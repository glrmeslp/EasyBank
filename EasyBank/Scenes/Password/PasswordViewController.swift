import UIKit

final class PasswordViewController: UIViewController {

    private var viewModel: PasswordViewModelProtocol?

    @IBOutlet private weak var progressView: UIProgressView!
    @IBOutlet private weak var stepLabel: UILabel!
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var continueButton: UIButton!
    @IBOutlet private weak var forgotPasswordButton: UIButton!
    @IBOutlet private weak var passwordTextField: UITextField! {
        didSet { passwordTextField.delegate = self }
    }

    init(viewModel: PasswordViewModelProtocol){
        self.viewModel = viewModel
        super.init(nibName: "PasswordView", bundle: nil)
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }

    @IBAction private func didTapContinueButton(_ sender: Any) {
        guard let placeholder = passwordTextField.placeholder, let password = passwordTextField.text else { return }
        enableActivityIndicatorView()
        switch PasswordEnum(rawValue: placeholder) {
        case .currentPassword:
            reauthenticate(with: password)
        case .newPassword:
            newPassword(with: password)
        case .confirmPassword:
            validateNewPassword(with: password)
        case .none:
            break
        }
        passwordTextField.text = ""
    }
    
    @IBAction private func didTapForgotPassword(_ sender: Any) {
        viewModel?.showRecoverPasswordViewController()
    }

    private func setup() {
        disableContinueButton()
        addGestureRecognizerForEndEditing()
        progressView.setProgress(1/3, animated: true)
    }

    private func disableContinueButton() {
        continueButton.isEnabled = false
        continueButton.configuration?.baseBackgroundColor = UIColor.systemGray6
        continueButton.configuration?.baseForegroundColor = UIColor.gray
    }

    private func enableContinueButton() {
        continueButton.isEnabled = true
        continueButton.configuration?.baseBackgroundColor = UIColor(named: "BlueColor")
        continueButton.configuration?.baseForegroundColor = UIColor.systemBackground
    }

    private func enableActivityIndicatorView() {
        continueButton.configuration?.title = ""
        continueButton.configuration?.showsActivityIndicator = true
    }
    
    private func disableActivityIndicatorView() {
        continueButton.configuration?.showsActivityIndicator = false
        continueButton.configuration?.title = "Continue"
    }

    private func setupNewPassword() {
        passwordTextField.placeholder = PasswordEnum.newPassword.rawValue
        titleLabel.text = "Enter new password"
        progressView.setProgress(2/3, animated: true)
        stepLabel.text = "Step 2/3"
    }

    private func setupConfirmPassword() {
        passwordTextField.placeholder = PasswordEnum.confirmPassword.rawValue
        titleLabel.text = "Confirm new password"
        progressView.setProgress(1, animated: true)
        stepLabel.text = "Step 3/3"
    }

    private func reauthenticate(with password: String) {
        viewModel?.reauthenticate(with: password) { [weak self] success in
            self?.disableActivityIndicatorView()
            if success {
                self?.setupNewPassword()
                self?.forgotPasswordButton.isHidden = true
            }
        }
    }

    private func newPassword(with newPassword: String) {
        viewModel?.newPassword(newPassword)
        disableActivityIndicatorView()
        setupConfirmPassword()
    }

    private func validateNewPassword(with newPassword: String) {
        viewModel?.validateNewPassword(newPassword) { [weak self] success in
            self?.disableActivityIndicatorView()
            if !success {
                self?.setupNewPassword()
            }
        }
    }
}

extension PasswordViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if continueButton.isEnabled {
            didTapContinueButton(self)
        }
        return true
    }
    
    func textFieldDidChangeSelection(_ textField: UITextField) {
        guard let value = textField.text else { return }
        if value.isEmpty {
            disableContinueButton()
        } else {
            enableContinueButton()
        }
    }
}
