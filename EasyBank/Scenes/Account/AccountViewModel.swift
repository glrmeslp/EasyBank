final class AccountViewModel: BaseViewModel {

    private var coordinatorDelegate: AccountViewModelCoordinatorDelegate?

    init(roomName: String, authService: AuthService, databaseService: DatabaseService, coordinator: AccountViewModelCoordinatorDelegate) {
        self.coordinatorDelegate = coordinator
        super.init(roomName: roomName, authService: authService, databaseService: databaseService)
    }

    func leaveRoom() {
        coordinatorDelegate?.pushToStartViewController()
    }

    func deleteAccount(completion: @escaping (String) -> Void) {
        guard let uid = userID else { return }
        roomService.deleteAccount(roomName: roomName, uid: uid) { [weak self] error in
            guard let error = error else {
                self?.coordinatorDelegate?.pushToStartViewController()
                return
            }
            completion(error)
        }
    }

    func deleteEasyBankAccount() {
        coordinatorDelegate?.pushToDeleteUserViewController()
    }

    func manageProfileInformation() {
        coordinatorDelegate?.pushToProfileViewController()
    }
}
