import UIKit

final class HomeViewController: UIViewController {

    private var viewModel: HomeViewModel?
    private var transferMenu: [[String]]?
    private var value: String?
    private var showBalance = true

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

    @IBAction private func didTapShowBalanceButton(_ sender: Any) {
        if showBalance {
            showBalanceButton.setImage(UIImage(systemName: "eye.fill"), for: .normal)
            balanceLabel.text = value
            showBalance = false
        } else {
            showBalanceButton.setImage(UIImage(systemName: "eye.slash.fill"), for: .normal)
            balanceLabel.text = "•••••"
            showBalance = true
        }
    }
    @IBAction private func didTapExtractButton(_ sender: Any) {
        viewModel?.showExtractViewController()
    }
    
    private func setup() {
        navigationController?.hidesBarsOnSwipe = true
        navigationItem.setHidesBackButton(true, animated: true)
        title = "Easy Bank"
        
        balanceView.layer.cornerRadius = 20
        balanceView.layer.maskedCorners = [.layerMinXMinYCorner,.layerMaxXMinYCorner]
        
        extractView.layer.cornerRadius = 20
        extractView.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMinXMaxYCorner]
        
        menuTransferCollection.register(UINib(nibName: "HomeCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "homeCollectionCell")
        
        let size = menuTransferCollection.bounds.width / 2 - 20
        let collectionViewFlowLayout = UICollectionViewFlowLayout()
        collectionViewFlowLayout.itemSize = CGSize(width: size, height: 100)
        collectionViewFlowLayout.sectionInset = UIEdgeInsets(top: 0, left: 5, bottom: 0, right: 5)
        menuTransferCollection.showsHorizontalScrollIndicator = false
        
        menuTransferCollection.collectionViewLayout = collectionViewFlowLayout

        let backBarButtonItem =  UIBarButtonItem(title: "", style: .plain, target: self, action: nil)
        navigationItem.backBarButtonItem = backBarButtonItem
    }

    private func setupRightBarButton() {
        let rightBarButtonItem = UIBarButtonItem(
            image: UIImage(named: "icons8-menu-2-30"),
            style: .plain,
            target: self,
            action: #selector(showHomeMenu))
        navigationItem.rightBarButtonItem = rightBarButtonItem
    }

    @objc private func showHomeMenu() {
        viewModel?.showHomeMenuViewController()
    }

    private func fetchData() {
        viewModel?.getAccountInformation { [weak self] account in
            self?.userNameLabel.text = account.userName
            self?.value = account.balance.asCurrency()
        }

        viewModel?.getRoomNameAndUserId { [weak self] roomName, _ in
            self?.roomNameLabel.text = roomName
        }

        viewModel?.getTransferMenu { [weak self] menu in
            self?.transferMenu = menu
        }
    }
}

extension HomeViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        transferMenu?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell =  collectionView.dequeueReusableCell(withReuseIdentifier: "homeCollectionCell", for: indexPath) as? HomeCollectionViewCell,
              let title = transferMenu?[indexPath.row].first,
              let image = transferMenu?[indexPath.row].last else {
            return UICollectionViewCell()
        }
        cell.configure(with: .init(title: title, image: image), and: cell)
        return cell
    }
}

extension HomeViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let menu = transferMenu?[indexPath.row].first else { return }
        switch TransferMenu(rawValue: menu) {
        case .pay:
            viewModel?.showPayViewController()
        case .receive:
            viewModel?.showReceiveViewController()
        case .none:
            break
        }
    }
}

