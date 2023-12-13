//
//  SetGame.swift
//  SetSwiftUi
//
//  Created by sam hastings on 02/11/2023.
//

import Foundation

/// A type to represent a variable that can take only three states.
enum Triad: Int, CaseIterable {
    case one = 1, two, three
}

/// Represents a game of Set with a deck of cards, cards in play, and matched cards.
struct SetGame {
    
    static var gameNumber = 0
    
    // MARK: - Structures
    
    /// Represents an individual card in a Set game.
    struct SetCard: Identifiable, Equatable {
        /// A `Bool` representing whether the card is face up
        var isFaceUp = false
        
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
            return String(symbol.rawValue) + String(color.rawValue) + String(fill.rawValue) + String(number.rawValue) + String(SetGame.gameNumber)
        }
        //let id = UUID().uuidString
    }
    
    // MARK: - Properties
    
    /// The deck of cards used to play a `SetGame`. At the start of the game this deck will consist of all 81 possible cards.
    private(set) var deck: Array<SetCard> = []
    
    /// The group of cards that have been dealt from `deck`. Does not include those that have been dealt and then matched.
    private(set) var cardsInPlay: Array<SetCard> = []
    
    /// The group of cards currently selected by the player.
    private var selectedCards: Array<SetCard> = []
    
    /// The group of cards that have been dealt and then matched.
    private(set) var matchedCards: Array<SetCard> = []
    
    // MARK: - Initializers
    
    /// Initializes a new game of Set.
    init() {
        generateDeck()
    }
    
    // MARK: - Public Methods
    
    /// Starts a new game by emptying all card arrays and generating a new deck.
    mutating func newGame() {
        SetGame.gameNumber += 1
        deck = []
        cardsInPlay = []
        selectedCards = []
        matchedCards = []
        generateDeck()
    }
    
    /// Shuffles the cards currently in play.
    mutating func shuffle() {
        cardsInPlay.shuffle()
    }
    
    /// Deals a specified number of cards from the `deck` to the `cardsInPlay`.
        /// - Parameter numCards: The number of cards to deal.
    mutating func deal(numCards: Int) {
        // Handle case where three cards are already selected before dealing new cards.
        handleThreeCardSelection()
        for _ in 0..<numCards {
            if let dealtCard = dealNextCard() {
                cardsInPlay.append(dealtCard)
            }
        }
    }
    
    /// When three cards are selected, updates the state of the selected cards to either 'set' or 'mismatch'.
    mutating func updateCardState() {
        guard selectedCards.count == 3 else { return }

        let newState: CardState = isSet() ? .set : .mismatch
        updateStateOfSelectedCards(to: newState)
    }
    
    /// Selects or deselects a card based on its identifier and whether it is already selected.
    /// - Parameter cardID: The unique identifier of the card to be selected or deselected.
    mutating func selectCard(withId id: String) {
        // If three cards are already selected, handle their selection status.
        handleThreeCardSelection()
        
        // Ensure the card is in play before proceeding.
        guard let chosenIndex = cardsInPlay.firstIndex(where: {$0.id == id}) else { return }
            
        if let selectedCardIndex = selectedCards.firstIndex(where: {$0.id == id}) {
            selectedCards.remove(at: selectedCardIndex)
            cardsInPlay[chosenIndex].cardState = .unselected
        } else {
            selectedCards.append(cardsInPlay[chosenIndex])
            cardsInPlay[chosenIndex].cardState = .selected
        }
    }
    
    // MARK: - Private Helper Methods
    
    /// Returns the first card in `deck`, or `nil` if `deck` is empty.
    private mutating func dealNextCard() -> SetCard? {
        guard !deck.isEmpty else { return nil }
        var nextCard = deck.removeFirst()
        nextCard.isFaceUp = true
        return nextCard
    }
    
    /// Returns a bool representing whether the cards contained in `selectedCards` comprise a Set.
    private func isSet() -> Bool {
        guard selectedCards.count == 3 else { return false }
        //return true
        return [
            Set(selectedCards.map {$0.color}),
            Set(selectedCards.map {$0.fill}),
            Set(selectedCards.map {$0.number}),
            Set(selectedCards.map {$0.symbol})
        ].allSatisfy{$0.count != 2}
    }
    
    /// Handles the selection logic when three cards are already selected.
    /// Moves matched cards or resets unmatched cards based on whether they form a set.
    private mutating func handleThreeCardSelection() {
        guard selectedCards.count == 3 else { return }

        if isSet() {
            moveMatchedCards()
        } else {
            resetUnmatchedCards()
        }
        selectedCards.removeAll()
    }
    
    /// Moves cards from `cardsInPlay` to `matchedCards`.
    private mutating func moveMatchedCards() {
        matchedCards.append(contentsOf: selectedCards)
        selectedCards.forEach { card in
            if let index = cardsInPlay.firstIndex(where: { $0.id == card.id }) {
                cardsInPlay.remove(at: index)
            }
        }
    }
    
    /// Resets `cardState` of unmatched cards to `.unselected`.
    private mutating func resetUnmatchedCards() {
        selectedCards.forEach { card in
            if let index = cardsInPlay.firstIndex(where: { $0.id == card.id }) {
                cardsInPlay[index].cardState = .unselected
            }
        }
    }

    /// Updates `cardState` of `selectedCards` to `newState`.
    private mutating func updateStateOfSelectedCards(to newState: CardState) {
        for id in selectedCards.map({ $0.id }) {
            if let index = cardsInPlay.firstIndex(where: { $0.id == id }) {
                cardsInPlay[index].cardState = newState
            }
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
    
    // MARK: - Enumerations
    
    /// Represents one of three possible states or values.
    enum CardState {
        case unselected, selected, set, mismatch
    }
}

