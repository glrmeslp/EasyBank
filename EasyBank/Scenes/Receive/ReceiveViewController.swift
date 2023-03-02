import UIKit

final class ReceiveViewController: UIViewController {

    private var coordinator: ReceiveViewCoordinatorDelegate?

    @IBOutlet private weak var valueTextField: UITextField!
    @IBOutlet private weak var createQRCodeButton: UIButton!
    
    init(coordinator: ReceiveViewCoordinatorDelegate) {
        self.coordinator = coordinator
        super.init(nibName: "ReceiveView", bundle: nil)
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        setupNavigationController(isHidden: false)
    }

    @IBAction func didTapCreateQRCodeButton(_ sender: Any) {
        if let value = valueTextField.text?.asDouble() {
            coordinator?.pushToQRCodeViewController(value: value)
        }
    }

    private func setup() {
        addGestureRecognizerForEndEditing()
        title = "Receive"
    }
}
