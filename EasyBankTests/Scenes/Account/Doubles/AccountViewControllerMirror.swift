
import UIKit

final class AccountViewControllerMirror: MirrorObject {
    init(viewController: UIViewController) {
        super.init(refrecting: viewController)
    }

    var roomNameLabel: UILabel? {
        return extract()
    }
    var userNameLabel: UILabel? {
        return extract()
    }
    var emailLabel: UILabel? {
        return extract()
    }
    var roomStackView: UIStackView? {
        return extract()
    }
    var nameStackView: UIStackView? {
        return extract()
    }
    var emailStackView: UIStackView? {
        return extract()
    }
    var leaveRoomButton: UIButton? {
        return extract()
    }
    var deleteAccount: UIButton? {
        return extract()
    }
    var yourProfileButton: UIButton? {
        return extract()
    }
    var closeYourAccountButton: UIButton? {
        return extract()
    }
}
