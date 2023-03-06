import FirebaseFirestore
import UIKit

enum BankFactory {
    static func make(firestore: Firestore) -> UIViewController {
        let service = BankService(firestore: firestore)
        let coordinator = BankCoordinator()
        let presenter = BankPresenter(coordinator: coordinator)
        let interactor = BankInteractor(service: service, presenter: presenter)
        let viewController = BankViewController(interactor: interactor)

        coordinator.viewController = viewController
        presenter.viewController = viewController

        return viewController
    }
}
