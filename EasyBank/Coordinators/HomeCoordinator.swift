import UIKit
import FirebaseFirestore
import FirebaseAuth

protocol HomeViewModelCoordinatorDelegate: AnyObject {
    func pushToReceiveViewController()
    func pushToScannerViewController()
    func presentHomeMenuViewController()
    func pushToExtractViewController(with userName: String)
}

protocol HomeMenuViewModelCoordinatorDelegate: AnyObject {
    func pushToStartViewController()
}

final class HomeCoordinator: Coordinator {
    
    var navigationController: UINavigationController
    var childCoordinators = [Coordinator]()

    private let roomName: String
    private let firestore: Firestore
    private let auth: Auth

    private var homeViewModel: HomeViewModel {
        let databaseService = DatabaseService(firestore: firestore)
        let authService = AuthenticationService(auth: auth)
        let viewModel = HomeViewModel(with: roomName, databaseService: databaseService, authService: authService, coordinator: self)
        return viewModel
    }

    init(navigationController: UINavigationController, roomName: String, firestore: Firestore, auth: Auth) {
        self.navigationController = navigationController
        self.roomName = roomName
        self.firestore = firestore
        self.auth = auth
    }

    func start() {
        let homeViewController = HomeViewController(viewModel: homeViewModel)
        navigationController.setViewControllers([homeViewController], animated: true)
    }

    func childDidFinish(_ child: Coordinator) {
        for (index, coordinator) in childCoordinators.enumerated() {
            if coordinator === child {
                childCoordinators.remove(at: index)
                break
            }
        }
    }
}

extension HomeCoordinator: HomeViewModelCoordinatorDelegate {
    func pushToExtractViewController(with userName: String) {
        let databaseService = DatabaseService(firestore: firestore)
        let authService = AuthenticationService(auth: auth)
        let extractViewModel = ExtractViewModel(databaseService: databaseService, authService: authService, roomName: roomName)
        let extractViewController = ExtractViewController(viewModel: extractViewModel)
        navigationController.pushViewController(extractViewController, animated: true)
    }
    
    func presentHomeMenuViewController() {
        let authService = AuthenticationService(auth: auth)
        let viewModel = HomeMenuViewModel(authService: authService, coordinator: self)
        let homeMenuViewController = HomeMenuViewController(viewModel: viewModel)
        if #available(iOS 15.0, *) {
            if let sheet = homeMenuViewController.sheetPresentationController {
                sheet.detents = [.medium()]
                sheet.prefersGrabberVisible = true
            }
        }
        navigationController.present(homeMenuViewController, animated: true)
    }
    
    func pushToScannerViewController() {
        let payCoordinator = PayCoordinator(navigationController: navigationController, firestore: firestore, roomName: roomName, auth: auth)
        payCoordinator.parentCoordinator = self
        childCoordinators.append(payCoordinator)
        payCoordinator.start()
    }
    
    func pushToReceiveViewController() {
        let receiveCoordinator = ReceiveCoordinator(navigationController: navigationController, roomName: roomName, auth: auth, firestore: firestore)
        receiveCoordinator.start()
    }
}

extension HomeCoordinator: HomeMenuViewModelCoordinatorDelegate {
    func pushToStartViewController() {
        let startCoordinator = StartCoordinator(navigationController: navigationController, firestore: firestore, auth: auth)
        startCoordinator.start()
    }
}



