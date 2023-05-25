import UIKit

@IBDesignable
class TabButton: UIView {
    @IBInspectable
    var title: String? {
        didSet {
            updateUI()
        }
    }
    var selected = false {
        didSet {
            updateUI()
        }
    }

    private var handler: ((TabButton) -> Void)?

    private let label = UILabel()
    private let control = UIControl()
    private let padding: CGFloat = 8

    private let highlightBackground = UIColor.label
    private let textColor = (UIColor.label, UIColor.systemBackground)

    override init(frame: CGRect) {
        super.init(frame: frame)
        setUI()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setUI()
    }

    init(title: String) {
        super.init(frame: .zero)
        self.title = title
        setUI()
    }

    private func setUI() {
        addSubview(control)
        control.translatesAutoresizingMaskIntoConstraints = false
        control.topAnchor.constraint(equalTo: topAnchor).isActive = true
        control.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        control.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        control.rightAnchor.constraint(equalTo: rightAnchor).isActive = true

        label.font = UIFont.preferredFont(forTextStyle: .title1)
        control.addSubview(label)

        label.translatesAutoresizingMaskIntoConstraints = false
        label.topAnchor.constraint(equalTo: control.topAnchor, constant: padding).isActive = true
        label.bottomAnchor.constraint(equalTo: control.bottomAnchor, constant: -padding).isActive = true
        label.leftAnchor.constraint(equalTo: control.leftAnchor, constant: padding).isActive = true
        label.rightAnchor.constraint(equalTo: control.rightAnchor, constant: -padding).isActive = true
        layer.cornerRadius = 8

        control.addTarget(self, action: #selector(didTap), for: .touchUpInside)

        updateUI()
    }

    private func updateUI() {
        label.text = title
        backgroundColor = selected ? highlightBackground : nil
        label.textColor = selected ? textColor.1 : textColor.0
    }

    override var intrinsicContentSize: CGSize {
        return CGSize(width: label.intrinsicContentSize.width + padding * 2, height: label.intrinsicContentSize.height + padding * 2)
    }

    func onTap(_ handler: @escaping (TabButton) -> Void) {
        self.handler = handler
    }

    @objc private func didTap() {
        handler?(self)
    }
}
