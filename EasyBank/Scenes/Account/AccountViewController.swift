import UIKit

final class AccountViewController: UIViewController {

    private var viewModel: AccountViewModel?

    @IBOutlet private weak var roomNameLabel: UILabel!
    @IBOutlet private weak var userNameLabel: UILabel!
    @IBOutlet private weak var emailLabel: UILabel!
    @IBOutlet private weak var roomStackView: UIStackView!
    @IBOutlet private weak var nameStackView: UIStackView!
    @IBOutlet private weak var emailStackView: UIStackView!

    init(viewModel: AccountViewModel) {
        self.viewModel = viewModel
        super.init(nibName: "AccountView", bundle: nil)
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        fetchData()
        setupNavigationController(isHidden: false)
    }

    override func viewWillAppear(_ animated: Bool) {
        viewModel?.getUser()
        fetchData()
        super.viewWillAppear(animated)
    }

    @IBAction private func didTapDeleteAccountButton(_ sender: Any) {
        presentActionSheet(title: "Do you want to delete your account?", buttonTitle: "Delete account",
                           message: "This operation cannot be undone. If you enter this room again, a new account will be created.",
                           style: .destructive) { _ in self.viewModel?.deleteAccount { error in self.presentAlert(with: error)}
        }
    }
    
    @IBAction private func didTapCloseYourAccountButton(_ sender: Any) {
        viewModel?.deleteEasyBankAccount()
    }

    @IBAction private func didTapLeaveRoomButton(_ sender: Any) {
        presentActionSheet(title: "Do you want to leave the room?", buttonTitle: "Get Out") { _ in self.viewModel?.leaveRoom()}
    }

    @IBAction private func didTapProfileButton(_ sender: Any) {
        viewModel?.manageProfileInformation()
    }

    private func setup() {
        title = "Account"
        navigationController?.hidesBarsOnSwipe = false
        roomStackView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didTapRoomStackView)))
        nameStackView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didTapNameStackView)))
        emailStackView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didTapEmailStackView)))
    }

    private func fetchData() {
        roomNameLabel.text = viewModel?.roomName
        userNameLabel.text = viewModel?.user?.name
        emailLabel.text = viewModel?.user?.email
    }
    
    @objc private func didTapRoomStackView(_ sender: UITapGestureRecognizer) {
        didTapLeaveRoomButton(self)
    }

    @objc private func didTapNameStackView(_ sender: UITapGestureRecognizer) {
        presentActionSheet(title: "Do you want to update your name?", buttonTitle: "Update name") { _ in self.didTapProfileButton(self) }
    }

    @objc private func didTapEmailStackView(_ sender: UITapGestureRecognizer) {
        presentActionSheet(title: "Do you want to change your email address?", buttonTitle: "Update email address") { _ in self.didTapProfileButton(self) }
    }
    
}
