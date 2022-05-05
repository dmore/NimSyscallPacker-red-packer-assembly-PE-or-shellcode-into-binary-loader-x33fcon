from winim/lean import ULONG, PVOID, SIZE_T, PSIZE_T, DWORD_PTR,LPDWORD,WINBOOL,TRUE,FALSE,HMODULE,LPOVERLAPPED, PIMAGE_SECTION_HEADER, LPCSTR, LPVOID, HANDLE, DWORD, GENERIC_READ, FILE_SHARE_READ, LPSECURITY_ATTRIBUTES, NULL, OPEN_EXISTING, FILE_ATTRIBUTE_NORMAL, PIMAGE_DOS_HEADER, PIMAGE_NT_HEADERS, IMAGE_DIRECTORY_ENTRY_EXPORT, IMAGE_FIRST_SECTION, IMAGE_SIZEOF_SECTION_HEADER, PIMAGE_EXPORT_DIRECTORY, PDWORD, BOOL, PULONG, NTSTATUS, PROCESS_ALL_ACCESS, FALSE, MEM_COMMIT, PAGE_EXECUTE_READ_WRITE, PAGE_READWRITE, CLIENT_ID, OBJECT_ATTRIBUTES
from winim import PWCHAR,PUNICODE_STRING,UNICODE_STRING,PHANDLE,LIST_ENTRY,UCHAR,BYTE,P_PEB,LPWSTR,IMAGE_NT_SIGNATURE,USHORT,IMAGE_FILE_DLL,lstrcmpiW,LPWSTR,PWSTR,RtlInitUnicodeString,ULONG_PTR,MAX_PATH,wchar_t,IMAGE_DATA_DIRECTORY,PCHAR,StrRStrIA
import winim/utils
import winim/winstr
import tables
import strformat
import algorithm

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

when defined(WIN64):
  const
    PEB_OFFSET* = 0x30
else:
  const
    PEB_OFFSET* = 0x60


const
  LdrLoadDll_SW2_HASH * = 4028654593
  MZ* = 0x5A4D

const
  NTDLL_DLL* = "ntdll.dll"
  KERNEL32_DLL* = "kernel32.dll"

type
  LdrLoadDll_t* = proc (PathToFile: PWCHAR, Flags: ULONG, ModuleFileName: PUNICODE_STRING, ModuleHandle: PHANDLE): NTSTATUS {.stdcall.}
  # typedef NTSTATUS(WINAPI LdrLoadDll_t)(PWCHAR, ULONG, PUNICODE_STRING, PHANDLE);

type
  ND_LDR_DATA_TABLE_ENTRY* {.bycopy.} = object
    InMemoryOrderLinks*: LIST_ENTRY ## struct _LIST_ENTRY InLoadOrderLinks;
    InInitializationOrderLinks*: LIST_ENTRY
    DllBase*: PVOID
    EntryPoint*: PVOID
    SizeOfImage*: ULONG
    FullDllName*: UNICODE_STRING
    BaseDllName*: UNICODE_STRING

  PND_LDR_DATA_TABLE_ENTRY* = ptr ND_LDR_DATA_TABLE_ENTRY
  ND_PEB_LDR_DATA* {.bycopy.} = object
    Length*: ULONG
    Initialized*: UCHAR
    SsHandle*: PVOID
    InLoadOrderModuleList*: LIST_ENTRY
    InMemoryOrderModuleList*: LIST_ENTRY
    InInitializationOrderModuleList*: LIST_ENTRY

  PND_PEB_LDR_DATA* = ptr ND_PEB_LDR_DATA
  ND_PEB* {.bycopy.} = object
    Reserved1*: array[2, BYTE]
    BeingDebugged*: BYTE
    Reserved2*: array[1, BYTE]
    Reserved3*: array[2, PVOID]
    Ldr*: PND_PEB_LDR_DATA

  PND_PEB* = ptr ND_PEB


proc GetPPEB(p: culong): P_PEB {. 
    header: 
        """#include <windows.h>
           #include <winnt.h>""", 
    importc: "__readgsqword"
.}


const
    seed = 0xC0DE1337

template ROR8(v: int64): int64 =
  ((v shr 8 and 4294967295) or (v shl 24 and 4294967295))

proc getHash(funcname: cstring): int64 =
    var hash = seed
    for letter in funcname:
        hash = hash xor int64(letter) + ROR8(hash)
    return hash


