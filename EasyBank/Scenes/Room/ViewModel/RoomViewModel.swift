
final class RoomViewModel {
    private weak var coordinatorDelegate: RoomViewModelCoordinatorDelegate?
    private let roomService: RoomService
    
    init(coordinator: RoomViewModelCoordinatorDelegate, roomService: RoomService) {
        self.coordinatorDelegate = coordinator
        self.roomService = roomService
    }
    
    func enterToRoom(_ roomName: String, completion: @escaping (String?) -> Void) {
        roomService.getRoom(roomName: roomName) { [weak self] _, error in
            guard let error = error else {
                completion(nil)
                self?.coordinatorDelegate?.pushToPlayerViewController(with: roomName)
                return
            }
            completion(error)
        }
    }
}
