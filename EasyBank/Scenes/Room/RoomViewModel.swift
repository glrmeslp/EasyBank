import UIKit

final class RoomViewModel: BaseViewModel {
    private weak var coordinatorDelegate: RoomViewModelCoordinatorDelegate?
    
    init(coordinator: RoomViewModelCoordinatorDelegate, roomService: RoomService, authService: AuthService) {
        self.coordinatorDelegate = coordinator
        super.init(roomName: "", authService: authService, roomService: roomService)
    }
    
    func enterToRoom(_ roomName: String) {
        roomService.getRoom(roomName: roomName) { [weak self] error in
            guard let error = error else {
                self?.userHasAnAccountInThisRoom(roomName: roomName)
                return
            }
            self?.coordinatorDelegate?.presentAlert(with: error)
        }
    }

    private func userHasAnAccountInThisRoom(roomName: String, controller: UIViewController) {
        guard let uid = user?.identifier else { return }
        roomService.getAccount(roomName: roomName, uid: uid) { [weak self] account, _ in
            if account == nil {
                self?.createAccount(with: roomName)
            } else {
                let message = "You already have an account in this room. A new account will not be created"
                self?.coordinatorDelegate?.presentAlertAndPushToHome(with: message, and: roomName)
            }
            
        }
    }

    private func createAccount(with roomName: String) {
        guard let user = user else { return }
        roomService.createAccount(roomName: roomName, user: user) { [weak self] error in
            guard let error = error else {
                let message = "You don't have an account in the room yet. A new account will be created"
                self?.coordinatorDelegate?.presentAlertAndPushToHome(with: message, and: roomName)
                return
            }
            self?.coordinatorDelegate?.presentAlert(with: error)
        }
    }
}
