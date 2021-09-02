import UIKit

protocol PlayerViewModelCoordinatorDelegate: AnyObject {
    func pushToHomeViewController(with roomName: String, and uid: String)
}

final class PlayerViewModel {

    private var roomName: String
    private var uid: String?

    weak var coordinatorDelegate: PlayerViewModelCoordinatorDelegate?

    init(roomName: String) {
        self.roomName = roomName
    }

    func createAccount(with name: String, completion: @escaping (String?) -> Void) {
//        guard let uid = uid else { return }
//        let roomName = roomName
//        RoomFirebaseService.shared.getAccount(roomName, uid) { [weak self] account, _ in
//            if account != nil {
//                self?.showHomeViewController()
//                completion("You already have an account in this room. A new account has not been created")
//            } else {
//                let account = Account(balance: 0, userName: name)
//                RoomFirebaseService.shared.createAccount(with: uid, account, and: roomName) { [weak self] error in
//                    guard let error = error else {
//                        completion(nil)
//                        self?.showHomeViewController()
//                        return
//                    }
//                    completion(error)
//                }
//            }
//        }
    }
    
    func showHomeViewController() {
        guard let uid = uid else { return }
        coordinatorDelegate?.pushToHomeViewController(with: roomName, and: uid)
    }
    
    func detectAuthenticationStatus() {
//        AuthService.shared.detectAuthenticationStatus() { [weak self] uid in
//            guard let uid = uid else { return }
//            self?.uid = uid
//        }
    }
    
    func undetectAuthenticationStatus() {
//        AuthService.shared.removeStateDidChangeListener()
    }
}
