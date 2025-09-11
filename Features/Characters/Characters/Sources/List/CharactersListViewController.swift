import UIKit
import DesignSystem

protocol CharactersListDisplaying: AnyObject {
    func displayInitialList(_ list: [CharactersListDTO])
    func displayNewItems(_ list: [CharactersListDTO])
    func displayLoading(isRefreshing: Bool)
    func displayFinishedLoading()
    func displayCanLoadMore(_ canLoadMore: Bool)
}

final class CharactersListViewController: UIViewController {
    // MARK: - Attributes
    private let interactor: CharactersListInteracting
    private var isLoading = false
    
    // MARK: - Layout Attributes
    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.backgroundColor = .clear
        tableView.separatorStyle = .none
        tableView.rowHeight = 72
        tableView.estimatedRowHeight = 72
        tableView.register(DSCell.self, forCellReuseIdentifier: DSCell.reuseID)
        tableView.delegate = self
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    private enum Section { case main }
    
    private lazy var dataSource: UITableViewDiffableDataSource<Section, CharactersListDTO> = {
        UITableViewDiffableDataSource<Section, CharactersListDTO>(
            tableView: tableView
        ) { tableView, indexPath, item in
            let cell = tableView.dequeueReusableCell(withIdentifier: DSCell.reuseID, for: indexPath) as? DSCell
            cell?.configure(name: item.name)
            return cell
        }
    }()
    
    private let loadMoreFooter = LoadMoreFooterView()
    
    // MARK: - Initializer
    init(interactor: CharactersListInteracting) {
        self.interactor = interactor
        super.init(nibName: nil, bundle: nil)
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
        configureDataSource()
        configureFooter()
        interactor.loadInitialCharacters()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        updateFooterHeight()
    }

    // MARK: - LayoutFunctions
    private func configureAppearance() {
        view.backgroundColor = .systemBackground
        title = "Pokédex"
        navigationController?.navigationBar.prefersLargeTitles = true
        applyTransparentNavBar()
    }
    
    private func configureTable() {
        view.addSubview(tableView)
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }

    private func configureDataSource() {
        tableView.dataSource = dataSource
        var snap = NSDiffableDataSourceSnapshot<Section, CharactersListDTO>()
        snap.appendSections([.main])
        dataSource.apply(snap, animatingDifferences: false)
    }
    
    private func configureFooter() {
        loadMoreFooter.onTapLoadMore = { [weak self] in
            guard let self, !self.isLoading else { return }
            self.interactor.loadNextCharacters()
        }
        loadMoreFooter.onNeedsLayoutUpdate = { [weak self] in
            self?.updateFooterHeight()
        }

        tableView.tableFooterView = loadMoreFooter
        updateFooterHeight()
    }
    
    private func updateFooterHeight() {
        guard let footer = tableView.tableFooterView else { return }
        let targetWidth = tableView.bounds.width
        let fittingSize = CGSize(width: targetWidth, height: UIView.layoutFittingCompressedSize.height)
        let size = footer.systemLayoutSizeFitting(
            fittingSize,
            withHorizontalFittingPriority: .required,
            verticalFittingPriority: .fittingSizeLevel
        )
        if footer.frame.size.height != size.height {
            footer.frame.size.height = size.height
            tableView.tableFooterView = footer // reatribui pra aplicar
        }
    }
}

// MARK: - UITableViewDelegate
extension CharactersListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // TODO: delegar seleção para interactor
    }
}

// MARK: - CharactersListDisplaying
extension CharactersListViewController: CharactersListDisplaying {
    func displayInitialList(_ list: [CharactersListDTO]) {
        var snap = NSDiffableDataSourceSnapshot<Section, CharactersListDTO>()
        snap.appendSections([.main])
        snap.appendItems(list, toSection: .main)
        dataSource.apply(snap, animatingDifferences: false)
    }
    
    func displayNewItems(_ list: [CharactersListDTO]) {
        var snap = dataSource.snapshot()
        if snap.sectionIdentifiers.isEmpty { snap.appendSections([.main]) }
        snap.appendItems(list, toSection: .main)
        dataSource.apply(snap, animatingDifferences: true)
    }

    func displayLoading(isRefreshing: Bool) {
        isLoading = true
        loadMoreFooter.setState(.loading)
    }

    func displayFinishedLoading() {
        isLoading = false
    }

    func displayCanLoadMore(_ canLoadMore: Bool) {
        loadMoreFooter.setState(canLoadMore ? .ready : .end)
    }
}
