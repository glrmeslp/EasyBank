import Foundation

public class ReloadableDataSource<View: AnyObject & ReloadableView, Cell, Section: Hashable, Item>: NSObject, Reloadable {
    public weak var reloadableView: View?
    public var automaticReloadData = true

    public typealias ItemProvider = (_ view: View, _ indexPath: IndexPath, _ item: Item) -> Cell?

    public private(set) var sections: [Section] = []
    public private(set) var data: [Section: [Item]] = [:] {
        didSet {
            guard automaticReloadData else { return }
            reloadableView?.reloadData()
        }
    }

    public var itemProvider: ItemProvider?

    public init(view: View, itemProvider: ItemProvider? = nil) {
        super.init()
        self.reloadableView = view
        self.itemProvider = itemProvider
    }

    // MARK: - Data management

    /// Adds a section to the data source
    /// - Parameter section: The section to be added to the data source
    /// - Note: If the section is already present, the data source does not change
    public func add(section: Section) {
        if !sections.contains(section) {
            sections.append(section)
            data[section] = []
        }
    }

    /// Add items to the given section
    /// - Parameters:
    ///   - items: The items to be added to the section
    ///   - section: A type that conforms to `Hashable` to represents a section
    /// - Note: If the section is not part of the data source, it will also add the section
    public func add(items: [Item], to section: Section) {
        add(section: section)
        var currentItems = data[section, default: []]
        currentItems.append(contentsOf: items)
        data[section] = currentItems
    }

    /// Add only one item to the given section
    /// - Parameters:
    ///   - item: The item to be added to the section
    ///   - section: A type that conforms to `Hashable` that represents a section
    /// - Note: If the section is not part of the data source, it will also be added
    public func add(item: Item, to section: Section) {
        var currentItems = data[section, default: []]
        currentItems.append(item)
        data[section] = currentItems
    }

    /// Add item in a specific position to the given section
    /// - Parameters:
    ///   - item: The item to be added to the section
    ///   - index: The position where the item will be added
    ///   - section: A type that conforms to `Hashable` that represents a section
    /// - Note: If the section is not part of the data source, it will also be added
    public func add(item: Item, at index: Int, in section: Section) {
        var currentItems = data[section, default: []]
        currentItems.insert(item, at: index)
        data[section] = currentItems
    }

    /// Updates the given section with the contents of the `items` parameter
    /// - Parameters:
    ///   - items: Items to replace the contents of the section
    ///   - section: The section to be updated
    /// - Note: If the section doesn't exists the data source does not change
    public func update(items: [Item], from section: Section) {
        if sections.contains(section) {
            data[section] = items
        }
    }

    /// Updates the given index path with the `item` parameter
    /// - Parameters:
    ///   - item: Item to replace the item on received index path
    ///   - indexPath: The index path to be updated
    /// - Note: If the section doesn't exists or received row is out of range, the data source does not change
    public func update(item: Item, at indexPath: IndexPath) {
        let section = sections[indexPath.section]
        if data.contains(where: { $0.key == section }), let items = data[section], items.count > indexPath.row {
            data[section]?[indexPath.row] = item
        }
    }

    /// Updates the given index path with the `item` parameter
    /// - Parameters:
    ///   - item: Item to replace the item on received position
    ///   - position: The index path to be updated
    ///   - Section: The section that will be updated
    public func update(item: Item, from section: Section, at position: Int) {
        if var itemArray = data[section], itemArray.indices.contains(position) {
            itemArray[position] = item
        }
    }

    /// Removes all sections from the data source
    public func removeAllSections() {
        sections.removeAll()
        data.removeAll()
    }

    /// Removes an entire section from the data source
    /// - Parameter section: The section to be removed
    public func remove(section: Section) {
        sections.removeAll(where: { $0.hashValue == section.hashValue })
        data.removeValue(forKey: section)
    }

    /// Removes an item in a specific position on the given section from the data source
    /// - Parameters:
    /// - section: The section where the item is localized
    /// - index: The position where the item to be removed is located
    public func removeItem(from section: Section, at index: Int) {
        data[section]?.remove(at: index)
    }

    /// Sort sections
    /// - Parameters:
    ///   - sections: An closure to determine the order of the sections
    /// - Note: If the section doesn't exists the data source does not change
    public func sort(sections sortCompletion: (Section, Section) throws -> Bool) throws {
        try sections.sort(by: sortCompletion)
    }

    /// - Parameter indexPath: The item `IndexPath`
    /// - Returns: Returns the item at the given `IndexPath` if the item exists, otherwise returns `nil`
    public func item(at indexPath: IndexPath) -> Item? {
        let section = sections[indexPath.section]
        guard data.contains(where: { $0.key == section }),
              let itens = data[section] else {
            return nil
        }
        let item = itens[indexPath.row]
        return item
    }
}

