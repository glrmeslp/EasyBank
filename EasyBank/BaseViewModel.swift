class BaseViewModel {
    let authService: AuthService
    let roomService: RoomService
    let roomName: String
    private(set) var userID: String?
    private(set) var email: String?
    private(set) var userName: String?
    private(set) var account: Account?

    init(roomName: String, authService: AuthService, databaseService: DatabaseService) {
        self.roomName = roomName
        self.authService = authService
        self.roomService = databaseService
        getUser()
    }

    private func getUser() {
        authService.getUser { [weak self] user in
            guard let user = user else { return }
            self?.userID = user.uid
            self?.email = user.email
        }
    }

    func getUserName(completion: @escaping (String) -> Void) {
        guard let uid = userID else { return }
        roomService.getAccount(roomName: roomName, uid: uid) { account, _ in
            guard let account = account else { return }
            self.userName = account.userName
            completion(account.userName)
        }
    }

    func getAccount(completion: @escaping (Account) -> Void) {
        guard let uid = userID else { return }
        roomService.getAccount(roomName: roomName, uid: uid) { account, _ in
            guard let account = account else { return }
            self.account = account
            completion(account)
        }
    }
}
