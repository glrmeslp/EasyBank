import UIKit

class RecoverPasswordViewController: UIViewController {

    private var viewModel: RecoverPasswordViewModel?

    @IBOutlet private weak var sendButton: UIButton!
    @IBOutlet private weak var emailTextField: UITextField! {
        didSet { emailTextField.delegate = self }
    }

    init(viewModel: RecoverPasswordViewModel) {
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
    @IBAction func didTapSendButton(_ sender: Any) {
        guard let email = emailTextField.text else { return }
        viewModel?.sendPasswordReset(with: email) { [weak self] message in
            self?.presentAlert(with: message)
        }
    }
    
    private func setup() {
        sendButton.layer.cornerRadius = 25
        sendButton.setTitleColor(UIColor.gray, for: .disabled)
        disableSendButton()
        emailTextField.becomeFirstResponder()
        
        let tapGestureReconizer = UITapGestureRecognizer(target: self, action: #selector(didTapView))
        view.addGestureRecognizer(tapGestureReconizer)
    }

    private func disableSendButton() {
        sendButton.isEnabled = false
        sendButton.layer.backgroundColor = UIColor.systemGray6.cgColor
    }

    private func enableSendButton() {
        sendButton.isEnabled = true
        sendButton.layer.backgroundColor = UIColor(named: "BlueColor")!.cgColor
    }

    @objc private func didTapView(_ sender: UITapGestureRecognizer) {
        view.endEditing(true)
    }
}

extension RecoverPasswordViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if sendButton.isEnabled {
            didTapSendButton(self)
        }
        return true
    }

    func textFieldDidEndEditing(_ textField: UITextField) {
        guard let value = textField.text else { return }
        if value.isEmpty {
            disableSendButton()
        }
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
