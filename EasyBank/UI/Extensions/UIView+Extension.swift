import UIKit

extension UIView {
    func addSubviews(_ views: UIView...) {
        views.forEach { addSubview($0) }
    }

    func removeAllSubviews() {
        for view in subviews {
            view.removeFromSuperview()
        }
    }
}
