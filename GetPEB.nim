from winim import P_PEB
proc GetPPEB * (p: culong): P_PEB {. 
    header: 
        """#include <windows.h>
           #include <winnt.h>""", 
    importc: "__readgsqword"
.}