import UIKit

protocol BankCoordinating: AnyObject {
}

final class BankCoordinator {
    weak var viewController: UIViewController?
}
// MARK: - BankCoordinating
extension BankCoordinator: BankCoordinating {
}
