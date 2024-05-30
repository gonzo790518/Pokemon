//
//  Pokemon.swift
//  Pokemon
//
//  Created by gonzo_li on 2024/5/28.
//

struct Pokemon: Decodable, Hashable {
    var name: String
    var url: String
}

struct PokemonList: Decodable, Hashable {
    var count: Int
    var next: String?
    var previous: String?
    var results: [Pokemon]
}
