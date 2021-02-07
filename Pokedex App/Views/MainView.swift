//
//  MainView.swift
//  Pokedex App
//
//  Created by Axel Cantor on 5/02/21.
//

import SwiftUI
import Moya

struct MainView: View {
    @State private var selection = 0
    
    @ObservedObject var viewModel = PokemonsViewModel()
    
    var body: some View {
        NavigationView {
            TabView(selection: $selection) {
                pokemonList
                    .tabItem {
                        Image("Pokemon")
                        Text("Pokemon")
                    }
                    .tag(0)
                
                Text("Moves Tab")
                    .font(.system(size: 30, weight: .bold, design: .rounded))
                    .tabItem {
                        Image("Moves")
                        Text("Moves")
                    }
                    .tag(1)
                
                Text("Items Tab")
                    .font(.system(size: 30, weight: .bold, design: .rounded))
                    .tabItem {
                        Image("Items")
                        Text("Items")
                    }
                    .tag(2)
            }
            .accentColor(.black)
            .onAppear() {
                UITabBar.appearance().barTintColor = .white
            }
            .navigationTitle("Pokemon")
        }
        .accentColor(.white)
    }
    
    private var pokemonList: some View {
        PokemonListView(
            pokemons: viewModel.state.pokemons,
            isLoading: viewModel.state.canLoadNextPage,
            onScrolledAtBottom: viewModel.fetchNextPageIfPossible
        )
        .onAppear(perform: viewModel.fetchNextPageIfPossible)
    }
}

#if DEBUG

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            MainView()
        }
    }
}

#endif
