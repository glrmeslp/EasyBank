import UIKit
import FirebaseFirestore
import FirebaseAuth

protocol StartViewModelCoordinatorDelegate: AnyObject {
    func pushToNewRoomViewController()
    func pushToRoomViewController()
    func pushToAuthViewController(view: UIViewController)
}

protocol NewRoomViewModelCoordinatorDelegate: AnyObject {
    func pushToHomeViewController(with roomName: String, and uid: String)
}

protocol RoomViewModelCoordinatorDelegate: AnyObject {
    func pushToPlayerViewController(with roomName: String)
}

final class StartCoordinator: Coordinator {
    var navigationController: UINavigationController
    let firestore: Firestore
    let auth: Auth

    private var startViewModel: StartViewModel {
        let authService = AuthenticationService(auth: auth)
        let viewModel = StartViewModel(authService: authService, coordinator: self)
        return viewModel
    }

    private var newRoomViewModel: NewRoomViewModel {
        let roomService = DatabaseService(firestore: firestore)
        let authService = AuthenticationService(auth: auth)
        let viewModel = NewRoomViewModel(coordinator: self, roomService: roomService, authService: authService)
        return viewModel
    }

    private var roomViewModel: RoomViewModel {
        let roomService = DatabaseService(firestore: firestore)
        let viewModel = RoomViewModel(coordinator: self, roomService: roomService)
        return viewModel
    }

    init(navigationController: UINavigationController, firestore: Firestore, auth: Auth) {
        self.navigationController = navigationController
        self.firestore = firestore
        self.auth = auth
    }
    
    func start() {
        let startViewController = StartViewController(viewModel: startViewModel)
        navigationController.pushViewController(startViewController, animated: false)
    }
}

extension StartCoordinator: StartViewModelCoordinatorDelegate {
    func pushToAuthViewController(view: UIViewController) {
        navigationController.present(view, animated: true, completion: nil)
    }

    func pushToNewRoomViewController() {
        let newRoomViewController = NewRoomViewController(viewModel: newRoomViewModel)
        navigationController.pushViewController(newRoomViewController, animated: true)
    }

    func pushToRoomViewController() {
        let roomViewController = RoomViewController(viewModel: roomViewModel)
        navigationController.pushViewController(roomViewController, animated: true)
    }
}

extension StartCoordinator: NewRoomViewModelCoordinatorDelegate, RoomViewModelCoordinatorDelegate, PlayerViewModelCoordinatorDelegate {
    
    func pushToHomeViewController(with roomName: String, and uid: String) {
        let homeViewModel = HomeViewModel(with: roomName, and: uid)
        homeViewModel.coordinatorDelegate = self
        let homeViewController = HomeViewController(viewModel: homeViewModel)
        navigationController.pushViewController(homeViewController, animated: false)
    }
    
    func pushToPlayerViewController(with roomName: String) {
        let playerViewModel = PlayerViewModel(roomName: roomName)
        playerViewModel.coordinatorDelegate = self
        let playerViewController = PlayerViewController(viewModel: playerViewModel)
        navigationController.pushViewController(playerViewController, animated: true)
    }
}

extension StartCoordinator: HomeViewModelCoordinatorDelegate {
    func pushToScannerViewController() {
        let scannerViewModel = ScannerViewModel(coordinator: self)
        let scannerViewController = ScannerViewController(viewModel: scannerViewModel)
        navigationController.pushViewController(scannerViewController, animated: true)
    }
    
    func pushToReceiveViewController(uid: String, roomName: String) {
        let receiveViewModel = ReceiveViewModel(uid: uid, roomName: roomName, coordinator: self)
        let receiveViewController = ReceiveViewController(viewModel: receiveViewModel)
        navigationController.pushViewController(receiveViewController, animated: true)
    }
}

extension StartCoordinator: ReceiveViewModelCoordinatorDelegate {
    func didFinisih() {
        navigationController.popViewController(animated: true)
    }
}

extension StartCoordinator: ScannerViewModelCoordinatorDelegate {
    func pushToPayViewController(with code: String) {
        print(code)
    }
}
