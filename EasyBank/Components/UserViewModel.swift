class UserViewModel {
    let authService: AuthService
    private(set) var user: User?

    init(authService: AuthService) {
        self.authService = authService
        getUser()
    }

    private func getUser() {
        authService.getUser { [weak self] user in
            self?.user = user
        }
    }
}
