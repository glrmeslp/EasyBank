import FirebaseAuth
import FirebaseUI

protocol AuthService {
    func detectAuthenticationStatus(completion: @escaping ( Bool) -> Void)
    func removeStateDidChangeListener()
    func getAuthViewController(completion: @escaping (UIViewController) -> Void)
    func getUser(completion: @escaping (User?) -> Void)
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
    }
}

extension AuthenticationService: AuthService {
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
