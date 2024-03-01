{.emit: """

#define WIN32_LEAN_AND_MEAN
#include <Windows.h>
#include <stdio.h>
#include <winternl.h> // For NTSTATUS
#include <process.h> // For CRT atexit functions
#include <shellapi.h> // For ShellExecute
// These functions are exported from ntdll.dll but do not exist in the header files so we need to prototype and import them
// The functions could also be located at runtime with GetProcAddress
// Function signatures are sourced from ReactOS: https://doxygen.reactos.org
//EXTERN_C NTSTATUS NTAPI LdrUnlockLoaderLock(_In_ ULONG Flags, _In_opt_ ULONG Cookie);
//EXTERN_C NTSTATUS NTAPI LdrLockLoaderLock(_In_ ULONG Flags, _Out_opt_ PULONG Disposition, _Out_opt_ PULONG_PTR Cookie);
//EXTERN_C NTSYSAPI void DECLSPEC_NORETURN WINAPI RtlExitUserProcess(NTSTATUS Status);
PCRITICAL_SECTION getLdrpLoaderLockAddress(LPVOID LdrAddress) {
    // GetModuleHandle to retrieve the ntdll.dll address
	HMODULE ntdll = GetModuleHandle(L"ntdll.dll");
	
	// GetProcAddress to retrieve the address of LdrUnlockLoaderLock
	LPVOID MyLdrUnlockLoaderLock = GetProcAddress(ntdll, "LdrUnlockLoaderLock");
    
    PBYTE ldrUnlockLoaderLockSearchCounter = (PBYTE)LdrAddress;
    const BYTE callAddressOpcode = 0xe8;
    const BYTE callAddressInstructionSize = sizeof(callAddressOpcode) + sizeof(INT32);
    const BYTE jmpAddressRelativeOpcode = 0xeb;
    // Search for this pattern (occurs twice in LdrUnlockLoaderLock and exists in other NTDLL functions so it seems unlikely to change):
    // 00007ffc`94a0df03 e84c07fcff           call    ntdll!LdrpReleaseLoaderLock (7ffc949ce654)
    // 00007ffc`94a0df08 ebaf                 jmp     ntdll!LdrUnlockLoaderLock+0x19 (7ffc94a0deb9)
    while (TRUE) {
        if (*ldrUnlockLoaderLockSearchCounter == callAddressOpcode) {
            // If there is a jmp address instruction directly below this one
            // This is for extra validation, if we are unlucky with the specific NTDLL build or ASLR then an addresses could contain the call opcode byte
            if (*(ldrUnlockLoaderLockSearchCounter + callAddressInstructionSize) == jmpAddressRelativeOpcode)
            {
                // print address found with address
                break;
            }
        }
        ldrUnlockLoaderLockSearchCounter++;
        
    }
    // Get address following call opcode
    INT32 rel32EncodedAddress = *(PINT32)(ldrUnlockLoaderLockSearchCounter + sizeof(callAddressOpcode));
    // print rel32EncodedAddress
    // Reverse engineering Native API function: LdrpReleaseLoaderLock
    // First argument: For output only, it returns a pointer (pointing to USER_SHARED_DATA, a read-only section used by the kernel) to a byte
    //   - The value of this byte should be zero under normal circumstances, otherwise the code jumps to some error-handling (the program may recover and jump back to the LdrpReleaseLoaderLock code or terminate)
    // Second argument: Unused (Exists in API for compatibility with previous/different Windows version? Reserved for future use?)
    // Third argument: Jump to error-handling code if it's a negative value
    // Return value: Passed through return value from ntdll!RtlLeaveCriticalSection (this is the function that actually unlocks the loader which makes sense)
    //   - ntdll!RtlLeaveCriticalSection takes one argument (the critical section, ntdll!LdrpLoaderLock in our case): https://doxygen.reactos.org/d0/d06/critical_8c_source.html
    //
    // Prototype function
    typedef INT32(NTAPI* LdrpReleaseLoaderLockType)(OUT PBYTE, INT32, INT32);
    // Get full address to LdrpReleaseLoaderLock function
    LdrpReleaseLoaderLockType LdrpReleaseLoaderLock = (LdrpReleaseLoaderLockType)(ldrUnlockLoaderLockSearchCounter + callAddressInstructionSize + rel32EncodedAddress);
    // Release loader lock
    // This is old code for calling LdrpReleaseLoaderLock to unlock ntdll!LdrpLoaderLock
    // Instead, we now proceed to find the address of the ntdll!LdrpLoaderLock critical section so we can easily re-lock later
    //LdrpReleaseLoaderLock(NULL, 2, 0); // Pass in 2 as second argument because that's what Windows does for statically loaded DLLs at least
    PBYTE ldrpReleaseLoaderLockAddressSearchCounter = (PBYTE)LdrpReleaseLoaderLock;
    // lea cx/ecx/rcx (size left unspecified, e.g. prepending 0x48 to the opcode would make it specific to rcx)
    // This is so it works on both a 32-bit or 64-bit process
    // Swapped from 0x8d0d to be in little endian
    const USHORT leaCxRegisterOpcode = 0x0d8d;
    const BYTE leaCxRegisterOpcodeInstructionSize = sizeof(leaCxRegisterOpcode) + sizeof(INT32);
    // Search for this pattern:
    // 00007ff9`4e04e673 488d0d4e7f1200  lea     rcx,[ntdll!LdrpLoaderLock (00007ff9`4e1765c8)]
    
    while (TRUE) {
        if (*(PUSHORT)ldrpReleaseLoaderLockAddressSearchCounter == leaCxRegisterOpcode)
        {
            break;
        }
        ldrpReleaseLoaderLockAddressSearchCounter++;
    }
    // Get pointer to ntdll!LdrpLoaderLock critical section in the .DATA section of NTDLL
    rel32EncodedAddress = *(PINT32)(ldrpReleaseLoaderLockAddressSearchCounter + sizeof(leaCxRegisterOpcode));
    PCRITICAL_SECTION LdrpLoaderLock = (PCRITICAL_SECTION)(ldrpReleaseLoaderLockAddressSearchCounter + leaCxRegisterOpcodeInstructionSize + rel32EncodedAddress);
    // convert LdrpLoaderLock to widestring and print the address via OutputDebugStringW
    
    return LdrpLoaderLock;
}
VOID modifyLdrEvents(BOOL doSet, const HANDLE events[], const SIZE_T eventsSize) {
    // Set event handles used by Windows loader (they are always these handle IDs)
    // This is so we don't hang on WaitForSingleObject in the new thread (launched by ShellExecute) when it's loading more libraries
    // Check the state of these event handles in WinDbg with this command: !handle 0 8 Event
    // Signal and unsignal in reverse order to avoid ordering inversion issues
    if (!doSet) {
        for (SIZE_T i = 0; i < eventsSize; ++i)
            ResetEvent(events[i]);
    }
    else {
        for (SIZE_T i = eventsSize; i-- > 0;)
            SetEvent(events[i]);
    }
}
VOID preloadLibraries(VOID) {
    // These are all the libraries ShellExecute loads before launching a new thread
    // They must be manually loaded before calling ShellExecute because LdrpWorkInProgress must be set to TRUE for loading libraries on this thread but FALSE for loading libraries on the new thread
    // Otherwise, we get stuck looping infinitely (high CPU usage) in LdrpDrainWorkQueue and hang
    // It may just so happen that some of these libraries are loaded into your process, however, we need to ensure all of them are loaded
    // HOW TO: Collect a list of all the modules loaded by your API call(s) load by reading the "ModLoad" messages given at runtime by WinDbg
    LoadLibrary(L"SHCORE");
    LoadLibrary(L"msvcrt");
    LoadLibrary(L"combase");
    LoadLibrary(L"RPCRT4");
    LoadLibrary(L"bcryptPrimitives");
    LoadLibrary(L"shlwapi");
    LoadLibrary(L"windows.storage.dll"); // Need DLL extension for this one because it contains a dot in the name
    LoadLibrary(L"Wldp");
    LoadLibrary(L"advapi32");
    LoadLibrary(L"sechost");
    // A Windows update occurred and now we also need to load these DLLs or we will crash/deadlock during ShellExecute
    //
    // Not loading one of them could cause a very strange and difficult to diagnose crash on one of the ntdll!TppWorkerThread threads 99% of the time
    // Finally though, I got lucky with a clean deadlock on loading the kernel.appcore.dll library and noticed the issue (I should have been looking out for "ModLoad" messages in WinDbg the entire time)
    LoadLibrary(L"kernel.appcore.dll");
    LoadLibrary(L"uxtheme");
    LoadLibrary(L"PROPSYS");
    LoadLibrary(L"clbcatq");
    LoadLibrary(L"CFGMGR32");
    LoadLibrary(L"profapi");
    LoadLibrary(L"edputil");
    LoadLibrary(L"Windows.StateRepositoryPS.dll");
    LoadLibrary(L"urlmon");
    LoadLibrary(L"iertutil");
    LoadLibrary(L"srvcli");
    LoadLibrary(L"netutils");
    LoadLibrary(L"SspiCli");
    LoadLibrary(L"virtdisk");
    LoadLibrary(L"FLTLIB");
    LoadLibrary(L"wintypes");
    LoadLibrary(L"appresolver");
    LoadLibrary(L"Bcp47Langs");
    LoadLibrary(L"SLC");
    LoadLibrary(L"sppc");
    LoadLibrary(L"OneCoreCommonProxyStub");
    LoadLibrary(L"OneCoreUAPCommonProxyStub");
    LoadLibrary(L"wininet.dll");
    // Some nice bloatware we have here
    // It seems like we now have to load all libraries ShellExecute will eventually load (even on its newly spawned threads)
    // However, note that LdrFullUnlock with RUN_PAYLOAD_DIRECTLY_FROM_DLLMAIN undefined (i.e. calls CreateThread) still works perfectly fine without any "library preloading", which is interesting
    //
    // More research is required here. It would be good for someone to do a thorough analysis on the differences in control flows using code coverage instrumentation.
    // For example, the code paths taken when ShellExecute is run inside DllMain vs. outside DllMain. Then we could really get to the bottom of this!
}
PULONG64 getLdrpWorkInProgressAddress(LPVOID Rtl_exit_address) {
    // Find and return address of ntdll!LdrpWorkInProgres
    PBYTE rtlExitUserProcessAddressSearchCounter = (PBYTE)Rtl_exit_address;
    // call 0x41424344 (absolute for 32-bit program; relative for 64-bit program)
    const BYTE callAddressOpcode = 0xe8;
    const BYTE callAddressInstructionSize = sizeof(callAddressOpcode) + sizeof(INT32);
    // Search for this pattern:
    // 00007ffc`949ed9a3 e84c0f0000           call    ntdll!LdrpDrainWorkQueue(7ffc949ee8f4)
    // 00007ffc`949ed9a8 e8070dfeff           call    ntdll!LdrpAcquireLoaderLock(7ffc949ce6b4)
    while (TRUE) {
        if (*rtlExitUserProcessAddressSearchCounter == callAddressOpcode) {
            // If there is another call opcode directly below this one
            if (*(rtlExitUserProcessAddressSearchCounter + callAddressInstructionSize) == callAddressOpcode)
                break;
        }
        rtlExitUserProcessAddressSearchCounter++;
    }
    INT32 rel32EncodedAddress = *(PINT32)(rtlExitUserProcessAddressSearchCounter + sizeof(callAddressOpcode));
    PBYTE ldrpDrainWorkQueue = (PBYTE)(rtlExitUserProcessAddressSearchCounter + callAddressInstructionSize + rel32EncodedAddress);
    PBYTE ldrpDrainWorkQueueAddressSearchCounter = ldrpDrainWorkQueue;
    // mov dword ptr [0x41424344], 0x1
    // Swapped from 0xc705 to be in little endian
    const USHORT movDwordAddressValueOpcode = 0x05c7;
    const BYTE movDwordAddressValueInstructionSize = sizeof(movDwordAddressValueOpcode) + sizeof(INT32) + sizeof(INT32);
    // Search for this pattern:
    // 00007ffc`949ee97f c7055fca100001000000 mov     dword ptr [ntdll!LdrpWorkInProgress (7ffc94afb3e8)], 1
    while (TRUE) {
        if (*(PUSHORT)ldrpDrainWorkQueueAddressSearchCounter == movDwordAddressValueOpcode) {
            // If TRUE (1) is being moved into this address
            if (*(PBOOL)(ldrpDrainWorkQueueAddressSearchCounter + movDwordAddressValueInstructionSize - sizeof(INT32)) == TRUE)
                break;
        }
        ldrpDrainWorkQueueAddressSearchCounter++;
    }
    // Get pointer to ntdll!LdrpWorkInProgress boolean in the .DATA section of NTDLL
    rel32EncodedAddress = *(PINT32)(ldrpDrainWorkQueueAddressSearchCounter + sizeof(movDwordAddressValueOpcode));
    PULONG64 LdrpWorkInProgress = (PULONG64)(ldrpDrainWorkQueueAddressSearchCounter + movDwordAddressValueInstructionSize + rel32EncodedAddress);
    return LdrpWorkInProgress;
}
// List of all NTDLL loader events
// Confirmed in WinDbg with this command: sxe ld:ntdll; bp ntdll!NtCreateEvent
// This stops the debugger on the first instruction in NTDLL and breaks on event creation
// Look up the address returned in RCX after each NtCreateEvent to find its debug symbol name
// https://doxygen.reactos.org/d4/deb/ntoskrnl_2ex_2event_8c.html#a6fff8045fa5834e03707df042e7c7cde
//
// NOTE: These hex codes may change, they are simply created at process start in NTDLL with NtCreateEvent which decides on a handle ID value at run-time
// However, the algorithm being used for generating these handle ID values seems to deterministically generate these values
// To verify these handle IDs, simply look up the debug symbol names in WinDbg
// If this breaks, then we can always search assembly code to find the handle IDs (feel free to contribute this code)
#define LdrpInitCompleteEvent (HANDLE)0x4
#define LdrpLoadCompleteEvent (HANDLE)0x3c
#define LdrpWorkCompleteEvent (HANDLE)0x40
VOID doit(LPVOID payload, LPVOID LdrpLoaderLock_address, LPVOID RtlExit_address) {
    // Fully unlock the Windows library loader
    //
    // Initialization
    //
    const PCRITICAL_SECTION LdrpLoaderLock = getLdrpLoaderLockAddress(LdrpLoaderLock_address);
    const HANDLE events[] = { LdrpInitCompleteEvent, LdrpWorkCompleteEvent };
    const SIZE_T eventsCount = sizeof(events) / sizeof(events[0]);
    const PULONG64 LdrpWorkInProgress = getLdrpWorkInProgressAddress(RtlExit_address);
    //
    // Preparation
    //
    // This is so we can see in WinDbg that we are in the payload
    LeaveCriticalSection(LdrpLoaderLock);
    // Preparation steps past this point are necessary if you will be creating new threads
    // And other scenarios, generally I notice it's necessary whenever a payload indirectly calls: __delayLoadHelper2
    preloadLibraries();
    modifyLdrEvents(TRUE, events, eventsCount);
    // print modify success
    // This is so we don't hang in ntdll!ldrpDrainWorkQueue of the new thread (launched by ShellExecute) when it's loading more libraries
    // ntdll!LdrpWorkInProgress must be NON-ZERO while libraries are being loaded in the current thread (requires further research)
    // ntdll!LdrpWorkInProgress must be ZERO while libraries are loading in the newly spawned thread (requires further research)
    // For this reason, we must preload the libraries loaded by ShellExecute
    // Perform this operation atomically with InterlockedDecrement to maintain thread safety (I'm not sure this is necessary given that the NTDLL code isn't doing it but we will be even safer than Microsoft here)
    
    InterlockedDecrement64(LdrpWorkInProgress);
    // print interlocked 
    // 
    // Run our payload!
    //
#ifdef RUN_PAYLOAD_DIRECTLY_FROM_DLLMAIN
    // Libraries loaded by API call(s) must be preloaded
    // cast direct function pointer from payload address and call it. It takes an LPVOID parameter as input, but this can be an empty pointer
    ((VOID(*)())payload)();
    //payload();
#else
    DWORD payloadThreadId;
    HANDLE payloadThread = CreateThread(NULL, 0, (LPTHREAD_START_ROUTINE)payload, NULL, 0, &payloadThreadId);
    if (payloadThread)
        WaitForSingleObject(payloadThread, INFINITE);
    
#endif

    // give the payload some secconds before entering the critical section
    //Sleep(2000);
    //
    // Cleanup
    //
    // Must set ntdll!LdrpWorkInProgress back to NON-ZERO otherwise we crash/deadlock in NTDLL library loader code sometime after returning from DllMain
    // The crash/deadlock occurs to due to concurrent operations happening in other threads
    // The problem arises due to ntdll!TppWorkerThread threads by default (https://devblogs.microsoft.com/oldnewthing/20191115-00/?p=103102)
    InterlockedAdd64(LdrpWorkInProgress, 1);
    // Reset these events to how they were to be safe (although it doesn't appear to be necessary at least in our case)
    modifyLdrEvents(FALSE, events, eventsCount);
    // Reacquire loader lock to be safe (although it doesn't appear to be necessary at least in our case)
    // Don't use the ntdll!LdrLockLoaderLock function to do this because it has the side effect of increasing ntdll!LdrpLoaderLockAcquisitionCount which we probably don't want
        
    EnterCriticalSection(LdrpLoaderLock);
    // enter done
}
""".}

from winim import LPVOID

proc LdrFullUnlock*(payload: LPVOID, address: LPVOID, rtl_address: LPVOID): void
    {.importc: "doit", nodecl.}