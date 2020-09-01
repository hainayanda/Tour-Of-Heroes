//
//  PriorityConvertible.swift
//  NamadaLayout
//
//  Created by Nayanda Haberty (ID) on 30/08/20.
//

import Foundation
import UIKit

public protocol PriorityConvertible {
    var asPriority: UILayoutPriority { get }
}

extension UILayoutPriority: PriorityConvertible {
    public var asPriority: UILayoutPriority {
        self
    }
}

extension Int: PriorityConvertible {
    public var asPriority: UILayoutPriority {
        .init(Float(self))
    }
}

extension Float: PriorityConvertible {
    public var asPriority: UILayoutPriority {
        .init(self)
    }
}

extension Double: PriorityConvertible {
    public var asPriority: UILayoutPriority {
        .init(Float(self))
    }
}
