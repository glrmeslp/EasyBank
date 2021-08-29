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

    func pushToPlayerViewController(uid: String) {
        let playerViewController = PlayerViewController()
        navigationController.pushViewController(playerViewController, animated: true)
    }
}

extension StartCoordinator: BankerViewModelCoordinatorDelegate {
    func pushToHomeViewController(with roomName: String, and uid: String) {
        let homeViewModel = HomeViewModel(with: roomName, and: uid)
        let homeViewController = HomeViewController(viewModel: homeViewModel)
        navigationController.pushViewController(homeViewController, animated: true)
    }
}
