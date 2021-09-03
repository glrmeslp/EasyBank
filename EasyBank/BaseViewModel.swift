class BaseViewModel {
    private let authService: AuthService
    internal var userID: String?
    
    init(authService: AuthService) {
        self.authService = authService
        getUserID()
    }
    
    internal func getUserID() {
        authService.getUser { [weak self] user in
            guard let user = user else { return }
            self?.userID = user.uid
        }
    }
}
