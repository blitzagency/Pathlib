//
//  POSIXTests.swift
//  Pathlib
//
//  Created by Adam Venturella on 9/15/15.
//  Copyright © 2015 BLITZ. All rights reserved.
//

import XCTest
import Pathlib

class POSIXTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testInitWithStringAbsolute() {
        let p1 = POSIXPath("/a/b/c")
        XCTAssert(p1.parts == ["/", "a", "b", "c"])
    }

    func testInitWithStringRelative() {
        let p1 = POSIXPath("a/b/c")
        XCTAssert(p1.parts == ["a", "b", "c"])
    }

    func testInitWithArray() {
        let p1 = POSIXPath(["a", "b", "c"])
        XCTAssert(p1.parts == ["a", "b", "c"])
        XCTAssert(p1.path == "a/b/c")
    }

    func testInitWithVariadic() {
        let p1 = POSIXPath("a", "b", "c")
        XCTAssert(p1.parts == ["a", "b", "c"])
        XCTAssert(p1.path == "a/b/c")
    }

    func testWithStringOperator(){
        let p1 = POSIXPath("/a/b")
        let result = p1 / "c"

        XCTAssert(result.parts == ["/", "a", "b", "c"])
        XCTAssert(result.path == "/a/b/c")
    }

    func testWithMultipleStringOperator(){
        let p1 = POSIXPath("/a/b")
        let result = p1 / "c" / "d" / "e" / "f"

        XCTAssert(result.parts == ["/", "a", "b", "c", "d", "e", "f"])
        XCTAssert(result.path == "/a/b/c/d/e/f")
    }

    func testWithPathOperator(){
        let p1 = POSIXPath("a/b")
        let p2 = POSIXPath("c")

        let result = p1 / p2

        XCTAssert(result.parts == ["a", "b", "c"])
        XCTAssert(result.path == "a/b/c")
    }

    func testRootIsEmpty(){
        let p1 = POSIXPath("a/b")
        XCTAssert(p1.root == "")
    }

    func testParent(){
        let p1 = POSIXPath("a/b/c")
        let p2 = p1.parent
        XCTAssert(p2.path == "a/b")
    }

    func testDriveIsNotEmpty(){
        let p1 = POSIXPath("/a/b")
        XCTAssert(p1.root == "/")
    }

    func testDriveIsEmpty(){
        let p1 = POSIXPath("a/b")
        XCTAssert(p1.drive == "")
    }

    func testDriveIsAbsoluteTrue(){
        let p1 = POSIXPath("/a/b")
        XCTAssert(p1.isAbsolute() == true)
    }

    func testDriveIsAbsoluteFalse(){
        let p1 = POSIXPath("a/b")
        XCTAssert(p1.isAbsolute() == false)
    }

    func testMkdirParents(){
        let p1 = POSIXPath("/tmp/foo/bar")
        XCTAssert(p1.exists() == false)
        try! p1.mkdir(parents: true)
        XCTAssert(p1.exists() == true)

        try! p1.rmitem()
    }

    func testMkdirNoParents(){
        let p1 = POSIXPath("/tmp/foo")
        XCTAssert(p1.exists() == false)
        try! p1.mkdir()
        XCTAssert(p1.exists() == true)

        try! p1.rmitem()
    }

    func testMkdirExists(){
        let p1 = POSIXPath("/tmp")

        do{
            try p1.mkdir()
        } catch let err as PathlibError{
            XCTAssert(err._code == PathlibError.FileExistsError._code)
            return
        } catch {
            XCTFail()
        }

        XCTFail()
    }

    func testHomeDir(){
        let p1 = POSIXPath.home()
        XCTAssert(p1.path != "")
    }

    func testDownloadsDir(){
        let p1 = POSIXPath.downloads()
        XCTAssert(p1.path != "")
    }

    func testDesktopDir(){
        let p1 = POSIXPath.desktop()
        XCTAssert(p1.path != "")
    }

    func testApplicationSupportDir(){
        let p1 = POSIXPath.applicationSupport()
        XCTAssert(p1.path != "")
    }

    func testTemp(){
        let p1 = POSIXPath.temp()
        XCTAssert(p1.path != "")
    }

    func testJoinPathArray(){
        let p1 = POSIXPath("/a/b")
        let p2 = p1.joinPath(["c", "d"])
        XCTAssert(p2.path == "/a/b/c/d")
    }

    func testJoinPathVariadic(){
        let p1 = POSIXPath("/a/b")
        let p2 = p1.joinPath("c", "d")
        XCTAssert(p2.path == "/a/b/c/d")
    }

    func testTouch(){
        let p1 = POSIXPath("/tmp/pathlib_test")
        XCTAssert(p1.exists() == false)

        p1.touch()

        XCTAssert(p1.exists() == true)
        try! p1.rmitem()
    }

    func testCopy(){
        let p1 = POSIXPath("/tmp/pathlib")
        let p2 = p1 / "test"
        let p3 = p1 / "test_copy"

        try! p1.mkdir()
        p2.touch()

        XCTAssert(p2.exists() == true)
        XCTAssert(p3.exists() == false)

        try! p2.copy(to: p3)

        XCTAssert(p2.exists() == true)
        XCTAssert(p3.exists() == true)

        try! p1.rmitem()
    }

    func testCopyDirectory(){
        let p1 = POSIXPath("/tmp/pathlib")
        let p2 = p1 / "test"
        let p3 = p1 / "test_copy"

        let p4 = POSIXPath("/tmp/pathlib2")
        let p5 = p4 / "test"
        let p6 = p4 / "test_copy"

        try! p1.mkdir()
        p2.touch()
        p3.touch()

        XCTAssert(p2.exists() == true)
        XCTAssert(p3.exists() == true)

        XCTAssert(p4.exists() == false)
        XCTAssert(p5.exists() == false)
        XCTAssert(p6.exists() == false)

        try! p1.copy(to: p4)

        XCTAssert(p4.exists() == true)
        XCTAssert(p5.exists() == true)
        XCTAssert(p6.exists() == true)
        
        try! p1.rmitem()
        try! p4.rmitem()
    }

    func testIterdir(){
        let p1 = POSIXPath("/tmp")

        for each in p1{
            print(each)
        }
    }
}
