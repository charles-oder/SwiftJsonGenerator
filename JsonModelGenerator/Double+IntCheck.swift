//
//  Double+IntCheck.swift
//  JsonModelGenerator
//
//  Created by Charles Oder Dev on 1/19/17.
//
//

import Foundation

public extension Double {
    
    var isReallyAnInt: Bool {
        return self == Double(Int(self))
    }
}
