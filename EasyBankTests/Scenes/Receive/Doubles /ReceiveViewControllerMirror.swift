import UIKit

final class ReceiveViewControllerMirror: MirrorObject {
    init(viewController: UIViewController) {
        super.init(refrecting: viewController)
    }

    var valueTextField: UITextField? {
        return extract()
    }

    var createQRCodeButton: UIButton? {
        return extract()
    }
}
