import UIKit

public protocol Reloadable {
    var automaticReloadData: Bool { get set }
}

public protocol ReloadableView {
    func reloadData()
}

extension UICollectionView: ReloadableView {}
