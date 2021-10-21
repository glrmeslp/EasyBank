import XCTest
@testable import EasyBank

final class AccountViewModelTests: XCTestCase {
    private let authServiceSpy = AuthenticationServiceSpy()
    private let roomServiceSpy = DatabaseServiceSpy()
    private let coordinatorSpy = AccountCoordinatorSpy()
    private lazy var sut: AccountViewModel = AccountViewModel(roomName: "Room",
                                                              authService: authServiceSpy,
                                                              roomService: roomServiceSpy,
                                                              coordinator: coordinatorSpy)

    func test_presentLeaveRoomActionSheet_shouldCallCoordinatorPresentLeaveRoomActionSheet() {
        sut.presentLeaveRoomActionSheet()
        XCTAssertTrue(coordinatorSpy.presentLeaveRoomActionSheetCalled)
    }

    func test_presentDeleteAccountActionSheet_shouldCallCoordinatorPresentDeleteAccountActionSheet() {
        sut.presentDeleteAccountActionSheet()
        XCTAssertTrue(coordinatorSpy.presentDeleteAccountActionSheetCalled)
        XCTAssertNotNil(coordinatorSpy.handler)
    }

    func test_presentUpdateNameActionSheet_shouldCallCoordinatorPresentUpdateNameActionSheet() {
        sut.presentUpdateNameActionSheet { _ in }
        XCTAssertTrue(coordinatorSpy.presentUpdateNameActionSheetCalled)
        XCTAssertNotNil(coordinatorSpy.handler)
    }

    func test_presentUpdateEmailActionSheet_shouldCallCoordinatorPresentUpdateEmailActionSheet() {
        sut.presentUpdateEmailActionSheet { _ in }
        XCTAssertTrue(coordinatorSpy.presentUpdateEmailActionSheetCalled)
        XCTAssertNotNil(coordinatorSpy.handler)
    }

    func test_deleteEasyBankAccount_shouldCallCoordinatorPresentReauthenticateViewController() {
        sut.deleteEasyBankAccount()
        XCTAssertTrue(coordinatorSpy.presentReauthenticateViewControllerCalled)
        XCTAssertEqual(Reautheticate.deleteUser, coordinatorSpy.motive)
    }

    func test_manageProfileInformation_shouldCallCoordinatorPresentReauthenticateViewController() {
        sut.manageProfileInformation()
        XCTAssertTrue(coordinatorSpy.presentReauthenticateViewControllerCalled)
        XCTAssertEqual(Reautheticate.updateUserInformation, coordinatorSpy.motive)
    }

    func test_fecthData_shouldReturnRoomNameAndUser() {
        authServiceSpy.user = User(identifier: "", name: "Guilherme", email: "guilherme@test.com")
        sut.fetchData { roomName, user in
            XCTAssertEqual("Room", roomName)
            XCTAssertEqual("Guilherme", user?.name)
            XCTAssertEqual("guilherme@test.com", user?.email)
        }
    }
}
