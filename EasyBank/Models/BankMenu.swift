struct BankMenu {
    let bankMenu: [String] = ["Pay",
                              "Charge",
                              "Delete Room"]
}

enum BankMenuEnum: String {
    case pay = "Pay"
    case charge = "Charge"
    case delete = "Delete Room"
}