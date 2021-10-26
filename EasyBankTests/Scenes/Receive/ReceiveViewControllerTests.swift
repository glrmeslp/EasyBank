import XCTest
@testable import EasyBank

final class ReceiveViewControllerTests: XCTestCase {
    private let coordinatorSpy = ReceiveCoordinatorSpy()
    private lazy var sut: ReceiveViewController = ReceiveViewController(coordinator: coordinatorSpy)

    func test_viewDidLoad_shouldSetupTitte() {
        sut.viewDidLoad()
        XCTAssertEqual("Receive", sut.title)
    }

    func test_didTapCreateQRCodeButton_shouldCallPushToQRCodeViewController() {
        sut.loadViewIfNeeded()
        let sutMirrored = ReceiveViewControllerMirror(viewController: sut)
        let value = 10.0
        sutMirrored.valueTextField?.text = value.asCurrency()
        sutMirrored.createQRCodeButton?.sendActions(for: .touchUpInside)
        XCTAssertTrue(coordinatorSpy.pushToQRCodeViewControllerCalled)
        XCTAssertEqual(value, coordinatorSpy.valueReturned)
    }
}
