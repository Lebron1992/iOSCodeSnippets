import UIKit

extension UIView {

    // MARK: - Constraints

    func constraintEdges(to superview: UIView, useSafeArea: Bool = true) {
        translatesAutoresizingMaskIntoConstraints = false
        if #available(iOS 11.0, *), useSafeArea {
            NSLayoutConstraint.activate([
                topAnchor.constraint(equalTo: superview.safeAreaLayoutGuide.topAnchor),
                bottomAnchor.constraint(equalTo: superview.safeAreaLayoutGuide.bottomAnchor),
                leadingAnchor.constraint(equalTo: superview.safeAreaLayoutGuide.leadingAnchor),
                trailingAnchor.constraint(equalTo: superview.safeAreaLayoutGuide.trailingAnchor)
            ])
        } else {
            NSLayoutConstraint.activate([
                topAnchor.constraint(equalTo: superview.topAnchor),
                bottomAnchor.constraint(equalTo: superview.bottomAnchor),
                leadingAnchor.constraint(equalTo: superview.leadingAnchor),
                trailingAnchor.constraint(equalTo: superview.trailingAnchor)
            ])
        }
    }

    func setSubviewsTranslatingMasksToConstraints(
        to value: Bool,
        except: UIView? = nil
    ) {
        subviews.forEach { (subview) in
            if subview === except {
                return
            }
            subview.translatesAutoresizingMaskIntoConstraints = value
            if subview.subviews.count > 0 {
                subview.setSubviewsTranslatingMasksToConstraints(to: value, except: except)
            }
        }
    }
}

// MARK: - Corner & Border
extension UIView {
    func roundCorners(corners: UIRectCorner, radius: CGFloat) {
        let path = UIBezierPath(
            roundedRect: bounds,
            byRoundingCorners: corners,
            cornerRadii: CGSize(width: radius, height: radius)
        )
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        layer.mask = mask
    }

    enum ViewSide {
        case top
        case right
        case bottom
        case left
    }

    func createBorder(
        side: ViewSide, thickness: CGFloat, color: UIColor,
        leftOffset: CGFloat = 0, rightOffset: CGFloat = 0,
        topOffset: CGFloat = 0, bottomOffset: CGFloat = 0
    ) -> CALayer {

        switch side {
        case .top:
            // Bottom Offset Has No Effect
            // Subtract the bottomOffset from the height and the thickness to get our final y position.
            // Add a left offset to our x to get our x position.
            // Minus our rightOffset and negate the leftOffset from the width to get our endpoint for the border.
            return _getOneSidedBorder(
                frame: CGRect(
                    x: 0 + leftOffset,
                    y: 0 + topOffset,
                    width: self.frame.size.width - leftOffset - rightOffset,
                    height: thickness),
                color: color
            )
        case .right:
            // Left Has No Effect
            // Subtract bottomOffset from the height to get our end.
            return _getOneSidedBorder(
                frame: CGRect(
                    x: self.frame.size.width - thickness - rightOffset,
                    y: 0 + topOffset,
                    width: thickness,
                    height: self.frame.size.height),
                color: color
            )
        case .bottom:
            // Top has No Effect
            // Subtract the bottomOffset from the height and the thickness to get our final y position.
            // Add a left offset to our x to get our x position.
            // Minus our rightOffset and negate the leftOffset from the width to get our endpoint for the border.
            return _getOneSidedBorder(
                frame: CGRect(
                    x: 0 + leftOffset,
                    y: self.frame.size.height-thickness-bottomOffset,
                    width: self.frame.size.width - leftOffset - rightOffset,
                    height: thickness),
                color: color
            )
        case .left:
            // Right Has No Effect
            return _getOneSidedBorder(
                frame: CGRect(
                    x: 0 + leftOffset,
                    y: 0 + topOffset,
                    width: thickness,
                    height: self.frame.size.height - topOffset - bottomOffset),
                color: color
            )
        }
    }

