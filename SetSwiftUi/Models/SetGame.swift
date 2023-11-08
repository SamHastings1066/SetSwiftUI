//
//  SetGame.swift
//  SetSwiftUi
//
//  Created by sam hastings on 02/11/2023.
//

import Foundation

/// The model for a `SetGame` containing all properties and methods that define a game.
struct SetGame {
    
    /// The deck of cards used to play a `SetGame`. At the start of the game this deck will consist of all 81 possible cards.
    ///
    private(set) var deck: Array<SetCard> = []
    
    /// The group of cards that have been dealt from `deck`. Does not include those that have been dealt and then matched.
    private(set) var cardsInPlay: Array<SetCard> = []
    
    /// The group of cards currently selected by the player.
    var selectedCards: Array<SetCard> = []
    
    /// The group of cards that have been dealt and then matched.
    var matchedCards: Array<SetCard> = []
    
    
    /// Initialises a SetGame instance by generating `deck` and dealing 12 cards to `cardsInPlay`.
    init() {
        generateDeck()
        deal(numCards: 12)
    }
    
    /// Returns the first card in `deck`, or `nil` if `deck` is empty.
    private mutating func dealNextCard() -> SetCard? {
        guard !deck.isEmpty else { return nil }
        return deck.removeFirst()
    }
    
    /// Removes numCards from deck and appends them to `cardsInPlay`, provided `numCards` is less than the total number of cards in `deck`, else removes all remaining cards from `deck` and appends them to `cardsInPlay`.
    mutating func deal(numCards: Int) {
        for _ in 0..<numCards {
            if let dealtCard = dealNextCard() {
                cardsInPlay.append(dealtCard)
            }
        }
    }
    
    /// Returns a bool representing whether the cards contains in `selectedCards` comprise a Set.
    private func isSet() -> Bool {
        guard selectedCards.count == 3 else { return false }
        return [
            Set(selectedCards.map {$0.color}),
            Set(selectedCards.map {$0.fill}),
            Set(selectedCards.map {$0.number}),
            Set(selectedCards.map {$0.symbol})
        ].allSatisfy{$0.count != 2}
    }
    
    /// Moves cards that have been matched from `selectedCards` to `matchedCards` and empties `selectedCards`.
    mutating func threeCardsAlreadySelected() {
        guard selectedCards.count == 3 else { return }
        let selectedCardsIndices = selectedCards.map{$0.id}
        if isSet() {
            matchedCards.append(contentsOf: selectedCards)
            selectedCardsIndices.forEach { index in
                if let selectedCardInPlayIndex = cardsInPlay.firstIndex(where: {$0.id == index}) {
                    cardsInPlay.remove(at: selectedCardInPlayIndex)
                    if let nextCard = dealNextCard() {
                        cardsInPlay.insert(nextCard, at: selectedCardInPlayIndex)
                    }
                }
            }
        } else {
            selectedCardsIndices.forEach { index in
                if let selectedCardInPlayIndex = cardsInPlay.firstIndex(where: {$0.id == index}) {
                    cardsInPlay[selectedCardInPlayIndex].cardState = .unselected
                }
            }
        }
        selectedCards.removeAll()
    }
    
    private mutating func updateSelectedCardsState() {
        guard selectedCards.count == 3 else { return }
        let selectedCardsIndices = selectedCards.map{$0.id}
        selectedCardsIndices.forEach { index in
            if let selectedCardInPlayIndex = cardsInPlay.firstIndex(where: {$0.id == index}) {
                if isSet() {
                    cardsInPlay[selectedCardInPlayIndex].cardState = .set
                } else {
                    cardsInPlay[selectedCardInPlayIndex].cardState = .mismatch
                }
            }
        }
    }
    
    mutating func selectCard(withId id: String) {
        print(id)
        threeCardsAlreadySelected()
        if let chosenIndex = cardsInPlay.firstIndex(where: {$0.id == id}) {
            if let selectedCardIndex = selectedCards.firstIndex(where: {$0.id == id}) {
                selectedCards.remove(at: selectedCardIndex)
                cardsInPlay[chosenIndex].cardState = .unselected
            } else {
                selectedCards.append(cardsInPlay[chosenIndex])
                cardsInPlay[chosenIndex].cardState = .selected
            }
            updateSelectedCardsState()

        }

    }
    
    /// A type to represent the state of a card that is in play
    enum CardState {
        case unselected, selected, set, mismatch
    }

    
    /// The individual cards in a `SetGame` deck
    struct SetCard: Identifiable {
        /// A `Bool` representing whether the card is face up
        var isFaceUp = true
        
        /// A `Bool` representing whether the card is has been dealt.
        var isDealt = false
        
        /// A `Bool` representing whether the card has been matched with two other cards to make a Set
        var isMatched = false
        
        /// A `CardState` representing the state of the card
        var cardState: CardState = .unselected
        
        /// The symbol displayed on the card
        let symbol: Triad
        
        /// The color of the symbols on the card
        let color: Triad
        
        /// The fill of the symbols on the card
        let fill: Triad
        
        /// The number of symbols displayed on the card
        let number: Triad
        
        /// Unique id of a card computed from its `symbol`, `color`, `fill` and `number`.
        var id: String {
            return String(symbol.rawValue) + String(color.rawValue) + String(fill.rawValue) + String(number.rawValue)
        }
    }
    
    /// Generates a shuffled `deck` with all 81 possible combinations of card `Triad` properties.
    private mutating func generateDeck() {
        for symbol in Triad.allCases {
            for color in Triad.allCases {
                for fill in Triad.allCases {
                    for number in Triad.allCases {
                        let setCard = SetCard(symbol: symbol, color: color, fill: fill, number: number)
                        deck.append(setCard)
                    }
                }
            }
        }
        deck.shuffle()
    }
}

/// A type to represent a variable that can take only three states.
enum Triad: Int, CaseIterable {
    case one = 1, two, three
}
