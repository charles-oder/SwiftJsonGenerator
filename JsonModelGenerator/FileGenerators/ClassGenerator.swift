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
    
    func createInitWithPropertyArgs(properties:[ObjectProperty]) -> String {
        var initMethod = "    public init(\n"
        for property in properties {
            initMethod += "                \(property.name): \(property.type)?\(property.name != properties.last?.name ? "," : "")\n"
        }
        initMethod += "                ) {\n"
        for property in properties {
            initMethod += "        self.\(property.name) = \(property.name)\n"
        }
        initMethod += "    }\n\n"
        return initMethod
    }
    
    func createInitWithDictionaryMethod(properties:[ObjectProperty]) -> String {
        var initMethod = "    public init?(dictionary:[String: Any?]?) {\n"
        initMethod += "\n"
        for property in properties {
            if property.isCustomType {
                if property.isArray {
                    initMethod += "        if let dictionaryArray = dictionary?[\"\(property.name)\"] as? [[String:Any?]] {\n"
                    initMethod += "            var objectArray = [\(property.arrayType)]()\n"
                    initMethod += "            for d in dictionaryArray {\n"
                    initMethod += "                if let object = \(property.arrayType)(dictionary:d) {\n"
                    initMethod += "                    objectArray.append(object)\n"
                    initMethod += "                }\n"
                    initMethod += "            }\n"
                    initMethod += "            self.\(property.name) = objectArray\n"
                    initMethod += "        } else {\n"
                    initMethod += "            self.\(property.name) = nil\n"
                    initMethod += "        }\n"
                    
                } else {
                    initMethod += "        self.\(property.name) = \(property.type)(dictionary:dictionary?[\"\(property.name)\"] as? [String:Any?])\n"
                }
            } else {
                initMethod += "        self.\(property.name) = dictionary?[\"\(property.name)\"] as? \(property.type)\n"
            }
        }
        initMethod += "\n"
        initMethod += "    }\n\n"
        return initMethod
    }
    
    func createJsonDictionaryDefinition(properties:[ObjectProperty]) -> String {
        var output = "    public var jsonDictionary: [String:Any?] {\n"
        output += "\n"
        output += "        var dictionary = [String: Any?]()\n"
        for property in properties {
            if property.isCustomType {
                if property.isArray {
                    output += "        if let objectArray = self.\(property.name) {\n"
                    output += "            var dictionaryArray = [[String: Any?]]()\n"
                    output += "            for object in objectArray {\n"
                    output += "                dictionaryArray.append(object.jsonDictionary)\n"
                    output += "            }\n"
                    output += "            dictionary[\"\(property.name)\"] = dictionaryArray\n"
                    output += "        }\n"
                    
                } else {
                    output += "        dictionary[\"\(property.name)\"] = self.\(property.name)?.jsonDictionary\n"
                }
            } else {
                output += "        dictionary[\"\(property.name)\"] = self.\(property.name)\n"
            }
            
        }
        output += "\n"
        output += "        return dictionary\n\n"
        output += "    }\n\n"
        return output
    }
    
    func createFooter() -> String {
        return "}\n"
    }
    
    func createFile(className: String, properties:[ObjectProperty]) throws {
        let fileName = className + ".swift"
        let url = URL(fileURLWithPath: fileLocation + fileName)
        
        let fileContents = createHeaders(className: className) +
            createClassDeclaration(className: className) +
            createPropertyList(properties: properties) +
            createInitWithPropertyArgs(properties: properties) +
            createInitWithDictionaryMethod(properties: properties) +
            createJsonDictionaryDefinition(properties: properties) +
            createFooter()
        
        try fileContents.data(using: .utf8, allowLossyConversion: true)?.write(to: url)
    }
    
    func getType(key: String, val: Any?) -> (type:String, isCustom:Bool) {
        if let _ = val as? String {
            return (type:"String", isCustom:false)
        }
        if let num = val as? Double {
            return num.isReallyAnInt ? (type:"Int", isCustom:false) : (type:"Double", isCustom:false)
        }
        if let _ = val as? Bool {
            return (type:"Bool", isCustom:false)
        }
        if let _ = val as? [String] {
            return (type:"[String]", isCustom:false)
        }
        if let numArray = val as? [Double] {
            var type = (type:"[Double]", isCustom:false)
            for num in numArray {
                if num.isReallyAnInt {
                    type = (type:"[Int]", isCustom:false)
                }
            }
            return type
        }
        if let _ = val as? [Bool] {
            return (type:"[Bool]", isCustom:false)
        }
        if let _ = val as? [String: Any?] {
            return (type:key.capitalized, isCustom:true)
        }
        if let _ = val as? [[String: Any?]] {
            return (type:"[\(key.capitalized)]", isCustom:true)
        }
        return (type:"Any", isCustom:false)
    }
    
    func getChildObjectDictionary(value: Any?) ->[String:Any?] {
        if let dictionary = value as? [String: Any?] {
            return dictionary
        } else if let dictionaryArray = value as? [[String: Any?]] {
            return dictionaryArray.mergedArray
        }
        return [:]
    }

}
