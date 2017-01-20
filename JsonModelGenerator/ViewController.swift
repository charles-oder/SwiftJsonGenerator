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
        directoryField.stringValue = "/Users/charlesoder/Documents/"
        jsonTextView.string = "{" +
        "\"aString\":\"sadfasf\"," +
        "\"aDouble\":1.11," +
        "\"anInt\":1," +
        "\"aBool\":true," +
        "\"aStringArray\":[\"one\", \"two\"]," +
        "\"aDoubleArray\":[1.2, 2.3, 3.4]," +
        "\"anIntArray\":[1,2,3,4]," +
        "\"aboolArray\":[true, false, true]," +
            "\"thing\":{\"one\":\"two\"}" +
    "}"
        
        do {
            let url = URL(fileURLWithPath: "/Users/charlesoder/Documents/LargeComplexFIle.json")
            let data = try Data(contentsOf: url)
            let json = String(data: data, encoding: .utf8)
            let obj = BaseClassModel(json: json!)
            let newJson = obj?.jsonString ?? "Nil"
            try newJson.data(using: .utf8, allowLossyConversion: true)?.write(to: URL(fileURLWithPath:"/Users/charlesoder/Documents/Output.json"))
        } catch {}
        
        // Do any additional setup after loading the view.
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
        
        var properties = [(name: String, type: String)]()
        for (key, val) in dict {
            let type = getType(key: key, val: val, location: location, prefix: prefix, suffix: suffix)
            properties.append((name: key, type: type))
        }
        createFile(location: location, className: className, properties: properties)
        
        return className
        
    }
    
    func createFile(location: String, className: String, properties:[(name: String, type: String)]) {
        let fileName = className + ".swift"
        let url = URL(fileURLWithPath: location + fileName)
        var fileContents = "// \(fileName)\n"
        fileContents += "// Generated \(Date().description)\n"
        fileContents += "\n"
        fileContents += "import Foundation\n"
        fileContents += "\n"
        fileContents += "public final class \(className): JsonModel {\n"
        fileContents += "\n"
        for property in properties {
            fileContents += "    public let \(property.name): \(property.type)?\n"
        }
        fileContents += "\n"
        fileContents += "    public init?(dict:[String: Any?]?) {\n"
        fileContents += "\n"
        for property in properties {
            if isCustomType(type: property.type) {
                if isArray(type: property.type) {
                    let type = getArrayType(type: property.type)
                    fileContents += "        if let dictArray = dict?[\"\(property.name)\"] as? [[String: Any?]] {\n"
                    fileContents += "            var objectArray = [\(type)]()\n"
                    fileContents += "            for dict in dictArray {\n"
                    fileContents += "                if let obj = \(type)(dict:dict){\n"
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
            if isCustomType(type: property.type) {
                if isArray(type: property.type) {
                    let type = getArrayType(type: property.type)
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
    
    func isCustomType(type: String) -> Bool {
        return type != "String" && type != "Int" && type != "Double" && type != "Bool" && type != "[String]" && type != "[Int]" && type != "[Double]" && type != "[Bool]"
    }
    
    func getArrayType(type: String) -> String {
        return type.replacingOccurrences(of: "[", with: "").replacingOccurrences(of: "]", with: "")
    }
    
    func isArray(type: String) -> Bool {
        return type.hasPrefix("[") && type.hasSuffix("]")
    }
    
    func getType(key: String, val: Any?, location: String, prefix: String, suffix: String) -> String {
         if let _ = val as? String {
            return "String"
        }
        if let num = val as? Double {
            return isReallyAnInt(num) ? "Int" : "Double"
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
                if isReallyAnInt(num) {
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
            let type = buildModelFile(dict: mergeDictArray(array: dictArray), location: location, prefix: prefix, className: key.capitalized, suffix: suffix)
            return "[\(type)]"
        }
        return "Any"
    }
    
    func isReallyAnInt(_ num: Double) -> Bool {
        return num == Double(Int(num))
    }
    
    func mergeDictArray(array: [[String:Any?]]) -> [String: Any?] {
        var output = [String: Any?]()
        for dict in array {
            for (key, val) in dict {
                output[key] = val
            }
        }
        return output
    }
    
    func showError(title: String, message: String) {
        let alert = NSAlert()
        alert.alertStyle = .critical
        alert.messageText = title
        alert.informativeText = message
        alert.addButton(withTitle: "OK")
        alert.runModal()
    }
    
    func dictionaryProperties(dict: [String: Any?]) -> String {
        var string = ""
        for (key, val) in dict {
            string += "\(key):\(String(describing: type(of: val!)))\r"
        }
        return string
    }

}

