import UIKit

final class RoomViewModel: BaseViewModel {
    private weak var coordinatorDelegate: RoomViewModelCoordinatorDelegate?
    
    init(coordinator: RoomViewModelCoordinatorDelegate, roomService: RoomService, authService: AuthService) {
        self.coordinatorDelegate = coordinator
        super.init(roomName: "", authService: authService, roomService: roomService)
    }
    
    func enterToRoom(_ roomName: String, from controller: UIViewController) {
        roomService.getRoom(roomName: roomName) { [weak self] roomExists, error in
            if roomExists == true {
                self?.userHasAnAccountInThisRoom(roomName: roomName, controller: controller)
            } else {
                guard let error = error else { return }
                self?.coordinatorDelegate?.presentAlert(with: error, from: controller)
            }  
        }
    }

    private func userHasAnAccountInThisRoom(roomName: String, controller: UIViewController) {
        guard let uid = userID else { return }
        roomService.getAccount(roomName: roomName, uid: uid) { [weak self] account, _ in
            if account == nil {
                self?.createAccount(with: roomName, from: controller)
            } else {
                let message = "You already have an account in this room. A new account will not be created"
                self?.coordinatorDelegate?.presentAlertAndPushToHome(with: message, from: controller, and: roomName)
            }
            
        }
    }

    private func createAccount(with roomName: String, from controller: UIViewController) {
        guard let user = user else { return }
        roomService.createAccount(roomName: roomName, user: user) { [weak self] error in
            guard let error = error else {
                let message = "You don't have an account in the room yet. A new account will be created"
                self?.coordinatorDelegate?.presentAlertAndPushToHome(with: message, from: controller, and: roomName)
                return
            }
            self?.coordinatorDelegate?.presentAlert(with: error, from: controller)
        }
    }
}
