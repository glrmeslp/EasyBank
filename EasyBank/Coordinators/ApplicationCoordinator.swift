import UIKit
import FirebaseFirestore
import FirebaseAuth

final class ApplicationCoordinator: Coordinator {
    var navigationController: UINavigationController
    
    private let window: UIWindow?
    private var startCoordinator: StartCoordinator?
    private let firestore: Firestore = Firestore.firestore()
    private let auth: Auth = Auth.auth()

    init(window: UIWindow?) {
        self.window = window

        navigationController = UINavigationController()

        startCoordinator = StartCoordinator(navigationController: navigationController,
                                            firestore: firestore,
                                            auth: auth)
    }

    func start() {
        guard let window = window else { return }
        window.rootViewController = navigationController
        startCoordinator?.start()
        window.makeKeyAndVisible()
    }
}
