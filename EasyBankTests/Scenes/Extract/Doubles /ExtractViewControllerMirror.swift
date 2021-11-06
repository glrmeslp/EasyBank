import UIKit

final class ExtractViewControllerMirror: MirrorObject {
    init(viewController: UIViewController) {
        super.init(refrecting: viewController)
    }

    var activityIndicatorView: UIActivityIndicatorView? { return extract()}
    var showBalanceButton: UIButton? { return extract()}
    var balanceLabel: UILabel? { return extract()}
    var extractTableView: UITableView? { return extract()}
}
