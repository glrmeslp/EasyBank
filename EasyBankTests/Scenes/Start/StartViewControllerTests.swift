import XCTest
@testable import EasyBank

final class StartViewControllerTests: XCTestCase {
    private let startViewModelSpy = StartViewModelSpy()
    private lazy var sut: StartViewController = StartViewController(viewModel: startViewModelSpy)

    func test_viewWillAppear_shouldCallDetectAuthenticationStatus() {
        sut.viewWillAppear(false)
        XCTAssertTrue(startViewModelSpy.detectAuthenticationStatusCalled)
    }

    func test_viewWillAppear_shouldReturnNavigationControllerHidden() {
        let navigationController =  UINavigationController(rootViewController: sut)
        sut.viewWillAppear(false)
        XCTAssertTrue(navigationController.isNavigationBarHidden)
    }

    func test_viewWillDisappear_shouldCallUndetectAuthenticationStatus() {
        sut.viewWillDisappear(false)
        XCTAssertTrue(startViewModelSpy.undetectAuthenticationStatusCalled)
    }

    func test_viewWillDisappear_shouldNotReturnNavigationControllerHidden() {
        let navigationController = UINavigationController(rootViewController: sut)
        sut.viewWillDisappear(false)
        XCTAssertFalse(navigationController.isNavigationBarHidden)
    }

    func test_didTapCreateButton_shouldCallShowNewRoomViewController() {
        sut.loadViewIfNeeded()
        let sutMirrored = StartViewControllerMirror(viewController: sut)
        sutMirrored.createButton?.sendActions(for: .touchUpInside)
        XCTAssertTrue(startViewModelSpy.showNewRoomViewControllerCalled)
    }

    func test_didTapJoinButton_shouldCallShowRoomViewController() {
        sut.loadViewIfNeeded()
        let sutMirrored = StartViewControllerMirror(viewController: sut)
        sutMirrored.joinButton?.sendActions(for: .touchUpInside)
        XCTAssertTrue(startViewModelSpy.showRoomViewControllerCalled)
    }
}
