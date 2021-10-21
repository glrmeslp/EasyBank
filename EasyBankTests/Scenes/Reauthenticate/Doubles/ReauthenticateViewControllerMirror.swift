import UIKit

final class ReauthenticateViewControllerMirror: MirrorObject {
    init(viewController: UIViewController) {
        super.init(refrecting: viewController)
    }

    var continueButton: UIButton? {
        return extract()
    }

    var passwordTextfield: UITextField? {
        return extract()
    }
}
