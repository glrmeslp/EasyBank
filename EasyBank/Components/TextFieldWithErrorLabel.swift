import UIKit

class TextFieldWithErrorLabel: UIView {
    
    @IBOutlet weak var customView: UIView!

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }
    
    private func setup() {
        Bundle.main.loadNibNamed("TextFieldWithErrorLabelView", owner: self, options: nil)
        customView.frame = bounds
        customView.autoresizingMask = [.flexibleWidth,.flexibleHeight]
        addSubview(customView)
    }
}
