import XCTest
@testable import EasyBank

final class RoomViewControllerTests: XCTestCase {
    private let roomViewModelSpy = RoomViewModelSpy()
    private lazy var sut: RoomViewController = RoomViewController(viewModel: roomViewModelSpy)
    
    func test_didTapCreateButton_shouldCallEnter() {
        sut.loadViewIfNeeded()
        let sutMirrored = RoomViewControllerMirror(viewController: sut)
        sutMirrored.continueButton?.sendActions(for: .touchUpInside)
        XCTAssertTrue(roomViewModelSpy.enterCalled)
    }

    func test_textFieldDidChangeSelection_whenTextFieldIsEmpty_shouldReturnContinueButtonDisabled() {
        let textField = UITextField()
        textField.text = ""
        sut.loadViewIfNeeded()
        sut.textFieldDidChangeSelection(textField)
        let sutMirrored = RoomViewControllerMirror(viewController: sut)
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
        let sutMirrored = RoomViewControllerMirror(viewController: sut)
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
        XCTAssertFalse(roomViewModelSpy.enterCalled)
    }

    func test_textFieldShouldReturn_whenContinueButtonIsEnabled_shouldCallEnter() {
        let textField = UITextField()
        textField.text = "Room"
        sut.loadViewIfNeeded()
        sut.textFieldDidChangeSelection(textField)
        _ = sut.textFieldShouldReturn(textField)
        XCTAssertTrue(roomViewModelSpy.enterCalled)
    }
}
