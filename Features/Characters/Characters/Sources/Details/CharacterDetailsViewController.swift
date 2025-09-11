import DesignSystem
import UIKit

protocol CharacterDetailsDisplaying: AnyObject {
    func displayDetails(_ detail: CharacterDetailsDTO)
}

final class CharacterDetailsViewController: UIViewController {
    private typealias Localizable = Strings.Details
    // MARK: - Attributes
    private let interactor: CharacterDetailsInteracting
    
    // MARK: Layout Attributes
    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .insetGrouped)
        tableView.backgroundColor = .systemBackground
        tableView.separatorStyle = .none
        tableView.contentInsetAdjustmentBehavior = .always
        tableView.estimatedRowHeight = 64
        tableView.rowHeight = UITableView.automaticDimension
        tableView.register(KeyValueCell.self, forCellReuseIdentifier: KeyValueCell.reuseID)
        tableView.register(StatCell.self, forCellReuseIdentifier: StatCell.reuseID)
        tableView.register(DSSectionHeader.self, forHeaderFooterViewReuseIdentifier: DSSectionHeader.reuseID)
        tableView.sectionHeaderTopPadding = 12
        tableView.delegate = self
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    private enum Section: Hashable {
        case info
        case stats
    }
    
    private enum Item: Hashable {
        case info(key: String, value: String)
        case stat(key: String, value: Int)
    }
    
    private lazy var dataSource: UITableViewDiffableDataSource<Section, Item> = {
        let dataSource = UITableViewDiffableDataSource<Section, Item>(tableView: tableView) { tableView, indexPath, item in
            switch item {
            case let .info(key, value):
                let cell = tableView.dequeueReusableCell(withIdentifier: KeyValueCell.reuseID, for: indexPath) as! KeyValueCell
                cell.configure(title: key, value: value)
                return cell
            case let .stat(name, value):
                let cell = tableView.dequeueReusableCell(withIdentifier: StatCell.reuseID, for: indexPath) as! StatCell
                cell.configure(name: name, value: value)
                return cell
            }
        }
        
        dataSource.defaultRowAnimation = .fade
        return dataSource
    }()
    
    // MARK: - Initializer
    init(
        interactor: CharacterDetailsInteracting,
        title: String
    ) {
        self.interactor = interactor
        super.init(nibName: nil, bundle: nil)
        self.title = title.capitalized
        interactor.loadDetails()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureAppearance()
        configureTable()
        prepareEmptySnapshot()
    }
    
    // MARK: - LayoutFunctions
    private func configureAppearance() {
        applyTransparentNavBar()
        view.backgroundColor = .systemBackground
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.largeTitleDisplayMode = .always
    }
    
    private func configureTable() {
        view.addSubview(tableView)
        tableView.dataSource = dataSource
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    private func prepareEmptySnapshot() {
        var snap = NSDiffableDataSourceSnapshot<Section, Item>()
        snap.appendSections([.info, .stats])
        dataSource.apply(snap, animatingDifferences: false)
    }
}

// MARK: - UITableViewDelegate
extension CharacterDetailsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: DSSectionHeader.reuseID) as? DSSectionHeader
        switch dataSource.snapshot().sectionIdentifiers[section] {
        case .info:
            header?.configure(title: Localizable.informations)
        case .stats:
            header?.configure(title: Localizable.stats)
        }
        return header
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        44
    }
}

// MARK: - CharacterDetailsDisplaying
extension CharacterDetailsViewController: CharacterDetailsDisplaying {
    func displayDetails(_ details: CharacterDetailsDTO) {
        var snap = NSDiffableDataSourceSnapshot<Section, Item>()
        snap.appendSections([.info, .stats])
        
        snap.appendItems([
            .info(
                key: Localizable.experience,
                value: Localizable.experienceValue(details.informations.experience)
            ),
            .info(
                key: Localizable.height,
                value: Localizable.heightValue(details.informations.height)
            ),
            .info(
                key: Localizable.weight,
                value: Localizable.weightValue(details.informations.weight)
            ),
        ], toSection: .info)
        
        snap.appendItems(
            details.attributes.map { .stat(key: $0.stat.name, value: $0.base) },
            toSection: .stats)
        
        dataSource.applySnapshotUsingReloadData(snap)
    }
}
