import XCTest
@testable import EasyBank

final class AccountViewControllerTests: XCTestCase {
    private let viewModelSpy = AccountViewModelSpy()
    private lazy var sut: AccountViewController = AccountViewController(viewModel: viewModelSpy)

    func test_viewDidLoad_shouldSetupTittle() {
        sut.loadViewIfNeeded()
        sut.viewDidLoad()
        let title = sut.title
        XCTAssertEqual("Account", title)
    }

    func test_viewWillAppear_shouldCallFetchData() {
        viewModelSpy.roomNameToBeReturn = "Room"
        viewModelSpy.userToBeReturn = User(identifier: "", name: "Guilherme", email: "guilherme@test.com")
        sut.loadViewIfNeeded()
        sut.viewWillAppear(false)
        let sutMirrored = AccountViewControllerMirror(viewController: sut)
        XCTAssertTrue(viewModelSpy.fetchDataCalled)
        XCTAssertEqual("Room", sutMirrored.roomNameLabel?.text)
        XCTAssertEqual("Guilherme", sutMirrored.userNameLabel?.text)
        XCTAssertEqual("guilherme@test.com", sutMirrored.emailLabel?.text)
    }

    func test_didTapDeleteAccountButton_shouldCallPresentDeleteAccountActionSheet() {
        sut.loadViewIfNeeded()
        let sutMirrored = AccountViewControllerMirror(viewController: sut)
        sutMirrored.deleteAccount?.sendActions(for: .touchUpInside)
        XCTAssertTrue(viewModelSpy.presentDeleteAccountActionSheetCalled)
    }

    func test_didTapCloseYourAccountButton_shouldCallDeleteEasyBankAccount() {
        sut.loadViewIfNeeded()
        let sutMirrored = AccountViewControllerMirror(viewController: sut)
        sutMirrored.closeYourAccountButton?.sendActions(for: .touchUpInside)
        XCTAssertTrue(viewModelSpy.deleteEasyBankAccountCalled)
    }

    func test_didTapLeaveRoomButton_shouldCallPresentLeaveRoomActionSheet() {
        sut.loadViewIfNeeded()
        let sutMirrored = AccountViewControllerMirror(viewController: sut)
        sutMirrored.leaveRoomButton?.sendActions(for: .touchUpInside)
        XCTAssertTrue(viewModelSpy.presentLeaveRoomActionSheetCalled)
    }

    func test_didTapProfileButton_shouldCallManageProfileInformation() {
        sut.loadViewIfNeeded()
        let sutMirrored = AccountViewControllerMirror(viewController: sut)
        sutMirrored.yourProfileButton?.sendActions(for: .touchUpInside)
        XCTAssertTrue(viewModelSpy.manageProfileInformationCalled)
    }

}
