import Networking

protocol CharactersListServicing {
    func fetchInitialCharacters(completion: @escaping (Result<CharactersList, CustomError>) -> Void)
}

final class CharactersListService: CharactersListServicing {
    private let networking: NetworkServicing
    
    init(networking: NetworkServicing) {
        self.networking = networking
    }
    
    func fetchInitialCharacters(completion: @escaping (Result<CharactersList, CustomError>) -> Void) {
        let api = CharactersEndpoint.getInitialCharacters()
        networking.fetch(api: api, completion: completion)
    }
}
