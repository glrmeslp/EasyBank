import UIKit

final class ScannerViewModel {

    private let roomService: RoomService
    private var coordinatorDelegate: ScannerViewModelCoordinatorDelegate?

    init(coordinator: ScannerViewModelCoordinatorDelegate, roomService: RoomService) {
        self.coordinatorDelegate = coordinator
        self.roomService = roomService
    }

    func validateQRCode(with code: String, from controller: UIViewController, completion: @escaping (Bool) -> Void) {
        var splittedCode = code.components(separatedBy: "00X00")
        splittedCode.removeFirst()
        let data = splittedCode
        var accountInformations = data
        accountInformations.removeLast()
        if QRCodeHelper().isQRCodeValid(value: code) {
            isAccountExists(split: accountInformations) { [weak self] value in
                completion(value)
                if value {
                    self?.coordinatorDelegate?.pushToPayViewController(with: data)
                }
            }
        } else {
            completion(false)
        }
    }

    private func isAccountExists(split: [String], completion: @escaping (Bool) -> Void) {
        roomService.getAccount(roomName: split.first ?? "", uid: split.last ?? "") { account, _ in
            if account != nil {
                completion(true)
            } else {
                completion(false)
            }
        }
    }
}
