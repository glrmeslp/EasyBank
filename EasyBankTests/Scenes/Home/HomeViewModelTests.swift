import XCTest
@testable import EasyBank

final class HomeViewModelTests: XCTestCase {
    private let roomServiceSpy = DatabaseServiceSpy()
    private let authServiceSpy = AuthenticationServiceSpy()
    private let coordinatorSpy = HomeCoordinatorSpy()
    private lazy var sut: HomeViewModel = HomeViewModel(with: "Room",
                                                        roomService: roomServiceSpy,
                                                        authService: authServiceSpy,
                                                        coordinator: coordinatorSpy)

    func test_showReceiveViewController_shouldCallPushToReceiveViewController() {
        sut.showReceiveViewController()
        XCTAssertTrue(coordinatorSpy.pushToReceiveViewControllerCalled)
    }

    func test_showPayViewController_shouldCallPushToScannerViewController() {
        sut.showPayViewController()
        XCTAssertTrue(coordinatorSpy.pushToScannerViewControllerCalled)
    }

    func test_showHomeMenuViewController_shouldCallPresentHomeMenuViewController() {
        sut.showHomeMenuViewController()
        XCTAssertTrue(coordinatorSpy.presentHomeMenuViewControllerCalled)
    }

    func test_showExtractViewController_shouldCallPushToExtractViewController() {
        sut.showExtractViewController()
        XCTAssertTrue(coordinatorSpy.pushToExtractViewControllerCalled)
    }

    func test_fetchBalance_shouldReturnBalanceAccount() {
        authServiceSpy.user = User(identifier: "123", name: "Guilherme", email: "test@test.com")
        roomServiceSpy.rooms = ["Room": ["123": Account(balance: 10, userName: "Guilherme")]]
        sut.fetchBalance { balance in
            XCTAssertEqual("¤10.00", balance)
        }
    }

    func test_fetchInformation_shouldReturnTransferMenuAndRoomName() {
        sut.fetchInformation { trasferMenu, roomName in
            XCTAssertEqual([["Pay QR Code","qrcode"],["Receive","ReceiveIcon"]], trasferMenu)
            XCTAssertEqual("Room", roomName)
        }
    }

    func test_fetchUserName_shouldReturnUserName() {
        authServiceSpy.user = User(identifier: "123", name: "Guilherme", email: "test@test.com")
        sut.fetchUserName { name in
            XCTAssertEqual("Guilherme", name)
        }
    }
}
