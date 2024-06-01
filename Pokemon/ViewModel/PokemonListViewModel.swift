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
    var currentOffset = 0
    let pageSize = 50
    private var pokemonID: Int = 0
    
    var apiManager: APIManagerProtocol
    init(apiManager: APIManagerProtocol = APIManager.shared) {
        
        self.pokemonData = []
        self.apiManager = apiManager
    }
    
    func fetchPokemonList() {
        
        isLoading = true
        pokemonID = 0
        self.apiManager.fetchPokemonList(offset: currentOffset, limit: pageSize) { responseData in
            
            self.currentOffset = self.currentOffset + self.pageSize
            let results = responseData?.results ?? [Pokemon(id: 0, name: "", url: "", types: "")]
            self.pokemonData.append(contentsOf: results)
            
            // Set id & isFavorite
            for index in self.pokemonData.indices {
                
                self.pokemonData[index].id = self.pokemonID + 1 // Set start id to 1.
                self.pokemonID += 1
                
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
    
    func formatNumber(_ number: Int) -> String {
        
        return String(format: "%04d", number)
    }
    
    func setFavorite(for item: Pokemon) {
        
        if let index = pokemonData.firstIndex(where: { $0.id == item.id }) {
            
            pokemonData[index].isFavorite.toggle()
            UserDefaults.standard.set(pokemonData[index].isFavorite, forKey: "\(item.id)")
        }
    }
    
    func isFavorite(for item: Pokemon) -> Bool {
        
        return UserDefaults.standard.bool(forKey: "\(item.id)")
    }
}
