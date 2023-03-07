import Foundation
import UIKit

protocol BankInteracting: AnyObject {
    func loadData()
}

final class BankInteractor {
    private let service: BankServicing
    private let presenter: BankPresenting
    private var roomName: String = ""

    init(service: BankServicing, presenter: BankPresenting) {
        self.service = service
        self.presenter = presenter
    }
}

// MARK: - BankInteracting
extension BankInteractor: BankInteracting {
    func loadData() {
        getRoomName()
        getAccounts()
        setupActionMenu()
    }
}

private extension BankInteractor {
    func getAccounts() {
        service.getAccounts(roomName: roomName) {[weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let data):
                self.presenter.display(accounts: data)
            case .failure:
                // Next PR
                break
            }
        }
    }
    
    func getRoomName() {
        if let name = UserDefaults.standard.string(forKey: "Room") {
            roomName = name
            presenter.display(roomName: name)
        }
    }
    
    func setupActionMenu() {
        let menu = [
            MenuCollectionItem(icon: .pay,
                               title: "Pay",
                               action: {
                                   self.presenter.openBankPayScreen()
                               }),
            MenuCollectionItem(icon: .charge,
                               title: "Charge",
                               action: {
                                   self.presenter.openBankChargeScreen()
                               }),
            MenuCollectionItem(icon: .room,
                               title: "Delete Room",
                               action: {
                                   self.didTapDeleteRoomButton()
                               })
        ]
        
        presenter.display(items: menu)
    }

    func didTapDeleteRoomButton() {
        presenter.presentDeleteRoomActionSheet { [weak self] _ in
            self?.deleteRoom()
        }
    }
    
    func deleteRoom() {
        print("Did tap delete room")
    }
}
