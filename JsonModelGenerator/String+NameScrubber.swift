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
}
