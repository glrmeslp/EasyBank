import XCTest
import FirebaseFirestore
@testable import EasyBank

final class CompleteTransactionViewModelTests: XCTestCase {
    private let coordinatorSpy = PayCoordinatorSpy()
    private var transfer: Transfer {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy/MM/dd HH:mm"
        let date = formatter.date(from: "2021/11/04 09:25")!
        let transfer = Transfer(id: "123",
                                payDate: Timestamp(date: date),
                                value: 10,
                                receiverName: "Receiver",
                                payerName: "Payer")
        return transfer
    }
    private lazy var sut: CompleteTransactionViewModel = CompleteTransactionViewModel(transfer: transfer,
                                                                                      coordinator: coordinatorSpy)

    func test_fetchTransaction_shouldReturnTransfer() {
        sut.fetchTransaction { transfer in
            XCTAssertEqual("123", transfer.id)
            XCTAssertEqual(10.0, transfer.value)
        }
    }

    func test_didFinish_shouldCallPopToHomeViewController() {
        sut.didFinish()
        XCTAssertTrue(coordinatorSpy.popToHomeViewControllerCalled)
    }
}
