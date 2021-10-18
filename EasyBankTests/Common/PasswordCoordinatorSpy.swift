import UIKit
@testable import EasyBank

final class PasswordCoordinatorSpy {
    private(set) var popToHomeViewControllerCalled = false
    private(set) var pushToRecoverPasswordViewControllerCalled = false
    private(set) var presentAlertCalled = false
    private(set) var alertMessage = ""
}

extension PasswordCoordinatorSpy: PasswordViewModelCoordinatorDelegate {
    func presentAlert(message: String, and handler: ((UIAlertAction) -> Void)?) {
        presentAlertCalled = true
        alertMessage = message
    }
    
    func popToHomeViewController() {
        popToHomeViewControllerCalled = true
    }
    
    func pushToRecoverPasswordViewController() {
        pushToRecoverPasswordViewControllerCalled = true
    }
}
