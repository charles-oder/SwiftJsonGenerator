// JsonExtensions.swift

// Do not add multiple copies of this generated file to your project
// Generated 2017-01-20 03:34:35 +0000
import Foundation

public protocol JsonModel {
    init?(dictionary:[String: Any?]?)
    var jsonDictionary: [String: Any?] { get }
}

public extension JsonModel {
    public init?(json: String) {
        self.init(dictionary:json.jsonDict)
    }

    public func serializeDictionary(dictionary: [String:Any?]) -> String? {
        do {
            let x = try JSONSerialization.data(withJSONObject: dictionary, options: JSONSerialization.WritingOptions(rawValue: 0))
            return String(data: x, encoding: .utf8)
        } catch {
            return nil
        }
    }
    
    public var jsonString: String? {
        return serializeDictionary(dictionary: jsonDictionary)
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
