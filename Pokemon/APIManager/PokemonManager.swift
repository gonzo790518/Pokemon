//
//  APIManager.swift
//  Pokemon
//
//  Created by gonzo_li on 2024/5/28.
//

import Alamofire

protocol APIManagerProtocol {
    
    func fetchPokemonList(offset: Int, limit: Int, Success success: ((_ responseData: PokemonList?) -> Void)?, Fail fail: ((_ err: Error, _ statusCode: Int?) -> Void)?)
}

class APIManager: APIManagerProtocol {
    static let shared = APIManager()
    
    private init() {
        
    }
    
    func fetchPokemonList(offset: Int = 0, limit: Int = 20, Success success: ((_ responseData: PokemonList?) -> Void)?, Fail fail: ((_ err: Error, _ statusCode: Int?) -> Void)?) {
        
        let url = "https://pokeapi.co/api/v2/pokemon?offset=\(offset)&limit=\(limit)"
        AF.request(url, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: nil).responseDecodable(of: PokemonList.self) { response in

            switch response.result {
            case .success(let data):
                
                success?(data)
            case .failure(let error):
                
                print("Error:", error)
                fail?(error, response.response?.statusCode)
            }
        }
    }
}
