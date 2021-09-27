import UIKit

extension String {

    func asCurrency() -> String? {
        Formatter().currency.locale = Locale.current
        return Formatter().currency.string(from: NSNumber(value: (Double(self) ?? 0) / 100))
    }

    func asDouble() -> Double? {
        Formatter().currency.locale = Locale.current
        return Formatter().currency.number(from: self)?.doubleValue
    }
}
