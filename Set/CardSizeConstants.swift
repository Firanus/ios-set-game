//
//  CardSizeConstants.swift
//  Set
//
//  Created by Ivan Tchernev on 08/02/2018.
//  Copyright © 2018 AND Digital. All rights reserved.
//

import Foundation
import UIKit

struct CardSizeConstants {
    private let cardSeperationToCardHeight: CGFloat = 0.025
    private let cardSeperationToCardWidth: CGFloat = 0.05
    
    let cardHeight: CGFloat
    let cardWidth: CGFloat
    let verticalCardSeperation: CGFloat
    let horizontalCardSeperation: CGFloat
    let columnCount: Int
    let rowCount: Int
    
    init(forGameSize size: CGSize, cardCount: Int) {
        columnCount = size.height > size.width ? 4 : 6
        rowCount = Int(ceil(Double(cardCount) / Double(columnCount)))
        
        let baseWidth = size.width / CGFloat(columnCount)
        let baseHeight = size.height / CGFloat(rowCount)
        
        horizontalCardSeperation = baseWidth * cardSeperationToCardWidth
        verticalCardSeperation = baseHeight * cardSeperationToCardHeight
        
        cardWidth = baseWidth - 2 * horizontalCardSeperation
        cardHeight = baseHeight - 2 * verticalCardSeperation
    }
}
