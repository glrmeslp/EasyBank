import UIKit

final class QRCodeViewController: UIViewController {

    private var viewModel: QRCodeViewModelProtocol?

    @IBOutlet private weak var valueLabel: UILabel!
    @IBOutlet private weak var qrCodeImageView: UIImageView!
    @IBOutlet private weak var homeButton: UIButton!
    
    init(viewModel: QRCodeViewModelProtocol) {
        self.viewModel = viewModel
        super.init(nibName: "QRCodeView", bundle: nil)
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        fetchData()
    }

    @IBAction func didTapHomeButton(_ sender: Any) {
        viewModel?.didFinish()
    }

    private func setup() {
        title = "My QR Code"
    }

    private func fetchData() {
        viewModel?.getValue { [weak self] value in
            self?.valueLabel.text = value
        }
        viewModel?.generateStringForQRcode { [weak self] string in
            self?.qrCodeImageView.image = QRCodeHelper().generateQRCode(from: string)
        }
    }
}
