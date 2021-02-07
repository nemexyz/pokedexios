//
//  PokeInteractor.swift
//  Pokedex App
//
//  Created by Axel Cantor on 6/02/21.
//

import Foundation
import Combine
import Moya
import CombineMoya

enum PokeInteractor {
    static let provider = MoyaProvider<PokeService>()
    
    static func getPokemonFullList(offset: Int, limit: Int) -> AnyPublisher<PokemonFullList, MoyaError> {
        return getPokemonList(offset: offset, limit: limit)
            .flatMap { instanceResponseList in
                Publishers.Sequence(sequence: instanceResponseList.results)
                    .flatMap { instance in
                        PokeInteractor.getPokemon(id: Int(instance.url.split(separator: "/").last!) ?? 0)
                            .eraseToAnyPublisher()
                    }
                    .collect()
                    .map { pokemons -> PokemonFullList in
                        return PokemonFullList(results: pokemons.sorted { $0.id < $1.id }, next: instanceResponseList.next != nil)
                    }
            }
            .eraseToAnyPublisher()
    }
    
    static func getPokemonList(offset: Int, limit: Int) -> AnyPublisher<PokemonList, MoyaError> {
        return provider.requestPublisher(.getPokemonList(offset: offset, limit: limit))
            .map(PokemonList.self)
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
    
    static func getPokemon(id: Int) -> AnyPublisher<Pokemon, MoyaError> {
        return provider.requestPublisher(.getPokemon(id: id))
            .map(Pokemon.self)
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
}
