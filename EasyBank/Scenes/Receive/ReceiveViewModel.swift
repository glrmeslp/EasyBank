protocol ReceiveViewModelCoordinatorDelegate: AnyObject {
    func didFinisih()
}

final class ReceiveViewModel {
    private var uid: String?

    private weak var coordinatorDelegate: ReceiveViewModelCoordinatorDelegate?

    init(uid: String, coordinator: ReceiveViewModelCoordinatorDelegate) {
        self.uid = uid
        self.coordinatorDelegate = coordinator
    }

    func getUid(completion: @escaping (String) -> Void) {
        guard let uid = uid else { return }
        completion(uid)
    }

    func didFinish() {
        coordinatorDelegate?.didFinisih()
    }
}
