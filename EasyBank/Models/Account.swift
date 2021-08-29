struct Account: Codable {
    var balance: Double = 0.0
    let userName: String
    
    enum CodingKeys: String, CodingKey{
        case balance
        case userName
    }
}
