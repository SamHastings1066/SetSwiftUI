//
//  SetGameViewModel.swift
//  SetSwiftUi
//
//  Created by sam hastings on 03/11/2023.
//

import SwiftUI

@Observable class SetGameViewModel {
    typealias SetCard = SetGame.SetCard
    
    private var setGame = SetGame()
    
    var cardsInPlay: Array<SetCard> {
        return setGame.cardsInPlay
    }
    
    var deck: Array<SetCard> {
         return setGame.deck
    }
    
    var matchedCards: Array<SetCard> {
        return setGame.matchedCards
    }
    
    func deal(numCards: Int) {
        setGame.deal(numCards: numCards)
    }
    
    var cardBackColor: Color {
        return .teal
    }
    
    var isFirstDeal = true
    
    func updateCardState() {
        setGame.updateCardState()
    }
    
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
    
    func setCardRepresentation(_ setCard: SetCard) -> SetCardRepresentation {
        return SetCardRepresentation(setCard)
    }
    
    
    // MARK: - Intents
    
    func dealThreeCards() {
        setGame.deal(numCards: 3)
        
    }
    
    func newGame() {
        setGame.newGame()
        isFirstDeal = true

    }
    
    func shuffle() {
        setGame.shuffle()
    }
    
    func selectCard(withId id: String) {
        setGame.selectCard(withId: id)
    }
    

}