template RVA*(atype: untyped, base_addr: untyped, rva: untyped): untyped = cast[atype](cast[ULONG_PTR](cast[ULONG_PTR](base_addr) + cast[ULONG_PTR](rva)))

template RVASub*(atype: untyped, base_addr: untyped, rva: untyped): untyped = cast[atype](cast[ULONG_PTR](cast[ULONG_PTR](base_addr) - cast[ULONG_PTR](rva)))

template RVA2VA(casttype, dllbase, rva: untyped): untyped =
  cast[casttype](cast[ULONG_PTR](dllbase) + rva)

proc `+`[T](a: ptr T, b: int): ptr T =
    cast[ptr T](cast[uint](a) + cast[uint](b * a[].sizeof))

proc `-`[T](a: ptr T, b: int): ptr T =
    cast[ptr T](cast[uint](a) - cast[uint](b * a[].sizeof))

# A pointer cannot be used with "+" in Nim, therefore its 
template PointerAdd*(atype: untyped, first: untyped, seccond: untyped): untyped = cast[atype](cast[uint](first) + cast[uint](seccond))

# A pointer cannot be used with "-" in Nim, therefore its 
template PointerSubstract*(atype: untyped, first: untyped, seccond: untyped): untyped = cast[atype](cast[int](first) - cast[int](seccond))

### Alternative for PEB x64 only

#[

type
  LDR_DATA_TABLE_ENTRY* {.bycopy.} = object
    InLoadOrderModuleList*: LIST_ENTRY
    InMemoryOrderModuleList*: LIST_ENTRY
    InInitializationOrderModuleList*: LIST_ENTRY
    DllBase*: PVOID
    EntryPoint*: PVOID
    SizeOfImage*: ULONG        ##  in bytes
    FullDllName*: UNICODE_STRING
    BaseDllName*: UNICODE_STRING
    Flags*: ULONG              ##  LDR_*
    LoadCount*: USHORT
    TlsIndex*: USHORT
    HashLinks*: LIST_ENTRY
    SectionPointer*: PVOID
    CheckSum*: ULONG
    TimeDateStamp*: ULONG ##     PVOID			LoadedImports;					// seems they are exist only on XP !!!
                        ##     PVOID			EntryPointActivationContext;	// -same-
  PLDR_DATA_TABLE_ENTRY* = ptr LDR_DATA_TABLE_ENTRY

  PEB_LDR_DATA* {.bycopy.} = object
    Length*: ULONG
    Initialized*: BOOLEAN
    SsHandle*: PVOID
    InLoadOrderModuleList*: LIST_ENTRY
    InMemoryOrderModuleList*: LIST_ENTRY
    InInitializationOrderModuleList*: LIST_ENTRY

  PPEB_LDR_DATA* = ptr PEB_LDR_DATA

  RTL_DRIVE_LETTER_CURDIR* {.bycopy.} = object
    Flags*: USHORT
    Length*: USHORT
    TimeStamp*: ULONG
    DosPath*: UNICODE_STRING

  RTL_USER_PROCESS_PARAMETERS* {.bycopy.} = object
    MaximumLength*: ULONG
    Length*: ULONG
    Flags*: ULONG
    DebugFlags*: ULONG
    ConsoleHandle*: PVOID
    ConsoleFlags*: ULONG
    StdInputHandle*: HANDLE
    StdOutputHandle*: HANDLE
    StdErrorHandle*: HANDLE
    CurrentDirectoryPath*: UNICODE_STRING
    CurrentDirectoryHandle*: HANDLE
    DllPath*: UNICODE_STRING
    ImagePathName*: UNICODE_STRING
    CommandLine*: UNICODE_STRING
    Environment*: PVOID
    StartingPositionLeft*: ULONG
    StartingPositionTop*: ULONG
    Width*: ULONG
    Height*: ULONG
    CharWidth*: ULONG
    CharHeight*: ULONG
    ConsoleTextAttributes*: ULONG
    WindowFlags*: ULONG
    ShowWindowFlags*: ULONG
    WindowTitle*: UNICODE_STRING
    DesktopName*: UNICODE_STRING
    ShellInfo*: UNICODE_STRING
    RuntimeData*: UNICODE_STRING
    DLCurrentDirectory*: array[0x20, RTL_DRIVE_LETTER_CURDIR]

  PEB* {.bycopy.} = object
    InheritedAddressSpace*: BOOLEAN
    ReadImageFileExecOptions*: BOOLEAN
    BeingDebugged*: BOOLEAN
    Spare*: BOOLEAN
    Mutant*: HANDLE
    ImageBaseAddress*: PVOID
    Ldr*: PPEB_LDR_DATA
    ProcessParameters*: PRTL_USER_PROCESS_PARAMETERS
    SubSystemData*: PVOID
    ProcessHeap*: PVOID
    FastPebLock*: PVOID
    FastPebLockRoutine*: PVOID
    FastPebUnlockRoutine*: PVOID
    EnvironmentUpdateCount*: ULONG
    KernelCallbackTable*: PVOID
    EventLogSection*: PVOID
    EventLog*: PVOID
    FreeList*: PVOID
    TlsExpansionCounter*: ULONG
    TlsBitmap*: PVOID
    TlsBitmapBits*: array[0x2, ULONG]
    ReadOnlySharedMemoryBase*: PVOID
    ReadOnlySharedMemoryHeap*: PVOID
    ReadOnlyStaticServerData*: PVOID
    AnsiCodePageData*: PVOID
    OemCodePageData*: PVOID
    UnicodeCaseTableData*: PVOID
    NumberOfProcessors*: ULONG
    NtGlobalFlag*: ULONG
    Spare2*: array[0x4, BYTE]
    CriticalSectionTimeout*: LARGE_INTEGER
    HeapSegmentReserve*: ULONG
    HeapSegmentCommit*: ULONG
    HeapDeCommitTotalFreeThreshold*: ULONG
    HeapDeCommitFreeBlockThreshold*: ULONG
    NumberOfHeaps*: ULONG
    MaximumNumberOfHeaps*: ULONG
    ProcessHeaps*: ptr PVOID
    GdiSharedHandleTable*: PVOID
    ProcessStarterHelper*: PVOID
    GdiDCAttributeList*: PVOID
    LoaderLock*: PVOID
    OSMajorVersion*: ULONG
    OSMinorVersion*: ULONG
    OSBuildNumber*: ULONG
    OSPlatformId*: ULONG
    ImageSubSystem*: ULONG
    ImageSubSystemMajorVersion*: ULONG
    ImageSubSystemMinorVersion*: ULONG
    GdiHandleBuffer*: array[0x22, ULONG]
    PostProcessInitRoutine*: ULONG
    TlsExpansionBitmap*: ULONG
    TlsExpansionBitmapBits*: array[0x80, BYTE]
    SessionId*: ULONG

  PPEB* = ptr PEB

