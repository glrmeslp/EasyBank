
import UIKit
@testable import EasyBank

final class PayViewControllerMirror: MirrorObject {
    init(viewController: UIViewController) {
        super.init(refrecting: viewController)
    }

    var confirmButton: UIButton? {
        return extract()
    }

    var nameLabel: UILabel? {
        return extract()
    }

    var valueLabel: UILabel? {
        return extract()
    }

    var balanceLabel: UILabel? {
        return extract()
    }

    var showBalanceButton: UIButton? {
        return extract()
    }

    var valueTextField: CurrencyTextField? {
        return extract()
    }
}
