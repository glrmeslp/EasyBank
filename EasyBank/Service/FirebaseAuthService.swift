import FirebaseAuth
import FirebaseUI

protocol AuthService {
    func detectAuthenticationStatus(completion: @escaping (String?) -> Void)
    func removeStateDidChangeListener()
    func getAuthViewController(completion: @escaping (UIViewController) -> Void)
}

final class FirebaseAuthService {

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

extension FirebaseAuthService: AuthService {
    func detectAuthenticationStatus(completion: @escaping (String?) -> Void) {
        handle = auth.addStateDidChangeListener { _, user in
            guard let user = user else {
                completion(nil)
                return
            }
            completion(user.uid)
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
