protocol ScannerViewModelCoordinatorDelegate: AnyObject {
    func pushToPayViewController(with code: String)
}

final class ScannerViewModel {
    private weak var coordinatorDelegate: ScannerViewModelCoordinatorDelegate?

    init(coordinator: ScannerViewModelCoordinatorDelegate) {
        self.coordinatorDelegate = coordinator
    }

    func showPayViewController(with code: String) {
        coordinatorDelegate?.pushToPayViewController(with: code)
    }
}
