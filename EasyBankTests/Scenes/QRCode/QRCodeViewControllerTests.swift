import XCTest
@testable import EasyBank

final class QRCodeViewControllerTests: XCTestCase {
    private let viewModelSpy = QRCodeViewModelSpy()
    private lazy var sut: QRCodeViewController = QRCodeViewController(viewModel: viewModelSpy)

    func test_viewDidLoad_shouldSetupTitle() {
        sut.viewDidLoad()
        XCTAssertEqual("My QR Code", sut.title)
    }

    func test_viewDidLoad_shouldCallGetValue() {
        viewModelSpy.valueToBeReturn = 10.0
        sut.loadViewIfNeeded()
        sut.viewDidLoad()
        let sutMirrored = QRCodeViewControllerMirror(viewController: sut)
        XCTAssertEqual(10.0.asCurrency(), sutMirrored.valueLabel?.text)
    }

    func test_viewDidLoad_shouldCallGenerateStringForQRcode() {
        viewModelSpy.stringForQRCodeToBeReturn = "test"
        sut.loadViewIfNeeded()
        sut.viewDidLoad()
        let sutMirrored = QRCodeViewControllerMirror(viewController: sut)
        XCTAssertNotNil(sutMirrored.qrCodeImageView?.image)
    }

    func test_didTapHomeButton_shouldCallDidFinish() {
        sut.loadViewIfNeeded()
        let sutMirrored = QRCodeViewControllerMirror(viewController: sut)
        sutMirrored.homeButton?.sendActions(for: .touchUpInside)
        XCTAssertTrue(viewModelSpy.didFinishCalled)
    }
}
