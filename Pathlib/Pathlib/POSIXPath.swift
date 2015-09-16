//
//  POSIXPath.swift
//  Pathlib
//
//  Created by Adam Venturella on 9/15/15.
//  Copyright © 2015 BLITZ. All rights reserved.
//


public struct POSIXPath: Path, SequenceType{

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

    public var parent: Path {
        // TODO consider a way to keep the slice around until
        // another operation is performed on on it
        let slice = parts[0..<parts.count]
        return POSIXPath(Array(slice))
    }

    public var path: String {
        if let root = _root{
            return root + parts[1..<parts.count].joinWithSeparator(separator)
        }

        return parts.joinWithSeparator(separator)
    }


    public func joinPath(value: String...) -> POSIXPath{
        return joinPath(value)
    }

    public func joinPath(value: [String]) -> POSIXPath{
        let components = parts + value
        return POSIXPath(components)
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

    public func iterdir() -> AnyGenerator<POSIXPath>{
        let manager = NSFileManager.defaultManager()
        let path = self.path
        if let enumerator = manager.enumeratorAtPath(path){

            let nextClosure : () -> POSIXPath? = {

                if let url = enumerator.nextObject() as? String{
                    return self / POSIXPath(url)
                }

                return nil
            }

            return anyGenerator(nextClosure)
        }

        return anyGenerator{ nil }
    }

    public func generate() -> AnyGenerator<POSIXPath>{
        return iterdir()
    }

}