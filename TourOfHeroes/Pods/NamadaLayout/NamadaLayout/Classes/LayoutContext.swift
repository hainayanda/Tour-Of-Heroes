//
//  LayoutContext.swift
//  NamadaLayout
//
//  Created by Nayanda Haberty (ID) on 06/07/20.
//

import Foundation
import UIKit

public class LayoutContext {
    private weak var _layoutDelegate: LayoutBuilderDelegate?
    var layoutDelegate: LayoutBuilderDelegate {
        get {
            return _layoutDelegate ?? DefaultDelegate.shared
        } set {
            _layoutDelegate = newValue
        }
    }
    var currentPriority: UILayoutPriority = .init(999)
    var countedPriority: UILayoutPriority {
        let newPriority: UILayoutPriority = .init(rawValue: currentPriority.rawValue - 1)
        currentPriority = newPriority
        return newPriority
    }
    public var currentViewController: UIViewController?
}
