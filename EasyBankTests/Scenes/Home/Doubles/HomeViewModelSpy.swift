@testable import EasyBank

final class HomeViewModelSpy: HomeViewModelProtocol {
    private(set) var fetchBalanceCalled = false
    private(set) var fetchInformationCalled = false
    private(set) var fecthUserNameCalled = false
    private(set) var showReceiveViewControlleCalled = false
    private(set) var showPayViewControllerCalled = false
    private(set) var showHomeMenuViewControllerCalled = false
    private(set) var showExtractViewControllerCalled = false
    var fetchBalanceToBeReturned: Double?
    private let transferMenu: [[String]] = [
        ["Pay QR Code","qrcode"],
        ["Receive","ReceiveIcon"]
    ]
    var roomName: String?
    var fecthUserNameToBeReturned: String?
    
    func fetchBalance(completion: @escaping (String) -> Void) {
        fetchBalanceCalled = true
        guard let value = fetchBalanceToBeReturned?.asCurrency() else { return }
        completion(value)
    }
    
    func fetchInformation(completion: @escaping ([[String]], String) -> Void) {
        fetchInformationCalled = true
        guard let roomName = roomName else {
            return
        }
        completion(transferMenu, roomName)
    }
    
    func fetchUserName(completion: @escaping (String?) -> Void) {
        fecthUserNameCalled = true
        completion(fecthUserNameToBeReturned)
    }
    
    func showReceiveViewController() {
        showReceiveViewControlleCalled = true
    }
    
    func showPayViewController() {
        showPayViewControllerCalled = true
    }
    
    func showHomeMenuViewController() {
        showHomeMenuViewControllerCalled = true
    }
    
    func showExtractViewController() {
        showExtractViewControllerCalled = true
    }
    
    
}
