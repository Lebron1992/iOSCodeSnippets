import Foundation

extension NSError {
    convenience init(domain: String, code: Int, reason: String) {
        let userInfo = [NSLocalizedDescriptionKey: reason]
        self.init(domain: domain, code: code, userInfo: userInfo)
    }
}
