final class PasswordViewModel {

    private var newPassword: String?
    private let authService: AuthService
    private weak var coordinatorDelegate: PasswordViewModelCoordinatorDelegate?

    init(authService: AuthService, coordinator: PasswordViewModelCoordinatorDelegate) {
        self.authService = authService
        self.coordinatorDelegate = coordinator
    }

    func reauthenticate(with password: String, completion: @escaping (String?) -> Void) {
        authService.reauthenticate(with: password) { error in
            guard let error = error else {
                completion(nil)
                return
            }
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

    func didFinish(){
        coordinatorDelegate?.popToHomeViewController()
    }

    func showForgotPasswordViewController() {
        coordinatorDelegate?.pushToForgotPasswordViewController()
    }
}
