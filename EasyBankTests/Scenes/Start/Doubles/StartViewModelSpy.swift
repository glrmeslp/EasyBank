@testable import EasyBank

final class StartViewModelSpy: StartViewModelProtocol {
    private(set) var detectAuthenticationStatusCalled = false
    private(set) var undetectAuthenticationStatusCalled = false
    private(set) var showNewRoomViewControllerCalled = false
    private(set) var showRoomViewControllerCalled = false

    func showNewRoomViewController() {
        showNewRoomViewControllerCalled = true
    }

    func showRoomViewController() {
        showRoomViewControllerCalled = true
    }

    func detectAuthenticationStatus() {
        detectAuthenticationStatusCalled = true
    }
    
    func undetectAuthenticationStatus() {
        undetectAuthenticationStatusCalled = true
    }
}
