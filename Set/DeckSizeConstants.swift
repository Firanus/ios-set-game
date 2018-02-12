//
//  DeckSizeConstants.swift
//  Set
//
//  Created by Ivan Tchernev on 09/02/2018.
//  Copyright © 2018 AND Digital. All rights reserved.
//

import Foundation
import UIKit

struct DeckSizeConstants {
    private let deckWidthToBoundsWidth: CGFloat = 0.475
    private let deckHeightToBoundsHeight: CGFloat = 0.9
    private let deckHorizontalBorderToSizeRatio: CGFloat = 0.0125
    private let deckVerticalBorderToSizeRatio: CGFloat = 0.05
    
    private var deckSize: CGSize
    var deckRect: CGRect
    var discardPileRect: CGRect
    
    init(forViewBounds bounds: CGRect) {
        deckSize = CGSize(width: bounds.width * deckWidthToBoundsWidth, height: bounds.height * deckHeightToBoundsHeight)
        
        deckRect = CGRect(origin: CGPoint(x: bounds.origin.x + deckSize.width * deckHorizontalBorderToSizeRatio, y: bounds.origin.y + deckSize.height * deckVerticalBorderToSizeRatio), size: deckSize)
        discardPileRect = CGRect(origin: CGPoint(x: bounds.maxX - deckSize.width - deckSize.width * deckHorizontalBorderToSizeRatio, y: bounds.origin.y + deckSize.height * deckVerticalBorderToSizeRatio), size: deckSize)
    }
}
