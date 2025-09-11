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
}

struct CharactersListItem: Decodable {
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
}
