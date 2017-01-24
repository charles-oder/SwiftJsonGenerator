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
        let classGenerator = ClassGenerator(fileLocation: directoryField.stringValue, prefix: prefixField.stringValue, suffix: suffixField.stringValue)
        var dict: [String: Any?]?
        do {
            dict = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String: Any?]
        } catch  {
            showError(title: "Error", message: "Please enter valid JSON.")
            return
        }
        
        do {
            try classGenerator.buildModelFile(dict: dict!, className: baseClassNameField.stringValue)
        } catch {
            showError(title: "Error", message: "Unable to generate class files: \(error.localizedDescription)")
            return
        }
        
        do {
            try JsonExtensionsGenerator(fileLocation: directoryField.stringValue).buildSupportFile()
        } catch {
            showError(title: "Error", message: "Could not create JsonExtensions file in directory: \(directoryField.stringValue)")
        }
        showSuccess(title: "Success!", message: "Model Files Generated")
        
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