    func createViewBackedBorder(
        side: ViewSide, thickness: CGFloat,
        color: UIColor, leftOffset: CGFloat = 0,
        rightOffset: CGFloat = 0, topOffset: CGFloat = 0,
        bottomOffset: CGFloat = 0
    ) -> UIView {

        switch side {
        case .top:
            let border: UIView =
                _getViewBackedOneSidedBorder(
                    frame: CGRect(
                        x: 0 + leftOffset,
                        y: 0 + topOffset,
                        width: self.frame.size.width - leftOffset - rightOffset,
                        height: thickness),
                    color: color
                )
            border.autoresizingMask = [.flexibleWidth, .flexibleBottomMargin]
            return border

        case .right:
            let border: UIView =
                _getViewBackedOneSidedBorder(
                    frame: CGRect(
                        x: self.frame.size.width-thickness-rightOffset,
                        y: 0 + topOffset,
                        width: thickness,
                        height: self.frame.size.height - topOffset - bottomOffset),
                    color: color
                )
            border.autoresizingMask = [.flexibleHeight, .flexibleLeftMargin]
            return border

        case .bottom:
            let border: UIView =
                _getViewBackedOneSidedBorder(
                    frame: CGRect(
                        x: 0 + leftOffset,
                        y: self.frame.size.height-thickness-bottomOffset,
                        width: self.frame.size.width - leftOffset - rightOffset,
                        height: thickness),
                    color: color
                )
            border.autoresizingMask = [.flexibleWidth, .flexibleTopMargin]
            return border

        case .left:
            let border: UIView =
                _getViewBackedOneSidedBorder(
                    frame: CGRect(
                        x: 0 + leftOffset,
                        y: 0 + topOffset,
                        width: thickness,
                        height: self.frame.size.height - topOffset - bottomOffset),
                    color: color
                )
            border.autoresizingMask = [.flexibleHeight, .flexibleRightMargin]
            return border
        }
    }

    func addBorder(
        side: ViewSide, thickness: CGFloat,
        color: UIColor, opacity: Float = 1,
        leftOffset: CGFloat = 0, rightOffset: CGFloat = 0,
        topOffset: CGFloat = 0, bottomOffset: CGFloat = 0
    ) {
        switch side {
        case .top:
            // Add leftOffset to our X to get start X position.
            // Add topOffset to Y to get start Y position
            // Subtract left offset from width to negate shifting from leftOffset.
            // Subtract rightoffset from width to set end X and Width.
            let border: CALayer = _getOneSidedBorder(
                    frame: CGRect(
                        x: 0 + leftOffset,
                        y: 0 + topOffset,
                        width: self.frame.size.width - leftOffset - rightOffset,
                        height: thickness),
                    color: color,
                    opacity: opacity
                )
            self.layer.addSublayer(border)
        case .right:
            // Subtract the rightOffset from our width + thickness to get our final x position.
            // Add topOffset to our y to get our start y position.
            // Subtract topOffset from our height, so our border doesn't extend past teh view.
            // Subtract bottomOffset from the height to get our end.
            let border: CALayer = _getOneSidedBorder(
                frame: CGRect(
                    x: self.frame.size.width-thickness-rightOffset,
                    y: 0 + topOffset, width: thickness,
                    height: self.frame.size.height - topOffset - bottomOffset),
                color: color,
                opacity: opacity
            )
            self.layer.addSublayer(border)
        case .bottom:
            // Subtract the bottomOffset from the height and the thickness to get our final y position.
            // Add a left offset to our x to get our x position.
            // Minus our rightOffset and negate the leftOffset from the width to get our endpoint for the border.
            let border: CALayer = _getOneSidedBorder(
                    frame: CGRect(
                        x: 0 + leftOffset,
                        y: self.frame.size.height-thickness-bottomOffset,
                        width: self.frame.size.width - leftOffset - rightOffset,
                        height: thickness),
                    color: color,
                    opacity: opacity
                )
            self.layer.addSublayer(border)
        case .left:
            let border: CALayer = _getOneSidedBorder(
                    frame: CGRect(
                        x: 0 + leftOffset,
                        y: 0 + topOffset,
                        width: thickness,
                        height: self.frame.size.height - topOffset - bottomOffset),
                    color: color,
                    opacity: opacity
                )
            self.layer.addSublayer(border)
        }
    }

