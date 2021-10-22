@testable import EasyBank

final class ReceiveCoordinatorSpy {
    private(set) var pushToQRCodeViewControllerCalled = false
    private(set) var valueReturned = 0.0
}

extension ReceiveCoordinatorSpy: ReceiveViewCoordinatorDelegate {
    func pushToQRCodeViewController(value: Double) {
        pushToQRCodeViewControllerCalled = true
        valueReturned = value
    }
}
