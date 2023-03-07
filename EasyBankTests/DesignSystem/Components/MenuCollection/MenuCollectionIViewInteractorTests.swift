@testable import EasyBank
import XCTest

final class MenuCollectionViewSpy: MenuCollectionViewDisplaying {
    enum Messages: Equatable {
        case display(items: [MenuCollectionItem])
    }
    
    private(set) var messages: [Messages] = []
    
    func display(items: [MenuCollectionItem]) {
        messages.append(.display(items: items))
    }
}

final class MenuCollectionIViewInteractorTests: XCTestCase {
    let viewSpy = MenuCollectionViewSpy()
    private lazy var sut: MenuCollectionViewInteractor = {
        let sut = MenuCollectionViewInteractor()
        sut.view = viewSpy
        return sut
    }()

    func testConfigureItems_ShouldDisplayCorrectly() {
        let items = [MenuCollectionItem.mock(icon: .pay, title: "Pay")]
        
        sut.configure(items: items)
        
        XCTAssertEqual(viewSpy.messages, [.display(items: items)])
    }
}
