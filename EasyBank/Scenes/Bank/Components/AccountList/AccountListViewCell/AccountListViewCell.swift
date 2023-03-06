import UIKit

final class AccountListViewCell: UIView {
    private lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.text = "Name"
        label.font = .boldSystemFont(ofSize: 14)
        return label
    }()
    
    private lazy var valueLabel: UILabel = {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: 14)
        label.text = "$ 0.00"
        label.textColor = UIColor(named: "BlueColor")
        return label
    }()
    
    private lazy var lineView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(named: "BlueColor")?.withAlphaComponent(0.20)
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        buildLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension AccountListViewCell: ViewConfiguration {
    func buildViewHierarchy() {
        addSubview(nameLabel)
        addSubview(valueLabel)
        addSubview(lineView)
    }
    
    func setupConstraints() {
        nameLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(16)
            $0.leading.trailing.equalToSuperview().inset(20)
        }
        
        valueLabel.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(20)
            $0.top.equalTo(nameLabel.snp_bottom).offset(8)
        }
        
        lineView.snp.makeConstraints {
            $0.top.equalTo(valueLabel.snp_bottom).offset(16)
            $0.trailing.bottom.equalToSuperview()
            $0.leading.equalToSuperview().inset(20)
            $0.height.equalTo(1)
        }
        
        superview?.snp.makeConstraints {
            $0.height.equalTo(61)
        }
    }
}
