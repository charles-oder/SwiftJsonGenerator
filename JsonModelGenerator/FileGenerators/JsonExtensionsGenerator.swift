//
//  JsonExtensionsGenerator.swift
//  JsonModelGenerator
//
//  Created by Charles Oder Dev on 1/19/17.
//
//

import Foundation

class JsonExtensionsGenerator: FileGenerator {
    
    func buildSupportFile() throws {
        do {
            guard let path = Bundle.main.path(forResource: "JsonExtensions", ofType: "txt") else {
                throw NSError(domain: "Missing Bundel", code: 1, userInfo: nil)
            }
            let contents = try String(contentsOfFile: path).replacingOccurrences(of: "{{DATE}}", with: "\(Date().description)")

            let fileName = "JsonExtensions.swift"
            try write(body: contents, toFile: fileName)
        } catch {
            
        }
    }
    
}
