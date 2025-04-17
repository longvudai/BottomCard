//
//  PresentationBehavior.swift
//
//
//  Created by longvu on 25/05/2022.
//

import Foundation

@MainActor
public protocol PresentationBehavior {
    var bottomCardPresentationContentSizing: BottomCardPresentationContentSizing { get }
}
