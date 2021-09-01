import UIKit
import AVFoundation

final class ScannerViewController: UIViewController, AVCaptureMetadataOutputObjectsDelegate {
    private var captureSession: AVCaptureSession!
    private var previewLayer: AVCaptureVideoPreviewLayer!
    private var viewModel: ScannerViewModel?
    
    @IBOutlet private weak var qrCodeSafeAreaView: UIView!
    @IBOutlet private weak var preview: UIView!
    
    init(viewModel: ScannerViewModel) {
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

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        isCaptureSessionRunning()
    }

    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        captureSession.stopRunning()

        if let metadataObject = metadataObjects.first {
            guard let readableObject = metadataObject as? AVMetadataMachineReadableCodeObject else { return }
            guard let stringValue = readableObject.stringValue else { return }
            AudioServicesPlaySystemSound(SystemSoundID(kSystemSoundID_Vibrate))
            found(code: stringValue)
        }

        dismiss(animated: true)
    }

    private func isCaptureSessionRunning() {
        if (captureSession?.isRunning == true) {
            captureSession.stopRunning()
        }
        if (captureSession?.isRunning == false) {
            captureSession.startRunning()
        }
    }

    private func setup() {
        qrCodeSafeAreaView.layer.cornerRadius = 5
        qrCodeSafeAreaView.layer.borderColor = UIColor(named: "BlueColor")!.cgColor
        qrCodeSafeAreaView.layer.borderWidth = 2

        captureSession = AVCaptureSession()

        guard let videoCaptureDevice = AVCaptureDevice.default(for: .video) else { return }
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

        let metadataOutput = AVCaptureMetadataOutput()

        if (captureSession.canAddOutput(metadataOutput)) {
            captureSession.addOutput(metadataOutput)

            metadataOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
            metadataOutput.metadataObjectTypes = [.qr]
        } else {
            failed()
            return
        }

        previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        previewLayer.frame = view.layer.bounds
        previewLayer.videoGravity = .resizeAspectFill
        preview.layer.addSublayer(previewLayer)
        captureSession.startRunning()
    }

    private func found(code: String) {
        viewModel?.showPayViewController(with: code)
    }

    private func failed() {
        presentAlert(with: "Scanning not supported",
                     mesage: "Your device does not support scanning a code from an item. Please use a device with a camera.")
        captureSession = nil
    }
}
