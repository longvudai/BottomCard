//
//  BottomCardVerticalPlacementTests.swift
//
//
//  Created by Claude on 11/10/2026.
//

@testable import BottomCard
import CoreGraphics
import Testing

struct BottomCardVerticalPlacementTests {
    @Test
    func contentThatFitsKeepsItsHeight() {
        let placement = BottomCardVerticalPlacement.verticalPlacement(
            containerHeight: 874, topInset: 62, contentHeight: 520, bottomOffset: 32, keyboardHeight: 0
        )
        #expect(placement.height == CGFloat(520))
        #expect(placement.y == CGFloat(874 - 32 - 520))
    }

    /// iPhone 17 Pro landscape: the sharing guide (about 520 pt) is taller than the screen.
    @Test
    func tallContentIsCappedBelowTheTopSafeArea() {
        let placement = BottomCardVerticalPlacement.verticalPlacement(
            containerHeight: 402, topInset: 0, contentHeight: 520, bottomOffset: 32, keyboardHeight: 0
        )
        #expect(placement.y >= CGFloat(0))
        #expect(placement.y + placement.height == CGFloat(402 - 32))
    }

    @Test
    func keyboardLiftsAndCapsTheCard() {
        let placement = BottomCardVerticalPlacement.verticalPlacement(
            containerHeight: 874, topInset: 62, contentHeight: 600, bottomOffset: 32, keyboardHeight: 336
        )
        #expect(placement.y == CGFloat(62))
        #expect(placement.y + placement.height == CGFloat(874 - 32 - 336))
    }
}
