import UIKit
import SwiftEntryKit

extension UIColor {
    static let calendarHeaderBackgroundColor: UIColor = .hex("#E1E7F2")
    static let calendarDateNormalBackgroundColor: UIColor = .hex("#F7F9FC")
    static let calendarDateSelectedBackgroundColor: UIColor = .hex("#33AD79")
    static let thisMonthDateTextColor: UIColor = .hex("#233C67")
    static let otherMonthDateTextColor: UIColor = .hex("#7888A3")
}

extension EKColor {
    static let calendarDateNormalBackgroundColor: EKColor = .init(
        light: .calendarDateNormalBackgroundColor,
        dark: .calendarDateNormalBackgroundColor
    )
}

extension DateFormatter {
    static let monthHeader: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM yyyy"
        return formatter
    }()

    static let monthFooter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM dd, yyyy"
        return formatter
    }()
}
