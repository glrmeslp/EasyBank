protocol BankInteracting: AnyObject {
    func doSomething()
}

final class BankInteractor {
    private let service: BankServicing
    private let presenter: BankPresenting

    init(service: BankServicing, presenter: BankPresenting) {
        self.service = service
        self.presenter = presenter
    }
}

// MARK: - BankInteracting
extension BankInteractor: BankInteracting {
    func doSomething() {
        presenter.displaySomething()
    }
}
