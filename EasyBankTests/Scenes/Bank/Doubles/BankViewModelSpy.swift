import UIKit
@testable import EasyBank

final class BankViewModelSpy: BankViewModelDelegate {
    private(set) var fetchRoomNameCalled = false
    private(set) var fetchAccountsCalled = false
    private(set) var fetchBankMenuCalled = false
    
    func fetchRoomName(completion: @escaping (String) -> Void) {
        fetchRoomNameCalled = true
    }
    
    func fetchAccounts(completion: @escaping ([Account]) -> Void) {
        fetchAccountsCalled = true
    }
    
    func fetchBankMenu(completion: @escaping ([String]) -> Void) {
        fetchBankMenuCalled = true
    }
}
