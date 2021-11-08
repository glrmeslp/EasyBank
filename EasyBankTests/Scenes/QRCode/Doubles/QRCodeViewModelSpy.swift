@testable import EasyBank

final class QRCodeViewModelSpy: QRCodeViewModelProtocol {
    private(set) var didFinishCalled = false
    var stringForQRCodeToBeReturn: String?
    var valueToBeReturn: Double?
    
    func didFinish() {
        didFinishCalled = true
    }
    
    func generateStringForQRcode(completion: @escaping (String) -> Void) {
        guard let stringForQRCodeToBeReturn = stringForQRCodeToBeReturn else {
            return
        }
        completion(stringForQRCodeToBeReturn)
    }
    
    func getValue(completion: @escaping (String) -> Void) {
        guard valueToBeReturn == 0.0 else {
            guard let value = valueToBeReturn?.asCurrency() else { return }
            completion(value)
            return
        }
        completion("Will be defined by who will pay")
    }
}
