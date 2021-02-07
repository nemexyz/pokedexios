//
//  ContentView.swift
//  Pokedex App
//
//  Created by Axel Cantor on 5/02/21.
//

import SwiftUI
import SDWebImageSwiftUI
import Moya

struct PokemonRow: View {
    var data: PokemonRowEntity
    
    var body: some View {
        HStack {
            WebImage(url: URL(string: data.image)).resizable().placeholder(Image("Pokeball")).scaledToFit().frame(width: 45, height: 45, alignment: .center)
            VStack(alignment: .leading) {
                Text(data.name).font(.system(size: 20, design: .rounded))
                Text(data.number == 0 ? "-" : "# \(data.number)").font(.subheadline).foregroundColor(.gray)
            }
            Spacer()
            HStack(spacing: -16) {
                ForEach(data.types, id: \.self) { item in
                    Image("Types-\(item.capitalized)")
                }
            }
        }
        .padding(.trailing, -16.0)
    }
}

struct PokemonsView: View {
    @State private var selection = 0
    @State private var selected: UUID?
    @State private var pokemons: [PokemonRowEntity] = []
    
    var body: some View {
        NavigationView {
            TabView(selection: $selection) {
                List(pokemons) { pokemon in
                    ZStack {
                        NavigationLink(destination: PokemonDetailView(data: pokemon)) {
                            EmptyView()
                        }
                        .hidden()
                        .buttonStyle(PlainButtonStyle())
                        PokemonRow(data: pokemon)
                    }
                }
                .tabItem {
                    Image("Pokemon")
                    Text("Pokemon")
                }
                .tag(0)
                
                Text("Bookmark Tab")
                    .font(.system(size: 30, weight: .bold, design: .rounded))
                    .tabItem {
                        Image("Moves")
                        Text("Moves")
                    }
                    .tag(1)
                
                Text("Video Tab")
                    .font(.system(size: 30, weight: .bold, design: .rounded))
                    .tabItem {
                        Image("Items")
                        Text("Items")
                    }
                    .tag(2)
            }
            .accentColor(.red)
            .onAppear() {
                UITabBar.appearance().barTintColor = .white
            }
            .navigationTitle("Pokemon")
        }
        .onAppear {
            getPokemons()
        }
    }
    
    func getPokemons() {
        let provider = MoyaProvider<PokeService>()
        provider.request(.getPokemonList(offset: 0, limit: 20)) { result in
            switch result {
            case let .success(moyaResponse):
                do {
                    let filteredResponse = try moyaResponse.filterSuccessfulStatusCodes()
                    let pkList: PokemonList = try filteredResponse.map(PokemonList.self)
                    for item in pkList.results {
                        let pokemon = PokemonRowEntity(
                            name: item.name.capitalized,
                            number: Int(item.url.split(separator: "/").last!) ?? 0
                        )
                        pokemons.append(pokemon)
                        getPokemon(pokemon: pokemon)
                    }
                }
                catch let error {
                    print("Error: \(error)")
                }
            case let .failure(error):
                print("Fallo general: \(error)")
            }
        }
    }
    
    func getPokemon(pokemon: PokemonRowEntity) {
        let provider = MoyaProvider<PokeService>()
        provider.request(.getPokemon(id: pokemon.number)) { result in
            switch result {
            case let .success(moyaResponse):
                do {
                    let filteredResponse = try moyaResponse.filterSuccessfulStatusCodes()
                    let pk: Pokemon = try filteredResponse.map(Pokemon.self)
                    let index = pokemons.firstIndex(where: { $0.number == pk.id })
                    pokemons[index!] = PokemonRowEntity(
                        name: pk.name.capitalized,
                        number: pk.id,
                        image: pk.sprites.other!.officialArtwork.frontDefault,
                        types: pk.types.map { $0.type.name }
                    )
                }
                catch let error {
                    print("Error: \(error)")
                }
            case let .failure(error):
                print("Fallo general: \(error)")
            }
        }
    }
}

#if DEBUG

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            PokemonsView()
        }
    }
}

#endif
