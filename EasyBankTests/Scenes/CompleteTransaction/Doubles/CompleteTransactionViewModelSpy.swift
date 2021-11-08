import UIKit
@testable import EasyBank

final class CompleteTransactionViewModelSpy: CompleteTransactionViewModelDelegate {
    private(set) var didFinishCalled = false
    var transferToBeReturn: Transfer?

    func fetchTransaction(completion: @escaping (Transfer) -> Void) {
        guard let transferToBeReturn = transferToBeReturn else {
            return
        }
        completion(transferToBeReturn)
    }

    func didFinish() {
        didFinishCalled = true
    }
}
