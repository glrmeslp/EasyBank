import UIKit
import FirebaseFirestore
import FirebaseAuth

protocol ScannerViewModelCoordinatorDelegate: AnyObject {
    func pushToPayViewController(with code: [String])
    func presentAlert(title: String, message: String, and handler: ((UIAlertAction) -> Void)?)
}

protocol PayViewModelCoordinatorDelegate: AnyObject {
    func pushToCompleteTransaction(with transferId: String)
    func presentConfirmAlert(handler: ((UIAlertAction) -> Void)?)
    func presentAlert(message: String, and handler: ((UIAlertAction) -> Void)?)
}

protocol CompleteTransactionViewModelCoordinatorDelegate: AnyObject {
    func pushToHomeViewController(from controller: UIViewController)
}

final class PayCoordinator: Coordinator {
    var navigationController: UINavigationController
    private let firestore: Firestore
    private let roomName: String
    private let auth: Auth
    
    weak var parentCoordinator: HomeCoordinator?

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

    private func didFinish() {
        parentCoordinator?.childDidFinish(self)
    }
}

extension PayCoordinator: ScannerViewModelCoordinatorDelegate {
    func presentAlert(title: String, message: String, and handler: ((UIAlertAction) -> Void)?) {
        navigationController.presentAlert(with: title, mesage: message, and: handler)
    }
    
    func pushToPayViewController(with code: [String]) {
        let databaseService = DatabaseService(firestore: firestore)
        let authService = AuthenticationService(auth: auth)
        let payViewModel = PayViewModel(data: code, roomName: roomName, authService: authService, databaseService: databaseService, coordinator: self)
        let payViewController = PayViewController(viewModel: payViewModel)
        navigationController.pushViewController(payViewController, animated: true)
    }
}

extension PayCoordinator: PayViewModelCoordinatorDelegate {
    func presentAlert(message: String, and handler: ((UIAlertAction) -> Void)?) {
        navigationController.presentAlert(with: message, and: handler)
    }

    func presentConfirmAlert(handler: ((UIAlertAction) -> Void)?) {
        let alert = UIAlertController(title: "Do you want to confirm the transaction?", message: nil, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        alert.addAction(UIAlertAction(title: "Confirm", style: .default, handler: handler))
        navigationController.present(alert, animated: true, completion: nil)
    }

    func pushToCompleteTransaction(with transferId: String) {
        let transferService = DatabaseService(firestore: firestore)
        let viewModel = CompleteTransactionViewModel(transferService: transferService, transferId: transferId, roomName: roomName, coordinator: self)
        let completeTransaction = CompleteTransactionViewController(viewModel: viewModel)
        completeTransaction.modalPresentationStyle = .fullScreen
        navigationController.present(completeTransaction, animated: true)
    }
}

extension PayCoordinator: CompleteTransactionViewModelCoordinatorDelegate {
    func pushToHomeViewController(from controller: UIViewController) {
        controller.dismiss(animated: true)
        navigationController.popToRootViewController(animated: false)
        didFinish()
    }
}