{.passC:"-masm=intel".}

proc GetPEB*(): PPEB {.asmNoStackFrame.} =
    # GetPEBAsm64 proc
    asm """
        push rbx
        xor rbx,rbx
        xor rax,rax
        mov rbx, qword ptr gs:[0x30]
        mov rax, rbx
        pop rbx
        ret
    """
    # GetPEBAsm64 endp
]#
## Alternative end

proc is_dll*(hLibrary: PVOID): BOOL
proc get_library_address*(LibName: LPWSTR; DoLoad: BOOL): HANDLE
proc resolve_reference*(hOriginalLibrary: HMODULE; functionAddress: PVOID): PVOID
proc get_function_address*(hLibrary: HMODULE; fhash: int64; ordinal: int, specialCase: BOOL): PVOID
proc find_legacy_export*(hOriginalLibrary: HMODULE; fhash: DWORD): PVOID

proc is_dll*(hLibrary: PVOID): BOOL =
  #echo "IS_DLL start"
  var dosHeader: PIMAGE_DOS_HEADER
  var ntHeader: PIMAGE_NT_HEADERS
  if (hLibrary == nil):
    when not defined(release):
        echo "[-] hLibrary == 0, exiting"
    return FALSE
  dosHeader = cast[PIMAGE_DOS_HEADER](hLibrary)
  #echo "Got dos Header"
  ##  check the MZ magic bytes
  if dosHeader.e_magic != MZ:
    when not defined(release):
        echo "[-] No Magic bytes found"
    return FALSE
  #nt = RVA(PIMAGE_NT_HEADERS, hLibrary, dosHeader.e_lfanew)
  ntHeader = cast[PIMAGE_NT_HEADERS](cast[DWORD_PTR](hLibrary) + dosHeader.e_lfanew)
  #echo "Got NT Headers"
  ##  check the NT_HEADER signature
  if ntHeader.Signature != IMAGE_NT_SIGNATURE:
    when not defined(release):
        echo "[-] Nt Header signature wrong, exiting"
    return FALSE
  var Characteristics: USHORT = ntHeader.FileHeader.Characteristics
  if (Characteristics and IMAGE_FILE_DLL) != IMAGE_FILE_DLL:
    when not defined(release):
        echo "[-] Characteristics shows this is not an DLL, exiting"
    return FALSE
  #echo "Everything fine, this is indeed a DLL"
  return TRUE


