import os

const
    seed = 0xC0DE1337

template ROR8(v: int64): int64 =
  ((v shr 8 and 4294967295) or (v shl 24 and 4294967295))

proc getHash(funcname: cstring): int64 =
    var hash = seed
    for letter in funcname:
        hash = hash xor int64(letter) + ROR8(hash)
    return hash

var value = paramStr(1)
var test = getHash(value)
echo test
