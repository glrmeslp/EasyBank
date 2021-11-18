import XCTest
@testable import EasyBank

final class BankViewModelTests: XCTestCase {
    private let roomService = DatabaseServiceSpy()
    private lazy var sut: BankViewModel = {
        UserDefaults.standard.set("Room01", forKey: "Room")
        let viewModel = BankViewModel(roomService: roomService)
        return viewModel
    }()

    func test_fetchRoomName_shouldReturnCorrectRoomName() {
        sut.fetchRoomName { result in
            XCTAssertEqual("Room01", result)
        }
    }

    func test_fetchAccounts_shouldReturnTwoAccounts() {
        roomService.accountsToBeReturn = [Account(balance: 10.0, userName: "Guilherme"),
                                          Account(balance: 15.0, userName: "Keven")]
        sut.fetchAccounts { result in
            XCTAssertEqual(2, result.count)
        }
    }

    func test_fetchBankMenu_shouldReturnThreeMenus() {
        sut.fetchBankMenu { result in
            XCTAssertEqual(3, result.count)
        }
    }
}
