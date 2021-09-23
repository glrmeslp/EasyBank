import FirebaseFirestore
import FirebaseFirestoreSwift
import FirebaseAuth

protocol RoomService {
    func createRoom(roomName: String, completion: @escaping (String?) -> Void)
    func getRoom(roomName: String, completion: @escaping (Bool, String?) -> Void)
    func createAccount(roomName: String, user: User, completion: @escaping (String?) -> Void)
    func getAccount(roomName: String, uid: String, completion: @escaping (Account?, String?) -> Void)
    func transfer(_ roomName: String, value: Double, payerID: String, _ payer: Account, receiverID: String, _ receiver: Account, completion: @escaping (String?, String?) -> Void)
    func deleteAccount(roomName: String, uid: String, completion: @escaping (String?) -> Void)
}

protocol TransferDatabaseService {
    func getTransfer(roomName: String, documentId: String, completion: @escaping (Transfer?, String?) -> Void )
    func getAllTransfers(roomName: String, name: String, completion: @escaping ([Transfer]) -> Void)
}

final class DatabaseService {

    private let firestore: Firestore
    private let COLLECTION_ROOM = "rooms"
    private let COLLECTION_ACCOUNTS = "accounts"
    private let COLLECTION_TRANSFERS = "transfers"

    init(firestore: Firestore) {
        self.firestore = firestore
    }
}

extension DatabaseService: RoomService {
    func deleteAccount(roomName: String, uid: String, completion: @escaping (String?) -> Void) {
        firestore.collection(COLLECTION_ROOM).document(roomName).collection(COLLECTION_ACCOUNTS).document(uid).delete() { error in
            guard let error = error else {
                completion(nil)
                return
            }
            completion(error.localizedDescription)
        }
    }

    func createRoom(roomName: String, completion: @escaping (String?) -> Void) {
        firestore.collection(COLLECTION_ROOM)
            .document(roomName)
            .setData(["createDate": Timestamp(date: Date())]) { error in
            if let error = error {
                completion(error.localizedDescription)
            } else {
                completion(nil)
            }
        }
    }

    func getRoom(roomName: String, completion: @escaping (Bool, String?) -> Void) {
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

    func getAccount(roomName: String, uid: String, completion: @escaping (Account?, String?) -> Void) {
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

    func transfer(_ roomName: String, value: Double, payerID: String, _ payer: Account, receiverID: String, _ receiver: Account, completion: @escaping (String?, String?) -> Void) {
        var payer = payer
        var receiver = receiver
        payer.transfer(account: &receiver, value: value) { error in
            guard let error = error else { return }
            completion(error, nil)
        }
        updateBalance(roomName: roomName, uid: payerID, account: payer) { error in
            guard let error = error else { return }
            completion(error, nil)
        }
        updateBalance(roomName: roomName, uid: receiverID, account: receiver) { error in
            guard let error = error else { return }
            completion(error, nil)
        }
        var ref: DocumentReference? = nil
        let transfer = Transfer(payDate: Timestamp(date: Date()), value: value, receiverName: receiver.userName, payerName: payer.userName)
        do {
            ref = try firestore.collection(COLLECTION_ROOM).document(roomName).collection(COLLECTION_TRANSFERS).addDocument(from: transfer)
            completion(nil, ref!.documentID)
        } catch let error {
            completion(error.localizedDescription, nil)
        }
    }

    private func updateBalance(roomName: String, uid: String, account: Account, completion: @escaping (String?) -> Void) {
        let accountRef = firestore.collection(COLLECTION_ROOM)
            .document(roomName)
            .collection(COLLECTION_ACCOUNTS)
            .document(uid)
        
        accountRef.updateData([
            "balance": account.balance
        ]) { error in
            if let error = error {
                completion(error.localizedDescription)
            } else {
                completion(nil)
            }
        }
    }

    func createAccount(roomName: String, user: User, completion: @escaping (String?) -> Void) {
        let account =  Account(balance: 0, userName: user.displayName ?? "No name")
        do {
            try firestore.collection(COLLECTION_ROOM).document(roomName).collection(COLLECTION_ACCOUNTS).document(user.uid).setData(from: account)
            completion(nil)
        } catch let error {
            completion(error.localizedDescription)
        }
    }
}

extension DatabaseService: TransferDatabaseService {
    func getAllTransfers(roomName: String, name: String, completion: @escaping ([Transfer]) -> Void) {
        let transferRef = firestore.collection(COLLECTION_ROOM).document(roomName).collection(COLLECTION_TRANSFERS)
        var transfers: [Transfer] = []
        getAllTransferWhereField("receiverName", isEqualTo: name, with: transferRef) { datas in
            transfers.append(contentsOf: datas)
            self.getAllTransferWhereField("payerName", isEqualTo: name, with: transferRef) { datas in
                transfers.append(contentsOf: datas)
                completion(transfers)
            }
        }
    }

    private func getAllTransferWhereField(_ fieldName: String, isEqualTo name: String, with transferRef: CollectionReference, completion: @escaping ([Transfer]) -> Void) {
        var transfers: [Transfer] = []
        transferRef.whereField(fieldName, isEqualTo: name).getDocuments() { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err.localizedDescription)")
            } else {
                guard let querySnapshot = querySnapshot else { return }
                for document in querySnapshot.documents {
                    do {
                        let transfer = try document.data(as: Transfer.self)
                        guard let transfer = transfer else { return }
                        transfers.append(transfer)
                    } catch let error {
                        print("Error decoding document: \(error.localizedDescription)")
                    }
                }
                completion(transfers)
            }
        }
    }
    
    func getTransfer(roomName: String, documentId: String, completion: @escaping (Transfer?, String?) -> Void) {
        let accountRef = firestore.collection(COLLECTION_ROOM)
            .document(roomName)
            .collection(COLLECTION_TRANSFERS)
            .document(documentId)
        accountRef.getDocument { document, error in
            if let document = document, document.exists {
                do {
                    let transfer = try document.data(as: Transfer.self)
                    completion(transfer,nil)
                } catch let error {
                    completion(nil, error.localizedDescription)
                }
            } else {
                completion(nil, error?.localizedDescription)
            }
        }
    }
}
