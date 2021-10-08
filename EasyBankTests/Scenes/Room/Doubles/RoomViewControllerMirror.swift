import UIKit

final class RoomViewControllerMirror: MirrorObject {
    init(viewController: UIViewController) {
        super.init(refrecting: viewController)
    }

    var continueButton: UIButton? {
        return extract()
    }

}
