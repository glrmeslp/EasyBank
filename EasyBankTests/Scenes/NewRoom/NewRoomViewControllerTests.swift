import XCTest
@testable import EasyBank

final class NewRoomViewControllerTests: XCTestCase {
    private let newRoomViewModelSpy = NewRoomViewModelSpy()
    private lazy var sut: NewRoomViewController = NewRoomViewController(viewModel: newRoomViewModelSpy)

//    func test_textFieldShouldReturn_whenCreateButtonDisabled_shouldNotCallValidateRoom() {
//        let textField = UITextField()
//        textField.text = ""
//        sut.loadViewIfNeeded()
//        sut.textFieldShouldReturn(textField)
//        XCTAssertFalse(newRoomViewModelSpy.validateRoomCalled)
//    }

//    func test_textFieldShouldReturn_whenCreateButtonEnabled_shouldCallValidateRoom() {
//        let textField = UITextField()
//        textField.text = "Room"
//        sut.loadViewIfNeeded()
//        sut.textFieldShouldReturn(textField)
//        XCTAssertTrue(newRoomViewModelSpy.validateRoomCalled)
//    }
    func test_didTapCreateButton_shouldCallValidateRoom() {
        sut.loadViewIfNeeded()
        let sutMirrored = NewRoomViewControllerMirror(viewController: sut)
        sutMirrored.createButton?.sendActions(for: .touchUpInside)
        XCTAssertTrue(newRoomViewModelSpy.validateRoomCalled)
    }

    func test_textFieldDidChangeSelection_whenTextFieldIsEmpty_shouldReturnCreateButtonDisabled() {
        let textField = UITextField()
        textField.text = ""
        sut.loadViewIfNeeded()
        sut.textFieldDidChangeSelection(textField)
        let sutMirrored = NewRoomViewControllerMirror(viewController: sut)
        guard let createButton = sutMirrored.createButton else {
            XCTFail("Create Button is nil")
            return
        }
        XCTAssertFalse(createButton.isEnabled)
        XCTAssertEqual(createButton.configuration?.baseBackgroundColor, UIColor.systemGray6)
        XCTAssertEqual(createButton.configuration?.baseForegroundColor, UIColor.gray)
    }

    func test_textFieldDidChangeSelection_whenTextFieldIsNotEmpty_shouldReturnCreateButtonEnabled() {
        let textField = UITextField()
        textField.text = "Room"
        sut.loadViewIfNeeded()
        sut.textFieldDidChangeSelection(textField)
        let sutMirrored = NewRoomViewControllerMirror(viewController: sut)
        guard let createButton = sutMirrored.createButton else {
            XCTFail("Create Button is nil")
            return
        }
        XCTAssertTrue(createButton.isEnabled)
        XCTAssertEqual(createButton.configuration?.baseBackgroundColor, UIColor(named: "BlueColor"))
        XCTAssertEqual(createButton.configuration?.baseForegroundColor, UIColor.systemBackground)
    }
}
