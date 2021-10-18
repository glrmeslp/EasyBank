import UIKit
import FirebaseAuth

protocol PasswordViewModelCoordinatorDelegate: AnyObject {
    func popToHomeViewController()
    func pushToRecoverPasswordViewController()
    func presentAlert(message: String, and handler: ((UIAlertAction) -> Void)?)
}

final class PasswordCoordinator: Coordinator {
    var navigationController: UINavigationController
    let auth: Auth

    private var passwordViewModel: PasswordViewModel {
        let authService = AuthenticationService(auth: auth)
        let viewModel = PasswordViewModel(authService: authService, coordinator: self)
        return viewModel
    }

    init(navigationController: UINavigationController, auth: Auth){
        self.navigationController = navigationController
        self.auth = auth
    }

    func start() {
        let passwordViewController = PasswordViewController(viewModel: passwordViewModel)
        navigationController.pushViewController(passwordViewController, animated: true)
    }
}

extension PasswordCoordinator: PasswordViewModelCoordinatorDelegate {
    func presentAlert(message: String, and handler: ((UIAlertAction) -> Void)?) {
        navigationController.presentAlert(with: message, and: handler)
    }

    func pushToRecoverPasswordViewController() {
        let authService = AuthenticationService(auth: auth)
        let viewModel = RecoverPasswordViewModel(authService: authService )
        let recoverPassword = RecoverPasswordViewController(viewModel: viewModel)
        if let sheet = recoverPassword.sheetPresentationController {
            sheet.detents = [.medium()]
            sheet.prefersGrabberVisible = true
        }
        navigationController.present(recoverPassword, animated: true)
    }

    func popToHomeViewController() {
        navigationController.popViewController(animated: true)
    }
}
