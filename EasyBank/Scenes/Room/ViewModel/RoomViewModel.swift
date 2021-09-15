import UIKit

final class RoomViewModel {
    private weak var coordinatorDelegate: RoomViewModelCoordinatorDelegate?
    private let roomService: RoomService
    private let authService: AuthService
    private var userID: String?
    private var roomName: String?
    
    init(coordinator: RoomViewModelCoordinatorDelegate, roomService: RoomService, authService: AuthService) {
        self.coordinatorDelegate = coordinator
        self.roomService = roomService
        self.authService = authService
        getUserID()
    }
    
    func enterToRoom(_ roomName: String, from controller: UIViewController) {
        self.roomName = roomName
        roomService.getRoom(roomName: roomName) { [weak self] roomExists, error in
            if roomExists == true {
                self?.userHasAnAccountInThisRoom(controller: controller)
            } else {
                guard let error = error else { return }
                self?.coordinatorDelegate?.presentAlert(with: error, from: controller)
            }  
        }
    }

    func userHasAnAccountInThisRoom(controller: UIViewController) {
        guard let roomName = roomName, let uid = userID else { return }
        roomService.getAccount(roomName: roomName, uid: uid) { [weak self] account, _ in
            if account == nil {
                self?.coordinatorDelegate?.pushToPlayerViewController(with: roomName)
            } else {
                let message = "You already have an account in this room. A new account will not be created"
                self?.coordinatorDelegate?.presentAlertAndPushToHome(with: message, from: controller, and: roomName)
            }
            
        }
    }

    private func getUserID() {
        authService.getUser { [weak self] user in
            guard let user = user else { return }
            self?.userID = user.uid
        }
    }
}
