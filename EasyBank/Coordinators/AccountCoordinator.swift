import UIKit
import FirebaseAuth
import FirebaseFirestore

protocol AccountViewModelCoordinatorDelegate: AnyObject {
    func pushToStartViewController()
    func pushToDeleteUserViewController()
    func pushToProfileViewController()
}

final class AccountCoordinator: Coordinator {
    var navigationController: UINavigationController

    private let roomName: String
    private let auth: Auth
    private let firestore: Firestore

    init(navigationController: UINavigationController, roomName: String, auth: Auth, firestore: Firestore) {
        self.navigationController = navigationController
        self.roomName = roomName
        self.auth = auth
        self.firestore = firestore
    }

    func start() {
        let accountViewModel = AccountViewModel(roomName: roomName,
                                                authService: AuthenticationService(auth: auth),
                                                databaseService: DatabaseService(firestore: firestore),
                                                coordinator: self)
        let accountViewController = AccountViewController(viewModel: accountViewModel)
        navigationController.pushViewController(accountViewController, animated: true)
    }
}

extension AccountCoordinator: AccountViewModelCoordinatorDelegate {
    func pushToProfileViewController() {
        print("Profile View Controller")
    }
    
    func pushToDeleteUserViewController() {
        print("Delete View Controller")
    }

    func pushToStartViewController() {
        let startCoordinator = StartCoordinator(navigationController: navigationController, firestore: firestore, auth: auth)
        startCoordinator.start()
    }
}
