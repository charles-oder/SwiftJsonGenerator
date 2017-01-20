// JsonExtensions.swift
// Do not add multiple copies of this generated file to your project
// Generated 2017-01-20 03:34:35 +0000
import Foundation

public protocol JsonModel {
    init?(dict:[String: Any?]?)
    var jsonDictionary: [String: Any?] { get }
}

public extension JsonModel {
    init?(json: String) {
        self.init(dict:json.jsonDict)
    }

    func serializeDictionary(dict: [String:Any?]) -> String? {
        do {
            let x = try JSONSerialization.data(withJSONObject: dict, options: JSONSerialization.WritingOptions(rawValue: 0))
            return String(data: x, encoding: .utf8)
        } catch {
            return nil
        }
    }
    
    var jsonString: String? {
        return serializeDictionary(dict: jsonDictionary)
    }

}

public extension String {
    var jsonDict: [String: Any] {
        do {
            guard let data = data(using: .utf8, allowLossyConversion: true) else { return [:] }
            guard let dict = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String: Any?] else { return [:] }
            return dict
        } catch {
            return [:]
        }
    }
}
