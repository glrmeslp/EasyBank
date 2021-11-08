import UIKit

final class StartViewController: UIViewController {

    private var viewModel: StartViewModelProtocol?

    @IBOutlet private weak var createButton: UIButton!
    @IBOutlet private weak var joinButton: UIButton!

    init(viewModel: StartViewModelProtocol) {
        self.viewModel = viewModel
        super.init(nibName: "StartView", bundle: nil)
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    override func viewWillAppear(_ animated: Bool) {
        viewModel?.detectAuthenticationStatus()
        setupNavigationController(isHidden: true)
        super.viewWillAppear(animated)
    }

    override func viewWillDisappear(_ animated: Bool) {
        viewModel?.undetectAuthenticationStatus()
        setupNavigationController(isHidden: false)
        super.viewWillDisappear(animated)
    }

    @IBAction private func didTapCreateButton(_ sender: Any) {
        viewModel?.showNewRoomViewController()
    }

    @IBAction private func didTapJoinButton(_ sender: Any) {
        viewModel?.showRoomViewController()
    }
}

