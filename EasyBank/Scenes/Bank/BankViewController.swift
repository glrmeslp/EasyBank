import UIKit

protocol BankDisplaying: AnyObject {
    
}

final class BankViewController: UIViewController {
    
    private var interactor: BankInteractor
    
    init(interactor: BankInteractor) {
        self.interactor = interactor
        super.init(nibName: nil, bundle: nil)
        self.view = UIView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
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
