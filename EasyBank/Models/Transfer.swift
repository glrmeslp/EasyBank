import FirebaseFirestore

struct Transfer: Codable {
    let payDate: Timestamp
    let value: Double
    let receiverName: String
    let payerName: String
}
