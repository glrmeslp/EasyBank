import UIKit
final class HomeViewControllerMirror: MirrorObject {
    init(viewController: UIViewController) {
        super.init(refrecting: viewController)
    }

    var menuTransferCollection: UICollectionView? {
        return extract()
    }

    var balanceLabel: UILabel? {
        return extract()
    }

    var showBalanceButton: UIButton? {
        return extract()
    }

    var userNameLabel: UILabel? {
        return extract()
    }

    var roomNameLabel: UILabel? {
        return extract()
    }

    var seeExtractButton: UIButton? {
        return extract()
    }
}
