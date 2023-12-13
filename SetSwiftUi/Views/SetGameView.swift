//
//  SetGameView.swift
//  SetSwiftUi
//
//  Created by sam hastings on 02/11/2023.
//

import SwiftUI

/// A view representing a game of Set.
struct SetGameView: View {
    
    /// ViewModel managing the game logic.
    var setGameViewModel: SetGameViewModel
    
    typealias SetCard = SetGame.SetCard
    
    // MARK: - Private Constants
    private let aspectRatio: CGFloat = 2/3
    private let spacing: CGFloat = 4
    private let dealInterval: TimeInterval = 0.15
    private let dealAnimation: Animation = .easeInOut(duration: 1)
    private let deckWidth: CGFloat = 50
    
    // MARK: - State Variables
    @State var isNewGame = false
    @State private var dealtCardIds = Set<SetCard.ID>()
    @State private var matchedCardIds = Set<SetCard.ID>()
    
    //MARK: - Derived State Properties
    
    /// Cards from the game model that haven't been dealt in the view.
    var undealtCards: [SetCard] {
        setGameViewModel.cardsInPlay.filter{ !isDealt($0) }
    }
    
    /// Cards from the game model that have been matched but not yet discarded.
    var unmatchedCards: [SetCard] {
        setGameViewModel.matchedCards.filter{ !isMatched($0) }
    }
    
    // MARK: - Namespaces for Matched Geometry Effect
    @Namespace private var dealingNamespace
    @Namespace private var discardNamespace
    
    // MARK: - View Body
    var body: some View {
        VStack {
            setCardsGrid
                .onAppear { dealCards() }
            HStack {
                deck
                Spacer()
                buttonStack
                Spacer()
                discardPile
            }
            .padding(.horizontal)
        }
        .padding()
    }
    
    // MARK: - Private View Components
    
    /// Grid view for set cards
    private var setCardsGrid: some View {
        AspectVGrid(setGameViewModel.cardsInPlay + setGameViewModel.matchedCards, aspectRatio: aspectRatio) { card in
            if isDealt(card) {
                SetCardView(card, viewModel: setGameViewModel)
                    .matchedGeometryEffect(id: card.id, in: discardNamespace)
                    .matchedGeometryEffect(id: card.id, in: dealingNamespace)
                    .transition(.asymmetric(insertion: .identity, removal: .identity))
                    .padding(spacing)
                    .animation(.default, value: setGameViewModel.cardsInPlay)
                    .onTapGesture {
                        setGameViewModel.selectCard(withId: card.id)
                        withAnimation(.linear.repeatForever(autoreverses: false)) {
                            setGameViewModel.updateCardState()
                        }
                        discardCards()
                    }
            }
        }
    }
    
    /// View displaying dealing deck.
    private var deck: some View {
        return ZStack {
            ForEach(setGameViewModel.deck) { card in
                SetCardView(card, viewModel: setGameViewModel)
                    .matchedGeometryEffect(id: card.id, in: dealingNamespace)
                    .transition(.asymmetric(insertion: .identity, removal: .identity))
            }
            // Using frame here to set a specific size for the deck is acceptable only because I want the deck to take up this exact amount of space regardless of how many cards are in play.
            .frame(width: deckWidth, height: deckWidth / aspectRatio)
            .onTapGesture {
                dealCards()
                discardCards()
            }
        }
    }
    
    /// View displaying the discard card pile.
    private var discardPile: some View {
        return ZStack {
            Color.clear
                .cardify(isFaceUp: true, cardState: .unselected, viewModel: setGameViewModel)
                .frame(width: deckWidth, height: deckWidth / aspectRatio)
            ForEach(setGameViewModel.matchedCards) { card in
                if isMatched(card) {
                    SetCardView(card, viewModel: setGameViewModel)
                        .matchedGeometryEffect(id: card.id, in: discardNamespace)
                        .transition(.asymmetric(insertion: .identity, removal: .identity))
                }
            }
            .frame(width: deckWidth, height: deckWidth / aspectRatio)
        }
    }
    
    /// VStack containing new game and shuffle buttons.
    private var buttonStack: some View {
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
    }
    
    // MARK: - User Interactions
    
    /// Starts a new game.
    func newGame() {
        dealtCardIds = Set<SetCard.ID>()
        matchedCardIds = Set<SetCard.ID>()
        setGameViewModel.newGame()
        dealCards()
    }
    
    /// Shuffles the cards in play.
    func shuffle() {
        setGameViewModel.shuffle()
    }
    
    
    
    // MARK: - Card Dealing and Discarding Logic
    
    /// Deals cards from the deck.
    private func dealCards() {
        var delay: TimeInterval = 0
        setGameViewModel.deal(numCards: setGameViewModel.isFirstDeal ? 12 : 3)
        setGameViewModel.isFirstDeal = false
        //print("dealtCardIds are \(dealtCardIds)")
        for setCard in undealtCards {
            _ = withAnimation(dealAnimation.delay(delay)) {
                dealtCardIds.insert(setCard.id)
            }
            delay += dealInterval
        }
        
    }
    
    /// Discards matched cards to the discard pile.
    private func discardCards() {
        var delay: TimeInterval = 0
        for setCard in unmatchedCards {
            withAnimation(dealAnimation.delay(delay)) {
                matchedCardIds.insert(setCard.id)
                dealtCardIds = dealtCardIds.filter{ !matchedCardIds.contains($0)}
            }
            delay += dealInterval
        }
    }
    
    // MARK: - Card State Helpers
    
    /// Determines if a card has been dealt.
    private func isDealt(_ setCard: SetCard) -> Bool {
        //print("setCard.id is \(setCard.id)")
        return dealtCardIds.contains(setCard.id)
    }
    
    /// Determines if a card has been matched.
    private func isMatched(_ setCard: SetCard) -> Bool {
        matchedCardIds.contains(setCard.id)
    }
    
}

#Preview {
    SetGameView(setGameViewModel: SetGameViewModel())
}

