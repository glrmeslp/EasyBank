import UIKit

final class ProfileViewController: UIViewController {

    private var viewModel: ProfileViewModel?

    @IBOutlet private weak var nameTextField: UITextField!
    @IBOutlet private weak var emailAddressTextfield: UITextField!
    
    init(viewModel: ProfileViewModel) {
        self.viewModel = viewModel
        super.init(nibName: "ProfileView", bundle: nil)
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    @IBAction func didTapUpdateNameButton(_ sender: Any) {
        guard let name = nameTextField.text else { return }
        viewModel?.updateDispleyName(name) { [weak self] message in
            self?.presentAlert(with: message)
        }
    }

    @IBAction func didTapUpdateEmailButton(_ sender: Any) {
        guard let email = emailAddressTextfield.text else { return }
        viewModel?.updateEmailAddress(email) { [weak self] message in
            self?.presentAlert(with: message)
        }
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
        nameTextField.text = viewModel?.user?.name
        emailAddressTextfield.text = viewModel?.user?.email
    }

}
