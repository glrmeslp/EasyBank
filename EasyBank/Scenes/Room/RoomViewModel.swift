import UIKit

protocol RoomViewModelProtocol {
    func enter(_ roomName: String)
}

final class RoomViewModel: UserViewModel, RoomViewModelProtocol {
    private weak var coordinatorDelegate: RoomViewModelCoordinatorDelegate?
    private let roomService: RoomService

    init(coordinator: RoomViewModelCoordinatorDelegate, roomService: RoomService, authService: AuthService) {
        self.coordinatorDelegate = coordinator
        self.roomService = roomService
        super.init(authService: authService)
    }

    func enter(_ roomName: String) {
        roomService.getRoom(roomName: roomName) { [weak self] message in
            guard let message = message else {
                self?.userHasAnAccountInThis(roomName)
                self?.setupUserDefaultsForRoomKey(roomName)
                return
            }
            self?.coordinatorDelegate?.presentAlert(with: message)
        }
    }

    private func userHasAnAccountInThis(_ roomName: String) {
        guard let uid = user?.identifier else { return }
        roomService.getAccount(roomName: roomName, uid: uid) { [weak self] account, _ in
            if account == nil {
                self?.createAccountInThe(roomName)
            } else {
                let message = "You already have an account in this room. A new account will not be created"
                self?.coordinatorDelegate?.presentAlertAndPushToHome(with: message)
            }
            
        }
    }

    private func createAccountInThe(_ roomName: String) {
        guard let user = user else { return }
        roomService.createAccount(roomName: roomName, user: user) { [weak self] error in
            guard let error = error else {
                let message = "You don't have an account in the room yet. A new account will be created"
                self?.coordinatorDelegate?.presentAlertAndPushToHome(with: message)
                return
            }
            self?.coordinatorDelegate?.presentAlert(with: error)
        }
    }

    private func setupUserDefaultsForRoomKey(_ roomName: String) {
        UserDefaults.standard.set(roomName, forKey: "Room")
    }
}
