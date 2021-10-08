protocol HomeViewModelProtocol {
    func fetchBalance(completion: @escaping (String) -> Void)
    func fetchInformation(completion: @escaping ([[String]],String) -> Void)
    func fetchUserName(completion: @escaping (String?) -> Void)
    func showReceiveViewController()
    func showPayViewController()
    func showHomeMenuViewController()
    func showExtractViewController()
}

final class HomeViewModel: UserViewModel, HomeViewModelProtocol {

    
    private let transferMenu: [[String]] = [
        ["Pay QR Code","qrcode"],
        ["Receive","ReceiveIcon"]
    ]
    private let roomName: String
    private let roomService: RoomService

    private var coordinatorDelegate: HomeViewModelCoordinatorDelegate?

    init(with roomName: String, roomService: RoomService, authService: AuthService, coordinator: HomeViewModelCoordinatorDelegate) {
        self.coordinatorDelegate = coordinator
        self.roomName = roomName
        self.roomService = roomService
        super.init(authService: authService)
    }

    func fetchBalance(completion: @escaping (String) -> Void) {
        guard let uid = user?.identifier else { return }
        roomService.getAccount(roomName: roomName, uid: uid) { account, _  in
            guard let value = account?.balance.asCurrency() else { return }
            completion(value)
        }
    }

    func fetchInformation(completion: @escaping ([[String]],String) -> Void) {
        completion(transferMenu,roomName)
    }

    func fetchUserName(completion: @escaping (String?) -> Void) {
        getUser()
        completion(user?.name)
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

    func showExtractViewController() {
        coordinatorDelegate?.pushToExtractViewController()
    }
}

