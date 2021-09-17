import UIKit

final class StartViewModel {
    
    private var coordinatorDelegate: StartViewModelCoordinatorDelegate?
    private let authService: AuthService
    
    init(authService: AuthService, coordinator: StartViewModelCoordinatorDelegate) {
        self.coordinatorDelegate = coordinator
        self.authService = authService
    }

    func showNewRoomViewController() {
        coordinatorDelegate?.pushToNewRoomViewController()
    }

    func showRoomViewController() {
        coordinatorDelegate?.pushToRoomViewController()
    }

    func detectAuthenticationStatus() {
        authService.detectAuthenticationStatus { [weak self] userLogged in
            if userLogged == false {
                self?.showAuthViewController()
            }
        }
    }
    
    func undetectAuthenticationStatus() {
        authService.removeStateDidChangeListener()
    }
    
    func showAuthViewController() {
        authService.getAuthViewController { [weak self] viewController in
            self?.coordinatorDelegate?.pushToAuthViewController(controller: viewController)
        }
    }

}
