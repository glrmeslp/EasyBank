import UIKit
import FirebaseFirestore
import FirebaseAuth

final class HomeCoordinator: Coordinator {
    var navigationController: UINavigationController
    
    private let roomName: String
    private let firestore: Firestore
    private let auth: Auth

    private var homeViewModel: HomeViewModel {
        let viewModel = HomeViewModel(with: roomName)
        return viewModel
    }

    init(navigationController: UINavigationController, roomName: String, firestore: Firestore, auth: Auth) {
        self.navigationController = navigationController
        self.roomName = roomName
        self.firestore = firestore
        self.auth = auth
    }

    func start() {
        let homeViewController = HomeViewController(viewModel: homeViewModel)
        navigationController.pushViewController(homeViewController, animated: true)
    }
}

//extension StartCoordinator: HomeViewModelCoordinatorDelegate {
//    func pushToScannerViewController() {
//        let scannerViewModel = ScannerViewModel(coordinator: self)
//        let scannerViewController = ScannerViewController(viewModel: scannerViewModel)
//        navigationController.pushViewController(scannerViewController, animated: true)
//    }
//
//    func pushToReceiveViewController(uid: String, roomName: String) {
//        let receiveViewModel = ReceiveViewModel(uid: uid, roomName: roomName, coordinator: self)
//        let receiveViewController = ReceiveViewController(viewModel: receiveViewModel)
//        navigationController.pushViewController(receiveViewController, animated: true)
//    }
//}
//
//extension StartCoordinator: ReceiveViewModelCoordinatorDelegate {
//    func didFinisih() {
//        navigationController.popViewController(animated: true)
//    }
//}
//
//extension StartCoordinator: ScannerViewModelCoordinatorDelegate {
//    func pushToPayViewController(with code: String) {
//        print(code)
//    }
//}
