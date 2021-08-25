protocol StartViewModelCoordinatorDelegate: AnyObject {
    func pushToBankerViewController()
    func pushToPlayerViewController()
}

final class StartViewModel {
    
    private weak var coordinatorDelegate: StartViewModelCoordinatorDelegate?
    
    init(coordinator: StartViewModelCoordinatorDelegate) {
        self.coordinatorDelegate = coordinator
    }

    func showBankerViewController() {
        coordinatorDelegate?.pushToBankerViewController()
    }

    func showPlayerViewController() {
        coordinatorDelegate?.pushToPlayerViewController()
    }

}
