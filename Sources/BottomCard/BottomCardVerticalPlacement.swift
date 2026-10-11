//
//  BottomCardVerticalPlacement.swift
//
//
//  Created by Claude on 11/10/2026.
//

import CoreGraphics

/// Vertical placement of a bottom card.
///
/// Content taller than the space above the bottom offset (an iPhone in landscape) is capped so the
/// card's top stays below the top safe area; the card's own content scrolls for the rest.
enum BottomCardVerticalPlacement {
    /// The card's y and height.
    ///
    /// - Parameters:
    ///   - containerHeight: The presentation container's height.
    ///   - topInset: The container's top safe-area inset.
    ///   - contentHeight: The card's fitting height before placement.
    ///   - bottomOffset: Vertical space kept free below the card.
    ///   - keyboardHeight: The height of the keyboard covering the container, or 0.
    static func verticalPlacement(
        containerHeight: CGFloat,
        topInset: CGFloat,
        contentHeight: CGFloat,
        bottomOffset: CGFloat,
        keyboardHeight: CGFloat
    ) -> (y: CGFloat, height: CGFloat) {
        let bottom = containerHeight - bottomOffset - keyboardHeight
        let height = max(0, min(contentHeight, bottom - topInset))
        return (bottom - height, height)
    }
}
