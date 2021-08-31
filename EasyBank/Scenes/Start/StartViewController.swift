import UIKit

class StartViewController: UIViewController {

    private var viewModel: StartViewModel?
    @IBOutlet private weak var bankerButton: UIButton!
    @IBOutlet private weak var playerButton: UIButton!
    
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
        navigationController?.navigationBar.isHidden = true
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
    
    func setup() {
        bankerButton.layer.cornerRadius = 20

        playerButton.layer.cornerRadius = 20
        playerButton.layer.borderWidth = 1
        playerButton.layer.borderColor = UIColor(named: "BlueColor")!.cgColor
        
        navigationController?.navigationBar.isTranslucent = false
        navigationController?.navigationBar.tintColor = UIColor(named: "BlueColor")
        navigationController?.navigationBar.isHidden = true
        
        let backBarButtonItem =  UIBarButtonItem(title: "", style: .plain, target: self, action: nil)
        navigationItem.backBarButtonItem = backBarButtonItem
    }
    
}
