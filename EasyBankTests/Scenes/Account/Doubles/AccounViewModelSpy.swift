import UIKit
@testable import EasyBank

final class AccountViewModelSpy: AccountViewModelProtocol {
    private(set) var fetchDataCalled = false
    private(set) var manageProfileInformationCalled = false
    private(set) var deleteEasyBankAccountCalled = false
    private(set) var presentUpdateEmailActionSheetCalled = false
    private(set) var presentUpdateNameActionSheetCalled = false
    private(set) var presentDeleteAccountActionSheetCalled = false
    private(set) var presentLeaveRoomActionSheetCalled = false
    private(set) var handler: ((UIAlertAction) -> Void)? = nil
    var roomNameToBeReturn: String?
    var userToBeReturn: User?

    func presentLeaveRoomActionSheet() {
        presentLeaveRoomActionSheetCalled = true
    }
    
    func presentDeleteAccountActionSheet() {
        presentDeleteAccountActionSheetCalled = true
    }
    
    func presentUpdateNameActionSheet(handler: ((UIAlertAction) -> Void)?) {
        presentUpdateNameActionSheetCalled = true
        self.handler = handler
    }
    
    func presentUpdateEmailActionSheet(handler: ((UIAlertAction) -> Void)?) {
        presentUpdateEmailActionSheetCalled = true
        self.handler = handler
    }
    
    func deleteEasyBankAccount() {
        deleteEasyBankAccountCalled = true
    }
    
    func manageProfileInformation() {
        manageProfileInformationCalled = true
    }
    
    func fecthData(completion: @escaping (String, User?) -> Void) {
        fetchDataCalled = true
        guard let roomNameToBeReturn = roomNameToBeReturn else {
            return
        }
        completion(roomNameToBeReturn, userToBeReturn)
    }
}
