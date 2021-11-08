import UIKit
@testable import EasyBank

final class NewRoomViewModelSpy: NewRoomViewModelProtocol {
    private(set) var validateRoomCalled = false

    func validateRoom(with roomName: String) {
        validateRoomCalled = true
    }
}
