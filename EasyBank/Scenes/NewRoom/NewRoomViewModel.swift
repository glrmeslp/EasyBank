import UIKit

final class NewRoomViewModel {

    private weak var coordinatorDelegate: NewRoomViewModelCoordinatorDelegate?
    private let roomService: RoomService
    private let authService: AuthService
    
    private var userId: String?
    private var roomName: String?
    
    init(coordinator: NewRoomViewModelCoordinatorDelegate, roomService: RoomService, authService: AuthService) {
        self.coordinatorDelegate = coordinator
        self.roomService = roomService
        self.authService = authService
        getUserID()
    }

    private func createRoom(with roomName: String, from controller: UIViewController) {
        self.roomName = roomName
        roomService.createRoom(roomName: roomName) { [weak self] error in
            guard let error = error else {
                self?.createTheGameBankerAccount(from: controller)
                return
            }
            self?.coordinatorDelegate?.presentAlert(with: error, from: controller)
        }
    }
    
    func validateRoom(with roomName: String, from controller: UIViewController) {
        roomService.getRoom(roomName: roomName) { [weak self] roomExists, _ in
            if roomExists == true {
                let message = "The room exists, please enter another room name"
                self?.coordinatorDelegate?.presentAlert(with: message, from: controller)
            } else {
                self?.createRoom(with: roomName, from: controller)
            }
        }
    }
    
    private func createTheGameBankerAccount(from controller: UIViewController) {
        guard let roomName = roomName, let uid = userId else { return }
        let account = Account(balance: 10000000000, userName: "The Banker")
        roomService.createAccount(roomName: roomName, uid: uid, account: account) { [weak self] error in
            guard let error = error else {
                self?.coordinatorDelegate?.pushToHomeViewController(with: roomName)
                return
            }
            self?.coordinatorDelegate?.presentAlert(with: error, from: controller)
        }
    }
    
    private func getUserID() {
        authService.getUser { [weak self] user in
            guard let user = user else { return }
            self?.userId = user.uid
        }
    }
}
