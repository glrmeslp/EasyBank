import XCTest
@testable import EasyBank

final class HomeViewControllerTests: XCTestCase {
    private let homeViewModelSpy = HomeViewModelSpy()
    private lazy var sut: HomeViewController = HomeViewController(viewModel: homeViewModelSpy)

    func test_numberOfItemsInSection_shouldReturnZero() {
        let result = sut.collectionView(UICollectionView(frame: CGRect.zero,
                                                         collectionViewLayout: UICollectionViewFlowLayout.init()),
                                                         numberOfItemsInSection: 0)
        XCTAssertEqual(0, result)
    }

    func test_numberOfItemsInSection_fetchingInformation_shouldReturnTwo() {
        homeViewModelSpy.roomName = "RoomTest"
        sut.loadViewIfNeeded()
        sut.viewDidLoad()
        let result = sut.collectionView(UICollectionView(frame: CGRect.zero,
                                                         collectionViewLayout: UICollectionViewFlowLayout.init()),
                                                         numberOfItemsInSection: 0)
        XCTAssertEqual(2, result)
    }

    func test_didSelectItemAt_givenIndexPathZero_shouldCallShowPayViewController() {
        homeViewModelSpy.roomName = "RoomTest"
        sut.loadViewIfNeeded()
        sut.viewDidLoad()
        let sutMirrored = HomeViewControllerMirror(viewController: sut)
        guard let collectionView = sutMirrored.menuTransferCollection else {
            XCTFail("Menu Transfer Collection is nil")
            return
        }
        sut.collectionView(collectionView, didSelectItemAt: IndexPath(row: 0, section: 0))
        XCTAssertTrue(homeViewModelSpy.showPayViewControllerCalled)
    }

    func test_cellForItemAt_givenIndexPathZero_shouldReturnHomeCollectionViewCell() {
        homeViewModelSpy.roomName = "Room"
        sut.loadViewIfNeeded()
        sut.viewDidLoad()
        let sutMirrored = HomeViewControllerMirror(viewController: sut)
        guard let collectionView = sutMirrored.menuTransferCollection else {
            XCTFail("Menu Transfer Collection is nil")
            return
        }
        let result = sut.collectionView(collectionView, cellForItemAt: IndexPath(row: 0, section: 0))
        let homeCollectionviewCell = HomeCollectionViewCellMirror(collectionViewCell: result)
        XCTAssertEqual("Pay QR Code", homeCollectionviewCell.titleLabel?.text)
        XCTAssertEqual(20, result.layer.cornerRadius)
        XCTAssertEqual(1, result.layer.borderWidth)
    }

    func test_didSelectItemAt_givenIndexPathOne_shouldCallShowReceiveViewController() {
        homeViewModelSpy.roomName = "RoomTest"
        sut.loadViewIfNeeded()
        sut.viewDidLoad()
        let sutMirrored = HomeViewControllerMirror(viewController: sut)
        guard let collectionView = sutMirrored.menuTransferCollection else {
            XCTFail("Menu Transfer Collection is nil")
            return
        }
        sut.collectionView(collectionView, didSelectItemAt: IndexPath(row: 1, section: 0))
        XCTAssertTrue(homeViewModelSpy.showReceiveViewControlleCalled)
    }

    func test_viewDidLoad_shouldCallFetchInformation() {
        homeViewModelSpy.roomName = "Room"
        sut.loadViewIfNeeded()
        sut.viewDidLoad()
        let sutMirrored = HomeViewControllerMirror(viewController: sut)
        XCTAssertTrue(homeViewModelSpy.fetchInformationCalled)
        XCTAssertEqual("Room", sutMirrored.roomNameLabel?.text)
    }

    func test_viewWillAppear_shouldCallFetchUserName() {
        homeViewModelSpy.fecthUserNameToBeReturned = "Guilherme Peixoto"
        sut.loadViewIfNeeded()
        sut.viewWillAppear(true)
        let sutMirrored = HomeViewControllerMirror(viewController: sut)
        XCTAssertTrue(homeViewModelSpy.fecthUserNameCalled)
        XCTAssertEqual("Guilherme Peixoto", sutMirrored.userNameLabel?.text)
    }

    func test_viewWillAppear_shouldReturnBalanceValueHidden() {
        homeViewModelSpy.roomName = "RoomTest"
        sut.loadViewIfNeeded()
        sut.viewWillAppear(false)
        let sutMirrored = HomeViewControllerMirror(viewController: sut)
        guard let balanceLabel = sutMirrored.balanceLabel else {
            XCTFail("Balance Label is nil")
            return
        }
        guard let showBalanceButton = sutMirrored.showBalanceButton else {
            XCTFail("Show balance button is nil")
            return
        }
        XCTAssertEqual(UIImage(systemName: "eye.slash.fill"), showBalanceButton.image(for: .normal))
        XCTAssertEqual("•••••", balanceLabel.text)
    }

    func test_didTapShowBalanceButton_whenBalanceLabelIsHidden_shouldCallFetchBalance() {
        homeViewModelSpy.roomName = "RoomTest"
        homeViewModelSpy.fetchBalanceToBeReturned = 10
        sut.loadViewIfNeeded()
        sut.viewWillAppear(false)
        let sutMirrored = HomeViewControllerMirror(viewController: sut)
        sutMirrored.showBalanceButton?.sendActions(for: .touchUpInside)
        guard let balanceLabel = sutMirrored.balanceLabel else {
            XCTFail("Balance Label is nil")
            return
        }
        guard let showBalanceButton = sutMirrored.showBalanceButton else {
            XCTFail("Show balance button is nil")
            return
        }
        XCTAssertEqual(UIImage(systemName: "eye.fill"), showBalanceButton.image(for: .normal))
        XCTAssertTrue(homeViewModelSpy.fetchBalanceCalled)
        XCTAssertEqual(10.0.asCurrency(), balanceLabel.text)
    }

    func test_didTapExtractButton_shouldCallShowExtractViewController() {
        sut.loadViewIfNeeded()
        let sutMirrored = HomeViewControllerMirror(viewController: sut)
        sutMirrored.seeExtractButton?.sendActions(for: .touchUpInside)
        XCTAssertTrue(homeViewModelSpy.showExtractViewControllerCalled)
    }
}
