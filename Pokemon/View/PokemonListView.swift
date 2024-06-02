//
//  PokemonListView.swift
//  Pokemon
//
//  Created by gonzo_li on 2024/5/28.
//

import SwiftUI

struct PokemonListView: View {
    @StateObject var viewModel = PokemonListViewModel()
    @State private var isDetailPresented = false
    
    var body: some View {
        
        NavigationView {
            VStack {
                List(viewModel.pokemonData.filter({ viewModel.isFiltered ? $0.isFavorite == viewModel.isFiltered : true}), id: \.self) { item in
                    
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
                        
                        Image(viewModel.isFavorite(for: item) ? "favorite" : "notFavorite")
                            .resizable()
                            .frame(width: 20, height: 20)
                            .scaledToFit()
                            .padding(.trailing, 10)
                            .onTapGesture {
                                
                                viewModel.setFavorite(for: item)
                            }
                    }
                    .contentShape(Rectangle())
                    .onTapGesture {
                        
                        if let index = viewModel.pokemonData.firstIndex(where: { $0.id == item.id }) {
                            
                            print("selectedPokemon isFavorite: \(viewModel.selectedPokemon.isFavorite)")
                            print("viewModel.pokemonData[index] isFavorite: \(viewModel.pokemonData[index].isFavorite)")
                            viewModel.selectedPokemon = viewModel.pokemonData[index]
                            isDetailPresented = true
                        }
                    }
                    
                }
                .listStyle(.plain)
            }
            .navigationTitle("Pokemon")
            .onReceive(NotificationCenter.default.publisher(for: .favoriteChanged)) { _ in
                
                let isFavorite = viewModel.isFavorite(for: viewModel.selectedPokemon)
                viewModel.selectedPokemon.isFavorite = isFavorite
                if let index = viewModel.pokemonData.firstIndex(where: { $0.id == viewModel.selectedPokemon.id }) {
                    
                    viewModel.pokemonData[index].isFavorite = isFavorite
                }
            }
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
            .background (
                NavigationLink(destination: PokemonDetailView(pokemon: $viewModel.selectedPokemon), isActive: $isDetailPresented) {
                    EmptyView()
                }.opacity(0)
            )
            
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
