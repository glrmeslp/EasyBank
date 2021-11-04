import Foundation

protocol HomeMenuViewModelProtocol {
    func updatePassword()
    func leaveRoom()
    func showAccount()
    func signOut()
}

final class HomeMenuViewModel: HomeMenuViewModelProtocol {
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
        UserDefaults.standard.removeObject(forKey: "Room")
        coordinatorDelegate?.pushToStartViewController()
    }

    func showAccount() {
        coordinatorDelegate?.pushToAccountViewController()
    }

    func signOut() {
        UserDefaults.standard.removeObject(forKey: "Room")
        authService.signOut()
        coordinatorDelegate?.pushToStartViewController()
    }
}
