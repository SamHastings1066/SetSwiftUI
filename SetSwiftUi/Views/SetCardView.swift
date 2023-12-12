//
//  SetCardView.swift
//  SetSwiftUi
//
//  Created by sam hastings on 03/11/2023.
//

import SwiftUI

struct SetCardView: View {
    typealias SetCard = SetGame.SetCard
    let setCard: SetCard
    let viewModel: SetGameViewModel
    
    init(_ setCard: SetCard, viewModel: SetGameViewModel) {
        self.setCard = setCard
        self.viewModel = viewModel
    }
    
    ///
    @ViewBuilder
    private func generateSymbol(for setCard: SetGame.SetCard) -> some View {
        switch setCard.symbol {
        case .one:  applyShading(to: Diamond(), for: setCard)
        case .two:  applyShading(to: Circle(), for: setCard)
        case .three:  applyShading(to: Rectangle(), for: setCard)
        }
    }
    
    private func applyShading(to shape: some Shape, for setCard: SetCard) -> some View {
        let setCardRepresentation = viewModel.setCardRepresentation(setCard)
        return shape
            .stroke(setCardRepresentation.strokeColor, lineWidth: setCardRepresentation.strokeLineWidth)
            .fill(setCardRepresentation.fillColor)
            .opacity(setCardRepresentation.opacity)
            .aspectRatio(2, contentMode: .fit) // aspect ratio of 2 for the symbol inside the card is 3 x 2/3 - i.e. three times the aspect ratio of the card itself.
    }
        
    var body: some View {
        let inset = CGFloat(10)
        LazyVGrid(columns: [GridItem()], content: {
            ForEach(0..<setCard.number.rawValue, id: \.self) { _ in
                generateSymbol(for: setCard)
            }
        })
        .padding(EdgeInsets(top: inset, leading: inset, bottom: inset, trailing: inset))
            .cardify(isFaceUp: setCard.isFaceUp, cardState: setCard.cardState, viewModel: viewModel)
        .rotationEffect(Angle(degrees: setCard.cardState == .mismatch ? 180 : 0))
        .scaleEffect(setCard.cardState == .set ? CGSize(width: 2.0, height: 2.0) : CGSize(width: 1.0, height: 1.0))
        .zIndex(setCard.cardState == .set ? 100 : 0 )
    }
    
}

//#Preview {
//    let viewModel = SetGameViewModel()
//    VStack {
//        HStack{
//            SetCardView(SetGame.SetCard(symbol: .one, color: .one, fill: .one, number: .one), viewModel: viewModel)
//            SetCardView(SetGame.SetCard(symbol: .two, color: .two, fill: .one, number: .three), viewModel: viewModel)
//        }
//        HStack{
//            SetCardView(SetGame.SetCard(symbol: .one, color: .one, fill: .three, number: .one), viewModel: viewModel)
//            SetCardView(SetGame.SetCard(symbol: .three, color: .one, fill: .one, number: .two), viewModel: viewModel)
//        }
//    }
//    .padding()
//}
