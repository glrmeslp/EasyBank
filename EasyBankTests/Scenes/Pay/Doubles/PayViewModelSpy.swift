
import UIKit
@testable import EasyBank

final class PayViewModelSpy: PayViewModelDelegate {
    var balanceToBeReturn: String?
    var valueToBeReturn: Double?
    var receiverNameToBeReturn: String?
    private(set) var handlerReturned: ((UIAlertAction) -> Void)? = nil
    private(set) var presentConfirmAlertCalled = false
    
    func fetchBalance(completion: @escaping (String) -> Void) {
        guard let balanceToBeReturn = balanceToBeReturn else {
            return
        }
        completion(balanceToBeReturn)
    }
    
    func fetchData(completion: @escaping (String, Double) -> Void) {
        guard let valueToBeReturn = valueToBeReturn,
        let receiverNameToBeReturn = receiverNameToBeReturn else {
            return
        }
        completion(receiverNameToBeReturn,valueToBeReturn)
    }
    
    func transfer(value: String, handler: ((UIAlertAction) -> Void)?) {
        
    }
    
    func presentConfirmAlert(handler: ((UIAlertAction) -> Void)?) {
        presentConfirmAlertCalled = true
        handlerReturned = handler
    }
    

}
