import XCTest
@testable import EasyBank

final class QRCodeViewModelTests: XCTestCase {
    private let authServiceSpy = AuthenticationServiceSpy()
    private let coordinatorSpy = ReceiveCoordinatorSpy()
    private lazy var sut: QRCodeViewModel = QRCodeViewModel(value: 0.0,
                                                            coordinator: coordinatorSpy,
                                                            authService: authServiceSpy)

    func test_didFinish_shouldCallCoordinatorDidFinish() {
        sut.didFinish()
        XCTAssertTrue(coordinatorSpy.didFinishCalled)
    }

    func test_generateStringForQRcode_shouldReturnString() {
        authServiceSpy.user = User(identifier: "123", name: "Guilherme", email: "test@test.com")
        sut.generateStringForQRcode { result in
            XCTAssertEqual("com.glrmeslp.EasyBank00X00Room00X000.000X0012300X00Guilherme", result)
        }
    }

    func test_getValue_givenValueZero_shouldReturnString() {
        sut.getValue { result in
            XCTAssertEqual("Will be defined by who will pay", result)
        }
    }

    func test_getValue_givenValueTen_shouldReturnValueAsCurrency() {
        let value = 10.0
        sut = QRCodeViewModel(value: value, coordinator: coordinatorSpy, authService: authServiceSpy)
        sut.getValue { result in
            XCTAssertEqual(value.asCurrency(), result)
        }
    }
}
