//
//  PokemonViewModel.swift
//  Pokedex App
//
//  Created by Axel Cantor on 5/02/21.
//

import Foundation
import Combine
import Moya
import RealmSwift

// MARK: - Pokemon Entity View Model
struct PokemonEntity: Identifiable {
    var id = UUID()
    var name: String = ""
    var number: Int = 0
    var image: String = ""
    var types: [String] = []
    var flavorText: String = "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua."
}

// MARK: - Pokemon View Model Logic
class PokemonViewModel: ObservableObject {
    let id: Int

    @Published private(set) var state = State()
    private var subscriptions = Set<AnyCancellable>()
    
    init(id: Int) {
        self.id = id
    }
    
    func fetch() {
        let realm = try! Realm()
        if let pk = realm.objects(Pokemon.self).filter("id == \(id)").first {
            state.pokemon = PokemonEntity(
                name: pk.name!.capitalized,
                number: pk.id,
                image: pk.sprites!.other!.officialArtwork!.frontDefault!,
                types: pk.types.map { $0.type!.name! }
            )
        } else {
            PokeInteractor.getPokemon(id: id)
                .sink(receiveCompletion: onReceive, receiveValue: onReceive)
                .store(in: &subscriptions)
        }
    }
    
    private func onReceive(_ completion: Subscribers.Completion<MoyaError>) {
        switch completion {
        case .finished:
            break
        case .failure:
            break
        }
    }

    private func onReceive(_ data: Pokemon) {
        let realm = try! Realm()
        try! realm.write {
            realm.add(data, update: .all)
        }
        
        state.pokemon = PokemonEntity(
            name: data.name!.capitalized,
            number: data.id,
            image: data.sprites!.other!.officialArtwork!.frontDefault!,
            types: data.types.map { $0.type!.name! }
        )
    }

    struct State {
        var pokemon: PokemonEntity?
    }
}
