@testable import EasyBank

final class DatabaseServiceSpy {
    var rooms: [String: [String: Account]]?
    var createRoomError: String?
    var createAccountError: String?
    var transferErrorToBeReturn: Error?
    var transferIdToBeReturn: String?
    private(set) var transferCalled = false
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
        guard (rooms?[roomName]) != nil else {
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
        guard let account = rooms?[roomName]?[uid] else {
            completion(nil,"Error!")
            return
        }
        completion(account,nil)
    }
    
    func deleteAccount(roomName: String, uid: String, completion: @escaping (String?) -> Void) {
        
    }
}

extension DatabaseServiceSpy: TransferDatabaseService {
    func transfer(_ roomName: String,
                  value: Double,
                  payerID: String,
                  payerName: String,
                  receiverID: String,
                  receiverName: String,
                  completion: @escaping (Error?, String?) -> Void) {
        transferCalled = true
        completion(transferErrorToBeReturn, transferIdToBeReturn)
    }
    
    func getTransfer(roomName: String, documentId: String, completion: @escaping (Transfer?, String?) -> Void) {
        
    }
    
    func getAllTransfers(roomName: String, name: String, completion: @escaping ([Transfer]) -> Void) {
        
    }
    
    
}
