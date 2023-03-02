protocol BankPresenting: AnyObject {
    func displaySomething()
    func didNextStep(action: BankAction)
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
    func displaySomething() {
//        viewController?.displaySomething()
    }
    
    func didNextStep(action: BankAction) {
        coordinator.perform(action: action)
    }
}
