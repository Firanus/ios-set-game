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
    
    enum CardProperty: TripleComparable, EnumCollection {
        case primary
        case secondary
        case tertiary
    }
    
    static func formSetOfThree(first: Card, second: Card, third: Card) -> Bool {
        let colorsMatch = CardProperty.allIdentical(first: first.color, second: second.color, third: third.color) ||
            CardProperty.allDistinct(first: first.color, second: second.color, third: third.color)
        let numbersMatch = CardProperty.allIdentical(first: first.number, second: second.number, third: third.number) ||
            CardProperty.allDistinct(first: first.number, second: second.number, third: third.number)
        let shapesMatch = CardProperty.allIdentical(first: first.shape, second: second.shape, third: third.shape) ||
            CardProperty.allDistinct(first: first.shape, second: second.shape, third: third.shape)
        let shadingsMatch = CardProperty.allIdentical(first: first.shading, second: second.shading, third: third.shading) ||
            CardProperty.allDistinct(first: first.shading, second: second.shading, third: third.shading)
        
        return colorsMatch && numbersMatch && shapesMatch && shadingsMatch
    }
}
