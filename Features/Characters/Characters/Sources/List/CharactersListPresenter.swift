protocol CharactersListPresenting: AnyObject {
    func presentInitialList(_ list: [CharactersListItem])
    func appendItems(_ list: [CharactersListItem])
}

final class CharactersListPresenter: CharactersListPresenting {
    private let router: CharactersListRouting
    weak var viewController: CharactersListDisplaying?
    
    init(router: CharactersListRouting) {
        self.router = router
    }
    
    func presentInitialList(_ list: [CharactersListItem]) {
        let dto = mapCharactersListDTO(from: list)
        viewController?.displayInitialList(dto)
    }
    
    func appendItems(_ list: [CharactersListItem]) {
        let dto = mapCharactersListDTO(from: list)
    }
    
    private func mapCharactersListDTO(from list: [CharactersListItem]) -> [CharactersListDTO] {
        list.map { item in
            CharactersListDTO(id: item.id, name: item.name)
        }
    }
}
