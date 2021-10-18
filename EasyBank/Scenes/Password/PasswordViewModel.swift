protocol PasswordViewModelProtocol {
    func reauthenticate(with password: String, completion: @escaping (Bool) -> Void)
    func newPassword(_ password: String)
    func validateNewPassword(_ password: String, completion: @escaping (Bool) -> Void)
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

    func reauthenticate(with password: String, completion: @escaping (Bool) -> Void) {
        authService.reauthenticate(with: password) { [weak self] error in
            guard let error = error else {
                completion(true)
                return
            }
            completion(false)
            self?.coordinatorDelegate.presentAlert(message: error, and: nil)
        }
    }

    func newPassword(_ password: String) {
        newPassword = password
    }

    func validateNewPassword(_ password: String, completion: @escaping (Bool) -> Void) {
        guard newPassword == password else {
            coordinatorDelegate.presentAlert(message: "Please enter a valid password", and: nil)
            completion(false)
            return
        }
        authService.updatePassword(with: password) { [weak self] error in
            guard let error = error else {
                self?.coordinatorDelegate.presentAlert(message: "Password updated successfully") { _ in self?.didFinish() }
                completion(true)
                return
            }
            self?.coordinatorDelegate.presentAlert(message: error, and: nil)
            completion(false)
        }
    }

    func didFinish() {
        coordinatorDelegate.popToHomeViewController()
    }

    func showRecoverPasswordViewController() {
        coordinatorDelegate.pushToRecoverPasswordViewController()
    }
}
