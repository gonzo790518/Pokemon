//
//  PokemonDetailView.swift
//  Pokemon
//
//  Created by gonzo_li on 2024/5/30.
//

import SwiftUI

struct PokemonDetailView: View {
    @Binding var pokemon: Pokemon

    var body: some View {
        
        VStack {
            Text(pokemon.name)
            Text("\(pokemon.isFavorite)")
        }
        .toolbar {
            
            Button {
                
                pokemon.isFavorite.toggle()
                UserDefaults.standard.set(pokemon.isFavorite, forKey: "\(pokemon.id)")
                NotificationCenter.default.post(name: .favoriteChanged, object: nil)
            } label: {
                
                Image(pokemon.isFavorite ? "favorite" : "notFavorite")
                    .resizable()
                    .frame(width: 20, height: 20)
                    .scaledToFit()
                    .padding(.trailing, 10)
            }
        }
    }
}
