import UIKit
import FirebaseAuth
import FirebaseFirestore

protocol AccountViewModelCoordinatorDelegate: AnyObject {
    func pushToStartViewController()
    func presentReauthenticateViewController(for motive: Reautheticate)
}

protocol ReauthenticateViewModelCoordinatorDelegate: AnyObject {
    func pushToProfileViewController()
    func presentDeleteUserActionSheet(with handler: @escaping ((UIAlertAction) -> Void))
    func pushToStartViewController()
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
    func presentReauthenticateViewController(for motive: Reautheticate) {
        let reauthenticateViewModel = ReauthenticateViewModel(coordinator: self, authService: AuthenticationService(auth: auth), motive: motive)
        let reauthenticateViewController = ReauthenticateViewController(viewModel: reauthenticateViewModel)
        if let sheet = reauthenticateViewController.sheetPresentationController {
            sheet.detents = [.medium()]
            sheet.prefersGrabberVisible = true
        }
        navigationController.present(reauthenticateViewController, animated: true)
    }

    func pushToStartViewController() {
        let startCoordinator = StartCoordinator(navigationController: navigationController, firestore: firestore, auth: auth)
        startCoordinator.start()
    }
}

extension AccountCoordinator: ReauthenticateViewModelCoordinatorDelegate {
    func presentDeleteUserActionSheet(with handler: @escaping ((UIAlertAction) -> Void)) {
        navigationController.presentActionSheet(title: "Do you want to delete your EasyBank account?",
                                                buttonTitle: "Delete",
                                                message: "This operation cannot be undone.",
                                                style: .destructive,
                                                handler: handler)
    }

    func pushToProfileViewController() {
        let profileViewModel = ProfileViewModel(roomName: roomName,
                                                authService: AuthenticationService(auth: auth),
                                                roomService: DatabaseService(firestore: firestore))
        let profileViewController = ProfileViewController(viewModel: profileViewModel)
        navigationController.pushViewController(profileViewController, animated: true)
    }
}
