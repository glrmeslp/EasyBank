import UIKit

final class ProfileViewControllerMirror: MirrorObject {
    init(viewController: UIViewController) {
        super.init(refrecting: viewController)
    }

    var nameTextField: UITextField? {
        return extract()
    }
    var emailAddressTextfield: UITextField? {
        return extract()
    }
    var updateNameButton: UIButton? {
        return extract()
    }
    var updateEmailButton: UIButton? {
        return extract()
    }
}
