//
//  FileGenerator.swift
//  JsonModelGenerator
//
//  Created by Charles Oder Dev on 1/20/17.
//
//

import Foundation

class FileGenerator {
    
    private var fileLocation: String
    
    init(fileLocation: String) {
        self.fileLocation = fileLocation.hasSuffix("/") ? fileLocation : fileLocation + "/"
    }
    
    func write(body: String, toFile: String) throws {
        let folderUrl = URL(fileURLWithPath: fileLocation, isDirectory: true)
        let url = URL(fileURLWithPath: fileLocation + toFile)
        try FileManager.default.createDirectory(at: folderUrl, withIntermediateDirectories: true, attributes: nil)
        try body.data(using: .utf8, allowLossyConversion: true)?.write(to: url)
    }
}
