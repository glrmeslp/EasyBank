import UIKit

protocol MenuCollectionViewCellDelegate {
    func configure(with data: MenuCollectionViewCellOld.ViewModel)
}

final class MenuCollectionViewCellOld: UICollectionViewCell {

    @IBOutlet private weak var imageView: UIImageView!
    @IBOutlet private weak var titleLabel: UILabel!

    struct ViewModel {
        let title: String
        let image: String
    }
}

extension MenuCollectionViewCellOld: MenuCollectionViewCellDelegate {
    func configure(with data: ViewModel) {
        titleLabel.text = data.title
        var image: UIImage?
        if data.image == "qrcode" {
            image = UIImage(systemName: data.image)
        } else {
            image = UIImage(named: data.image)
        }
        imageView.image = image?.withTintColor(UIColor(named: "BlueColor")!)
        self.layer.cornerRadius = 20
        self.layer.borderWidth = 1
        self.layer.borderColor = UIColor(named: "BlueColor")?.cgColor
    }
}
