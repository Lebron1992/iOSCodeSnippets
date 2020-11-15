import UIKit

protocol PageMenuViewDelegate: class {
    func pageMenuViewDidPressTab(at index: Int)
}

final class PageMenuView: UIView {

    // MARK: - Views

    private lazy var tabsStackView: UIStackView = {
        let stackView = UIStackView(frame: .zero)
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.backgroundColor = .clear
        return stackView
    }()

    private lazy var underlineView: UIView = {
        let view = UIView(frame: .zero)
        view.backgroundColor = .white
        return view
    }()
    var underlineWidth: CGFloat {
        return bounds.width / CGFloat(tabTitles.count)
    }
    private var underlineViewLeadingConstraint: NSLayoutConstraint!

    // MARK: - Properties

    weak var delegate: PageMenuViewDelegate?

    private let tabTitles: [String]
    private(set) var isAnimatingUnderline = false

    // MARK: - Initializers

    init(frame: CGRect, tabTitles: [String]) {
        self.tabTitles = tabTitles
        super.init(frame: frame)
        backgroundColor = .appRed
        configSubviews()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Public Methods
extension PageMenuView {
    func updateUnderlinePosition(leading: CGFloat, animated: Bool = true) {
        if animated {
            isAnimatingUnderline = true
            UIView.animate(withDuration: animated ? 0.25 : 0, animations: {
                self.underlineViewLeadingConstraint.constant = leading
                self.layoutIfNeeded()
            }, completion: { _ in
                self.isAnimatingUnderline = false
            })
        } else {
            isAnimatingUnderline = false
            underlineViewLeadingConstraint.constant = leading
            layoutIfNeeded()
        }
    }
}

// MARK: - Setup Subviews
extension PageMenuView {
    private func configSubviews() {
        addSubview(tabsStackView)
        addSubview(underlineView)

        tabTitles.forEach { title in
            let button = UIButton(type: .system)
            button.setTitle(title, for: .normal)
            button.setTitleColor(.white, for: .normal)
            button.titleLabel?.font = .Forza(style: .medium, size: 14)
            button.addTarget(
                self,
                action: #selector(tabButtonPressed(_:)),
                for: .touchUpInside
            )
            tabsStackView.addArrangedSubview(button)
        }

        setSubviewsTranslatingMasksToConstraints(to: false)
        tabsStackView.constraintEdges(to: self, useSafeArea: false)

        underlineViewLeadingConstraint = underlineView.leadingAnchor.constraint(equalTo: leadingAnchor)

        NSLayoutConstraint.activate([
            underlineView.widthAnchor.constraint(
                equalTo: widthAnchor,
                multiplier: 1.0 / CGFloat(tabTitles.count)
            ),
            underlineView.heightAnchor.constraint(equalToConstant: 2),
            underlineView.bottomAnchor.constraint(equalTo: bottomAnchor),
            underlineViewLeadingConstraint
        ])
    }

    @objc private func tabButtonPressed(_ button: UIButton) {
        guard let title = button.currentTitle,
            let selectedTabIndex = tabTitles.firstIndex(of: title) else {
                return
        }
        delegate?.pageMenuViewDidPressTab(at: selectedTabIndex)
        updateUnderlinePosition(leading: self.underlineWidth * CGFloat(selectedTabIndex))
    }
}
