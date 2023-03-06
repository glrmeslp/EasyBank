import UIKit

final class AccountListView: UIView {
    private lazy var titleHeaderLabel: UILabel = {
        let label = UILabel()
        label.text = "Accounts"
        label.font = .boldSystemFont(ofSize: 16)
        return label
    }()
    
    private lazy var scrollView: UIScrollView = {
        let scroll = UIScrollView()
        scroll.backgroundColor = .clear
        scroll.showsVerticalScrollIndicator = false
        return scroll
    }()
    
    private lazy var stackView: UIStackView = {
        let stack = UIStackView()
        stack.backgroundColor = .clear
        stack.axis = .vertical
        return stack
    }()
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        buildLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configure(data: [Account]) {
        stackView.removeAllSubviews()
        for account in data {
            let view = AccountListViewCell()
            view.configure(data: account)
            stackView.addArrangedSubview(view)
        }
    }
}

extension AccountListView: ViewConfiguration {
    func buildViewHierarchy() {
        scrollView.addSubview(stackView)
        addSubview(titleHeaderLabel)
        addSubview(scrollView)
    }
    
    func setupConstraints() {
        titleHeaderLabel.snp.makeConstraints {
            $0.top.trailing.equalToSuperview()
            $0.leading.equalToSuperview().inset(20)
        }
        
        scrollView.snp.makeConstraints {
            $0.top.equalTo(titleHeaderLabel.snp.bottom)
            $0.leading.trailing.bottom.equalToSuperview()
        }
        
        stackView.snp.makeConstraints {
            $0.top.trailing.leading.width.equalTo(scrollView)
            $0.bottom.equalTo(scrollView)
        }
    }
}
