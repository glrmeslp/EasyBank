import  UIKit

protocol PayViewModelDelegate {
    func fetchBalance(completion: @escaping (String) -> Void)
    func fetchData(completion: @escaping (String, Double) -> Void)
    func transfer(value: String, handler: ((UIAlertAction) -> Void)?)
    func presentConfirmAlert(handler: ((UIAlertAction) -> Void)?)
}

final class PayViewModel: UserViewModel, PayViewModelDelegate {

    private var value: Double?
    private var receiverName: String?
    private var receiverID: String?
    private let roomName: String? = UserDefaults.standard.string(forKey: "Room")
    private var coordiantorDelegate: PayViewModelCoordinatorDelegate?
    private let transferService: TransferDatabaseService
    private let roomService: RoomService

    init(data: [String],
         authService: AuthService,
         roomService: RoomService,
         transferService: TransferDatabaseService,
         coordinator: PayViewModelCoordinatorDelegate) {
        self.coordiantorDelegate = coordinator
        self.transferService = transferService
        self.roomService = roomService
        super.init(authService: authService)
        setup(data: data)
    }

    private func setup(data: [String]) {
        var newData = data
        guard let value = newData.first, let receiverName = newData.last else { return }
        self.value = Double(value)
        self.receiverName = receiverName
        newData.removeLast()
        guard let uid = newData.last else { return }
        receiverID = uid
    }

    func fetchBalance(completion: @escaping (String) -> Void) {
        guard let uid = user?.identifier, let roomName = roomName else { return }
        roomService.getAccount(roomName: roomName, uid: uid) { account, _  in
            guard let value = account?.balance.asCurrency() else { return }
            completion(value)
        }
    }

    func fetchData(completion: @escaping (String, Double) -> Void) {
        guard let receiverName = receiverName, let value = value else { return }
        completion(receiverName, value)
    }

    func transfer(value: String, handler: ((UIAlertAction) -> Void)?) {
        guard let receiverName = receiverName,
              let payerName = user?.name,
              let value = value.asDouble(),
              let payerID = user?.identifier,
              let receiverID = receiverID,
              let roomName = roomName else { return }
        transferService.transfer(roomName,
                                 value: value,
                                 payerID: payerID,
                                 payerName: payerName,
                                 receiverID: receiverID,
                                 receiverName: receiverName) { [weak self] error, transfer in
            guard let error = error else {
                guard let transfer = transfer else { return }
                self?.coordiantorDelegate?.pushToCompleteTransaction(with: transfer)
                return
            }
            self?.coordiantorDelegate?.presentAlert(message: error.localizedDescription, and: handler)
        }
    }

    func presentConfirmAlert(handler: ((UIAlertAction) -> Void)?) {
        coordiantorDelegate?.presentConfirmAlert(handler: handler)
    }
}
