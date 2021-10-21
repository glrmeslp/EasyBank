import XCTest
@testable import EasyBank

final class ReauthenticateViewModelTests: XCTestCase {
    private let authServiceSpy = AuthenticationServiceSpy()
    private let coordinatorSpy = AccountCoordinatorSpy()
    private lazy var sut: ReauthenticateViewModel = ReauthenticateViewModel(coordinator: coordinatorSpy,
                                                                            authService: authServiceSpy,
                                                                            motive: .deleteUser)

    func test_reauthenticate_withReauthenticateError_shouldCallCoordinatorPresentAlert() {
        authServiceSpy.reauthenticateErrorToBeReturn = "Error!"
        sut.reauthenticate(with: "")
        XCTAssertTrue(authServiceSpy.reauthenticateCalled)
        XCTAssertTrue(coordinatorSpy.presentAlertCalled)
        XCTAssertEqual("Error!", coordinatorSpy.message)
    }

    func test_reauthenticateFor_whenMotiveIsDeleteUser_shouldCallPresentDeleteUserActionSheet() {
        sut.reauthenticate(with: "password")
        XCTAssertTrue(coordinatorSpy.presentDeleteAccountActionSheetCalled)
        XCTAssertNotNil(coordinatorSpy.handler)
    }

    func test_reauthenticateFor_whenMotiveIsUpdateUserInformation_shouldCallPushToProfileViewController() {
        sut = ReauthenticateViewModel(coordinator: coordinatorSpy,
                                      authService: authServiceSpy,
                                      motive: .updateUserInformation)
        sut.reauthenticate(with: "password")
        XCTAssertTrue(coordinatorSpy.pushToProfileViewControllerCalled)
    }
}
