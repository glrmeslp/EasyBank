@testable import EasyBank
import UIKit

final class AuthenticationServiceSpy: AuthService {
    private(set) var removeStateDidChangeListenerCalled = false
    private(set) var signOutCalled = false
    private(set) var reauthenticateCalled = false
    var reauthenticateErrorToBeReturn: String?
    var updatePasswordErrorToBeReturn: String?
    var sendPasswordResetErrorToBeReturn: String?
    var user: User?
    
    func detectAuthenticationStatus(completion: @escaping (Bool) -> Void) {
        guard user != nil else {
            completion(false)
            return
        }
        completion(true)
    }
    
    func removeStateDidChangeListener() {
        removeStateDidChangeListenerCalled = true
    }
    
    func getUser(completion: @escaping (User) -> Void) {
        guard let user = user else { return }
        completion(user)
    }
    
    func signOut() {
        signOutCalled = true
    }
    
    func reauthenticate(with password: String, completion: @escaping (String?) -> Void) {
        reauthenticateCalled = true
        completion(reauthenticateErrorToBeReturn)
    }
    
    func updatePassword(with password: String, completion: @escaping (String?) -> Void) {
        completion(updatePasswordErrorToBeReturn)
    }
    
    func sendPasswordReset(with email: String, completion: @escaping (String?) -> Void) {
        completion(sendPasswordResetErrorToBeReturn)
    }
    
    func deleteUser(completion: @escaping (String?) -> Void) {
        
    }
    
    func updateDisplayName(with newName: String, completion: @escaping (String?) -> Void) {
        
    }
    
    func updateEmailAddress(with newEmail: String, completion: @escaping (String?) -> Void) {
        
    }
}
