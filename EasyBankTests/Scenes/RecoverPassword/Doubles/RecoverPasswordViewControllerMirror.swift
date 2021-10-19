import UIKit

final class RecoverPasswordViewControllerMirror: MirrorObject {
    init(viewController: UIViewController) {
        super.init(refrecting: viewController)
    }

    var sendButton: UIButton? {
        return extract()
    }

    var emailTextField: UITextField? {
        return extract()
    }
}
