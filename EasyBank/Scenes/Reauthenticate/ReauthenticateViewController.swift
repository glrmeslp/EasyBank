import UIKit

final class ReauthenticateViewController: UIViewController {

    private var viewModel: ReauthenticateViewModelProtocol?
    
    @IBOutlet private weak var continueButton: UIButton!
    @IBOutlet private weak var passwordTextfield: UITextField! {
        didSet { passwordTextfield.delegate = self }
    }

    init(viewModel: ReauthenticateViewModelProtocol) {
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

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        disableActivityIndicatorView()
    }

    @IBAction func didTapContinueButton(_ sender: Any) {
        guard let password = passwordTextfield.text else { return }
        enableActivityIndicatorView()
        viewModel?.reauthenticate(with: password)
    }

    private func setup() {
        disableContinueButton()
        addGestureRecognizerForEndEditing()
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
        continueButton.isEnabled = false
    }
    
    private func disableActivityIndicatorView() {
        continueButton.configuration?.showsActivityIndicator = false
        continueButton.configuration?.title = "Continue"
        continueButton.isEnabled = true
    }
}

extension ReauthenticateViewController: UITextFieldDelegate {
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
