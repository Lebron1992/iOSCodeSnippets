import Foundation

extension Encodable {
    var dictionary: [String: Any] {
        let obj = try? JSONSerialization.jsonObject(with: JSONEncoder().encode(self))
        return obj as? [String: Any] ?? [:]
    }
}
