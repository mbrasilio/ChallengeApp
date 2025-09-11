import Networking

protocol CharactersListServicing {
    func fetchInitialCharacters(completion: @escaping (Result<CharactersList, CustomError>) -> Void)
    func fetchNextCharacters(url: String, completion: @escaping (Result<CharactersList, CustomError>) -> Void)
}

final class CharactersListService: CharactersListServicing {
    private let networking: NetworkServicing
    
    init(networking: NetworkServicing) {
        self.networking = networking
    }
    
    func fetchInitialCharacters(completion: @escaping (Result<CharactersList, CustomError>) -> Void) {
        let api = CharactersEndpoint.getInitialCharacters()
        networking.fetch(api: api) { (result: Result<CharactersList, CustomError>) in
            DispatchQueue.main.async {
                completion(result)
            }
        }
    }
    
    func fetchNextCharacters(url: String, completion: @escaping (Result<CharactersList, CustomError>) -> Void) {
        let api = CharactersEndpoint.getNextCharacters(urlString: url)
        networking.fetch(api: api) { (result: Result<CharactersList, CustomError>) in
            DispatchQueue.main.async {
                completion(result)
            }
        }
    }
}
