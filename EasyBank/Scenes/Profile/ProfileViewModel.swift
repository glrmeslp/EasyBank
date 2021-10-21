protocol ProfileViewModelProtocol {
    func updateEmailAddress(_ email: String)
    func updateDispleyName(_ name: String)
    func fetchData(completion: @escaping (User) -> Void)
}

final class ProfileViewModel: UserViewModel, ProfileViewModelProtocol {

    private weak var coordinatorDelegate: ProfileViewModelCoordinatorDelegate?

    init(coordinator: ProfileViewModelCoordinatorDelegate, authService: AuthService) {
        super.init(authService: authService)
        self.coordinatorDelegate = coordinator
    }

    func updateEmailAddress(_ email: String) {
        authService.updateEmailAddress(with: email) { [weak self] error in
            guard let error = error else {
                let message = "Your email address has been updated successfully"
                self?.coordinatorDelegate?.presentAlert(message: message)
                return
            }
            self?.coordinatorDelegate?.presentAlert(message: error)
        }
    }
    
    func updateDispleyName(_ name: String) {
        authService.updateDisplayName(with: name) { [weak self] error in
            guard let error = error else {
                let message = "Your name has been updated successfully"
                self?.coordinatorDelegate?.presentAlert(message: message)
                return
            }
            self?.coordinatorDelegate?.presentAlert(message: error)
        }
    }
    
    func fetchData(completion: @escaping (User) -> Void) {
        guard let user = user else { return }
        completion(user)
    }
}
