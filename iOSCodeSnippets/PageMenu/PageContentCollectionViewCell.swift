import UIKit

final class PageContentCollectionViewCell: UICollectionViewCell {

    var hostedView: UIView? {
        didSet {
            guard let view = hostedView else { return }
            contentView.addSubview(view)
            view.constraintEdges(to: contentView)
        }
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        hostedView?.removeFromSuperview()
        hostedView = nil
    }
}
