import UIKit
@testable import EasyBank

final class AccountCoordinatorSpy {
    private(set) var presentLeaveRoomActionSheetCalled = false
    private(set) var presentDeleteAccountActionSheetCalled = false
    private(set) var presentReauthenticateViewControllerCalled = false
    private(set) var presentUpdateNameActionSheetCalled = false
    private(set) var presentUpdateEmailActionSheetCalled = false
    private(set) var pushToStartViewControllerCalled = false
    private(set) var pushToProfileViewControllerCalled = false
    private(set) var presentAlertCalled = false
    private(set) var didFinishCalled = false
    private(set) var presentDeleteUserActionSheetCalled = false
    private(set) var handler: ((UIAlertAction) -> Void)? = nil
    private(set) var motive: Reautheticate? = nil
    private(set) var message = ""
}

extension AccountCoordinatorSpy: AccountViewModelCoordinatorDelegate {
    func presentLeaveRoomActionSheet() {
        presentLeaveRoomActionSheetCalled = true
    }
    
    func presentDeleteAccountActionSheet(handler: ((UIAlertAction) -> Void)?) {
        presentDeleteAccountActionSheetCalled = true
        self.handler = handler
    }
    
    func presentReauthenticateViewController(for motive: Reautheticate) {
        presentReauthenticateViewControllerCalled = true
        self.motive = motive
    }
    
    func presentUpdateNameActionSheet(handler: ((UIAlertAction) -> Void)?) {
        presentUpdateNameActionSheetCalled = true
        self.handler = handler
    }
    
    func presentUpdateEmailActionSheet(handler: ((UIAlertAction) -> Void)?) {
        presentUpdateEmailActionSheetCalled = true
        self.handler = handler
    }
    
    func pushToStartViewController() {
        pushToStartViewControllerCalled = true
    }
    
    func presentAlert(message: String) {
        presentAlertCalled = true
        self.message = message
    }
}

extension AccountCoordinatorSpy: ReauthenticateViewModelCoordinatorDelegate {
    func pushToProfileViewController() {
        pushToProfileViewControllerCalled = true
    }
    
    func presentDeleteUserActionSheet(with handler: @escaping ((UIAlertAction) -> Void)) {
        presentDeleteAccountActionSheetCalled = true
        self.handler = handler
    }
    
    func didFinish() {
        didFinishCalled = true
    }
}

extension AccountCoordinatorSpy: ProfileViewModelCoordinatorDelegate {}
