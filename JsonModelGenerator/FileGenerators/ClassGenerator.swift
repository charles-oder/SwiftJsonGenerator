//
//  ClassGenerator.swift
//  JsonModelGenerator
//
//  Created by Charles Oder Dev on 1/20/17.
//
//

import Foundation

class ClassGenerator: FileGenerator {
    
    private var prefix: String
    private var suffix: String
    
    init(fileLocation: String, prefix: String, suffix: String) {
        self.prefix = prefix
        self.suffix = suffix
        super.init(fileLocation: fileLocation)
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
                initMethod += "        self.\(property.name) = CustomPropertyFactory.getObject(from: dictionary?[\"\(property.name)\"] ?? nil, factory: { (dict) -> (\(property.arrayType)?) in return \(property.arrayType)(dictionary: dict) }) as? \(property.type)\n"
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
                output += "        dictionary[\"\(property.name)\"] = CustomPropertyFactory.getJsonDictionary(for: self.\(property.name))\n"
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
        
        let fileContents = createHeaders(className: className) +
            createClassDeclaration(className: className) +
            createPropertyList(properties: properties) +
            createInitWithPropertyArgs(properties: properties) +
            createInitWithDictionaryMethod(properties: properties) +
            createJsonDictionaryDefinition(properties: properties) +
            createFooter()
        
        try write(body: fileContents, toFile: fileName)
    }
    
    func getType(key: String, val: Any?) -> (type:String, isCustom:Bool) {
        
        guard let value = val else {
            return (type:"Any", isCustom:false)
        }
        
        let typeDescription = String(describing:type(of:value))
        
        if typeDescription == "__NSSingleEntryDictionaryI" || typeDescription == "__NSDictionaryI" {
            return (type:self.prefix + key.capitalized + self.suffix, isCustom:true)
        } else if typeDescription == "__NSSingleObjectArrayI" { // Could be an array of arrays?
            if let something = (value as? [Any?])?.first {
                var type = getType(key: key, val: something)
                type.type = "[\(type.type)]"
                return type
            }
        } else if typeDescription == "NSTaggedPointerString" || typeDescription == "__NSCFString" {
            return (type:"String", isCustom:false)
        } else if typeDescription == "__NSCFNumber" {
            return CFNumberIsFloatType(value as! CFNumber) ? (type:"Double", isCustom:false) : (type:"Int", isCustom:false)
        } else if typeDescription == "__NSCFBoolean" {
            return (type:"Bool", isCustom:false)
        }  else if typeDescription == "__NSArrayI" || typeDescription == "__NSSingleObjectArrayI" {
            if let something = (value as? [Any])?.first {
                var type = getType(key: key, val: something)
                type.type = "[\(type.type)]"
                return type
            }
            return (type:"Bool", isCustom:false)
        }
        return (type:"Any", isCustom:false)
    }
    
    func getChildObjectDictionary(value: Any?) -> [String:Any?] {
        if let dictionary = value as? [String: Any?] {
            return dictionary
        } else if let dictionaryArray = value as? [[String: Any?]] {
            return dictionaryArray.mergedArray
        } else if let arrayChild = (value as? [Any?])?.first {
            return getChildObjectDictionary(value: arrayChild)
        }
        return [:]
    }
    
    func buildModelFile(json: String, className: String) throws {
        guard let data = json.data(using: .utf8, allowLossyConversion: true) else {
            throw NSError()
        }
        guard let dictionary = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String: Any?] else {
            throw NSError()
        }
        try buildModelFile(dict: dictionary, className: className)
    }
    
    func buildModelFile(dict: [String: Any?], className: String) throws {
        let className = prefix + className + suffix
        
        var properties = [ObjectProperty]()
        for (key, val) in dict {
            let type = getType(key: key, val: val)
            if type.isCustom {
                try buildModelFile(dict: getChildObjectDictionary(value: val), className: key.capitalized)
            }
            properties.append(ObjectProperty(name: key, type: type.type))
        }
        
        try createFile(className: className, properties: properties)
        
    }
    


}
