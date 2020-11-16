import Foundation

extension Double {
    var stringRemovedZerosFromEnd: String {
        let formatter = NumberFormatter()
        formatter.minimumFractionDigits = 0
        // maximum digits in Double after dot (maximum precision)
        formatter.maximumFractionDigits = 16
        let number = NSNumber(value: self)
        return String(formatter.string(from: number) ?? "")
    }
}
