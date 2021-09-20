import UIKit

final class PlayerViewModel: BaseViewModel {

    private weak var coordinatorDelegate: PlayerViewModelCoordinatorDelegate?

    init(roomName: String, coordinator: PlayerViewModelCoordinatorDelegate,
         authService: AuthService, databaseService: DatabaseService) {
        self.coordinatorDelegate = coordinator
        super.init(roomName: roomName, authService: authService, databaseService: databaseService)
    }

    func createAccount(with name: String, from controller: UIViewController) {
        guard let uid = userID else { return }
        let roomName = roomName
        let account = Account(balance: 0, userName: name)
        roomService.createAccount(roomName: roomName, uid: uid, account: account) { [weak self] error in
            guard let error = error else {
                self?.coordinatorDelegate?.pushToHomeViewController(with: roomName)
                return
            }
            self?.coordinatorDelegate?.presentAlert(with: error, from: controller)
        }
    }
}
