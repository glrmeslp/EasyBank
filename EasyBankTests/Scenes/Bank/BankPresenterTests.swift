@testable import EasyBank
import XCTest

final class BankViewControllerSpy: BankDisplaying {
    enum Messages: Equatable {
        case display(accounts: [Account])
    }
    
    private(set) var messages: [Messages] = []
    
    func display(accounts: [Account]) {
        messages.append(.display(accounts: accounts))
    }
}

final class BankCoordinatorSpy: BankCoordinating { }

final class BankPresenterTests: XCTestCase {
    private lazy var viewControllerSpy = BankViewControllerSpy()
    private lazy var coordinatorSpy = BankCoordinatorSpy()
    private lazy var sut: BankPresenter = {
        let sut = BankPresenter(coordinator: coordinatorSpy)
        sut.viewController = viewControllerSpy
        return sut
    }()

    func testDisplayAccounts_ShouldDisplayCorrectly() {
        let accounts = [Account(balance: 10.0, userName: "UserName")]
    
        sut.display(accounts: accounts)
        
        XCTAssertEqual(viewControllerSpy.messages, [.display(accounts: accounts)])
    }
}
