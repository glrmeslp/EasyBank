import UIKit

extension MenuCollectionView.Layout {
    static let itemSize = CGSize(width: 150, height: 100)
    static let sectionInset = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
}

final class MenuCollectionView: UIView {
    fileprivate enum Layout { }

    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = Layout.sectionInset
        layout.scrollDirection = .horizontal
//        layout.minimumLineSpacing = Space.base01.rawValue
        layout.itemSize = Layout.itemSize
//
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(MenuCollectionViewCell.self, forCellWithReuseIdentifier: String(describing: MenuCollectionViewCell.self))
        collectionView.isScrollEnabled = true
        collectionView.showsHorizontalScrollIndicator = false
//        collectionView.delegate = self
        collectionView.backgroundColor = .clear
        return collectionView
    }()

    private lazy var dataSource: CollectionViewDataSource<Int, Int> = {
        let dataSource = CollectionViewDataSource<Int, Int>(view: collectionView)
        dataSource.itemProvider = { [weak self] _, indexPath, data -> UICollectionViewCell? in
            let cell = self?.collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: MenuCollectionViewCell.self),
                                                                for: indexPath) as? MenuCollectionViewCell
            return cell
        }
        return dataSource
    }()

    override init(frame: CGRect) {
        super.init(frame: .zero)
        buildLayout()
        collectionView.dataSource = dataSource
        dataSource.add(items: [1,2,3], to: 0)
        collectionView.reloadData()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
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
