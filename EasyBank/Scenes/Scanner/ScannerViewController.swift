import UIKit
import AVFoundation

final class ScannerViewController: UIViewController {
    private var captureSession: AVCaptureSession = AVCaptureSession()
    private var previewLayer: AVCaptureVideoPreviewLayer!
    private var viewModel: ScannerViewModelDelegate?
    
    @IBOutlet private weak var qrCodeSafeAreaView: UIView!
    @IBOutlet private weak var preview: UIView!
    
    init(viewModel: ScannerViewModelDelegate) {
        self.viewModel = viewModel
        super.init(nibName: "ScannerView", bundle: nil)
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        isCaptureSessionRunning()
    }

    private func isCaptureSessionRunning() {
        if (captureSession.isRunning == true) {
            captureSession.stopRunning()
        }
        if (captureSession.isRunning == false) {
            captureSession.startRunning()
        }
    }

    private func setup() {
        qrCodeSafeAreaView.layer.cornerRadius = 5
        qrCodeSafeAreaView.layer.borderColor = UIColor(named: "BlueColor")!.cgColor
        qrCodeSafeAreaView.layer.borderWidth = 2

        addInput()
    }

    private func addInput() {
        guard let videoCaptureDevice = AVCaptureDevice.default(for: .video) else {
            failed()
            return
        }
        let videoInput: AVCaptureDeviceInput
        do {
            videoInput = try AVCaptureDeviceInput(device: videoCaptureDevice)
        } catch {
            return
        }

        if (captureSession.canAddInput(videoInput)) {
            captureSession.addInput(videoInput)
        } else {
            failed()
            return
        }
        addOutput()
    }

    private func addOutput() {
        let metadataOutput = AVCaptureMetadataOutput()

        if (captureSession.canAddOutput(metadataOutput)) {
            captureSession.addOutput(metadataOutput)
            metadataOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
            metadataOutput.metadataObjectTypes = [.qr]
        } else {
            failed()
            return
        }
        addPreviewLayer()
    }

    private func addPreviewLayer() {
        previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        previewLayer.frame = view.layer.bounds
        previewLayer.videoGravity = .resizeAspectFill
        preview.layer.addSublayer(previewLayer)

        captureSession.startRunning()
    }

    private func found(code: String) {
        viewModel?.validateQRCode(code: code) { _ in self.captureSession.startRunning()}
    }

    private func failed() {
        viewModel?.presentFailedAlert()
    }
}

extension ScannerViewController: AVCaptureMetadataOutputObjectsDelegate {
    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        captureSession.stopRunning()
        if let metadataObject = metadataObjects.first {
            guard let readableObject = metadataObject as? AVMetadataMachineReadableCodeObject else { return }
            guard let stringValue = readableObject.stringValue else { return }
            found(code: stringValue)
        }
    }
}
