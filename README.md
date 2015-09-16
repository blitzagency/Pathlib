# Pathlib

Little utility framework for working with paths inspired by Python's `pathlib`.
See the unit tests for additional examples. The current API will likely see
changes as this is a first draft.

### Carthage Install

```
github "blitzagency/Pathlib"
```

### Examples

**Convenience Paths**

```swift
let p0 = POSIXPath.temp()
let p1 = POSIXPath.home()
let p2 = POSIXPath.desktop()
let p3 = POSIXPath.downloads()
let p4 = POSIXPath.applicationSupport()
let p5 = POSIXPath.applicationGroup("foo.bar.baz")
let p6 = POSIXPath.directory(searchPath:.DocumentDirectory, domain:.UserDomainMask, expandTilde: true)
```

**Joining Paths with Strings**

```swift
let p1 = POSIXPath("/a/b")
let p2 = p1 / "c"
print(p2)  // "/a/b/c"

// OR GO NUTS:

let p3 = p2 / "d" / "e" / "f"
print(p3)  // "/a/b/c/d/e/f"

// OR

let p4 = p2.joinPath("d", "e", "f")
print(p4)  // "/a/b/c/d/e/f"

// OR

let p5 = p2.joinPath(["d", "e", "f"])
print(p5)  // "/a/b/c/d/e/f"
```

**Joining Paths with Paths**

```swift
let p1 = POSIXPath("/a/b")
let p2 = p1 / POSIXPath("c")
print(p2)  // "/a/b/c"
```


**Iterating directories**

```swift
let p1 = POSIXPath("/a/b") // SequenceType

for path in p1{
    print(path)
}
```

**Copy Files**
```swift
let p1 = POSIXPath("/tmp/pathlib")
let p2 = p1 / "test"
let p3 = p1 / "test_copy"

try! p1.mkdir()
p2.touch()  // touch should likely throw as well...it doesn't right now.

try! p2.copy(to: p3)

try! p1.rmitem()
```

**Additional helpers**

```swift
let p1 = POSIXPath("/a/b")

p1.iterdir()                          // AnyGenerator<POSIXPath>
                                      //
p1.parts                              // ["/", "a", "b"]
p1.path                               // "/a/b"
p1.url                                // -> NSURL
                                      //
p1.mkdir(parents: true)               // throws (default for parents is false)
p1.rmitem()                           // throws
p1.copy(to: otherPOSIXPath)           // throws (default for parents is false)
p1.exists()                           // Bool
p1.isAbsolute()                       // Bool
p1.isDir()                            // Bool
p1.isFile()                           // Bool
                                      //
p1.create(myNSData?, attributes: nil) // create files with optional data
p1.touch()                            // update last modified time
```


