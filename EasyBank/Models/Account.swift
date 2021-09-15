struct Account: Codable {
    private(set) var balance: Double = 0.0
    let userName: String
    
    enum CodingKeys: String, CodingKey{
        case balance
        case userName
    }

    private mutating func deposit(_ value: Double) {
        balance += value
    }

    private mutating func withdraw(_ value: Double) {
        balance -= value
    }

    mutating func transfer(account: inout Account, value: Double, completion: @escaping (String?) -> Void) {
        if (balance < value) {
            completion("Error!")
            return
        }
        withdraw(value)
        account.deposit(value)
        completion(nil)
    }
}
