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
        service.fetchInitialCharacters { [weak self] result in
            guard let self else { return }
            switch result {
            case .success(let characters):
                nextUrl = characters.paginationUrl
                charactersListItem = characters.results
                presenter.presentInitialList(charactersListItem)
            case .failure(let error):
                // TODO: - Adicionar tela de erro
                break
            }
        }
    }
    
    func loadNextCharacters() {
    }
}
