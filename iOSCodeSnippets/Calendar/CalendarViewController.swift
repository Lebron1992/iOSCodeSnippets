import UIKit
import JTAppleCalendar

final class CalendarViewController: UIViewController {

    var currentDate: Date?
    var doneBlock: ((Date?) -> Void)?

    private var viewIfAppeared = false

    // MARK: - Views

    private lazy var headerView: CalendarMonthHeaderView = {
        let view = CalendarMonthHeaderView(frame: .zero)
        view.delegate = self
        return view
    }()

    private lazy var monthView: JTACMonthView = {
        let monthView = JTACMonthView(frame: .zero)
        monthView.backgroundColor = .hex("#F7F9FC")
        monthView.showsVerticalScrollIndicator = false
        monthView.showsHorizontalScrollIndicator = false
        monthView.register(
            CalendarDateCollectionViewCell.self,
            forCellWithReuseIdentifier: CalendarDateCollectionViewCell.defaultReusableId
        )
        monthView.calendarDelegate = self
        monthView.calendarDataSource = self
        monthView.scrollingMode = .stopAtEachCalendarFrame
        monthView.scrollDirection = .horizontal
        return monthView
    }()

    // MARK: - Lift Cycles

    override func viewDidLoad() {
        super.viewDidLoad()
        addSubviews()

        let currDate = currentDate ?? Date()
        monthView.scrollToDate(currDate, animateScroll: false)
        monthView.selectDates([currDate])
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        viewIfAppeared = true
    }
}

// MARK: - JTACMonthViewDataSource

extension CalendarViewController: JTACMonthViewDataSource {
    func configureCalendar(_ calendar: JTACMonthView) -> ConfigurationParameters {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy MM dd"
        let startDate = formatter.date(from: "2018 01 01")!
        let endDate = formatter.date(from: "2022 01 01")!
        return ConfigurationParameters(startDate: startDate, endDate: endDate)
    }
}

// MARK: - JTACMonthViewDelegate

extension CalendarViewController: JTACMonthViewDelegate {
    func calendar(
        _ calendar: JTACMonthView,
        cellForItemAt date: Date,
        cellState: CellState, indexPath: IndexPath
    ) -> JTACDayCell {
        guard let cell = calendar.dequeueReusableJTAppleCell(
            withReuseIdentifier: CalendarDateCollectionViewCell.defaultReusableId,
            for: indexPath) as? CalendarDateCollectionViewCell else {
            return CalendarDateCollectionViewCell()
        }
        cell.configure(with: cellState)
        return cell
    }

    func calendar(
        _ calendar: JTACMonthView,
        willDisplay cell: JTACDayCell,
        forItemAt date: Date,
        cellState: CellState, indexPath: IndexPath
    ) {
        let cell = cell as? CalendarDateCollectionViewCell
        cell?.configure(with: cellState)
    }

    func calendar(
        _ calendar: JTACMonthView,
        didSelectDate date: Date,
        cell: JTACDayCell?,
        cellState: CellState,
        indexPath: IndexPath
    ) {
        let cell = cell as? CalendarDateCollectionViewCell
        cell?.configure(with: cellState)

        if viewIfAppeared { // ignore the select event when setting current day
            doneBlock?(monthView.selectedDates.first)
        }
    }

    func calendar(
        _ calendar: JTACMonthView,
        didDeselectDate date: Date,
        cell: JTACDayCell?,
        cellState: CellState,
        indexPath: IndexPath
    ) {
        let cell = cell as? CalendarDateCollectionViewCell
        cell?.configure(with: cellState)
    }

    func calendar(
        _ calendar: JTACMonthView,
        didScrollToDateSegmentWith visibleDates: DateSegmentInfo
    ) {
        let date = visibleDates.monthDates.first?.date
        setMonthLabel(with: date)
    }
}

// MARK: - CalendarMonthHeaderViewDelegate

extension CalendarViewController: CalendarMonthHeaderViewDelegate {
    func calendarMonthHeaderViewDidClickPreviousButton() {
        scrollToPreviousMonth()
    }

    func calendarMonthHeaderViewDidClickNextButton() {
        scrollToNextMonth()
    }
}

// MARK: - Helper Methods

extension CalendarViewController {
    private func setMonthLabel(with date: Date?) {
        guard let date = date else {
            headerView.monthLabel.text = nil
            return
        }
        headerView.monthLabel.text = DateFormatter.monthHeader.string(from: date)
    }

    private func scrollToPreviousMonth() {
        monthView.scrollToSegment(.previous)
    }

    private func scrollToNextMonth() {
        monthView.scrollToSegment(.next)
    }
}

// MARK: - Setup Subviews

extension CalendarViewController {
    private func addSubviews() {
        view.addSubview(headerView)
        view.addSubview(monthView)

        headerView.translatesAutoresizingMaskIntoConstraints = false
        monthView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            headerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            headerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            headerView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            headerView.heightAnchor.constraint(equalToConstant: 115),

            monthView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            monthView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            monthView.topAnchor.constraint(equalTo: headerView.bottomAnchor),
            monthView.heightAnchor.constraint(equalToConstant: 300)
        ])
    }
}
