//
//  Pokemon.swift
//  Pokemon
//
//  Created by gonzo_li on 2024/5/28.
//

struct Pokemon: Identifiable, Decodable, Hashable {
    var id: Int
    var name: String
    var url: String
    var isFavorite: Bool
    
    init(id: Int = -1, name: String, url: String, isFavorite: Bool = false) {
        self.id = id
        self.name = name
        self.url = url
        self.isFavorite = isFavorite
    }
    
    private enum CodingKeys: String, CodingKey {
        case name
        case url
        case isFavorite
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.name = try container.decode(String.self, forKey: .name)
        self.url = try container.decode(String.self, forKey: .url)
        self.isFavorite = false
        self.id = -1
    }
}

struct PokemonList: Decodable, Hashable {
    var count: Int
    var next: String?
    var previous: String?
    var results: [Pokemon]
}
