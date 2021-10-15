protocol PasswordViewModelProtocol {
    func reauthenticate(with password: String, completion: @escaping (String?) -> Void)
    func newPassword(_ password: String)
    func validateNewPassword(_ password: String, completion: @escaping (String, Bool) -> Void)
    func didFinish()
    func showRecoverPasswordViewController()
}

final class PasswordViewModel: PasswordViewModelProtocol {

    private var newPassword: String?
    private let authService: AuthService
    private let coordinatorDelegate: PasswordViewModelCoordinatorDelegate

    init(authService: AuthService, coordinator: PasswordViewModelCoordinatorDelegate) {
        self.authService = authService
        self.coordinatorDelegate = coordinator
    }

    func reauthenticate(with password: String, completion: @escaping (String?) -> Void) {
        authService.reauthenticate(with: password) { error in
            completion(error)
        }
    }

    func newPassword(_ password: String) {
        newPassword = password
    }

    func validateNewPassword(_ password: String, completion: @escaping (String, Bool) -> Void) {
        guard newPassword == password else {
            completion("Please enter a valid password", false)
            return
        }
        authService.updatePassword(with: password) { error in
            guard let error = error else {
                completion("Password updated successfully", true)
                return
            }
            completion(error, false)
        }
    }

    func didFinish() {
        coordinatorDelegate.popToHomeViewController()
    }

    func showRecoverPasswordViewController() {
        coordinatorDelegate.pushToRecoverPasswordViewController()
    }
}
