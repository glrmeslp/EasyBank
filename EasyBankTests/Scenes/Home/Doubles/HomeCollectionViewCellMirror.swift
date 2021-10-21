import UIKit

class HomeCollectionViewCellMirror: MirrorObject {
    init(collectionViewCell: UICollectionViewCell) {
        super.init(refrecting: collectionViewCell)
    }

    var imageView: UIImageView? {
        return extract()
    }

    var titleLabel: UILabel? {
        return extract()
    }
}
