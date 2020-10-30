import UIKit

extension UITraitCollection {
    var isDarkMode: Bool {
        if #available(iOS 12.0, *) {
            return userInterfaceStyle == .dark
        } else {
            return false
        }
    }

    static var isDarkMode: Bool {
        if #available(iOS 13.0, *) {
            return UITraitCollection.current.isDarkMode
        } else {
            return false
        }
    }
}
