
final class HomeViewModel: BaseViewModel {
    private let transferMenu: [[String]] = [
        ["Pay QR Code","qrcode"],
        ["Receive","ReceiveIcon"]
    ]
    private let roomService: RoomService

    private var coordinatorDelegate: HomeViewModelCoordinatorDelegate?

    init(with roomName: String, roomService: RoomService, authService: AuthService, coordinator: HomeViewModelCoordinatorDelegate) {
        self.roomService = roomService
        self.coordinatorDelegate = coordinator
        super.init(roomName: roomName, authService: authService, roomService: roomService)
    }

    func getAccountInformation(completion: @escaping (Account) -> Void) {
        guard let uid = userID else { return }
        roomService.getAccount(roomName: roomName, uid: uid) { account, _ in
            guard let account = account else { return }
            completion(account)
        }
    }
    
    func getRoomNameAndUserId(completion: @escaping (String, String) -> Void) {
        guard let uid = userID else { return }
        completion(roomName, uid)
    }
    
    func getTransferMenu(completion: @escaping ([[String]]) -> Void) {
        completion(transferMenu)
    }

    func showReceiveViewController() {
        coordinatorDelegate?.pushToReceiveViewController()
    }

    func showPayViewController() {
        coordinatorDelegate?.pushToScannerViewController()
    }

    func showHomeMenuViewController() {
        coordinatorDelegate?.presentHomeMenuViewController()
    }
}

