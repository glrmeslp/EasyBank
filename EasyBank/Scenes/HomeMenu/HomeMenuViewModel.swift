final class HomeMenuViewModel {
    private let authService: AuthService
    private weak var coordinatorDelegate: HomeMenuViewModelCoordinatorDelegate?

    init(authService: AuthService, coordinator: HomeMenuViewModelCoordinatorDelegate) {
        self.authService = authService
        self.coordinatorDelegate = coordinator
    }

    func updatePassword() {
        coordinatorDelegate?.pushToPasswordViewController()
    }

    func leaveRoom() {
        coordinatorDelegate?.pushToStartViewController()
    }

    func showAccount() {
        coordinatorDelegate?.pushToAccountViewController()
    }

    func signOut() {
        authService.signOut()
        coordinatorDelegate?.pushToStartViewController()
    }
}
