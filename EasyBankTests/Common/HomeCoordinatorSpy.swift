@testable import EasyBank
final class HomeCoordinatorSpy {
    private(set) var pushToReceiveViewControllerCalled = false
    private(set) var pushToScannerViewControllerCalled = false
    private(set) var presentHomeMenuViewControllerCalled = false
    private(set) var pushToExtractViewControllerCalled = false
}

extension HomeCoordinatorSpy: HomeViewModelCoordinatorDelegate {
    func pushToReceiveViewController() {
        pushToReceiveViewControllerCalled = true
    }
    
    func pushToScannerViewController() {
        pushToScannerViewControllerCalled = true
    }
    
    func presentHomeMenuViewController() {
        presentHomeMenuViewControllerCalled = true
    }
    
    func pushToExtractViewController() {
        pushToExtractViewControllerCalled = true
    }
}
