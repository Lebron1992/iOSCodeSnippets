import UIKit

extension UIDevice {
    static var deviceId: String {
        UIDevice.current.identifierForVendor?.uuidString ?? ""
    }

    static var isPortrait: Bool {
        let screenSize = UIScreen.main.bounds.size
        return screenSize.width < screenSize.height
    }

    static var hasLargeScreen: Bool {
        if isPortrait {
            return UIScreen.height > 667
        }
        return UIScreen.width > 667
    }

    // swiftlint:disable line_length
    // for the screen sizes, refer to https://kapeli.com/cheat_sheets/iOS_Design.docset/Contents/Resources/Documents/index
    static var isGTEIphoneX: Bool {
        if isPortrait {
            return UIScreen.height >= 812
        }
        return UIScreen.width >= 812
    }

    static var isGTEIphoneXR: Bool {
        if isPortrait {
            return UIScreen.height >= 896
        }
        return UIScreen.width >= 896
    }
}
