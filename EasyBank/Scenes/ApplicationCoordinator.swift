import UIKit

final class ApplicationCoordinator: Coordinator {
    var navigationController: UINavigationController
    
    private let window: UIWindow
    private var startCoordinator: StartCoordinator?

    init(window: UIWindow) {
        self.window = window

        navigationController = UINavigationController()

        startCoordinator = StartCoordinator(navigationController: navigationController)
    }

    func start() {
        window.rootViewController = navigationController
        startCoordinator?.start()
        window.makeKeyAndVisible()
    }
}
