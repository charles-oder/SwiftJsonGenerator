//
//  Array+JsonDictionary.swift
//  JsonModelGenerator
//
//  Created by Charles Oder Dev on 1/19/17.
//
//

import Foundation

extension Collection where Iterator.Element == [String: Any?] {
    var mergedArray: [String: Any?] {
        var output = [String: Any?]()
        for dict in self {
            for (key, val) in dict {
                output[key] = val
            }
        }
        return output
    }
}
