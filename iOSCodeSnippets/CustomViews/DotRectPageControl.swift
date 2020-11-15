import UIKit

protocol DotRectPageControlDelegate: class {
    func dotRectPageControlDidClickPage(at index: Int)
}

private class DotRectPageIndicatorView: UIView {
    var pageIndex: Int = 0
}

final class DotRectPageControl: UIControl {

    // MARK: - Properties

    weak var delegate: DotRectPageControlDelegate?

    var currentPage: Int = 0 {
        didSet {
            if currentPage < 0 {
                currentPage = 0
                return
            }
            if currentPage > numberOfPages - 1 {
                currentPage = numberOfPages - 1
                return
            }
            updateCurrentPageIndicator(oldPage: oldValue, newPage: currentPage)
        }
    }

    var numberOfPages: Int = 0 {
        didSet { createIndicators() }
    }

    var pageIndicatorSize: CGSize = .init(width: 6, height: 6) {
        didSet { createIndicators() }
    }

    var currentPageIndicatorSize: CGSize = .init(width: 16, height: 6) {
        didSet { createIndicators() }
    }

    var indicatorSpacing: CGFloat = 3 {
        didSet { createIndicators() }
    }

    var pageIndicatorTintColor: UIColor = .white {
        didSet { createIndicators() }
    }

    var currentPageIndicatorTintColor: UIColor = .init(red: 11/255, green: 186/255, blue: 112/255, alpha: 1) {
        didSet { createIndicators() }
    }

    // MARK: - Initializers

    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }

    private func commonInit() {
        backgroundColor = .clear
        isUserInteractionEnabled = true
    }

    private func createIndicators() {
        indicatorViews.forEach { $0.removeFromSuperview() }

        guard numberOfPages > 0 else { return }

        let containerWidth = CGFloat(numberOfPages - 1) * pageIndicatorSize.width +
                             currentPageIndicatorSize.width +
                             CGFloat(numberOfPages - 1) * indicatorSpacing

        var startX: CGFloat = 0
        if frame.width < containerWidth {
            startX = 0
        } else {
            startX = (frame.width - containerWidth) * 0.5
        }

        var startY: CGFloat = 0
        let maxIndicatorHeight = max(pageIndicatorSize.height, currentPageIndicatorSize.height)
        if frame.height < maxIndicatorHeight {
            startY = 0
        } else {
            startY = (frame.height - maxIndicatorHeight) * 0.5
        }

        for page in 0..<numberOfPages {
            if page == currentPage {
                let rect = CGRect(origin: .init(x: startX, y: startY), size: currentPageIndicatorSize)
                let currentIndicatorView = DotRectPageIndicatorView(frame: rect)
                currentIndicatorView.pageIndex = page
                currentIndicatorView.layer.cornerRadius = currentPageIndicatorSize.height * 0.5
                currentIndicatorView.backgroundColor = currentPageIndicatorTintColor
                let tapGesture = UITapGestureRecognizer(target: self, action: #selector(indicatorDidTap(_:)))
                currentIndicatorView.addGestureRecognizer(tapGesture)
                addSubview(currentIndicatorView)
                startX = rect.maxX + indicatorSpacing

            } else {
                let rect = CGRect(origin: .init(x: startX, y: startY), size: pageIndicatorSize)
                let indicatorView = DotRectPageIndicatorView(frame: rect)
                indicatorView.pageIndex = page
                indicatorView.layer.cornerRadius = pageIndicatorSize.height * 0.5
                indicatorView.backgroundColor = pageIndicatorTintColor
                let tapGesture = UITapGestureRecognizer(target: self, action: #selector(indicatorDidTap(_:)))
                indicatorView.addGestureRecognizer(tapGesture)
                addSubview(indicatorView)
                startX = rect.maxX + indicatorSpacing
            }
        }
    }

    @objc private func indicatorDidTap(_ gesture: UITapGestureRecognizer) {
        print("indicatorDidTap")
        guard let indicatorView = gesture.view as? DotRectPageIndicatorView else {
            return
        }
        delegate?.dotRectPageControlDidClickPage(at: indicatorView.pageIndex)
    }

    private func updateCurrentPageIndicator(oldPage: Int, newPage: Int) {
        guard oldPage != newPage,
            let oldCurrentIndicator = indicatorViews.filter({ $0.pageIndex == oldPage }).first,
            let newCurrentIndicator = indicatorViews.filter({ $0.pageIndex == newPage }).first else {
                return
        }

        oldCurrentIndicator.backgroundColor = pageIndicatorTintColor
        newCurrentIndicator.backgroundColor = currentPageIndicatorTintColor

        let oldIndicatorFrame = oldCurrentIndicator.frame
        let newIndicatorFrmae = newCurrentIndicator.frame
        let widthDiff = currentPageIndicatorSize.width - pageIndicatorSize.width

        UIView.animate(withDuration: 0.25) {

            var oldIndicatorX = oldIndicatorFrame.origin.x
            if newPage < oldPage {
                oldIndicatorX += widthDiff
            }
            oldCurrentIndicator.frame = CGRect(
                origin: .init(x: oldIndicatorX, y: oldIndicatorFrame.origin.y),
                size: self.pageIndicatorSize
            )

            var newIndicatorX = newIndicatorFrmae.origin.x
            if newPage > oldPage {
                newIndicatorX -= widthDiff
            }
            newCurrentIndicator.frame = CGRect(
                origin: .init(x: newIndicatorX, y: newIndicatorFrmae.origin.y),
                size: self.currentPageIndicatorSize
            )

            // center indicators in nonadjacent switch

            if (newPage - oldPage) < -1 {
                for page in (newPage + 1)..<oldPage {
                    guard let indicator = self.indicatorViews.filter({ $0.pageIndex == page }).first else {
                        break
                    }
                    indicator.frame = CGRect(
                        origin: .init(
                            x: indicator.frame.origin.x + widthDiff,
                            y: indicator.frame.origin.y
                        ),
                        size: self.pageIndicatorSize
                    )
                }
            }

            if (newPage - oldPage) > 1 {
                for page in (oldPage + 1)..<newPage {
                    guard let indicator = self.indicatorViews.filter({ $0.pageIndex == page }).first else {
                        break
                    }
                    indicator.frame = CGRect(
                        origin: .init(
                            x: indicator.frame.origin.x - widthDiff,
                            y: indicator.frame.origin.y
                        ),
                        size: self.pageIndicatorSize
                    )
                }
            }
        }
    }
}

// MARK: - Getters
extension DotRectPageControl {
    private var indicatorViews: [DotRectPageIndicatorView] {
        return subviews
            .compactMap { $0 as? DotRectPageIndicatorView }
            .sorted { $0.pageIndex < $1.pageIndex }
    }
}
