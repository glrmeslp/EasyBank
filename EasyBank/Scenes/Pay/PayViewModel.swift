final class PayViewModel: BaseViewModel {

    private let roomService: RoomService
    private var value: Double?
    private var receiverName: String?
    private var receiver: Account?
    private var payer: Account?

    init(data: [String], roomName: String, authService: AuthService, roomService: RoomService) {
        self.roomService = roomService
        super.init(roomName: roomName, authService: authService, roomService: roomService)
        setup(data: data)
    }
    
    private func setup(data: [String]) {
        var newData = data
        newData.removeFirst()
        guard let value = newData.first, let receiverName = newData.last else { return }
        self.value = Double(value)
        self.receiverName = receiverName
        newData.removeLast()
        guard let uid = newData.last else { return }
        getAccount(uid: uid) { [weak self] account in
            self?.receiver = account
        }
    }
    
    private func getAccount(uid: String, completion: @escaping (Account) -> Void ) {
        roomService.getAccount(roomName: roomName, uid: uid) { account, _ in
            guard let account = account else { return }
            completion(account)
        }
    }
    
    func getPayerAccount(completion: @escaping (Account) -> Void) {
        guard let uid = userID else { return }
        getAccount(uid: uid) { [weak self] account in
            self?.payer = account
            completion(account)
        }
    }
    
    func getInformation(completion: @escaping (String, Double) -> Void) {
        guard let receiverName = receiverName, let value = value else { return }
        completion(receiverName, value)
    }
}
