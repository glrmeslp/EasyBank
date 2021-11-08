import UIKit

final class HomeMenuViewControllerMirror: MirrorObject {
    init(viewController: UIViewController) {
        super.init(refrecting: viewController)
    }

    var passwordButton: UIButton? {
        return extract()
    }
    var roomButton: UIButton? {
        return extract()
    }
    var accountButton: UIButton? {
        return extract()
    }
    var signOutButton: UIButton? {
        return extract()
    }

    var bankButton: UIButton? {
        return extract()
    }
}
