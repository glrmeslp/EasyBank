@testable import EasyBank

final class RecoverPasswordVieModelSpy: RecoverPasswordViewModelProtocol {
    private(set) var sendPasswordResetCalled = false

    func sendPasswordReset(with email: String) {
        sendPasswordResetCalled = true
    }
}
