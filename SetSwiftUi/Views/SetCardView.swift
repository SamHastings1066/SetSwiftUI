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
    let setCardRepresentation: SetCardRepresentation
    //typealias SetCardRepresentation = SetGameViewModel.SetCardRepresentation
    //let setCardRepresentation: SetCardRepresentation
    
    init(_ setCard: SetCard) {
        self.setCard = setCard
        setCardRepresentation = SetCardRepresentation(setCard)
    }
        
    var body: some View {
        let inset = CGFloat(10)
        LazyVGrid(columns: [GridItem()], content: {
            ForEach(0..<setCard.number.rawValue, id: \.self) { _ in
                setCardRepresentation.generateSymbol()
            }
        })
        .padding(EdgeInsets(top: inset, leading: inset, bottom: inset, trailing: inset))
        .cardify(isFaceUp: setCard.isFaceUp, cardState: setCard.cardState)
    }
    
    private struct Constants {

        static let inset: CGFloat = 5
        struct FontSize {
            static let largest: CGFloat = 200
            static let smallest: CGFloat = 10
            static let scaleFactor: CGFloat = smallest / largest
        }
        struct Pie {
            static let opacity: CGFloat = 0.5
            static let inset: CGFloat = 5
        }
    }
    
    // TODO: Move to ViewModel
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
        
        func applyShading(to shape: some Shape) -> some View {
            shape
                .stroke(strokeColor, lineWidth: strokeLineWidth)
                .fill(fillColor)
                .opacity(opacity)
                .aspectRatio(2, contentMode: .fit)
                
        }
        
        @ViewBuilder
        func generateSymbol() -> some View {
            switch symbol {
            case .one:  applyShading(to: Diamond())
            case .two:  applyShading(to: Circle())
            case .three:  applyShading(to: Rectangle())
            }
        }
    }
}

#Preview {
    VStack {
        HStack{
            SetCardView(SetGame.SetCard(symbol: .one, color: .one, fill: .one, number: .one))
            SetCardView(SetGame.SetCard(symbol: .two, color: .two, fill: .one, number: .three))
        }
        HStack{
            SetCardView(SetGame.SetCard(symbol: .one, color: .one, fill: .three, number: .one))
            SetCardView(SetGame.SetCard(symbol: .three, color: .one, fill: .one, number: .two))
        }
    }
    .padding()
}
