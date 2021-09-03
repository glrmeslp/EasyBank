import UIKit

final class PlayerViewModel {

    private var roomName: String
    private var userID: String?

    private weak var coordinatorDelegate: PlayerViewModelCoordinatorDelegate?
    private let authService: AuthService
    private let roomService: RoomService

    init(roomName: String, coordinator: PlayerViewModelCoordinatorDelegate,
         authService: AuthService, roomService: RoomService) {
        self.roomName = roomName
        self.coordinatorDelegate = coordinator
        self.authService = authService
        self.roomService = roomService
        getUserID()
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
    
    func showHomeViewController() {
        coordinatorDelegate?.pushToHomeViewController(with: roomName)
    }

    private func getUserID() {
        authService.getUser { [weak self] user in
            guard let user = user else { return }
            self?.userID = user.uid
        }
    }
}
