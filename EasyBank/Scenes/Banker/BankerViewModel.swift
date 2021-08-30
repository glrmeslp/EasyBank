import UIKit

protocol BankerViewModelDelegate: AnyObject {
    func showErrorMessage(with message: String)
}

protocol BankerViewModelCoordinatorDelegate: AnyObject {
    func pushToHomeViewController(with roomName: String, and uid: String)
}

final class BankerViewModel {

    weak var viewDelegate: BankerViewModelDelegate?
    weak var coordinatorDelegate: BankerViewModelCoordinatorDelegate?
    
    private var userId: String?
    private var roomName: String?
    
    init(uid: String) {
        self.userId = uid
    }

    func createRoom(with roomName: String) {
        self.roomName = roomName
        DatabaseService.shared.createRoom(roomName) { [weak self] error in
            guard let error = error else {
                self?.createTheGameBankerAccount()
                return
            }
            self?.viewDelegate?.showErrorMessage(with: error)
        }
    }
    
    func isThereThisRoom(with roomName: String, completion: @escaping (String?) -> Void) {
        DatabaseService.shared.getRoom(roomName: roomName) { roomExists, _ in
            if let roomExists = roomExists, roomExists == true {
                completion("The room exists, please enter another room name")
            }
            completion(nil)
        }
    }
    
    func createTheGameBankerAccount() {
        guard let uid = userId, let roomName = roomName else { return }
        let account = Account(balance: 10000000000.0, userName: "The Banker")
        DatabaseService.shared.createAccount(with: uid, account, and: roomName) { [weak self] error in
            guard let error = error else {
                self?.coordinatorDelegate?.pushToHomeViewController(with: roomName, and: uid)
                return
            }
            self?.viewDelegate?.showErrorMessage(with: error)
        }
    }
}
