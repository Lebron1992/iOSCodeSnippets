import UIKit

/// Navigation bar colors for `ColorableNavigationController`, called on `push` & `pop` actions
protocol NavigationBarColorable: class {
    var navigationTintColor: UIColor? { get }
    var navigationBarTintColor: UIColor? { get }
}

extension NavigationBarColorable {
    var navigationTintColor: UIColor? { return nil }
}

/**
 UINavigationController with different colors support of UINavigationBar.
 To use it please adopt needed child view controllers to protocol `NavigationBarColorable`.
 */
class ColorableNavigationController: BaseNavigationController {

    private var previousViewController: UIViewController? {
        guard viewControllers.count > 1 else {
            return nil
        }
        return viewControllers[viewControllers.count - 2]
    }

    override open func pushViewController(_ viewController: UIViewController, animated: Bool) {
        setNavigationBarColors(viewController as? NavigationBarColorable)
        super.pushViewController(viewController, animated: animated)
    }

    override open func popViewController(animated: Bool) -> UIViewController? {
        setNavigationBarColors(previousViewController as? NavigationBarColorable)

        // Let's start pop action or we can't get transitionCoordinator
        let popViewController = super.popViewController(animated: animated)

        // Secure situation if user cancelled transition
        transitionCoordinator?.animate(alongsideTransition: nil, completion: { [weak self] _ in
            self?.setNavigationBarColors(self?.topViewController as? NavigationBarColorable)
        })

        return popViewController
    }

    private func setNavigationBarColors(_ colors: NavigationBarColorable?) {
        // TODO: update default color
        let defaultBarTintColor: UIColor = .white
        let defaultTintColor: UIColor = .black
        let defaultBarButtonTitleDarkModeColor: UIColor = .lightGray
        let defaultBarButtonTitleLightModeColor: UIColor = .darkGray
        
        let barTintColor = colors?.navigationBarTintColor ?? defaultBarTintColor
        let tintColor = colors?.navigationTintColor ?? defaultTintColor

        if #available(iOS 13.0, *) {
            let buttonAppearance: UIBarButtonItemAppearance = {
                let appearance = UIBarButtonItemAppearance(style: .plain)
                let itemAttrs: [NSAttributedString.Key: Any] = [
                    .foregroundColor: UIColor { $0.isDarkMode ? defaultBarButtonTitleDarkModeColor : defaultBarButtonTitleLightModeColor } as Any,
                    .font: UIFont.Forza(style: .medium, size: 15) as Any
                ]
                appearance.normal.titleTextAttributes = itemAttrs
                appearance.highlighted.titleTextAttributes = itemAttrs
                appearance.focused.titleTextAttributes = itemAttrs
                return appearance
            }()

            let appearance: UINavigationBarAppearance = {
                let appearance = UINavigationBarAppearance()
                appearance.backgroundColor = barTintColor
                appearance.shadowImage = UIImage()
                appearance.shadowColor = .clear
                appearance.titleTextAttributes = [
                    .foregroundColor: (colors?.navigationTintColor ?? defaultTintColor) as Any,
                    .font: UIFont.Forza(style: .medium, size: 16)  as Any
                ]
                appearance.buttonAppearance = buttonAppearance
                return appearance
            }()

            navigationBar.standardAppearance = appearance
            navigationBar.scrollEdgeAppearance = appearance

        } else {
            navigationBar.barTintColor = barTintColor
            navigationBar.tintColor = tintColor
            navigationBar.titleTextAttributes = [
                .foregroundColor: tintColor as Any,
                .font: UIFont.Forza(style: .medium, size: 16)  as Any
            ]
        }
    }
}
