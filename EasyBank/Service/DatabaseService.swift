import FirebaseFirestore
import FirebaseFirestoreSwift
import FirebaseAuth

protocol RoomService {
    func createRoom(roomName: String, completion: @escaping (String?) -> Void)
    func getRoom(roomName: String, completion: @escaping (String?) -> Void)
    func createAccount(roomName: String, user: User, completion: @escaping (String?) -> Void)
    func getAccount(roomName: String, uid: String, completion: @escaping (Account?, String?) -> Void)
    func deleteAccount(roomName: String, uid: String, completion: @escaping (String?) -> Void)
}

protocol TransferDatabaseService {
    func transfer(_ roomName: String, value: Double,
                  payerID: String, payerName: String,
                  receiverID: String, receiverName: String,
                  completion: @escaping (Error?, String?) -> Void)
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

    func getRoom(roomName: String, completion: @escaping (String?) -> Void) {
        let roomRef = firestore.collection(COLLECTION_ROOM).document(roomName)
        roomRef.getDocument { (document, error) in
            guard let document = document, document.exists else {
                completion("This room does not exist")
                return
            }
            completion(nil)
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

    func transfer(_ roomName: String, value: Double,
                  payerID: String, payerName: String,
                  receiverID: String, receiverName: String,
                  completion: @escaping (Error?, String?) -> Void) {
        let payerReference = firestore.collection(COLLECTION_ROOM).document(roomName)
            .collection(COLLECTION_ACCOUNTS).document(payerID)
        let receiverReference = firestore.collection(COLLECTION_ROOM).document(roomName)
            .collection(COLLECTION_ACCOUNTS).document(receiverID)
        firestore.runTransaction({ (transaction, errorPointer) -> Any? in
            let payerDocument: DocumentSnapshot
            do {
                try payerDocument = transaction.getDocument(payerReference)
            } catch let error as NSError {
                errorPointer?.pointee = error
                return nil
            }

            let receiverDocument: DocumentSnapshot
            do {
                try receiverDocument = transaction.getDocument(receiverReference)
            } catch let error as NSError {
                errorPointer?.pointee = error
                return nil
            }

            guard let oldPayerBalance = payerDocument.data()?["balance"] as? Double else {
                errorPointer?.pointee = NSError(domain: "AppErrorDomain", code: -1,
                                                userInfo: [NSLocalizedDescriptionKey: "Unable to retrieve balance from snapshot \(payerDocument)"])
                return nil
            }

            guard oldPayerBalance >= value else {
                errorPointer?.pointee = NSError(domain: "AppErrorDomain", code: -2,
                                                userInfo: [NSLocalizedDescriptionKey: "Insufficient balance to transfer"])
                return nil
            }

            guard let oldReceiverBalance = receiverDocument.data()?["balance"] as? Double else {
                errorPointer?.pointee = NSError(domain: "AppErrorDomain", code: -1,
                                                userInfo: [NSLocalizedDescriptionKey: "Unable to retrieve balance from snapshot \(receiverDocument)"])
                return nil
            }
            
            transaction.updateData(["balance": oldPayerBalance - value], forDocument: payerReference)
            transaction.updateData(["balance": oldReceiverBalance + value], forDocument: receiverReference)
            return nil
        }) { (object, error) in
            guard let error = error else {
                self.createTransferDocument(roomName, value: value, payerName: payerName, receiverName: receiverName) { error, documentID in
                    completion(error,documentID)
                }
                return
            }
            completion(error, nil)
        }
    }

    private func createTransferDocument(_ roomName: String, value: Double, payerName: String, receiverName: String, completion: @escaping (Error? ,String?) -> Void) {
        let transfer = Transfer(payDate: Timestamp(date: Date()), value: value, receiverName: receiverName, payerName: payerName)
        do {
            let reference = try firestore.collection(COLLECTION_ROOM).document(roomName).collection(COLLECTION_TRANSFERS).addDocument(from: transfer)
            completion(nil, reference.documentID)
        } catch let error {
            completion(error, nil)
        }
    }
}
