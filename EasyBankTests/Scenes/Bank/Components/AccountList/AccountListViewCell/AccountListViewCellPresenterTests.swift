@testable import EasyBank
import XCTest

final class AccountListViewCellSpy: AccountListViewCellDisplaying {
    enum Messages: Equatable {
        case display(name: String)
        case display(balance: String)
    }
    
    private(set) var messages: [Messages] = []
    
    func display(name: String) {
        messages.append(.display(name: name))
    }
    
    func display(balance: String) {
        messages.append(.display(balance: balance))
    }
}

final class AccountListViewCellPresenterTests: XCTestCase {
    private lazy var viewSpy = AccountListViewCellSpy()
    private lazy var sut: AccountListViewCellPresenter = {
        let sut = AccountListViewCellPresenter()
        sut.view = viewSpy
        return sut
    }()

    func testConfigureData_ShouldDisplayCorrectly() {
        let account = Account(balance: 10.0, userName: "UserName")
        
        sut.configure(data: account)
        
        XCTAssertEqual(viewSpy.messages, [.display(name: account.userName), .display(balance: account.balance.asCurrency() ?? "")])
    }
}
