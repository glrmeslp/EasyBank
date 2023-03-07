
protocol MenuCollectionViewInteracting: AnyObject {
    var view: MenuCollectionViewDisplaying? { get set }
    func configure(items: [MenuCollectionItem])
    func didSelectItem(index: Int)
}

final class MenuCollectionViewInteractor: MenuCollectionViewInteracting {
    var view: MenuCollectionViewDisplaying?
    
    private var items: [MenuCollectionItem] = []
    
    func configure(items: [MenuCollectionItem]) {
        self.items = items
        view?.display(items: items)
    }
    
    func didSelectItem(index: Int) {
        items[index].action()
    }
}
