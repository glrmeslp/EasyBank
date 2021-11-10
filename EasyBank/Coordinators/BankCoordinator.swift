import UIKit
import FirebaseFirestore
import FirebaseAuth

final class BankCoordinator: Coordinator {
    var navigationController: UINavigationController
    private let firestore: Firestore
    private let auth: Auth

    init(navigationController: UINavigationController, firestore: Firestore, auth: Auth) {
        self.navigationController = navigationController
        self.firestore = firestore
        self.auth = auth
    }

    func start() {
        let viewController = BankViewController()
        navigationController.pushViewController(viewController, animated: true)
    }

}
