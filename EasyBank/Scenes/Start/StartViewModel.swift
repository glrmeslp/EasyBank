import UIKit

protocol StartViewModelProtocol {
    func showNewRoomViewController()
    func showRoomViewController()
    func detectAuthenticationStatus()
    func undetectAuthenticationStatus()
}

final class StartViewModel: StartViewModelProtocol {
    
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

    private func showAuthViewController() {
        coordinatorDelegate?.pushToAuthViewController()
    }

    func detectAuthenticationStatus() {
        authService.detectAuthenticationStatus { [weak self] userLogged in
            if !userLogged {
                self?.showAuthViewController()
            }
        }
    }
    
    func undetectAuthenticationStatus() {
        authService.removeStateDidChangeListener()
    }
}
