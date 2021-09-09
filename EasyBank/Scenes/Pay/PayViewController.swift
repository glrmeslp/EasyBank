
import UIKit

final class PayViewController: UIViewController {

    private var viewModel: PayViewModel?
    private var showBalance = true
    private var balance: String?

    @IBOutlet private weak var confirmButton: UIButton!
    @IBOutlet private weak var nameLabel: UILabel!
    @IBOutlet private weak var valueLabel: UILabel!
    @IBOutlet private weak var balanceLabel: UILabel!
    @IBOutlet private weak var showBalanceButton: UIButton!
    @IBOutlet private weak var valueTextField: CurrencyTextField! {
        didSet { valueTextField.delegate = self}
    }
    
    init(viewModel: PayViewModel) {
        self.viewModel = viewModel
        super.init(nibName: "PayView", bundle: nil)
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        fetchData()
    }

    @IBAction func didTapConfirmButton(_ sender: Any) {
    }

    @IBAction func didTapShowBalanceButton(_ sender: Any) {
        if showBalance {
            showBalanceButton.setImage(UIImage(systemName: "eye.fill"), for: .normal)
            balanceLabel.text = balance
            showBalance = false
        } else {
            showBalanceButton.setImage(UIImage(systemName: "eye.slash.fill"), for: .normal)
            balanceLabel.text = "•••••"
            showBalance = true
        }
    }

    private func setup() {
        confirmButton.layer.cornerRadius = 20
    }
    
    private func fetchData() {
        viewModel?.getInformation { [weak self] name, value in
            self?.nameLabel.text = name
            if value > 0 {
                self?.showValueName(value: value)
            } else {
                self?.showValueTextField()
            }
        }
        
        viewModel?.getPayerAccount { [weak self] account in
            self?.balance = account.balance.asCurrency()
        }
    }
    
    private func showValueName(value: Double) {
        valueLabel.isHidden = false
        valueLabel.text = value.asCurrency()
    }
    
    private func showValueTextField() {
        valueTextField.isHidden = false
        valueTextField.becomeFirstResponder()
        
        let tapGestureReconizer = UITapGestureRecognizer(target: self, action: #selector(didTapView))
        view.addGestureRecognizer(tapGestureReconizer)
        
        disableConfirmButton()
    }

    private func enableConfirmButton() {
        confirmButton.isEnabled = true
        confirmButton.layer.backgroundColor = UIColor(named: "BlueColor")!.cgColor
    }

    private func disableConfirmButton() {
        confirmButton.isEnabled = false
        confirmButton.layer.backgroundColor = UIColor.systemGray6.cgColor
    }

    @objc private func didTapView(_ sender: UITapGestureRecognizer) {
        view.endEditing(true)
    }
}

extension PayViewController: UITextFieldDelegate {
    func textFieldDidEndEditing(_ textField: UITextField) {
        guard let value = textField.text else { return }
        if let value = value.asDouble(), value > 0 {
            enableConfirmButton()
        }
    }
    
    func textFieldDidChangeSelection(_ textField: UITextField) {
        guard let value = textField.text else { return }
        if let value = value.asDouble(), value > 0 {
            enableConfirmButton()
        } else {
            disableConfirmButton()
        }
    }
}
