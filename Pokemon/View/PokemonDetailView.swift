//
//  PokemonDetailView.swift
//  Pokemon
//
//  Created by gonzo_li on 2024/5/30.
//

import SwiftUI

struct PokemonDetailView: View {
    @StateObject var viewModel = PokemonDetailViewModel()
    @State var pokemon: Pokemon
    @State private var isDetailPresented = false
    @State var isTheFirstTime: Bool = false
    
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
                        
                        Text("Evolution Chain: ")
                            .font(.headline)
                        HStack {
                            ForEach(viewModel.pokemonChain, id: \.self) {
                                
                                let item = $0
                                Button {
                                    
                                    viewModel.setNextPokemon(item: item)
                                    isDetailPresented = true
                                } label: {
                                    Text(item.name)
                                }
                                .disabled(item.id == pokemon.id)
                                
                                Text("->")
                                    .opacity(item.id == viewModel.pokemonChain.last?.id ? 0 : 1)
                            }
                        }
                    }
                    .padding(.bottom, 5)
                    
                    if !viewModel.pokemonSpecies.flavorTextEntries.isEmpty {
                        
                        Text("Description: ").font(.headline)
                        Text(viewModel.getFlavorTextWithLocale())
                    }
                }
                Spacer()
            }
            .padding(.horizontal, 20)
        }
        .onAppear {
            
            if !isTheFirstTime {
                
                isTheFirstTime = true
                viewModel.fetchPokemonDetail(id: pokemon.id)
            }
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
        .background (
            
            NavigationLink(destination: PokemonDetailView(pokemon: viewModel.nextPokemon), isActive: $isDetailPresented) {
                EmptyView()
            }.opacity(0)
        )
    }
}
