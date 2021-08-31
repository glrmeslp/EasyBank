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
        viewModel?.enterToRoom(roomName) { [weak self] error in
            guard let error = error else { return }
            self?.presentAlert(with: error)
        }
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

        roomNameTextField.becomeFirstResponder()
    
        navigationController?.navigationBar.isHidden = false

        let backBarButtonItem =  UIBarButtonItem(title: "", style: .plain, target: self, action: nil)
        navigationItem.backBarButtonItem = backBarButtonItem
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
