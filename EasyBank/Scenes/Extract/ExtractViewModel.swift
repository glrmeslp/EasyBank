import Foundation

protocol ExtractViewModelDelegate {
    func fetchAllTransfers(completion: @escaping ([Transfer]) -> Void)
    func fetchBalance(completion: @escaping (String) -> Void)
    func configureDataExtract(with transfer: Transfer) -> ExtractTableViewCell.ViewModel
}

final class ExtractViewModel: UserViewModel, ExtractViewModelDelegate{

    private let transferService: TransferDatabaseService
    private let roomService: RoomService
    private let roomName: String? = UserDefaults.standard.string(forKey: "Room")

    init(transferService: TransferDatabaseService, authService: AuthService, roomService: RoomService) {
        self.transferService = transferService
        self.roomService = roomService
        super.init(authService: authService)
    }

    func fetchAllTransfers(completion: @escaping ([Transfer]) -> Void){
        guard let name = user?.name, let roomName = roomName else { return }
        transferService.getAllTransfers(roomName: roomName, name: name ) { tranfers in
            let sortedTranfers = tranfers.sorted { $0.payDate.dateValue() > $1.payDate.dateValue() }
            completion(sortedTranfers)
        }
    }

    func fetchBalance(completion: @escaping (String) -> Void) {
        guard let uid = user?.identifier, let roomName = roomName else { return }
        roomService.getAccount(roomName: roomName, uid: uid) { account, _  in
            guard let value = account?.balance.asCurrency() else { return }
            completion(value)
        }
    }

    func configureDataExtract(with transfer: Transfer) -> ExtractTableViewCell.ViewModel {
        if transfer.payerName == user?.name {
            return .init(extractEnum: .transferred, name: transfer.receiverName, value: transfer.value.asCurrency())
        } else {
            return .init(extractEnum: .received, name: transfer.payerName, value: transfer.value.asCurrency())
        }
    }
}
