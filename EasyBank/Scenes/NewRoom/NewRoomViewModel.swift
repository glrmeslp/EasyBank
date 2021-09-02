import UIKit

protocol NewRoomViewModelCoordinatorDelegate: AnyObject {
    func pushToHomeViewController(with roomName: String, and uid: String)
}

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
    }

    func createRoom(with roomName: String, completion: @escaping (String?) -> Void) {
        self.roomName = roomName
        roomService.createRoom(roomName: roomName) { [weak self] error in
            guard let error = error else {
                self?.createTheGameBankerAccount()
                return
            }
            completion(error)
        }
    }
    
    func validateRoom(with roomName: String, completion: @escaping (String?) -> Void) {
        roomService.getRoom(roomName: roomName) { roomExists, _ in
            if let roomExists = roomExists, roomExists == true {
                completion("The room exists, please enter another room name")
            }
            completion(nil)
        }
    }
    
    func createTheGameBankerAccount() {
        getUserID()
        guard let roomName = roomName, let uid = userId else { return }
        let account = Account(balance: 10000000000, userName: "The Banker")
        roomService.createAccount(roomName: roomName, uid: uid, account: account) { [weak self] error in
            guard error != nil else {
                self?.coordinatorDelegate?.pushToHomeViewController(with: roomName, and: uid)
                return
            }
        }
    }
    
    private func getUserID() {
        authService.getUser { [weak self] user in
            guard let user = user else { return }
            self?.userId = user.uid
        }
    }
}
