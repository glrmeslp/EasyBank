protocol BankPresenting: AnyObject {
    func display(accounts: [Account])
}

final class BankPresenter {
    private let coordinator: BankCoordinating
    weak var viewController: BankDisplaying?

    init(coordinator: BankCoordinating) {
        self.coordinator = coordinator
    }
}

// MARK: - BankPresenting
extension BankPresenter: BankPresenting {
    func display(accounts: [Account]) {
        viewController?.display(accounts: accounts)
    }
}
