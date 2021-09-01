protocol HomeViewModelCoordinatorDelegate: AnyObject {
    func pushToReceiveViewController(uid: String)
    func pushToScannerViewController()
}

final class HomeViewModel {
    private var roomName: String?
    private var uid: String?
    private let transferMenu: [[String]] = [
        ["Pay QR Code","qrcode"],
        ["Receive","ReceiveIcon"]
    ]

    weak var coordinatorDelegate: HomeViewModelCoordinatorDelegate?

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

    func showReceiveViewController() {
        guard let uid = uid else { return }
        coordinatorDelegate?.pushToReceiveViewController(uid: uid)
    }

    func showPayViewController() {
        coordinatorDelegate?.pushToScannerViewController()
    }
}

