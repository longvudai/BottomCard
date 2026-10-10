//
//  BottomCardFoldPlacement.swift
//
//
//  Created by Claude on 10/10/2026.
//

import CoreGraphics

/// Horizontal placement of a bottom card on a display with an active fold.
///
/// UIKit puts its own sheets and alerts on the side of an active vertical fold
/// away from the vertical bar. This mirrors that using plain geometry, so it can be
/// tested without iOS 27.1 types.
enum BottomCardFoldPlacement {
    /// Where the system places the vertical bar, relative to the layout direction.
    enum BarEdge {
        case unspecified
        case leading
        case trailing
    }

    /// Whether the vertical bar is on the physical left of the screen.
    /// `.unspecified` counts as right, so the card goes left, where UIKit puts sheets.
    static func isBarOnPhysicalLeft(edge: BarEdge, isRightToLeft: Bool) -> Bool {
        switch edge {
        case .unspecified: false
        case .leading: !isRightToLeft
        case .trailing: isRightToLeft
        }
    }

    /// The card's x and width.
    ///
    /// - Parameters:
    ///   - containerBounds: The presentation container's bounds.
    ///   - division: The active division region's frame, margins included, in the container's coordinates.
    ///     A division wider than tall (a horizontal fold) is ignored.
    ///   - isBarOnPhysicalLeft: Whether the vertical bar is on the physical left.
    ///   - contentWidth: The card's width before placement.
    ///   - widthOffset: Horizontal space kept free around the card.
    static func horizontalPlacement(
        containerBounds: CGRect,
        division: CGRect?,
        isBarOnPhysicalLeft: Bool,
        contentWidth: CGFloat,
        widthOffset: CGFloat
    ) -> (x: CGFloat, width: CGFloat) {
        guard let division, division.height >= division.width else {
            return (containerBounds.midX - contentWidth / 2, contentWidth)
        }

        let side = isBarOnPhysicalLeft
            ? CGRect(
                x: division.maxX,
                y: containerBounds.minY,
                width: containerBounds.maxX - division.maxX,
                height: containerBounds.height
            )
            : CGRect(
                x: containerBounds.minX,
                y: containerBounds.minY,
                width: division.minX - containerBounds.minX,
                height: containerBounds.height
            )

        let width = max(0, min(contentWidth, side.width - widthOffset))
        return (side.midX - width / 2, width)
    }
}
