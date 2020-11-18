import ReactiveSwift

/// A base view model for list.
/// Because it''s a generic type, we can't code it in inputs/ouputs mode.
/// For example:
/// ```
/// protocol ListViewModelOutputs {
///    associatedtype ItemType: Codable
///    var itemClicked: Signal<ItemType, Never> { get }
/// }

/// protocol ListViewModelType {
///    // trigger error: Protocol 'ListViewModelOutputs' can only be used as a generic constraint
///    // because it has Self or associated type requirements
///    var outputs: ListViewModelOutputs { get }
/// }
/// ```
class ListViewModel<ItemType: ListItemType> {

    init() {
        itemClicked = itemCellPressedProperty.signal
            .skipNil()
    }

    let currentPageChangedProperty = MutableProperty
        <(currentPage: Int, showTopLoading: Bool)>((currentPage: 1, showTopLoading: false))
    func currentPageChanged(_ currentPage: Int, showTopLoading: Bool) {
        currentPageChangedProperty.value = (currentPage: currentPage, showTopLoading: showTopLoading)
    }

    let itemCellPressedProperty = MutableProperty<ItemType?>(nil)
    func itemCellPressed(_ item: ItemType) {
        itemCellPressedProperty.value = item
    }

    let triggeredPullToRefreshProperty = MutableProperty(())
    func triggeredPullToRefresh() {
        triggeredPullToRefreshProperty.value = ()
    }

    let triggeredLoadMoreProperty = MutableProperty(())
    func triggeredLoadMore() {
        triggeredLoadMoreProperty.value = ()
    }

    let viewDidLoadProperty = MutableProperty(())
    func viewDidLoad() {
        viewDidLoadProperty.value = ()
    }

    var isRefreshing: Signal<Bool, Never>!
    var isBottomLoading: Signal<Bool, Never>!
    var itemClicked: Signal<ItemType, Never>
    var itemsLoaded: Signal<[ItemType], Never>!
    var showLoadingHUD: Signal<Bool, Never>!
    var showError: Signal<Error, Never>!

    var moreItemsLoaded: Signal<[ItemType], Never>!
    var hasMoreData = true

    var inputs: ListViewModel { return self }
    var outputs: ListViewModel { return self }
}
