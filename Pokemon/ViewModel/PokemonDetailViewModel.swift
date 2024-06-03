//
//  PokemonDetailViewModel.swift
//  Pokemon
//
//  Created by gonzo_li on 2024/6/2.
//

import SwiftUI

class PokemonDetailViewModel: ObservableObject {
    @Published var pokemonSpecies: PokemonSpecies = PokemonSpecies(evolutionChain: EvolutionChain(url: ""), flavorTextEntries: [])
    
    var apiManager: APIManagerProtocol
    init(apiManager: APIManagerProtocol = APIManager.shared) {
        
        self.apiManager = apiManager
    }
    
    func fetchPokemonDetail(id: Int) {

        let url = "https://pokeapi.co/api/v2/pokemon-species/\(id)"
        self.apiManager.fetchPokemonDetail(url: url) { responseData in
            
            if let response = responseData {
                self.pokemonSpecies = response
            }
            print("evolutionChain: \(String(describing: responseData?.evolutionChain))")
        } Fail: { err, statusCode in
            
            print("[Fetch Detail] err: \(String(describing: err))")
            print("[Fetch Detail] statusCode: \(String(describing: statusCode))")
        }
    }
    
    func getFlavorTextWithLocale() -> String {
        
        let preferredLanguage = Locale.preferredLanguageNScripCodes.first ?? "en"
        var filteredFlavorText = self.pokemonSpecies.flavorTextEntries.filter({ $0.language.name == preferredLanguage })
        
        if filteredFlavorText.isEmpty {
            filteredFlavorText = self.pokemonSpecies.flavorTextEntries.filter({ $0.language.name == "en" })
        }
        
        // Not sure what version is, so pick the first one Flavor Text.
        let firstFlavorText = filteredFlavorText.first?.flavorText ?? ""
        return firstFlavorText.replacingOccurrences(of: "\n", with: "")
    }
}
