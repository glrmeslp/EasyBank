import UIKit

final class RecoverPasswordViewController: UIViewController {

    private var viewModel: RecoverPasswordViewModelProtocol?

    @IBOutlet private weak var sendButton: UIButton!
    @IBOutlet private weak var emailTextField: UITextField! {
        didSet { emailTextField.delegate = self }
    }

    init(viewModel: RecoverPasswordViewModelProtocol) {
        self.viewModel = viewModel
        super.init(nibName: "RecoverPasswordView", bundle: nil)
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }

    @IBAction private func didTapSendButton(_ sender: Any) {
        guard let email = emailTextField.text else { return }
        viewModel?.sendPasswordReset(with: email)
    }
    
    private func setup() {
        disableSendButton()
        addGestureRecognizerForEndEditing()
    }

    private func disableSendButton() {
        sendButton.isEnabled = false
        sendButton.configuration?.baseForegroundColor = .gray
        sendButton.configuration?.baseBackgroundColor = .systemGray6
    }

    private func enableSendButton() {
        sendButton.isEnabled = true
        sendButton.configuration?.baseForegroundColor = .systemBackground
        sendButton.configuration?.baseBackgroundColor = UIColor(named: "BlueColor")
    }
}

extension RecoverPasswordViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if sendButton.isEnabled {
            didTapSendButton(self)
        }
        return true
    }

    func textFieldDidChangeSelection(_ textField: UITextField) {
        guard let value = textField.text else { return }
        if value.isEmpty {
            disableSendButton()
        } else {
            enableSendButton()
        }
    }
}
