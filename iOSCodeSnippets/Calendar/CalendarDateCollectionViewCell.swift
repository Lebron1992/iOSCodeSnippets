import UIKit
import JTAppleCalendar

final class CalendarDateCollectionViewCell: JTACDayCell {

    private lazy var dateLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.textAlignment = .center
        label.layer.cornerRadius = 25
        label.layer.masksToBounds = true
        return label
    }()

    // MARK: - Initializers

    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubviews()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configure(with state: CellState) {
        dateLabel.font = state.isSelected ? .boldSystemFont(ofSize: 18) : .systemFont(ofSize: 18)
        dateLabel.textColor = state.isSelected ?
            .white : state.dateBelongsTo == .thisMonth ?
                .thisMonthDateTextColor : .otherMonthDateTextColor
        dateLabel.backgroundColor = state.isSelected ?
            .calendarDateSelectedBackgroundColor : .calendarDateNormalBackgroundColor
        dateLabel.alpha = state.dateBelongsTo == .thisMonth ? 1 : 0.5
        dateLabel.text = state.text
    }
}

// MARK: - Setup Subviews

extension CalendarDateCollectionViewCell {
    private func addSubviews() {
        contentView.addSubview(dateLabel)
        dateLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            dateLabel.widthAnchor.constraint(equalToConstant: 50),
            dateLabel.heightAnchor.constraint(equalTo: dateLabel.widthAnchor),
            dateLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            dateLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ])
    }
}
