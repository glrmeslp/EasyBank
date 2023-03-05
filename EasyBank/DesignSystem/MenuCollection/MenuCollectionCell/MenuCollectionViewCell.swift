import UIKit

extension MenuCollectionViewCell.Layout {
    static let iconSize: CGFloat = 30
    static let cornerRadius: CGFloat = 20
    static let borderWidth: CGFloat = 1
    static let borderColor = UIColor(named: "BlueColor")?.cgColor
}

final class MenuCollectionViewCell: UICollectionViewCell {
    fileprivate enum Layout {}
    
    private lazy var iconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = .init(systemName: "qrcode")
        imageView.contentMode = .scaleAspectFit
        imageView.tintColor = UIColor(named: "BlueColor")
        return imageView
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Label"
        label.font = .boldSystemFont(ofSize: 12)
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        buildLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension MenuCollectionViewCell: ViewConfiguration {
    func buildViewHierarchy() {
        addSubview(iconImageView)
        addSubview(titleLabel)
    }
    
    func setupConstraints() {
        iconImageView.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalToSuperview().inset(16)
            $0.size.equalTo(Layout.iconSize)
        }
        
        titleLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(iconImageView.snp.bottom).offset(8)
            $0.bottom.equalToSuperview().inset(16)
        }
    }
    
    func configureViews() {
        self.layer.cornerRadius = Layout.cornerRadius
        self.layer.borderWidth = Layout.borderWidth
        self.layer.borderColor = Layout.borderColor
    }
}
