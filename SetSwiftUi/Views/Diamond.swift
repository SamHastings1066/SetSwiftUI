//
//  Diamond.swift
//  SetSwiftUi
//
//  Created by sam hastings on 03/11/2023.
//

import SwiftUI

/// A custome Shape that represents a diamond.
struct Diamond: Shape {
    func path(in rect: CGRect) -> Path {
        let topPoint = CGPoint(x: rect.midX, y: rect.minY)
        let rightPoint = CGPoint(x: rect.maxX, y: rect.midY)
        let bottomPoint = CGPoint(x: rect.midX, y: rect.maxY)
        let leftPoint = CGPoint(x: rect.minX, y: rect.midY)
        var p = Path()
        p.move(to: topPoint)
        p.addLine(to: rightPoint)
        p.addLine(to: bottomPoint)
        p.addLine(to: leftPoint)
        p.closeSubpath()
        return p
    }
}
