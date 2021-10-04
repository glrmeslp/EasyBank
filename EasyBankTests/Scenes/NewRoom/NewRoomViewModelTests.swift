import XCTest
import FirebaseAuth
@testable import EasyBank

final class NewRoomViewModelTests: XCTestCase {
    private let coordinatorSpy = StartCoordinatorSpy()
    private let authServiceSpy = AuthenticationServiceSpy()
    private let roomServiceSpy = DatabaseServiceSpy()
    private lazy var sut: NewRoomViewModel = NewRoomViewModel(coordinator: coordinatorSpy,
                                                              roomService: roomServiceSpy,
                                                              authService: authServiceSpy)

    func test_validateRoom_givenAnExistingRoom_shouldCallCoordinatorPresentAlert() {
        roomServiceSpy.roomExists = true
        sut.validateRoom(with: "Room")
        XCTAssertTrue(coordinatorSpy.presentAlertCalled)
        XCTAssertEqual("The room exists, please enter another room name", coordinatorSpy.messageAlert)
    }

    func test_createRoom_withError_shloudCallCoordinatorPresentAlert() {
        roomServiceSpy.roomExists = false
        roomServiceSpy.error = "Error!"
        sut.validateRoom(with: "Room")
        XCTAssertTrue(coordinatorSpy.presentAlertCalled)
        XCTAssertEqual("Error!", coordinatorSpy.messageAlert)
    }

//    func test_createAccount_withoutError_shouldCallCoordinatorPushToViewController() {
//        roomServiceSpy.roomExists = false
//        roomServiceSpy.error = nil
//        sut.user = User()
//        sut.validateRoom(with: "Room")
//        XCTAssertTrue(coordinatorSpy.pushToHomeViewControllerCalled)
//        XCTAssertEqual("Room", coordinatorSpy.roomName)
//    }
}
