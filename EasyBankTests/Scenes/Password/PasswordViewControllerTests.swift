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

    func test_didTapContinueButton_givenReauthenticateResultTrue_shouldCallSetupNewPassword() {
        viewModelSpy.reauthenticateResultToBeReturn = true
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

    func test_didTapContinueButton_givenReauthenticateResultFalse_shouldNotCallSetupNewPassword() {
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
        XCTAssertFalse(forgotPasswordButton.isHidden)
        XCTAssertEqual(sutMirrored.titleLabel?.text, "Enter your current password")
        XCTAssertEqual(sutMirrored.progressView?.progress, 1/3)
        XCTAssertEqual(sutMirrored.stepLabel?.text, "Step 1/3")
    }

    func test_didTapContinueButton_givenNewPassword_shouldCallSetupConfirmPassword() {
        viewModelSpy.reauthenticateResultToBeReturn = true
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

    func test_didTapContinueButton_givenUpdateResultFalse_shouldCallSetupNewPassword() {
        viewModelSpy.reauthenticateResultToBeReturn = true
        sut.loadViewIfNeeded()
        sut.viewDidLoad()
        let textField = UITextField()
        textField.text = "password123"
        sut.textFieldDidChangeSelection(textField)
        _ = sut.textFieldShouldReturn(textField)
        textField.text = "password"
        _ = sut.textFieldShouldReturn(textField)
        textField.text = "password12"
        _ = sut.textFieldShouldReturn(textField)
        let sutMirrored = PasswordViewControllerMirror(viewController: sut)
        XCTAssertEqual(sutMirrored.titleLabel?.text, "Enter new password")
        XCTAssertEqual(sutMirrored.progressView?.progress, 2/3)
        XCTAssertEqual(sutMirrored.stepLabel?.text, "Step 2/3")
    }

    func test_didTapContinueButton_givenUpdateResultTrue_shouldNotCallSetupNewPassword() {
        viewModelSpy.reauthenticateResultToBeReturn = true
        viewModelSpy.updatePasswordResultToBeReturn = true
        sut.loadViewIfNeeded()
        sut.viewDidLoad()
        let textField = UITextField()
        textField.text = "password123"
        sut.textFieldDidChangeSelection(textField)
        _ = sut.textFieldShouldReturn(textField)
        textField.text = "password"
        _ = sut.textFieldShouldReturn(textField)
        textField.text = "password"
        _ = sut.textFieldShouldReturn(textField)
        let sutMirrored = PasswordViewControllerMirror(viewController: sut)
        XCTAssertEqual(sutMirrored.titleLabel?.text, "Confirm new password")
        XCTAssertEqual(sutMirrored.progressView?.progress, 1)
        XCTAssertEqual(sutMirrored.stepLabel?.text, "Step 3/3")
    }

    func test_textFieldDidChangeSelection_whenTextFieldIsEmpty_shouldReturnContinueButtonDisabled() {
        let textField = UITextField()
        textField.text = ""
        sut.loadViewIfNeeded()
        sut.textFieldDidChangeSelection(textField)
        let sutMirrored = PasswordViewControllerMirror(viewController: sut)
        guard let continueButton = sutMirrored.continueButton else {
            XCTFail("Continue Button is nil")
            return
        }
        XCTAssertFalse(continueButton.isEnabled)
        XCTAssertEqual(continueButton.configuration?.baseBackgroundColor, UIColor.systemGray6)
        XCTAssertEqual(continueButton.configuration?.baseForegroundColor, UIColor.gray)
    }

    func test_textFieldDidChangeSelection_whenTextFieldIsNotEmpty_shouldReturnContinueButtonEnabled(){
        let textField = UITextField()
        textField.text = "Test"
        sut.loadViewIfNeeded()
        sut.textFieldDidChangeSelection(textField)
        let sutMirrored = PasswordViewControllerMirror(viewController: sut)
        guard let continueButton = sutMirrored.continueButton else {
            XCTFail("Continue Button is nil")
            return
        }
        XCTAssertTrue(continueButton.isEnabled)
        XCTAssertEqual(continueButton.configuration?.baseBackgroundColor, UIColor(named: "BlueColor"))
        XCTAssertEqual(continueButton.configuration?.baseForegroundColor, UIColor.systemBackground)
    }
}
