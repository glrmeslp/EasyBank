import UIKit

final class StartCoordinator: Coordinator {
    var navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        let viewModel = StartViewModel()
        let startViewController = StartViewController(viewModel: viewModel)
        navigationController.pushViewController(startViewController, animated: false)
    }
    
    
}
