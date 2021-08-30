protocol RoomViewModelCoordinatorDelegate: AnyObject {
    func pushToPlayerViewController(with roomName: String)
}

final class RoomViewModel {
    weak var coordinatorDelegate: RoomViewModelCoordinatorDelegate?
    
    func enterToRoom(_ roomName: String, completion: @escaping (String?) -> Void) {
        DatabaseService.shared.getRoom(roomName: roomName) { [weak self] _, error in
            guard let error = error else {
                self?.coordinatorDelegate?.pushToPlayerViewController(with: roomName)
                return
            }
            completion(error)
        }
    }
}
