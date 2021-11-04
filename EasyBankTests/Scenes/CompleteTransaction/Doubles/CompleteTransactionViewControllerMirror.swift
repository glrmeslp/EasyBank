import UIKit

final class CompleteTransactionViewControllerMirror: MirrorObject {
    init(viewController: UIViewController) {
        super.init(refrecting: viewController)
    }

    var homeButton: UIButton? {
        return extract()
    }
    var transactionIDLabel: UILabel? {
        return extract()
    }
    var payDayLabel: UILabel? {
        return extract()
    }
    var hourLabel: UILabel? {
        return extract()
    }
    var receiverNameLabel: UILabel? {
        return extract()
    }
    var payerNameLabel: UILabel? {
        return extract()
    }
}
