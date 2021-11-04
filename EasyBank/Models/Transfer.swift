import FirebaseFirestore

struct Transfer: Codable {
    var id: String?
    let payDate: Timestamp
    let value: Double
    let receiverName: String
    let payerName: String
}
