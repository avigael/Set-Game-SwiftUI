//
//  SetGameLogic.swift
//  SetGame
//
//  Created by Gael G. on 10/2/21.
//

import Foundation

/// The **Model** for our game logic
struct SetGameLogic {
    /// Simulates shuffled deck of card (holds undealt cards)
    private(set) var deck: Array<Card>
    /// Represents dealt cards
    private(set) var cards: Array<Card>
    /// Stores the first selected card
    private var firstCardIdx: Int?
    /// Stores the second selected card
    private var secondCardIdx: Int?
    /// Stores the result of match, 0 = no recent match, 1 = recent mismatch, 2 = recent match
    private var matchResult = 0
    /// The main function for playing Set. Stores selected cards, allows for unselection, and determines matches.
    /// - Parameter card: The most recently tapped on card
    mutating func choose(_ card: Card) {
        if matchResult != 0 {
            dealCards(numberOfCards: 3)
            if card.isMatched {
                return
            }
        }
        matchResult = 0
        if let chosenIndex = cards.firstIndex(where: {$0.id == card.id}) {
            if cards[chosenIndex].isSelected {
                if let indexA = firstCardIdx, indexA == chosenIndex {
                    firstCardIdx = nil
                } else {
                    secondCardIdx = nil
                }
            }
            cards[chosenIndex].isSelected.toggle()
            if cards[chosenIndex].isSelected {
                if let indexA = firstCardIdx {
                    if let indexB = secondCardIdx {
                        if checkSet(cards[indexA], cards[indexB], cards[chosenIndex]) {
                            cards[indexA].isMatched = true
                            cards[indexB].isMatched = true
                            cards[chosenIndex].isMatched = true
                            matchResult = 2
                        } else {
                            cards[indexA].badMatch = true
                            cards[indexB].badMatch = true
                            cards[chosenIndex].badMatch = true
                            matchResult = 1
                        }
                        cards[indexA].isSelected = false
                        cards[indexB].isSelected = false
                        cards[chosenIndex].isSelected = false
                        firstCardIdx = nil
                        secondCardIdx = nil
                    } else {
                        secondCardIdx = chosenIndex
                    }
                } else {
                    firstCardIdx = chosenIndex
                }
            }
        }
    }
    
    /// This function deals any number of remaining cards from the deck. No cards will be dealt if desk is empty.
    /// Also, this function removes any matching or mismatched cards.
    /// - Parameter numberOfCards: The number of cards you wish to deal out.
    mutating func dealCards(numberOfCards: Int) {
        if matchResult != 0 {
            cards.indices.forEach { cards[$0].badMatch = false }
            cards.removeAll { $0.isMatched }
            matchResult = 0
        }
        var cardsToDeal = numberOfCards
        if cardsToDeal > deck.count {
            cardsToDeal = deck.count
        }
        for card in deck[0..<cardsToDeal] {
            cards.append(card)
            deck.removeFirst()
        }
    }
    
    /// This function contains the main logic that validates a successful match in Set.
    /// - Parameters:
    ///   - C1: A card from your set of 3
    ///   - C2: Another card from your set of 3
    ///   - C3: The last card from your set of 3
    /// - Returns: If all properties are different or the same this function returns true.
    private func checkSet(_ C1: Card, _ C2: Card, _ C3: Card) -> Bool {
        if allTrueOrAllFalse(C1.number, C2.number, C3.number) {
            if allTrueOrAllFalse(C1.shape, C2.shape, C3.shape) {
                if allTrueOrAllFalse(C1.shading, C2.shading, C3.shading) {
                    return allTrueOrAllFalse(C1.hue, C2.hue, C3.hue)
                }
            }
        }
        return false
    }
    
    
    /// Generic function that checks 3 inputs are all the same or all different
    /// - Returns: Returns true if all inputs are the same or all different
    func allTrueOrAllFalse<T>(_ A: T, _ B: T, _ C: T) -> Bool where T: Equatable {
        ((A == B && A == C && B == C) || (A != B && A != C && B != C))
    }
    
    /// Initialiazed this struct by creating and shuffling 81 different cards then dealing them.
    /// - Parameter numberOfCards: The number of cards you want to deal in your new game.
    init(numberOfCards: Int) {
        deck = []
        cards = []
        let threeShapes = ["oval", "squiggle", "diamond"]
        let threeShadings = ["solid", "striped", "outline"]
        var id = 0
        for number in 1...3 {
            for shape in threeShapes {
                for shading in threeShadings {
                    deck.append(Card(number: number, shape: shape, shading: shading, hue: Hue.red, id: id))
                    deck.append(Card(number: number, shape: shape, shading: shading, hue: Hue.blue, id: id+1))
                    deck.append(Card(number: number, shape: shape, shading: shading, hue: Hue.purple, id: id+2))
                    id += 3
                }
            }
        }
        deck.shuffle()
        var cardsToDeal = numberOfCards
        if cardsToDeal > deck.count {
            cardsToDeal = deck.count
        }
        for card in deck[0..<cardsToDeal] {
            cards.append(card)
            deck.removeFirst()
        }
    }
    
    /// A Card stores the symbol on the card, the number of times it appears, the styling of the shape, and the color.
    struct Card: Identifiable {
        var isSelected = false // true if card is currently selected
        var isMatched = false // true if card has been apart of a successful match
        var badMatch = false // true if card has been apart of an unsuccessful match
        var number: Int // the number of symbols on the card
        var shape: String // the shape of the symbol on the card
        var shading: String // the styling of the symbol on the card
        var hue: Hue // the hue of the symbol on the card
        var id: Int
    }
    
    /// Stores colors that represent a hue from 0 to 360 with a Double from 0 to 1.
    enum Hue: Double {
        case red = 0.0
        case blue = 0.65
        case purple = 0.77
    }
}
