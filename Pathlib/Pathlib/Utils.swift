//
//  Utils.swift
//  Pathlib
//
//  Created by Adam Venturella on 9/15/15.
//  Copyright © 2015 BLITZ. All rights reserved.
//

import Foundation

func POSIXComponents(value: String, separator: String = "/") -> [String]{
    let components: [String]

    let view = separator.unicodeScalars
    let unicodeScalars = value.unicodeScalars
    let unicodeSeparator = separator.unicodeScalars[separator.unicodeScalars.startIndex]
    let parts = value.unicodeScalars.split(isSeparator: {$0 == unicodeSeparator}).map(String.init)

    if unicodeScalars[unicodeScalars.startIndex] == view[view.startIndex]{
        components = [separator] + parts
    } else {
        components = parts
    }

    return components
}