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
    private(set) var roomName = ""
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
    func pushToHomeViewController(with roomName: String) {
        pushToHomeViewControllerCalled = true
        self.roomName = roomName
    }
    
    func presentAlert(with message: String) {
        presentAlertCalled = true
        messageAlert = message
    }
    
    func presentAlertAndPushToHome(with message: String, and roomName: String) {
        presentAlertAndPushToHomeCalled = true
        self.roomName = roomName
    }
    
    
}
