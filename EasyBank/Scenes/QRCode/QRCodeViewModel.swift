import Foundation

protocol QRCodeViewModelProtocol {
    func didFinish()
    func generateStringForQRcode(completion: @escaping (String) -> Void)
    func getValue(completion: @escaping (String) -> Void)
}

final class QRCodeViewModel: UserViewModel, QRCodeViewModelProtocol {
    private let value: Double
    private let roomName: String? = UserDefaults.standard.string(forKey: "Room")
    private weak var coordinatorDelegate: QRcodeViewModelCoordinatorDelegate?

    init(value: Double, coordinator: QRcodeViewModelCoordinatorDelegate, authService: AuthService) {
        self.value = value
        self.coordinatorDelegate = coordinator
        super.init(authService: authService)
    }

    func generateStringForQRcode(completion: @escaping (String) -> Void) {
        guard let uid = user?.identifier, let name = user?.name, let roomName = roomName else { return }
        let string = "com.glrmeslp.EasyBank00X00\(roomName)00X00\(value)00X00\(uid)00X00\(name)"
        completion(string)
    }

    func getValue(completion: @escaping (String) -> Void) {
        guard value == 0.0 else {
            guard let value = value.asCurrency() else { return }
            completion(value)
            return
        }
        completion("Will be defined by who will pay")
    }

    func didFinish() {
        coordinatorDelegate?.didFinisih()
    }
}
