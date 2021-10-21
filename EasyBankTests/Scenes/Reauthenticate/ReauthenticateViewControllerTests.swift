import XCTest
@testable import EasyBank

final class ReauthenticateViewControllerTests: XCTestCase {
    private let viewModelSpy = ReauthenticateViewModelSpy()
    private lazy var sut: ReauthenticateViewController = ReauthenticateViewController(viewModel: viewModelSpy)

    func test_textFieldDidChangeSelection_whenTextFieldIsEmpty_shouldReturnContinueButtonDisabled() {
        let textField = UITextField()
        textField.text = ""
        sut.loadViewIfNeeded()
        sut.textFieldDidChangeSelection(textField)
        let sutMirrored = ReauthenticateViewControllerMirror(viewController: sut)
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
        let sutMirrored = ReauthenticateViewControllerMirror(viewController: sut)
        guard let continueButton = sutMirrored.continueButton else {
            XCTFail("Continue Button is nil")
            return
        }
        XCTAssertTrue(continueButton.isEnabled)
        XCTAssertEqual(continueButton.configuration?.baseBackgroundColor, UIColor(named: "BlueColor"))
        XCTAssertEqual(continueButton.configuration?.baseForegroundColor, UIColor.systemBackground)
    }

    func test_textFieldShouldReturn_whenContinueButtonIsDisabled_shouldNotCallEnter() {
        let textField = UITextField()
        textField.text = ""
        sut.loadViewIfNeeded()
        sut.textFieldDidChangeSelection(textField)
        _ = sut.textFieldShouldReturn(textField)
        XCTAssertFalse(viewModelSpy.reauthenticateCalled)
    }

    func test_textFieldShouldReturn_whenContinueButtonIsEnabled_shouldCallEnter() {
        sut.loadViewIfNeeded()
        sut.viewDidLoad()
        let sutMirrored = ReauthenticateViewControllerMirror(viewController: sut)
        guard let textField = sutMirrored.passwordTextfield else {
            XCTFail("Text field is nil")
            return
        }
        textField.text = "password"
        sut.textFieldDidChangeSelection(textField)
        _ = sut.textFieldShouldReturn(textField)
        XCTAssertTrue(viewModelSpy.reauthenticateCalled)
        XCTAssertEqual("password", viewModelSpy.passwordReturned)
    }
}
