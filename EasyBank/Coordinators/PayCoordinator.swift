import UIKit
import FirebaseFirestore
import FirebaseAuth

protocol ScannerViewModelCoordinatorDelegate: AnyObject {
    func pushToPayViewController(with code: [String])
    func presentAlert(with title: String, and message: String, from controller: UIViewController)
}

final class PayCoordinator: Coordinator {
    var navigationController: UINavigationController
    private let firestore: Firestore
    private let roomName: String
    private let auth: Auth

    init(navigationController: UINavigationController, firestore: Firestore, roomName: String, auth: Auth) {
        self.navigationController = navigationController
        self.firestore = firestore
        self.roomName = roomName
        self.auth = auth
    }

    func start() {
        let roomService = DatabaseService(firestore: firestore)
        let scannerViewModel = ScannerViewModel(coordinator: self, roomService: roomService)
        let scannerViewController = ScannerViewController(viewModel: scannerViewModel)
        navigationController.pushViewController(scannerViewController, animated: true)
    }
}

extension PayCoordinator: ScannerViewModelCoordinatorDelegate {
    func presentAlert(with title: String, and message: String, from controller: UIViewController) {
        controller.presentAlert(with: title, mesage: message)
    }
    
    func pushToPayViewController(with code: [String]) {
        let roomService = DatabaseService(firestore: firestore)
        let authService = AuthenticationService(auth: auth)
        let payViewModel = PayViewModel(data: code, roomName: roomName, authService: authService, roomService: roomService)
        let payViewController = PayViewController(viewModel: payViewModel)
        navigationController.pushViewController(payViewController, animated: true)
    }
}
