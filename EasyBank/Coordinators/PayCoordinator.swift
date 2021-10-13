import UIKit
import FirebaseFirestore
import FirebaseAuth

protocol ScannerViewModelCoordinatorDelegate: AnyObject {
    func pushToPayViewController(with code: [String])
    func presentAlert(with title: String, and message: String, from controller: UIViewController)
}

protocol PayViewModelCoordinatorDelegate: AnyObject {
    func pushToCompleteTransaction(with transferId: String)
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
    func presentAlert(with title: String, and message: String, from controller: UIViewController) {
        controller.presentAlert(with: title, mesage: message)
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
