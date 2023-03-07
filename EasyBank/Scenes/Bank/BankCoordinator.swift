import UIKit

protocol BankCoordinating: AnyObject {
    func openBankPayScreen()
    func openBankChargeScreen()
    func presentDeleteRoomActionSheet(with handler: @escaping ((UIAlertAction) -> Void))
}

final class BankCoordinator {
    weak var viewController: UIViewController?
}
// MARK: - BankCoordinating
extension BankCoordinator: BankCoordinating {
    func presentDeleteRoomActionSheet(with handler: @escaping ((UIAlertAction) -> Void)) {
        guard let navigationController = viewController?.navigationController else { return }
        navigationController.presentActionSheet(title: "Do you want to delete this Room?",
                                                buttonTitle: "Delete",
                                                message: "This operation cannot be undone.",
                                                style: .destructive,
                                                handler: handler)
    }
    
    func openBankPayScreen() {
        print("Did tap Pay")
    }
    
    func openBankChargeScreen() {
        print("Did tap Charge")
    }
}
