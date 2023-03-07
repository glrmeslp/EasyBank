@testable import EasyBank

extension MenuCollectionItem {
    static func mock(icon: Icon, title: String) -> Self {
        .init(icon: icon, title: title, action: { })
    }
}
