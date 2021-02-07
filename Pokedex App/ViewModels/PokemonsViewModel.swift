//
//  PokemonsViewModel.swift
//  Pokedex App
//
//  Created by Axel Cantor on 6/02/21.
//

import Foundation
import Combine
import Moya
import RealmSwift

// MARK: - Pokemon Row Entity View Model
struct PokemonRowEntity: Identifiable, Equatable {
    var id = UUID()
    var name: String = ""
    var number: Int = 0
    var image: String = ""
    var types: [String] = []
}

// MARK: - Pokemon List View Model Logic
class PokemonsViewModel: ObservableObject {
    @Published private(set) var state = State()
    private var subscriptions = Set<AnyCancellable>()
    
    func fetchNextPageIfPossible() {
        guard state.canLoadNextPage else { return }
        
        let limit = state.offset + PokeService.pageSize
        PokeInteractor.getPokemonFullList(offset: state.offset, limit: limit)
            .sink(receiveCompletion: onReceive, receiveValue: onReceive)
            .store(in: &subscriptions)
    }
    
    private func onReceive(_ completion: Subscribers.Completion<MoyaError>) {
        switch completion {
        case .finished:
            break
        case .failure:
            state.canLoadNextPage = false
        }
    }

    private func onReceive(_ data: PokemonFullList) {
        let realm = try! Realm()
        try! realm.write {
            realm.add(data.results, update: .all)
        }
        
        state.pokemons += data.results.map { pk in
            PokemonRowEntity(
                name: pk.name!.capitalized,
                number: pk.id,
                image: pk.sprites!.other!.officialArtwork!.frontDefault!,
                types: pk.types.map { $0.type!.name! }
            )
        }
        state.offset += PokeService.pageSize
        state.canLoadNextPage = data.next
    }

    struct State {
        var pokemons: [PokemonRowEntity] = []
        var offset: Int = 0
        var canLoadNextPage = true
    }
}
