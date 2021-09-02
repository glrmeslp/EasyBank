import UIKit

protocol StartViewModelCoordinatorDelegate: AnyObject {
    func pushToBankerViewController(uid: String)
    func pushToRoomViewController(uid: String)
    func pushToAuthViewController(view: UIViewController)
}

final class StartViewModel {
    
    private weak var coordinatorDelegate: StartViewModelCoordinatorDelegate?
    private var uid: String?
    private let authService: AuthService
    
    init(authService: AuthService, coordinator: StartViewModelCoordinatorDelegate) {
        self.coordinatorDelegate = coordinator
        self.authService = authService
    }

    func showBankerViewController() {
        guard let uid = uid else { return }
        coordinatorDelegate?.pushToBankerViewController(uid: uid)
    }

    func showPlayerViewController() {
        guard let uid = uid else { return }
        coordinatorDelegate?.pushToRoomViewController(uid: uid)
    }

    func detectAuthenticationStatus() {
        authService.detectAuthenticationStatus { [weak self] uid in
            if let uid = uid {
                self?.uid = uid
                return
            }
            self?.showAuthViewController()
        }
    }
    
    func undetectAuthenticationStatus() {
        authService.removeStateDidChangeListener()
    }
    
    func showAuthViewController() {
        authService.getAuthViewController { [weak self] viewController in
            self?.coordinatorDelegate?.pushToAuthViewController(view: viewController)
        }
    }

}
