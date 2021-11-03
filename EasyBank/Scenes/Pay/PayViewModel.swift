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
    private let roomName: String
    private var coordiantorDelegate: PayViewModelCoordinatorDelegate?
    private let transferService: TransferDatabaseService
    private let roomService: RoomService

    init(data: [String],
         roomName: String,
         authService: AuthService,
         roomService: RoomService,
         transferService: TransferDatabaseService,
         coordinator: PayViewModelCoordinatorDelegate) {
        self.coordiantorDelegate = coordinator
        self.transferService = transferService
        self.roomService = roomService
        self.roomName = roomName
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
        guard let uid = user?.identifier else { return }
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
        guard let receiverName = receiverName, let payerName = user?.name, let value = value.asDouble(), let payerID = user?.identifier, let receiverID = receiverID else { return }
        transferService.transfer(roomName,
                                 value: value,
                                 payerID: payerID,
                                 payerName: payerName,
                                 receiverID: receiverID,
                                 receiverName: receiverName) { [weak self] error, documentID in
            guard let error = error else {
                guard let documentID = documentID else { return }
                self?.coordiantorDelegate?.pushToCompleteTransaction(with: documentID)
                return
            }
            self?.coordiantorDelegate?.presentAlert(message: error.localizedDescription, and: handler)
        }
    }

    func presentConfirmAlert(handler: ((UIAlertAction) -> Void)?) {
        coordiantorDelegate?.presentConfirmAlert(handler: handler)
    }
}
