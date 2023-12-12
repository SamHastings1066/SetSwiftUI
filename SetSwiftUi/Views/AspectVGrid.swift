//
//  AspectVGrid.swift
//  SetSwiftUi
//
//  Created by sam hastings on 02/11/2023.
//

import SwiftUI

struct AspectVGrid<Item: Identifiable, ItemView: View>: View {
    let items: [Item]
    var aspectRatio: CGFloat = 1
    // closure that takes an item and returns an ItemView
    let content: (Item) -> ItemView
    
    init(_ items: [Item], aspectRatio: CGFloat, @ViewBuilder content: @escaping (Item) -> ItemView) {
        self.items = items
        self.aspectRatio = aspectRatio
        self.content = content
    }
    
    /// The body of the `AspectVGrid` view, creating a grid layout of the items.
    ///
    /// This view calculates the appropriate grid item size based on the available space and specified aspect ratio, and lays out the items in a lazy vertical grid.
    ///
    /// - Returns: A view representing a vertical grid of items.
    var body: some View {
        GeometryReader { geometry in
            let gridItemSize = gridItemWidthThatFits(
                count: items.count,
                size: geometry.size,
                atAspectRatio: aspectRatio
            )
            LazyVGrid(columns: [GridItem(.adaptive(minimum: gridItemSize), spacing: 0)], spacing: 0) {
                ForEach(items) { item in
                    content(item)
                        .aspectRatio(aspectRatio, contentMode: .fit)
                }
            }
        }
    }
    
    /// Calculates the width for grid items that best fits the available size while maintaining the specified aspect ratio.
    ///
    /// This function iteratively adjusts the column count to find an optimal width for the items, ensuring they fit within the given size constraints.
    ///
    /// - Parameters:
    ///   - count: The total number of items in the grid.
    ///   - size: The available size for the grid (width and height).
    ///   - aspectRatio: The desired aspect ratio for each item.
    /// - Returns: The calculated width for each grid item.
    private func gridItemWidthThatFits(
        count: Int,
        size: CGSize,
        atAspectRatio aspectRatio: CGFloat
    ) -> CGFloat {
        let count = CGFloat(count)
        var columnCount = 1.0
        repeat {
            let width = size.width / columnCount
            let height = width / aspectRatio
            
            let rowCount = (count / columnCount).rounded(.up)
            if rowCount * height < size.height {
                return (size.width / columnCount).rounded(.down)
            }
            columnCount += 1
        } while columnCount < count
        return min(size.width / count, size.height * aspectRatio).rounded(.down)
    }
}
