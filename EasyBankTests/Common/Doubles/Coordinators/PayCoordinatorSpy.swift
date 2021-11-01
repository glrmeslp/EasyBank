import UIKit
@testable import EasyBank

final class PayCoordinatorSpy {
    private(set) var pushToPayViewControllerCalled = false
    private(set) var presentAlertCalled = false
    private(set) var handlerReturned: ((UIAlertAction) -> Void)? = nil
    private(set) var titleReturned = ""
    private(set) var messageReturned = ""
    private(set) var codeReturned = [""]
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
