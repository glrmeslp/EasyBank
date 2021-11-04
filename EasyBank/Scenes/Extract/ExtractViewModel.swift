import Foundation

final class ExtractViewModel: UserViewModel{

    private let transferService: TransferDatabaseService
    private let roomName: String? = UserDefaults.standard.string(forKey: "Room")

    init(databaseService: DatabaseService, authService: AuthService) {
        self.transferService = databaseService
        super.init(authService: authService)
    }

    func getAllTransfers(completion: @escaping ([Transfer]) -> Void){
        guard let name = user?.name else { return }
//        transferService.getAllTransfers(roomName: roomName, name: name ) { tranfers in
//            let sortedTranfers = tranfers.sorted { $0.payDate.dateValue() > $1.payDate.dateValue() }
//            completion(sortedTranfers)
//        }
    }

    func getBalance(completion: @escaping (String) -> Void) {
        guard let uid = user?.identifier else { return }
//        getAccount(uid: uid) { account in
//            guard let value = account.balance.asCurrency() else { return }
//            completion(value)
//        }
    }

    func configureDataExtract(with transfer: Transfer) -> ExtractTableViewCell.ViewModel {
        if transfer.payerName == user?.name {
            return .init(extractEnum: .transferred, name: transfer.receiverName, value: transfer.value.asCurrency())
        } else {
            return .init(extractEnum: .received, name: transfer.payerName, value: transfer.value.asCurrency())
        }
    }
}
