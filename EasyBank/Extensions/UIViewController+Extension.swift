import UIKit

extension UIViewController {

    func presentAlert(with title: String, mesage: String? = nil,buttonTitle: String = "OK", and handler: ((UIAlertAction) -> Void)? = nil) {
        let alert = UIAlertController(title: title, message: mesage, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: buttonTitle, style: .cancel, handler: handler))
        present(alert, animated: true, completion: nil)
    }

    func presentActionSheet(title: String, buttonTitle: String, message: String? = nil, style: UIAlertAction.Style = .default, handler: ((UIAlertAction) -> Void)? = nil) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: buttonTitle, style: style, handler: handler))
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        present(alert, animated: true)
    }
    
    func setupNavigationController(isHidden: Bool) {
        let backBarButtonItem =  UIBarButtonItem(title: "", style: .plain, target: self, action: nil)
        navigationItem.backBarButtonItem = backBarButtonItem
        navigationController?.isNavigationBarHidden = isHidden
        navigationController?.navigationBar.backgroundColor = UIColor.systemBackground
        navigationController?.navigationBar.tintColor = UIColor(named: "BlueColor")
    }

    func addGestureRecognizerForEndEditing() {
        let tapGestureRecognizer = UITapGestureRecognizer(target: self,
                                                          action: #selector(didTapView))
        view.addGestureRecognizer(tapGestureRecognizer)
    }

    @objc private func didTapView(_ sender: UITapGestureRecognizer) {
        view.endEditing(true)
    }
}
