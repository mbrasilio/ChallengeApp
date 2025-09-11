import Networking

protocol CharacterDetailsServicing {
    func fetchDetails(completion: @escaping (Result<CharacterDetailsDTO, CustomError>) -> Void)
}

final class CharacterDetailsService: CharacterDetailsServicing {
    private let url: String
    private let networking: NetworkServicing
    
    init(
        url: String,
        networking: NetworkServicing
    ) {
        self.url = url
        self.networking = networking
    }
    
    func fetchDetails(completion: @escaping (Result<CharacterDetailsDTO, CustomError>) -> Void) {
        let api = CharactersEndpoint.getCharacterDetails(urlString: url)
        networking.fetch(api: api) { (result: Result<CharacterDetailsDTO, CustomError>) in
            DispatchQueue.main.async {
                completion(result)
            }
        }
    }
}
