//
//  BottomCardFoldPlacementTests.swift
//
//
//  Created by Claude on 10/10/2026.
//

@testable import BottomCard
import CoreGraphics
import Testing

struct BottomCardFoldPlacementTests {
    struct Case: CustomTestStringConvertible, Sendable {
        let name: String
        let division: CGRect?
        let edge: BottomCardFoldPlacement.BarEdge
        let isRightToLeft: Bool
        let contentWidth: CGFloat
        let expectedX: CGFloat
        let expectedWidth: CGFloat

        var testDescription: String { name }
    }

    static let bounds = CGRect(x: 0, y: 0, width: 951, height: 400)
    static let verticalDivision = CGRect(x: 455.5, y: 0, width: 40, height: 400)
    static let widthOffset: CGFloat = 32

    static let cases: [Case] = [
        Case(
            name: "Book pose, bar right: card centred in the left side",
            division: verticalDivision, edge: .trailing, isRightToLeft: false,
            contentWidth: 400, expectedX: 455.5 / 2 - 200, expectedWidth: 400
        ),
        Case(
            name: "Book pose, bar left: card centred in the right side",
            division: verticalDivision, edge: .leading, isRightToLeft: false,
            contentWidth: 400, expectedX: (495.5 + 951) / 2 - 200, expectedWidth: 400
        ),
        Case(
            name: "RTL, bar leading (physical right): left side",
            division: verticalDivision, edge: .leading, isRightToLeft: true,
            contentWidth: 400, expectedX: 455.5 / 2 - 200, expectedWidth: 400
        ),
        Case(
            name: "RTL, bar trailing (physical left): right side",
            division: verticalDivision, edge: .trailing, isRightToLeft: true,
            contentWidth: 400, expectedX: (495.5 + 951) / 2 - 200, expectedWidth: 400
        ),
        Case(
            name: "No bar, vertical division active: left side",
            division: verticalDivision, edge: .unspecified, isRightToLeft: false,
            contentWidth: 400, expectedX: 455.5 / 2 - 200, expectedWidth: 400
        ),
        Case(
            name: "Flat, closed or pre-27.1: centred",
            division: nil, edge: .trailing, isRightToLeft: false,
            contentWidth: 400, expectedX: 951 / 2 - 200, expectedWidth: 400
        ),
        Case(
            name: "Horizontal fold: centred",
            division: CGRect(x: 0, y: 180, width: 951, height: 40), edge: .trailing, isRightToLeft: false,
            contentWidth: 400, expectedX: 951 / 2 - 200, expectedWidth: 400
        ),
        Case(
            name: "Narrow side: width clamped to side width minus widthOffset",
            division: verticalDivision, edge: .trailing, isRightToLeft: false,
            contentWidth: 440, expectedX: 16, expectedWidth: 455.5 - 32
        ),
    ]

    @Test(arguments: cases)
    func horizontalPlacement(_ testCase: Case) {
        let placement = BottomCardFoldPlacement.horizontalPlacement(
            containerBounds: Self.bounds,
            division: testCase.division,
            isBarOnPhysicalLeft: BottomCardFoldPlacement.isBarOnPhysicalLeft(
                edge: testCase.edge,
                isRightToLeft: testCase.isRightToLeft
            ),
            contentWidth: testCase.contentWidth,
            widthOffset: Self.widthOffset
        )

        #expect(placement.x == testCase.expectedX)
        #expect(placement.width == testCase.expectedWidth)
    }
}
