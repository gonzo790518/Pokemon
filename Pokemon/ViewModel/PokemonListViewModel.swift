//
//  PokemonListViewModel.swift
//  Pokemon
//
//  Created by gonzo_li on 2024/5/28.
//

import SwiftUI

class PokemonListViewModel: ObservableObject {
    @Published var pokemonData: [Pokemon]? = []
    @Published var isLoading = false
    var currentOffset = 0
    let pageSize = 20
    
    var apiManager: APIManagerProtocol
    init(apiManager: APIManagerProtocol = APIManager.shared) {
        
        self.apiManager = apiManager
    }
    
    func fetchPokemonList() {
        
        isLoading = true
        self.apiManager.fetchPokemonList(offset: currentOffset, limit: pageSize) { responseData in
            
            self.currentOffset = self.currentOffset + self.pageSize
            let results = responseData?.results ?? [Pokemon(name: "", url: "")]
            self.pokemonData?.append(contentsOf: results)
            self.isLoading = false
        } Fail: { err, statusCode in
            
            print("err: \(String(describing: err))")
            print("statusCode: \(String(describing: statusCode))")
        }
    }
    
    func formatNumber(_ number: Int) -> String {
        return String(format: "%04d", number)
    }
}
