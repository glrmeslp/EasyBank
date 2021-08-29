import UIKit

class StartViewController: UIViewController {

    private var viewModel: StartViewModel?
    
    init(viewModel: StartViewModel) {
        self.viewModel = viewModel
        super.init(nibName: "StartViewController", bundle: nil)
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func viewWillAppear(_ animated: Bool) {
        viewModel?.detectAuthenticationStatus()
        super.viewWillAppear(animated)
    }

    override func viewWillDisappear(_ animated: Bool) {
        viewModel?.undetectAuthenticationStatus()
        super.viewWillDisappear(animated)
    }
    
    @IBAction private func didTapBankerButton(_ sender: Any) {
        viewModel?.showBankerViewController()
    }

    @IBAction private func didTapPlayerButton(_ sender: Any) {
        viewModel?.showPlayerViewController()
    }
    
}
