@testable import EasyBank

final class StartCoordinatorSpy: StartViewModelCoordinatorDelegate {
    private(set) var pushToNewRoomViewControllerCalled = false
    private(set) var pushToRoomViewControllerCalled = false
    private(set) var pushToAuthViewControllerCalled = false
    
    func pushToNewRoomViewController() {
        pushToNewRoomViewControllerCalled = true
    }
    
    func pushToRoomViewController() {
        pushToRoomViewControllerCalled = true
    }
    
    func pushToAuthViewController() {
        pushToAuthViewControllerCalled = true
    }
}
