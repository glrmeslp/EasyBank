import UIKit

final class HomeViewController: UIViewController {

    private var viewModel: HomeViewModel? {
        didSet {
            viewModel?.viewDelegate = self
        }
    }
    private var transferMenu: [[String]]?

    @IBOutlet private weak var roomNameLabel: UILabel!
    @IBOutlet private weak var userNameLabel: UILabel!
    @IBOutlet private weak var balanceLabel: UILabel!
    @IBOutlet private weak var balanceView: UIView!
    @IBOutlet private weak var extractView: UIView!
    @IBOutlet weak var showBalanceButton: UIButton!
    @IBOutlet weak var menuTransferCollection: UICollectionView! {
        didSet{
            menuTransferCollection.dataSource = self
            menuTransferCollection.delegate = self
        }
    }
    
    init(viewModel: HomeViewModel) {
        self.viewModel = viewModel
        super.init(nibName: "HomeViewController", bundle: nil)
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        fetchData()
        setupRightBarButton()
    }

    @IBAction func didTapShowBalanceButton(_ sender: Any) {
        if balanceLabel.isHidden {
            showBalanceButton.setImage(UIImage(systemName: "eye.fill"), for: .normal)
            balanceLabel.isHidden = false
        } else {
            showBalanceButton.setImage(UIImage(systemName: "eye.slash.fill"), for: .normal)
            balanceLabel.isHidden = true
        }
    }

    private func setup() {
        viewModel?.getAccountInformation { [weak self] account in
            self?.userNameLabel.text = account.userName
            self?.balanceLabel.text = "\(account.balance)"
        }
        viewModel?.getRoomNameAndUserId { [weak self] roomName, _ in
            self?.roomNameLabel.text = roomName
        }
        
        navigationController?.hidesBarsOnSwipe = true
        navigationItem.setHidesBackButton(true, animated: true)
        title = "Easy Banker"
        
        balanceView.layer.cornerRadius = 20
        balanceView.layer.maskedCorners = [.layerMinXMinYCorner,.layerMaxXMinYCorner]
        
        extractView.layer.cornerRadius = 20
        extractView.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMinXMaxYCorner]
        
        menuTransferCollection.register(UINib(nibName: "HomeCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "homeCollectionCell")
    }

    private func setupRightBarButton() {
        let rightBarButtonItem = UIBarButtonItem(
            image: UIImage(named: "icons8-menu-2-30"),
            style: .plain,
            target: self,
            action: nil)
        navigationItem.rightBarButtonItem = rightBarButtonItem
    }

    func fetchData() {
        viewModel?.getTransferMenu { [weak self] menu in
            self?.transferMenu = menu
        }
    }
}

extension HomeViewController: HomeViewModelDelegate {
    
    func showErrorMessage(with message: String) {
        presentAlert(with: message)
    }
}

extension HomeViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        transferMenu?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell =  collectionView.dequeueReusableCell(withReuseIdentifier: "homeCollectionCell", for: indexPath) as? HomeCollectionViewCell,
              let menu = transferMenu?[indexPath.row] else {
            return UICollectionViewCell()
        }
        cell.configure(with: .init(title: menu[0], image: menu[1]), and: cell)
        return cell
    }
}

extension HomeViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let menu = transferMenu?[indexPath.row] else { return }
        switch menu[0] {
        case "Pay QR Code":
            print(menu[0])
        case "Receive":
            print(menu[0])
        case "Transfer":
            print(menu[0])
        default:
            print("")
        }
    }
}

