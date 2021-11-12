import Foundation

protocol BankViewModelDelegate {
    func fetchRoomName(completion: @escaping (String) -> Void)
    func fetchAccounts(completion: @escaping ([Account]) -> Void)
}

final class BankViewModel: BankViewModelDelegate {
    private let roomName: String?
    private let roomService: RoomService
    
    init(roomService: RoomService) {
        self.roomService = roomService
        self.roomName = UserDefaults.standard.string(forKey: "Room")
    }

    func fetchRoomName(completion: @escaping (String) -> Void) {
        guard let roomName = roomName else {
            return
        }
        completion(roomName)
    }

    func fetchAccounts(completion: @escaping ([Account]) -> Void) {
        guard let roomName = roomName else {
            return
        }
        roomService.getAllAccounts(roomName: roomName) { accounts, _ in
            completion(accounts)
        }
    }
}
