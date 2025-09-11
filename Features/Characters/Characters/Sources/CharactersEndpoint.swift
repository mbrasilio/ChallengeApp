import Foundation
import Networking

struct CharactersEndpoint: EndpointApiProtocol {
    let url: String
    let method: HTTPMethod
    let header: [String: String]?
    let body: Data?
    let timeout: TimeInterval?
    
    init(
        url: String,
        method: HTTPMethod = .GET,
        header: [String : String]? = nil,
        body: Data? = nil,
        timeout: TimeInterval? = nil
    ) {
        self.url = url
        self.method = method
        self.header = header
        self.body = body
        self.timeout = timeout
    }
    
    static func getInitialCharacters() -> Self {
        CharactersEndpoint(url: "https://pokeapi.co/api/v2/pokemon?limit=20&offset=0")
    }
    
    static func getNextCharacters(urlString url: String) -> Self {
        CharactersEndpoint(url: url)
    }
    
    static func getCharacterDetails(urlString url: String) -> Self {
        CharactersEndpoint(url: url)
    }
}
