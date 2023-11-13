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
    
//    func cardState(withId id: String) -> SetGame.CardState {
//        return setGame.cardsInPlay.first(where: {$0.id == id})?.cardState ?? .unselected
//    }
//    
    func updateSelectedCardsState() {
        setGame.updateSelectedCardsState()
    }
    
    // MARK: - Intents
    
    func dealThreeCards() {
        setGame.deal(numCards: 3)
        
    }
    
    func newGame() {
        setGame.newGame()
        isFirstDeal = true
        //setGame.deal(numCards: 12)
    }
    
    func shuffle() {
        setGame.shuffle()
    }
    
    func selectCard(withId id: String) {
        setGame.selectCard(withId: id)
    }
    

}
