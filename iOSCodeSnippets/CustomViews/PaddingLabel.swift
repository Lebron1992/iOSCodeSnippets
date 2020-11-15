import UIKit

final class PaddingLabel: UILabel {

    var contentInset: UIEdgeInsets

    required init(frame: CGRect, contentInset: UIEdgeInsets) {
        self.contentInset = contentInset
        super.init(frame: frame)
    }

    required init?(coder aDecoder: NSCoder) {
        contentInset = .zero
        super.init(coder: aDecoder)
    }

    override func drawText(in rect: CGRect) {
        super.drawText(in: rect.inset(by: contentInset))
    }

    override var intrinsicContentSize: CGSize {
        var contentSize = super.intrinsicContentSize
        contentSize.height += contentInset.top + contentInset.bottom
        contentSize.width += contentInset.left + contentInset.right
        return contentSize
    }
}
