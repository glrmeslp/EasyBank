import UIKit

protocol CompleteTransactionViewModelDelegate {
    func fetchTransaction(completion: @escaping (Transfer) -> Void)
    func didFinish()
}

final class CompleteTransactionViewModel: CompleteTransactionViewModelDelegate {

    private let transfer: Transfer
    private var coordinatorDelegate: CompleteTransactionViewModelCoordinatorDelegate?

    init(transfer: Transfer, coordinator: CompleteTransactionViewModelCoordinatorDelegate) {
        self.transfer = transfer
        self.coordinatorDelegate = coordinator
    }

    func fetchTransaction(completion: @escaping (Transfer) -> Void) {
        completion(transfer)
    }

    func didFinish() {
        coordinatorDelegate?.popToHomeViewController()
    }
}
