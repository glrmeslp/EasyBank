import UIKit

extension Double {

    func asCurrency() -> String? {
        Formatter().currency.locale = Locale.current
        return Formatter().currency.string(from: NSNumber(value: self))
    }
}
