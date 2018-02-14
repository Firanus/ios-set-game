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
    private let deckHorizontalBorderToSizeRatio: CGFloat = 0.025
    private let deckVerticalBorderToSizeRatio: CGFloat = 0.025
    
    private var deckSize: CGSize
    var deckRect: CGRect
    var discardPileRect: CGRect
    
    init(forViewBounds bounds: CGRect) {
        let deckWidthToBoundsWidth: CGFloat = bounds.height < bounds.width ? 0.475 : 0.9
        let deckHeightToBoundsHeight: CGFloat = bounds.height < bounds.width ? 0.9 : 0.475
        
        deckSize = CGSize(width: bounds.width * deckWidthToBoundsWidth, height: bounds.height * deckHeightToBoundsHeight)
        
        deckRect = CGRect(origin: CGPoint(x: bounds.origin.x + deckSize.width * deckHorizontalBorderToSizeRatio, y: bounds.origin.y + deckSize.height * deckVerticalBorderToSizeRatio), size: deckSize)
        
        let discardPileOrigin: CGPoint = bounds.height < bounds.width
            ? CGPoint(x: bounds.origin.x + deckSize.width + 2 * deckSize.width * deckHorizontalBorderToSizeRatio, y: bounds.origin.y + deckSize.height * deckVerticalBorderToSizeRatio)
            : CGPoint(x: bounds.origin.x + deckSize.width * deckHorizontalBorderToSizeRatio, y: bounds.origin.y + deckSize.height + 2 * deckSize.height * deckVerticalBorderToSizeRatio)
        discardPileRect = CGRect(origin: discardPileOrigin, size: deckSize)
    }
}
