//
//  ObservableView.swift
//  TourOfHeroes
//
//  Created by Nayanda Haberty (ID) on 24/08/20.
//  Copyright © 2020 Nayanda Haberty (ID). All rights reserved.
//

import Foundation
import NamadaLayout

public protocol ObservableView {
    associatedtype Observer
    var observer: Observer? { get }
}

extension ObservableView where Self: NSObject {
    public var observer: Observer? {
        bindedModel() as? Observer
    }
}
