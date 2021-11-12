import UIKit

protocol BankViewDelegate {
    func setup(_ roomName: String)
    func setup(_ accounts: [Account])
    func setup(_ bankmenu: [String])
}

final class BankView: UIView, NibView {

    private var accounts: [Account]?
    private var bankMenu: [String]?
    private var view: UIView?
    private var collectionViewFlowLayout: UICollectionViewFlowLayout = {
        let collectionViewFlowLayout = UICollectionViewFlowLayout()
        collectionViewFlowLayout.sectionInset = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
        return collectionViewFlowLayout
    }()

    @IBOutlet private weak var roomNameLabel: UILabel!
    @IBOutlet private weak var menuCollectionView: UICollectionView!
    @IBOutlet private weak var accountsTableView: UITableView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        nibSetup()
        configureViews()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        nibSetup()
        configureViews()
    }

    private func nibSetup() {
        view = instantiate()
        view?.frame = bounds
        guard let view = view else {
            return
        }
        addSubview(view)
    }

    private func configureViews() {
        updateCollectionViewFlowLayoutItemSize()
        menuCollectionView.register(UINib(nibName: "MenuCollectionViewCell", bundle: nil),
                                    forCellWithReuseIdentifier: "menuCollectionCell")
        menuCollectionView.collectionViewLayout = collectionViewFlowLayout
        menuCollectionView.showsHorizontalScrollIndicator = false
        menuCollectionView.dataSource = self
    
        accountsTableView.register(UINib(nibName: "AccountTableViewCell", bundle: nil),
                                   forCellReuseIdentifier: "accountTableViewCell")
        
        accountsTableView.register(UINib(nibName: "AccountTableHeaderView", bundle: nil),
                                   forHeaderFooterViewReuseIdentifier: "accountTableHeaderView")
        accountsTableView.dataSource = self

    }

    private func updateCollectionViewFlowLayoutItemSize() {
        collectionViewFlowLayout.scrollDirection = .horizontal
        collectionViewFlowLayout.itemSize = CGSize(width: 150, height: 100)
    }
}

extension BankView: BankViewDelegate {
    func setup(_ bankmenu: [String]) {
        self.bankMenu = bankmenu
    }

    func setup(_ accounts: [Account]) {
        self.accounts = accounts
        accountsTableView.reloadData()
    }
    
    func setup(_ roomName: String) {
        roomNameLabel.text = roomName
    }
}

extension BankView: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        accounts?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "accountTableViewCell") as? AccountTableViewCell,
              let account = accounts?[indexPath.row],
              let balance = account.balance.asCurrency() else { return UITableViewCell()}
        cell.configure(with: .init(name: account.userName, balance: balance))
        return cell
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        1
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        30
    }

    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        "Accounts"
    }
}

extension BankView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        bankMenu?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell =  collectionView.dequeueReusableCell(withReuseIdentifier: "menuCollectionCell", for: indexPath) as? MenuCollectionViewCell,
              let menu = bankMenu?[indexPath.row] else {
            return UICollectionViewCell()
        }
        cell.configure(with: .init(title: menu, image: menu))
        return cell
    }    
}