##
##  Get the base address of a DLL
##

proc LdrLoadDll(PathToFile: PWCHAR, Flags: ULONG, ModuleFileName: PUNICODE_STRING, ModuleHandle: PHANDLE): NTSTATUS {.stdcall, dynlib: "ntdll", importc.}


proc get_library_address*(LibName: LPWSTR; DoLoad: BOOL): HANDLE =
  when not defined(release):
      echo "\r\n[*] Parsing the PEB to search for the target DLL\r\n"
  var Peb: PPEB = GetPPEB(PEB_OFFSET)
  var Ldr = Peb.Ldr
  var FirstEntry: PVOID = addr(Ldr.InMemoryOrderModuleList.Flink)
  var Entry: PND_LDR_DATA_TABLE_ENTRY = cast[PND_LDR_DATA_TABLE_ENTRY](Ldr.InMemoryOrderModuleList.Flink)
  while true:
    # lstrcmpiW is not case sensitive, lstrcmpW is case sensitive
    var compare: int = lstrcmpiW(LibName,cast[LPWSTR](Entry.BaseDllName.Buffer))
    if(compare == 0):
      #echo "DLL names equal"
      when not defined(release):
          echo "\r\n[+] Found the DLL!\r\n"
      return cast[HANDLE](Entry.DllBase)
    Entry = cast[PND_LDR_DATA_TABLE_ENTRY](Entry.InMemoryOrderLinks.Flink)
    if not (Entry != FirstEntry):
      when not defined(release):
          echo "DLL not found for the current proc, loading."
      break
  if (DoLoad == FALSE):
    when not defined(release): echo "Exit, loading is not appreciated"
    return 0
  
  var MyLdrLoadDll: LdrLoadDll_t = cast[LdrLoadDll_t](cast[LPVOID](get_function_address(cast[HMODULE](get_library_address(NTDLL_DLL, FALSE)), LdrLoadDll_SW2_HASH, 0, TRUE)))
  
  if MyLdrLoadDll == nil:
    when not defined(release): echo "[-] Address of LdrLoadDll not found"
    return 0

  var ModuleFileName: UNICODE_STRING
  
  var hLibrary: HANDLE = 0
  
  RtlInitUnicodeString(&ModuleFileName, LibName)
  #echo fmt"Copyied {LibName} into {ModuleFileName} "
  #echo "Error after:", $GetLastError()
  
  ##  load the library
  var status: NTSTATUS = MyLdrLoadDll(nil, 0, &ModuleFileName, &hLibrary)
  
  if (status != 0):
    when not defined(release): echo fmt"[-] Failed to load {Libname}, status: {status}\n"
    if (hLibrary == 0):
        when not defined(release): echo "HLibrary still null"
    return 0
  else:
    when not defined(release): echo fmt"Loaded {LibName} successfully!"
  when not defined(release): echo fmt"[+] Loaded {LibName} at {hLibrary}"
  return hLibrary

##
##  Follow the reference and return the real address of the function
##

#proc charseqtoString(bytes: seq[char]): string =
#  result = newString(bytes.len)
#  copyMem(result[0].addr, bytes[0].unsafeAddr, bytes.len)

