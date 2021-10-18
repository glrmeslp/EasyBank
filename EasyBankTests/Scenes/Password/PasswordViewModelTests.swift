import XCTest
@testable import EasyBank

final class PasswordViewModelTests: XCTestCase {
    private let authServiceSpy = AuthenticationServiceSpy()
    private let coordinatorSpy = HomeCoordinatorSpy()
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

    func test_reauthenticate_withoutReauthenticateError_shouldReturnNil() {
        sut.reauthenticate(with: "") { error in
            XCTAssertNil(error)
        }
    }

    func test_reauthenticate_withReauthenticateError_shouldReturnError() {
        authServiceSpy.reauthenticateErrorToBeReturn = "Error!"
        sut.reauthenticate(with: "") { error in
            XCTAssertEqual(error, "Error!")
        }
    }

    func test_validateNewPassword_givenInvalidPassword_shouldReturnFalse() {
        sut.newPassword("password")
        sut.validateNewPassword("password123") { message, bool in
            XCTAssertEqual("Please enter a valid password", message)
            XCTAssertFalse(bool)
        }
    }

    func test_validateNewPassword_withoutUpdatePasswordError_shouldReturnTrue() {
        sut.newPassword("password")
        sut.validateNewPassword("password") { message, bool in
            XCTAssertEqual("Password updated successfully", message)
            XCTAssertTrue(bool)
        }
    }

    func test_validateNewPassword_withUpdatePasswordError_shouldReturnFalse() {
        authServiceSpy.updatePasswordErrorToBeReturn = "Error!"
        sut.newPassword("password")
        sut.validateNewPassword("password") { message, bool in
            XCTAssertEqual("Error!", message)
            XCTAssertFalse(bool)
        }
    }
}
