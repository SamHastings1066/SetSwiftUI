//
//  Cardify.swift
//  SetSwiftUi
//
//  Created by sam hastings on 03/11/2023.
//

import SwiftUI

struct Cardify: ViewModifier {
    let isFaceUp: Bool
    let cardState: SetGame.CardState
    
    func body(content: Content) -> some View {
        let fillColor: Color = {
            switch cardState {
            case .unselected: return .white
            case .selected: return .yellow
            case .set: return .teal
            case .mismatch: return .orange
            }
        }()
        return ZStack {
            let base = RoundedRectangle(cornerRadius: Constants.cornerRadius)
            base.strokeBorder(lineWidth: Constants.lineWidth)
                .background(base.fill(
                    fillColor
                ))
                .overlay(content)
                .opacity(isFaceUp ? 1 : 0)
            // TODO: Move back of card color to view model
            base.fill(.teal)
                .opacity(isFaceUp ? 0 : 1)
        }
    }
    
    private struct Constants {
        static let cornerRadius: CGFloat = 12
        static let lineWidth: CGFloat = 2
    }
}

extension View {
    func cardify(isFaceUp: Bool, cardState: SetGame.CardState) -> some View {
        modifier(Cardify(isFaceUp: isFaceUp, cardState: cardState))
    }
}
