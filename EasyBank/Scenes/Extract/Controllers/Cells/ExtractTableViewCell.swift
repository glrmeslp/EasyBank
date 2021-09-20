import UIKit

protocol ExtractTableViewCellDelegate {
    func configure(with data: ExtractTableViewCell.ViewModel)
}

final class ExtractTableViewCell: UITableViewCell {

    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var nameLabel: UILabel!
    @IBOutlet private weak var valueLabel: UILabel!

    struct ViewModel {
        let extractEnum: ExtractEnum
        let name: String
        let value: String?
    }
}

extension ExtractTableViewCell: ExtractTableViewCellDelegate {
    func configure(with data: ViewModel) {
        guard let value = data.value else { return }
        switch data.extractEnum {
        case .transferred:
            titleLabel.text = ExtractEnum.transferred.rawValue
            nameLabel.text = "To - \(data.name)"
            valueLabel.textColor = .systemRed
            valueLabel.text = "- \(value)"
        case .received:
            titleLabel.text = ExtractEnum.received.rawValue
            nameLabel.text = "From - \(data.name)"
            valueLabel.textColor = .systemGreen
            valueLabel.text = "+ \(value)"
        }
   
    }
}



