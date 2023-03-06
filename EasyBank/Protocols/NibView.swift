import UIKit
protocol NibView {
    var nibName: String { get }
    var nibBundle: Bundle { get }
    func instantiate() -> UIView
}

extension NibView where Self: UIView {

    var nibBundle: Bundle {
        return .main
    }

    var nibName: String {
        return type(of: self).description().components(separatedBy: ".").last!
    }
    
    func instantiate() -> UIView {
        let nib = UINib(nibName: nibName, bundle: nibBundle)
        return nib.instantiate(withOwner: self, options: nil).first as? UIView ?? UIView()
    }
}
