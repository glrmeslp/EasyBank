import XCTest
@testable import EasyBank

final class HomeMenuViewControllerTests: XCTestCase {
    private let viewModelSpy = HomeMenuViewModelSpy()
    private lazy var sut: HomeMenuViewController = HomeMenuViewController(viewModel: viewModelSpy)

    func test_didTapPasswordButton_shouldCallUpdatePassword() {
        sut.loadViewIfNeeded()
        let sutMirrored = HomeMenuViewControllerMirror(viewController: sut)
        sutMirrored.passwordButton?.sendActions(for: .touchUpInside)
        XCTAssertTrue(viewModelSpy.updatePasswordCalled)
    }

    func test_didTapAccountButton_shouldCallShowAccount() {
        sut.loadViewIfNeeded()
        let sutMirrored = HomeMenuViewControllerMirror(viewController: sut)
        sutMirrored.accountButton?.sendActions(for: .touchUpInside)
        XCTAssertTrue(viewModelSpy.showAccountCalled)
    }
}
