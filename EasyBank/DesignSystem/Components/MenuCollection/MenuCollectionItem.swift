import UIKit

struct MenuCollectionItem: Equatable {
    let icon: Icon
    let title: String
    let action: () -> Void
    
    static func == (lhs: MenuCollectionItem, rhs: MenuCollectionItem) -> Bool {
        lhs.icon == rhs.icon &&
        lhs.title == rhs.title &&
        lhs.action() == rhs.action()
    }
    
}
