import XCTest
@testable import EasyBank

final class ProfileViewModelTests: XCTestCase {
    private let authServiceSpy = AuthenticationServiceSpy()
    private let coordinatorSpy = AccountCoordinatorSpy()
    private lazy var sut: ProfileViewModel = ProfileViewModel(coordinator: coordinatorSpy,
                                                              authService: authServiceSpy)

    func test_fetchData_shouldReturnUser() {
        authServiceSpy.user = User(identifier: "", name: "Guilherme", email: "test@test.com")
        sut.fetchData { user in
            XCTAssertEqual("Guilherme", user.name)
            XCTAssertEqual("test@test.com", user.email)
        }
    }

    func test_updateDispleyName_whenUpdateNameErrorReturn_shouldCallPresentAlertWithErrorMessage() {
        authServiceSpy.updateNameErrorToBeReturn = "Error!"
        sut.updateDispleyName("Guilherme")
        XCTAssertTrue(coordinatorSpy.presentAlertCalled)
        XCTAssertEqual("Error!", coordinatorSpy.message)
    }

    func test_updateDispleyName_whenUpdateNameErrorDontReturn_shouldCallPresentAlertWithSuccessMessage() {
        sut.updateDispleyName("Guilherme")
        XCTAssertTrue(coordinatorSpy.presentAlertCalled)
        XCTAssertEqual("Your name has been updated successfully", coordinatorSpy.message)
    }

    func test_updateEmailAddress_whenUpdateEmailErrorReturn_shouldCallPresentAlertWithErrorMessage() {
        authServiceSpy.updateEmailErrorToBeReturn = "Error!"
        sut.updateEmailAddress("test@test.com")
        XCTAssertTrue(coordinatorSpy.presentAlertCalled)
        XCTAssertEqual("Error!", coordinatorSpy.message)
    }

    func test_updateEmailAddress_whenUpdateEmailErrorDontReturn_shouldCallPresentAlertWithSuccessMessage() {
        sut.updateEmailAddress("test@test.com")
        XCTAssertTrue(coordinatorSpy.presentAlertCalled)
        XCTAssertEqual("Your email address has been updated successfully", coordinatorSpy.message)
    }
}
