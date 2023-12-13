//
//  SetGameViewModel.swift
//  SetSwiftUi
//
//  Created by sam hastings on 03/11/2023.
//

import SwiftUI

/// ViewModel for the SetGame. Manages the game logic and provides data for the UI.
@Observable class SetGameViewModel {
    typealias SetCard = SetGame.SetCard
    
    private var setGame = SetGame()
    
    /// Cards currently in play.
    var cardsInPlay: Array<SetCard> {
        return setGame.cardsInPlay
    }
    
    /// Remaining cards in the deck.
    var deck: Array<SetCard> {
         return setGame.deck
    }
    
    /// Cards that have been successfully matched.
    var matchedCards: Array<SetCard> {
        return setGame.matchedCards
    }
    
    /// The color used for the back of the cards.
    var cardBackColor: Color {
        return .teal
    }
    /// Indicates whether it's the first deal of the game.
    var isFirstDeal = true
    
    /// Represents the visual appearance of a SetCard.
    struct SetCardRepresentation {
        let strokeColor: Color
        let strokeLineWidth: CGFloat
        let fillColor: Color
        let opacity: Double
        let number: Int
        let symbol: Triad
        
        init(_ setCard: SetCard){
            strokeColor = {
                switch setCard.color {
                case .one: return .red
                case .two: return .purple
                case .three: return .green
                }
            }()
            strokeLineWidth = {
                switch setCard.fill {
                case .one, .two: return 0
                case .three: return 1 // TODO: have this reflect the size of the card.
                }
            }()
            
            fillColor = {
                if setCard.fill == .three {
                    return .clear
                } else {
                    switch setCard.color {
                    case .one: return .red
                    case .two: return .purple
                    case .three: return .green
                    }
                }
            }()
            opacity = {
                switch setCard.fill {
                case .one, .three: return 1.0
                case .two: return 0.4
                }
            }()
            symbol = setCard.symbol
            number = setCard.number.rawValue
        }
    }
    
    // MARK: - User Intents
    
    /// Starts a new game.
    func newGame() {
        setGame.newGame()
        isFirstDeal = true
    }
    
    /// Shuffles the cards currently in play.
    func shuffle() {
        setGame.shuffle()
    }
    
    /// Deals three cards.
    func dealThreeCards() {
        setGame.deal(numCards: 3)
        
    }

    /// Selects or deselects a card based on its identifier string `id`.
    func selectCard(withId id: String) {
        setGame.selectCard(withId: id)
    }
    

    // MARK: - Other Methods
    
    /// Deals `numCards` number of cards.
    func deal(numCards: Int) {
        setGame.deal(numCards: numCards)
    }
    
    /// Updates the state of the selected cards.
    func updateCardState() {
        setGame.updateCardState()
    }
    
    /// Gets the visual representation of a SetCard.
    func setCardRepresentation(_ setCard: SetCard) -> SetCardRepresentation {
        return SetCardRepresentation(setCard)
    }
    


}
