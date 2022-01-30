# NimSyscallPacker / Loader

For some this might be self explanatory - but please don't upload the resulting payloads to VirusTotal or similar services. This will in the worst case lead to many signatures for the packed binaries and makes the tool useless. Use https://antiscan.me/ instead.

This Packer can be used to pack any C# Assembly, PE-File or Shellcode into a Nim binary. It will encrypt the target payload, build the corresponding Nim source code according to the given arguments and compiles it to an Nim binary.

In addition you'll need `nimble install nimcrypto docopt ptr_math strenc` plus `donut.exe` and `denim.exe` in the CWD depending on what you want to do.

Make sure you use an up to date Nim version. It works fine for me with Nim version 1.6.2.

```
NimSyscall_Loader v 1.1

Usage:
  NimSyscall_Loader --file=file_to_encrypt [--key=<key> --output=<output> --remoteprocess=<processnames> --csharp --noAMSI --noETW --sleep=<10> --shellcode --COMVARETW --remoteinject --unhook --reflective --obfuscate --hide --noArgs --pe --hellsgate --replace --self-delete --sandbox=<check1,check2>, --domain=<targetdomain>]
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
  --unhook    Unhook ntdll.dll before doing anything else for the current process
  --reflective    Set compiler flags, so that the Loader Nim binary can be reflectively loaded
  --obfuscate    Compile the Nim binary via Denim to make use of LLVM obfuscation (not possible in combination with --reflective)
  --hide    Compile with --app:gui flag, so that the console won't pop up
  --pe    Encrypt a PE to decrypt and run it on runtime as shellcode via donut
  --hellsgate    Execute shellcode via Hellsgate technique
  --replace    Replace common nim IOS's in the loader like the string 'nim'
  --sandbox Check1    Include Sandbox Checks of your choice into the loader
                      Domain -> Only execute if the target domain is == the --domain parameter's domain / If --domain is not set, it will only execute on non-domain joined systems
                      DomainJoined -> Only execute if the target is connected to ANY domain - you don't need to know the target's domain for this one
                      DiskSpace -> Only execute if c:\ disk space >= 200GB
                      MemorySpace -> Only execute if more than 4GB RAM available
  --domain targetdomain    Specify a domain for SandBox Evasion
  --self-delete    The loader deletes it's own executable on runtime (Credit to @byt3bl33d3r and @jonasLyk)
```


To pack Mimikatz for example with unhooking before execution and without patching AMSI use the following:

```
NimSyscall_Loader.exe --file=mimikatz.exe --unhook --noAMSI --pe
```

For the moment you cannot pass arguments to e.g. Mimikatz after loading it because I'm using shellcode injection here. I'll update the tool to support PE-Loading via another method so that is possible. As a workaround you cann directly pass parameters to it via the commandline e.g.:

```
Packedmimikatz.exe coffee exit
```


To pack Shellcode for local injection:

```
NimSyscall_Loader.exe --file=shellcode.bin --noAMSI
```

To load shellcode into a remote process:

```
NimSyscall_Loader.exe --file=shellcode.bin --noAMSI --remoteprocess=teams.exe
```

To load a C# assembly:
```
NimSyscall_Loader.exe --file=Seatbelt.exe --csharp
```

To load a C# assembly and use hellsgate for Syscall retrieval :
```
NimSyscall_Loader.exe --file=Seatbelt.exe --csharp --hellsgate
```

To pack Shellcode for local injection + hellsgate usage + self-delete + sandbox checks:

```
NimSyscall_Loader.exe --file=beacon.bin --hellsgate --self-delete --sandbox=DomainJoined,MemorySpace
```
