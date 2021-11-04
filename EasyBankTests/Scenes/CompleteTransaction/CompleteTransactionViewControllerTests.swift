import XCTest
import FirebaseFirestore

@testable import EasyBank

final class CompleteTransactionViewControllerTests: XCTestCase {
    private let viewModelSpy = CompleteTransactionViewModelSpy()
    private lazy var sut: CompleteTransactionViewController = CompleteTransactionViewController(viewModel: viewModelSpy)

    func test_fetchData_shouldReturnTransfer() {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy/MM/dd HH:mm"
        guard let date = formatter.date(from: "2021/11/04 09:25") else {
            XCTFail("Date is nil")
            return
        }
        viewModelSpy.transferToBeReturn = Transfer(id: "123",
                                                   payDate: Timestamp(date: date),
                                                   value: 10,
                                                   receiverName: "Receiver",
                                                   payerName: "Payer")
        sut.loadViewIfNeeded()
        sut.viewDidLoad()
        let sutMirrored = CompleteTransactionViewControllerMirror(viewController: sut)
        XCTAssertEqual("123", sutMirrored.transactionIDLabel?.text)
        XCTAssertEqual("2021-11-04", sutMirrored.payDayLabel?.text)
        XCTAssertEqual("13:25:00", sutMirrored.hourLabel?.text)
        XCTAssertEqual("Receiver", sutMirrored.receiverNameLabel?.text)
        XCTAssertEqual("Payer", sutMirrored.payerNameLabel?.text)
    }

    func test_didTapHomeButton_shouldCallDidFinish() {
        sut.loadViewIfNeeded()
        let sutMirrored = CompleteTransactionViewControllerMirror(viewController: sut)
        sutMirrored.homeButton?.sendActions(for: .touchUpInside)
        XCTAssertTrue(viewModelSpy.didFinishCalled)
    }
}
