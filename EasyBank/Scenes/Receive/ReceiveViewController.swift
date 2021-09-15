import UIKit

class ReceiveViewController: UIViewController {

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
        let tapGestureReconizer = UITapGestureRecognizer(target: self, action: #selector(didTapView))
        view.addGestureRecognizer(tapGestureReconizer)
        createQRCodeButton.layer.cornerRadius = 20
        title = "Receive"
    }
    

    @objc private func didTapView(_ sender: UITapGestureRecognizer) {
        view.endEditing(true)
    }
}
