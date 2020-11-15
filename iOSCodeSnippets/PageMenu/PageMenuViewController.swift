import UIKit

class PageMenuViewController: BaseViewController {

    // MARK: - Views

    var pageContainerView: UIView {
        return view
    }

    private(set) lazy var pageMenuView: PageMenuView = {
        let menu = PageMenuView(frame: .zero, tabTitles: tabTitles)
        menu.delegate = self
        return menu
    }()

    private(set) lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let collectionView = UICollectionView(
            frame: .zero,
            collectionViewLayout: layout
        )
        collectionView.backgroundColor = .white
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.bounces = false
        collectionView.isPagingEnabled = true
        collectionView.decelerationRate = .fast
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(
            PageContentCollectionViewCell.self,
            forCellWithReuseIdentifier: "PageContentCollectionViewCell"
        )
        return collectionView
    }()

    // MARK: - Properties

    private lazy var tabTitles: [String] = {
        let tabTitles = tabTitlesForMenu()
        return tabTitles
    }()

    private lazy var contentViewControllers: [UIViewController] = {
        let viewControllers = tabTitles.map { title -> UIViewController in
            let vc = viewControllerForTabWithTitle(title) ?? UIViewController()
            addChild(vc)
            vc.didMove(toParent: self)
            return vc
        }
        return viewControllers
    }()

    // MARK: - Lift Cycles

    override func viewDidLoad() {
        super.viewDidLoad()
        addSubviews()
    }

    // MARK: - Methods to be overrided by Subclass

    func tabTitlesForMenu() -> [String] {
        return []
    }

    func viewControllerForTabWithTitle(_ title: String) -> UIViewController? {
        return nil
    }

    func didScrollToViewController(_ viewController: UIViewController) {

    }
}

// MARK: - Private
extension PageMenuViewController {
    private func didScrollToViewController(at index: Int) {
        let viewController = contentViewControllers[index]
        didScrollToViewController(viewController)
    }
}

// MARK: - UICollectionViewDelegate
extension PageMenuViewController: UICollectionViewDataSource {
    func collectionView(
        _ collectionView: UICollectionView,
        numberOfItemsInSection section: Int
    ) -> Int {
        return tabTitles.count
    }

    func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        guard let contentCell = collectionView.dequeueReusableCell(
            withReuseIdentifier: "PageContentCollectionViewCell",
            for: indexPath
            ) as? PageContentCollectionViewCell else {
                return UICollectionViewCell()
        }
        let viewController = contentViewControllers[indexPath.row]
        contentCell.hostedView = viewController.view
        return contentCell
    }
}

// MARK: - UICollectionViewDelegate
extension PageMenuViewController {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetX = scrollView.contentOffset.x
        let contentWidth = scrollView.bounds.width
        let maxOffset = contentWidth * CGFloat(tabTitles.count - 1)

        guard 0...maxOffset ~= offsetX &&
            !pageMenuView.isAnimatingUnderline else {
            return
        }

        let leading = (offsetX / contentWidth) * pageMenuView.underlineWidth
        pageMenuView.updateUnderlinePosition(leading: leading, animated: false)
    }

    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let offsetX = scrollView.contentOffset.x
        let contentWidth = scrollView.bounds.width
        let currentPage = Int((offsetX + 0.5 * contentWidth)/contentWidth)
        didScrollToViewController(at: currentPage)
    }
}

// MARK: - UICollectionViewDelegateFlowLayout
extension PageMenuViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath
    ) -> CGSize {
        return collectionView.bounds.size
    }

    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        minimumLineSpacingForSectionAt section: Int
    ) -> CGFloat {
        return 0
    }
}

// MARK: - PageMenuViewDelegate
extension PageMenuViewController: PageMenuViewDelegate {
    func pageMenuViewDidPressTab(at index: Int) {
        collectionView.scrollToItem(
            at: .init(item: index, section: 0),
            at: .centeredHorizontally,
            animated: true
        )
        didScrollToViewController(at: index)
    }
}

// MARK: - Setup Subviews
extension PageMenuViewController {
    private func addSubviews() {
        pageContainerView.addSubview(pageMenuView)
        pageContainerView.addSubview(collectionView)

        pageMenuView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            pageMenuView.leadingAnchor.constraint(equalTo: pageContainerView.leadingAnchor),
            pageMenuView.trailingAnchor.constraint(equalTo: pageContainerView.trailingAnchor),
            pageMenuView.topAnchor.constraint(equalTo: pageContainerView.safeAreaLayoutGuide.topAnchor),
            pageMenuView.heightAnchor.constraint(equalToConstant: 44),

            collectionView.leadingAnchor.constraint(equalTo: pageContainerView.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: pageContainerView.trailingAnchor),
            collectionView.topAnchor.constraint(equalTo: pageMenuView.bottomAnchor),
            collectionView.bottomAnchor.constraint(equalTo: pageContainerView.bottomAnchor)
        ])
    }
}
