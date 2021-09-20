class BaseViewModel {
    private let authService: AuthService
    let roomService: RoomService
    var userID: String?
    let roomName: String
    var userName: String?
    var account: Account?

    init(roomName: String, authService: AuthService, databaseService: DatabaseService) {
        self.roomName = roomName
        self.authService = authService
        self.roomService = databaseService
        getUserID()
    }

    private func getUserID() {
        authService.getUser { [weak self] user in
            guard let user = user else { return }
            self?.userID = user.uid
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
