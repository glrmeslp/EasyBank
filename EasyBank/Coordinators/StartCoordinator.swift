import UIKit
import FirebaseFirestore
import FirebaseAuth

protocol StartViewModelCoordinatorDelegate: AnyObject {
    func pushToNewRoomViewController()
    func pushToRoomViewController()
    func pushToAuthViewController(controller: UIViewController)
}

protocol NewRoomViewModelCoordinatorDelegate: AnyObject {
    func pushToHomeViewController(with roomName: String)
    func presentAlert(with message: String, from controller: UIViewController)
}

protocol RoomViewModelCoordinatorDelegate: AnyObject {
    func pushToPlayerViewController(with roomName: String)
    func presentAlert(with message: String, from controller: UIViewController)
    func presentAlertAndPushToHome(with message: String, from controller: UIViewController, and roomName: String)
}

protocol PlayerViewModelCoordinatorDelegate: AnyObject {
    func pushToHomeViewController(with roomName: String)
    func presentAlert(with message: String, from controller: UIViewController)
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
        navigationController.pushViewController(startViewController, animated: false)
    }
}

extension StartCoordinator: StartViewModelCoordinatorDelegate {
    func pushToAuthViewController(controller: UIViewController) {
        navigationController.present(controller, animated: true, completion: nil)
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
    func presentAlert(with message: String, from controller: UIViewController) {
        controller.presentAlert(with: message)
    }
    
    func presentAlertAndPushToHome(with message: String, from controller: UIViewController, and roomName: String) {
        controller.presentAlert(with: message) { _ in
            self.pushToHomeViewController(with: roomName)
        }
    }

    func pushToHomeViewController(with roomName: String) {
        let homeCoordinator = HomeCoordinator(navigationController: navigationController, roomName: roomName, firestore: firestore, auth: auth)
        homeCoordinator.start()
    }
    
    func pushToPlayerViewController(with roomName: String) {
        let authService = AuthenticationService(auth: auth)
        let roomService = DatabaseService(firestore: firestore)
        let playerViewModel = PlayerViewModel(roomName: roomName, coordinator: self, authService: authService, roomService: roomService)
        let playerViewController = PlayerViewController(viewModel: playerViewModel)
        navigationController.pushViewController(playerViewController, animated: true)
    }
}


