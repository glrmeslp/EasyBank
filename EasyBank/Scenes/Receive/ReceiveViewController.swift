import UIKit

final class ReceiveViewController: UIViewController {

    private var viewModel: ReceiveViewModel?
    @IBOutlet private weak var qrCodeImage: UIImageView!
    @IBOutlet private weak var homeButton: UIButton!
    
    init(viewModel: ReceiveViewModel) {
        self.viewModel = viewModel
        super.init(nibName: "ReceiveView", bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }

    @IBAction func didTapHomeButton(_ sender: Any) {
        viewModel?.didFinish()
    }

    private func setup() {
        homeButton.layer.cornerRadius = 20
        generateQRcode()
        title = "My QR Code"
    }

    private func generateQRcode() {
        viewModel?.getUid { [weak self] uid in
            self?.qrCodeImage.image = UIImage().generateQRCode(from: uid)
        }
    }
}
