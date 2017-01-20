//
//  JsonExtensionsTests.swift
//  JsonModelGenerator
//
//  Created by Charles Oder Dev on 1/20/17.
//
//

import XCTest
@testable import JsonModelGenerator

struct TestModel: JsonModel {

    public let thing: String?
    
    public init(thing: String?) {
        self.thing = thing
    }
    
    public init?(dict: [String : Any?]?) {
        thing = dict?["thing"] as? String
    }

    public var jsonDictionary: [String : Any?] {
        return ["thing":thing]
    }
    
}

class JsonExtensionsTests: XCTestCase {

    func testGoodJsonCreatesDict() {
        let dict = "{\"thing\":\"one\"}".jsonDict
        
        XCTAssertEqual("one", dict["thing"] as? String)
    }
    
    func testBadJsonCreatesEmptyDict() {
        let dict = "...".jsonDict
        
        XCTAssertEqual(0, dict.count)
    }
    
    func testInitWithJsonString() {
        let testObject = TestModel(json: "{\"thing\":\"one\"}")
        
        XCTAssertEqual("one", testObject?.thing)
    }
    
    func testSerializeToDictionary() {
        let testObject = TestModel(thing: "two")
        
        XCTAssertEqual("two", testObject.jsonDictionary["thing"] as? String)
    }
    
    func testSerializeToJson() {
        let testObject = TestModel(thing: "two")
        
        XCTAssertEqual("{\"thing\":\"two\"}", testObject.jsonString)
    }

}
