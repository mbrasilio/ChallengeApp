import Networking

protocol CharactersListInteracting: AnyObject {
    func loadInitialCharacters()
    func loadNextCharacters()
}

final class CharactersListInteractor {
    private let service: CharactersListServicing
    private let presenter: CharactersListPresenting
    
    private var charactersListItem = [CharactersListItem]()
    private var nextUrl = String()
    
    init(
        service: CharactersListServicing,
        presenter: CharactersListPresenting
    ) {
        self.service = service
        self.presenter = presenter
    }
}

// MARK: - CharactersListInteracting
extension CharactersListInteractor: CharactersListInteracting {
    func loadInitialCharacters() {
        presenter.presentLoading()
        service.fetchInitialCharacters { [weak self] result in
            guard let self else { return }
            presenter.stopLoading()
            switch result {
            case .success(let characters):
                nextUrl = characters.paginationUrl
                charactersListItem = characters.results
                presenter.presentInitialList(charactersListItem)
                presenter.presentCanLoadMore(couldLoadMoreItens(total: characters.count))
            case .failure(let error):
                // TODO: - Adicionar tela de erro
                break
            }
        }
    }
    
    func loadNextCharacters() {
        presenter.presentLoading()
        service.fetchNextCharacters(url: nextUrl) { [weak self] result in
            guard let self else { return }
            presenter.stopLoading()
            switch result {
            case .success(let characters):
                nextUrl = characters.paginationUrl
                charactersListItem.append(contentsOf: characters.results)
                presenter.presentNextCharacters(characters.results)
                presenter.presentCanLoadMore(couldLoadMoreItens(total: characters.count))
            case .failure(let error):
                // TODO: - Adicionar tela de erro
                break
            }
        }
    }
    
    private func couldLoadMoreItens(total: Int) -> Bool {
        total > charactersListItem.count
    }
}
