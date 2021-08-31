import UIKit

final class StartCoordinator: Coordinator {
    var navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        let viewModel = StartViewModel(coordinator: self)
        let startViewController = StartViewController(viewModel: viewModel)
        navigationController.pushViewController(startViewController, animated: false)
//        pushToHomeViewController(with: "test05", and: "swY5HaPQ1Edbs4kVPIHndNoWhc93")
    }
}

extension StartCoordinator: StartViewModelCoordinatorDelegate {
    func pushToAuthViewController() {
        let auth = AuthService.shared.auth
        navigationController.present(auth.authViewController(), animated: true)
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
