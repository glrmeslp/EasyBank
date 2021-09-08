protocol QRcodeViewModelCoordinatorDelegate: AnyObject {
    func didFinisih()
}

final class QRCodeViewModel: BaseViewModel {

    private var roomName: String
    private var value: Double
    private weak var coordinatorDelegate: QRcodeViewModelCoordinatorDelegate?

    init(roomName: String, value: Double, coordinator: QRcodeViewModelCoordinatorDelegate, authService: AuthService) {
        self.roomName = roomName
        self.value = value
        self.coordinatorDelegate = coordinator
        super.init(authService: authService)
    }

    func generateStringForQRcode(completion: @escaping (String) -> Void) {
        guard let uid = userID else { return }
        let string = "com.glrmeslp.EasyBank00X00\(roomName)00X00\(uid)00X00\(value)"
        completion(string)
    }
    
    func getValue(completion: @escaping (String) -> Void) {
        if value == 0.0 {
            completion("Will be defined by who will pay")
        } else {
            guard let value = value.asCurrency() else { return }
            completion(value)
        }
    }

    func didFinish() {
        coordinatorDelegate?.didFinisih()
    }
}
