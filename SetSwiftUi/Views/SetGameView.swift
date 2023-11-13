//
//  SetGameView.swift
//  SetSwiftUi
//
//  Created by sam hastings on 02/11/2023.
//

import SwiftUI

struct SetGameView: View {
    var setGameViewModel: SetGameViewModel
    typealias SetCard = SetGame.SetCard
    
    private let aspectRatio: CGFloat = 2/3
    private let spacing: CGFloat = 4
    private let dealInterval: TimeInterval = 0.15
    private let dealAnimation: Animation = .easeInOut(duration: 1)
    private let deckWidth: CGFloat = 50
    
    @State var isNewGame = false
    
    var body: some View {
        VStack {
            setCards
                .onAppear { deal() }
            HStack {
                deck
                Spacer()
                VStack {
                    Button(action: newGame) {
                        Text("New Game")
                    }
                    Text("")
                    Button {
                        shuffle()
                    } label: {
                        Text("Shuffle")
                    }
                }

                Spacer()
                discardPile
            }
            .padding(.horizontal)
        }
        .padding()
    }
    
    @Namespace private var dealingNamespace
    
    func newGame() {
        dealtCardIds = Set<SetCard.ID>()
        matchedCardIds = Set<SetCard.ID>()
        setGameViewModel.newGame()
        deal()
    }
    
    func shuffle() {
        setGameViewModel.shuffle()
    }
    
    private var deck: some View {
        return ZStack {
            ForEach(setGameViewModel.deck) { card in
                SetCardView(card)
                    .matchedGeometryEffect(id: card.id, in: dealingNamespace)
                    .transition(.asymmetric(insertion: .identity, removal: .identity))
            }
            // Using frame here to set a specific size for the deck is acceptable only because we want the deck to take up this exact amount of space regardless of how many cards are in play.
            .frame(width: deckWidth, height: deckWidth / aspectRatio)
            .onTapGesture {
                deal()
                discard()
            }
        }
    }
    
    @State private var dealtCardIds = Set<SetCard.ID>()
    
    private func isDealt(_ setCard: SetCard) -> Bool {
        dealtCardIds.contains(setCard.id)
    }
    
    var undealtCards: [SetCard] {
        setGameViewModel.cardsInPlay.filter{ !isDealt($0) }
    }
    
    private func deal() {
        var delay: TimeInterval = 0
        setGameViewModel.deal(numCards: setGameViewModel.isFirstDeal ? 12 : 3)
        setGameViewModel.isFirstDeal = false
        for setCard in undealtCards {
            _ = withAnimation(dealAnimation.delay(delay)) {
                dealtCardIds.insert(setCard.id)
            }
            delay += dealInterval
        }
        
    }
    
    @Namespace private var discardNamespace
    
    private var discardPile: some View {
        return ZStack {
            Color.clear
                .cardify(isFaceUp: true, cardState: .unselected)
                .frame(width: deckWidth, height: deckWidth / aspectRatio)
            ForEach(setGameViewModel.matchedCards) { card in
                if isMatched(card) {
                    SetCardView(card)
                        .matchedGeometryEffect(id: card.id, in: discardNamespace)
                        .transition(.asymmetric(insertion: .identity, removal: .identity))
                }
            }
            .frame(width: deckWidth, height: deckWidth / aspectRatio)
        }
    }
    
    @State private var matchedCardIds = Set<SetCard.ID>()
    
    private func isMatched(_ setCard: SetCard) -> Bool {
        matchedCardIds.contains(setCard.id)
    }
    
    var unmatchedCards: [SetCard] {
        setGameViewModel.matchedCards.filter{ !isMatched($0) }
    }
    
    private func discard() {
        var delay: TimeInterval = 0
        for setCard in unmatchedCards {
            withAnimation(dealAnimation.delay(delay)) {
                matchedCardIds.insert(setCard.id)
                dealtCardIds = dealtCardIds.filter{ !matchedCardIds.contains($0)}
            }
            delay += dealInterval
        }
    }
    
    private var setCards: some View {
        AspectVGrid(setGameViewModel.cardsInPlay + setGameViewModel.matchedCards, aspectRatio: aspectRatio) { card in
            if isDealt(card) {
                SetCardView(card)
                    .matchedGeometryEffect(id: card.id, in: discardNamespace)
                    .matchedGeometryEffect(id: card.id, in: dealingNamespace)
                    .transition(.asymmetric(insertion: .identity, removal: .identity))
                    // 42:50 lecture 8
                    //.rotationEffect(Angle(degrees: card.cardState == .set ? 180 : 0))
                    //.animation(.linear.repeatForever(autoreverses: false), value: card)
                    .padding(spacing)
                // TODO: have this implicit animation work wiht the repeat forever animation below
                    .animation(.default, value: setGameViewModel.cardsInPlay)
                    .onTapGesture {
                        setGameViewModel.selectCard(withId: card.id)
                        
                        withAnimation(.linear.repeatForever(autoreverses: false)) {
                            setGameViewModel.updateCardState()
                            //setGameViewModel.updateSelectedCardsState()
                        }
                        
                        discard()
                    }
                    
                
                //withAnimation(.linear.repeatForever(autoreverses: false)) {
                //}
            }
        }
    }
}

#Preview {
    SetGameView(setGameViewModel: SetGameViewModel())
}

