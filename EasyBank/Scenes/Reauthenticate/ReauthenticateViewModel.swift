protocol ReauthenticateViewModelProtocol {
    func reauthenticate(with password: String)
}

final class ReauthenticateViewModel: ReauthenticateViewModelProtocol {

    private weak var coordinatorDelegate: ReauthenticateViewModelCoordinatorDelegate?
    private let authService: AuthService
    private let motive: Reautheticate

    init(coordinator: ReauthenticateViewModelCoordinatorDelegate, authService: AuthService, motive: Reautheticate) {
        self.coordinatorDelegate = coordinator
        self.authService = authService
        self.motive = motive
    }

    private func showProfileViewController() {
        coordinatorDelegate?.pushToProfileViewController()
    }

    private func deleteUser() {
        authService.deleteUser { [weak self] error in
            guard let error = error else {
                self?.coordinatorDelegate?.pushToStartViewController()
                return
            }
            self?.coordinatorDelegate?.presentAlert(message: error)
        }
    }

    private func showDeleteUserActionSheet() {
        coordinatorDelegate?.presentDeleteUserActionSheet { [weak self] _ in
            self?.deleteUser()
        }
    }

    func reauthenticate(with password: String) {
        authService.reauthenticate(with: password) { [weak self] error in
            self?.coordinatorDelegate?.didFinish()
            guard let error = error else {
                self?.reautheticateFor()
                return
            }
            self?.coordinatorDelegate?.presentAlert(message: error)
        }
    }

    private func reautheticateFor() {
        switch motive {
        case .deleteUser:
            showDeleteUserActionSheet()
        case .updateUserInformation:
            showProfileViewController()
        }
    }
}
