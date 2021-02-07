//
//  PokemonView.swift
//  Pokedex App
//
//  Created by Axel Cantor on 6/02/21.
//

import SwiftUI
import SDWebImageSwiftUI

struct PokemonView: View {
    @ObservedObject var viewModel: PokemonViewModel
    
    var body: some View {
        VStack {
            if viewModel.state.pokemon == nil {
                loadingIndicator
            } else {
                content
            }
        }
        .onAppear {
            viewModel.fetch()
        }
    }
    
    private var loadingIndicator: some View {
        Spinner(style: .medium).frame(idealWidth: .infinity, maxWidth: .infinity, alignment: .center)
    }
    
    private var content: some View {
        ZStack {
            LinearGradient(gradient: Gradient(colors: [.blue, .clear]), startPoint: .leading, endPoint: .trailing).padding(.bottom, 80)
            VStack {
                WebImage(url: URL(string: viewModel.state.pokemon!.image)).resizable().placeholder(Image("Pokeball")).scaledToFit().frame(width: 200, height: 200, alignment: .center)
                VStack(spacing: 0) {
                    Text("\(viewModel.state.pokemon!.name)").font(.largeTitle).foregroundColor(.textColor)
                        //.padding(.top, 50)
                    HStack(spacing: -16) {
                        ForEach(viewModel.state.pokemon!.types, id: \.self) { item in
                            Image("Tag-\(item.capitalized)")
                        }
                    }.padding(.bottom, 16)
                    Text("\(viewModel.state.pokemon!.flavorText)").font(.body).fontWeight(.light).foregroundColor(.textColor)
                    Spacer()
                }
                .padding(EdgeInsets(top: 16, leading: 16, bottom: 16, trailing: 16))
                .frame(maxWidth: .infinity)
                .background(Color.white)
                .cornerRadius(40)
            }.padding(.top, 100)
        }.edgesIgnoringSafeArea(.all)
    }
}

#if DEBUG

struct PokemonView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            PokemonView(viewModel: PokemonViewModel(id: 1)).edgesIgnoringSafeArea(.horizontal)
        }
    }
}

#endif
