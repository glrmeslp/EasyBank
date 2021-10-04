import FirebaseAuth

class BaseViewModel {
    let authService: AuthService
    let roomService: RoomService
    let roomName: String
    private(set) var user: User?
    private(set) var account: Account?

    init(roomName: String, authService: AuthService, roomService: RoomService) {
        self.roomName = roomName
        self.authService = authService
        self.roomService = roomService
        getUser()
    }

    func getUser() {
        authService.getUser { [weak self] user in
            self?.user = user
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
