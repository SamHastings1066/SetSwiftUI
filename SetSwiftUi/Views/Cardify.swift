//
//  Cardify.swift
//  SetSwiftUi
//
//  Created by sam hastings on 03/11/2023.
//

import SwiftUI

/// A view modifier that applies a card-like appearance to a view.
struct Cardify: ViewModifier {
    
    // MARK: - Properties
    let isFaceUp: Bool
    let cardState: SetGame.CardState
    let backColor: Color
    
    // MARK: - Constants
    private struct Constants {
        static let cornerRadius: CGFloat = 12
        static let lineWidth: CGFloat = 2
    }
    
    // MARK: - Body
    /// The body of the `Cardify` view modifier.  Applies styling based on the card state and orientation.
    func body(content: Content) -> some View {
        return ZStack {
            let base = RoundedRectangle(cornerRadius: Constants.cornerRadius)
            base.strokeBorder(lineWidth: Constants.lineWidth)
                .background(base.fill(
                    fillColorForState
                ))
                .overlay(content)
                .opacity(isFaceUp ? 1 : 0)
            base.fill(backColor)
                .opacity(isFaceUp ? 0 : 1)
        }
    }
    
    // MARK: - Private Helper
    /// Determines the fill color for the card based on its state.
    private var fillColorForState: Color {
        switch cardState {
        case .unselected: return .white
        case .selected: return .yellow
        case .set: return .teal
        case .mismatch: return .orange
        }
    }
    

}

// MARK: - View Extension
extension View {
    /// Applies the `Cardify` modifier to the view.
    func cardify(isFaceUp: Bool, cardState: SetGame.CardState, viewModel: SetGameViewModel) -> some View {
        modifier(Cardify(isFaceUp: isFaceUp, cardState: cardState, backColor: viewModel.cardBackColor))
    }
}
