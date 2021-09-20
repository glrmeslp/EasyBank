final class ExtractViewModel: BaseViewModel {

    private let transferService: TransferDatabaseService

    init(databaseService: DatabaseService, authService: AuthService, roomName: String) {
        self.transferService = databaseService
        super.init(roomName: roomName, authService: authService, databaseService: databaseService)
    }

    func getAllTransfers(completion: @escaping ([Transfer]) -> Void){
        getUserName { [weak self] userName in
            guard let roomName = self?.roomName else { return }
            self?.transferService.getAllTransfers(roomName: roomName, name: userName ) { tranfers in
                let sortedTranfers = tranfers.sorted { $0.payDate.dateValue() > $1.payDate.dateValue() }
                completion(sortedTranfers)
            }
        }
    }

    func getBalance(completion: @escaping (String) -> Void) {
        getAccount { account in
            guard let value = account.balance.asCurrency() else { return }
            completion(value)
        }
    }

    func configureDataExtract(with transfer: Transfer) -> ExtractTableViewCell.ViewModel {
        if transfer.payerName == userName {
            return .init(extractEnum: .transferred, name: transfer.receiverName, value: transfer.value.asCurrency())
        } else {
            return .init(extractEnum: .received, name: transfer.payerName, value: transfer.value.asCurrency())
        }
    }
}
