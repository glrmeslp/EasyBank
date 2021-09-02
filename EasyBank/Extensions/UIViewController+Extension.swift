import UIKit

extension UIViewController {

    func presentAlert(with title: String, mesage: String? = nil,buttonTitle: String = "OK", and handler: ((UIAlertAction) -> Void)? = nil) {
        let alert = UIAlertController(title: title, message: mesage, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: buttonTitle, style: .cancel, handler: handler))
        present(alert, animated: true, completion: nil)
    }
    
    func setupNavigationController(isHidden: Bool) {
        let backBarButtonItem =  UIBarButtonItem(title: "", style: .plain, target: self, action: nil)
        navigationItem.backBarButtonItem = backBarButtonItem

        navigationController?.navigationBar.isHidden = isHidden
        navigationController?.navigationBar.isTranslucent = false
        navigationController?.navigationBar.tintColor = UIColor(named: "BlueColor")
    }
    
}
