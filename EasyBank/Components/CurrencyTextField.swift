import UIKit

final class CurrencyTextField: UITextField {

    private var enteredNumbers = ""

    private var didBackspace = false

    private var locale: Locale = .current

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }

    private func setup() {
        textColor = UIColor(named: "BlueColor")
        text = enteredNumbers.asCurrency()
        addTarget(self, action: #selector(editingChanged), for: .editingChanged)
    }

    override func deleteBackward() {
        enteredNumbers = String(enteredNumbers.dropLast())
        text = enteredNumbers.asCurrency()
        didBackspace = true
        super.deleteBackward()
    }

    @objc private func editingChanged() {
        defer {
            didBackspace = false
            text = enteredNumbers.asCurrency()
        }

        guard didBackspace == false else { return }

        if let lastEnteredCharacter = text?.last, lastEnteredCharacter.isNumber {
            enteredNumbers.append(lastEnteredCharacter)
        }
    }
}

extension Formatter {
    static let currency: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        return formatter
    }()
}


