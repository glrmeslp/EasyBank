@testable import EasyBank

final class DatabaseServiceSpy {
    var roomExists: Bool?
    var createRoomError: String?
    var createAccountError: String?
}

extension DatabaseServiceSpy: RoomService {
    func createRoom(roomName: String, completion: @escaping (String?) -> Void) {
        if let error = createRoomError {
            completion(error)
        } else {
            completion(nil)
        }
    }
    
    func getRoom(roomName: String, completion: @escaping (String?) -> Void) {
        guard let roomExists = roomExists else { return }
        guard roomExists else {
            completion("This room does not exist")
            return
        }
        completion(nil)
    }
    
    func createAccount(roomName: String, user: User, completion: @escaping (String?) -> Void) {
        if let error = createAccountError {
            completion(error)
        } else {
            completion(nil)
        }
    }
    
    func getAccount(roomName: String, uid: String, completion: @escaping (Account?, String?) -> Void) {
        
    }
    
    func deleteAccount(roomName: String, uid: String, completion: @escaping (String?) -> Void) {
        
    }
}
