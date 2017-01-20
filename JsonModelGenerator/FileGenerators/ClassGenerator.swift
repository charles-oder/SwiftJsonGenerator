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
    

}