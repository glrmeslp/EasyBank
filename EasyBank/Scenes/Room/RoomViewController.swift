import UIKit

class RoomViewController: UIViewController {
    
    private var viewModel: RoomViewModel?

    @IBOutlet weak var roomNameTextField: UITextField! {
        didSet { roomNameTextField.delegate = self }}
    @IBOutlet weak var continueButton: UIButton!
    
    init(viewModel: RoomViewModel) {
        super.init(nibName: "RoomViewController", bundle: nil)
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
        guard let roomName = roomNameTextField.text else { return }
        viewModel?.enterToRoom(roomName, from: self)
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
        
        continueButton.layer.cornerRadius = 25
        continueButton.setTitleColor(UIColor.gray, for: .disabled)
        disableContinueButton()
        
        roomNameTextField.becomeFirstResponder()
    }

    @objc private func didTapView(_ sender: UITapGestureRecognizer) {
        view.endEditing(true)
    }
}

extension RoomViewController: UITextFieldDelegate {
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