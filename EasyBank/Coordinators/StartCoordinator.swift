import UIKit
import FirebaseFirestore
import FirebaseAuth

protocol StartViewModelCoordinatorDelegate: AnyObject {
    func pushToNewRoomViewController()
    func pushToRoomViewController()
    func pushToAuthViewController()
}

protocol NewRoomViewModelCoordinatorDelegate: AnyObject {
    func pushToHomeViewController(with roomName: String)
    func presentAlert(with message: String)
}

protocol RoomViewModelCoordinatorDelegate: AnyObject {
    func pushToHomeViewController(with roomName: String)
    func presentAlert(with message: String)
    func presentAlertAndPushToHome(with message: String, and roomName: String)
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
        let authService = AuthenticationService(auth: auth)
        let viewModel = RoomViewModel(coordinator: self, roomService: roomService, authService: authService)
        return viewModel
    }

    init(navigationController: UINavigationController, firestore: Firestore, auth: Auth) {
        self.navigationController = navigationController
        self.firestore = firestore
        self.auth = auth
    }
    
    func start() {
        let startViewController = StartViewController(viewModel: startViewModel)
        navigationController.setViewControllers([startViewController], animated: false)
    }
}

extension StartCoordinator: StartViewModelCoordinatorDelegate {
    func pushToAuthViewController() {
        let authService = AuthenticationService(auth: auth)
        let authViewController = authService.uiAuth.authViewController()
        authViewController.modalPresentationStyle = .overCurrentContext
        navigationController.present(authViewController, animated: true)
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

extension StartCoordinator: NewRoomViewModelCoordinatorDelegate, RoomViewModelCoordinatorDelegate {
    func presentAlert(with message: String) {
        navigationController.presentAlert(with: message)
    }

    func presentAlertAndPushToHome(with message: String, and roomName: String) {
        navigationController.presentAlert(with: message) { _ in
            self.pushToHomeViewController(with: roomName)
        }
    }

    func pushToHomeViewController(with roomName: String) {
        let homeCoordinator = HomeCoordinator(navigationController: navigationController, roomName: roomName, firestore: firestore, auth: auth)
        homeCoordinator.start()
    }
}


