import UIKit

final class NewRoomViewController: UIViewController {

    private var viewModel: NewRoomViewModelProtocol?

    @IBOutlet private weak var roomNameTextField: UITextField! {
        didSet { roomNameTextField.delegate = self}}
    @IBOutlet private weak var createButton: UIButton!
    
    init(viewModel: NewRoomViewModelProtocol) {
        self.viewModel = viewModel
        super.init(nibName: "NewRoomView", bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }

    @IBAction private func didTapCreateButton(_ sender: Any) {
        guard let roomName = roomNameTextField.text else { return }
        viewModel?.validateRoom(with: roomName)
    }

    private func enableCreateButton() {
        createButton.isEnabled = true
        createButton.configuration?.baseBackgroundColor = UIColor(named: "BlueColor")
        createButton.configuration?.baseForegroundColor = UIColor.systemBackground
    }

    private func disableCreateButton() {
        createButton.isEnabled = false
        createButton.configuration?.baseBackgroundColor = UIColor.systemGray6
        createButton.configuration?.baseForegroundColor = UIColor.gray
    }

    private func setup() {
        disableCreateButton()
        roomNameTextField.becomeFirstResponder()
        addGestureRecognizerForEndEditing()
    }
}

extension NewRoomViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if createButton.isEnabled {
            didTapCreateButton(self)
        }
        return true
    }

    func textFieldDidChangeSelection(_ textField: UITextField) {
        guard let value = textField.text else { return }
        if value.isEmpty {
            disableCreateButton()
        } else {
            enableCreateButton()
        }
    }
}
