@testable import EasyBank

final class PasswordViewModelSpy: PasswordViewModelProtocol {
    private(set) var reauthenticateCalled = false
    private(set) var didFinishCalled = false
    private(set) var showRecoverPasswordViewControllerCalled = false
    var newPassword: String?
    var updatePasswordErrorToBeReturn: String?
    var reauthenticateErrorToBeReturn: String?
    
    func reauthenticate(with password: String, completion: @escaping (String?) -> Void) {
        reauthenticateCalled = true
        completion(reauthenticateErrorToBeReturn)
    }
    
    func newPassword(_ password: String) {
        newPassword = password
    }
    
    func validateNewPassword(_ password: String, completion: @escaping (String, Bool) -> Void) {
        guard newPassword == password else {
            completion("Please enter a valid password", false)
            return
        }
        guard let updatePasswordErrorToBeReturn = updatePasswordErrorToBeReturn else {
            completion("Password updated successfully", true)
            return
        }
        completion(updatePasswordErrorToBeReturn, false)

    }
    
    func didFinish() {
        didFinishCalled = true
    }
    
    func showRecoverPasswordViewController() {
        showRecoverPasswordViewControllerCalled = true
    }
    
    
}
