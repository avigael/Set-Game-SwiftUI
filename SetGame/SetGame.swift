//
//  SetGame.swift
//  SetGame
//
//  Created by Gael G. on 10/2/21.
//

import SwiftUI

/// Our **ViewModel** that allows use to connect our UI with our game logic
class SetGame: ObservableObject {
    typealias Card = SetGameLogic.Card
    /// Creates our game starting with 12 randomly dealt cards
    @Published private var model = SetGameLogic(numberOfCards: 12)
    /// Gives access to the dealt cards in our Model
    var cards: Array<Card> {
        model.cards
    }
    /// Gives access to the deck of undealt cards. When deck is empty all cards have been dealt.
    var deck: Array<Card> {
        model.deck
    }
    // MARK: - Intent(s)
    /// Creates a new game replacing the current game.
    /// - Parameter numberOfCardsToDeal: The number of cards that the game begins with.
    func newGame(numberOfCardsToDeal: Int) {
        model = SetGameLogic(numberOfCards: numberOfCardsToDeal)
    }
    /// Connects to the game logic defining the rules of Set in our Model.
    /// - Parameter card: The most recently tapped card.
    func choose(_ card: Card) {
        model.choose(card)
    }
    /// Allows any number of cards to be dealt from the deck.
    /// - Parameter numberOfCards: The number of cards you wish to deal from the deck.
    func dealCards(numberOfCards: Int) {
        model.dealCards(numberOfCards: numberOfCards)
    }
}
