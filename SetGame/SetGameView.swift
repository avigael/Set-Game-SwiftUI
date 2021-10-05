//
//  SetGameView.swift
//  SetGame
//
//  Created by Gael G. on 9/30/21.
//

import SwiftUI

/// Our **View** that converts our game logic into UI
struct SetGameView: View {
    @ObservedObject var game: SetGame
    var body: some View {
        VStack {
            HStack {
                Spacer()
                Button(action: {
                    game.dealCards(numberOfCards: 3)
                }) {
                    VStack{
                        Image(systemName: "3.square")
                        Text("Deal Cards").font(.caption)
                    }
                }.disabled(game.deck.isEmpty)
                Spacer()
                Button(action: {
                    game.newGame(numberOfCardsToDeal: 12)
                }) {
                    VStack{
                        Image(systemName: "arrow.triangle.2.circlepath.circle")
                        Text("New Game").font(.caption)
                    }
                }
                Spacer()
                
            }
            AspectVGrid(items: game.cards, aspectRatio: 2/3, content: { card in
                CardView(card: card)
                    .padding(4)
                    .onTapGesture {
                        game.choose(card)
                    }
            })
        }
        .padding(.horizontal)
        .font(.largeTitle)
    }
}

/// Creates a card
struct CardView: View {
    let card: SetGame.Card
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                let cardShape = RoundedRectangle(cornerRadius: 10)
                if card.isSelected {
                    cardShape.fill().foregroundColor(.white)
                    cardShape.strokeBorder(.green, lineWidth: 5)
                } else if card.isMatched {
                    cardShape.fill().foregroundColor(.green)
                } else if card.badMatch {
                    cardShape.fill().foregroundColor(.red)
                } else {
                    cardShape.fill().foregroundColor(.white)
                    cardShape.strokeBorder(.gray, lineWidth: 3)
                }
                CardSymbol(number: card.number, shape: card.shape, shading: card.shading, hue: card.hue.rawValue).padding(.all)
            }
        }
    }
}

/// Creates the symbols that is displayed on the card
struct CardSymbol: View {
    let number: Int
    let shape: String
    let shading: String
    let hue: Double
    var body: some View {
        VStack {
            ForEach(0..<number, id: \.self) {_ in
                let color = Color(hue: hue, saturation: 1, brightness: 1)
                switch shape {
                case "oval":
                    Capsule().stroke(color, lineWidth: 3).background(Capsule().fill(color.opacity(getOpacity(shading))))
                case "squiggle": 
                    Rectangle().stroke(color, lineWidth: 3).background(Rectangle().fill(color.opacity(getOpacity(shading))))
                default:
                    Diamond().stroke(color, lineWidth: 3).background(Diamond().fill(color.opacity(getOpacity(shading))))
                }
            }
        }
    }
    
    /// Converts the shade to double to be used for opacity
    /// - Returns: Returns a double from 0 to 1
    private func getOpacity (_ shade: String) -> Double {
        switch shade {
        case "solid":
            return 1.0
        case "striped":
            return 0.5
        default:
            return 0.0
        }
    }
}
