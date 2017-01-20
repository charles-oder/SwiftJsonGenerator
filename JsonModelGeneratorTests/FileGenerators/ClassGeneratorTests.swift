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
        testObject = ClassGenerator(fileLocation: "/tmp/", prefix: "TST", suffix: "Model")
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
    
    func testCreateFooter() {
        let expectedFooter = "}\n"
        
        let testString = testObject.createFooter()
        
        XCTAssertEqual(expectedFooter, testString)
    }
    
    func testCreateClassFile() {
        let expectedPrefix = "// TestModel.swift\n" +
        "// Created by SwiftJsonGenerator https://github.com/charles-oder/SwiftJsonGenerator\n" +
        "// Generated "
        let expectedSuffix = "\n" +
        "import Foundation\n" +
        "\n" +
        "public struct TestModel: JsonModel {\n" +
        "\n" +
        "    public let thing: String?\n" +
        "\n" +
        "    public init(\n" +
        "                thing: String?\n" +
        "                ) {\n" +
        "        self.thing = thing\n" +
        "    }\n" +
        "\n" +
        "    public init?(dictionary:[String: Any?]?) {\n" +
        "\n" +
        "        self.thing = dictionary?[\"thing\"] as? String\n" +
        "\n" +
        "    }\n" +
        "\n" +
        "    public var jsonDictionary: [String:Any?] {\n" +
        "\n" +
        "        var dictionary = [String: Any?]()\n" +
        "        dictionary[\"thing\"] = self.thing\n" +
        "\n" +
        "        return dictionary\n" +
        "\n" +
        "    }\n" +
        "\n" +
        "}\n"
        
        let propertyList = [ObjectProperty(name: "thing", type: "String")]
        
        do {
            try testObject.createFile(className: "TestModel", properties: propertyList)
        } catch {
            XCTFail("Failed to create file")
        }
        
        var testFile: String?
        do {
            testFile = try String(contentsOf: URL(fileURLWithPath: "/tmp/TestModel.swift"))
        } catch {
            XCTFail("Test file not found")
        }
        
        XCTAssertTrue(testFile?.hasPrefix(expectedPrefix) == true)
        XCTAssertTrue(testFile?.hasSuffix(expectedSuffix) == true)
    }
    
    func testGetTypeForString() {
        let value = "something"
        
        let type = testObject.getType(key: "thing", val: value)
        
        XCTAssertEqual("String", type.type)
        XCTAssertFalse(type.isCustom)
    }
    
    func testGetTypeForDouble() {
        let value = Double(1.1)
        
        let type = testObject.getType(key: "thing", val: value)
        
        XCTAssertEqual("Double", type.type)
        XCTAssertFalse(type.isCustom)
    }
    
    func testGetTypeForInt() {
        let value = Double(1)
        
        let type = testObject.getType(key: "thing", val: value)
        
        XCTAssertEqual("Int", type.type)
        XCTAssertFalse(type.isCustom)
    }
    
    func testGetTypeForBool() {
        let value = true
        
        let type = testObject.getType(key: "thing", val: value)
        
        XCTAssertEqual("Bool", type.type)
        XCTAssertFalse(type.isCustom)
    }
    
    func testGetTypeForStringArray() {
        let value = ["something"]
        
        let type = testObject.getType(key: "thing", val: value)
        
        XCTAssertEqual("[String]", type.type)
        XCTAssertFalse(type.isCustom)
    }
    
    func testGetTypeForDoubleArray() {
        let value = [Double(1.1)]
        
        let type = testObject.getType(key: "thing", val: value)
        
        XCTAssertEqual("[Double]", type.type)
        XCTAssertFalse(type.isCustom)
    }
    
    func testGetTypeForIntArray() {
        let value = [Double(1)]
        
        let type = testObject.getType(key: "thing", val: value)
        
        XCTAssertEqual("[Int]", type.type)
        XCTAssertFalse(type.isCustom)
    }
    
    func testGetTypeForBoolArray() {
        let value = [true]
        
        let type = testObject.getType(key: "thing", val: value)
        
        XCTAssertEqual("[Bool]", type.type)
        XCTAssertFalse(type.isCustom)
    }
    
    func testGetTypeForCustom() {
        let value = [String:Any?]()
        
        let type = testObject.getType(key: "thing", val: value)
        
        XCTAssertEqual("TSTThingModel", type.type)
        XCTAssertTrue(type.isCustom)
    }
    
    func testGetTypeForCustomArray() {
        let value = [[String:Any?]()]
        
        let type = testObject.getType(key: "thing", val: value)
        
        XCTAssertEqual("[TSTThingModel]", type.type)
        XCTAssertTrue(type.isCustom)
    }
    
    func testGetChildObjectDictionaryForDictionary() {
        let expectedDict = ["thing":"one"]
        
        let actualDictionary = testObject.getChildObjectDictionary(value: expectedDict)
        
        XCTAssertEqual("one", actualDictionary["thing"] as? String)
    }
    
    func testGetChildObjectDictionaryForDictionaryArray() {
        let expectedDict = [["thing":"one"], ["otherThing":"two"]]
        
        let actualDictionary = testObject.getChildObjectDictionary(value: expectedDict)
        
        XCTAssertEqual("one", actualDictionary["thing"] as? String)
        XCTAssertEqual("two", actualDictionary["otherThing"] as? String)
    }
    
    func testBuildClassHeirarchy() {
        let testJson = "{\"aString\":\"one\", \"aDouble\": 2.1, \"anInt\": 3, \"aBool\":true, \"aStringArray\":[\"one\", \"two\"], \"aDoubleArray\":[1.1, 2.2], \"anIntArray\":[1, 2], \"aBoolArray\":[true, false], \"monkey\":{\"thing\":\"one\"}, \"bananas\":[{\"thing\":\"one\", \"anotherThing\":2}]}"
        
        do {
            try testObject.buildModelFile(json: testJson, className: "Base")
        } catch {
            XCTFail("Failed to create files")
        }
        
        do {
            let base = try String(contentsOfFile: "/tmp/TSTBaseModel.swift")
            XCTAssertTrue(base.contains("public let aString: String?"))
            XCTAssertTrue(base.contains("public let aDouble: Double?"))
            XCTAssertTrue(base.contains("public let anInt: Int?"))
            XCTAssertTrue(base.contains("public let aBool: Bool?"))
            XCTAssertTrue(base.contains("public let aStringArray: [String]?"))
            XCTAssertTrue(base.contains("public let aDoubleArray: [Double]?"))
            XCTAssertTrue(base.contains("public let anIntArray: [Int]?"))
            XCTAssertTrue(base.contains("public let aBoolArray: [Bool]?"))
            XCTAssertTrue(base.contains("public let monkey: TSTMonkeyModel?"))
            XCTAssertTrue(base.contains("public let bananas: [TSTBananasModel]?"))
        } catch {
            XCTFail("No base file found")
        }
        do {
            let monkey = try String(contentsOfFile: "/tmp/TSTMonkeyModel.swift")
            XCTAssertTrue(monkey.contains("public let thing: String?"))
        } catch {
            XCTFail("No monkey found")
        }
        do {
            let bananas = try String(contentsOfFile: "/tmp/TSTBananasModel.swift")
            XCTAssertTrue(bananas.contains("public let thing: String?"))
            XCTAssertTrue(bananas.contains("public let anotherThing: Int?"))
        } catch {
            XCTFail("No bananas found")
        }
        
    }
    
    func testBuildFileWithNoTrailingSlashInDirectory() {
        testObject = ClassGenerator(fileLocation: "/tmp", prefix: "BAM", suffix: "Payload")
        let testJson = "{\"aString\":\"one\"}"
        
        do {
            try testObject.buildModelFile(json: testJson, className: "Base")
        } catch {
            XCTFail("Failed to create files")
        }
        
        do {
            let base = try String(contentsOfFile: "/tmp/BAMBasePayload.swift")
            XCTAssertTrue(base.contains("public let aString: String?"))
        } catch {
            XCTFail("No base file found")
        }
        
    }
    
}