# This will not work yet, did not do any tests for this function yet!
proc resolve_reference*(hOriginalLibrary: HMODULE; functionAddress: PVOID): PVOID =
  var hLibrary: HANDLE
  var new_addr: PVOID
  var api: LPCSTR
  ##  addr points to a string like: NewLibrary.NewFunctionName
  
  # strrchr cannot be found, search for alternatives
  #api = addr(strrchr(functionAddress, '.')[1])

  # For the moment we will just print the actual value and take it
  #echo repr(functionAddress)
  api = cast[LPCSTR](unsafeAddr functionAddress)
  #echo api
  var dll_length: DWORD = cast[DWORD](cast[ULONG_PTR](api) - cast[ULONG_PTR](functionAddress))
  var length = MAX_PATH + 1
  var dll: seq[char] # this looked the following before var dll: array[MAX_PATH + 1, char]
  #old
  #strncpy(dll, cast[LPCSTR](functionAddress), dll_length)
  copyMem(dll[0].addr, cast[LPCSTR](functionAddress), dll_length)
  #old
  #strncat(dll, "dll", MAX_PATH)
  dll.add("dll")

  var wc_dll: seq[wchar_t] # this looked the following before - array[MAX_PATH, wchar_t] = [0]
  #old
  #mbstowcs(wc_dll, dll, MAX_PATH)
  copyMem(wc_dll[0].addr,dll[0].addr,MAX_PATH)
  #var dllString = charseqtoString(dll)
  #wc_dll.add(dllString)
  
  ##  try to find the library NewLibrary
  hLibrary = get_library_address(cast[LPWSTR](wc_dll), FALSE)
  if (cast[PVOID](hLibrary) == nil):
    ##  the library is not loaded, meaning it is a legacy DLL
    new_addr = find_legacy_export(hOriginalLibrary, cast[DWORD](getHash(api)))
    return new_addr
  new_addr = get_function_address(hLibrary, cast[DWORD](getHash(api)), 0, FALSE)
  return new_addr

##
##  Find an export in a DLL
##

