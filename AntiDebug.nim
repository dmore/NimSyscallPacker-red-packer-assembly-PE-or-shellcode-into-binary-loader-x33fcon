from winim import LIST_ENTRY,PVOID,ULONG,UNICODE_STRING,UCHAR,BYTE,P_PEB

when defined(WIN64):
  const
    PEB_OFF* = 0x30
else:
  const
    PEB_OFF* = 0x60

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
    BeingDebugged*: bool
    Reserved2*: array[1, BYTE]
    Reserved3*: array[2, PVOID]
    Ldr*: PND_PEB_LDR_DATA

  PND_PEB* = ptr ND_PEB

proc GetPEBPointer(p: culong): P_PEB {. 
    header: 
        """#include <windows.h>
           #include <winnt.h>""", 
    importc: "__readgsqword"
.}

proc AmIDebugged*(): bool =
    var Peb: PPEB = GetPEBPointer(PEB_OFF)
    var BeingDebugged = bool(Peb.BeingDebugged)
    if (BeingDebugged):
      echo "Hello world!"
      return true
    else:
      return false

#[
   More to come - https://0xpat.github.io/Malware_development_part_3/

   #define FLG_HEAP_ENABLE_TAIL_CHECK   0x10
   #define FLG_HEAP_ENABLE_FREE_CHECK   0x20
   #define FLG_HEAP_VALIDATE_PARAMETERS 0x40
   #define NT_GLOBAL_FLAG_DEBUGGED (FLG_HEAP_ENABLE_TAIL_CHECK | FLG_HEAP_ENABLE_FREE_CHECK | FLG_HEAP_VALIDATE_PARAMETERS)
   PDWORD pNtGlobalFlag = (PDWORD)(__readgsqword(0x60) + 0xBC);
   if ((*pNtGlobalFlag) & NT_GLOBAL_FLAG_DEBUGGED) return false;


and


PDWORD pHeapFlags = (PDWORD)((PBYTE)GetProcessHeap() + 0x70);
PDWORD pHeapForceFlags = (PDWORD)((PBYTE)GetProcessHeap() + 0x74);
if (*pHeapFlags ^ HEAP_GROWABLE || *pHeapForceFlags != 0) return false;

+

CONTEXT context = {};
context.ContextFlags = CONTEXT_DEBUG_REGISTERS;
GetThreadContext(GetCurrentThread(), &context);
if (context.Dr0 || context.Dr1 || context.Dr2 || context.Dr3) return;

or


BOOL isDebugged = TRUE;

LONG WINAPI CustomUnhandledExceptionFilter(PEXCEPTION_POINTERS pExceptionPointers)
{
	isDebugged = FALSE;
	return EXCEPTION_CONTINUE_EXECUTION;
}

void main()
{
	PTOP_LEVEL_EXCEPTION_FILTER previousUnhandledExceptionFilter = SetUnhandledExceptionFilter(CustomUnhandledExceptionFilter);
	RaiseException(EXCEPTION_FLT_DIVIDE_BY_ZERO, 0, 0, NULL);
	SetUnhandledExceptionFilter(previousUnhandledExceptionFilter);
	if (isDebugged) return;

	wprintf_s(L"Now hacking...\n");
}

Hide Thread from a debugger:

typedef NTSTATUS(WINAPI *NtSetInformationThread)(IN HANDLE, IN THREADINFOCLASS, IN PVOID, IN ULONG);
NtSetInformationThread pNtSetInformationThread = (NtSetInformationThread)GetProcAddress(GetModuleHandleW(L"ntdll.dll"), "NtSetInformationThread");
THREADINFOCLASS ThreadHideFromDebugger = (THREADINFOCLASS)0x11;
pNtSetInformationThread(GetCurrentThread(), ThreadHideFromDebugger, NULL, 0);

]#