import XCTest
@testable import EasyBank

final class BankViewControllerTests: XCTestCase {
    private let viewModelSpy = BankViewModelSpy()
    private lazy var sut: BankViewController = BankViewController(viewModel: viewModelSpy)

    func test_viewDidLoad_shouldCallFetchData() {
        sut.viewDidLoad()
        XCTAssertTrue(viewModelSpy.fetchBankMenuCalled)
        XCTAssertTrue(viewModelSpy.fetchRoomNameCalled)
        XCTAssertTrue(viewModelSpy.fetchAccountsCalled)
    }

    func test_loadView_shouldReturnBankViewClass() {
        sut.loadView()
        let result = sut.view
        XCTAssertTrue(result is BankView)
    }
}
