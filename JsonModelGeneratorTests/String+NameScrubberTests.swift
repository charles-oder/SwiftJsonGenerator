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
        XCTAssertEqual("testObject", "testObjects".removePlural)
        XCTAssertEqual("testNews", "testNews".removePlural)
        XCTAssertEqual("testAnalysis", "testAnalyses".removePlural)
        XCTAssertEqual("testDiagnosis", "testDiagnoses".removePlural)
        XCTAssertEqual("testParenthesis", "testParentheses".removePlural)
        XCTAssertEqual("testPrognosis", "testPrognoses".removePlural)
        XCTAssertEqual("testSynopsis", "testSynopses".removePlural)
        XCTAssertEqual("testThesis", "testTheses".removePlural)
        XCTAssertEqual("testAnalysis", "testAnalyses".removePlural)
        XCTAssertEqual("testJealousy", "testJealousies".removePlural)
        XCTAssertEqual("testMouse", "testMice".removePlural)
        XCTAssertEqual("testPerson", "testPeople".removePlural)
        XCTAssertEqual("testMan", "testMen".removePlural)
        XCTAssertEqual("testChild", "testChildren".removePlural)
        XCTAssertEqual("testSex", "testSexes".removePlural)
        XCTAssertEqual("testGoose", "testGeese".removePlural)
        XCTAssertEqual("testAlumna", "testAlumnae".removePlural)
        XCTAssertEqual("testSpecies", "testSpecies".removePlural)
        XCTAssertEqual("testEquipment", "testEquipment".removePlural)
        XCTAssertEqual("testInformation", "testInformation".removePlural)
        XCTAssertEqual("testRice", "testRice".removePlural)
        XCTAssertEqual("testMoney", "testMoney".removePlural)
        XCTAssertEqual("testSeries", "testSeries".removePlural)
        XCTAssertEqual("testFish", "testFish".removePlural)
        XCTAssertEqual("testSheep", "testSheep".removePlural)
        XCTAssertEqual("testDeer", "testDeer".removePlural)
        XCTAssertEqual("testAircraft", "testAircraft".removePlural)
        XCTAssertEqual("testRadius", "testRadii".removePlural)
    }
    
    func testRemovePluralForNonPluralNameEndingInS() {
        let testObject = "testObject".removePlural
        
        XCTAssertEqual("testObject", testObject)
    }
    
    
    
    /*
     
     AddSingular("((a)naly|(b)a|(d)iagno|(p)arenthe|(p)rogno|(s)ynop|(t)he)ses$", "$1$2sis");
     AddSingular("(^analy)ses$", "$1sis");
     AddSingular("([^f])ves$", "$1fe");
     AddSingular("(hive)s$", "$1");
     AddSingular("(tive)s$", "$1");
     AddSingular("([lr])ves$", "$1f");
     AddSingular("([^aeiouy]|qu)ies$", "$1y");
     AddSingular("(s)eries$", "$1eries");
     AddSingular("(m)ovies$", "$1ovie");
     AddSingular("(x|ch|ss|sh)es$", "$1");
     AddSingular("([m|l])ice$", "$1ouse");
     AddSingular("(bus)es$", "$1");
     AddSingular("(o)es$", "$1");
     AddSingular("(shoe)s$", "$1");
     AddSingular("(cris|ax|test)es$", "$1is");
     AddSingular("(octop|vir|alumn|fung)i$", "$1us");
     AddSingular("(alias|status)es$", "$1");
     AddSingular("^(ox)en", "$1");
     AddSingular("(vert|ind)ices$", "$1ex");
     AddSingular("(matr)ices$", "$1ix");
     AddSingular("(quiz)zes$", "$1");
     
     AddUncountable("equipment");
     AddUncountable("information");
     AddUncountable("rice");
     AddUncountable("money");
     AddUncountable("species");
     AddUncountable("series");
     AddUncountable("fish");
     AddUncountable("sheep");
     AddUncountable("deer");
     AddUncountable("aircraft");

 */
}
