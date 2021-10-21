@testable import EasyBank

final class HomeMenuViewModelSpy: HomeMenuViewModelProtocol {
    private(set) var updatePasswordCalled = false
    private(set) var showAccountCalled = false

    func updatePassword() {
        updatePasswordCalled = true
    }
    
    func leaveRoom() {
        
    }
    
    func showAccount() {
        showAccountCalled = true
    }
    
    func signOut() {
        
    }
}
