# NimSyscallPacker / Loader

For some this might be self explanatory - but please don't upload the resulting payloads to VirusTotal or similar services. This will in the worst case lead to many signatures for the packed binaries and makes the tool useless. Use https://antiscan.me/ instead.

This Packer can be used to pack any C# Assembly, PE-File or Shellcode into a Nim binary. It will encrypt the target payload, build the corresponding Nim source code according to the given arguments and compiles it to an Nim binary.


### Setup

A Video - if you prefer that - can be found here:
[https://youtu.be/0PwIn3Nxmgo](https://youtu.be/0PwIn3Nxmgo)

#### Windows

Download and install [Nim 1.6.2](https://nim-lang.org/download/nim-1.6.2_x64.zip) and [Mingw64](https://sourceforge.net/projects/mingw-w64/files/) version 8.1.0 `x86_64-posix-seh`. You can either just use this GCC version or in addition install [GCC 12.1.0](https://sourceforge.net/projects/gcc-win64/files/12.1.0/). Don't use other GCC versions, as that breaks some functionality. But you need to place the Mingw64 DLL's around `libwinpthread-1.dll` into some `%PATH%` environment variable folder. Login/logout for the `%PATH%` changes to take effect.

Install dependencies:
`nimble install nimcrypto docopt ptr_math strenc winim`

`denim.exe` needs to be in the CWD if you want to use LLVM obfuscator. It can be found [here]([denim](https://github.com/moloch--/denim)). Install it via `denim setup`.

Compile the Packer via `nim c NimSyscallLoader.nim`. Ready to go.

#### Linux

E.g. on Kali:

`apt-get install nim=1.6.2`

`apt-get install mingw-64=8.0.0-1`

`nimble install nimcrypto docopt ptr_math strenc winim`

If you cannot downgrade mingw-64 to 8.0.0-1 `--hellsgate` won't work.

Install donut via `pip3 install donut-shellcode`. `denim` cannot be used from Unix so obfuscation via LLVM is not possible here. Same for Callobfuscator.

Compile the Packer via `nim c NimSyscallLoader.nim`. Ready to go.



### Usage

A Video - if you prefer that - can be found here:
[https://youtu.be/UHaIgdzqHDA](https://youtu.be/UHaIgdzqHDA)

```
NimSyscall_Loader v 1.5

Usage:
  NimSyscall_Loader --file=file_to_encrypt [--key=<key> --output=<output> --dll --dllexportfunc=<exportfuncname> --remoteprocess=<processnames> --csharp --noAMSI --noETW --sleep=<10> --shellcode --COMVARETW --remoteinject --remotepatchAMSI --remotepatchETW --unhook --reflective --obfuscate --hide --noArgs --peinject --peload --hellsgate --syswhispers --jump --sgn --replace --self-delete --sandbox=<check1,check2>, --domain=<targetdomain> --pump=<words,size> --obfuscatefunctions --debug --x86 --llvm]
  NimSyscall_Loader (-h | --help)
  NimSyscall_Loader --version

Options:
  -h --help     Show this screen.
  --version     Show version.
  --file filename  File to encrypt.
  --key key     Key to encrypt with
  --output filename    Filename for encrypted exe/dll
  --dll     Generate DLL instead of an exe
  --dllexportfunc exportfuncname    Comma separated names of DLL custom export functions
  --COMVARETW    Block ETW by setting COMPlus_ETWEnabled to 0
  --noETW    Don't use ETW Patch
  --noAMSI    Don't patch AMSI
  --csharp    Encrypt a C# Assembly to load it on runtime
  --noArgs    Don't provide any arguments to the assembly (some can only run without args)
  --shellcode    Encrypt shellcode to load it on runtime
  --sleep 10    Sleep 10 seconds before decryption to evade in memory scanners
  --remoteinject    Inject shellcode a newly spawned process (default notepad) / otherwise it's self injection
  --remoteprocess procname    Injects into the specified remote process name, e.g. teams.exe. The loader searches for the first process with that name
                     Can be used for multiple process names, e.g. --remoteprocess=teams.exe,iexplore.exe,MicrosoftEdge.exe -> First try teams, else Internet Explorer, last Edge
  --remotepatchAMSI    Patch AMSI in the remote process before shellcode execution
  --remotepatchETW    Patch ETW in the remote process before shellcode execution
  --unhook    Unhook ntdll.dll before doing anything else for the current process
  --reflective    Set compiler flags, so that the Loader Nim binary can be reflectively loaded
  --obfuscate    Compile the Nim binary via Denim to make use of LLVM obfuscation (not possible in combination with --reflective)
  --hide    Compile with --app:gui flag, so that the console won't pop up
  --peinject    Encrypt a PE to decrypt and run it on runtime as shellcode via donut
  --peload    Encrypt a PE to decrypt it on runtime and execute it via a syscall variant of Run-PE
  --hellsgate    Retrieve Syscalls via Hellsgate technique (for patching AMSI/ETW or shellcode execution/PE injection)
  --syswhispers    Embed Syscalls via Syswhispers3 (NimLineWhispers3) technique
  --jump    When using Syswhispers3, use the jumper_randomized technique
  --sgn    Encode shellcode via SGN before encrypting it
  --replace    Replace common nim IoC's in the loader like the string 'nim'
  --sandbox value    Include Sandbox Checks of your choice into the loader:
                     Domain -> Only execute if the target domain is == the --domain parameter's domain / If --domain is not set, it will only execute on non-domain joined systems
                     DomainJoined -> Only execute if the target is connected to ANY domain - you don't need to know the target's domain for this one
                     DiskSpace -> Only execute if c:\ disk space >= 200GB
                     MemorySpace -> Only execute if more than 4GB RAM available
  --pump value    Pump the file with:
                  words -> english dictionary words to increase the reputation for "mashine learning" evasion (https://twitter.com/hardwaterhacker/status/1502425183331799043)
                  reputation -> Pump reputation with strings from well known binaries e.g. Chrome,Cortana,Discord and some others
  --domain targetdomain    Specify a domain for SandBox Evasion
  --self-delete    The loader deletes it's own executable on runtime (Credit to @byt3bl33d3r and @jonasLyk)
  --obfuscatefunctions    Obfuscate some Nim specific Windows API's from the IAT via CallObfuscator (https://github.com/d35ha/CallObfuscator - only possible from a Windows OS)
  --debug    Compiles the binary in debug mode (More DInvoke output)
  --x86    (Compiles an x86 binary - have to cast some more function values before this works smoothly)
  --llvm    Add compiler flags for LLVM obfuscation, you have to set it up by yourself
```


To pack Mimikatz for example with unhooking before execution and without patching AMSI use the following:

```
NimSyscallLoader --file=mimikatz.exe --unhook --noAMSI --peinject
```

Some of you had problems loading Mimikatz with the packer via "--file=Mimikatz --pe" arguments to afterwards issue custom commands on runtime.

I found the reason for this behaviour. Don't ask me why but you cannot just take the release from Github but have to compile Mimikatz on your own (or build a custom version) and load this instead of the official release.

If you still want to embed the release version from github you can directly pass arguments like this:

```
Packedmimikatz.exe coffee exit
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

To generate an DLL as output instead of an executable just add the `--dll` parameter. You can also define custom export functions via `--dllexportfunc Export1,ExportFunc2`

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

## TO-DO
- [x] PELoader via syscalls
- [x] Hellsgate support
- [X] Load only the needed Winim libraries
- [x] Remote process AMSI/ETW Patching based on [SnD_AMSI](https://github.com/whydee86/SnD_AMSI)
- [X] Use Syscalls for remote patching
- [X] Remotely load the "to patch" DLL (ntdll or amsi.dll) into the remote process before patching (otherwise it won't help us)
- [x] Hellsgate support for remote shellcode injection + PELoading
- [X] DLL output
- [ ] DLL Sideloading capabilities
- [ ] C# and/or Powershell output files
- [X] More syscalls and or D/Invoke for win32 functions
- [X] Cobalt Strike integration - CNA
- [ ] Passing parameters via e.g. manipulation of the PEB field (Command line spoofing like)
- [ ] Shellcode memory encryption via Sleep Hook [ShellcodeFluctuation like](https://github.com/mgeeky/ShellcodeFluctuation)

## CREDITS

- [X] [@WhyDee86](https://twitter.com/WhyDee86) - Sleep function + remote process Library module
- [X] [@chvancooten](https://twitter.com/chvancooten) - Custom strenc + Inspiration from his Nim Packer
- [X] [@lefayjey](https://github.com/lefayjey) - DLL Output + CNA Script contribution
- [X] [@d35ha](https://github.com/d35ha/CallObfuscator) - CallObfuscator
- [X] [@klezVirus](https://github.com/klezVirus/NimlineWhispers3) - NimlineWhispers3
- [X] [@TheWover](https://github.com/TheWover/donut) - Donut 
- [X] [@icyguider](https://github.com/icyguider) - Inspiration 
