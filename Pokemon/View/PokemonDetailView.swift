//
//  PokemonDetailView.swift
//  Pokemon
//
//  Created by gonzo_li on 2024/5/30.
//

import SwiftUI

struct PokemonDetailView: View {
    @StateObject var viewModel = PokemonDetailViewModel()
    @Binding var pokemon: Pokemon
    
    var body: some View {
        VStack(alignment: .center) {
            
            let imageURL = "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/home/\(pokemon.id).png"
            AsyncImageView(url: imageURL)
                .frame(width: 250, height: 250)
            
            ScrollView {
                VStack(alignment: .leading) {
                    Group {
                        HStack {
                            Text("ID: ").font(.headline)
                            Text(General.shared.formatNumber(pokemon.id))
                        }
                        
                        HStack {
                            Text("Name: ").font(.headline)
                            Text(pokemon.name)
                        }
                        
                        HStack {
                            Text("Types: ").font(.headline)
                            Text(pokemon.types)
                        }
                    }
                    .padding(.bottom, 5)
                    
                    if !viewModel.pokemonSpecies.flavorTextEntries.isEmpty {
                        
                        Text("Description: ").font(.headline)
                        Text(viewModel.getFlavorTextWithLocale())
                    }
                    
                    NavigationLink {
                        
                        PokemonEvolutionChainView()
                    } label: {
                        
                        Text("Evolution Chain Pokemon").font(.headline)
                    }.padding(.top, 5)
                }
                Spacer()
            }
            .padding(.horizontal, 20)
        }
        .onAppear {
            
            viewModel.fetchPokemonDetail(id: pokemon.id)
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
