import FirebaseAuth
import FirebaseUI

final class AuthService {
    
    static let shared = AuthService()
    private weak var handle: AuthStateDidChangeListenerHandle?
    
    let auth: FUIAuth = {
        let auth = FUIAuth.defaultAuthUI()!
        let actionCodeSettings = ActionCodeSettings()
        actionCodeSettings.handleCodeInApp = true
        let emailAuth = FUIEmailAuth(authAuthUI: auth,
                                     signInMethod: EmailPasswordAuthSignInMethod,
                                     forceSameDevice: false,
                                     allowNewEmailAccounts: true,
                                     actionCodeSetting: actionCodeSettings)
        auth.providers = [emailAuth]
        return auth
    }()

    func detectAuthenticationStatus(completion: @escaping (String?) -> Void) {
        handle = Auth.auth().addStateDidChangeListener { _, user in
            guard let user = user else {
                completion(nil)
                return
            }
            completion(user.uid)
        }
    }

    func removeStateDidChangeListener() {
        Auth.auth().removeStateDidChangeListener(handle!)
    }
}
