import UIKit

final class StatCell: UITableViewCell {
    static let reuseID = "StatCell"

    private let card: UIView = {
        let view = UIView()
        view.backgroundColor = .secondarySystemBackground
        view.layer.cornerCurve = .continuous
        view.layer.cornerRadius = 16
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOpacity = 0.06
        view.layer.shadowRadius = 8
        view.layer.shadowOffset = CGSize(width: 0, height: 4)
        return view
    }()
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.font = .preferredFont(forTextStyle: .body)
        label.adjustsFontForContentSizeCategory = true
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let valueLabel: UILabel = {
        let label = UILabel()
        label.font = .preferredFont(forTextStyle: .body)
        label.adjustsFontForContentSizeCategory = true
        label.textColor = .secondaryLabel
        label.textAlignment = .right
        label.setContentCompressionResistancePriority(.required, for: .horizontal)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let progress: UIProgressView = {
        let progress = UIProgressView(progressViewStyle: .default)
        progress.translatesAutoresizingMaskIntoConstraints = false
        progress.trackTintColor = .tertiarySystemFill
        progress.progressTintColor = .systemGray
        progress.layer.cornerRadius = 3
        progress.clipsToBounds = true
        progress.translatesAutoresizingMaskIntoConstraints = false
        return progress
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        backgroundColor = .clear
        contentView.backgroundColor = .clear
        setup()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configure(name: String, value: Int) {
        nameLabel.text = name
        valueLabel.text = "\(value)"
        let clamped = max(0, min(100, value))
        progress.setProgress(Float(clamped) / 100.0, animated: false)
    }

    private func setup() {
        contentView.addSubview(card)
        card.addSubview(nameLabel)
        card.addSubview(valueLabel)
        card.addSubview(progress)

        NSLayoutConstraint.activate([
            card.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            card.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            card.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            card.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),

            nameLabel.topAnchor.constraint(equalTo: card.topAnchor, constant: 12),
            nameLabel.leadingAnchor.constraint(equalTo: card.leadingAnchor, constant: 16),
            nameLabel.trailingAnchor.constraint(lessThanOrEqualTo: valueLabel.leadingAnchor, constant: -8),

            valueLabel.centerYAnchor.constraint(equalTo: nameLabel.centerYAnchor),
            valueLabel.trailingAnchor.constraint(equalTo: card.trailingAnchor, constant: -16),

            progress.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 8),
            progress.leadingAnchor.constraint(equalTo: card.leadingAnchor, constant: 16),
            progress.trailingAnchor.constraint(equalTo: card.trailingAnchor, constant: -16),
            progress.bottomAnchor.constraint(equalTo: card.bottomAnchor, constant: -12),
            progress.heightAnchor.constraint(equalToConstant: 6)
        ])
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        card.layer.shadowPath = UIBezierPath(roundedRect: card.bounds, cornerRadius: 16).cgPath
    }
}
