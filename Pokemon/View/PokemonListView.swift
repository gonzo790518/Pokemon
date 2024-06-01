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
                List(viewModel.pokemonData.filter({ viewModel.isFiltered ? $0.isFavorite == viewModel.isFiltered : true}), id: \.self) { item in
                                        
                    NavigationLink(destination: PokemonDetailView()) {
                        
                        let imageURL = "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/\(item.id).png"
                        HStack {
                            
                            AsyncImageView(url: imageURL)
                                .frame(width: 70, height: 70)
                            
                            VStack(alignment: .leading) {
                                
                                Text(viewModel.formatNumber(item.id))
                                Text(item.name)
                                    .onAppear {
                                        if item.id == viewModel.pokemonData.count - 5 {
                                            
                                            viewModel.fetchPokemonList()
                                        }
                                    }
                                Text("\(item.types)")
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
                .listStyle(.plain)
            }
            .navigationTitle("Pokemon")
            .toolbar {
                
                Button {
                    
                    viewModel.isFiltered.toggle()
                } label: {
                    
                    Image(viewModel.isFiltered ? "filtered" : "filter")
                        .resizable()
                        .frame(width: 20, height: 20)
                        .scaledToFit()
                        .padding(.trailing, 10)
                }
            }
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
