import UIKit

class BaseNavigationController: UINavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override var preferredStatusBarStyle: UIStatusBarStyle {
        topViewController?.preferredStatusBarStyle ?? .default
    }

    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        // update image for back button item
        viewControllers.forEach { vc in
            let tag = vc.navigationItem.leftBarButtonItem?.tag
            switch tag {
            case UIBarButtonItemTag.backButtonItem.rawValue:
                vc.navigationItem.leftBarButtonItem = vc.backButtonItem

            case UIBarButtonItemTag.closeButtonItem.rawValue:
                vc.navigationItem.leftBarButtonItem = vc.closeButtonItem

            default: break
            }
        }
    }
}
