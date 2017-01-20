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
        
        do {
            try JsonExtensionsGenerator(fileLocation: directoryField.stringValue).buildSupportFile()
        } catch {
            showError(title: "Error", message: "Could not create JsonExtensions file in directory: \(directoryField.stringValue)")
        }
        showSuccess(title: "Success!", message: "Model Files Generated")
        
    }
    
    func buildModelFile(dict: [String: Any?], location: String, prefix: String, className: String, suffix: String) -> String {
        
        let className = prefix + className + suffix
        
        var properties = [ObjectProperty]()
        for (key, val) in dict {
            let type = getType(key: key, val: val, location: location, prefix: prefix, suffix: suffix)
            properties.append(ObjectProperty(name: key, type: type))
        }
        do {
            try ClassGenerator(fileLocation: location).createFile(className: className, properties: properties)
        } catch {
            showError(title: "Error", message: "Could not write file: \(location)")
        }
        
        return className
        
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
    
    func showSuccess(title: String, message: String) {
        let alert = NSAlert()
        alert.alertStyle = .informational
        alert.messageText = title
        alert.informativeText = message
        alert.addButton(withTitle: "OK")
        alert.runModal()
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

