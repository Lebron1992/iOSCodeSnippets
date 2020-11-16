import Foundation

extension Encodable {
    var dictionary: [String: Any] {
        let obj = try? JSONSerialization.jsonObject(with: Constant.jsonEncoder.encode(self))
        return obj as? [String: Any] ?? [:]
    }
}
