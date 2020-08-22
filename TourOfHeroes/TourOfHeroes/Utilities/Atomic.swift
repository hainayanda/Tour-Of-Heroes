//
//  Atomic.swift
//  TourOfHeroes
//
//  Created by Nayanda Haberty (ID) on 22/08/20.
//  Copyright © 2020 Nayanda Haberty (ID). All rights reserved.
//

import Foundation

@propertyWrapper
struct Atomic<Wrapped> {
    
    private var value: Wrapped
    private let lock = NSLock()
    
    init(wrappedValue value: Wrapped) {
        self.value = value
    }
    
    var wrappedValue: Wrapped {
        get { return load() }
        set { store(newValue: newValue) }
    }
    
    func load() -> Wrapped {
        lock.lock()
        defer { lock.unlock() }
        return value
    }
    
    mutating func store(newValue: Wrapped) {
        lock.lock()
        defer { lock.unlock() }
        value = newValue
    }
}