proc get_function_address*(hLibrary: HMODULE; fhash: int64; ordinal: int, specialCase: BOOL): PVOID =
  var dos: PIMAGE_DOS_HEADER
  var nt: PIMAGE_NT_HEADERS
  #var data: PIMAGE_DATA_DIRECTORY
  var data: array[0..15, IMAGE_DATA_DIRECTORY]
  var exp: PIMAGE_EXPORT_DIRECTORY
  var exp_size: DWORD
  var adr: PDWORD
  var ord: PDWORD
  var functionAddress: PVOID
  var toCheckLibrary: PVOID = cast[PVOID](hLibrary)
  if (is_dll(toCheckLibrary) == FALSE):
    when not defined(release): echo "[-] Exiting, not a DLL"
    return nil
  dos = cast[PIMAGE_DOS_HEADER](hLibrary)
  nt = RVA(PIMAGE_NT_HEADERS, cast[PVOID](hLibrary), dos.e_lfanew)
  
  data = nt.OptionalHeader.DataDirectory
  
  if (data[0].Size == 0 or data[0].VirtualAddress == 0):
    when not defined(release): echo "[-] Data size == 0 or no VirtualAddress"
    return nil
  exp = RVA(PIMAGE_EXPORT_DIRECTORY, hLibrary, data[IMAGE_DIRECTORY_ENTRY_EXPORT].VirtualAddress)
  exp_size = data[0].Size

  adr = RVA2VA(PDWORD, cast[DWORD_PTR](hLibrary), exp.AddressOfFunctions)
  ord = RVA2VA(PDWORD, cast[DWORD_PTR](hLibrary), exp.AddressOfNameOrdinals)
  
  functionAddress = nil

  var numofnames = cast[DWORD](exp.NumberOfNames)
  var functions = RVA2VA(PDWORD, cast[PVOID](hLibrary), exp.AddressOfFunctions)
  var ordinalbase: DWORD = exp.AddressOfFunctions + 0x10
  var ordinalsRVA: DWORD = exp.AddressOfFunctions + 0x24
  var addressOfFunctionsvalue = RVA2VA(PDWORD, cast[PVOID](hLibrary), exp.AddressOfFunctions)[]
  var names = RVA2VA(PDWORD, cast[PVOID](hLibrary), exp.AddressOfNames)[]

  when not defined(release): echo "\r\n[*] Checking DLL's Export Directory for the target function\r\n"

  if fhash != 0:
    ##  iterate over all the exports
    var i: DWORD = 0

    for i in 0 .. numofnames:
      # Getting the function name value
      var funcname = RVA2VA(PCHAR, cast[PVOID](hLibrary), names)
      #echo funcname

      var finalfunctionAddress = RVA(PVOID, cast[PVOID](hLibrary), addressOfFunctionsvalue)
      
      # We are comparing against function names, which include "." because for some reason all function names in this loop also contain references to other DLLs, e.g. "api-ms-win-core-libraryloader-l1-1-0.AddDllDirectory" in kernel32.dll
      var test = StrRStrIA(cast[LPCSTR](funcname),nil,cast[LPCSTR]("."))

      if test != nil:
        # As we found a trash (indirect reference, normally this is in the address field and not in the names field) function, we have to increase this value -> Not an official function
        numofnames = numofnames + 1
      else:
        functions = functions + 1
        addressOfFunctionsvalue = functions[]
      #when not defined(release): echo "Relative Address: ", toHex(functions[])
      names += cast[DWORD](len(funcname) + 1)
      #when not defined(release): echo "Function: ", funcname
      if fhash == getHash(funcname):
        
        # So many edge cases, maybe also due to the not REAL Hash and colissions?
        if (funcname == obf("CreateFileW")):
          functions = functions - 1
        if (funcname == obf("SetFileInformationByHandle")):
          functions = functions - 1
        if (funcname == obf("CloseHandle")):
          functions = functions - 1
        if (funcname == obf("GetModuleFileNameW")):
          functions = functions - 1

        when not defined(release): echo "\r\n[+] Found API call: ",funcname
        when not defined(release): echo "\r\n"
        
        # GetFileInformationByHandle and SetFileInformationByHandle produce the same Hash -.- Have to change the algorithm.
        if (funcname != obf("GetFileInformationByHandle")):
          # Strange. For ntdll functions the following is needed, but for kernel32 functions it's not. Don't ask me why. This is a workaround for the moment. Need to troubleshoot.
          if (specialCase):
            # Why?
            when not defined(release): echo "This is a special case, subtract one function"
            finalfunctionAddress = RVA(PVOID, cast[PVOID](hLibrary), addressOfFunctionsvalue)
          when not defined(release): echo "Relative Address: ", toHex(functions[])
          functions = functions - 1
          when not defined(release): echo "Relative Address one before: ", toHex(functions[])
          functions = functions + 2
          when not defined(release): echo "Relative Address one after: ", toHex(functions[])
          functionAddress = finalfunctionAddress
          break
  else:
    # Add the ordinal number e.g. 1034 for OpenProcess and - the EXP Base address
    when not defined(release): echo fmt"Getting address via ordinal: {ordinal}"
    functions = functions + ordinal - 1
    functionAddress = RVA(PVOID, hLibrary, functions[])
    when not defined(release): echo "Relative Address: ", toHex(functions[])
    #echo "Function address via ordinal:"
    #echo repr(functionAddress)
  if functionAddress == nil:
    return nil
  if functionAddress >= cast[PVOID](exp) and functionAddress < RVA(PVOID, exp, exp_size):
    when not defined(release): echo "this is the case"
    ##  the function seems to be defined somewhere else
    functionAddress = resolve_reference(cast[HMODULE](hLibrary), functionAddress)
  return functionAddress

##
##  Look among all loaded DLLs for an export with certain function hash
##

# Not verified working yet
proc find_legacy_export*(hOriginalLibrary: HMODULE; fhash: DWORD): PVOID =
  var functionAddress: PVOID
  var Peb: PPEB = GetPPEB(PEB_OFFSET)
  #var Peb: PPEB = GetPEB()
  var Ldr = Peb.Ldr
  var FirstEntry: PVOID = addr(Ldr.InMemoryOrderModuleList.Flink)
  var Entry: PND_LDR_DATA_TABLE_ENTRY = cast[PND_LDR_DATA_TABLE_ENTRY](Ldr.InMemoryOrderModuleList.Flink)
  while Entry != FirstEntry:
    ##  avoid looking in the DLL that brought us here
    if Entry.DllBase == cast[PVOID](hOriginalLibrary):
      Entry = cast[PND_LDR_DATA_TABLE_ENTRY](Entry.InMemoryOrderLinks.Flink)
      continue
    functionAddress = get_function_address(cast[HMODULE](Entry.DllBase), fhash, 0, FALSE)
    if functionAddress == nil:
      Entry = cast[PND_LDR_DATA_TABLE_ENTRY](Entry.InMemoryOrderLinks.Flink)
      continue
    return functionAddress
    Entry = cast[PND_LDR_DATA_TABLE_ENTRY](Entry.InMemoryOrderLinks.Flink)
  return nil
