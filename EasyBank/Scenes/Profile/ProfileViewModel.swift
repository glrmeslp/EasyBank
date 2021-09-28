final class ProfileViewModel: BaseViewModel {

    func updateEmailAddress(_ email: String, completion: @escaping (String) -> Void) {
        authService.updateEmailAddress(with: email) { error in
            guard let error = error else {
                completion("Your email address has been updated successfully")
                return
            }
            completion(error)
        }
    }

    func updateDispleyName(_ name: String, completion: @escaping (String) -> Void) {
        authService.updateDisplayName(with: name) { error in
            guard let error = error else {
                completion("Your name has been updated successfully")
                return
            }
            completion(error)
        }
    }
}
