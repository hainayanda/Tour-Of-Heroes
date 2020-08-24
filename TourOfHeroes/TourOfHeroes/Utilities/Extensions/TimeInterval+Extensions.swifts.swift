//
//  TimeInterval+Extensions.swifts.swift
//  TourOfHeroes
//
//  Created by Nayanda Haberty (ID) on 22/08/20.
//  Copyright © 2020 Nayanda Haberty (ID). All rights reserved.
//

import Foundation

extension TimeInterval {
    
    // MARK: Animataion Duration
    static var zero: TimeInterval { 0 }
    static var instant: TimeInterval { 0.02 }
    static var almostInstant: TimeInterval { 0.06 }
    static var fastest: TimeInterval { 0.1 }
    static var faster: TimeInterval { 0.2 }
    static var fast: TimeInterval { 0.4 }
    static var fluid: TimeInterval { 0.6 }
    static var standard: TimeInterval { 0.8 }
    static var slow: TimeInterval { 1 }
    static var slower: TimeInterval { 2 }
    static var slowest: TimeInterval { 4 }
}
