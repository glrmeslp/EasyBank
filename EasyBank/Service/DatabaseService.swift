import FirebaseFirestore
import FirebaseFirestoreSwift

class DatabaseService {

    static let shared = DatabaseService()
    private let firestore = Firestore.firestore()
    private let COLLECTION_ROOM = "rooms"
    private let COLLECTION_ACCOUNTS = "accounts"
    
    func createRoom(_ roomName: String, completion: @escaping (String?) -> Void) {
        firestore.collection(COLLECTION_ROOM).document(roomName).setData(["createDate": Timestamp(date: Date())]) { error in
            if let error = error {
                completion(error.localizedDescription)
            } else {
                completion(nil)
            }
        }
    }
    
    func getRoom(roomName: String, completion: @escaping (Bool?, String?) -> Void) {
        let roomRef = firestore.collection(COLLECTION_ROOM).document(roomName)
        roomRef.getDocument { (document, error) in
            if let document = document, document.exists {
                completion(true, nil)
            } else {
                guard let error = error else {
                    completion(false,"This room does not exist")
                    return
                }
                completion(false,error.localizedDescription)
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

    func createAccount(with uid: String, _ account: Account, and roomName: String, completion: @escaping (String?) -> Void) {
        do {
            try firestore.collection(COLLECTION_ROOM)
                .document(roomName)
                .collection(COLLECTION_ACCOUNTS)
                .document(uid)
                .setData(from: account)
            completion(nil)
        } catch let error {
            completion(error.localizedDescription)
        }
    }
    

}
