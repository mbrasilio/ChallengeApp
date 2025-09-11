import UIKit

public final class LoadMoreFooterView: UIView {
    private typealias Localizable = Strings.LoadMoreFooterView
    public enum State { case ready, loading, end }

    public var onTapLoadMore: (() -> Void)?
    public var onNeedsLayoutUpdate: (() -> Void)?

    // MARK: - Subviews
    private let loadMoreButton: UIButton = {
        var config = UIButton.Configuration.filled()
        config.title = Localizable.loadMore
        config.baseBackgroundColor = .systemBackground
        config.baseForegroundColor = .systemBlue
        config.cornerStyle = .medium
        config.contentInsets = NSDirectionalEdgeInsets(top: 12, leading: 16, bottom: 12, trailing: 16)

        let button = UIButton(configuration: config)
        button.titleLabel?.font = .preferredFont(forTextStyle: .headline)
        button.layer.cornerCurve = .continuous
        return button
    }()

    private let spinner: UIActivityIndicatorView = {
        let view = UIActivityIndicatorView(style: .medium)
        view.hidesWhenStopped = true
        return view
    }()

    private let endLabel: UILabel = {
        let label = UILabel()
        label.text = Localizable.allLoaded
        label.textColor = .secondaryLabel
        label.font = .preferredFont(forTextStyle: .footnote)
        return label
    }()

    private let stack: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.spacing = 12
        stackView.isLayoutMarginsRelativeArrangement = true
        stackView.layoutMargins = UIEdgeInsets(top: 16, left: 16, bottom: 24, right: 16)
        return stackView
    }()

    private var currentState: State = .ready

    // MARK: - Init
    public override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    public required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }

    private func setup() {
        backgroundColor = .clear

        addSubview(stack)
        [loadMoreButton, spinner, endLabel].forEach { stack.addArrangedSubview($0) }

        stack.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            stack.topAnchor.constraint(equalTo: topAnchor),
            stack.leadingAnchor.constraint(equalTo: leadingAnchor),
            stack.trailingAnchor.constraint(equalTo: trailingAnchor),
            stack.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])

        loadMoreButton.addTarget(self, action: #selector(handleTap), for: .touchUpInside)

        setState(.ready)
    }

    // MARK: - Actions
    @objc
    private func handleTap() {
        onTapLoadMore?()
    }

    // MARK: - API
    public func setState(_ newState: State) {
        guard newState != currentState else { return }
        currentState = newState

        switch newState {
        case .ready:
            loadMoreButton.isHidden = false
            loadMoreButton.isEnabled = true
            spinner.stopAnimating()
            endLabel.isHidden = true

        case .loading:
            loadMoreButton.isHidden = true
            loadMoreButton.isEnabled = false
            spinner.startAnimating()
            endLabel.isHidden = true

        case .end:
            loadMoreButton.isHidden = true
            loadMoreButton.isEnabled = false
            spinner.stopAnimating()
            endLabel.isHidden = false
        }

        onNeedsLayoutUpdate?()
    }

    public override var intrinsicContentSize: CGSize {
        CGSize(width: UIView.noIntrinsicMetric, height: currentState == .end ? 64 : 96)
    }
}
