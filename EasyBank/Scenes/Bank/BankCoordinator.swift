import UIKit

enum BankAction {
    // template
}

protocol BankCoordinating: AnyObject {
    func perform(action: BankAction)
}

final class BankCoordinator {
    weak var viewController: UIViewController?
}
// MARK: - BankCoordinating
extension BankCoordinator: BankCoordinating {
    func perform(action: BankAction) {
        // template
    }
}
