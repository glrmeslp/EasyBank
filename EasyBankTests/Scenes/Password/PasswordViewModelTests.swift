import XCTest
@testable import EasyBank

final class PasswordViewModelTests: XCTestCase {
    private let authServiceSpy = AuthenticationServiceSpy()
    private let coordinatorSpy = PasswordCoordinatorSpy()
    private lazy var sut: PasswordViewModel = PasswordViewModel(authService: authServiceSpy,
                                                                coordinator: coordinatorSpy)

    func test_didFinish_shouldCallPopToHomeViewController() {
        sut.didFinish()
        XCTAssertTrue(coordinatorSpy.popToHomeViewControllerCalled)
    }

    func test_showRecoverPasswordViewController_shouldCallPushToRecoverPasswordViewController() {
        sut.showRecoverPasswordViewController()
        XCTAssertTrue(coordinatorSpy.pushToRecoverPasswordViewControllerCalled)
    }

    func test_reauthenticate_withoutReauthenticateError_shouldReturnTrue() {
        sut.reauthenticate(with: "") { result in
            XCTAssertTrue(result)
        }
    }

    func test_reauthenticate_withReauthenticateError_shouldShouldCallPresentAlert() {
        authServiceSpy.reauthenticateErrorToBeReturn = "Error!"
        sut.reauthenticate(with: "") { result in
            XCTAssertFalse(result)
        }
        XCTAssertTrue(coordinatorSpy.presentAlertCalled)
        XCTAssertEqual("Error!", coordinatorSpy.alertMessage)
    }

    func test_validateNewPassword_givenInvalidPassword_shouldReturnFalse() {
        sut.newPassword("password")
        sut.validateNewPassword("password123") { result in
            XCTAssertFalse(result)
        }
        XCTAssertTrue(coordinatorSpy.presentAlertCalled)
        XCTAssertEqual("Please enter a valid password", coordinatorSpy.alertMessage)
    }

    func test_validateNewPassword_withoutUpdatePasswordError_shouldReturnTrue() {
        sut.newPassword("password")
        sut.validateNewPassword("password") { result in
            XCTAssertTrue(result)
        }
        XCTAssertTrue(coordinatorSpy.presentAlertCalled)
        XCTAssertEqual("Password updated successfully", coordinatorSpy.alertMessage)
    }

    func test_validateNewPassword_withUpdatePasswordError_shouldReturnFalse() {
        authServiceSpy.updatePasswordErrorToBeReturn = "Error!"
        sut.newPassword("password")
        sut.validateNewPassword("password") { result in
            XCTAssertFalse(result)
        }
        XCTAssertTrue(coordinatorSpy.presentAlertCalled)
        XCTAssertEqual("Error!", coordinatorSpy.alertMessage)
    }
}
