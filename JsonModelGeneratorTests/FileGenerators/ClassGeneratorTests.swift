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
    
    func testInitWithPropertyArgs() {
        let expectedList =  "    public init(\n" +
                            "                thing: String?,\n" +
                            "                otherThing: Int?\n" +
                            "                ) {\n" +
                            "        self.thing = thing\n" +
                            "        self.otherThing = otherThing\n" +
                            "    }\n\n"
        let propertyList = [ObjectProperty(name: "thing", type: "String"), ObjectProperty(name: "otherThing", type: "Int")]
        
        let testString = testObject.createInitWithPropertyArgs(properties: propertyList)
        
        XCTAssertEqual(expectedList, testString)
    }
    
    func testInitWithDictionaryWithPrimitiveTypes() {
        let expectedString =  "    public init?(dictionary:[String: Any?]?) {\n\n" +
            "        self.thing = dictionary?[\"thing\"] as? String\n" +
            "        self.otherThing = dictionary?[\"otherThing\"] as? Int\n\n" +
        "    }\n\n"
        let propertyList = [ObjectProperty(name: "thing", type: "String"), ObjectProperty(name: "otherThing", type: "Int")]
        
        let testString = testObject.createInitWithDictionaryMethod(properties: propertyList)
        
        XCTAssertEqual(expectedString, testString)
    }
    
    func testInitWithDictionaryWithCustomTypes() {
        let expectedString =  "    public init?(dictionary:[String: Any?]?) {\n\n" +
            "        self.thing = Monkey(dictionary:dictionary?[\"thing\"] as? [String:Any?])\n" +
            "        self.otherThing = Banana(dictionary:dictionary?[\"otherThing\"] as? [String:Any?])\n\n" +
        "    }\n\n"
        let propertyList = [ObjectProperty(name: "thing", type: "Monkey"), ObjectProperty(name: "otherThing", type: "Banana")]
        
        let testString = testObject.createInitWithDictionaryMethod(properties: propertyList)
        
        XCTAssertEqual(expectedString, testString)
    }
    
    func testInitWithDictionaryWithCustomTypeArray() {
        let expectedString =  "    public init?(dictionary:[String: Any?]?) {\n\n" +
            "        if let dictionaryArray = dictionary?[\"thing\"] as? [[String:Any?]] {\n" +
            "            var objectArray = [Monkey]()\n" +
            "            for d in dictionaryArray {\n" +
            "                if let object = Monkey(dictionary:d) {\n" +
            "                    objectArray.append(object)\n" +
            "                }\n" +
            "            }\n" +
            "            self.thing = objectArray\n" +
            "        } else {\n" +
            "            self.thing = nil\n" +
            "        }\n\n" +
        "    }\n\n"
        let propertyList = [ObjectProperty(name: "thing", type: "[Monkey]")]
        
        let testString = testObject.createInitWithDictionaryMethod(properties: propertyList)
        
        XCTAssertEqual(expectedString, testString)
    }
    
    func testJsonDictionaryPropertyWithPrimitiveTypes() {
        let expectedString =  "    public var jsonDictionary: [String:Any?] {\n\n" +
            "        var dictionary = [String: Any?]()\n" +
            "        dictionary[\"thing\"] = self.thing\n" +
            "        dictionary[\"otherThing\"] = self.otherThing\n\n" +
            "        return dictionary\n\n" +
        "    }\n\n"
        let propertyList = [ObjectProperty(name: "thing", type: "String"), ObjectProperty(name: "otherThing", type: "Int")]
        
        let testString = testObject.createJsonDictionaryDefinition(properties: propertyList)
        
        XCTAssertEqual(expectedString, testString)
    }
    
    func testJsonDictionaryPropertyWithCustomTypes() {
        let expectedString =  "    public var jsonDictionary: [String:Any?] {\n\n" +
            "        var dictionary = [String: Any?]()\n" +
            "        dictionary[\"thing\"] = self.thing?.jsonDictionary\n" +
            "        dictionary[\"otherThing\"] = self.otherThing?.jsonDictionary\n\n" +
            "        return dictionary\n\n" +
        "    }\n\n"
        let propertyList = [ObjectProperty(name: "thing", type: "Monkey"), ObjectProperty(name: "otherThing", type: "Banana")]
        
        let testString = testObject.createJsonDictionaryDefinition(properties: propertyList)
        
        XCTAssertEqual(expectedString, testString)
    }
    
    func testJsonDictionaryPropertyWithCustomTypeArray() {
        let expectedString =  "    public var jsonDictionary: [String:Any?] {\n\n" +
            "        var dictionary = [String: Any?]()\n" +
            "        if let objectArray = self.thing {\n" +
            "            var dictionaryArray = [[String: Any?]]()\n" +
            "            for object in objectArray {\n" +
            "                dictionaryArray.append(object.jsonDictionary)\n" +
            "            }\n" +
            "            dictionary[\"thing\"] = dictionaryArray\n" +
            "        }\n\n" +
            "        return dictionary\n\n" +
        "    }\n\n"
        let propertyList = [ObjectProperty(name: "thing", type: "[Monkey]")]
        
        let testString = testObject.createJsonDictionaryDefinition(properties: propertyList)
        
        XCTAssertEqual(expectedString, testString)
    }
    
    
    
}
