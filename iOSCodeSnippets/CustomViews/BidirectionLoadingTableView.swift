import UIKit

protocol BidirectionLoadingTableViewDelegate: class {
    func hasMoreData() -> Bool
}

class BidirectionLoadingTableView: UITableView {

    weak var loadingDelegate: BidirectionLoadingTableViewDelegate?

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

    private let kBottomDragOffset: CGFloat = 60
    private var isBottomLoadingFinished = true
    private var contentOffsetObserver: NSKeyValueObservation?

    private lazy var bottomLoadingView: BottomLoadingView = {
        let bv = BottomLoadingView(frame: CGRect(x: 0, y: 0, width: 0, height: 80))
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
}

// MARK: - Top pull to refresh

extension BidirectionLoadingTableView {

    private func addPullToRefresh() {
        refreshControl = UIRefreshControl()
        refreshControl?.addTarget(
            self,
            action: #selector(refreshAction),
            for: .valueChanged
        )
    }

    private func stopTopRefresh() {
        refreshControl?.endRefreshing()
    }

    private func startTopRefresh() {
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

extension BidirectionLoadingTableView {

    func tableDidScroll() {
        guard isBottomLoadingFinished else { return }

        let offset = contentOffset
        let size = contentSize
        let inset = contentInset
        let y = offset.y + bounds.size.height - inset.bottom
        let distance = y - size.height
        if distance > kBottomDragOffset &&
            !isBottomLoading && contentSize.height >= frame.height {
            isBottomLoading = true
        }
    }

    private func startBottomLoading() {
        tableFooterView = bottomLoadingView
        bottomLoadingAction?()
    }

    private func finishBottomLoading() {
        isBottomLoadingFinished = false
        UIView.animate(withDuration: 0.3, animations: {
            self.tableFooterView = nil
        }, completion: { _ in
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                self.isBottomLoadingFinished = true
            }
        })
    }
}
