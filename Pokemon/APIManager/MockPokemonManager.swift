//
//  MockPokemonManager.swift
//  Pokemon
//
//  Created by gonzo_li on 2024/6/4.
//

import Foundation

class MockPokemonManager: APIManagerProtocol {
    
    func fetchPokemonList(offset: Int, limit: Int, Success success: ((PokemonList?) -> Void)?, Fail fail: ((any Error, Int?) -> Void)?) {
        
        // ..
    }
    
    func fetchPokemonType(url: String, Success success: ((PokemonDetail?) -> Void)?, Fail fail: ((any Error, Int?) -> Void)?) {
        
        // ..
    }
    
    func fetchPokemonDetail(url: String, Success success: ((PokemonSpecies?) -> Void)?, Fail fail: ((any Error, Int?) -> Void)?) {
        
        // ..
    }
    
    func fetchEvolutionChain(url: String, Success success: ((Evolution?) -> Void)?, Fail fail: ((any Error, Int?) -> Void)?) {
        
        // ..
    }
}
