//
//  PokemonDetailViewModel.swift
//  Pokemon
//
//  Created by gonzo_li on 2024/6/2.
//

import SwiftUI

class PokemonDetailViewModel: ObservableObject {
    @Published var pokemonSpecies: PokemonSpecies = PokemonSpecies(evolutionChain: EvolutionChain(url: ""), flavorTextEntries: [])
    @Published var pokemonChain: [Species] = []
    @Published var nextPokemon: Pokemon = Pokemon(name: "", url: "", types: "")
    @Published var types: String = ""
    
    var apiManager: APIManagerProtocol
    init(apiManager: APIManagerProtocol = APIManager.shared) {
        
        self.apiManager = apiManager
    }
    
    func fetchPokemonDetail(id: Int) {
        
        let url = "https://pokeapi.co/api/v2/pokemon-species/\(id)"
        self.apiManager.fetchPokemonDetail(url: url) { responseData in
            
            if let response = responseData {
                
                self.pokemonSpecies = response
                self.fetchEvolutionChain(url: response.evolutionChain.url)
            }
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
    
    func fetchEvolutionChain(url: String) {

        apiManager.fetchEvolutionChain(url: url) { responseData in
            
            if let response = responseData {
                
                let speciesList = self.extractAllSpecies(from: response.chain)
                for i in 0 ..< speciesList.count {
                    
                    var item = speciesList[i]
                    item.id = self.getPokemonID(item: item)
                    self.pokemonChain.append(item)
                }
            }
        } Fail: { err, statusCode in
            
            print("[Fetch EvolutionChain] err: \(String(describing: err))")
            print("[Fetch EvolutionChain] statusCode: \(String(describing: statusCode))")
        }
        
    }
    
    func extractAllSpecies(from chain: Chain) -> [Species] {
        
        var speciesList: [Species] = [chain.species]
        for subChain in chain.evolvesTo {
            speciesList.append(contentsOf: extractAllSpecies(from: subChain))
        }
        return speciesList
    }
    
    func getPokemonID(item: Species) -> Int {
        
        if let pokemonID = General.shared.extractID(keyword: "pokemon-species", from: item.url) {
            
            return Int(pokemonID) ?? 0
        }
        return 0
    }
    
    func isFavorite(for item: Pokemon) -> Bool {
        
        return UserDefaults.standard.bool(forKey: "\(item.id)")
    }
    
    func setNextPokemon(item: Species) {
        
        let isFavorite = UserDefaults.standard.bool(forKey: "\(item.id ?? 0)")
        nextPokemon.id = item.id ?? 0
        nextPokemon.name = item.name
        nextPokemon.url = item.url
        nextPokemon.isFavorite = isFavorite
        nextPokemon.types = self.types
    }
    
    func fetchTypesIfLack(id: Int) {
        
        let url = "https://pokeapi.co/api/v2/pokemon/\(id)/"
        self.apiManager.fetchPokemonType(url: url) { responseData in
            
            let types = responseData?.types.map { $0.type.name } ?? []
            self.types = types.joined(separator: ", ")
        } Fail: { err, statusCode in
            
            print("[Fetch Types] err: \(String(describing: err))")
            print("[Fetch Types] statusCode: \(String(describing: statusCode))")
        }
    }
}
