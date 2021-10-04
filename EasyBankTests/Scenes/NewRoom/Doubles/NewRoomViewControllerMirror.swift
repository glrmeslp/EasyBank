import UIKit

final class NewRoomViewControllerMirror: MirrorObject {

    init(viewController: UIViewController) {
        super.init(refrecting: viewController)
    }

    var createButton: UIButton? {
        return extract()
    }

    var roomNameTextField: UITextField? {
        return extract()
    }
}
