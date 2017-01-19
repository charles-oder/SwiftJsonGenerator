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
        
        // Do any additional setup after loading the view.
    }

    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }

    @IBAction func generateButtonClicked(_ sender: Any) {
        guard let text = jsonTextView.string, !text.isEmpty else {
            print("No JSON")
            showError(title: "Error", message: "Please paste json sample in the text box.")
            return
        }
        let json = text

        guard let data = json.data(using: .utf8, allowLossyConversion: true) else {
            print("NO DATA: \(text)")
            showError(title: "Error", message: "Please enter valid JSON.")
            return
        }

        var dict: [String: Any?]?
        do {
            dict = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String: Any?]
        } catch  {
            showError(title: "Error", message: "Please enter valid JSON.")
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
        
        let desc = dictionaryProperties(dict: dict!)
        
        let location = directoryField.stringValue + prefixField.stringValue + baseClassNameField.stringValue + suffixField.stringValue + ".swift"
        
        do {
            try desc.data(using: .utf8, allowLossyConversion: true)?.write(to: URL(fileURLWithPath: location))
        } catch {
            showError(title: "Error", message: "Could not write file: \(location)")

        }
        
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

