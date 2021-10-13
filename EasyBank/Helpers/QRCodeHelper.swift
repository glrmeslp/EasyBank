import UIKit

final class QRCodeHelper {
    func isQRCodeValid(value: String) -> Bool {
        do {
            let qrCodePattern = #"com.glrmeslp.EasyBank00X00+\S+00X00+\S+00X00?\S"#
            let regex = try NSRegularExpression(pattern: qrCodePattern)
            let sourceRange = NSRange(value.startIndex..<value.endIndex, in: value)
            return regex.firstMatch(in: value, options: [], range: sourceRange) != nil
        } catch {
            return false
        }
    }

    func generateQRCode(from string: String) -> UIImage? {
        let data = string.data(using: String.Encoding.ascii)
            if let filter = CIFilter(name: "CIQRCodeGenerator") {
                filter.setValue(data, forKey: "inputMessage")
                let transform = CGAffineTransform(scaleX: 10, y: 10)

                if let output = filter.outputImage?.transformed(by: transform) {
                    return UIImage(ciImage: output)
                }
            }
            return nil
    }
}
