@testable import EasyBank
final class HomeCoordinatorSpy {
    private(set) var pushToReceiveViewControllerCalled = false
    private(set) var pushToScannerViewControllerCalled = false
    private(set) var presentHomeMenuViewControllerCalled = false
    private(set) var pushToExtractViewControllerCalled = false
    private(set) var pushToStartViewControllerCalled = false
    private(set) var pushToPasswordViewControllerCalled = false
    private(set) var pushToAccountViewControllerCalled = false
    private(set) var presentBankModeAlertCalled = false
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

extension HomeCoordinatorSpy: HomeMenuViewModelCoordinatorDelegate {
    func presentBankModeAlert() {
        presentBankModeAlertCalled = true
    }
    
    func pushToStartViewController() {
        pushToStartViewControllerCalled = true
    }
    
    func pushToPasswordViewController() {
        pushToPasswordViewControllerCalled = true
    }
    
    func pushToAccountViewController() {
        pushToAccountViewControllerCalled = true
    }
}
