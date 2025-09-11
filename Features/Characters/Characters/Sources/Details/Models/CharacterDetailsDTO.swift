import Foundation

struct CharacterDetailsDTO: Decodable, Hashable {
    let informations: CharacterInformationsDTO
    let attributes: [CharacterAttribueDTO]
    
    enum CodingKeys: String, CodingKey {
        case height, weight
        case experience = "base_experience"
        case attributes = "stats"
    }
    
    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let height = try container.decode(Int.self, forKey: .height)
        let weight = try container.decode(Int.self, forKey: .weight)
        let experience = try container.decode(Int.self, forKey: .experience)
        informations = CharacterInformationsDTO(
            experience: experience,
            height: height,
            weight: weight
        )
        attributes = try container.decode([CharacterAttribueDTO].self, forKey: .attributes)
    }
}

struct CharacterInformationsDTO: Hashable {
    let experience: Int
    let height: Int
    let weight: Int
}

struct CharacterAttribueDTO: Decodable, Hashable {
    let base: Int
    let stat: CharacterAttributeStatDTO
    
    enum CodingKeys: String, CodingKey {
        case stat
        case base = "base_stat"
    }
}

struct CharacterAttributeStatDTO: Decodable, Hashable {
    let name: String
}
