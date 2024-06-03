//
//  PokemonListViewModel.swift
//  Pokemon
//
//  Created by gonzo_li on 2024/5/28.
//

import SwiftUI

class PokemonListViewModel: ObservableObject {
    @Published var pokemonData: [Pokemon]
    @Published var isLoading = false
    @Published var isFiltered = false
    @Published var types: [String] = []
    @Published var selectedPokemon: Pokemon = Pokemon(name: "", url: "", types: "")
    var currentOffset = 0
    let pageSize = 50
    
    var apiManager: APIManagerProtocol
    init(apiManager: APIManagerProtocol = APIManager.shared) {
        
        self.pokemonData = []
        self.apiManager = apiManager
    }
    
    func fetchPokemonList() {
        
        isLoading = true
        self.apiManager.fetchPokemonList(offset: currentOffset, limit: pageSize) { responseData in
            
            self.currentOffset = self.currentOffset + self.pageSize
            let results = responseData?.results ?? [Pokemon(id: 0, name: "", url: "", types: "")]
            self.pokemonData.append(contentsOf: results)
                        
            
            // Set id & isFavorite
            for index in self.pokemonData.indices {
                
                if let pokemonID = General.shared.extractID(keyword: "pokemon", from: self.pokemonData[index].url) {
                    
                    self.pokemonData[index].id = Int(pokemonID) ?? 0
                }
                
                let isFavorite = self.isFavorite(for: self.pokemonData[index])
                self.pokemonData[index].isFavorite = isFavorite
                
                self.apiManager.fetchPokemonType(url: self.pokemonData[index].url) { responseData in
                    
                    let types = responseData?.types.map { $0.type.name } ?? []
                    self.pokemonData[index].types = types.joined(separator: ", ")
                    
                    if index == results.count - 1 {
                        self.isLoading = false
                    }
                } Fail: { err, statusCode in
                    
                    print("[Fetch Types] err: \(String(describing: err))")
                    print("[Fetch Types] statusCode: \(String(describing: statusCode))")
                }
            }
        } Fail: { err, statusCode in
            
            print("[Fetch Pokemon List] err: \(String(describing: err))")
            print("[Fetch Pokemon List] statusCode: \(String(describing: statusCode))")
        }
    }
    
    func setFavorite(for item: Pokemon) {
        
        if let index = pokemonData.firstIndex(where: { $0.id == item.id }) {
            
            pokemonData[index].isFavorite.toggle()
            UserDefaults.standard.set(pokemonData[index].isFavorite, forKey: "\(item.id)")
            NotificationCenter.default.post(name: .favoriteChanged, object: nil)
        }
    }
    
    func isFavorite(for item: Pokemon) -> Bool {
        
        return UserDefaults.standard.bool(forKey: "\(item.id)")
    }
}
