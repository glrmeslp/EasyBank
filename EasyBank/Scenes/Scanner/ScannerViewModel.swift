import UIKit

protocol ScannerViewModelDelegate {
    func validateQRCode(code: String, handler: ((UIAlertAction) -> Void)?)
    func presentFailedAlert()
}

final class ScannerViewModel: ScannerViewModelDelegate {

    private let roomService: RoomService
    private weak var coordinatorDelegate: ScannerViewModelCoordinatorDelegate?

    init(coordinator: ScannerViewModelCoordinatorDelegate, roomService: RoomService) {
        self.coordinatorDelegate = coordinator
        self.roomService = roomService
    }

    func validateQRCode(code: String, handler: ((UIAlertAction) -> Void)?) {
        if QRCodeHelper().isQRCodeValid(value: code) {
            isAccountExists(code: code, handler: handler)
        } else {
            presentQRCodeInvalidAlert(handler: handler)
        }
    }

    private func isAccountExists(code: String, handler: ((UIAlertAction) -> Void)?) {
         let splittedCode = splitCode(code)
         roomService.getAccount(roomName: splittedCode[1].first ?? "",
                                uid: splittedCode[1].last ?? "") { [weak self] account, _ in
             guard account == nil else {
                 self?.coordinatorDelegate?.pushToPayViewController(with: splittedCode[0])
                 return
             }
             self?.presentQRCodeInvalidAlert(handler: handler)
         }
     }

    private func presentQRCodeInvalidAlert(handler: ((UIAlertAction) -> Void)?) {
        coordinatorDelegate?.presentAlert(title: "Oops! Something went wrong",
                                          message: "This payment has not been completed because this QR code is invalid.",
                                          and: handler)
    }

    func presentFailedAlert() {
        coordinatorDelegate?.presentAlert(title: "Scanning not supported",
                                          message: "Your device does not support scanning a code from an item. Please use a device with a camera.",
                                          and: nil)
    }

    private func splitCode(_ code: String) -> [[String]] {
        var splittedCode = code.components(separatedBy: "00X00")
        splittedCode.removeFirst()
        var data = splittedCode
        var accountInformations = data
        accountInformations.removeLast()
        data.removeFirst()
        return [data, accountInformations]
    }
}
