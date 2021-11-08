import UIKit

protocol NewRoomViewModelProtocol {
    func validateRoom(with roomName: String)
}

final class NewRoomViewModel: UserViewModel, NewRoomViewModelProtocol {

    private weak var coordinatorDelegate: NewRoomViewModelCoordinatorDelegate?
    private let roomService: RoomService
    
    init(coordinator: NewRoomViewModelCoordinatorDelegate, roomService: RoomService, authService: AuthService) {
        self.coordinatorDelegate = coordinator
        self.roomService = roomService
        super.init(authService: authService)
    }

    func validateRoom(with roomName: String) {
        roomService.getRoom(roomName: roomName) { [weak self] error in
            guard error != nil else {
                let message = "The room exists, please enter another room name"
                self?.coordinatorDelegate?.presentAlert(with: message)
                return
            }
            self?.createRoom(with: roomName)
        }
    }

    private func createRoom(with roomName: String) {
        roomService.createRoom(roomName: roomName) { [weak self] error in
            guard let error = error else {
                self?.createAccount(with: roomName)
                return
            }
            self?.coordinatorDelegate?.presentAlert(with: error)
        }
    }

    private func createAccount(with roomName: String) {
        guard let user = user else { return }
        roomService.createAccount(roomName: roomName, user: user) { [weak self] error in
            guard let error = error else {
                self?.setupUserDefaultsForRoomKey(roomName)
                self?.coordinatorDelegate?.pushToHomeViewController()
                return
            }
            self?.coordinatorDelegate?.presentAlert(with: error)
        }
    }

    private func setupUserDefaultsForRoomKey(_ roomName: String) {
        UserDefaults.standard.set(roomName, forKey: "Room")
    }
}
