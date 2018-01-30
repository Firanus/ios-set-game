//
//  EnumCollection.swift
//  Set
//
//  Created by Ivan Tchernev on 23/01/2018.
//  Copyright © 2018 AND Digital. All rights reserved.
//
//  Credit to Tober Bodecs for his EnumCollection protocol https://theswiftdev.com/2017/10/12/swift-enum-all-values/
//

import Foundation

public protocol EnumCollection: Hashable {
    static func cases() -> AnySequence<Self>
    static var allValues: [Self] { get }
}

public extension EnumCollection {
    
    public static func cases() -> AnySequence<Self> {
        return AnySequence { () -> AnyIterator<Self> in
            var raw = 0
            return AnyIterator {
                let current: Self = withUnsafePointer(to: &raw) { $0.withMemoryRebound(to: self, capacity: 1) { $0.pointee } }
                guard current.hashValue == raw else {
                    return nil
                }
                raw += 1
                return current
            }
        }
    }
    
    public static var allValues: [Self] {
        return Array(self.cases())
    }
}
