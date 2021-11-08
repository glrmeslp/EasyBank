@testable import EasyBank

final class ProfileViewModelSpy: ProfileViewModelProtocol {
    private(set) var updateEmailAddressCalled = false
    private(set) var updateDispleyNameCalled = false
    private(set) var fetchDataCalled = false
    private(set) var emailReturned = ""
    private(set) var nameReturned = ""
    var userToBeReturn: User?

    func updateEmailAddress(_ email: String) {
        updateEmailAddressCalled = true
        emailReturned = email
    }

    func updateDispleyName(_ name: String) {
        updateDispleyNameCalled = true
        nameReturned = name
    }

    func fetchData(completion: @escaping (User) -> Void) {
        fetchDataCalled = true
        guard let userToBeReturn = userToBeReturn else {
            return
        }
        completion(userToBeReturn)
    }
}
