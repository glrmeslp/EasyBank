import UIKit

final class ProfileViewController: UIViewController {

    private var viewModel: ProfileViewModelProtocol?

    @IBOutlet private weak var nameTextField: UITextField!
    @IBOutlet private weak var emailAddressTextfield: UITextField!
    @IBOutlet private weak var updateNameButton: UIButton!
    @IBOutlet private weak var updateEmailButton: UIButton!

    init(viewModel: ProfileViewModelProtocol) {
        self.viewModel = viewModel
        super.init(nibName: "ProfileView", bundle: nil)
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    @IBAction func didTapUpdateNameButton(_ sender: Any) {
        guard let name = nameTextField.text else { return }
        viewModel?.updateDispleyName(name)
    }

    @IBAction func didTapUpdateEmailButton(_ sender: Any) {
        guard let email = emailAddressTextfield.text else { return }
        viewModel?.updateEmailAddress(email)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        fetchData()
    }

    private func setup() {
        title = "Profile"
    }

    private func fetchData() {
        viewModel?.fetchData { [weak self] user in
            self?.nameTextField.text = user.name
            self?.emailAddressTextfield.text = user.email
        }
        
    }
}
