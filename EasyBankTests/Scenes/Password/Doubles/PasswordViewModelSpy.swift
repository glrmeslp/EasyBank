@testable import EasyBank

final class PasswordViewModelSpy: PasswordViewModelProtocol {

    
    private(set) var reauthenticateCalled = false
    private(set) var didFinishCalled = false
    private(set) var showRecoverPasswordViewControllerCalled = false
    private var newPassword: String?
    var updatePasswordResultToBeReturn: Bool?
    var reauthenticateResultToBeReturn: Bool?

    func reauthenticate(with password: String, completion: @escaping (Bool) -> Void) {
        reauthenticateCalled = true
        completion(reauthenticateResultToBeReturn ?? false)
    }
    
    func validateNewPassword(_ password: String, completion: @escaping (Bool) -> Void) {
        guard newPassword == password else {
            completion(false)
            return
        }
        completion(updatePasswordResultToBeReturn ?? false)
    }
    
    func newPassword(_ password: String) {
        newPassword = password
    }
    
    func didFinish() {
        didFinishCalled = true
    }
    
    func showRecoverPasswordViewController() {
        showRecoverPasswordViewControllerCalled = true
    }
    
    
}
