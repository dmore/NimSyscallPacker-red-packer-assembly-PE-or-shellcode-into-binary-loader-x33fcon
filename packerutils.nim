
proc memset(a: pointer, v: cint, size: Natural) {.cdecl.} =
    let a = cast[ptr UncheckedArray[byte]](a)
    var i = 0
    let v = cast[byte](v)
    while i < size:
      a[i] = v
      inc i

proc `+`*[T; S: SomeInteger](p: ptr T, offset: S): ptr T =
  ## Increments pointer `p` by `offset` that jumps memory in increments of
  ## the size of `T`.
  runnableExamples:
    type
      MyObject = object
        i: int
        f: float
        b: bool
    var
      a = [MyObject(i: 100, f: 2.3, b: true),
           MyObject(i: 300, f: 4.5, b: false),
           MyObject(i: 500, f: 6.7, b: true)]
      p = addr(a[0])
      p2 = p + 2

    doAssert p2[0].i == 500
    doAssert p2[-1].f == 4.5
  ##
  return cast[ptr T](cast[ByteAddress](p) +% (int(offset) * sizeof(T)))
  #                                      `+%` treats x and y inputs as unsigned
  # and adds them: https://nim-lang.github.io/Nim/system.html#%2B%25%2Cint%2Cint

proc `+`*[S: SomeInteger](p: pointer, offset: S): pointer =
  ## Increments pointer `p` by `offset` that jumps memory in increments of
  ## single bytes.
  runnableExamples:
    type
      MyObject = object
        i: int
        f: float
        b: bool
    var
      a = [MyObject(i: 100, f: 2.3, b: true),
           MyObject(i: 300, f: 4.5, b: false),
           MyObject(i: 500, f: 6.7, b: true)]
      p = cast[pointer](addr(a[0]))
      p2 = p + (2*sizeof(MyObject))

    doAssert cast[ptr MyObject](p2)[0].i == 500
    doAssert cast[ptr MyObject](p2)[-1].f == 4.5
  ##
  return cast[pointer](cast[ByteAddress](p) +% int(offset))

proc `-`*[T; S: SomeInteger](p: ptr T, offset: S): ptr T =
  ## Decrements pointer `p` by `offset` that jumps memory in increments of
  ## the size of `T`.
  runnableExamples:
    type
      MyObject = object
        i: int
        f: float
        b: bool
    var
      a = [MyObject(i: 100, f: 2.3, b: true),
           MyObject(i: 300, f: 4.5, b: false),
           MyObject(i: 500, f: 6.7, b: true)]
      p = addr(a[2])
      p1 = p - 1
    doAssert p1[0].i == 300
    doAssert p1[-1].b == true
    doAssert p1[1].f == 6.7
  ##
  return cast[ptr T](cast[ByteAddress](p) -% (int(offset) * sizeof(T)))

proc `-`*[S: SomeInteger](p: pointer, offset: S): pointer =
  ## Decrements pointer `p` by `offset` that jumps memory in increments of
  ## single bytes.
  runnableExamples:
    type
      MyObject = object
        i: int
        f: float
        b: bool
    var
      a = [MyObject(i: 100, f: 2.3, b: true),
           MyObject(i: 300, f: 4.5, b: false),
           MyObject(i: 500, f: 6.7, b: true)]
      p = cast[pointer](addr(a[2]))
      p1 = p - (1*sizeof(MyObject))
    doAssert cast[ptr MyObject](p1)[0].i == 300
    doAssert cast[ptr MyObject](p1)[-1].b == true
    doAssert cast[ptr MyObject](p1)[1].f == 6.7
  ##
  return cast[pointer](cast[ByteAddress](p) -% int(offset))

proc `+=`*[T; S: SomeInteger](p: var ptr T, offset: S) =
  ## Increments pointer `p` *in place* by `offset` that jumps memory
  ## in increments of the size of `T`.
  runnableExamples:
    type
      MyObject = object
        i: int
        f: float
        b: bool
    var
      a = [MyObject(i: 100, f: 2.3, b: true),
           MyObject(i: 300, f: 4.5, b: false),
           MyObject(i: 500, f: 6.7, b: true)]
      p = addr(a[0])

    p += 1
    doAssert p[].i == 300
  ##
  p = p + offset

proc `+=`*[S: SomeInteger](p: var pointer, offset: S) =
  ## Increments pointer `p` *in place* by `offset` that jumps memory
  ## in increments of single bytes.
  runnableExamples:
    type
      MyObject = object
        i: int
        f: float
        b: bool
    var
      a = [MyObject(i: 100, f: 2.3, b: true),
           MyObject(i: 300, f: 4.5, b: false),
           MyObject(i: 500, f: 6.7, b: true)]
      p = cast[pointer](addr(a[0]))

    p += (1*sizeof(MyObject))
    doAssert cast[ptr MyObject](p)[].i == 300
  ##
  p = p + offset

