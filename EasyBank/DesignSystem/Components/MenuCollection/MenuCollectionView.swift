import UIKit

extension MenuCollectionView.Layout {
    static let itemSize = CGSize(width: 150, height: 100)
    static let sectionInset = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
}

protocol MenuCollectionViewDisplaying: AnyObject {
    func display(items: [MenuCollectionItem])
}

final class MenuCollectionView: UIView {
    fileprivate enum Layout { }
    
    private lazy var interactor: MenuCollectionViewInteractor = {
        let interactor = MenuCollectionViewInteractor()
        interactor.view = self
        return interactor
    }()

    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = Layout.sectionInset
        layout.scrollDirection = .horizontal
        layout.itemSize = Layout.itemSize
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(MenuCollectionViewCell.self, forCellWithReuseIdentifier: String(describing: MenuCollectionViewCell.self))
        collectionView.isScrollEnabled = true
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.delegate = self
        collectionView.backgroundColor = .clear
        return collectionView
    }()

    private lazy var dataSource: CollectionViewDataSource<Int, MenuCollectionItem> = {
        let dataSource = CollectionViewDataSource<Int, MenuCollectionItem>(view: collectionView)
        dataSource.itemProvider = { [weak self] _, indexPath, data -> UICollectionViewCell? in
            let cell = self?.collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: MenuCollectionViewCell.self),
                                                                for: indexPath) as? MenuCollectionViewCell
            cell?.configure(item: data)
            return cell
        }
        return dataSource
    }()

    override init(frame: CGRect) {
        super.init(frame: .zero)
        buildLayout()
        collectionView.dataSource = dataSource
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configure(items: [MenuCollectionItem]) {
        interactor.configure(items: items)
    }
}

extension MenuCollectionView: ViewConfiguration {
    func buildViewHierarchy() {
        addSubview(collectionView)
    }
    
    func setupConstraints() {
        collectionView.snp.makeConstraints {
            $0.edges.equalToSuperview()
            $0.height.equalTo(100)
        }
    }
}

extension MenuCollectionView: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        interactor.didSelectItem(index: indexPath.row)
    }
}

extension MenuCollectionView: MenuCollectionViewDisplaying {
    func display(items: [MenuCollectionItem]) {
        dataSource.remove(section: 0)
        dataSource.add(items: items, to: 0)
        collectionView.reloadData()
    }
}
