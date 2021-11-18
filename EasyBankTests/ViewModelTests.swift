
import Quick
import Nimbleck
@testable import EasyBank

final class ViewModelTests: QuickSpec {
    override func spec() {
        var sut: BankViewModel!
        var roomServiceSpy: DatabaseServiceSpy!
        
        beforeEach {
            UserDefaults.standard.set("Room01", forKey: "Room")
            roomServiceSpy = DatabaseServiceSpy()
            sut = BankViewModel(roomService: roomServiceSpy)
        }
        
        describe("#fetchRoomName") {
            var result: String!
            
            beforeEach {
                sut.fetchRoomName { name in
                    result = name
                }
            }
            
            it("deveria retornar nome da sala correto") {
                expect(result) == "Room01"
            }
        }
    }
}
