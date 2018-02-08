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
            if let cardCount = cardViews?.count {
                cardsizeConstants = CardSizeConstants(forViewBounds: bounds, cardCount: cardCount)
            }
        }
    }
    
    var cardsizeConstants: CardSizeConstants?
    
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
        if let cards = cardViews, let constants = cardsizeConstants {
            for row in 0..<constants.rowCount {
                for column in 0..<constants.columnCount {
                    if row * constants.columnCount + column < cards.count {
                        let card = cards[row * constants.columnCount + column]
                        let xOrigin = bounds.origin.x + CGFloat(column) * constants.cardWidth + (2 * CGFloat(column) + 1) * constants.horizontalCardSeperation
                        let yOrigin = bounds.origin.y + CGFloat(row) * constants.cardHeight + (2 * CGFloat(row) + 1) * constants.verticalCardSeperation
                        card.frame.origin = CGPoint(x: xOrigin, y: yOrigin)
                        card.frame.size = CGSize(width: constants.cardWidth, height: constants.cardHeight)
                        addSubview(card)
                    }
                }
            }
        }
    }
}

extension SetGameView {
    struct AnimationConsts {
        static let dealingAnimationLength: TimeInterval = 0.6
    }
    
    struct CardSizeConstants {
        private let cardSeperationToCardHeight: CGFloat = 0.025
        private let cardSeperationToCardWidth: CGFloat = 0.05
        
        let cardHeight: CGFloat
        let cardWidth: CGFloat
        let verticalCardSeperation: CGFloat
        let horizontalCardSeperation: CGFloat
        let columnCount: Int
        let rowCount: Int
        
        init(forViewBounds bounds: CGRect, cardCount: Int) {
            columnCount = bounds.height > bounds.width ? 4 : 6
            rowCount = Int(ceil(Double(cardCount) / Double(columnCount)))
            
            let baseWidth = bounds.width / CGFloat(columnCount)
            let baseHeight = bounds.height / CGFloat(rowCount)
            
            horizontalCardSeperation = baseWidth * cardSeperationToCardWidth
            verticalCardSeperation = baseHeight * cardSeperationToCardHeight
            
            cardWidth = baseWidth - 2 * horizontalCardSeperation
            cardHeight = baseHeight - 2 * verticalCardSeperation
        }
    }
}
