import UIKit

extension String {
    var isQRCodeValid: Bool {
        do {
            let qrCodePattern = #"com.glrmeslp.EasyBank00X00+\S+00X00+\S+00X00?\S"#
            let regex = try NSRegularExpression(pattern: qrCodePattern)
            let sourceRange = NSRange(self.startIndex..<self.endIndex, in: self)
            return regex.firstMatch(in: self, options: [], range: sourceRange) != nil
        } catch {
            return false
        }
    }
    
    var split: [String] {
        return self.components(separatedBy: "00X00")
    }

    func asCurrency() -> String? {
        Formatter.currency.locale = Locale.current
        return Formatter.currency.string(from: NSNumber(value: (Double(self) ?? 0) / 100))
    }

    func asDouble() -> Double? {
        Formatter.currency.locale = Locale.current
        return Formatter.currency.number(from: self)?.doubleValue
    }
}
