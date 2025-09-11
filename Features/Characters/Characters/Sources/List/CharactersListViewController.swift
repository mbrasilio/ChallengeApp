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
        tableView.refreshControl = refresh
        tableView.delegate = self
        tableView.prefetchDataSource = self
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
    
    private let refresh = UIRefreshControl()
    
    private lazy var footerSpinner: UIActivityIndicatorView = {
        let indicatorView = UIActivityIndicatorView(style: .medium)
        indicatorView.hidesWhenStopped = true
        indicatorView.startAnimating()
        return indicatorView
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
    
    // MARK: - LayoutFunctions
    private func configureAppearance() {
        view.backgroundColor = .systemBackground
        title = "Pokédex"
        navigationController?.navigationBar.prefersLargeTitles = true
        applyTransparentNavBar()
    }
    
    private func configureTable() {
        refresh.addTarget(self, action: #selector(onPullToRefresh), for: .valueChanged)

        view.addSubview(tableView)
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }

    private func configureDataSource() {
        var snap = NSDiffableDataSourceSnapshot<Section, CharactersListDTO>()
        snap.appendSections([.main])
        dataSource.apply(snap, animatingDifferences: false)
        tableView.dataSource = dataSource
    }
    
    private func showFooterSpinner(_ show: Bool) {
        tableView.tableFooterView = show ? footerSpinner : UIView(frame: .zero)
        tableView.tableFooterView?.frame.size.height = show ? 56 : 0
        if show { footerSpinner.startAnimating() } else { footerSpinner.stopAnimating() }
    }
    
    @objc
    func onPullToRefresh() {
        interactor.loadNextCharacters()
    }
    
    private func configureFooter() {
        loadMoreFooter.onTapLoadMore = { [weak self] in
            guard let self, !self.isLoading else { return }
            self.interactor.loadNextCharacters()
        }
        loadMoreFooter.onNeedsLayoutUpdate = { [weak self] in
            self?.updateFooterHeight()
        }

        // aplica como tableFooterView
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
            tableView.tableFooterView = footer
        }
    }
}

// MARK: - UITableViewDelegate & UITableViewDataSourcePrefetching
extension CharactersListViewController: UITableViewDelegate, UITableViewDataSourcePrefetching {
    func tableView(_ tableView: UITableView,
                   willDisplay cell: UITableViewCell,
                   forRowAt indexPath: IndexPath) {
        guard !isLoading else { return }
        
        let total = dataSource.snapshot().numberOfItems
        let isLastCell = indexPath.row == total - 1
        if isLastCell {
            interactor.loadNextCharacters()
        }
    }
    
    func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
        guard !isLoading else { return }
//        if indexPaths.contains(where: { $0.row >= items.count - 5 }) {
//            loadNextPage()
//        }
    }
}

// MARK: - CharactersListDisplaying
extension CharactersListViewController: CharactersListDisplaying {
    func displayInitialList(_ list: [CharactersListDTO]) {
        var snap = dataSource.snapshot()
        snap.deleteAllItems()
        snap.appendSections([.main])
        snap.appendItems(list, toSection: .main)
        dataSource.apply(snap, animatingDifferences: false)
    }
    
    func displayNewItems(_ list: [CharactersListDTO]) {
        stopLoading()
        var snap = dataSource.snapshot()
        if snap.sectionIdentifiers.isEmpty { snap.appendSections([.main]) }
        snap.appendItems(list, toSection: .main)
        dataSource.apply(snap, animatingDifferences: true)
    }
    
    func displayLoading(isRefreshing: Bool) {
        if isRefreshing {
            if !refresh.isRefreshing { refresh.beginRefreshing() }
            loadMoreFooter.setState(.ready)
        } else {
            loadMoreFooter.setState(.loading)
        }
    }
    
    func displayFinishedLoading() {
        refresh.endRefreshing()
        isLoading = false
    }
    
    func displayCanLoadMore(_ canLoadMore: Bool) {
        loadMoreFooter.setState(canLoadMore ? .ready : .end)
    }
}
