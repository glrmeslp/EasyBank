import XCTest
@testable import EasyBank

final class HomeMenuViewModelTests: XCTestCase {
    private let authServiceSpy = AuthenticationServiceSpy()
    private let coordinatorSpy = HomeCoordinatorSpy()
    private lazy var sut: HomeMenuViewModel = HomeMenuViewModel(authService: authServiceSpy,
                                                                coordinator: coordinatorSpy)

    func test_updatePassword_shouldCallPushToPasswordViewController() {
        sut.updatePassword()
        XCTAssertTrue(coordinatorSpy.pushToPasswordViewControllerCalled)
    }

    func test_leaveRoom_shouldCallPushToStartViewController() {
        sut.leaveRoom()
        XCTAssertTrue(coordinatorSpy.pushToStartViewControllerCalled)
    }

    func test_showAccount_shouldCallPushToAcoountViewController() {
        sut.showAccount()
        XCTAssertTrue(coordinatorSpy.pushToAccountViewControllerCalled)
    }

    func test_signOut_shouldCallSignOutAndPushToStartViewController() {
        sut.signOut()
        XCTAssertTrue(authServiceSpy.signOutCalled)
        XCTAssertTrue(coordinatorSpy.pushToStartViewControllerCalled)
    }

    func test_enterBankMode_shouldCallPresentBankModeAlert() {
        sut.enterBankMode()
        XCTAssertTrue(coordinatorSpy.presentBankModeAlertCalled)
    }
}
