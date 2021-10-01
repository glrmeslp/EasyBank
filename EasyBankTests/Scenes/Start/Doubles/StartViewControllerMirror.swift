import UIKit

final class StartViewControllerMirror: MirrorObject {
    init(viewController: UIViewController) {
        super.init(refrecting: viewController)
    }

    var createButton: UIButton? {
        return extract()
    }

    var joinButton: UIButton? {
        return extract()
    }
}
