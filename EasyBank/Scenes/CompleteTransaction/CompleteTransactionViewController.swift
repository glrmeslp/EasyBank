import UIKit

final class CompleteTransactionViewController: UIViewController {

    private var viewModel: CompleteTransactionViewModelDelegate?

    @IBOutlet private weak var homeButton: UIButton!
    @IBOutlet private weak var transactionIDLabel: UILabel!
    @IBOutlet private weak var payDayLabel: UILabel!
    @IBOutlet private weak var hourLabel: UILabel!
    @IBOutlet private weak var receiverNameLabel: UILabel!
    @IBOutlet private weak var payerNameLabel: UILabel!

    init(viewModel: CompleteTransactionViewModelDelegate) {
        self.viewModel = viewModel
        super.init(nibName: "CompleteTransactionView", bundle: nil)
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        fetchData()
    }

    @IBAction private func didTapHomeButton(_ sender: Any) {
        viewModel?.didFinish()
    }

    private func fetchData() {
        viewModel?.fetchTransaction { [weak self] transfer in
            var split = "\(transfer.payDate.dateValue())".components(separatedBy: " ")
            split.removeLast()
            self?.transactionIDLabel.text = transfer.id
            self?.payDayLabel.text = split.first
            self?.hourLabel.text = split.last
            self?.receiverNameLabel.text = transfer.receiverName
            self?.payerNameLabel.text = transfer.payerName
        }
    }
}
