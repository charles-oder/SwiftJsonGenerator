//
//  JsonExtensionsTests.swift
//  JsonModelGenerator
//
//  Created by Charles Oder Dev on 1/20/17.
//
//

import XCTest
@testable import JsonModelGenerator

class JsonExtensionsGeneratorTests: XCTestCase {

    let testLocation = "/tmp/"
    
    override func setUp() {
        super.setUp()
        do {
            try FileManager.default.removeItem(at: URL(fileURLWithPath: testLocation + "JsonExtensions.swift"))
        } catch {
            // don't really care
        }
    }
    
    func testCreateJsonExtensionFile() {
        let testObject = JsonExtensionsGenerator(fileLocation: testLocation)
        do {
            try testObject.buildSupportFile()
        } catch {
            XCTFail("Could not write support file")
        }
        var storedFile: String?
        do {
            storedFile = try String(contentsOf: URL(fileURLWithPath: testLocation + "JsonExtensions.swift"))
        } catch {
            XCTFail("Could not read support file")
        }
        
        XCTAssertTrue(storedFile?.contains("public protocol JsonModel") == true)
    }

}
