//
//  UIView+Extensions.swift
//  TourOfHeroes
//
//  Created by Nayanda Haberty (ID) on 24/08/20.
//  Copyright © 2020 Nayanda Haberty (ID). All rights reserved.
//

import Foundation
import UIKit

// MARK: Shadow

public extension UIView {
    
    enum DropShadowDirection {
        case top
        case bottom
        case center
    }
    
    func removeDropShadow() {
        layer.shadowColor = UIColor.clear.cgColor
    }
    
    func addDropShadow(at direction: DropShadowDirection) {
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = 0.09
        layer.shadowRadius = 1.8
        layer.masksToBounds = false
        switch direction {
        case .top:
            layer.shadowOffset = .init(width: 0, height: -2.7)
        case .bottom:
            layer.shadowOffset = .init(width: 0, height: 2.7)
        default:
            layer.shadowOffset = .zero
        }
    }
}
