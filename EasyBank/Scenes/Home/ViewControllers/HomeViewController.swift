import UIKit

final class HomeViewController: UIViewController {

    private var viewModel: HomeViewModel?
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

    override func viewWillAppear(_ animated: Bool) {
        navigationController?.hidesBarsOnSwipe = true
        viewModel?.getUser()
        fetchData()
        super.viewWillAppear(animated)
    }

    @IBAction private func didTapShowBalanceButton(_ sender: Any) {
        guard let value = balanceLabel.text else { return }
        switch ShowBalance(rawValue: value) {
        case .disabled:
            showBalanceButton.setImage(UIImage(systemName: "eye.fill"), for: .normal)
            viewModel?.getBalance { [weak self] value in
                self?.balanceLabel.text = value
            }
        case .none:
            showBalanceButton.setImage(UIImage(systemName: "eye.slash.fill"), for: .normal)
            balanceLabel.text = ShowBalance.disabled.rawValue
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

        let size = view.bounds.width / 2 - 30
        let collectionViewFlowLayout = UICollectionViewFlowLayout()
        collectionViewFlowLayout.itemSize = CGSize(width: size, height: 100)
        collectionViewFlowLayout.sectionInset = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
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
        roomNameLabel.text = viewModel?.roomName
        userNameLabel.text = viewModel?.userName

        viewModel?.getTransferMenu { [weak self] menu in
            self?.transferMenu = menu
        }

        showBalanceButton.setImage(UIImage(systemName: "eye.slash.fill"), for: .normal)
        balanceLabel.text = ShowBalance.disabled.rawValue
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

