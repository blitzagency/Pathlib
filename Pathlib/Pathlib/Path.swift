//
//  Path.swift
//  Pathlib
//
//  Created by Adam Venturella on 9/15/15.
//  Copyright © 2015 BLITZ. All rights reserved.
//

import Foundation

public enum PathlibError: ErrorType{
    case FileExistsError
    case FileNotFoundError
    case PermissionDeniedError
    case Error
}

public protocol Path: CustomStringConvertible{

    static func applicatoinGroup(id: String) -> Self
    static func home() -> Self
    static func downloads() -> Self
    static func desktop() -> Self
    static func applicationSupport() -> Self
    static func directory(searchPath: NSSearchPathDirectory, domain: NSSearchPathDomainMask, expandTilde: Bool) -> Self

    var separator: String {get}
    var parts: [String] {get set}
    var parent: Path {get}
    var path: String {get}
    var drive: String{get}
    var root: String {get}
    var anchor: String {get}

    init(_ path: String)
    init(_ components: String...)
    init(_ components: [String])

    func joinPath(value: String...) -> Self
    func isAbsolute() -> Bool
    func isDir() -> Bool
    func isFile() -> Bool
    func mkdir(parents parents: Bool) throws
    func iterdir() -> AnyGenerator<Self>
    func rmitem() throws
}

extension Path{

    public var path: String {
        return drive + root + parts.joinWithSeparator(separator)
    }

    public var description: String {
        return path
    }

    public var url: NSURL{
        return NSURL(fileURLWithPath: description)
    }

    public var anchor: String {
        return drive + root
    }

    public func exists() -> Bool {
        let manager = NSFileManager.defaultManager()
        return manager.fileExistsAtPath(path)
    }

    public func isDir() -> Bool {
        let manager = NSFileManager.defaultManager()
        var isDir: ObjCBool = false
        manager.fileExistsAtPath(path, isDirectory: &isDir)
        
        return Bool(isDir)
    }

    public func isFile() -> Bool {
        let manager = NSFileManager.defaultManager()
        var isDir: ObjCBool = false
        manager.fileExistsAtPath(path, isDirectory: &isDir)

        return !Bool(isDir)
    }

    public func rmitem() throws {
        let manager = NSFileManager.defaultManager()
        do{
            try manager.removeItemAtPath(path)
        } catch let err as NSError{
            throw err
        }
    }

    public func mkdir(parents parents: Bool = false) throws {
        let manager = NSFileManager.defaultManager()

        if exists(){
            throw PathlibError.FileExistsError
        }

        do{
            try manager.createDirectoryAtPath(path, withIntermediateDirectories: parents, attributes: nil)
        } catch let err as NSError {

            if err.code == 13{
                throw PathlibError.PermissionDeniedError
            }

            // this is really bad, but just doing it for now
            // because I have some other work to get to. this
            // obviously needs to be a more descriptive error
            // see linux/include/errno.h, for codes
            // or http://www.ioplex.com/~miallen/errcmp.html
            //
            // when you receive an NSError in NSPOSIXErrorDomain, it
            // means that an error was returned by an underlying BSD-layer function,
            // and the error's code is equal to the errno that was set by that
            // function.
            // http://www.cocoabuilder.com/archive/cocoa/236685-what-header-has-enum-for-nsposixerrordomain.html#236698
            throw PathlibError.Error
        }
    }
}