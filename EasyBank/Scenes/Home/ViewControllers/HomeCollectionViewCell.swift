import UIKit

protocol HomeCollectionViewCellDelegate {
    func configure(with data: HomeCollectionViewCell.ViewModel, and view: UICollectionViewCell)
}

class HomeCollectionViewCell: UICollectionViewCell {

    @IBOutlet private weak var imageView: UIImageView!
    @IBOutlet private weak var titleLabel: UILabel!

    struct ViewModel {
        let title: String
        let image: String
    }
}

extension HomeCollectionViewCell: HomeCollectionViewCellDelegate {
    func configure(with data: ViewModel, and view: UICollectionViewCell) {
        titleLabel.text = data.title
        var image: UIImage?
        if data.image == "qrcode" {
            image = UIImage(systemName: data.image)
        } else {
            image = UIImage(named: data.image)
        }
        imageView.image = image?.withTintColor(UIColor(named: "BlueColor")!)
        view.layer.cornerRadius = 20
        view.layer.borderWidth = 1
        view.layer.borderColor = UIColor(named: "BlueColor")?.cgColor
    }
}
