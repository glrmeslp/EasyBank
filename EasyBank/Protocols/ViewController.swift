import UIKit

protocol ViewConfiguration: AnyObject {
    func buildViewHierarchy()
    func setupConstraints()
    func configureViews()
    func buildLayout()
}

extension ViewConfiguration {
    func buildLayout() {
        buildViewHierarchy()
        setupConstraints()
        configureViews()
    }

    func configureViews() { }
}

class ViewController<Interactor, V: UIView>: UIViewController, ViewConfiguration {
    let interactor: Interactor
    var rootView = V()

    init(interactor: Interactor) {
        self.interactor = interactor
        super.init(nibName: nil, bundle: nil)
    }

    @available(*, unavailable)
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        buildLayout()
    }

    override func loadView() {
        view = rootView
    }

    func buildViewHierarchy() { }

    func setupConstraints() { }
    
    func configureViews() { }
}

extension ViewController where Interactor == Void {
    convenience init(_ interactor: Interactor = ()) {
        self.init(interactor: interactor)
    }
}
