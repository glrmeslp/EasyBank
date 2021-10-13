import UIKit

class ReauthenticateViewController: UIViewController {

    private var viewModel: ReauthenticateViewModel?
    
    @IBOutlet private weak var continueButton: UIButton!
    @IBOutlet private weak var passwordTextfield: UITextField! {
        didSet { passwordTextfield.delegate = self }
    }

    init(viewModel: ReauthenticateViewModel) {
        self.viewModel = viewModel
        super.init(nibName: "ReauthenticateView", bundle: nil)
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }

    @IBAction func didTapContinueButton(_ sender: Any) {
        guard let password = passwordTextfield.text else { return }
        viewModel?.reauthenticate(with: password) { [weak self] error, motive in
            guard let error = error else {
                self?.reautheticateFor(motive)
                return
            }
            self? .presentAlert(with: error)
        }
    }

    private func setup() {
        continueButton.setTitleColor(UIColor.gray, for: .disabled)
        disableContinueButton()
    }

    private func disableContinueButton() {
        continueButton.isEnabled = false
        continueButton.configuration?.baseBackgroundColor = UIColor.systemGray6
    }

    private func enableContinueButton() {
        continueButton.isEnabled = true
        continueButton.configuration?.baseBackgroundColor = UIColor(named: "BlueColor")
    }

    private func reautheticateFor(_ motive: Reautheticate) {
        switch motive {
        case .deleteUser:
            dismiss(animated: true) { self.viewModel?.showDeleteUserActionSheet() }
        case .updateUserInformation:
            dismiss(animated: true) { self.viewModel?.showProfileViewController() }
        }
    }
}

extension ReauthenticateViewController: UITextFieldDelegate {
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
