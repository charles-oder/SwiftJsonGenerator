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
        let testObject = ObjectProperty(name: "thing", type: "String")
        
        XCTAssertFalse(testObject.isCustomType)
    }
    
    func testIntIsNotCustomType() {
        let testObject = ObjectProperty(name: "thing", type: "Int")
        
        XCTAssertFalse(testObject.isCustomType)
    }
    
    func testDoubleIsNotCustomType() {
        let testObject = ObjectProperty(name: "thing", type: "Double")
        
        XCTAssertFalse(testObject.isCustomType)
    }
    
    func testBoolIsNotCustomType() {
        let testObject = ObjectProperty(name: "thing", type: "Bool")
        
        XCTAssertFalse(testObject.isCustomType)
    }
    
    func testMonkeyIsCustomType() {
        let testObject = ObjectProperty(name: "thing", type: "Monkey")
        
        XCTAssertTrue(testObject.isCustomType)
    }
    
    func testStringArrayIsNotCustomType() {
        let testObject = ObjectProperty(name: "thing", type: "[String]")
        
        XCTAssertFalse(testObject.isCustomType)
    }
    
    func testIntIsArrayNotCustomType() {
        let testObject = ObjectProperty(name: "thing", type: "[Int]")
        
        XCTAssertFalse(testObject.isCustomType)
    }
    
    func testDoubleArrayIsNotCustomType() {
        let testObject = ObjectProperty(name: "thing", type: "[Double]")
        
        XCTAssertFalse(testObject.isCustomType)
    }
    
    func testBoolArrayIsNotCustomType() {
        let testObject = ObjectProperty(name: "thing", type: "[Bool]")
        
        XCTAssertFalse(testObject.isCustomType)
    }
    
    func testMonkeyArrayIsCustomType() {
        let testObject = ObjectProperty(name: "thing", type: "[Monkey]")
        
        XCTAssertTrue(testObject.isCustomType)
    }
    
    func testArrayIsArray() {
        let testObject = ObjectProperty(name: "thing", type: "Monkey")
        
        XCTAssertFalse(testObject.isArray)
    }
    
    func testNonArrayIsNotArray() {
        let testObject = ObjectProperty(name: "thing", type: "[Monkey]")
        
        XCTAssertTrue(testObject.isArray)
    }
    
    
}
