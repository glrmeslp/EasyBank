import Foundation

protocol BankInteracting: AnyObject {
    func loadData()
}

final class BankInteractor {
    private let service: BankServicing
    private let presenter: BankPresenting

    init(service: BankServicing, presenter: BankPresenting) {
        self.service = service
        self.presenter = presenter
    }
}

// MARK: - BankInteracting
extension BankInteractor: BankInteracting {
    func loadData() {
        getAccounts()
    }
}

private extension BankInteractor {
    func getAccounts() {
        service.getAccounts(roomName: getRoomName()) {[weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let data):
                self.presenter.display(accounts: data)
            case .failure:
                // Next PR
                break
            }
        }
    }
    
    func getRoomName() -> String {
        guard let name = UserDefaults.standard.string(forKey: "Room") else { return "Error!"}
        return name
    }
}
