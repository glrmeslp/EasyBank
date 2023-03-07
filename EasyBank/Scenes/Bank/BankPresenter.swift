import UIKit

protocol BankPresenting: AnyObject {
    func display(accounts: [Account])
    func display(roomName: String)
    func display(items: [MenuCollectionItem])
    func presentDeleteRoomActionSheet(with handler: @escaping ((UIAlertAction) -> Void))
    func openBankPayScreen()
    func openBankChargeScreen()
}

final class BankPresenter {
    private let coordinator: BankCoordinating
    weak var viewController: BankDisplaying?

    init(coordinator: BankCoordinating) {
        self.coordinator = coordinator
    }
}

// MARK: - BankPresenting
extension BankPresenter: BankPresenting {
    func presentDeleteRoomActionSheet(with handler: @escaping ((UIAlertAction) -> Void)) {
        coordinator.presentDeleteRoomActionSheet(with: handler)
    }
    
    func openBankPayScreen() {
        coordinator.openBankPayScreen()
    }
    
    func openBankChargeScreen() {
        coordinator.openBankChargeScreen()
    }
    
    func display(items: [MenuCollectionItem]) {
        viewController?.display(items: items)
    }
    
    func display(roomName: String) {
        viewController?.display(roomName: roomName)
    }
    
    func display(accounts: [Account]) {
        viewController?.display(accounts: accounts)
    }
}
