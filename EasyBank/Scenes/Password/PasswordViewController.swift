import UIKit

final class PasswordViewController: UIViewController {

    private var viewModel: PasswordViewModel?

    @IBOutlet private weak var progressView: UIProgressView!
    @IBOutlet private weak var stepLabel: UILabel!
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var continueButton: UIButton!
    @IBOutlet private weak var activityIndicatorView: UIActivityIndicatorView!
    @IBOutlet private weak var forgotPasswordButton: UIButton!
    @IBOutlet private weak var passwordTextField: UITextField! {
        didSet { passwordTextField.delegate = self }
    }

    init(viewModel: PasswordViewModel){
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
            viewModel?.reauthenticate(with: password) { [weak self] error in
                self?.disableActivityIndicatorView()
                guard let error = error else {
                    self?.setupNewPassword()
                    return
                }
                self?.presentAlert(with: error)
            }
        case .newPassword:
            viewModel?.newPassword(password)
            disableActivityIndicatorView()
            setupConfirmPassword()
        case .confirmPassword:
            viewModel?.validateNewPassword(password) {  [weak self] message, success in
                self?.disableActivityIndicatorView()
                if success {
                    self?.presentAlert(with: message) { _ in self?.viewModel?.didFinish()}
                } else {
                    self?.presentAlert(with: message) { _ in self?.setupNewPassword()}
                }
            }
        case .none:
            break
        }
        passwordTextField.text = ""
    }
    
    @IBAction private func didTapForgotPassword(_ sender: Any) {
        viewModel?.showForgotPasswordViewController()
    }

    private func setup() {
        continueButton.layer.cornerRadius = 25
        continueButton.setTitleColor(UIColor.gray, for: .disabled)
        disableContinueButton()
        progressView.progress = 1/3
        activityIndicatorView.isHidden = true
    }

    private func disableContinueButton() {
        continueButton.isEnabled = false
        continueButton.layer.backgroundColor = UIColor.systemGray6.cgColor
    }

    private func enableContinueButton() {
        continueButton.isEnabled = true
        continueButton.layer.backgroundColor = UIColor(named: "BlueColor")!.cgColor
    }

    private func enableActivityIndicatorView() {
        continueButton.setTitle("", for: .normal)
        activityIndicatorView.isHidden = false
        activityIndicatorView.startAnimating()
    }
    
    private func disableActivityIndicatorView() {
        activityIndicatorView.stopAnimating()
        activityIndicatorView.isHidden = true
        continueButton.setTitle("Continue", for: .normal)
    }

    private func setupNewPassword() {
        forgotPasswordButton.isHidden = true
        passwordTextField.placeholder = PasswordEnum.newPassword.rawValue
        titleLabel.text = "Enter new password"
        progressView.progress = 2/3
        stepLabel.text = "Step 2/3"
    }

    private func setupConfirmPassword() {
        passwordTextField.placeholder = PasswordEnum.confirmPassword.rawValue
        titleLabel.text = "Confirm new password"
        progressView.progress = 1
        stepLabel.text = "Step 3/3"
    }

}

extension PasswordViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if continueButton.isEnabled {
            didTapContinueButton(self)
        }
        return true
    }

    func textFieldDidEndEditing(_ textField: UITextField) {
        guard let value = textField.text else { return }
        if value.isEmpty {
            disableContinueButton()
        }
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
