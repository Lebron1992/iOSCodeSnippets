import UIKit

class BaseCollectionViewCell: UICollectionViewCell {
    override var isSelected: Bool {
        didSet {
            UIView.animate(withDuration: 0.25) {
                self.alpha = self.isSelected ? 0.5 : 1
            }
        }
    }
}
