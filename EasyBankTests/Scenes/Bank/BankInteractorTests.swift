@testable import EasyBank
import XCTest

final class BankServiceSpy: BankServicing {
    private(set) var getAccountsCallsCount = 0
    var requestgetAccounts: Result<[Account], Error>?
    func getAccounts(roomName: String, completion: @escaping (Result<[Account], Error>) -> Void) {
        guard let completionResult = requestgetAccounts else { return }
        completion(completionResult)
        getAccountsCallsCount += 1
    }
}

final class BankPresenterSpy: BankPresenting {
    enum Messages: Equatable {
        case display(accounts: [Account])
    }
    
    private(set) var messages: [Messages] = []

    func display(accounts: [Account]) {
        messages.append(.display(accounts: accounts))
    }
}

final class BankInteractorTests: XCTestCase {
    private lazy var presenterSpy = BankPresenterSpy()
    private lazy var serviceSpy = BankServiceSpy()
    private lazy var sut = BankInteractor(service: serviceSpy,
                                          presenter: presenterSpy)

    func testLoadData_WhenDidCallSuccess_ShouldDisplayCorrectly() {
        let accounts = [Account(balance: 10.0, userName: "UserName")]
        serviceSpy.requestgetAccounts = .success(accounts)
        
        sut.loadData()
        
        XCTAssertEqual(serviceSpy.getAccountsCallsCount, 1)
        XCTAssertEqual(presenterSpy.messages, [.display(accounts: accounts)])
    }

    func testLoadData_WhenDidCallFailure_ShouldDisplayCorrectly() {
        serviceSpy.requestgetAccounts = .failure(NSError())
        
        sut.loadData()
        
        XCTAssertEqual(serviceSpy.getAccountsCallsCount, 1)
        XCTAssertEqual(presenterSpy.messages, [])
    }
}
