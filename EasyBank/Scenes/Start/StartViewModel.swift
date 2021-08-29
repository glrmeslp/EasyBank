protocol StartViewModelCoordinatorDelegate: AnyObject {
    func pushToBankerViewController(uid: String)
    func pushToPlayerViewController(uid: String)
    func pushToAuthViewController()
}

final class StartViewModel {
    
    private weak var coordinatorDelegate: StartViewModelCoordinatorDelegate?
    private var uid: String?
    
    init(coordinator: StartViewModelCoordinatorDelegate) {
        self.coordinatorDelegate = coordinator
    }

    func showBankerViewController() {
        guard let uid = uid else { return }
        coordinatorDelegate?.pushToBankerViewController(uid: uid)
    }

    func showPlayerViewController() {
        guard let uid = uid else { return }
        coordinatorDelegate?.pushToPlayerViewController(uid: uid)
    }

    func detectAuthenticationStatus() {
        AuthService.shared.detectAuthenticationStatus() { [weak self] uid in
            if let uid = uid {
                self?.uid = uid
                return
            }
            self?.showAuthViewController()
        }
    }
    
    func undetectAuthenticationStatus() {
        AuthService.shared.removeStateDidChangeListener()
    }
    
    func showAuthViewController() {
        coordinatorDelegate?.pushToAuthViewController()
    }

}
