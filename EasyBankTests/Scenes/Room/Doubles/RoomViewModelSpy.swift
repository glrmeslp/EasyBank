@testable import EasyBank

final class RoomViewModelSpy: RoomViewModelProtocol {
    private(set) var enterCalled = false
    
    func enter(_ roomName: String) {
        enterCalled = true
    }
}
