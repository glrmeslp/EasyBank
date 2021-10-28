import XCTest
@testable import EasyBank

final class ScannerViewModelTests: XCTestCase {
    private let coordinatorSpy = PayCoordinatorSpy()
    private let roomServiceSpy = DatabaseServiceSpy()
    private lazy var sut: ScannerViewModel = ScannerViewModel(coordinator: coordinatorSpy,
                                                              roomService: roomServiceSpy)

    func test_validateQRCode_givenInvalidQRCode_shouldCallPresentQRCodeInvalidAlert() {
        sut.validateQRCode(code: "") { _ in }
        XCTAssertTrue(coordinatorSpy.presentAlertCalled)
        XCTAssertEqual("Oops! Something went wrong", coordinatorSpy.titleReturned)
        XCTAssertEqual("This payment has not been completed because this QR code is invalid.", coordinatorSpy.messageReturned)
        XCTAssertNotNil(coordinatorSpy.handlerReturned)
    }

    func test_validateQRCode_givenInexistentAccount_shouldCallPresentQRCodeInvalidAlert() {
        sut.validateQRCode(code: "com.glrmeslp.EasyBank00X00Room00X0010.000X0000X00") { _ in }
        XCTAssertTrue(coordinatorSpy.presentAlertCalled)
        XCTAssertEqual("Oops! Something went wrong", coordinatorSpy.titleReturned)
        XCTAssertEqual("This payment has not been completed because this QR code is invalid.", coordinatorSpy.messageReturned)
        XCTAssertNotNil(coordinatorSpy.handlerReturned)
    }

    func test_validateQRCode_givenExistentAccount_shouldCallPushToPayViewController() {
        roomServiceSpy.rooms = ["Room": ["123": Account(balance: 0, userName: "UserName")]]
        sut.validateQRCode(code: "com.glrmeslp.EasyBank00X00Room00X0010.000X0012300X00UserName") { _ in }
        XCTAssertTrue(coordinatorSpy.pushToPayViewControllerCalled)
        XCTAssertEqual(["Room","10.0","123","UserName"], coordinatorSpy.codeReturned)
    }

    func test_presentFailedAlert_shouldCallPresentAlert() {
        sut.presentFailedAlert()
        XCTAssertTrue(coordinatorSpy.presentAlertCalled)
        XCTAssertEqual("Scanning not supported", coordinatorSpy.titleReturned)
        XCTAssertEqual("Your device does not support scanning a code from an item. Please use a device with a camera.", coordinatorSpy.messageReturned)
        XCTAssertNil(coordinatorSpy.handlerReturned)
    }
}
