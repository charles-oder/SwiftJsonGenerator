//
//  ClassGeneratorTests.swift
//  JsonModelGenerator
//
//  Created by Charles Oder Dev on 1/20/17.
//
//

import XCTest
@testable import JsonModelGenerator

class ClassGeneratorTests: XCTestCase {

    var testObject: ClassGenerator!
    
    override func setUp() {
        super.setUp()
        TestFileManager().deleteTempSwiftFiles(path: "/tmp")
        testObject = ClassGenerator(fileLocation: "/tmp")
    }
    
    override func tearDown() {
        TestFileManager().deleteTempSwiftFiles(path: "/tmp")
        super.tearDown()
    }

    func testHeaders() {
        let expectedPrefix = "// TestFile.swift\n// Created by SwiftJsonGenerator https://github.com/charles-oder/SwiftJsonGenerator\n// Generated "
        let expectedSuffix = "\n\nimport Foundation\n\n"
        let testString = testObject.createHeaders(className: "TestFile")
        
        XCTAssertTrue(testString.hasPrefix(expectedPrefix))
        XCTAssertTrue(testString.hasSuffix(expectedSuffix))
        
    }
    
    func testClassDeclaration() {
        let expectedClassDeclaration = "public struct TestFile: JsonModel {\n\n"
        
        let testString = testObject.createClassDeclaration(className: "TestFile")
        
        XCTAssertEqual(expectedClassDeclaration, testString)
    }
    
    func testPropertyList() {
        let expectedList = "    public let thing: String?\n    public let otherThing: Int?\n\n"
        let propertyList = [ObjectProperty(name: "thing", type: "String"), ObjectProperty(name: "otherThing", type: "Int")]
        
        let testString = testObject.createPropertyList(properties: propertyList)
        
        XCTAssertEqual(expectedList, testString)
    }

}
