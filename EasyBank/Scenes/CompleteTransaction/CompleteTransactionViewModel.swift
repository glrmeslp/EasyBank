import UIKit

final class CompleteTransactionViewModel {

    private let transferService: TransferDatabaseService
    private let transferId: String
    private let roomName: String
    private var coordinatorDelegate: CompleteTransactionViewModelCoordinatorDelegate?

    init(transferService: TransferDatabaseService, transferId: String, roomName: String, coordinator: CompleteTransactionViewModelCoordinatorDelegate) {
        self.transferService = transferService
        self.transferId = transferId
        self.roomName = roomName
        self.coordinatorDelegate = coordinator
    }

    func getTransaction(completion: @escaping (Transfer, String) -> Void) {
        transferService.getTransfer(roomName: roomName, documentId: transferId) { transfer, _ in
            guard let transfer = transfer else { return }
            completion(transfer, self.transferId)
        }
    }

    func showHomeViewController(from controller: UIViewController) {
        coordinatorDelegate?.pushToHomeViewController(from: controller)
    }
}
