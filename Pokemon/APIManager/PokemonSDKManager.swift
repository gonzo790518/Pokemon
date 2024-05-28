//
//  PokemonSDKManager.swift
//  Pokemon
//
//  Created by gonzo_li on 2024/5/28.
//

import Alamofire

protocol PokemonSDKManagerProtocol {
    func fetchPokemonList(completion: @escaping (Bool) -> Void)
}

class PokemonSDKManager: PokemonSDKManagerProtocol {
    static let shared = PokemonSDKManager()
    
    private init() {
        
    }
    
    func fetchPokemonList(completion: @escaping (Bool) -> Void) {
        
        let url = "https://pokeapi.co/api/v2/pokemon?offset=0&limit=20"
        AF.request(url, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: nil).responseDecodable(of: PokemonList.self) { response in

            switch response.result {
            case .success(let data):
                
                print(data)
            case .failure(let error):
                print("Error:", error)
            }
        }
    }
}
