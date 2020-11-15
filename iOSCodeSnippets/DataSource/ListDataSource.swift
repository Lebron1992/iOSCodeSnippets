import UIKit

typealias ListItemType = Equatable & Codable

class ListDataSource<ItemType: ListItemType, CellType: ValueCell>: ValueCellDataSource
where CellType.Value == ItemType {

    func loadItems(_ items: [ItemType]) {
        set(values: items, cellClass: CellType.self, inSection: 0)
    }

    @discardableResult
    func loadMoreItems(_ items: [ItemType]) -> [IndexPath] {
        let oldCount = values.first?.count ?? 0
        var result: [IndexPath] = []
        items.enumerated().forEach { index, item in
            appendRow(value: item, cellClass: CellType.self, toSection: 0)
            result.append(.init(row: oldCount + index, section: 0))
        }
        return result
    }

    override func configureTableCell(_ cell: UITableViewCell, with value: Any) {
        switch (cell, value) {
        case let (cell as CellType, value as ItemType):
            cell.configureWith(value: value)
        default:
            assertionFailure("Unrecognized (cell, value) combo.")
        }
    }

    func item(at indexPath: IndexPath) -> ItemType? {
        item(at: indexPath, cellClass: CellType.self)
    }

    func indexPath(for item: ItemType) -> IndexPath? {
        let sectionArray = values.map { $0.compactMap { $0.value as? ItemType } }
        guard let section = sectionArray.firstIndex(where: { $0.contains(item) }),
            let row = sectionArray[section].firstIndex(of: item) else {
                return nil
        }
        return IndexPath(row: row, section: section)
    }
}
