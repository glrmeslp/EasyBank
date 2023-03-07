@testable import EasyBank
import XCTest

final class BankViewControllerSpy: BankDisplaying {
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
}

final class BankCoordinatorSpy: BankCoordinating {
    enum Messages: Equatable {
        case openBankPayScreen
        case openBankChargeScreen
        case presentDeleteRoomActionSheet
    }
    
    private(set) var messages: [Messages] = []
    
    func openBankPayScreen() {
        messages.append(.openBankPayScreen)
    }
    
    func openBankChargeScreen() {
        messages.append(.openBankChargeScreen)
    }
    
    func presentDeleteRoomActionSheet(with handler: @escaping ((UIAlertAction) -> Void)) {
        messages.append(.presentDeleteRoomActionSheet)
    }
}

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

    func testDisplayRoomName_ShouldDisplayCorrectly() {
        let roomName = "Room01"
        
        sut.display(roomName: roomName)
        
        XCTAssertEqual(viewControllerSpy.messages, [.display(roomName: roomName)])
    }

    func testDisplayItems_ShouldDisplayCorrectly() {
        let items = [MenuCollectionItem(icon: .pay, title: "Pay", action: { })]
        
        sut.display(items: items)
        
        XCTAssertEqual(viewControllerSpy.messages, [.display(items: items)])
    }

    func testOpenBankPayScreen_ShouldCallOpenBankPayScreen() {
        sut.openBankPayScreen()
        
        XCTAssertEqual(coordinatorSpy.messages, [.openBankPayScreen])
    }

    func testOpenBankChargeScreen_ShouldCallOpenBankChargeScreen() {
        sut.openBankChargeScreen()
        
        XCTAssertEqual(coordinatorSpy.messages, [.openBankChargeScreen])
    }
    
    func testPresentDeleteRoomActionSheet_ShouldCallPresentDeleteRoomActionSheet() {
        sut.presentDeleteRoomActionSheet(with: { _ in })
        
        XCTAssertEqual(coordinatorSpy.messages, [.presentDeleteRoomActionSheet])
    }
}
