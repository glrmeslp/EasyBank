import UIKit

class HomeViewController: UIViewController {

    private var viewModel: HomeViewModel? {
        didSet {
            viewModel?.viewDelegate = self
        }
    }

    @IBOutlet private weak var roomNameLabel: UILabel!
    @IBOutlet private weak var userNameLabel: UILabel!
    @IBOutlet private weak var balanceLabel: UILabel!
    
    init(viewModel: HomeViewModel) {
        self.viewModel = viewModel
        super.init(nibName: "HomeViewController", bundle: nil)
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupLabels()
    }
    
    func setupLabels() {
        viewModel?.getAccountInformation { [weak self] account in
            self?.userNameLabel.text = account.userName
            self?.balanceLabel.text = "\(account.balance)"
        }
        viewModel?.getRoomNameAndUserId { [weak self] roomName, _ in
            self?.roomNameLabel.text = roomName
        }
    }
}

extension HomeViewController: HomeViewModelDelegate {
    
    func showErrorMessage(with message: String) {
        presentAlert(with: message)
    }
}
