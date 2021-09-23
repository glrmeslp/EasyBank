import UIKit

final class NewRoomViewModel: BaseViewModel {

    private weak var coordinatorDelegate: NewRoomViewModelCoordinatorDelegate?
    
    init(coordinator: NewRoomViewModelCoordinatorDelegate, roomService: DatabaseService, authService: AuthService) {
        self.coordinatorDelegate = coordinator
        super.init(roomName: "", authService: authService, roomService: roomService)
    }

    func validateRoom(with roomName: String, from controller: UIViewController) {
        roomService.getRoom(roomName: roomName) { [weak self] roomExists, _ in
            if roomExists {
                let message = "The room exists, please enter another room name"
                self?.coordinatorDelegate?.presentAlert(with: message, from: controller)
            } else {
                self?.createRoom(with: roomName, from: controller)
            }
        }
    }

    private func createRoom(with roomName: String, from controller: UIViewController) {
        roomService.createRoom(roomName: roomName) { [weak self] error in
            guard let error = error else {
                self?.createAccount(with: roomName, from: controller)
                return
            }
            self?.coordinatorDelegate?.presentAlert(with: error, from: controller)
        }
    }

    private func createAccount(with roomName: String, from controller: UIViewController) {
        guard let user = user else { return }
        roomService.createAccount(roomName: roomName, user: user) { [weak self] error in
            guard let error = error else {
                self?.coordinatorDelegate?.pushToHomeViewController(with: roomName)
                return
            }
            self?.coordinatorDelegate?.presentAlert(with: error, from: controller)
        }
    }
}
