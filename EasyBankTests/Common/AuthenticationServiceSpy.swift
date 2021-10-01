@testable import EasyBank
import UIKit
import FirebaseAuth

final class AuthenticationServiceSpy: AuthService {
    private(set) var removeStateDidChangeListenerCalled = false
    var userLogged: Bool?
    
    func detectAuthenticationStatus(completion: @escaping (Bool) -> Void) {
        guard let userLogged = userLogged else { return }
        completion(userLogged)
    }
    
    func removeStateDidChangeListener() {
        removeStateDidChangeListenerCalled = true
    }
    
    func getAuthViewController(completion: @escaping (UIViewController) -> Void) {
        
    }
    
    func getUser(completion: @escaping (User?) -> Void) {
        
    }
    
    func signOut() {
        
    }
    
    func reauthenticate(with password: String, completion: @escaping (String?) -> Void) {
        
    }
    
    func updatePassword(with password: String, completion: @escaping (String?) -> Void) {
        
    }
    
    func sendPasswordReset(with email: String, completion: @escaping (String?) -> Void) {
        
    }
    
    func deleteUser(completion: @escaping (String?) -> Void) {
        
    }
    
    func updateDisplayName(with newName: String, completion: @escaping (String?) -> Void) {
        
    }
    
    func updateEmailAddress(with newEmail: String, completion: @escaping (String?) -> Void) {
        
    }
}
