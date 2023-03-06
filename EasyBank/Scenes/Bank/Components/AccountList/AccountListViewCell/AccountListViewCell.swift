import UIKit

protocol AccountListViewCellDisplaying: AnyObject {
    func display(name: String)
    func display(balance: String)
}

protocol AccountListViewCellProtocol: AnyObject {
    func configure(data: Account)
}

final class AccountListViewCell: UIView {
    private lazy var presenter: AccountListViewCellPresenting = {
        let presenter = AccountListViewCellPresenter()
        presenter.view = self
        return presenter
    }()
    
    private lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: 14)
        return label
    }()
    
    private lazy var balanceLabel: UILabel = {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: 14)
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
        addSubview(balanceLabel)
        addSubview(lineView)
    }
    
    func setupConstraints() {
        nameLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(16)
            $0.leading.trailing.equalToSuperview().inset(20)
        }
        
        balanceLabel.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(20)
            $0.top.equalTo(nameLabel.snp_bottom).offset(8)
        }
        
        lineView.snp.makeConstraints {
            $0.top.equalTo(balanceLabel.snp_bottom).offset(16)
            $0.trailing.bottom.equalToSuperview()
            $0.leading.equalToSuperview().inset(20)
            $0.height.equalTo(1)
        }
        
        superview?.snp.makeConstraints {
            $0.height.equalTo(61)
        }
    }
}

extension AccountListViewCell: AccountListViewCellDisplaying {
    func display(name: String) {
        nameLabel.text = name
    }
    
    func display(balance: String) {
        balanceLabel.text = balance
    }
}

extension AccountListViewCell: AccountListViewCellProtocol {
    func configure(data: Account) {
        presenter.configure(data: data)
    }
}
