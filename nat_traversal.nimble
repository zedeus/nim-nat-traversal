mode = ScriptMode.Verbose

packageName   = "nat_traversal"
version       = "0.0.1"
author        = "Status Research & Development GmbH"
description   = "miniupnpc and libnatpmp wrapper"
license       = "Apache License 2.0 or MIT"
installDirs   = @["vendor"]

### Dependencies
requires "nim >= 0.19.0", "stew"

proc compileStaticLibraries() =
  withDir "vendor/miniupnp/miniupnpc":
    when defined(windows):
      exec("mingw32-make -f Makefile.mingw CC=gcc init libminiupnpc.a")
    else:
      exec("make libminiupnpc.a")
  withDir "vendor/libnatpmp":
    when defined(windows):
      exec("mingw32-make CC=gcc CFLAGS=\"-Wall -Os -DWIN32 -DNATPMP_STATICLIB -DENABLE_STRNATPMPERR -DNATPMP_MAX_RETRIES=4\" libnatpmp.a")
    else:
      exec("make CFLAGS=\"-Wall -Os -DENABLE_STRNATPMPERR -DNATPMP_MAX_RETRIES=4\" libnatpmp.a")

task buildBundledLibs, "build bundled libraries":
  compileStaticLibraries()

before install:
  compileStaticLibraries()

