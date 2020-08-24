//
//  Collection+Extensions.swift
//  TourOfHeroes
//
//  Created by Nayanda Haberty (ID) on 23/08/20.
//  Copyright © 2020 Nayanda Haberty (ID). All rights reserved.
//

import Foundation
import NamadaLayout

public extension Collection {
    subscript (safe index: Index) -> Element? {
        return indices.contains(index) ? self[index] : nil
    }
}

public extension Array {
    static func duplicate(of element: @autoclosure () -> Element, count: Int) -> Self {
        var result: [Element] = []
        for _ in 1...count {
            result.append(element())
        }
        return result
    }
}
