//
//  PokemonListView.swift
//  Pokedex App
//
//  Created by Axel Cantor on 6/02/21.
//

import SwiftUI
import SDWebImageSwiftUI

struct PokemonListView: View {
    let pokemons: [PokemonRowEntity]
    let isLoading: Bool
    let onScrolledAtBottom: () -> Void
    
    var body: some View {
        List {
            pokemonList
            if isLoading {
                loadingIndicator
            }
        }
    }
    
    private var pokemonList: some View {
        ForEach(pokemons) { pokemon in
            ZStack {
                NavigationLink(destination: PokemonView(viewModel: PokemonViewModel(id: pokemon.number))) {
                    EmptyView()
                }
                .hidden()
                .buttonStyle(PlainButtonStyle())
                PokemonRow(current: pokemon)
            }
            .onAppear {
                if self.pokemons.last == pokemon {
                    self.onScrolledAtBottom()
                }
            }
        }
    }
    
    private var loadingIndicator: some View {
        Spinner(style: .medium).frame(idealWidth: .infinity, maxWidth: .infinity, alignment: .center)
    }
}

struct PokemonRow: View {
    let current: PokemonRowEntity
    
    var body: some View {
        HStack {
            WebImage(url: URL(string: current.image)).resizable().placeholder(Image("Pokeball")).scaledToFit().frame(width: 45, height: 45, alignment: .center)
            VStack(alignment: .leading) {
                Text(current.name).font(.system(size: 20, design: .rounded))
                Text(current.number == 0 ? "-" : "# \(current.number)").font(.subheadline).foregroundColor(.gray)
            }
            Spacer()
            HStack(spacing: -16) {
                ForEach(current.types, id: \.self) { item in
                    Image("Types-\(item.capitalized)")
                }
            }
        }
        .padding(.trailing, -16.0)
    }
}
