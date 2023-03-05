import UIKit

public final class CollectionViewDataSource<Section: Hashable, Item>: ReloadableDataSource<UICollectionView, UICollectionViewCell, Section, Item>, UICollectionViewDataSource {

    public typealias SupplementaryViewProvider = (_ collectionView: UICollectionView, _ kind: String, _ indexPath: IndexPath) -> UICollectionReusableView?

    public var supplementaryViewProvider: SupplementaryViewProvider?

    public func numberOfSections(in collectionView: UICollectionView) -> Int {
        sections.count
    }

    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let section = sections[section]
        guard let data = data[section] else {
            return 0
        }

        return data.count
    }

    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let item = self.item(at: indexPath), let cell = itemProvider?(collectionView, indexPath, item) else {
            return UICollectionViewCell()
        }
        return cell
    }

    public func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        supplementaryViewProvider?(collectionView, kind, indexPath) ?? UICollectionReusableView()
    }
}
