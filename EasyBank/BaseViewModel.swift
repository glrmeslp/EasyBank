class BaseViewModel {
    private let authService: AuthService
    private let roomService: RoomService
    internal var userID: String?
    internal let roomName: String
    internal var userName: String?

    init(roomName: String, authService: AuthService, roomService: RoomService) {
        self.roomName = roomName
        self.authService = authService
        self.roomService = roomService
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
            completion(account.userName)
        }
    }
}
