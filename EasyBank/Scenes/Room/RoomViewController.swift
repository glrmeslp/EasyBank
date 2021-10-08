import UIKit

final class RoomViewController: UIViewController {
    
    private var viewModel: RoomViewModelProtocol?

    @IBOutlet private weak var roomNameTextField: UITextField! {
        didSet { roomNameTextField.delegate = self }}
    @IBOutlet private weak var continueButton: UIButton!
    
    init(viewModel: RoomViewModelProtocol) {
        self.viewModel = viewModel
        super.init(nibName: "RoomViewController", bundle: nil)
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }

    @IBAction private func didTapContinueButton(_ sender: Any) {
        guard let roomName = roomNameTextField.text else { return }
        viewModel?.enter(roomName)
    }

    private func enableContinueButton() {
        continueButton.isEnabled = true
        continueButton.configuration?.baseBackgroundColor = UIColor(named: "BlueColor")
        continueButton.configuration?.baseForegroundColor = UIColor.systemBackground
    }

    private func disableContinueButton() {
        continueButton.isEnabled = false
        continueButton.configuration?.baseBackgroundColor = UIColor.systemGray6
        continueButton.configuration?.baseForegroundColor = UIColor.gray
    }

    private func setup() {
        addGestureRecognizerForEndEditing()
        disableContinueButton()
        roomNameTextField.becomeFirstResponder()
    }
}

extension RoomViewController: UITextFieldDelegate {
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
