//
//  JsonModelGeneratorTests.swift
//  JsonModelGeneratorTests
//
//  Created by Charles Oder Dev on 1/19/17.
//
//

import XCTest
@testable import JsonModelGenerator

class ObjectPropertyTests: XCTestCase {
    
    func testStringIsNotCustomType() {
        let testObject = ObjectProperty(key: "thing", type: "String")
        
        XCTAssertFalse(testObject.isCustomType)
    }
    
    func testIntIsNotCustomType() {
        let testObject = ObjectProperty(key: "thing", type: "Int")
        
        XCTAssertFalse(testObject.isCustomType)
    }
    
    func testDoubleIsNotCustomType() {
        let testObject = ObjectProperty(key: "thing", type: "Double")
        
        XCTAssertFalse(testObject.isCustomType)
    }
    
    func testBoolIsNotCustomType() {
        let testObject = ObjectProperty(key: "thing", type: "Bool")
        
        XCTAssertFalse(testObject.isCustomType)
    }
    
    func testMonkeyIsCustomType() {
        let testObject = ObjectProperty(key: "thing", type: "Monkey")
        
        XCTAssertTrue(testObject.isCustomType)
    }
    
    func testStringArrayIsNotCustomType() {
        let testObject = ObjectProperty(key: "thing", type: "[String]")
        
        XCTAssertFalse(testObject.isCustomType)
    }
    
    func testIntIsArrayNotCustomType() {
        let testObject = ObjectProperty(key: "thing", type: "[Int]")
        
        XCTAssertFalse(testObject.isCustomType)
    }
    
    func testDoubleArrayIsNotCustomType() {
        let testObject = ObjectProperty(key: "thing", type: "[Double]")
        
        XCTAssertFalse(testObject.isCustomType)
    }
    
    func testBoolArrayIsNotCustomType() {
        let testObject = ObjectProperty(key: "thing", type: "[Bool]")
        
        XCTAssertFalse(testObject.isCustomType)
    }
    
    func testMonkeyArrayIsCustomType() {
        let testObject = ObjectProperty(key: "thing", type: "[Monkey]")
        
        XCTAssertTrue(testObject.isCustomType)
    }
    
    func testArrayIsArray() {
        let testObject = ObjectProperty(key: "thing", type: "Monkey")
        
        XCTAssertFalse(testObject.isArray)
    }
    
    func testNonArrayIsNotArray() {
        let testObject = ObjectProperty(key: "thing", type: "[Monkey]")
        
        XCTAssertTrue(testObject.isArray)
    }
    
    func testArrayTypeForStringArray() {
        let testObject = ObjectProperty(key: "thing", type: "[String]")
        
        XCTAssertEqual("String", testObject.arrayType)
    }
    
    func testArrayTypeForCustomArray() {
        let testObject = ObjectProperty(key: "thing", type: "[Monkey]")
        
        XCTAssertEqual("Monkey", testObject.arrayType)
    }
    
    func testNameForKeyWithUnderscores() {
        let testObject = ObjectProperty(key: "the_thing", type: "[Monkey]")
        
        XCTAssertEqual("theThing", testObject.name)
    }
    
    func testNameForKeyWithUnderscorePrefix() {
        let testObject = ObjectProperty(key: "_thing", type: "[Monkey]")
        
        XCTAssertEqual("thing", testObject.name)
    }
    
    
}
