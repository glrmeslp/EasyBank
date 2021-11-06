import XCTest
import FirebaseFirestore
@testable import EasyBank

final class ExtractViewModelTests: XCTestCase {
    private let databaseSpy = DatabaseServiceSpy()
    private let authServiceSpy = AuthenticationServiceSpy()
    private var formatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy/MM/dd HH:mm"
        return formatter
    }
    private lazy var sut: ExtractViewModel = ExtractViewModel(transferService: databaseSpy,
                                                              authService: authServiceSpy,
                                                              roomService: databaseSpy)

    func test_fetchBalance_shouldReturnBalanceAsCurrency() {
        authServiceSpy.user = User(identifier: "123", name: "Guilherme", email: "test@test.com")
        databaseSpy.rooms = ["Room": ["123": Account(balance: 10, userName: "Guilherme")]]
        sut.fetchBalance { balance in
            XCTAssertEqual(10.0.asCurrency(), balance)
        }
    }

    func test_configureDataExtract_givenTransferWhereUserIsPayer_shouldReturnExtractEnumTransferred() {
        let date = formatter.date(from: "2021/11/04 09:25")!
        authServiceSpy.user = User(identifier: "123", name: "Guilherme", email: "test@test.com")
        let transfer = Transfer(id: "123", payDate: Timestamp(date: date), value: 10, receiverName: "Receiver", payerName: "Guilherme")
        let result = sut.configureDataExtract(with: transfer)
        XCTAssertEqual(ExtractEnum.transferred, result.extractEnum)
        XCTAssertEqual("Receiver", result.name)
    }

    func test_configureDataExtract_givenTransferWhereUserIsReceiver_shouldReturnExtractEnumReceived() {
        let date = formatter.date(from: "2021/11/04 09:25")!
        authServiceSpy.user = User(identifier: "123", name: "Guilherme", email: "test@test.com")
        let transfer = Transfer(id: "123", payDate: Timestamp(date: date), value: 10, receiverName: "Guilherme", payerName: "Payer")
        let result = sut.configureDataExtract(with: transfer)
        XCTAssertEqual(ExtractEnum.received, result.extractEnum)
        XCTAssertEqual("Payer", result.name)
    }

    func test_fetchAllTransfers_shouldReturnTranfersSorted() {
        let date1 = formatter.date(from: "2021/11/04 09:25")!
        let date2 = formatter.date(from: "2021/11/04 09:26")!
        authServiceSpy.user = User(identifier: "123", name: "Guilherme", email: "test@test.com")
        databaseSpy.transfersToBeReturn = [Transfer(id: "123", payDate: Timestamp(date: date1), value: 10, receiverName: "Receiver", payerName: "Guilherme"),
        Transfer(id: "123", payDate: Timestamp(date: date2), value: 10, receiverName: "Guilherme", payerName: "Payer")]
        sut.fetchAllTransfers { transfers in
            XCTAssertEqual(transfers[0].payerName, "Payer")
            XCTAssertEqual(transfers[1].payerName, "Guilherme")
        }
    }
}
