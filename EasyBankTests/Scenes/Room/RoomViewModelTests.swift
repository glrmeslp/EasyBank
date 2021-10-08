import XCTest
@testable import EasyBank

final class RoomViewModelTests: XCTestCase {
    private let coordinatorSpy = StartCoordinatorSpy()
    private let roomServiceSpy = DatabaseServiceSpy()
    private let authServiceSpy = AuthenticationServiceSpy()
    private lazy var sut: RoomViewModel = RoomViewModel(coordinator: coordinatorSpy,
                                                        roomService: roomServiceSpy,
                                                        authService: authServiceSpy)

    func test_enter_givenANonExistentRoom_shouldCallPresentAlert() {
        sut.enter("Room")
        XCTAssertTrue(coordinatorSpy.presentAlertCalled)
        XCTAssertEqual("This room does not exist", coordinatorSpy.messageAlert)
    }

    func test_userHasAnAccountInThis_whenThereIsAccount_shouldCallpresentAlertAndPushToHome() {
        authServiceSpy.user = User(identifier: "123", name: "UserName", email: "user@test.com")
        roomServiceSpy.rooms = ["Room": ["123": Account(balance: 0, userName: "UserName")]]
        sut.enter("Room")
        XCTAssertTrue(coordinatorSpy.presentAlertAndPushToHomeCalled)
        XCTAssertEqual("You already have an account in this room. A new account will not be created", coordinatorSpy.messageAlert)
    }

    func test_createAccountInThe_withoutError_shouldCallPresentAlertAndPushToHome() {
        authServiceSpy.user = User(identifier: "123", name: "UserName", email: "user@test.com")
        roomServiceSpy.rooms = ["Room": [:]]
        sut.enter("Room")
        XCTAssertTrue(coordinatorSpy.presentAlertAndPushToHomeCalled)
        XCTAssertEqual("You don't have an account in the room yet. A new account will be created", coordinatorSpy.messageAlert)
        XCTAssertEqual("Room", coordinatorSpy.roomName)
    }

    func test_createAccountInThe_withError_shouldCallPresentAlert() {
        authServiceSpy.user = User(identifier: "123", name: "UserName", email: "user@test.com")
        roomServiceSpy.rooms = ["Room": [:]]
        roomServiceSpy.createAccountError = "Error!"
        sut.enter("Room")
        XCTAssertTrue(coordinatorSpy.presentAlertCalled)
        XCTAssertEqual("Error!", coordinatorSpy.messageAlert)
    }
}
