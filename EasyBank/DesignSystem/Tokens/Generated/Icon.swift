import UIKit

enum Icon: String {
    case charge = "charge"
    case room = "room"
    case pay = "pay"
    
    var image: UIImage {
        guard let image = UIImage(named: self.rawValue) else {
            return UIImage()
        }
        return image
    }
}
