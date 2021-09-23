import FirebaseAuth
import FirebaseUI

protocol AuthService {
    func detectAuthenticationStatus(completion: @escaping (Bool) -> Void)
    func removeStateDidChangeListener()
    func getAuthViewController(completion: @escaping (UIViewController) -> Void)
    func getUser(completion: @escaping (User?) -> Void)
    func signOut()
    func reauthenticate(with password: String, completion: @escaping (String?) -> Void)
    func updatePassword(with password: String, completion: @escaping (String?) -> Void)
    func sendPasswordReset(with email: String, completion: @escaping (String?) -> Void)
    func deleteUser(completion: @escaping (String?) -> Void)
}

final class AuthenticationService {

    private let auth: Auth
    private weak var handle: AuthStateDidChangeListenerHandle?
    private let uiAuth: FUIAuth = {
        let uiAuth = FUIAuth.defaultAuthUI()!
        let actionCodeSettings = ActionCodeSettings()
        actionCodeSettings.handleCodeInApp = true
        let emailAuth = FUIEmailAuth(authAuthUI: uiAuth,
                                     signInMethod: EmailPasswordAuthSignInMethod,
                                     forceSameDevice: false,
                                     allowNewEmailAccounts: true,
                                     actionCodeSetting: actionCodeSettings)
        uiAuth.providers = [emailAuth]
        return uiAuth
    }()

    init(auth: Auth) {
        self.auth = auth
        auth.useAppLanguage()
    }
}

extension AuthenticationService: AuthService {
    func deleteUser(completion: @escaping (String?) -> Void) {
        let user = auth.currentUser
        user?.delete { error in
            if let error = error {
                completion(error.localizedDescription)
            } else {
                completion(nil)
            }
        }
    }
    
    func sendPasswordReset(with email: String, completion: @escaping (String?) -> Void) {
        auth.sendPasswordReset(withEmail: email) { error in
            guard let error = error else {
                completion(nil)
                return }
            completion(error.localizedDescription)
        }
    }
    
    func updatePassword(with password: String, completion: @escaping (String?) -> Void) {
        auth.currentUser?.updatePassword(to: password) { error in
            guard let error = error else {
                completion(nil)
                return }
            completion(error.localizedDescription)
        }
    }
    
    func reauthenticate(with password: String, completion: @escaping (String?) -> Void) {
        guard let user = auth.currentUser, let email = user.email else { return }
        let credential = EmailAuthProvider.credential(withEmail: email, password: password)
        user.reauthenticate(with: credential) { _, error  in
            guard let error = error else {
                completion(nil)
                return
            }
            completion(error.localizedDescription)
        }
    }
    
    func signOut() {
        do {
            try auth.signOut()
        } catch let signOutError as NSError {
            print("Error signing out: %@", signOutError)
        }
        
    }
    
    func getUser(completion: @escaping (User?) -> Void) {
        let user = auth.currentUser
        completion(user)
    }

    func detectAuthenticationStatus(completion: @escaping (Bool) -> Void) {
        handle = auth.addStateDidChangeListener { _, user in
            guard user != nil else {
                completion(false)
                return
            }
            completion(true)
        }
    }

    func removeStateDidChangeListener() {
        auth.removeStateDidChangeListener(handle!)
    }

    func getAuthViewController(completion: @escaping (UIViewController) -> Void) {
        let authViewController = uiAuth.authViewController()
        authViewController.modalPresentationStyle = .overCurrentContext
        completion(authViewController)
    }
}

extension FUIAuthBaseViewController {
    open override func viewWillAppear(_ animated: Bool) {
        self.navigationItem.leftBarButtonItem = nil
        setupNavigationController(isHidden: false)
    }

}
