final class PayViewModel: BaseViewModel {

    private var value: Double?
    private var receiverName: String?
    private var receiverID: String?
    private var coordiantorDelegate: PayViewModelCoordinatorDelegate?
    private let transferService: TransferDatabaseService

    init(data: [String], roomName: String, authService: AuthService, databaseService: DatabaseService, coordinator: PayViewModelCoordinatorDelegate) {
        self.coordiantorDelegate = coordinator
        self.transferService = databaseService
        super.init(roomName: roomName, authService: authService, roomService: databaseService)
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
    }

    func getBalance(completion: @escaping (String) -> Void) {
        guard let uid = userID else { return }
        getAccount(uid: uid) { account in
            guard let value = account.balance.asCurrency() else { return }
            completion(value)
        }
    }

    func getInformation(completion: @escaping (String, Double) -> Void) {
        guard let receiverName = receiverName, let value = value else { return }
        completion(receiverName, value)
    }

    func transfer(value: String, completion: @escaping (String) -> Void) {
        guard let receiverName = receiverName, let payerName = userName, let value = value.asDouble(), let payerID = userID, let receiverID = receiverID else { return }
        transferService.transfer(roomName, value: value, payerID: payerID, payerName: payerName, receiverID: receiverID, receiverName: receiverName) { [weak self] error, documentID in
            guard let error = error else {
                guard let documentID = documentID else { return }
                self?.coordiantorDelegate?.pushToCompleteTransaction(with: documentID)
                return
            }
            completion(error.localizedDescription)
        }
    }
}
