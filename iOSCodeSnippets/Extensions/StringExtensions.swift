import Foundation
import UIKit

// MARK: - Properties
extension String {
    var isEmail: Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        let emailPred = NSPredicate(format: "SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: self)
    }
}

// MARK: - Methods
extension String {
    func trim() -> String {
        trimmingCharacters(in: .whitespacesAndNewlines)
    }
    
    func removedZeroInTheEndForDouble() -> String {
        guard self.contains(".") else {
            return self
        }

        let components = split(separator: ".")
        let left = components[0]
        let right = components[1].removedZeroInTheEnd()

        if right == "" {
            return String(left)
        }
        return "\(left).\(right)"
    }
    
    func convertHtml() -> NSAttributedString {
        guard let data = data(using: .utf8) else {
            return NSAttributedString()
        }
        do {
            return try NSAttributedString(
                data: data,
                options: [
                    .documentType: NSAttributedString.DocumentType.html,
                    .characterEncoding: String.Encoding.utf8.rawValue
                ],
                documentAttributes: nil
            )
        } catch {
            return NSAttributedString()
        }
    }
    
    static func random(length: Int) -> String {
      let letters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
      return String((0..<length).map { _ in letters.randomElement()! })
    }
}

extension String {
    func boundingRect(
        with size: CGSize,
        options: NSStringDrawingOptions,
        attributes: [NSAttributedString.Key: Any]?,
        context: NSStringDrawingContext?
    ) -> CGRect {
        (self as NSString).boundingRect(
            with: size,
            options: options,
            attributes: attributes,
            context: context
        )
    }
}

extension Substring {
    fileprivate func removedZeroInTheEnd() -> String {
        var str = self
        while str.last == "0" {
            str.removeLast()
        }
        return String(str)
    }
}

// MARK: - Optional
extension Optional where Wrapped == String {
    var isEmpty: Bool {
        if let str = self {
            return str.isEmpty
        }
        return true
    }
}
