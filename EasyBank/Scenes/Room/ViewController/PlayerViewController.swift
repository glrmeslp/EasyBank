import UIKit

final class PlayerViewController: UIViewController {

    private var viewModel: PlayerViewModel?

    @IBOutlet private weak var nameTextField: UITextField! {
        didSet { nameTextField.delegate = self }}
    @IBOutlet private weak var continueButton: UIButton!
    
    init(viewModel: PlayerViewModel) {
        super.init(nibName: "PlayerViewController", bundle: nil)
        self.viewModel = viewModel
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }

    @IBAction func didTapContinueButton(_ sender: Any) {
        guard let name = nameTextField.text else { return }
        viewModel?.createAccount(with: name, from: self)
    }
    
    private func enableContinueButton() {
        continueButton.isEnabled = true
        continueButton.layer.backgroundColor = UIColor(named: "BlueColor")!.cgColor
    }

    private func disableContinueButton() {
        continueButton.isEnabled = false
        continueButton.layer.backgroundColor = UIColor.systemGray6.cgColor
    }

    private func setup() {
        let tapGestureReconizer = UITapGestureRecognizer(target: self, action: #selector(didTapView))
        view.addGestureRecognizer(tapGestureReconizer)
        
        continueButton.layer.cornerRadius = 20
        disableContinueButton()

        nameTextField.becomeFirstResponder()
    }

    @objc private func didTapView(_ sender: UITapGestureRecognizer) {
        view.endEditing(true)
    }
}

extension PlayerViewController: UITextFieldDelegate {
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


