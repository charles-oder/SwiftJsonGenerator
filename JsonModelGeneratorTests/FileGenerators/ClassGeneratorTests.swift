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
        let expectedList = "    public var thing: String?\n    public var otherThing: Int?\n\n"
        let propertyList = [ObjectProperty(key: "thing", type: "String"), ObjectProperty(key: "otherThing", type: "Int")]
        
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
        let propertyList = [ObjectProperty(key: "thing", type: "String"), ObjectProperty(key: "otherThing", type: "Int")]
        
        let testString = testObject.createInitWithPropertyArgs(properties: propertyList)
        
        XCTAssertEqual(expectedList, testString)
    }
    
    func testInitWithDictionaryWithPrimitiveTypes() {
        let expectedString =  "    public init?(dictionary: [String: Any?]?) {\n\n" +
            "        self.thing = dictionary?[\"thing\"] as? String\n" +
            "        self.otherThing = dictionary?[\"otherThing\"] as? Int\n\n" +
        "    }\n\n"
        let propertyList = [ObjectProperty(key: "thing", type: "String"), ObjectProperty(key: "otherThing", type: "Int")]
        
        let testString = testObject.createInitWithDictionaryMethod(properties: propertyList)
        
        XCTAssertEqual(expectedString, testString)
    }
    
    func testInitWithDictionaryWithCustomTypes() {
        let expectedString =  "    public init?(dictionary: [String: Any?]?) {\n\n" +
            "        self.thing = CustomPropertyFactory.getObject(from: dictionary?[\"thing\"] ?? nil, factory: { (dict) -> (Monkey?) in return Monkey(dictionary: dict) }) as? Monkey\n" +
            "        self.otherThing = CustomPropertyFactory.getObject(from: dictionary?[\"otherThing\"] ?? nil, factory: { (dict) -> (Banana?) in return Banana(dictionary: dict) }) as? Banana\n\n" +
        "    }\n\n"
        let propertyList = [ObjectProperty(key: "thing", type: "Monkey"), ObjectProperty(key: "otherThing", type: "Banana")]
        
        let testString = testObject.createInitWithDictionaryMethod(properties: propertyList)
        
        XCTAssertEqual(expectedString, testString)
    }
    
    func testInitWithDictionaryWithCustomTypeArray() {
        let expectedString =  "    public init?(dictionary: [String: Any?]?) {\n\n" +
            "        self.thing = CustomPropertyFactory.getObject(from: dictionary?[\"thing\"] ?? nil, factory: { (dict) -> (Monkey?) in return Monkey(dictionary: dict) }) as? [Monkey]\n\n" +
        "    }\n\n"
        let propertyList = [ObjectProperty(key: "thing", type: "[Monkey]")]
        
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
        let propertyList = [ObjectProperty(key: "thing", type: "String"), ObjectProperty(key: "otherThing", type: "Int")]
        
        let testString = testObject.createJsonDictionaryDefinition(properties: propertyList)
        
        XCTAssertEqual(expectedString, testString)
    }
    
    func testJsonDictionaryPropertyWithCustomTypes() {
        let expectedString =  "    public var jsonDictionary: [String:Any?] {\n\n" +
            "        var dictionary = [String: Any?]()\n" +
            "        dictionary[\"thing\"] = CustomPropertyFactory.getJsonDictionary(for: self.thing)\n" +
            "        dictionary[\"otherThing\"] = CustomPropertyFactory.getJsonDictionary(for: self.otherThing)\n\n" +
            "        return dictionary\n\n" +
        "    }\n\n"
        let propertyList = [ObjectProperty(key: "thing", type: "Monkey"), ObjectProperty(key: "otherThing", type: "Banana")]
        
        let testString = testObject.createJsonDictionaryDefinition(properties: propertyList)
        
        XCTAssertEqual(expectedString, testString)
    }
    
    func testJsonDictionaryPropertyWithCustomTypeArrayOfArrays() {
        let expectedString =  "    public var jsonDictionary: [String:Any?] {\n\n" +
            "        var dictionary = [String: Any?]()\n" +
            "        dictionary[\"thing\"] = CustomPropertyFactory.getJsonDictionary(for: self.thing)\n\n" +
            "        return dictionary\n\n" +
        "    }\n\n"
        let propertyList = [ObjectProperty(key: "thing", type: "[Monkey]")]
        
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
            "    public var thing: String?\n" +
            "\n" +
            "    public init(\n" +
            "                thing: String?\n" +
            "                ) {\n" +
            "        self.thing = thing\n" +
            "    }\n" +
            "\n" +
            "    public init?(dictionary: [String: Any?]?) {\n" +
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
        
        let propertyList = [ObjectProperty(key: "thing", type: "String")]
        
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
    
    func testCreateClassFileWithUnderscoreProperties() {
        let expectedPrefix = "// TestModel.swift\n" +
            "// Created by SwiftJsonGenerator https://github.com/charles-oder/SwiftJsonGenerator\n" +
        "// Generated "
        let expectedSuffix = "\n" +
            "import Foundation\n" +
            "\n" +
            "public struct TestModel: JsonModel {\n" +
            "\n" +
            "    public var theThing: String?\n" +
            "\n" +
            "    public init(\n" +
            "                theThing: String?\n" +
            "                ) {\n" +
            "        self.theThing = theThing\n" +
            "    }\n" +
            "\n" +
            "    public init?(dictionary: [String: Any?]?) {\n" +
            "\n" +
            "        self.theThing = dictionary?[\"the_thing\"] as? String\n" +
            "\n" +
            "    }\n" +
            "\n" +
            "    public var jsonDictionary: [String:Any?] {\n" +
            "\n" +
            "        var dictionary = [String: Any?]()\n" +
            "        dictionary[\"the_thing\"] = self.theThing\n" +
            "\n" +
            "        return dictionary\n" +
            "\n" +
            "    }\n" +
            "\n" +
        "}\n"
        
        let propertyList = [ObjectProperty(key: "the_thing", type: "String")]
        
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
        let testJson = "{\"thing\":\"something\"}"
        let dictionary = getDictionary(json: testJson)!

        let type = testObject.getType(key: "thing", val: dictionary["thing"]!)
        
        XCTAssertEqual("String", type.type)
        XCTAssertFalse(type.isCustom)
    }
    
    func getDictionary(json: String) -> [String: Any?]? {
        guard let data = json.data(using: .utf8, allowLossyConversion: true) else {
            XCTFail()
            return nil
        }
        do {
            return try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String: Any?]
        } catch {
            XCTFail()
        }
        return nil
        
    }
    
    func testGetTypeForDouble() {
        let testJson = "{\"thing\":1.1}"
        let dictionary = getDictionary(json: testJson)!
        
        let type = testObject.getType(key: "thing", val: dictionary["thing"]!)
        
        XCTAssertEqual("Double", type.type)
        XCTAssertFalse(type.isCustom)
    }
    
    func testGetTypeForInt() {
        let testJson = "{\"thing\":1}"
        let dictionary = getDictionary(json: testJson)!
        
        let type = testObject.getType(key: "thing", val: dictionary["thing"]!)
        
        XCTAssertEqual("Int", type.type)
        XCTAssertFalse(type.isCustom)
    }
    
    func testGetTypeForBool() {
        let testJson = "{\"thing\":true}"
        let dictionary = getDictionary(json: testJson)!
        
        let type = testObject.getType(key: "thing", val: dictionary["thing"]!)
        
        XCTAssertEqual("Bool", type.type)
        XCTAssertFalse(type.isCustom)
    }
    
    func testGetTypeForStringArray() {
        let testJson = "{\"thing\":[\"something\",\"somethingElse\"]}"
        let dictionary = getDictionary(json: testJson)!
        
        let type = testObject.getType(key: "thing", val: dictionary["thing"]!)
        
        XCTAssertEqual("[String]", type.type)
        XCTAssertFalse(type.isCustom)
    }
    
    func testGetTypeForDoubleArray() {
        let testJson = "{\"thing\":[1.1,2.2]}"
        let dictionary = getDictionary(json: testJson)!
        
        let type = testObject.getType(key: "thing", val: dictionary["thing"]!)
        
        XCTAssertEqual("[Double]", type.type)
        XCTAssertFalse(type.isCustom)
    }
    
    func testGetTypeForIntArray() {
        let testJson = "{\"thing\":[1,2]}"
        let dictionary = getDictionary(json: testJson)!
        
        let type = testObject.getType(key: "thing", val: dictionary["thing"]!)
        
        XCTAssertEqual("[Int]", type.type)
        XCTAssertFalse(type.isCustom)
    }
    
    func testGetTypeForBoolArray() {
        let testJson = "{\"thing\":[true, false]}"
        let dictionary = getDictionary(json: testJson)!
        
        let type = testObject.getType(key: "thing", val: dictionary["thing"]!)
        
        XCTAssertEqual("[Bool]", type.type)
        XCTAssertFalse(type.isCustom)
    }
    
    func testGetTypeForCustom() {
        let testJson = "{\"thing\":{\"otherThing\":\"two\"}}"
        let dictionary = getDictionary(json: testJson)!
        
        let type = testObject.getType(key: "thing", val: dictionary["thing"]!)
        
        XCTAssertEqual("TSTThingModel", type.type)
        XCTAssertTrue(type.isCustom)
    }
    
    func testGetTypeForCustomArray() {
        let testJson = "{\"things\":[{\"otherThing\":\"two\"}]}"
        let dictionary = getDictionary(json: testJson)!
        
        let type = testObject.getType(key: "things", val: dictionary["things"]!)
        
        XCTAssertEqual("[TSTThingModel]", type.type)
        XCTAssertTrue(type.isCustom)
    }
    
    func testGetTypeForCustomArrayOfArrays() {
        let testJson = "{\"thing\":[[{\"otherThing\":\"two\"}]]}"
        let dictionary = getDictionary(json: testJson)!
        
        let type = testObject.getType(key: "thing", val: dictionary["thing"]!)
        
        XCTAssertEqual("[[TSTThingModel]]", type.type)
        XCTAssertTrue(type.isCustom)
    }
    
    func testGetChildObjectDictionaryForDictionary() {
        let expectedDict = ["thing":"one"]
        
        let actualDictionary = testObject.getChildObjectDictionary(value: expectedDict)
        
        XCTAssertEqual("one", actualDictionary["thing"] as? String)
    }
    
    func testGetChildObjectDictionaryForArrayOfArrayOfDictionaries() {
        let expectedDict = [[["thing":"one"]]]
        
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
            XCTAssertTrue(base.contains("public var aString: String?"))
            XCTAssertTrue(base.contains("public var aDouble: Double?"))
            XCTAssertTrue(base.contains("public var anInt: Int?"))
            XCTAssertTrue(base.contains("public var aBool: Bool?"))
            XCTAssertTrue(base.contains("public var aStringArray: [String]?"))
            XCTAssertTrue(base.contains("public var aDoubleArray: [Double]?"))
            XCTAssertTrue(base.contains("public var anIntArray: [Int]?"))
            XCTAssertTrue(base.contains("public var aBoolArray: [Bool]?"))
            XCTAssertTrue(base.contains("public var monkey: TSTMonkeyModel?"))
            XCTAssertTrue(base.contains("public var bananas: [TSTBananaModel]?"))
        } catch {
            XCTFail("No base file found")
        }
        do {
            let monkey = try String(contentsOfFile: "/tmp/TSTMonkeyModel.swift")
            XCTAssertTrue(monkey.contains("public var thing: String?"))
        } catch {
            XCTFail("No monkey found")
        }
        do {
            let bananas = try String(contentsOfFile: "/tmp/TSTBananaModel.swift")
            XCTAssertTrue(bananas.contains("public var thing: String?"))
            XCTAssertTrue(bananas.contains("public var anotherThing: Int?"))
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
            XCTAssertTrue(base.contains("public var aString: String?"))
        } catch {
            XCTFail("No base file found")
        }
        
    }
    
}
