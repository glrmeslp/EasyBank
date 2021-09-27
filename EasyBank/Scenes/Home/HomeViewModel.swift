
final class HomeViewModel: BaseViewModel {
    private let transferMenu: [[String]] = [
        ["Pay QR Code","qrcode"],
        ["Receive","ReceiveIcon"]
    ]

    private var coordinatorDelegate: HomeViewModelCoordinatorDelegate?

    init(with roomName: String, databaseService: DatabaseService, authService: AuthService, coordinator: HomeViewModelCoordinatorDelegate) {
        self.coordinatorDelegate = coordinator
        super.init(roomName: roomName, authService: authService, roomService: databaseService)
    }

    func getBalance(completion: @escaping (String) -> Void) {
        guard let uid = userID else { return }
        getAccount(uid: uid) { account in
            guard let value = account.balance.asCurrency() else { return }
            completion(value)
        }
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

    func showExtractViewController() {
        coordinatorDelegate?.pushToExtractViewController()
    }
}

