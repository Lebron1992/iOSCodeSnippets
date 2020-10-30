import UIKit

extension UIFont {
    enum ForzaFontStyle: String {
        case black  = "Forza-Black"
        case bold   = "Forza-Bold"
        case book   = "Forza-Book"
        case light  = "Forza-Light"
        case medium = "Forza-Medium"
        case thin   = "Forza-Thin"
    }

    static func Forza(style: ForzaFontStyle, size: CGFloat) -> UIFont {
        return UIFont(name: style.rawValue, size: size)!
    }
}
