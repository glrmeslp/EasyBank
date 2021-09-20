
final class HomeViewModel: BaseViewModel {
    private let transferMenu: [[String]] = [
        ["Pay QR Code","qrcode"],
        ["Receive","ReceiveIcon"]
    ]

    private var coordinatorDelegate: HomeViewModelCoordinatorDelegate?

    init(with roomName: String, databaseService: DatabaseService, authService: AuthService, coordinator: HomeViewModelCoordinatorDelegate) {
        self.coordinatorDelegate = coordinator
        super.init(roomName: roomName, authService: authService, databaseService: databaseService)
    }

    func getAccountInformation(completion: @escaping (Account) -> Void) {
        getAccount { account in
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

    func showExtractViewController() {
        guard let account = account else { return }
        coordinatorDelegate?.pushToExtractViewController(with: account.userName)
    }
}

