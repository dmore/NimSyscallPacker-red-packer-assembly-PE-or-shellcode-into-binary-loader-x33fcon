import macros, hashes

type
  # Use a distinct string type so we won't recurse forever
  estring = distinct string

# Use a "strange" name
proc thisisStrange(s: estring, key: int): string {.noinline.} =
  # We need {.noinline.} here because otherwise C compiler
  # aggresively inlines this procedure for EACH string which results
  # in more assembly instructions
  var k = key
  var whatup: char
  var testString: string = " "
  result = string(s)
  for i in 0 ..< result.len:
    for f in [0, 8, 16, 24]:
      whatup = result[i]
      testString = testString & " "
      result[i] = chr(uint8(result[i]) xor uint8((k shr f) and 0xEE))
    k = k +% 1


var encodedCounter {.compileTime.} = hash(CompileTime & CompileDate) and 0x7FFFFFEE

# Use a term-rewriting macro to change all string literals
macro encrypt*{s}(s: string{lit}): untyped =
  var encodedStr = thisisStrange(estring($s), encodedCounter)

  template genStuff(str, counter: untyped): untyped = 
    {.noRewrite.}:
      thisisStrange(estring(`str`), `counter`)
  
  result = getAst(genStuff(encodedStr, encodedCounter))
  encodedCounter = (encodedCounter *% 16777619) and 0x7FFFFFEE