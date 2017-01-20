//
//  TestFileManager.swift
//  JsonModelGenerator
//
//  Created by Charles Oder Dev on 1/20/17.
//
//

import Foundation

class TestFileManager {
    
    func deleteTempSwiftFiles(path: String) {
        do {
            let fileManager = FileManager.default
            let enumerator = fileManager.enumerator(atPath: path)
            while let file = enumerator?.nextObject() as? String {
                if file.hasSuffix(".swift") {
                    try fileManager.removeItem(at: URL(fileURLWithPath: path + "/" + file))
                }
            }
        } catch {
            // Don't care
        }
    }
    

}
