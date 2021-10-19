import XCTest
@testable import EasyBank

final class RecoverPasswordViewModelTests: XCTestCase {
    private let authServiceSpy = AuthenticationServiceSpy()
    private let coordinatorSpy = PasswordCoordinatorSpy()
    private lazy var sut: RecoverPasswordViewModel = RecoverPasswordViewModel(authService: authServiceSpy,
                                                                              coordinator: coordinatorSpy)

    func test_sendPasswordReset_withoutError_shouldCallPresentAlert() {
        sut.sendPasswordReset(with: "test@test.com")
        XCTAssertTrue(coordinatorSpy.presentAlertCalled)
        XCTAssertEqual("Follow the instructions sent to test@test.com to recover your password.",
                       coordinatorSpy.alertMessage)
    }

    func test_sendPasswordReset_withError_shouldCallPresentAlert() {
        authServiceSpy.sendPasswordResetErrorToBeReturn = "Error!"
        sut.sendPasswordReset(with: "test@test.com")
        XCTAssertTrue(coordinatorSpy.presentAlertCalled)
        XCTAssertEqual("Error!", coordinatorSpy.alertMessage)
    }
}
