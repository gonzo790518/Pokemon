//
//  PokemonListViewModel.swift
//  Pokemon
//
//  Created by gonzo_li on 2024/5/28.
//

import SwiftUI

class PokemonListViewModel: ObservableObject {
    var sdkManager: PokemonSDKManagerProtocol
    
    init(sdkManager: PokemonSDKManagerProtocol = PokemonSDKManager.shared) {
        
        self.sdkManager = sdkManager
    }
    
    func fetchPokemonList(completion: @escaping (Bool) -> Void) {
        
        self.sdkManager.fetchPokemonList { result in
            
            completion(result)
        }
    }
}
