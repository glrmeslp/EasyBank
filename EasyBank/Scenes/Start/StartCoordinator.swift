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
    func pushToBankerViewController() {
        let bankerViewController = BankerViewController()
        navigationController.pushViewController(bankerViewController, animated: true)
    }

    func pushToPlayerViewController() {
        let playerViewController = PlayerViewController()
        navigationController.pushViewController(playerViewController, animated: true)
    }
}
