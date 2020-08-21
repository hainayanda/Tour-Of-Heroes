//
//  ThreadHelper.swift
//  TourOfHeroes
//
//  Created by Nayanda Haberty (ID) on 21/08/20.
//  Copyright © 2020 Nayanda Haberty (ID). All rights reserved.
//

import Foundation

public func runOnMainThread(_ closure: @escaping () -> Void) {
    guard !Thread.isMainThread else {
        closure()
        return
    }
    DispatchQueue.main.async(execute: closure)
}


public func dispatchOnMainThread(_ closure: @escaping () -> Void) {
    DispatchQueue.main.async(execute: closure)
}

public func dispatchOnMainThread(after deadline: DispatchTime, _ closure: @escaping () -> Void) {
    DispatchQueue.main.asyncAfter(deadline: deadline, execute: closure)
}
