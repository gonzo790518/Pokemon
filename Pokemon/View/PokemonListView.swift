//
//  PokemonListView.swift
//  Pokemon
//
//  Created by gonzo_li on 2024/5/28.
//

import SwiftUI

struct PokemonListView: View {
    @StateObject var viewModel = PokemonListViewModel()
    
    var body: some View {
        
        NavigationView {
            VStack {
                List {
                    ForEach(viewModel.pokemonData.indices, id: \.self) { index in
                        NavigationLink(destination: PokemonDetailView()) {
                            
                            let pokemonId = index + 1
                            let item = viewModel.pokemonData[index]
                            let imageURL = "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/\(pokemonId).png"
                            HStack {
                                
                                AsyncImageView(url: imageURL)
                                    .frame(width: 70, height: 70)
                                
                                VStack(alignment: .leading) {

                                    Text(viewModel.formatNumber(item.id))
                                    Text(item.name)
                                        .onAppear {
                                            if index == viewModel.pokemonData.count - 1 {
                                                
                                                viewModel.fetchPokemonList()
                                            }
                                        }
                                }
                                
                                Spacer()
                                
                                Button {
                                    
                                    viewModel.setFavorite(for: item)
                                } label: {
                                    
                                    Image(viewModel.isFavorite(for: item) ? "favorite" : "notFavorite")
                                        .resizable()
                                        .frame(width: 20, height: 20)
                                        .scaledToFit()
                                        .padding(.trailing, 10)
                                }
                                .buttonStyle(PlainButtonStyle())
                            }
                        }
                    }
                }
                .listStyle(.plain)
            }
            .navigationTitle("Pokemon")
        }
        .onAppear {
            
            viewModel.fetchPokemonList()
        }
        .overlay(
            Group {
                if viewModel.isLoading {
                    ProgressView()
                        .progressViewStyle(.circular)
                        .scaleEffect(0.7)
                        .padding()
                }
            }, alignment: .bottom
        )
    }
}

#Preview {
    PokemonListView()
}
