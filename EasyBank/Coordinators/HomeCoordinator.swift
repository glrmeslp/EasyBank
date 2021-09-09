import UIKit
import FirebaseFirestore
import FirebaseAuth

protocol HomeViewModelCoordinatorDelegate: AnyObject {
    func pushToReceiveViewController()
    func pushToScannerViewController()
}

final class HomeCoordinator: Coordinator {
    
    var navigationController: UINavigationController
    
    private let roomName: String
    private let firestore: Firestore
    private let auth: Auth

    private var homeViewModel: HomeViewModel {
        let roomService = DatabaseService(firestore: firestore)
        let authService = AuthenticationService(auth: auth)
        let viewModel = HomeViewModel(with: roomName,
                                      roomService: roomService,
                                      authService: authService,
                                      coordinator: self)
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

extension HomeCoordinator: HomeViewModelCoordinatorDelegate {
    func pushToScannerViewController() {
        let payCoordinator = PayCoordinator(navigationController: navigationController, firestore: firestore, roomName: roomName, auth: auth)
        payCoordinator.start()
    }
    
    func pushToReceiveViewController() {
        let receiveCoordinator = ReceiveCoordinator(navigationController: navigationController, roomName: roomName, auth: auth, firestore: firestore)
        receiveCoordinator.start()
    }
}

