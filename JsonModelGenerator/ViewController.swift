//
//  ViewController.swift
//  JsonModelGenerator
//
//  Created by Charles Oder Dev on 1/19/17.
//
//

import Cocoa

class ViewController: NSViewController {

    @IBOutlet var jsonTextView: NSTextView!
    @IBOutlet weak var directoryField: NSTextField!
    @IBOutlet weak var suffixField: NSTextField!
    @IBOutlet weak var prefixField: NSTextField!
    @IBOutlet weak var baseClassNameField: NSTextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        jsonTextView.isAutomaticQuoteSubstitutionEnabled = false
    }

    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }

    @IBAction func generateButtonClicked(_ sender: Any) {
        guard let json = jsonTextView.string, !json.isEmpty else {
            print("No JSON")
            showError(title: "Error", message: "Please paste json sample in the text box.")
            return
        }

        guard !directoryField.stringValue.isEmpty else {
            showError(title: "Error", message: "Please enter a destination directory.")
            return
        }
        
        guard !baseClassNameField.stringValue.isEmpty else {
            showError(title: "Error", message: "Please enter a base class name.")
            return
        }
        
        guard let data = json.data(using: .utf8, allowLossyConversion: true) else {
            showError(title: "Error", message: "Please enter valid JSON.")
            return
        }
        
        var dict: [String: Any?]?
        do {
            dict = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String: Any?]
            _ = buildModelFile(dict: dict!, location: directoryField.stringValue, prefix: prefixField.stringValue, className: baseClassNameField.stringValue, suffix: suffixField.stringValue)
        } catch  {
            showError(title: "Error", message: "Please enter valid JSON.")
            return
        }
        
        buildSupportFile(location: directoryField.stringValue)
        
    }
    
    func buildSupportFile(location: String) {
        let fileContents = "// JsonExtensions.swift\n" +
            "// Do not add multiple copies of this generated file to your project\n" +
            "// Generated \(Date().description)\n" +
            "import Foundation\n" +
            "\n" +
            "public protocol JsonModel {\n" +
            "    init?(dict:[String: Any?]?)\n" +
            "    var jsonDictionary: [String: Any?] { get }\n" +
            "}\n" +
            "\n" +
            "public extension JsonModel {\n" +
            "    init?(json: String) {\n" +
            "        self.init(dict:json.jsonDict)\n" +
            "    }\n" +
            "\n" +
            "    func serializeDictionary(dict: [String:Any?]) -> String? {\n" +
            "        do {\n" +
            "            let x = try JSONSerialization.data(withJSONObject: dict, options: JSONSerialization.WritingOptions(rawValue: 0))\n" +
            "            return String(data: x, encoding: .utf8)\n" +
            "        } catch {\n" +
            "            return nil\n" +
            "        }\n" +
            "    }\n" +
            "    \n" +
            "    var jsonString: String? {\n" +
            "        return serializeDictionary(dict: jsonDictionary)\n" +
            "    }\n" +
            "\n" +
            "}\n" +
            "\n" +
            "public extension String {\n" +
            "    var jsonDict: [String: Any] {\n" +
            "        do {\n" +
            "            guard let data = data(using: .utf8, allowLossyConversion: true) else { return [:] }\n" +
            "            guard let dict = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String: Any?] else { return [:] }\n" +
            "            return dict\n" +
            "        } catch {\n" +
            "            return [:]\n" +
            "        }\n" +
            "    }\n" +
            "}"
        let fileName = "JsonExtensions.swift"
        let url = URL(fileURLWithPath: location + fileName)
        do {
            try fileContents.data(using: .utf8, allowLossyConversion: true)?.write(to: url)
        } catch {
            showError(title: "Error", message: "Could not write file: \(location)")
            
        }

    }
    
    func buildModelFile(dict: [String: Any?], location: String, prefix: String, className: String, suffix: String) -> String {
        
        let className = prefix + className + suffix
        
        var properties = [ObjectProperty]()
        for (key, val) in dict {
            let type = getType(key: key, val: val, location: location, prefix: prefix, suffix: suffix)
            properties.append(ObjectProperty(name: key, type: type))
        }
        createFile(location: location, className: className, properties: properties)
        
        return className
        
    }
    
    func createFile(location: String, className: String, properties:[ObjectProperty]) {
        let fileName = className + ".swift"
        let url = URL(fileURLWithPath: location + fileName)
        var fileContents = "// \(fileName)\n"
        fileContents += "// Generated \(Date().description)\n"
        fileContents += "\n"
        fileContents += "import Foundation\n"
        fileContents += "\n"
        fileContents += "public struct \(className): JsonModel {\n"
        fileContents += "\n"
        for property in properties {
            fileContents += "    public let \(property.name): \(property.type)?\n"
        }
        fileContents += "\n"
        fileContents += "    public init?(dict:[String: Any?]?) {\n"
        fileContents += "\n"
        for property in properties {
            if property.isCustomType {
                if property.isArray {
                    fileContents += "        if let dictArray = dict?[\"\(property.name)\"] as? [[String: Any?]] {\n"
                    fileContents += "            var objectArray = [\(property.arrayType)]()\n"
                    fileContents += "            for dict in dictArray {\n"
                    fileContents += "                if let obj = \(property.arrayType)(dict:dict){\n"
                    fileContents += "                    objectArray.append(obj)\n"
                    fileContents += "                }\n"
                    fileContents += "            }\n"
                    fileContents += "            \(property.name) = objectArray\n"
                    fileContents += "        } else {\n"
                    fileContents += "            \(property.name) = nil\n"
                    fileContents += "        }\n"
                    
                } else {
                    fileContents += "        \(property.name) = \(property.type)(dict:(dict?[\"\(property.name)\"] as? [String:Any?]))\n"
                }
            } else {
                fileContents += "        \(property.name) = dict?[\"\(property.name)\"] as? \(property.type)\n"
            }
        }
        fileContents += "\n"
        fileContents += "    }\n"
        fileContents += "\n"
        fileContents += "    public var jsonDictionary: [String: Any?] {\n"
        fileContents += "\n"
        fileContents += "        var dict = [String: Any?]()\n"
        for property in properties {
            if property.isCustomType {
                if property.isArray {
                    fileContents += "        if let objArray = \(property.name) {\n"
                    fileContents += "            var dictArray = [[String: Any?]]()\n"
                    fileContents += "            for obj in objArray {\n"
                    fileContents += "                dictArray.append(obj.jsonDictionary)\n"
                    fileContents += "            }\n"
                    fileContents += "            dict[\"\(property.name)\"] = dictArray\n"
                    fileContents += "        }\n"
                    
                } else {
                    fileContents += "        dict[\"\(property.name)\"] = \(property.name)?.jsonDictionary\n"
                }
            } else {
                fileContents += "        dict[\"\(property.name)\"] = \(property.name)\n"
            }

        }
        fileContents += "\n"
        fileContents += "        return dict\n"
        fileContents += "    }\n"
        fileContents += "}\n"
        do {
            try fileContents.data(using: .utf8, allowLossyConversion: true)?.write(to: url)
        } catch {
            showError(title: "Error", message: "Could not write file: \(location)")
            
        }
    }
    
    func getType(key: String, val: Any?, location: String, prefix: String, suffix: String) -> String {
         if let _ = val as? String {
            return "String"
        }
        if let num = val as? Double {
            return num.isReallyAnInt ? "Int" : "Double"
        }
        if let _ = val as? Bool {
            return "Bool"
        }
        if let _ = val as? [String] {
            return "[String]"
        }
        if let numArray = val as? [Double] {
            var type = "[Double]"
            for num in numArray {
                if num.isReallyAnInt {
                    type = "[Int]"
                }
            }
            return type
        }
        if let _ = val as? [Bool] {
            return "[Bool]"
        }
        if let dict = val as? [String: Any?] {
            return buildModelFile(dict: dict, location: location, prefix: prefix, className: key.capitalized, suffix: suffix)
        }
        if let dictArray = val as? [[String: Any?]] {
            let type = buildModelFile(dict: dictArray.mergedArray, location: location, prefix: prefix, className: key.capitalized, suffix: suffix)
            return "[\(type)]"
        }
        return "Any"
    }
    
    func showError(title: String, message: String) {
        let alert = NSAlert()
        alert.alertStyle = .critical
        alert.messageText = title
        alert.informativeText = message
        alert.addButton(withTitle: "OK")
        alert.runModal()
    }
    
}

