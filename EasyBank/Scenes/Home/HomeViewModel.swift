
final class HomeViewModel: BaseViewModel {
    private var roomName: String
    private let transferMenu: [[String]] = [
        ["Pay QR Code","qrcode"],
        ["Receive","ReceiveIcon"]
    ]
    private let roomService: RoomService

    private weak var coordinatorDelegate: HomeViewModelCoordinatorDelegate?

    init(with roomName: String, roomService: RoomService, authService: AuthService, coordinator: HomeViewModelCoordinatorDelegate) {
        self.roomName = roomName
        self.roomService = roomService
        self.coordinatorDelegate = coordinator
        super.init(authService: authService)
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
        coordinatorDelegate?.pushToReceiveViewController(roomName: roomName)
        
    }

    func showPayViewController() {
        coordinatorDelegate?.pushToScannerViewController()
    }
}

