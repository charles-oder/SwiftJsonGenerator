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
                output.append(output.isEmpty ? item : item.capitalized)
            }
        }
        return output
    }
    
    var scrubbedClassName: String {
        let components = self.components(separatedBy: "_")
        var output = ""
        for item in components {
            if !item.isEmpty {
                output.append(item.capitalized)
            }
        }
        return output
    }
    
}
