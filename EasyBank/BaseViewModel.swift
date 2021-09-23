import FirebaseAuth

class BaseViewModel {
    let authService: AuthService
    let roomService: RoomService
    let roomName: String
    private(set) var user: User?
    private(set) var userID: String?
    private(set) var email: String?
    private(set) var userName: String?
    private(set) var account: Account?

    init(roomName: String, authService: AuthService, roomService: RoomService) {
        self.roomName = roomName
        self.authService = authService
        self.roomService = roomService
        getUser()
    }

    private func getUser() {
        authService.getUser { [weak self] user in
            guard let user = user else { return }
            self?.user = user
            self?.userID = user.uid
            self?.email = user.email
            self?.userName = user.displayName
        }
    }

    func getAccount(uid: String, completion: @escaping (Account) -> Void) {
        roomService.getAccount(roomName: roomName, uid: uid) { account, _ in
            guard let account = account else { return }
            self.account = account
            completion(account)
        }
    }
}
