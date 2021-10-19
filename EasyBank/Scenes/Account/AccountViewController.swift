import UIKit

final class AccountViewController: UIViewController {

    private var viewModel: AccountViewModelProtocol?

    @IBOutlet private weak var roomNameLabel: UILabel!
    @IBOutlet private weak var userNameLabel: UILabel!
    @IBOutlet private weak var emailLabel: UILabel!
    @IBOutlet private weak var roomStackView: UIStackView!
    @IBOutlet private weak var nameStackView: UIStackView!
    @IBOutlet private weak var emailStackView: UIStackView!

    init(viewModel: AccountViewModelProtocol) {
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
        fetchData()
        super.viewWillAppear(animated)
    }

    @IBAction private func didTapDeleteAccountButton(_ sender: Any) {
        viewModel?.presentDeleteAccountActionSheet()
    }
    
    @IBAction private func didTapCloseYourAccountButton(_ sender: Any) {
        viewModel?.deleteEasyBankAccount()
    }

    @IBAction private func didTapLeaveRoomButton(_ sender: Any) {
        viewModel?.presentLeaveRoomActionSheet()
    }

    @IBAction private func didTapProfileButton(_ sender: Any) {
        viewModel?.manageProfileInformation()
    }

    private func setup() {
        title = "Account"
        roomStackView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didTapRoomStackView)))
        nameStackView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didTapNameStackView)))
        emailStackView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didTapEmailStackView)))
    }

    private func fetchData() {
        viewModel?.fecthData { [weak self] roomName, user in
            self?.roomNameLabel.text = roomName
            self?.userNameLabel.text = user?.name
            self?.emailLabel.text = user?.email
        }
    }
    
    @objc private func didTapRoomStackView(_ sender: UITapGestureRecognizer) {
        didTapLeaveRoomButton(self)
    }

    @objc private func didTapNameStackView(_ sender: UITapGestureRecognizer) {
        viewModel?.presentUpdateNameActionSheet { _ in
            self.didTapProfileButton(self)
        }
    }

    @objc private func didTapEmailStackView(_ sender: UITapGestureRecognizer) {
        viewModel?.presentUpdateNameActionSheet { _ in
            self.didTapProfileButton(self)
        }
    }
    
}
