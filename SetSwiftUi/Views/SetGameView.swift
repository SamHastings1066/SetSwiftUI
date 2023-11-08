//
//  SetGameView.swift
//  SetSwiftUi
//
//  Created by sam hastings on 02/11/2023.
//

import SwiftUI

struct SetGameView: View {
    var setGameViewModel: SetGameViewModel
    
    private let aspectRatio: CGFloat = 2/3
    private let spacing: CGFloat = 4
    
    
    
    var body: some View {
        VStack {
            //Text("Cards in deck: \(setGameViewModel.cardsInPlay.count)")
            setCards
            Button("Deal") {
                setGameViewModel.dealThreeCards()
            }
        }
        .padding()
    }
    
    private var setCards: some View {
        AspectVGrid(setGameViewModel.cardsInPlay, aspectRatio: aspectRatio) { card in
            SetCardView(card)
                .padding(spacing)
                .onTapGesture {
                    setGameViewModel.selectCard(withId: card.id)
                }
        }
    }
}

#Preview {
    SetGameView(setGameViewModel: SetGameViewModel())
}

