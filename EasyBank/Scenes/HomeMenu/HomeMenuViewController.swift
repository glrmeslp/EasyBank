import UIKit

final class HomeMenuViewController: UIViewController {

    private var viewModel: HomeMenuViewModel?

    @IBOutlet private weak var passwordButton: UIButton!
    @IBOutlet private weak var roomButton: UIButton!
    @IBOutlet private weak var accountButton: UIButton!
    @IBOutlet private weak var signOutButton: UIButton!

    init(viewModel: HomeMenuViewModel) {
        self.viewModel = viewModel
        super.init(nibName: "HomeMenuView", bundle: nil)
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @IBAction func didTapPassordButton(_ sender: Any) {
        viewModel?.updatePassword()
    }

    @IBAction func didTapRoomButton(_ sender: Any) {
        let alert = UIAlertController(title: "Do you want to leave the room?", message: nil, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        alert.addAction(UIAlertAction(title: "Leave", style: .destructive) { _ in
                            self.dismiss(animated: true)
                            self.viewModel?.leaveRoom()
        })
        present(alert, animated: true, completion: nil)
    }

    @IBAction func didTapAccountButton(_ sender: Any) {
        viewModel?.showAccount()
    }

    @IBAction func didTapSignOutButton(_ sender: Any) {
        let alert = UIAlertController(title: "Sign Out", message: "Do you really want to leave?", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        alert.addAction(UIAlertAction(title: "Sign Out", style: .destructive) { _ in
                            self.dismiss(animated: true)
                            self.viewModel?.signOut()
        })
        present(alert, animated: true, completion: nil)
    }
}
