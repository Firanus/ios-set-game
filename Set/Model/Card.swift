//
//  Card.swift
//  Set
//
//  Created by Ivan Tchernev on 23/01/2018.
//  Copyright © 2018 AND Digital. All rights reserved.
//

import Foundation

struct Card {
    
    let color: CardProperty
    let number: CardProperty
    let shape: CardProperty
    let shading: CardProperty
    
    enum CardProperty: Int, TripleComparable {
        case primary = 1
        case secondary
        case tertiary
        
        static var allValues: [CardProperty] { return [.primary, .secondary, .tertiary] }
    }
    
    static func doFormSetOfThree(first: Card, second: Card, third: Card) -> Bool {
        let colorsMatch = CardProperty.allIdenticalOrAllDistinct(first: first.color, second: second.color, third: third.color)
        let numbersMatch = CardProperty.allIdenticalOrAllDistinct(first: first.number, second: second.number, third: third.number)
        let shapesMatch = CardProperty.allIdenticalOrAllDistinct(first: first.shape, second: second.shape, third: third.shape)
        let shadingsMatch = CardProperty.allIdenticalOrAllDistinct(first: first.shading, second: second.shading, third: third.shading)
        
        return colorsMatch && numbersMatch && shapesMatch && shadingsMatch
    }
}

extension Card: Hashable {
    var hashValue: Int {
        return (color.rawValue) + (number.rawValue * 3) + (shape.rawValue * 9) + (shading.rawValue * 27)
    }
    
    static func ==(lhs: Card, rhs: Card) -> Bool {
        return lhs.hashValue == rhs.hashValue
    }
}
