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
    
    override func buildViewHierarchy() {
        stackView.addArrangedSubview(roomHeaderView)
        stackView.addArrangedSubview(menuCollectionView)
        view.addSubview(stackView)
    }
    
    override func setupConstraints() {
        stackView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top).inset(30)
            $0.leading.trailing.equalToSuperview()
        }
    }
    
    override func configureViews() {
        view.backgroundColor = .systemBackground
    }
    //
//    private var viewModel: BankViewModelDelegate?
//    private var customView: BankViewDelegate {
//        return view as! BankViewDelegate
//    }
//
//    init(viewModel: BankViewModelDelegate) {
//        self.viewModel = viewModel
//        super.init(nibName: nil, bundle: nil)
//    }
//
//    required init?(coder: NSCoder) {
//        super.init(coder: coder)
//    }
//
//    override func loadView() {
//        view = BankView()
//    }
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        fetchData()
//    }
//
//    private func fetchData() {
//        viewModel?.fetchBankMenu { [weak self] menu in
//            self?.customView.setup(menu)
//        }
//
//        viewModel?.fetchRoomName { [weak self] roomName in
//            self?.customView.setup(roomName)
//        }
//
//        viewModel?.fetchAccounts { [weak self] accounts in
//            self?.customView.setup(accounts)
//        }
//    }
}

extension BankViewController: BankDisplaying { }
