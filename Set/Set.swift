//
//  Set.swift
//  Set
//
//  Created by Ivan Tchernev on 23/01/2018.
//  Copyright © 2018 AND Digital. All rights reserved.
//

import Foundation

class Set {
    var unusedCards = [Card]()
    var matchedCards = [Card]()
    
    init() {
        let numberOfVariations = Card.CardProperty.allValues.count
        for i in 0..<numberOfVariations {
            for j in 0..<numberOfVariations {
                for k in 0..<numberOfVariations {
                    for l in 0..<numberOfVariations {
                        unusedCards.append(Card(color: Card.CardProperty.allValues[i],
                                                number: Card.CardProperty.allValues[j],
                                                shape: Card.CardProperty.allValues[k],
                                                shading: Card.CardProperty.allValues[l]))
                    }
                }
            }
        }
        
        //Shuffle the cards
        for k in stride(from: unusedCards.count - 1, to: 0, by: -1) {
            unusedCards.swapAt(Int(arc4random_uniform(UInt32(k + 1))), k)
        }
    }
    
}
