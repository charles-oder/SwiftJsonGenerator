//
//  ClassGenerator.swift
//  JsonModelGenerator
//
//  Created by Charles Oder Dev on 1/20/17.
//
//

import Foundation

class ClassGenerator {
    
    private var fileLocation: String
    
    init(fileLocation: String) {
        self.fileLocation = fileLocation
    }
    
    func createHeaders(className: String) -> String {
        var header = "// \(className).swift\n"
        header += "// Created by SwiftJsonGenerator https://github.com/charles-oder/SwiftJsonGenerator\n"
        header += "// Generated \(Date().description)\n\n"
        
        header += "import Foundation\n\n"
        return header
    }
    
    func createClassDeclaration(className: String) -> String {
        return "public struct \(className): JsonModel {\n\n"
    }
    
    func createPropertyList(properties:[ObjectProperty]) -> String {
        var propList = ""
        for property in properties {
            propList += "    public let \(property.name): \(property.type)?\n"
        }
        propList += "\n"
        return propList
    }
    


}
