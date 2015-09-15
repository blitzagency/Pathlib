//
//  POSIXPathOperators.swift
//  Pathlib
//
//  Created by Adam Venturella on 9/15/15.
//  Copyright © 2015 BLITZ. All rights reserved.
//

import Foundation

public func /(a: POSIXPath, b: String) -> POSIXPath {
    return a.joinPath(b)
}

public func /(a: POSIXPath, b: POSIXPath) -> POSIXPath {
    return a.joinPath(b.parts)
}
