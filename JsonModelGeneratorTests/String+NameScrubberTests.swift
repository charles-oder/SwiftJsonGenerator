//
//  String+NameScrubberTests.swift
//  JsonModelGenerator
//
//  Created by Charles Oder Dev on 2/9/17.
//
//

import XCTest
@testable import JsonModelGenerator

class String_NameScrubberTests: XCTestCase {

    func testUnderscoresRemovedFromClassName() {
        let testObject = "test_objectOne".scrubbedClassName
        
        XCTAssertEqual("TestObjectOne", testObject)
    }

    func testUnderscoresRemovedFromPropertyName() {
        let testObject = "test_objectOne".scrubbedProperyName
        
        XCTAssertEqual("testObjectOne", testObject)
    }
    
    func testUnderscorePrefixRemovedFromClassName() {
        let testObject = "_testObject".scrubbedClassName
        
        XCTAssertEqual("TestObject", testObject)
    }
    
    func testUnderscorePrefixRemovedFromPropertyName() {
        let testObject = "_testObject".scrubbedProperyName
        
        XCTAssertEqual("testObject", testObject)
    }
    
    func testRemovePluralForPluralName() {
        let testObject = "testObjects".removePlural
        
        XCTAssertEqual("testObject", testObject)
    }
    
    func testRemovePluralForNonPluralName() {
        let testObject = "testObject".removePlural
        
        XCTAssertEqual("testObject", testObject)
    }
}