proc `-=`*[T; S: SomeInteger](p: var ptr T, offset: S) =
  ## Decrements pointer `p` *in place* by `offset` that jumps memory
  ## in increments of the size of `T`.
  runnableExamples:
    type
      MyObject = object
        i: int
        f: float
        b: bool
    var
      a = [MyObject(i: 100, f: 2.3, b: true),
           MyObject(i: 300, f: 4.5, b: false),
           MyObject(i: 500, f: 6.7, b: true)]
      p = addr(a[2])

    p -= 2
    doAssert p[].f == 2.3
  ##
  p = p - offset

proc `-=`*[S: SomeInteger](p: var pointer, offset: S) =
  ## Decrements pointer `p` *in place* by `offset` that jumps memory
  ## in increments of single bytes.
  runnableExamples:
    type
      MyObject = object
        i: int
        f: float
        b: bool
    var
      a = [MyObject(i: 100, f: 2.3, b: true),
           MyObject(i: 300, f: 4.5, b: false),
           MyObject(i: 500, f: 6.7, b: true)]
      p = cast[pointer](addr(a[2]))

    p -= (2*sizeof(MyObject))
    doAssert cast[ptr MyObject](p)[].f == 2.3
  ##
  p = p - offset

proc `[]=`*[T; S: SomeInteger](p: ptr T, offset: S, val: T) =
  ## Assigns the value at memory location pointed by `p[offset]`.
  runnableExamples:
    var
      a = [1.3, -9.5, 100.0]
      p = addr(a[1])

    p[0] = 123.456
    doAssert a[1] == 123.456
  ##
  (p + offset)[] = val

proc `[]`*[T; S: SomeInteger](p: ptr T, offset: S): var T =
  ## Retrieves the value from `p[offset]`.
  runnableExamples:
    var
      a = [1, 3, 5, 7]
      p = addr(a[0])

    doAssert p[] == a[0]
    doAssert p[0] == a[0]
    doAssert p[2] == a[2]
  ##
  return (p + offset)[]


iterator items*[T](start: ptr T, stopBefore: ptr T): lent T =
  ## Iterates over contiguous `ptr T`s, from `start` excluding `stopBefore`. Yields immutable `T`.
  runnableExamples:
    var
      a = [1, 3, 5, 7]
      p = addr(a[0])
      e = p + a.len
      sum = 0
    for i in items(p, e):
      sum += i
    doAssert(sum == 16)
  ##
  var p = start
  while p != stopBefore:
    yield p[] 
    p += 1

iterator mitems*[T](start: ptr T, stopBefore: ptr T): var T =
  ## Iterates over contiguous `ptr T`s, from `start` excluding `stopBefore`. Yields mutable `T`.
  runnableExamples:
    var
      a = [1, 3, 5, 7]
      p = addr(a[0])
      e = p + a.len
      sum = 0
    for i in mitems(p, e):
      inc i
    for i in items(p, e):
      sum += i
    doAssert(sum == 20)
  ##
  var p = start
  while p != stopBefore:
    yield p[] 
    p += 1

iterator items*[T](uarray: UncheckedArray[T] | ptr T, len: SomeInteger): lent T =
  ## Iterates over `UncheckedArray[T]` or `ptr T` array with length. Yields immutable `T`.
  runnableExamples:
    let
      l = 4
      a = cast[ptr UncheckedArray[int]](alloc0(sizeof(int) * l))
      b = [1, 3, 5, 7]

    copyMem(a, b[0].unsafeAddr, sizeof(int) * l) 
    var i = 0
    for val in items(a[], l):
      doAssert(val == b[i])
      inc i

    let
      p = cast[ptr int](a)
    i = 0
    for val in items(p, l):
      doAssert(val == b[i])
      inc i
    dealloc(a)
  ##
  for i in 0..<len:
    yield uarray[i]

# As of 1.6.0 mitems and mpairs for var UncheckedArray[t] and ptr T cannot be combined
# like their immutable versions. https://forum.nim-lang.org/t/8557#55560

iterator mitems*[T](uarray: var UncheckedArray[T], len: SomeInteger): var T =
  ## Iterates over `var UncheckedArray[T]` with length. Yields mutable `T`.
  runnableExamples:
    var a = cast[ptr UncheckedArray[int]](alloc0(sizeof(int) * 4))
    for i in mitems(a[], 4):
      inc i
    doAssert(a[0] == 1)
    dealloc(a)
  ##
  for i in 0..<len:
    yield uarray[i]

iterator mitems*[T](p: ptr T, len: SomeInteger): var T =
  ## Iterates over `ptr T` with length. Yields mutable `T`.
  runnableExamples:
    var a = cast[ptr int](alloc0(sizeof(int) * 4))
    for i in mitems(a, 4):
      inc i
    doAssert(a[0] == 1)
    dealloc(a)
  ##
  for i in 0..<len:
    yield p[i]

