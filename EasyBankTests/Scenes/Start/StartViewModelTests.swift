import XCTest
@testable import EasyBank

final class StartViewModelTests: XCTestCase {
    private let authServiceSpy = AuthenticationServiceSpy()
    private let coordinatorSpy = StartCoordinatorSpy()
    private lazy var sut: StartViewModel = StartViewModel(authService: authServiceSpy,
                                                          coordinator: coordinatorSpy) 

    func test_showNewRoomViewController_shouldCallPushToNewRoomViewController() {
        sut.showNewRoomViewController()
        XCTAssertTrue(coordinatorSpy.pushToNewRoomViewControllerCalled)
    }

    func test_showRoomViewController_shouldCallPushToRoomViewController() {
        sut.showRoomViewController()
        XCTAssertTrue(coordinatorSpy.pushToRoomViewControllerCalled)
    }

    func test_detectAuthenticationStatus_noUserLoggedIn_shouldCallShowAuthViewController() {
        sut.detectAuthenticationStatus()
        XCTAssertTrue(coordinatorSpy.pushToAuthViewControllerCalled)
    }

    func test_detectAuthenticationStatus_userLoggedIn_shouldNotCallShowAuthViewController() {
        authServiceSpy.user = User(identifier: "", name: "Test", email: "test@test.com")
        sut.detectAuthenticationStatus()
        XCTAssertFalse(coordinatorSpy.pushToAuthViewControllerCalled)
    }

    func test_undetectAuthenticationStatus_shouldCallRemoveStateDidChangeListener() {
        sut.undetectAuthenticationStatus()
        XCTAssertTrue(authServiceSpy.removeStateDidChangeListenerCalled)
    }
}
