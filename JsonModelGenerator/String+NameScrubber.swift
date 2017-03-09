//
//  NameScrubber.swift
//  JsonModelGenerator
//
//  Created by Charles Oder Dev on 2/7/17.
//
//

import Foundation

extension String {
    
    var scrubbedProperyName: String {
        let components = self.components(separatedBy: "_")
        var output = ""
        for item in components {
            if !item.isEmpty {
                output.append(output.isEmpty ? item : item.firstLetterCapitalized)
            }
        }
        return output
    }
    
    var scrubbedClassName: String {
        let components = self.components(separatedBy: "_")
        var output = ""
        for item in components {
            if !item.isEmpty {
                output.append(item.firstLetterCapitalized)
            }
        }
        return output
    }
    
    var firstLetterCapitalized: String {
        let first = String(characters.prefix(1)).capitalized
        let other = String(characters.dropFirst())
        return first + other

    }
    
    var removePlural: String {
        if lowercased().hasSuffix("status") {
            return self
        }
        if lowercased().hasSuffix("news") {
            return self
        }
        if lowercased().hasSuffix("species") {
            return self
        }
        if lowercased().hasSuffix("series") {
            return self
        }
        if lowercased().hasSuffix("alumnae") {
            return String(characters.dropLast(2)) + "a"
        }
        if lowercased().hasSuffix("geese") {
            return String(characters.dropLast(4)) + "oose"
        }
        if lowercased().hasSuffix("children") {
            return String(characters.dropLast(3))
        }
        if lowercased().hasSuffix("men") {
            return String(characters.dropLast(2)) + "an"
        }
        if lowercased().hasSuffix("people") {
            return String(characters.dropLast(4)) + "rson"
        }
        if lowercased().hasSuffix("radii") {
            return String(characters.dropLast()) + "us"
        }
        if lowercased().hasSuffix("mice") {
            return String(characters.dropLast(3)) + "ouse"
        }
        if hasSuffix("ses") {
            return String(characters.dropLast(3)) + "sis"
        }
        if hasSuffix("ies") {
            return String(characters.dropLast(3)) + "y"
        }
        if hasSuffix("es") {
            return String(characters.dropLast(2))
        }
        if hasSuffix("s") {
            return String(characters.dropLast())
        }
        return self
    }
}
