//
//  APIManager.swift
//  Pokemon
//
//  Created by gonzo_li on 2024/5/28.
//

import Alamofire
import SwiftUI

protocol APIManagerProtocol {
    
    func fetchPokemonList(offset: Int, limit: Int, Success success: ((_ responseData: PokemonList?) -> Void)?, Fail fail: ((_ err: Error, _ statusCode: Int?) -> Void)?)
    func fetchPokemonType(url: String, Success success: ((_ responseData: PokemonDetail?) -> Void)?, Fail fail: ((_ err: Error, _ statusCode: Int?) -> Void)?)
    func fetchPokemonDetail(url: String, Success success: ((_ responseData: PokemonSpecies?) -> Void)?, Fail fail: ((_ err: Error, _ statusCode: Int?) -> Void)?)
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
    
    func fetchPokemonType(url: String, Success success: ((_ responseData: PokemonDetail?) -> Void)?, Fail fail: ((_ err: Error, _ statusCode: Int?) -> Void)?) {
        
        AF.request(url, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: nil).responseDecodable(of: PokemonDetail.self) { response in

            switch response.result {
            case .success(let data):
                
                success?(data)
            case .failure(let error):
                
                print("Error:", error)
                fail?(error, response.response?.statusCode)
            }
        }
    }
    
    func fetchPokemonDetail(url: String, Success success: ((_ responseData: PokemonSpecies?) -> Void)?, Fail fail: ((_ err: Error, _ statusCode: Int?) -> Void)?) {
        
        AF.request(url, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: nil).responseDecodable(of: PokemonSpecies.self) { response in

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
