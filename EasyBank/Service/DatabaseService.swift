import FirebaseFirestore
import FirebaseFirestoreSwift

class DatabaseService {

    static let shared = DatabaseService()
    private let firestore = Firestore.firestore()
    private let COLLECTION_ROOM = "rooms"
    private let COLLECTION_ACCOUNTS = "accounts"
    
    func createRoom(_ roomName: String, _ userId: String, completion: @escaping (String?) -> Void) {
        do {
            let account = Account(balance: 100000.0, userName: "The Banker")
            try firestore.collection(COLLECTION_ROOM).document(roomName)
                .collection(COLLECTION_ACCOUNTS)
                .document(userId)
                .setData(from: account)
            completion(nil)
        } catch let error {
            completion(error.localizedDescription)
        }
    }
    
    func isRoomExists(roomName: String, completion: @escaping (String?) -> Void) {
        let roomRef = firestore.collection(COLLECTION_ROOM).document(roomName)
        roomRef.getDocument { document, error in
            if let document = document, document.exists {
                return
            } else {
                completion(error.debugDescription)
            }
        }
    }

    func getAccount(_ roomName: String, _ uid: String, completion: @escaping (Account?, String?) -> Void) {
        let accountRef = firestore.collection(COLLECTION_ROOM)
            .document(roomName)
            .collection(COLLECTION_ACCOUNTS)
            .document(uid)
        accountRef.getDocument { document, error in
            if let document = document, document.exists {
                do {
                    let account = try document.data(as: Account.self)
                    completion(account,nil)
                } catch let error {
                    completion(nil, error.localizedDescription)
                }
            } else {
                completion(nil, error?.localizedDescription)
            }
        }
    }
    

}
