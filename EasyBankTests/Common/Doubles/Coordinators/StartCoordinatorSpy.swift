import UIKit
@testable import EasyBank

final class StartCoordinatorSpy {
    private(set) var pushToNewRoomViewControllerCalled = false
    private(set) var pushToRoomViewControllerCalled = false
    private(set) var pushToAuthViewControllerCalled = false
    private(set) var pushToHomeViewControllerCalled = false
    private(set) var presentAlertCalled = false
    private(set) var messageAlert = ""
    private(set) var presentAlertAndPushToHomeCalled = false
}

extension StartCoordinatorSpy: StartViewModelCoordinatorDelegate {
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

extension StartCoordinatorSpy: NewRoomViewModelCoordinatorDelegate, RoomViewModelCoordinatorDelegate {
    func pushToHomeViewController() {
        pushToHomeViewControllerCalled = true
    }
    
    func presentAlert(with message: String) {
        presentAlertCalled = true
        messageAlert = message
    }
    
    func presentAlertAndPushToHome(with message: String) {
        presentAlertAndPushToHomeCalled = true
        messageAlert = message
    }
    
    
}
