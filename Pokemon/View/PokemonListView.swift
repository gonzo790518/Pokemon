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
        VStack {
            List(viewModel.pokemonData ?? [Pokemon(name: "", url: "")], id: \.self) { item in
                
                VStack {
                    Text(item.name)
                        .onAppear {
                            if item == viewModel.pokemonData?.last {
                                
                                viewModel.fetchPokemonList()
                            }
                        }
                }
            }
            
        }
        .padding()
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
