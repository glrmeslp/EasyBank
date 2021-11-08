import UIKit

final class QRCodeViewControllerMirror: MirrorObject {
    init(viewController: UIViewController) {
        super.init(refrecting: viewController)
    }

    var valueLabel: UILabel? {
        return extract()
    }

    var qrCodeImageView: UIImageView? {
        return extract()
    }

    var homeButton: UIButton? {
        return extract()
    }
}
