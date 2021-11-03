
import XCTest
@testable import EasyBank

final class PayViewControllerTests: XCTestCase {
    private let viewModelSpy = PayViewModelSpy()
    private lazy var sut: PayViewController = PayViewController(viewModel: viewModelSpy)

    func test_fetchData_givenValueGreaterThanZero_shouldCallShowValueLabel() {
        let value = 10.0
        viewModelSpy.receiverNameToBeReturn = "Guilherme"
        viewModelSpy.valueToBeReturn = value
        sut.loadViewIfNeeded()
        sut.viewDidLoad()
        let sutMirrored = PayViewControllerMirror(viewController: sut)
        XCTAssertFalse(sutMirrored.valueLabel?.isHidden ?? true)
        XCTAssertEqual(value.asCurrency(), sutMirrored.valueLabel?.text)
    }

    func test_fetchData_givenValueEqualToZero_shouldCallShowValueTextField() {
        let value = 0.0
        viewModelSpy.receiverNameToBeReturn = "Guilherme"
        viewModelSpy.valueToBeReturn = value
        sut.loadViewIfNeeded()
        sut.viewDidLoad()
        let sutMirrored = PayViewControllerMirror(viewController: sut)
        XCTAssertFalse(sutMirrored.valueTextField?.isHidden ?? true)
        XCTAssertFalse(sutMirrored.confirmButton?.isEnabled ?? true)
    }

    func test_textFieldDidChangeSelection_givenValueGreaterThanZero_shouldCallEnableConfirmButton() {
        let textField = UITextField()
        textField.text = 10.0.asCurrency()
        sut.loadViewIfNeeded()
        sut.textFieldDidChangeSelection(textField)
        let sutMirrored = PayViewControllerMirror(viewController: sut)
        XCTAssertTrue(sutMirrored.confirmButton?.isEnabled ?? false)
    }

    func test_textFieldDidChangeSelection_givenValueEqualToZero_shouldCallDisableConfirmButton() {
        let textField = UITextField()
        textField.text = 0.0.asCurrency()
        sut.loadViewIfNeeded()
        sut.textFieldDidChangeSelection(textField)
        let sutMirrored = PayViewControllerMirror(viewController: sut)
        XCTAssertFalse(sutMirrored.confirmButton?.isEnabled ?? true)
    }

    func test_didTapShowBalanceButton_whenBalanceLabelIsHidden_shouldCallFetchBalance() {
        viewModelSpy.balanceToBeReturn = 10.0.asCurrency()
        sut.loadViewIfNeeded()
        let sutMirrored = PayViewControllerMirror(viewController: sut)
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
        let sutMirrored = PayViewControllerMirror(viewController: sut)
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

    func test_didTapConfirmButton_shouldCallPresentConfirmAlert() {
        sut.loadViewIfNeeded()
        let sutMirrored = PayViewControllerMirror(viewController: sut)
        sutMirrored.confirmButton?.sendActions(for: .touchUpInside)
        XCTAssertTrue(viewModelSpy.presentConfirmAlertCalled)
        XCTAssertNotNil(viewModelSpy.handlerReturned)
    }
}
