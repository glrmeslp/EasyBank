import UIKit

final class StartViewController: UIViewController {

    private var viewModel: StartViewModel?

    @IBOutlet private weak var createButton: UIButton!
    @IBOutlet private weak var joinButton: UIButton!

    init(viewModel: StartViewModel) {
        self.viewModel = viewModel
        super.init(nibName: "StartViewController", bundle: nil)
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }

    override func viewWillAppear(_ animated: Bool) {
        viewModel?.detectAuthenticationStatus()
        setupNavigationController(isHidden: true)
        super.viewWillAppear(animated)
    }

    override func viewWillDisappear(_ animated: Bool) {
        viewModel?.undetectAuthenticationStatus()
        super.viewWillDisappear(animated)
    }

    @IBAction private func didTapCreateButton(_ sender: Any) {
        viewModel?.showNewRoomViewController()
    }

    @IBAction private func didTapJoinButton(_ sender: Any) {
        viewModel?.showRoomViewController()
    }

    func setup() {
        createButton.layer.cornerRadius = 20

        joinButton.layer.cornerRadius = 20
        joinButton.layer.borderWidth = 1
        joinButton.layer.borderColor = UIColor(named: "BlueColor")!.cgColor

        setupNavigationController(isHidden: true)
        navigationController?.hidesBarsOnSwipe = false
    }

}

