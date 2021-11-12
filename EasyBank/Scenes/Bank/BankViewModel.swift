import Foundation

protocol BankViewModelDelegate {
    func fetchRoomName(completion: @escaping (String) -> Void)
    func fetchAccounts(completion: @escaping ([Account]) -> Void)
    func fetchBankMenu(completion: @escaping ([String]) -> Void)
}

final class BankViewModel: BankViewModelDelegate {
    private let roomName: String?
    private let roomService: RoomService
    private let bankMenu: [String]
    
    init(roomService: RoomService) {
        self.roomService = roomService
        self.roomName = UserDefaults.standard.string(forKey: "Room")
        self.bankMenu = BankMenu().bankMenu
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

    func fetchBankMenu(completion: @escaping ([String]) -> Void) {
        completion(bankMenu)
    }
}
