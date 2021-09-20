final class PayViewModel: BaseViewModel {

    private var value: Double?
    private var receiverName: String?
    private var receiverID: String?
    private var receiver: Account?
    private var payer: Account?
    private var coordiantorDelegate: PayViewModelCoordinatorDelegate?

    init(data: [String], roomName: String, authService: AuthService, databaseService: DatabaseService, coordinator: PayViewModelCoordinatorDelegate) {
        self.coordiantorDelegate = coordinator
        super.init(roomName: roomName, authService: authService, databaseService: databaseService)
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
        receiverID = uid
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
    
    func transfer(value: String, completion: @escaping (String) -> Void) {
        guard let receiver = receiver, let payer = payer, let value = value.asDouble(), let payerID = userID, let receiverID = receiverID else { return }
        roomService.transfer(roomName, value: value, payerID: payerID, payer, receiverID: receiverID, receiver) { [weak self] error, transferId in
            if let error = error {
                completion(error)
            } else {
                guard let transferId = transferId else { return }
                self?.coordiantorDelegate?.pushToCompleteTransaction(with: transferId)
            }
        }
    }
}
