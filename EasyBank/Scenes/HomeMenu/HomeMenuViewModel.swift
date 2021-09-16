final class HomeMenuViewModel {
    private let authService: AuthService
    private var coordinatorDelegate: HomeMenuViewModelCoordinatorDelegate?

    init(authService: AuthService, coordinator: HomeMenuViewModelCoordinatorDelegate) {
        self.authService = authService
        self.coordinatorDelegate = coordinator
    }

    func updatePassword() {
        print("Password Button Tapped")
    }

    func leaveRoom() {
        coordinatorDelegate?.pushToStartViewController()
    }

    func showAccount() {
        print("Account Button Tapped")
    }

    func signOut() {
        authService.signOut()
        coordinatorDelegate?.pushToStartViewController()
    }
}
