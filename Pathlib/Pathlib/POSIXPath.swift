//
//  POSIXPath.swift
//  Pathlib
//
//  Created by Adam Venturella on 9/15/15.
//  Copyright © 2015 BLITZ. All rights reserved.
//


public struct POSIXPath: Path, SequenceType{

    public static func temp() -> POSIXPath{
        let path = NSTemporaryDirectory()
        return POSIXPath(path)
    }

    public static func home() -> POSIXPath{
        return POSIXPath(NSHomeDirectory())
    }

    public static func documents() -> POSIXPath{
        return directory(.DocumentDirectory)
    }

    public static func desktop() -> POSIXPath{
        return directory(.DesktopDirectory)
    }

    public static func applicationSupport() -> POSIXPath{
        return directory(.ApplicationSupportDirectory)
    }

    public static func applicationGroup(id: String) -> POSIXPath{
        let manager = NSFileManager.defaultManager()
        let path = manager
            .containerURLForSecurityApplicationGroupIdentifier(id)?.path

        return POSIXPath(path!)
    }

    public static func downloads() -> POSIXPath{
        return directory(.DownloadsDirectory)
    }

    public static func directory(searchPath: NSSearchPathDirectory, domain: NSSearchPathDomainMask = .UserDomainMask, expandTilde: Bool = true) -> POSIXPath{
        let paths = NSSearchPathForDirectoriesInDomains(searchPath, domain, expandTilde)
        return POSIXPath(paths.first!)
    }

    public let separator = "/"
    public var parts: [String]
    let _root: String?

    public init(_ path: String){
        self.init(POSIXComponents(path))
    }

    public init(_ components: String...){
        self.init(components)
    }

    public init(_ components: [String]){
        if components[0] == separator{
            _root = separator
            parts = components
            return
        }

        _root = nil
        parts = components
    }


    public var path: String {
        if let root = _root{
            return root + parts[1..<parts.count].joinWithSeparator(separator)
        }

        return parts.joinWithSeparator(separator)
    }


    public var drive: String {
        return ""
    }

    public var root: String {
        if let value = _root{
            return value
        }

        return ""
    }

    public func isAbsolute() -> Bool {
        if let _ = _root{
            return true
        }

        return false
    }

}