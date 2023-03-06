protocol AccountListViewCellPresenting: AnyObject {
    func configure(data: Account)
}

final class AccountListViewCellPresenter {
    weak var view: AccountListViewCellDisplaying?
}

extension AccountListViewCellPresenter: AccountListViewCellPresenting {
    func configure(data: Account) {
        view?.display(name: data.userName)
        
        if let balance = data.balance.asCurrency() {
            view?.display(balance: balance)
        }
    }
}
