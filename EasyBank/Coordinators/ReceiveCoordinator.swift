import UIKit
import FirebaseFirestore
import FirebaseAuth

protocol ReceiveViewCoordinatorDelegate: AnyObject {
    func pushToQRCodeViewController(value: Double)
}

protocol QRcodeViewModelCoordinatorDelegate: AnyObject {
    func didFinisih()
}

final class ReceiveCoordinator: Coordinator {
    var navigationController: UINavigationController
    private let auth: Auth
    
    init(navigationController: UINavigationController, auth: Auth) {
        self.navigationController = navigationController
        self.auth = auth
    }

    func start() {
        let receiveHomeViewController = ReceiveViewController(coordinator: self)
        navigationController.pushViewController(receiveHomeViewController, animated: true)
    }
}

extension ReceiveCoordinator: ReceiveViewCoordinatorDelegate {
    func pushToQRCodeViewController(value: Double) {
        let authService = AuthenticationService(auth: auth)
        let qrCodeViewModel = QRCodeViewModel(value: value, coordinator: self, authService: authService)
        let qrCodeViewController = QRCodeViewController(viewModel: qrCodeViewModel)
        navigationController.pushViewController(qrCodeViewController, animated: true)
    }
}

extension ReceiveCoordinator: QRcodeViewModelCoordinatorDelegate {
    func didFinisih() {
        navigationController.popToRootViewController(animated: true)
    }
}

