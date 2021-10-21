import UIKit

protocol AccountViewModelProtocol {
    func presentLeaveRoomActionSheet()
    func presentDeleteAccountActionSheet()
    func presentUpdateNameActionSheet(handler: ((UIAlertAction) -> Void)?)
    func presentUpdateEmailActionSheet(handler: ((UIAlertAction) -> Void)?)
    func deleteEasyBankAccount()
    func manageProfileInformation()
    func fetchData(completion: @escaping (String, User?) -> Void)
}

final class AccountViewModel: UserViewModel, AccountViewModelProtocol {

    private var coordinatorDelegate: AccountViewModelCoordinatorDelegate?
    private let roomService: RoomService
    private let roomName: String

    init(roomName: String, authService: AuthService, roomService: RoomService, coordinator: AccountViewModelCoordinatorDelegate) {
        self.coordinatorDelegate = coordinator
        self.roomService = roomService
        self.roomName = roomName
        super.init(authService: authService)
    }

    func presentLeaveRoomActionSheet() {
        coordinatorDelegate?.presentLeaveRoomActionSheet()
    }

    func presentDeleteAccountActionSheet() {
        coordinatorDelegate?.presentDeleteAccountActionSheet { [weak self] _ in
            self?.deleteAccount()
        }
    }

    func presentUpdateNameActionSheet(handler: ((UIAlertAction) -> Void)?) {
        coordinatorDelegate?.presentUpdateNameActionSheet(handler: handler)
    }

    func presentUpdateEmailActionSheet(handler: ((UIAlertAction) -> Void)?) {
        coordinatorDelegate?.presentUpdateEmailActionSheet(handler: handler)
    }

    private func deleteAccount() {
        guard let uid = user?.identifier else { return }
        roomService.deleteAccount(roomName: roomName, uid: uid) { [weak self] error in
            guard let error = error else {
                self?.coordinatorDelegate?.pushToStartViewController()
                return
            }
            self?.coordinatorDelegate?.presentAlert(message: error)
        }
    }

    func deleteEasyBankAccount() {
        coordinatorDelegate?.presentReauthenticateViewController(for: .deleteUser)
    }

    func manageProfileInformation() {
        coordinatorDelegate?.presentReauthenticateViewController(for: .updateUserInformation)
    }

    func fetchData(completion: @escaping (String, User?) -> Void) {
        getUser()
        completion(roomName,user)
    }
}