iterator pairs*[T; S:SomeInteger](uarray: UncheckedArray[T] | ptr T, len: S): (S, lent T) =
  ## Iterates over `UncheckedArray[T]` or `ptr T` array with length. Yields immutable `(index, uarray[index])`.
  runnableExamples:
    let
      l = 4
      a = [1, 3, 5, 7]
      b = cast[ptr UncheckedArray[int]](alloc0(sizeof(int) * l))
      c = cast[ptr int](alloc0(sizeof(int) * l))

    copyMem(b, a[0].unsafeAddr, sizeof(int) * l) 
    copyMem(c, a[0].unsafeAddr, sizeof(int) * l) 

    for i, val in pairs(b[], l):
      doAssert(a[i] == val)

    for i, val in pairs(c, l):
      doAssert(a[i] == val)
    dealloc(b)
    dealloc(c)
  ##
  for i in S(0)..<len:
    yield (i, uarray[i])


iterator mpairs*[T; S: SomeInteger](uarray: var UncheckedArray[T], len: S): (S, var T) =
  ## Iterates over `var UncheckedArray[T]` with length. Yields `(index, uarray[index])` with mutable `T`.
  runnableExamples:
    let
      l = 4
      a = [1, 3, 5, 7]
      b = cast[ptr UncheckedArray[int]](alloc0(sizeof(int) * l))

    copyMem(b, a[0].unsafeAddr, sizeof(int) * l) 

    for i, val in mpairs(b[], l):
      inc val
      doAssert(a[i] + 1 == val)

    dealloc(b)
  ##
  for i in S(0)..<len:
    yield (i, uarray[i])

iterator mpairs*[T; S: SomeInteger](p: ptr T, len: S): (S, var T) =
  ## Iterates over `ptr T` array with length. Yields `(index, p[index])` with mutable `T`.
  runnableExamples:
    let
      l = 4
      a = [1, 3, 5, 7]
      b = cast[ptr int](alloc0(sizeof(int) * l))

    copyMem(b, a[0].unsafeAddr, sizeof(int) * l) 

    for i, val in mpairs(b, l):
      inc val
      doAssert(a[i] + 1 == val)
    dealloc(b)
  ##
  for i in S(0)..<len:
    yield (i, p[i])

proc strcmp(s1, s2: ptr char): int {.cdecl.} =
    var i = 0
    while true:
        if s1[i] == '\0' and s2[i] == '\0':
            return 0
        if s1[i] == '\0':
            return -1
        if s2[i] == '\0':
            return 1
        if s1[i] != s2[i]:
            return ord(s1[i]) - ord(s2[i])
        inc(i)

# custom strstr function, as we need that for leaving out dynlib
proc strstr(s1, s2: ptr char): ptr char {.cdecl.} =
    var i = 0
    var j = 0
    while true:
        if s1[i] == '\0':
            return nil
        if s1[i] == s2[j]:
            inc(j)
            if s2[j] == '\0':
                return s1 + i - j + 1
        else:
            j = 0
        inc(i)

import winim

type
    CFile* = object
        cptr*:       cstring
        cnt*:        SIZE_T
        base*:       cstring
        flag*:       SIZE_T
        file*:       SIZE_T
        charBuf*:    SIZE_T
        bufSize*:    SIZE_T
        tmpFname*:   cstring

    CFilePtr* = ptr CFile ## The type representing a file handle.

type
    ## MSVCRT
    ##-----------------------------------------------
    iob_func*   = proc: CFilePtr {.cdecl, gcsafe.}
    fileno*     = proc(f: CFilePtr): SIZE_T {.cdecl, gcsafe.}
    fwrite*     = proc(b: PVOID, size, n: SIZE_T, f: CFilePtr): SIZE_T {.cdecl, gcsafe.}
    set_mode*   = proc(fd, mode: SIZE_T): SIZE_T {.cdecl, gcsafe.}
    fflush*     = proc(stream: CFilePtr): SIZE_T {.cdecl, gcsafe.}

type
    ## Distinct pointer for module base addresses.
    ModuleHandle* = distinct pointer

func `==`*(a: ModuleHandle, b: pointer): bool {.borrow.}
func `==`*(a,b: ModuleHandle): bool {.borrow.}
func `isNil`*(a: ModuleHandle): bool {.borrow.}

template `+%`*(h: ModuleHandle, i: SomeInteger): PVOID =
    cast[PVOID](cast[int](h) +% i)

template `-%`*(h: ModuleHandle, i: SomeInteger): PVOID =
    cast[PVOID](cast[int](h) -% i)

when not defined(DInvoke):
  when defined(WIN64):
    const
      PEB_OFFSET_1* = 0x15
      PEB_OFFSET* = PEB_OFFSET_1 + 0x15
  else:
    const
      PEB_OFFSET_1* = 0x30
      PEB_OFFSET* = PEB_OFFSET_1 + 0x30

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

when defined(DInvoke):
  proc MyRtlGetCurrentPeb*(p: culong): P_PEB {. 
      header: 
          """#include <windows.h>
            #include <winnt.h>""", 
      importc: "__readgsqword"
  .}