//
//  Pokemons.swift
//  Pokedex App
//
//  Created by Axel Cantor on 5/02/21.
//

import Foundation

// MARK: - Pokemons
struct PokemonList: Decodable {
    let count: Int
    let next, previous: String?
    let results: [PokemonName]
}

struct PokemonName: Decodable {
    let name: String
    let url: String
}

// MARK: - Pokemon
struct PokemonFullList {
    let results: [Pokemon]
    let next: Bool
}
