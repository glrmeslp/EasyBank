import UIKit

protocol AccountTableViewCellDelegate {
    func configure(with data: AccountTableViewCell.ViewModel)
}

final class AccountTableViewCell: UITableViewCell {

    @IBOutlet private weak var nameLabel: UILabel!
    @IBOutlet private weak var balanceLabel: UILabel!

    struct ViewModel {
        let name: String
        let balance: String
    }
}

extension AccountTableViewCell: AccountTableViewCellDelegate {
    func configure(with data: ViewModel) {
        nameLabel.text = data.name
        balanceLabel.text = data.balance
    }
}
