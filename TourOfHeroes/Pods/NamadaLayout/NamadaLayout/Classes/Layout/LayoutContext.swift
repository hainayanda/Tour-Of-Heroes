//
//  LayoutContext.swift
//  NamadaLayout
//
//  Created by Nayanda Haberty (ID) on 27/08/20.
//

import Foundation
import UIKit

public class LayoutContext {
    weak var _delegate: NamadaLayoutDelegate?
    var delegate: NamadaLayoutDelegate {
        _delegate ?? DefaultNamadaLayoutDelegate.shared
    }
    var currentPriority: UILayoutPriority = 999
    var mutatingPriority: UILayoutPriority {
        let newPriority: UILayoutPriority = .init(rawValue: currentPriority.rawValue - 1)
        currentPriority = newPriority
        return newPriority
    }
    
    init(delegate: NamadaLayoutDelegate? = nil) {
        self._delegate = delegate
    }
}
