protocol RecoverPasswordViewModelProtocol {
    func sendPasswordReset(with email: String)
}

final class RecoverPasswordViewModel: RecoverPasswordViewModelProtocol {
    private let authService: AuthService
    private weak var coordinatorDelegate: RecoverPasswordViewModelCoordinatorDelegate?

    init(authService: AuthService, coordinator: RecoverPasswordViewModelCoordinatorDelegate) {
        self.authService = authService
        self.coordinatorDelegate = coordinator
    }

    func sendPasswordReset(with email: String) {
        authService.sendPasswordReset(with: email) { [weak self] error in
            guard let error = error else {
                let message = "Follow the instructions sent to \(email) to recover your password."
                self?.coordinatorDelegate?.presentAlert(message: message, and: nil)
                return
            }
            self?.coordinatorDelegate?.presentAlert(message: error, and: nil)
        }
    }
}
