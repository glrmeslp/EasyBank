import UIKit
import FirebaseAuth
import FirebaseFirestore

protocol AccountViewModelCoordinatorDelegate: AnyObject {
    func presentLeaveRoomActionSheet()
    func presentDeleteAccountActionSheet(handler: ((UIAlertAction) -> Void)?)
    func presentReauthenticateViewController(for motive: Reautheticate)
    func presentUpdateNameActionSheet(handler: ((UIAlertAction) -> Void)?)
    func presentUpdateEmailActionSheet(handler: ((UIAlertAction) -> Void)?)
    func pushToStartViewController()
    func presentAlert(message: String)
}

protocol ReauthenticateViewModelCoordinatorDelegate: AnyObject {
    func pushToProfileViewController()
    func presentDeleteUserActionSheet(with handler: @escaping ((UIAlertAction) -> Void))
    func presentAlert(message: String)
    func pushToStartViewController()
    func didFinish()
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
                                                roomService: DatabaseService(firestore: firestore),
                                                coordinator: self)
        let accountViewController = AccountViewController(viewModel: accountViewModel)
        navigationController.pushViewController(accountViewController, animated: true)
    }

    func pushToStartViewController() {
        let startCoordinator = StartCoordinator(navigationController: navigationController, firestore: firestore, auth: auth)
        startCoordinator.start()
    }
}

extension AccountCoordinator: AccountViewModelCoordinatorDelegate {
    func presentUpdateNameActionSheet(handler: ((UIAlertAction) -> Void)?) {
        navigationController.presentActionSheet(title: "Do you want to update your name?",
                                                buttonTitle: "Update name",
                                                handler: handler)
    }
    
    func presentUpdateEmailActionSheet(handler: ((UIAlertAction) -> Void)?) {
        navigationController.presentActionSheet(title: "Do you want to change your email address?",
                                                buttonTitle: "Update email address",
                                                handler: handler)
    }
    
    func presentAlert(message: String) {
        navigationController.presentAlert(with: message)
    }
    
    func presentDeleteAccountActionSheet(handler: ((UIAlertAction) -> Void)?) {
        navigationController.presentActionSheet(title: "Do you want to delete your account?",
                                                buttonTitle: "Delete account",
                                                message: "This operation cannot be undone. If you enter this room again, a new account will be created.",
                                                style: .destructive,
                                                handler: handler)
    }
    
    func presentLeaveRoomActionSheet() {
        navigationController.presentActionSheet(title: "Do you want to leave the room?",
                                                buttonTitle: "Get Out",
                                                style: .destructive) { _ in self.pushToStartViewController()}
    }
    
    func presentReauthenticateViewController(for motive: Reautheticate) {
        let reauthenticateViewModel = ReauthenticateViewModel(coordinator: self, authService: AuthenticationService(auth: auth), motive: motive)
        let reauthenticateViewController = ReauthenticateViewController(viewModel: reauthenticateViewModel)
        if let sheet = reauthenticateViewController.sheetPresentationController {
            sheet.detents = [.medium()]
            sheet.prefersGrabberVisible = true
        }
        navigationController.present(reauthenticateViewController, animated: true)
    }
}

extension AccountCoordinator: ReauthenticateViewModelCoordinatorDelegate {
    func didFinish() {
        navigationController.dismiss(animated: true)
    }
    
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
