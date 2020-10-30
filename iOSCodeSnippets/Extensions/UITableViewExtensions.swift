import UIKit

extension UITableView {
    func registerCellClass(_ cellClass: UITableViewCell.Type) {
        register(cellClass, forCellReuseIdentifier: cellClass.defaultReusableId)
    }

    func deleteRows(at indexPaths: [IndexPath]) {
        beginUpdates()
        deleteRows(at: indexPaths, with: .automatic)
        endUpdates()
    }
}

extension UITableViewCell {
    static var defaultReusableId: String {
        description()
            .components(separatedBy: ".")
            .dropFirst()
            .joined(separator: ".")
    }
}

extension UITableViewHeaderFooterView {
    static var defaultReusableId: String {
        description()
            .components(separatedBy: ".")
            .dropFirst()
            .joined(separator: ".")
    }
}

extension UICollectionReusableView {
    static var defaultReusableId: String {
        description()
            .components(separatedBy: ".")
            .dropFirst()
            .joined(separator: ".")
    }
}
