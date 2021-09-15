import UIKit

final class CompleteTransactionViewController: UIViewController {

    private var viewModel: CompleteTransactionViewModel?

    @IBOutlet private weak var homeButton: UIButton!
    @IBOutlet private weak var transactionIDLabel: UILabel!
    @IBOutlet weak var payDayLabel: UILabel!
    @IBOutlet weak var hourLabel: UILabel!
    @IBOutlet weak var receiverNameLabel: UILabel!
    @IBOutlet weak var payerNameLabel: UILabel!

    init(viewModel: CompleteTransactionViewModel) {
        self.viewModel = viewModel
        super.init(nibName: "CompleteTransactionView", bundle: nil)
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        fetchData()
    }

    private func setup() {
        homeButton.layer.cornerRadius = 20
    }

    private func fetchData() {
        viewModel?.getTransaction { [weak self] transfer, id in
            var split = "\(transfer.payDate.dateValue())".components(separatedBy: " ")
            split.removeLast()
            self?.transactionIDLabel.text = id
            self?.payDayLabel.text = split.first
            self?.hourLabel.text = split.last
            self?.receiverNameLabel.text = transfer.receiverName
            self?.payerNameLabel.text = transfer.payerName
        }
    }

    @IBAction func didTapHomeButton(_ sender: Any) {
        viewModel?.showHomeViewController(from: self)
    }
    
}
