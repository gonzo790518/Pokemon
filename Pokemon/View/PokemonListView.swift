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
                    ForEach((viewModel.pokemonData ?? [Pokemon(name: "", url: "")]).indices, id: \.self) { index in
                        NavigationLink(destination: PokemonDetailView()) {
                            
                            let data = viewModel.pokemonData?[index] ?? Pokemon(name: "", url: "")
                            let imageURL = "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/\(index+1).png"
                            HStack {
                                
                                AsyncImageView(url: imageURL)
                                    .frame(width: 70, height: 70)
                                
                                VStack(alignment: .leading) {
                                    Text(viewModel.formatNumber(index + 1))
                                    Text(data.name)
                                        .onAppear {
                                            if index == (viewModel.pokemonData?.count ?? 0) - 1 {
                                                
                                                viewModel.fetchPokemonList()
                                            }
                                        }
                                }
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
