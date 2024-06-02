//
//  PokemonDetail.swift
//  Pokemon
//
//  Created by gonzo_li on 2024/6/2.
//

struct PokemonSpecies: Decodable {
    let evolutionChain: EvolutionChain
    let flavorTextEntries: [FlavorTextEntry]
    
    enum CodingKeys: String, CodingKey {
        case evolutionChain = "evolution_chain"
        case flavorTextEntries = "flavor_text_entries"
    }
}

struct EvolutionChain: Decodable {
    let url: String
}

struct FlavorTextEntry: Decodable {
    let flavorText: String
    let language: Language
    
    enum CodingKeys: String, CodingKey {
        case flavorText = "flavor_text"
        case language
    }
}

struct Language: Decodable {
    let name: String
}

