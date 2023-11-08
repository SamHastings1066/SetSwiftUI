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
    
    // MARK: - Intents
    
    func dealThreeCards() {
        setGame.deal(numCards: 3)
    }
    
    func selectCard(withId id: String) {
        setGame.selectCard(withId: id)
    }
    

}
