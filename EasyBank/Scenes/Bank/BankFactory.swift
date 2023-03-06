import UIKit

enum BankFactory {
    static func make() -> UIViewController {
        let service = BankService()
        let coordinator = BankCoordinator()
        let presenter = BankPresenter(coordinator: coordinator)
        let interactor = BankInteractor(service: service, presenter: presenter)
        let viewController = BankViewController(interactor: interactor)

        coordinator.viewController = viewController
        presenter.viewController = viewController

        return viewController
    }
}
