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
    
    @IBAction private func didTapBankerButton(_ sender: Any) {
        viewModel?.showBankerViewController()
    }

    @IBAction private func didTapPlayerButton(_ sender: Any) {
        viewModel?.showPlayerViewController()
    }
    
}
