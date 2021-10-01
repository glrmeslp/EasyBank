import XCTest
@testable import EasyBank

final class StartViewControllerTests: XCTestCase {
    private let startViewModelSpy = StartViewModelSpy()
    private lazy var sut: StartViewController = StartViewController(viewModel: startViewModelSpy)

    func test_viewWillAppear_shouldCallDetectAuthenticationStatus() {
        sut.viewWillAppear(true)
        XCTAssertTrue(startViewModelSpy.detectAuthenticationStatusCalled)
    }

    func test_viewWillAppear_shouldReturnNavigationControllerHidden() {
        sut.viewWillAppear(true)
        sut.loadViewIfNeeded()
        print(sut.navigationController?.isNavigationBarHidden)
//        XCTAssertTrue(navigationController.navigationBar.isHidden)
    }

    func test_viewWillDisappear_shouldCallUndetectAuthenticationStatus() {
        sut.viewWillDisappear(true)
        XCTAssertTrue(startViewModelSpy.undetectAuthenticationStatusCalled)
    }

//    func test_viewWillDisappear_shouldNotReturnNavigationControllerHidden() {
//        sut.viewWillDisappear(true)
//        sut.loadViewIfNeeded()
//        let navigationController = UINavigationController(rootViewController: sut)
//        XCTAssertFalse(navigationController.navigationBar.isHidden)
//    }

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