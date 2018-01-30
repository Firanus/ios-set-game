//
//  TripleComparable.swift
//  Set
//
//  Created by Ivan Tchernev on 23/01/2018.
//  Copyright © 2018 AND Digital. All rights reserved.
//

import Foundation

protocol TripleComparable: Equatable {
    static func allIdentical(first: Self, second: Self, third: Self) -> Bool
    static func allDistinct(first: Self, second: Self, third: Self) -> Bool
    static func allIdenticalOrAllDistinct(first: Self, second: Self, third: Self) -> Bool
}

extension TripleComparable {
    static func allIdentical(first: Self, second: Self, third: Self) -> Bool {
        return first == second && second == third && first == third
    }
    static func allDistinct(first: Self, second: Self, third: Self) -> Bool {
        return first != second && second != third && first != third
    }
    
    static func allIdenticalOrAllDistinct(first: Self, second: Self, third: Self) -> Bool {
        return allIdentical(first: first, second: second, third: third) || allDistinct(first: first, second: second, third: third)
    }
}
