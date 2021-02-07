//
//  PokeService.swift
//  Pokedex App
//
//  Created by Axel Cantor on 5/02/21.
//

import Foundation
import Moya

enum PokeService {
    case getPokemonList(offset: Int, limit: Int)
    case getPokemon(id: Int)
    static let pageSize = 20
}

extension PokeService: TargetType {
    var baseURL: URL{ return URL(string: "https://pokeapi.co/api/v2")! }
    var path: String {
        switch self {
        case .getPokemonList(_, _):
            return "/pokemon"
        case .getPokemon(let id):
            return "/pokemon/\(id)"
        }
    }
    var method: Moya.Method {
        switch self {
        case .getPokemonList, .getPokemon:
            return .get
        }
    }
    var task: Task {
        switch self {
        case let .getPokemonList(offset, limit):
            return .requestParameters(parameters: ["offset": offset, "limit": limit], encoding: URLEncoding.queryString)
        case .getPokemon(_):
            return .requestPlain
        }
    }
    var sampleData: Data {
        switch self {
        case .getPokemonList(_, _):
            guard let url = Bundle.main.url(forResource: "pokemons", withExtension: "json"),
                  let data = try? Data(contentsOf: url) else {
                    return Data()
            }
            return data
        case .getPokemon(_):
            guard let url = Bundle.main.url(forResource: "charmander", withExtension: "json"),
                  let data = try? Data(contentsOf: url) else {
                    return Data()
            }
            return data
        }
    }
    var headers: [String: String]? {
        return ["Content-type": "application/json"]
    }
}

// MARK: - Helpers
private extension String {
    var urlEscaped: String {
        return addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)!
    }
    
    var utf8Encoded: Data {
        return data(using: .utf8)!
    }
}
