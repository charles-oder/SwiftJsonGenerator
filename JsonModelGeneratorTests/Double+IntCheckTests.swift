//
//  Double+IntCheckTests.swift
//  JsonModelGenerator
//
//  Created by Charles Oder Dev on 1/19/17.
//
//

import XCTest
@testable import JsonModelGenerator

class Double_IntCheckTests: XCTestCase {

    func testDoubleIsNotInt() {
        
        XCTAssertFalse(2.1.isReallyAnInt)
        XCTAssertFalse(11.23.isReallyAnInt)
        XCTAssertFalse(2.01.isReallyAnInt)
        XCTAssertFalse(1.5.isReallyAnInt)
        XCTAssertFalse(3.333.isReallyAnInt)
    }

    func testDoubleFromIntIsInt() {
        
        XCTAssertTrue(2.isReallyAnInt)
        XCTAssertTrue(2.isReallyAnInt)
        XCTAssertTrue(11.isReallyAnInt)
        XCTAssertTrue(2.isReallyAnInt)
        XCTAssertTrue(1.isReallyAnInt)
        XCTAssertTrue(3.isReallyAnInt)
    }
    

}
