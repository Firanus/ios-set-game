//
//  SetGameView.swift
//  Set
//
//  Created by Ivan Tchernev on 30/01/2018.
//  Copyright © 2018 AND Digital. All rights reserved.
//

import UIKit

@IBDesignable
class SetGameView: UIView {
    
    var cardViews: [SetCardView]? {
        didSet {
            setNeedsLayout()
        }
    }
    
    private let cardSeperationToCardHeight: CGFloat = 0.025
    private let cardSeperationToCardWidth: CGFloat = 0.05
    
    override func layoutSubviews() {
        super.layoutSubviews()
        removeCurrentCards()
        arrangeCardViews()
    }
    
    private func removeCurrentCards() {
        for subUIView in self.subviews as [UIView] {
            subUIView.removeFromSuperview()
        }
    }
    
    private func arrangeCardViews() {
        if let cards = cardViews {
            let columnCount = bounds.height > bounds.width ? 4 : 6
            let rowCount = Int(ceil(Double(cards.count) / Double(columnCount)))
            
            var cardWidth = bounds.width / CGFloat(columnCount)
            var cardHeight = bounds.height / CGFloat(rowCount)
            
            let horizontalCardSeperation = cardWidth * cardSeperationToCardWidth
            let verticalCardSeperation = cardHeight * cardSeperationToCardHeight
            
            cardWidth -= 2 * horizontalCardSeperation
            cardHeight -= 2 * verticalCardSeperation
            
            for row in 0..<rowCount {
                for column in 0..<columnCount {
                    if row * columnCount + column < cards.count {
                        let card = cards[row * columnCount + column]
                        let xOrigin = bounds.origin.x + CGFloat(column) * cardWidth + (2 * CGFloat(column) + 1) * horizontalCardSeperation
                        let yOrigin = bounds.origin.y + CGFloat(row) * cardHeight + (2 * CGFloat(row) + 1) * verticalCardSeperation
                        card.frame.origin = CGPoint(x: xOrigin, y: yOrigin)
                        card.frame.size = CGSize(width: cardWidth, height: cardHeight)
                        addSubview(card)
                    }
                }
            }
        }
    }
}
