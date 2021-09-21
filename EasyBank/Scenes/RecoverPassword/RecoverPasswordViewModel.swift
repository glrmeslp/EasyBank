final class RecoverPasswordViewModel {
    private let authService: AuthService

    init(authService: AuthService) {
        self.authService = authService
    }

    func sendPasswordReset(with email: String, completion: @escaping (String) -> Void) {
        authService.sendPasswordReset(with: email) { error in
            guard let error = error else {
                completion("Follow the instructions sent to \(email) to recover your password.")
                return
            }
            completion(error)
        }
    }
}