    func addViewBackedBorder(
        side: ViewSide, thickness: CGFloat,
        color: UIColor, alpha: CGFloat = 1,
        leftOffset: CGFloat = 0, rightOffset: CGFloat = 0,
        topOffset: CGFloat = 0,
        bottomOffset: CGFloat = 0
    ) {
        switch side {
        case .top:
            let border: UIView = _getViewBackedOneSidedBorder(
                frame: CGRect(
                    x: 0 + leftOffset,
                    y: 0 + topOffset,
                    width: self.frame.size.width - leftOffset - rightOffset,
                    height: thickness),
                color: color,
                alpha: alpha
            )
            border.autoresizingMask = [.flexibleWidth, .flexibleBottomMargin]
            self.addSubview(border)

        case .right:
            let border: UIView = _getViewBackedOneSidedBorder(
                frame: CGRect(
                    x: self.frame.size.width-thickness-rightOffset,
                    y: 0 + topOffset,
                    width: thickness,
                    height: self.frame.size.height - topOffset - bottomOffset),
                color: color,
                alpha: alpha
            )
            border.autoresizingMask = [.flexibleHeight, .flexibleLeftMargin]
            self.addSubview(border)

        case .bottom:
            let border: UIView = _getViewBackedOneSidedBorder(
                frame: CGRect(
                    x: 0 + leftOffset,
                    y: self.frame.size.height-thickness-bottomOffset,
                    width: self.frame.size.width - leftOffset - rightOffset,
                    height: thickness),
                color: color,
                alpha: alpha
            )
            border.autoresizingMask = [.flexibleWidth, .flexibleTopMargin]
            self.addSubview(border)
        case .left:
            let border: UIView = _getViewBackedOneSidedBorder(
                frame: CGRect(
                    x: 0 + leftOffset,
                    y: 0 + topOffset,
                    width: thickness,
                    height: self.frame.size.height - topOffset - bottomOffset),
                color: color,
                alpha: alpha
            )
            border.autoresizingMask = [.flexibleHeight, .flexibleRightMargin]
            self.addSubview(border)
        }
    }

    //////////
    // Private: Our methods call these to add their borders.
    //////////

    private func _getOneSidedBorder(frame: CGRect, color: UIColor, opacity: Float = 1) -> CALayer {
        let border: CALayer = CALayer()
        border.frame = frame
        border.backgroundColor = color.cgColor
        border.opacity = opacity
        return border
    }

    private func _getViewBackedOneSidedBorder(frame: CGRect, color: UIColor, alpha: CGFloat = 1) -> UIView {
        let border: UIView = UIView.init(frame: frame)
        border.backgroundColor = color
        border.alpha = alpha
        return border
    }
}

// MARK: - Take Screenshot
extension UIView {
    func toImage() -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(bounds.size, false, 0)
        defer {
            UIGraphicsEndImageContext()
        }
        guard let context = UIGraphicsGetCurrentContext() else {
            return nil
        }
        layer.render(in: context)
        return UIGraphicsGetImageFromCurrentImageContext()
    }
}

// MARK: - Cross Dissolve
func crossDissolve(_ view: UIView, show: Bool, completion: (() -> Void)? = nil) {
    view.alpha = show ? 0 : 1
    UIView.animate(withDuration: 0.25) {
        view.alpha = show ? 1 : 0
    } completion: { _ in
        completion?()
    }
}
