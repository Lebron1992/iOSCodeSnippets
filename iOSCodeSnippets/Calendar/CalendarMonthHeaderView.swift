import JTAppleCalendar

protocol CalendarMonthHeaderViewDelegate: class {
    func calendarMonthHeaderViewDidClickPreviousButton()
    func calendarMonthHeaderViewDidClickNextButton()
}

final class CalendarMonthHeaderView: UIView {

    // MARK: - Views

    private lazy var previousButton: UIButton = {
        let button = UIButton(type: .system)
        let backward = UIImage(named: "backward")?.withRenderingMode(.alwaysOriginal)
        button.setImage(backward, for: .normal)
        button.addTarget(self, action: #selector(previousButtonPressed), for: .touchUpInside)
        return button
    }()

    private lazy var nextButton: UIButton = {
        let button = UIButton(type: .system)
        let forward = UIImage(named: "forward")?.withRenderingMode(.alwaysOriginal)
        button.setImage(forward, for: .normal)
        button.addTarget(self, action: #selector(nextButtonPressed), for: .touchUpInside)
        return button
    }()

    lazy var monthLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.textAlignment = .center
        label.textColor = .thisMonthDateTextColor
        label.font = .systemFont(ofSize: 16)
        return label
    }()

    private lazy var topContainerView: UIView = {
        let view = UIView(frame: .zero)
        view.backgroundColor = .calendarHeaderBackgroundColor
        return view
    }()

    private lazy var daysOfWeekStackView: UIStackView = {
        let views = ["Sun", "Mon", "Tues", "Wed", "Thur", "Fri", "Sat"].map { day -> UILabel in
            let label = UILabel(frame: .zero)
            label.textAlignment = .center
            label.textColor = .otherMonthDateTextColor
            label.font = .systemFont(ofSize: 14)
            label.text = day
            label.backgroundColor = .calendarDateNormalBackgroundColor
            return label
        }
        let stackView = UIStackView(arrangedSubviews: views)
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        return stackView
    }()

    // MARK: - Properties

    weak var delegate: CalendarMonthHeaderViewDelegate?

    // MARK: - Initializers

    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubviews()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Actions

extension CalendarMonthHeaderView {
    @objc private func previousButtonPressed() {
        delegate?.calendarMonthHeaderViewDidClickPreviousButton()
    }

    @objc private func nextButtonPressed() {
        delegate?.calendarMonthHeaderViewDidClickNextButton()
    }
}

// MARK: - Setup Subviews

extension CalendarMonthHeaderView {
    private func addSubviews() {
        topContainerView.addSubview(previousButton)
        topContainerView.addSubview(monthLabel)
        topContainerView.addSubview(nextButton)
        addSubview(topContainerView)
        addSubview(daysOfWeekStackView)

        setSubviewsTranslatingMasksToConstraints(to: false)

        NSLayoutConstraint.activate([
            topContainerView.leadingAnchor.constraint(equalTo: leadingAnchor),
            topContainerView.trailingAnchor.constraint(equalTo: trailingAnchor),
            topContainerView.topAnchor.constraint(equalTo: topAnchor),
            topContainerView.heightAnchor.constraint(equalToConstant: 60),

            previousButton.widthAnchor.constraint(equalToConstant: 60),
            previousButton.heightAnchor.constraint(equalTo: previousButton.widthAnchor),
            previousButton.leadingAnchor.constraint(equalTo: topContainerView.leadingAnchor, constant: 5),
            previousButton.centerYAnchor.constraint(equalTo: topContainerView.centerYAnchor),

            monthLabel.centerXAnchor.constraint(equalTo: topContainerView.centerXAnchor),
            monthLabel.centerYAnchor.constraint(equalTo: topContainerView.centerYAnchor),

            nextButton.widthAnchor.constraint(equalTo: previousButton.widthAnchor),
            nextButton.heightAnchor.constraint(equalTo: previousButton.widthAnchor),
            nextButton.trailingAnchor.constraint(equalTo: topContainerView.trailingAnchor, constant: -5),
            nextButton.centerYAnchor.constraint(equalTo: topContainerView.centerYAnchor),

            daysOfWeekStackView.topAnchor.constraint(equalTo: topContainerView.bottomAnchor),
            daysOfWeekStackView.heightAnchor.constraint(equalToConstant: 55),
            daysOfWeekStackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            daysOfWeekStackView.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])
    }
}
