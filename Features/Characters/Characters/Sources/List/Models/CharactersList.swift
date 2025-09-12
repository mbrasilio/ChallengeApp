import Foundation

struct CharactersList: Decodable {
    let count: Int
    let paginationUrl: String
    let results: [CharactersListItem]
    
    enum CodingKeys: String, CodingKey {
        case results, count
        case paginationUrl = "next"
    }
    
    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        count = try container.decode(Int.self, forKey: .count)
        paginationUrl = try container.decode(String.self, forKey: .paginationUrl)
        results = try container.decode([CharactersListItem].self, forKey: .results)
    }
    
    init(
        count: Int,
        paginationUrl: String,
        results: [CharactersListItem]
    ) {
        self.count = count
        self.paginationUrl = paginationUrl
        self.results = results
    }
}

struct CharactersListItem: Decodable, Equatable {
    let id: UUID
    let name: String
    let detailUrl: String
    
    enum CodingKeys: String, CodingKey {
        case name
        case detailUrl = "url"
    }
    
    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = UUID()
        name = try container.decode(String.self, forKey: .name)
        detailUrl = try container.decode(String.self, forKey: .detailUrl)
    }
    
    init(
        id: UUID,
        name: String,
        detailUrl: String
    ) {
        self.id = id
        self.name = name
        self.detailUrl = detailUrl
    }
}
