protocol HomeViewModelDelegate: AnyObject {
    func showErrorMessage(with message: String)
}

final class HomeViewModel {
    private var roomName: String?
    private var uid: String?
    private let transferMenu: [[String]] = [
        ["Pay QR Code","qrcode"],
        ["Transfer","transferIcon"],
        ["Receive","receiveIcon"]
    ]

    weak var viewDelegate: HomeViewModelDelegate?

    init(with roomName: String, and uid: String) {
        self.roomName = roomName
        self.uid = uid
    }

    func getAccountInformation(completion: @escaping (Account) -> Void) {
        guard let roomName = roomName, let uid = uid else { return }
        DatabaseService.shared.getAccount(roomName, uid) { account, _ in
            guard let account = account else { return }
            completion(account)
        }
    }
    
    func getRoomNameAndUserId(completion: @escaping (String, String) -> Void) {
        guard let roomName = roomName, let uid = uid else { return }
        completion(roomName, uid)
    }
    
    func getTransferMenu(completion: @escaping ([[String]]) -> Void) {
        completion(transferMenu)
    }
}

