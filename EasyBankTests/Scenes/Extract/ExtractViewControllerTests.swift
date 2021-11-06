import XCTest
import FirebaseFirestore
@testable import EasyBank

final class ExtractViewControllerTests: XCTestCase {
    private let viewModelSpy = ExtractViewModelSpy()
    private var formatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy/MM/dd HH:mm"
        return formatter
    }
    private lazy var sut: ExtractViewController = ExtractViewController(viewModel: viewModelSpy)

    func test_numberOfRowsInSection_givenTwoTransfers_shouldReturnTwo() {
        let date1 = formatter.date(from: "2021/11/04 09:25")!
        let date2 = formatter.date(from: "2021/11/04 09:26")!
        viewModelSpy.transfersToBeReturn = [Transfer(id: "123", payDate: Timestamp(date: date1), value: 10, receiverName: "Receiver", payerName: "Guilherme"),
        Transfer(id: "123", payDate: Timestamp(date: date2), value: 10, receiverName: "Guilherme", payerName: "Payer")]
        sut.loadViewIfNeeded()
        sut.viewDidLoad()
        let result = sut.tableView(UITableView(), numberOfRowsInSection: 0)
        XCTAssertEqual(2, result)
    }

    func test_numberOfRowsInSection_givenNoTransfer_shouldReturnZero() {
        sut.loadViewIfNeeded()
        sut.viewDidLoad()
        let result = sut.tableView(UITableView(), numberOfRowsInSection: 0)
        XCTAssertEqual(0, result)
    }

    func test_viewDidLoad_shouldSetupTitle() {
        sut.loadViewIfNeeded()
        sut.viewDidLoad()
        XCTAssertEqual("Extract", sut.title)
    }

    func test_didTapShowBalanceButton_whenBalanceLabelIsHidden_shouldCallFetchBalance() {
        viewModelSpy.balanceToBeReturn = 10.0.asCurrency()
        sut.loadViewIfNeeded()
        let sutMirrored = ExtractViewControllerMirror(viewController: sut)
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
        XCTAssertEqual(10.0.asCurrency(), balanceLabel.text)
    }

    func test_didTapShowBalanceButton_whenBalanceLabelIsNotHidden_shouldCallHideBalanceValue() {
        viewModelSpy.balanceToBeReturn = 10.0.asCurrency()
        sut.loadViewIfNeeded()
        let sutMirrored = ExtractViewControllerMirror(viewController: sut)
        sutMirrored.showBalanceButton?.sendActions(for: .touchUpInside)
        sutMirrored.showBalanceButton?.sendActions(for: .touchUpInside)
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
}

