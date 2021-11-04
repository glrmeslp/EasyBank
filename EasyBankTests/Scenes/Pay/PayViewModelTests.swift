import XCTest
import FirebaseFirestore
@testable import EasyBank

final class PayViewModelTests: XCTestCase {
    private let databaseSpy = DatabaseServiceSpy()
    private let coordinatorSpy = PayCoordinatorSpy()
    private let authServiceSpy = AuthenticationServiceSpy()
    private lazy var sut: PayViewModel = PayViewModel(data: ["10.0","124","UserName"],
                                                      roomName: "Room",
                                                      authService: authServiceSpy,
                                                      roomService: databaseSpy,
                                                      transferService: databaseSpy,
                                                      coordinator: coordinatorSpy)

    func test_fetchBalance_shouldReturnBalanceAccount() {
        authServiceSpy.user = User(identifier: "123", name: "Guilherme", email: "test@test.com")
        databaseSpy.rooms = ["Room": ["123": Account(balance: 10, userName: "Guilherme")]]
        sut.fetchBalance { balance in
            XCTAssertEqual(10.0.asCurrency(), balance)
        }
    }

    func test_fetchData_shouldReturnReceiverNameAndValue() {
        sut.fetchData { name, value in
            XCTAssertEqual(name, "UserName")
            XCTAssertEqual(value, 10)
        }
    }

    func test_transfer_withError_shouldCallPresentAlert() {
        databaseSpy.transferErrorToBeReturn = NSError(domain: "AppErrorDomain", code: -1,
                                                      userInfo: [NSLocalizedDescriptionKey: "Error"])
        authServiceSpy.user = User(identifier: "123", name: "Guilherme", email: "test@test.com")
        sut.transfer(value: 10.0.asCurrency() ?? "") { _ in }
        XCTAssertTrue(coordinatorSpy.presentAlertCalled)
        XCTAssertEqual("Error", coordinatorSpy.messageReturned)
        XCTAssertNotNil(coordinatorSpy.handlerReturned)
    }

    func test_transfer_withoutError_shouldCallPushToCompleteTransaction() {
        authServiceSpy.user = User(identifier: "123", name: "Guilherme", email: "test@test.com")
        databaseSpy.transferToBeReturn = Transfer(id: "123", payDate: Timestamp(date: Date()), value: 10, receiverName: "", payerName: "")
        sut.transfer(value: 10.0.asCurrency() ?? "") { _ in }
        XCTAssertTrue(databaseSpy.transferCalled)
        XCTAssertTrue(coordinatorSpy.pushToCompleteTransactionCalled)
    }

    func test_presentConfirmAlert_shouldCallCoodinatorPresentConfirmAlert() {
        sut.presentConfirmAlert { _ in }
        XCTAssertTrue(coordinatorSpy.presentConfirmAlertCalled)
        XCTAssertNotNil(coordinatorSpy.handlerReturned)
    }
}
