import UIKit
import FirebaseFirestore
import FirebaseAuth

protocol ReceiveViewCoordinatorDelegate: AnyObject {
    func pushToQRCodeViewController(value: Double)
}

final class ReceiveCoordinator: Coordinator {
    var navigationController: UINavigationController
    private let roomName: String
    private let auth: Auth
    private let firestore: Firestore
    
    init(navigationController: UINavigationController, roomName: String, auth: Auth, firestore: Firestore) {
        self.navigationController = navigationController
        self.roomName = roomName
        self.auth = auth
        self.firestore = firestore
    }

    func start() {
        let receiveHomeViewController = ReceiveViewController(coordinator: self)
        navigationController.pushViewController(receiveHomeViewController, animated: true)
    }
}

extension ReceiveCoordinator: ReceiveViewCoordinatorDelegate {
    func pushToQRCodeViewController(value: Double) {
        let authService = AuthenticationService(auth: auth)
        let roomService = DatabaseService(firestore: firestore)
        let qrCodeViewModel = QRCodeViewModel(roomName: roomName, value: value, coordinator: self, authService: authService, roomService: roomService)
        let qrCodeViewController = QRCodeViewController(viewModel: qrCodeViewModel)
        navigationController.pushViewController(qrCodeViewController, animated: true)
    }
}

extension ReceiveCoordinator: QRcodeViewModelCoordinatorDelegate {
    func didFinisih() {
        navigationController.popToRootViewController(animated: true)
    }
}

