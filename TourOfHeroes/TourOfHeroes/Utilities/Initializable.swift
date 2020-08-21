//
//  Initializable.swift
//  TourOfHeroes
//
//  Created by Nayanda Haberty (ID) on 21/08/20.
//  Copyright © 2020 Nayanda Haberty (ID). All rights reserved.
//

import Foundation

public protocol Initializable {
    init()
}

public func build<Buildable: Initializable>(_ builder: (inout Buildable) -> Void) -> Buildable {
    var buildable = Buildable()
    builder(&buildable)
    return buildable
}
