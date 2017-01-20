//
//  Array+JsonDictionaryTests.swift
//  JsonModelGenerator
//
//  Created by Charles Oder Dev on 1/19/17.
//
//

import XCTest
@testable import JsonModelGenerator

class Array_JsonDictionaryTests: XCTestCase {

    func testMergeArrayOfJsonDictionaries() {
        let dict1: [String: Any?] = ["one":1, "two":"two"]
        let dict2: [String: Any?] = ["three":3.0, "four":true]
        
        let mergedDict = [dict1, dict2].mergedArray
        
        XCTAssertEqual(1, mergedDict["one"] as? Int)
        XCTAssertEqual("two", mergedDict["two"] as? String)
        XCTAssertEqual(3.0, mergedDict["three"] as? Double)
        XCTAssertEqual(true, mergedDict["four"] as? Bool)
    }

}
