import UIKit

protocol BankDisplaying: AnyObject {
    
}

final class BankViewController: ViewController<BankInteractor, UIView> {
    
    private lazy var stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.backgroundColor = .clear
        stackView.axis = .vertical
        stackView.spacing = 30
        return stackView
    }()

    private lazy var roomHeaderView = RoomHeaderView()
    private lazy var menuCollectionView = MenuCollectionView()
    private lazy var accountListView = AccountListView()
    
    override func buildViewHierarchy() {
        stackView.addArrangedSubview(roomHeaderView)
        stackView.addArrangedSubview(menuCollectionView)
        stackView.addArrangedSubview(accountListView)
        view.addSubview(stackView)
    }
    
    override func setupConstraints() {
        stackView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top).inset(30)
            $0.leading.trailing.bottom.equalToSuperview()
        }
    }
    
    override func configureViews() {
        view.backgroundColor = .systemBackground
    }
}

extension BankViewController: BankDisplaying { }
