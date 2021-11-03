import UIKit
@testable import EasyBank

final class PayCoordinatorSpy {
    private(set) var pushToPayViewControllerCalled = false
    private(set) var presentAlertCalled = false
    private(set) var handlerReturned: ((UIAlertAction) -> Void)? = nil
    private(set) var titleReturned = ""
    private(set) var messageReturned = ""
    private(set) var codeReturned = [""]
    private(set) var pushToCompleteTransactionCalled = false
    private(set) var presentConfirmAlertCalled = false
    private(set) var transferIdReturned = ""
}

extension PayCoordinatorSpy: ScannerViewModelCoordinatorDelegate {
    func pushToPayViewController(with code: [String]) {
        pushToPayViewControllerCalled = true
        codeReturned = code
    }
    
    func presentAlert(title: String, message: String, and handler: ((UIAlertAction) -> Void)?) {
        presentAlertCalled = true
        handlerReturned = handler
        titleReturned = title
        messageReturned = message
    }
}

extension PayCoordinatorSpy: PayViewModelCoordinatorDelegate {
    func pushToCompleteTransaction(with transferId: String) {
        pushToCompleteTransactionCalled = true
        transferIdReturned = transferId
    }
    
    func presentConfirmAlert(handler: ((UIAlertAction) -> Void)?) {
        presentConfirmAlertCalled = true
        handlerReturned = handler
    }
    
    func presentAlert(message: String, and handler: ((UIAlertAction) -> Void)?) {
        presentAlertCalled = true
        handlerReturned = handler
        messageReturned = message
    }
}
