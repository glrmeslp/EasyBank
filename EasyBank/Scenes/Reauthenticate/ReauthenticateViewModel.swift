final class ReauthenticateViewModel {

    private weak var coordinatorDelegate: ReauthenticateViewModelCoordinatorDelegate?
    private let authService: AuthService
    private let motive: Reautheticate

    init(coordinator: ReauthenticateViewModelCoordinatorDelegate, authService: AuthService, motive: Reautheticate) {
        self.coordinatorDelegate = coordinator
        self.authService = authService
        self.motive = motive
    }

    func showProfileViewController() {
        coordinatorDelegate?.pushToProfileViewController()
    }

    private func deleteUser() {
        authService.deleteUser { _ in }
    }

    private func showStartViewController() {
        coordinatorDelegate?.pushToStartViewController()
    }

    func showDeleteUserActionSheet() {
        coordinatorDelegate?.presentDeleteUserActionSheet { _ in
            self.deleteUser()
            self.showStartViewController()
        }
    }

    func reauthenticate(with password: String, completion: @escaping (String?, Reautheticate) -> Void) {
        authService.reauthenticate(with: password) { error in
            completion(error, self.motive)
        }
    }
}
