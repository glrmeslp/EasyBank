import UIKit

class BankerViewController: UIViewController {

    private var viewModel: BankerViewModel? {
        didSet {
            viewModel?.viewDelegate = self
        }
    }

    @IBOutlet private weak var roomNameTextField: UITextField!
    
    init(viewModel: BankerViewModel) {
        self.viewModel = viewModel
        super.init(nibName: "BankerViewController", bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @IBAction func didTapDoneButton(_ sender: Any) {
        guard let roomName = roomNameTextField.text else { return }

        viewModel?.createRoom(with: roomName)
    }
    
}

extension BankerViewController: BankerViewModelDelegate {
    func showErrorMessage(with message: String) {
        presentAlert(with: message)
    }
}
