import UIKit
import FirebaseFirestore
import FirebaseAuth

final class StartCoordinator: Coordinator {
    var navigationController: UINavigationController
    let firestore: Firestore
    let auth: Auth

    private var startViewModel: StartViewModel {
        let authService = FirebaseAuthService(auth: auth)
        let viewModel = StartViewModel(authService: authService, coordinator: self)
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

    func pushToBankerViewController(uid: String) {
        let bankerViewModel = BankerViewModel(uid: uid)
        bankerViewModel.coordinatorDelegate = self
        let bankerViewController = BankerViewController(viewModel: bankerViewModel)
        navigationController.pushViewController(bankerViewController, animated: true)
    }

    func pushToRoomViewController(uid: String) {
        let roomViewModel = RoomViewModel()
        roomViewModel.coordinatorDelegate = self
        let roomViewController = RoomViewController(viewModel: roomViewModel)
        navigationController.pushViewController(roomViewController, animated: true)
    }
}

extension StartCoordinator: BankerViewModelCoordinatorDelegate, RoomViewModelCoordinatorDelegate, PlayerViewModelCoordinatorDelegate {
    
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
