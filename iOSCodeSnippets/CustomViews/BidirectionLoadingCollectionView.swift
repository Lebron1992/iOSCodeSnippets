import UIKit

protocol BidirectionLoadingCollectionViewDelegate: class {
    func hasMoreData() -> Bool
}

final class BidirectionLoadingCollectionView: UICollectionView {

    weak var loadingDelegate: BidirectionLoadingCollectionViewDelegate?

    var pullToRefreshAction: (() -> Void)? {
        didSet {
            if refreshControl == nil {
                addPullToRefresh()
            }
        }
    }
    var bottomLoadingAction: (() -> Void)? {
        didSet {
            guard bottomLoadingAction != nil else { return }
            addSubview(bottomLoadingView)
            observeContentOffset()
        }
    }

    var isTopRefreshing: Bool = false {
        didSet {
            guard isTopRefreshing != oldValue else { return }
            if !isTopRefreshing {
                stopTopRefresh()
            } else {
                startTopRefresh()
            }
        }
    }

    var isBottomLoading: Bool = false {
        didSet {
            guard isBottomLoading != oldValue else { return }
            if !isBottomLoading {
                finishBottomLoading()
            } else {
                startBottomLoading()
            }
        }
    }

    private let kBottomLoadingViewHeight: CGFloat = 80
    private let kBottomDragOffset: CGFloat = 60
    private var contentOffsetObserver: NSKeyValueObservation?

    private lazy var bottomLoadingView: BottomLoadingView = {
        let bv = BottomLoadingView(frame: .init(
            x: 0,
            y: 0,
            width: 0,
            height: kBottomLoadingViewHeight
            ))
        bv.isHidden = true
        return bv
    }()

    private func observeContentOffset() {
        contentOffsetObserver = observe(\.contentOffset, options: .new) { [weak self] _, _ in
            guard let self = self, self.loadingDelegate?.hasMoreData() ?? true else { return }
            self.tableDidScroll()
        }
    }

    deinit {
        contentOffsetObserver = nil
    }

    // MARK: - Overrides

    override func layoutSubviews() {
        super.layoutSubviews()
        if bottomLoadingView.frame != frameForBottomLoadingView {
            bottomLoadingView.frame = frameForBottomLoadingView
        }
    }

    override var backgroundColor: UIColor? {
        didSet {
            bottomLoadingView.backgroundColor = backgroundColor
        }
    }
}

// MARK: - Top pull to refresh
extension BidirectionLoadingCollectionView {

    private func addPullToRefresh() {
        refreshControl = UIRefreshControl()
        refreshControl?.addTarget(
            self,
            action: #selector(refreshAction),
            for: .valueChanged
        )
    }

    func stopTopRefresh() {
        refreshControl?.endRefreshing()
    }

    func startTopRefresh() {
        refreshControl?.beginRefreshing()
    }

    @objc private func refreshAction() {
        isTopRefreshing = true
        pullToRefreshAction?()
    }
}

// MARK: - Bottom loading

private final class BottomLoadingView: UIView {

    private var activityView: UIActivityIndicatorView!

    override init(frame: CGRect) {
        super.init(frame: frame)
        addActivityView()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func addActivityView() {
        activityView = UIActivityIndicatorView(style: .gray)
        activityView.color = .lightGray
        activityView.startAnimating()
        addSubview(activityView)
        activityView.translatesAutoresizingMaskIntoConstraints = false
        activityView.centerXAnchor.constraint(
            equalTo: centerXAnchor).isActive = true
        activityView.centerYAnchor.constraint(
            equalTo: centerYAnchor).isActive = true
    }
}

extension BidirectionLoadingCollectionView {

    private var frameForBottomLoadingView: CGRect {
        let x = frame.origin.x
        let y = contentInset.top + contentSize.height
        return CGRect(
            x: x,
            y: y,
            width: frame.width,
            height: kBottomLoadingViewHeight
        )
    }

    func startBottomLoading() {
        bottomLoadingView.isHidden = false
        sendSubviewToBack(bottomLoadingView)

        let oldInset = contentInset
        bottomLoadingView.frame = frameForBottomLoadingView

        UIView.animate(withDuration: 0.25, animations: {
            let newInset = UIEdgeInsets(
                top: oldInset.top,
                left: oldInset.left,
                bottom: oldInset.bottom + self.kBottomLoadingViewHeight,
                right: oldInset.right
            )
            self.contentInset = newInset
        }, completion: { _ in
            self.bottomLoadingAction?()
        })
    }

    func finishBottomLoading() {
        let oldInset = contentInset
        let newInset = UIEdgeInsets(
            top: oldInset.top,
            left: oldInset.left,
            bottom: oldInset.bottom - kBottomLoadingViewHeight,
            right: oldInset.right
        )

        UIView.animate(withDuration: 0.25,
                       animations: {
                        self.contentInset = newInset
        }, completion: { _ in
            self.bottomLoadingView.isHidden = true
        })
    }

    func tableDidScroll() {
        guard !isBottomLoading else { return }

        let offset = contentOffset
        let size = contentSize
        let inset = contentInset
        let y = offset.y + bounds.size.height - inset.bottom
        let distance = y - size.height

        if distance > kBottomDragOffset && contentSize.height >= frame.height {
            isBottomLoading = true
        }
    }
}
