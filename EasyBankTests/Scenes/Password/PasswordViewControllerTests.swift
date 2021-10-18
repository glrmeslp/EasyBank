import XCTest
@testable import EasyBank

final class PasswordViewControllerTests: XCTestCase {
    private let viewModelSpy = PasswordViewModelSpy()
    private lazy var sut: PasswordViewController = PasswordViewController(viewModel: viewModelSpy)

    func test_didTapForgotPassword_shouldCallShowRecoverPasswordViewController() {
        sut.loadViewIfNeeded()
        let sutMirrored = PasswordViewControllerMirror(viewController: sut)
        guard let forgotPasswordButton = sutMirrored.forgotPasswordButton else {
            XCTFail("forgotPasswordButton is nil")
            return
        }
        forgotPasswordButton.sendActions(for: .touchUpInside)
        XCTAssertTrue(viewModelSpy.showRecoverPasswordViewControllerCalled)
    }

    func test_didTapContinueButton_givenCurrentPassword_shouldCallSetupNewPassword() {
        sut.loadViewIfNeeded()
        sut.viewDidLoad()
        let textField = UITextField()
        textField.text = "password123"
        sut.textFieldDidChangeSelection(textField)
        _ = sut.textFieldShouldReturn(textField)
        let sutMirrored = PasswordViewControllerMirror(viewController: sut)
        guard let forgotPasswordButton = sutMirrored.forgotPasswordButton else {
            XCTFail("forgotPasswordButton is nil")
            return
        }
        XCTAssertTrue(viewModelSpy.reauthenticateCalled)
        XCTAssertTrue(forgotPasswordButton.isHidden)
        XCTAssertEqual(sutMirrored.titleLabel?.text, "Enter new password")
        XCTAssertEqual(sutMirrored.progressView?.progress, 2/3)
        XCTAssertEqual(sutMirrored.stepLabel?.text, "Step 2/3")
    }

    func test_didTapContinueButton_withReauthenticateError_shouldCallPresentAlert() {
        viewModelSpy.reauthenticateErrorToBeReturn = "Error!"
        sut.loadViewIfNeeded()
        sut.viewDidLoad()
        let textField = UITextField()
        textField.text = "password123"
        sut.textFieldDidChangeSelection(textField)
        _ = sut.textFieldShouldReturn(textField)
        XCTAssertTrue(viewModelSpy.reauthenticateCalled)
    }

    func test_didTapContinueButton_givenNewPassword_shouldCallSetupConfirmPassword() {
        sut.loadViewIfNeeded()
        sut.viewDidLoad()
        let textField = UITextField()
        textField.text = "password123"
        sut.textFieldDidChangeSelection(textField)
        _ = sut.textFieldShouldReturn(textField)
        textField.text = "password"
        _ = sut.textFieldShouldReturn(textField)
        let sutMirrored = PasswordViewControllerMirror(viewController: sut)
        XCTAssertEqual(sutMirrored.titleLabel?.text, "Confirm new password")
        XCTAssertEqual(sutMirrored.progressView?.progress, 1)
        XCTAssertEqual(sutMirrored.stepLabel?.text, "Step 3/3")
    }
}
