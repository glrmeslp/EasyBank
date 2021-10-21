@testable import EasyBank

final class ReauthenticateViewModelSpy: ReauthenticateViewModelProtocol {
    private(set) var reauthenticateCalled = false
    private(set) var passwordReturned = ""

    func reauthenticate(with password: String) {
        reauthenticateCalled = true
        passwordReturned = password
    }
}
