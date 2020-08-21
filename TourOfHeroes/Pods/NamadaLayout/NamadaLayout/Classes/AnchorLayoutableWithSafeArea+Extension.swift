//
//  AnchorLayoutableWithSafeArea+Extension.swift
//  NamadaLayout
//
//  Created by Nayanda Haberty (ID) on 07/07/20.
//

import Foundation
import UIKit

public extension AnchorLayoutableWithSafeArea {
    @discardableResult
    func equalWithSafeArea() -> LayoutBuilderType {
        equalWithSafeArea(priority: context.countedPriority)
    }
    
    @discardableResult
    func distanceToSafeArea(at space: CGFloat) -> LayoutBuilderType {
        distanceToSafeArea(at: space, priority: context.countedPriority)
    }
    
    @discardableResult
    func distanceToSafeArea(moreThan space: CGFloat) -> LayoutBuilderType {
        distanceToSafeArea(moreThan: space, priority: context.countedPriority)
    }
    
    @discardableResult
    func distanceToSafeArea(lessThan space: CGFloat) -> LayoutBuilderType {
        distanceToSafeArea(lessThan: space, priority: context.countedPriority)
    }
}
