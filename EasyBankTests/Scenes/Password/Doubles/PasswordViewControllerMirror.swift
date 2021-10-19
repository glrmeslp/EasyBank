
import UIKit

final class PasswordViewControllerMirror: MirrorObject {
    init(viewController: UIViewController) {
        super.init(refrecting: viewController)
    }

    var progressView: UIProgressView? { return extract() }
    var stepLabel: UILabel? { return extract() }
    var titleLabel: UILabel? { return extract() }
    var continueButton: UIButton? { return extract() }
    var forgotPasswordButton: UIButton? { return extract() }
}
