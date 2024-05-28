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
            Button {
                
                viewModel.fetchPokemonList { result in
                    
                    // ..
                }
            } label: {
                Text("Pokemon")
            }

            
        }
        .padding()
    }
}

#Preview {
    PokemonListView()
}
