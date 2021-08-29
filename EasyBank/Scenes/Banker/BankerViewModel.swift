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
        guard let uid = userId else { return }
        DatabaseService.shared.createRoom(roomName, uid) { [weak self] error in
            guard let error = error else {
                self?.coordinatorDelegate?.pushToHomeViewController(with: roomName, and: uid)
                return
            }
            self?.viewDelegate?.showErrorMessage(with: error)
        }
    }
}
