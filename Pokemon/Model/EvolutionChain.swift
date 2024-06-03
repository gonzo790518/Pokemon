//
//  EvolutionChain.swift
//  Pokemon
//
//  Created by gonzo_li on 2024/6/3.
//

import Foundation

struct Evolution: Decodable {
    let chain: Chain
}

struct Chain: Decodable {
    let species: Species
    let evolvesTo: [Chain]

    enum CodingKeys: String, CodingKey {
        case species
        case evolvesTo = "evolves_to"
    }
}

struct Species: Decodable, Hashable {
    var id: Int?
    let name: String
    let url: String
}
