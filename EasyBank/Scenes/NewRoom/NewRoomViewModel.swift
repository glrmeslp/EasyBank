import UIKit

protocol NewRoomViewModelProtocol {
    func validateRoom(with roomName: String)
}

final class NewRoomViewModel: BaseViewModel, NewRoomViewModelProtocol {

    private weak var coordinatorDelegate: NewRoomViewModelCoordinatorDelegate?
    
    init(coordinator: NewRoomViewModelCoordinatorDelegate, roomService: RoomService, authService: AuthService) {
        self.coordinatorDelegate = coordinator
        super.init(roomName: "", authService: authService, roomService: roomService)
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
                self?.coordinatorDelegate?.pushToHomeViewController(with: roomName)
                return
            }
            self?.coordinatorDelegate?.presentAlert(with: error)
        }
    }
}
