from macaddress import MAC
import sys

if len(sys.argv) < 2:
    print("Usage: %s <shellcode_file>" % sys.argv[0])
    sys.exit(1) 

with open(sys.argv[1], "rb") as f:
    chunk = f.read(6)
    # Instead of an C char* MAC[] array we want to have a nim array
    print("const mac: seq[cstring] = @[")
    while chunk:
        if len(chunk) < 6:
            padding = 6 - len(chunk)
            chunk = chunk + (b"\x90" * padding)
            print("{}cast[cstring](\"{}\")".format(' '*4,MAC(chunk)))
            break
        print("{}cast[cstring](\"{}\"),".format(' '*4,MAC(chunk)))
        chunk = f.read(6)
    print("]")