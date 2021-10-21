import XCTest
@testable import EasyBank

final class RecoverPasswordViewControllerTests: XCTestCase {
    private let viewModelSpy = RecoverPasswordVieModelSpy()
    private lazy var sut: RecoverPasswordViewController = RecoverPasswordViewController(viewModel: viewModelSpy)

    func test_textFieldDidChangeSelection_whenTextFieldIsEmpty_shouldReturnContinueButtonDisabled() {
        let textField = UITextField()
        textField.text = ""
        sut.loadViewIfNeeded()
        sut.textFieldDidChangeSelection(textField)
        let sutMirrored = RecoverPasswordViewControllerMirror(viewController: sut)
        guard let sendButton = sutMirrored.sendButton else {
            XCTFail("sendButton is nil")
            return
        }
        XCTAssertFalse(sendButton.isEnabled)
        XCTAssertEqual(sendButton.configuration?.baseBackgroundColor, UIColor.systemGray6)
        XCTAssertEqual(sendButton.configuration?.baseForegroundColor, UIColor.gray)
    }

    func test_textFieldDidChangeSelection_whenTextFieldIsNotEmpty_shouldReturnContinueButtonEnabled(){
        let textField = UITextField()
        textField.text = "Test"
        sut.loadViewIfNeeded()
        sut.textFieldDidChangeSelection(textField)
        let sutMirrored = RecoverPasswordViewControllerMirror(viewController: sut)
        guard let sendButton = sutMirrored.sendButton else {
            XCTFail("sendButton is nil")
            return
        }
        XCTAssertTrue(sendButton.isEnabled)
        XCTAssertEqual(sendButton.configuration?.baseBackgroundColor, UIColor(named: "BlueColor"))
        XCTAssertEqual(sendButton.configuration?.baseForegroundColor, UIColor.systemBackground)
    }

    func test_textFieldShouldReturn_whenSendButtonIsEnabled_shouldCallSendPasswordReset() {
        sut.loadViewIfNeeded()
        sut.viewDidLoad()
        let sutMirrored = RecoverPasswordViewControllerMirror(viewController: sut)
        guard let textField = sutMirrored.emailTextField else {
            XCTFail("emailTextField is nil")
            return
        }
        textField.text = "test@test.com"
        sut.textFieldDidChangeSelection(textField)
        _ = sut.textFieldShouldReturn(textField)
        XCTAssertTrue(viewModelSpy.sendPasswordResetCalled)
    }

    func test_textFieldShouldReturn_whenSendButtonIsDisabled_shouldNotCallSendPasswordReset() {
        sut.loadViewIfNeeded()
        sut.viewDidLoad()
        let sutMirrored = RecoverPasswordViewControllerMirror(viewController: sut)
        guard let textField = sutMirrored.emailTextField else {
            XCTFail("emailTextField is nil")
            return
        }
        textField.text = ""
        sut.textFieldDidChangeSelection(textField)
        _ = sut.textFieldShouldReturn(textField)
        XCTAssertFalse(viewModelSpy.sendPasswordResetCalled)
    }
}
