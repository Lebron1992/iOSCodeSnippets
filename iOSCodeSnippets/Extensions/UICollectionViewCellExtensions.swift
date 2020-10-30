import UIKit

extension UICollectionViewCell {
    func performSelectionAnimations() {
        contentView.alpha = 0.5
        UIView.animate(withDuration: 0.25) {
            self.contentView.alpha = 1
        }
    }
}
