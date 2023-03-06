import SnapKit
import UIKit

final class RoomHeaderView: UIView {
    private lazy var stackVerticalView: UIStackView = {
        let stackView = UIStackView()
        stackView.backgroundColor = .clear
        stackView.axis = .vertical
        stackView.spacing = 20
        return stackView
    }()
    
    private lazy var stackHorizontalView: UIStackView = {
        let stackView = UIStackView()
        stackView.backgroundColor = .clear
        stackView.axis = .horizontal
        stackView.alignment = .fill
        stackView.distribution = .fillEqually
        return stackView
    }()

    private lazy var lineView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(named: "BlueColor")
        return view
    }()

    private lazy var roomLabel: UILabel = {
        let label = UILabel()
        label.text = "Room"
        label.font = .boldSystemFont(ofSize: 14)
        return label
    }()

    private lazy var roomNameLabel: UILabel = {
        let label = UILabel()
        label.text = "Room Name"
        label.font = .systemFont(ofSize: 14)
        label.textColor = .systemGray
        label.textAlignment = .right
        return label
    }()
    
    init() {
        super.init(frame: .zero)
        buildLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension RoomHeaderView: ViewConfiguration {
    func buildViewHierarchy() {
        stackVerticalView.addArrangedSubview(stackHorizontalView)
        stackVerticalView.addArrangedSubview(lineView)
        stackHorizontalView.addArrangedSubview(roomLabel)
        stackHorizontalView.addArrangedSubview(roomNameLabel)
        addSubview(stackVerticalView)
    }
    
    func setupConstraints() {
        stackVerticalView.snp.makeConstraints {
            $0.top.bottom.equalToSuperview()
            $0.leading.trailing.equalToSuperview().inset(20)
        }
        
        lineView.snp.makeConstraints {
            $0.height.equalTo(1)
        }
    }
}
