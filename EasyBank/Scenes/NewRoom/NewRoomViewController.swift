import UIKit

class NewRoomViewController: UIViewController {

    private var viewModel: NewRoomViewModel? 

    @IBOutlet private weak var roomNameTextField: UITextField! {
        didSet { roomNameTextField.delegate = self}}
    @IBOutlet private weak var createButton: UIButton!
    
    init(viewModel: NewRoomViewModel) {
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

    @IBAction func didTapCreateButton(_ sender: Any) {
        guard let roomName = roomNameTextField.text else { return }
        validateRoom(roomName)
    }
    
    private func validateRoom(_ roomName: String) {
        viewModel?.validateRoom(with: roomName) { [weak self] message in
            if let message = message {
                self?.presentAlert(with: message)
            } else {
                self?.createRoom(roomName)
            }
        }
    }

    private func createRoom(_ roomName: String) {
        viewModel?.createRoom(with: roomName) { [weak self] error in
            guard let error = error else { return }
            self?.presentAlert(with: error)
        }
    }

    private func enableContinueButton() {
        createButton.isEnabled = true
        createButton.layer.backgroundColor = UIColor(named: "BlueColor")!.cgColor
    }

    private func disableContinueButton() {
        createButton.isEnabled = false
        createButton.layer.backgroundColor = UIColor.systemGray6.cgColor
    }

    private func setup() {
        let tapGestureReconizer = UITapGestureRecognizer(target: self, action: #selector(didTapView))
        view.addGestureRecognizer(tapGestureReconizer)
        
        createButton.layer.cornerRadius = 20
        disableContinueButton()

        roomNameTextField.becomeFirstResponder()
        
        setupNavigationController(isHidden: false)
    }

    @objc private func didTapView(_ sender: UITapGestureRecognizer) {
        view.endEditing(true)
    }
    
}

extension NewRoomViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if createButton.isEnabled {
            didTapCreateButton(self)
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
