//
//  ObjectProperty.swift
//  JsonModelGenerator
//
//  Created by Charles Oder Dev on 1/19/17.
//
//

import Foundation

struct ObjectProperty {
    let name: String
    let type: String
}

extension ObjectProperty {
    var isCustomType: Bool {
        return type != "String" && type != "Int" && type != "Double" && type != "Bool" && type != "[String]" && type != "[Int]" && type != "[Double]" && type != "[Bool]"
    }
}
