import FirebaseFirestore

protocol BankServicing {
    func getAccounts(roomName: String, completion: @escaping (Result<[Account], Error>) -> Void)
}

final class BankService {
    private let firestore: Firestore
    private let COLLECTION_ROOM = "rooms"
    private let COLLECTION_ACCOUNTS = "accounts"

    init(firestore: Firestore) {
        self.firestore = firestore
    }
}

// MARK: - BankServicing
extension BankService: BankServicing {
    func getAccounts(roomName: String, completion: @escaping (Result<[Account], Error>) -> Void) {
        var accounts: [Account] = []
        firestore.collection(COLLECTION_ROOM)
            .document(roomName)
            .collection(COLLECTION_ACCOUNTS)
            .order(by: "balance", descending: true)
            .getDocuments() { (querySnapshot, error) in
            guard let querySnapshot = querySnapshot else {
                completion(Result.failure(error ?? NSError()))
                return
            }
            for document in querySnapshot.documents {
                do {
                    let account = try document.data(as: Account.self)
                    guard let account = account else { return }
                    accounts.append(account)
                } catch let error {
                    completion(Result.failure(error))
                }
            }
            completion(Result.success(accounts))
        }
    }
}
