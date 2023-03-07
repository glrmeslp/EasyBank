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
        case display(roomName: String)
        case display(items: [MenuCollectionItem])
    }
    
    private(set) var messages: [Messages] = []

    func display(accounts: [Account]) {
        messages.append(.display(accounts: accounts))
    }

    func display(roomName: String) {
        messages.append(.display(roomName: roomName))
    }
    
    func display(items: [MenuCollectionItem]) {
        messages.append(.display(items: items))
    }
    
    func presentDeleteRoomActionSheet(with handler: @escaping ((UIAlertAction) -> Void)) { }
    
    func openBankPayScreen() { }
    
    func openBankChargeScreen() { }
}

final class BankInteractorTests: XCTestCase {
    private lazy var presenterSpy = BankPresenterSpy()
    private lazy var serviceSpy = BankServiceSpy()
    private lazy var sut = BankInteractor(service: serviceSpy,
                                          presenter: presenterSpy)

    func testLoadData_WhenDidCallSuccess_ShouldDisplayCorrectly() {
        let accounts = [Account(balance: 10.0, userName: "UserName")]
        let roomName = "RoomTest"
        UserDefaults.standard.set(roomName, forKey: "Room")
        let items = [MenuCollectionItem.mock(icon: .pay, title: "Pay"),
                     MenuCollectionItem.mock(icon: .charge, title: "Charge"),
                     MenuCollectionItem.mock(icon: .room, title: "Delete Room")]
        serviceSpy.requestgetAccounts = .success(accounts)
        
        sut.loadData()
        
        XCTAssertEqual(serviceSpy.getAccountsCallsCount, 1)
        XCTAssertEqual(presenterSpy.messages, [.display(roomName: roomName),
                                               .display(accounts: accounts),
                                               .display(items: items)])
    }

    func testLoadData_WhenDidCallFailure_ShouldDisplayCorrectly() {
        let roomName = "RoomTest"
        UserDefaults.standard.set(roomName, forKey: "Room")
        let items = [MenuCollectionItem.mock(icon: .pay, title: "Pay"),
                     MenuCollectionItem.mock(icon: .charge, title: "Charge"),
                     MenuCollectionItem.mock(icon: .room, title: "Delete Room")]
        serviceSpy.requestgetAccounts = .failure(NSError())
        
        sut.loadData()
        
        XCTAssertEqual(serviceSpy.getAccountsCallsCount, 1)
        XCTAssertEqual(presenterSpy.messages, [.display(roomName: roomName),
                                               .display(items: items)])
    }
}
