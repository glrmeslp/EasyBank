import UIKit

final class ExtractViewController: UIViewController {

    private var viewModel: ExtractViewModel?
    private var transfers: [Transfer]?

    @IBOutlet private weak var activityIndicatorView: UIActivityIndicatorView!
    @IBOutlet private weak var showBalanceButton: UIButton!
    @IBOutlet private weak var balanceLabel: UILabel!
    @IBOutlet private weak var extractTableView: UITableView! {
        didSet {
            extractTableView.dataSource = self
        }
    }

    init(viewModel: ExtractViewModel) {
        self.viewModel = viewModel
        super.init(nibName: "ExtractView", bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        fetchData()
    }

    @IBAction private func didTapShowBalanceButton(_ sender: Any) {
        guard let value = balanceLabel.text else { return }
        switch Balance(rawValue: value) {
        case .hidden:
            showBalanceButton.setImage(UIImage(systemName: "eye.fill"), for: .normal)
            viewModel?.getBalance { [weak self] value in
                self?.balanceLabel.text = value
            }
        case .none:
            showBalanceButton.setImage(UIImage(systemName: "eye.slash.fill"), for: .normal)
            balanceLabel.text = Balance.hidden.rawValue
        }
    }

    private func setup() {
        title = "Extract"
        activityIndicatorView.startAnimating()
        extractTableView.register(UINib(nibName: "ExtractTableViewCell", bundle: nil), forCellReuseIdentifier: "ExtractTableViewCell")
    }

    private func fetchData() {
        viewModel?.getAllTransfers { [weak self] transfers in
            self?.transfers = transfers
            self?.activityIndicatorView.stopAnimating()
            self?.activityIndicatorView.isHidden = true
            self?.extractTableView.isHidden = false
            self?.extractTableView.reloadData()
        }
    }
}

extension ExtractViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        transfers?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "ExtractTableViewCell", for: indexPath) as? ExtractTableViewCell,
              let transfer = transfers?[indexPath.row],
              let data = viewModel?.configureDataExtract(with: transfer)
        else { return UITableViewCell()}
        cell.configure(with: data)
        return cell
    }
}
