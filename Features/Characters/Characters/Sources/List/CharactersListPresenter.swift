protocol CharactersListPresenting: AnyObject {
    func presentLoading()
    func stopLoading()
    func presentInitialList(_ list: [CharactersListItem])
    func presentNextCharacters(_ list: [CharactersListItem])
    func presentCanLoadMore(_ canLoadMore: Bool)
}

final class CharactersListPresenter: CharactersListPresenting {
    private let router: CharactersListRouting
    weak var viewController: CharactersListDisplaying?
    
    init(router: CharactersListRouting) {
        self.router = router
    }
    
    func presentLoading() {
        viewController?.displayLoading()
    }
    
    func stopLoading() {
        viewController?.displayFinishedLoading()
    }
    
    func presentInitialList(_ list: [CharactersListItem]) {
        let dto = mapCharactersListDTO(from: list)
        viewController?.displayInitialList(dto)
    }
    
    func presentNextCharacters(_ list: [CharactersListItem]) {
        let dto = mapCharactersListDTO(from: list)
        viewController?.displayNewItems(dto)
    }
    
    func presentCanLoadMore(_ canLoadMore: Bool) {
        viewController?.displayCanLoadMore(canLoadMore)
    }
    
    private func mapCharactersListDTO(from list: [CharactersListItem]) -> [CharactersListDTO] {
        list.map { item in
            CharactersListDTO(id: item.id, name: item.name)
        }
    }
}
