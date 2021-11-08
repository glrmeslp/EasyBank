import XCTest
@testable import EasyBank

final class ProfileViewControllerTests: XCTestCase {
    private let viewModelSpy = ProfileViewModelSpy()
    private lazy var sut: ProfileViewController = ProfileViewController(viewModel: viewModelSpy)

    func test_viewDidLoad_shouldReturnProfileTitle() {
        sut.viewDidLoad()
        XCTAssertEqual("Profile", sut.title)
    }

    func test_viewDidLoad_shouldCallFetchDataAndReturnUser() {
        viewModelSpy.userToBeReturn = User(identifier: "", name: "Guilherme", email: "test@test.com")
        sut.loadViewIfNeeded()
        sut.viewDidLoad()
        let sutMirrored = ProfileViewControllerMirror(viewController: sut)
        XCTAssertTrue(viewModelSpy.fetchDataCalled)
        XCTAssertEqual("Guilherme", sutMirrored.nameTextField?.text)
        XCTAssertEqual("test@test.com", sutMirrored.emailAddressTextfield?.text)
    }

    func test_didTapUpdateNameButton_shouldCallUpdateDispleyName() {
        viewModelSpy.userToBeReturn = User(identifier: "", name: "Guilherme", email: "test@test.com")
        sut.loadViewIfNeeded()
        sut.viewDidLoad()
        let sutMirrored = ProfileViewControllerMirror(viewController: sut)
        sutMirrored.updateNameButton?.sendActions(for: .touchUpInside)
        XCTAssertTrue(viewModelSpy.updateDispleyNameCalled)
        XCTAssertEqual("Guilherme", viewModelSpy.nameReturned)
    }

    func test_didTapUpdateEmailButton_shouldCallUpdateEmailAddress() {
        viewModelSpy.userToBeReturn = User(identifier: "", name: "Guilherme", email: "test@test.com")
        sut.loadViewIfNeeded()
        sut.viewDidLoad()
        let sutMirrored = ProfileViewControllerMirror(viewController: sut)
        sutMirrored.updateEmailButton?.sendActions(for: .touchUpInside)
        XCTAssertTrue(viewModelSpy.updateEmailAddressCalled)
        XCTAssertEqual("test@test.com", viewModelSpy.emailReturned)
    }
}
