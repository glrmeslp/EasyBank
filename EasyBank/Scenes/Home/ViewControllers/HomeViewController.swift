import UIKit

final class HomeViewController: UIViewController {

    private var viewModel: HomeViewModelProtocol?
    private var transferMenu: [[String]]?
    private var collectionViewFlowLayout: UICollectionViewFlowLayout = {
        let collectionViewFlowLayout = UICollectionViewFlowLayout()
        collectionViewFlowLayout.sectionInset = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
        return collectionViewFlowLayout
    }()

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
    
    init(viewModel: HomeViewModelProtocol) {
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
        setupNavigationController(isHidden: false)
    }

    override func viewWillAppear(_ animated: Bool) {
        fetchUserData()
        hideBalanceValue()
        super.viewWillAppear(animated)
    }

    @IBAction private func didTapShowBalanceButton(_ sender: Any) {
        guard let value = balanceLabel.text else { return }
        switch Balance(rawValue: value) {
        case .hidden:
            showBalanceValue()
        case .none:
            hideBalanceValue()
        }
    }

    @IBAction private func didTapExtractButton(_ sender: Any) {
        viewModel?.showExtractViewController()
    }
    
    private func setup() {
        title = "Easy Bank"
        updateCollectionViewFlowLayoutItemSize()

        balanceView.layer.cornerRadius = 20
        balanceView.layer.maskedCorners = [.layerMinXMinYCorner,.layerMaxXMinYCorner]

        extractView.layer.cornerRadius = 20
        extractView.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMinXMaxYCorner]

        menuTransferCollection.register(UINib(nibName: "HomeCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "homeCollectionCell")
        menuTransferCollection.collectionViewLayout = collectionViewFlowLayout
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
        viewModel?.fetchInformation { [weak self] menu, roomName in
            self?.transferMenu = menu
            self?.roomNameLabel.text = roomName
        }
    }

    private func fetchUserData() {
        viewModel?.fetchUserName { [weak self] name in
            self?.userNameLabel.text = name
        }
    }

    private func hideBalanceValue() {
        showBalanceButton.setImage(UIImage(systemName: "eye.slash.fill"), for: .normal)
        balanceLabel.text = Balance.hidden.rawValue
    }

    private func showBalanceValue() {
        showBalanceButton.setImage(UIImage(systemName: "eye.fill"), for: .normal)
        viewModel?.fetchBalance { [weak self] value in
            self?.balanceLabel.text = value
        }
    }

    private func updateCollectionViewFlowLayoutItemSize() {
        let size = view.bounds.width / 2 - 30
        collectionViewFlowLayout.itemSize = CGSize(width: size, height: 100)
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

