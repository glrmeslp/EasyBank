import UIKit

final class BankViewController: UIViewController {

    private var bankMenu: [String]?
    private var viewModel: BankViewModelDelegate?

    private var customView: BankViewDelegate {
        return view as! BankViewDelegate
    }

    init(viewModel: BankViewModelDelegate) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func loadView() {
        view = BankView()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        customView.setupCollection(dataSource: self, delegate: self)
        fetchData()
    }

    private func fetchData() {
        bankMenu = BankMenu().bankMenu
    
        viewModel?.fetchRoomName { [weak self] roomName in
            self?.customView.setup(roomName)
        }
    
        viewModel?.fetchAccounts { [weak self] accounts in
            self?.customView.setup(accounts)
        }
    }
}

extension BankViewController: UICollectionViewDataSource {
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

extension BankViewController: UICollectionViewDelegate {
    
}
