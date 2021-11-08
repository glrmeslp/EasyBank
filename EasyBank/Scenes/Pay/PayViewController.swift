
import UIKit

final class PayViewController: UIViewController {

    private var viewModel: PayViewModelDelegate?

    @IBOutlet private weak var confirmButton: UIButton!
    @IBOutlet private weak var nameLabel: UILabel!
    @IBOutlet private weak var valueLabel: UILabel!
    @IBOutlet private weak var balanceLabel: UILabel!
    @IBOutlet private weak var showBalanceButton: UIButton!
    @IBOutlet private weak var valueTextField: CurrencyTextField! {
        didSet { valueTextField.delegate = self}
    }
    
    init(viewModel: PayViewModelDelegate) {
        self.viewModel = viewModel
        super.init(nibName: "PayView", bundle: nil)
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        fetchData()
    }

    override func viewWillDisappear(_ animated: Bool) {
        disableActivityIndicatorView()
        super.viewWillDisappear(animated)
    }

    @IBAction func didTapConfirmButton(_ sender: Any) {
        viewModel?.presentConfirmAlert { _ in self.transfer()}
    }

    @IBAction func didTapShowBalanceButton(_ sender: Any) {
        guard let value = balanceLabel.text else { return }
        switch Balance(rawValue: value) {
        case .hidden:
            showBalanceValue()
        case .none:
            hideBalanceValue()
        }
    }
    
    private func fetchData() {
        viewModel?.fetchData { [weak self] name, value in
            self?.nameLabel.text = name
            if value > 0 {
                self?.showValueLabel(value: value)
            } else {
                self?.showValueTextField()
            }
        }
    }
    
    private func showValueLabel(value: Double) {
        valueLabel.isHidden = false
        valueLabel.text = value.asCurrency()
    }
    
    private func showValueTextField() {
        valueTextField.isHidden = false
        valueTextField.becomeFirstResponder()
        addGestureRecognizerForEndEditing()
        disableConfirmButton()
    }

    private func enableConfirmButton() {
        confirmButton.isEnabled = true
    }

    private func disableConfirmButton() {
        confirmButton.isEnabled = false
    }
    
    private func transfer() {
        enableActivityIndicatorView()
        var value: String
        if valueLabel.isHidden {
            guard let text = valueTextField.text else { return }
            value = text
        } else {
            guard let text = valueLabel.text else { return }
            value = text
        }
        viewModel?.transfer(value: value) { _ in self.disableActivityIndicatorView()}
    }

    private func enableActivityIndicatorView() {
        confirmButton.configuration?.title = ""
        confirmButton.configuration?.showsActivityIndicator = true
    }
    
    private func disableActivityIndicatorView() {
        confirmButton.configuration?.title = "Confirm"
        confirmButton.configuration?.showsActivityIndicator = false
    }

    private func hideBalanceValue() {
        showBalanceButton.setImage(UIImage(systemName: "eye.slash.fill"), for: .normal)
        balanceLabel.text = Balance.hidden.rawValue
    }

    private func showBalanceValue() {
        showBalanceButton.setImage(UIImage(systemName: "eye.fill"), for: .normal)
        viewModel?.fetchBalance { [weak self] value in
            self?.balanceLabel.text = value
        }
    }
}

extension PayViewController: UITextFieldDelegate {

    func textFieldDidChangeSelection(_ textField: UITextField) {
        guard let value = textField.text else { return }
        if let value = value.asDouble(), value > 0 {
            enableConfirmButton()
        } else {
            disableConfirmButton()
        }
    }
}
