import UIKit
@testable import EasyBank

final class ExtractViewModelSpy: ExtractViewModelDelegate {
    var transfersToBeReturn: [Transfer]?
    var balanceToBeReturn: String?
    var userName: String?
    
    func fetchAllTransfers(completion: @escaping ([Transfer]) -> Void) {
        guard let transfersToBeReturn = transfersToBeReturn else {
            return
        }
        completion(transfersToBeReturn)
    }
    
    func fetchBalance(completion: @escaping (String) -> Void) {
        guard let balanceToBeReturn = balanceToBeReturn else {
            return
        }
        completion(balanceToBeReturn)
    }
    
    func configureDataExtract(with transfer: Transfer) -> ExtractTableViewCell.ViewModel {
        if transfer.payerName == userName {
            return .init(extractEnum: .transferred, name: transfer.receiverName, value: transfer.value.asCurrency())
        } else {
            return .init(extractEnum: .received, name: transfer.payerName, value: transfer.value.asCurrency())
        }
    }
}
