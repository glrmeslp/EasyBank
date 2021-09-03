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
}
