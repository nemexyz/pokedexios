//
//  PokemonDetailView.swift
//  Pokedex App
//
//  Created by Axel Cantor on 6/02/21.
//

import SwiftUI

struct PokemonView: View {
    var data: PokemonRowEntity
    
    var body: some View {
        VStack {
            Text(data.name).font(.title)
        }
    }
}
