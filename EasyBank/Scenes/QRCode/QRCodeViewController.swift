import UIKit

class QRCodeViewController: UIViewController {

    private var viewModel: QRCodeViewModel?

    @IBOutlet private weak var valueTextField: UILabel!
    @IBOutlet private weak var qrCodeImageView: UIImageView!
    @IBOutlet private weak var homeButton: UIButton!
    
    init(viewModel: QRCodeViewModel) {
        self.viewModel = viewModel
        super.init(nibName: "QRCodeView", bundle: nil)
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
        homeButton.layer.cornerRadius = 25
    
        title = "My QR Code"
        
        viewModel?.getValue { [weak self] value in
            self?.valueTextField.text = value
        }
        
        viewModel?.generateStringForQRcode { [weak self] string in
            self?.qrCodeImageView.image = QRCodeHelper().generateQRCode(from: string)
        }
    }
}
