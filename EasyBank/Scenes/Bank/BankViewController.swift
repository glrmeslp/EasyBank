import UIKit

final class BankViewController: UIViewController {

    var bankMenu: [String]?

    private var customView: BankViewDelegate {
        return view as! BankViewDelegate
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
        customView.setup("Room01")
        customView.setup([Account(balance: 10.0, userName: "Guilherme"),Account(balance: 15.0, userName: "Keven")])
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
