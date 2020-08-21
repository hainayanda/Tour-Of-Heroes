//
//  AnchorLayoutable+Extension.swift
//  NamadaLayout
//
//  Created by Nayanda Haberty (ID) on 07/07/20.
//

import Foundation

public extension AnchorLayoutable {
    
    @discardableResult
    func equal(with other: LayoutBuilderType) -> LayoutBuilderType {
        equal(with: other, priority: context.countedPriority)
    }
    
    @discardableResult
    func distance(to other: LayoutBuilderType, at space: CGFloat) -> LayoutBuilderType {
        distance(to: other, at: space, priority: context.countedPriority)
    }
    
    @discardableResult
    func distance(to other: LayoutBuilderType, moreThan space: CGFloat) -> LayoutBuilderType {
        distance(to: other, moreThan: space, priority: context.countedPriority)
    }
    
    @discardableResult
    func distance(to other: LayoutBuilderType, lessThan space: CGFloat) -> LayoutBuilderType {
        distance(to: other, lessThan: space, priority: context.countedPriority)
    }
    
    @discardableResult
    func equalWithParent() -> LayoutBuilderType {
        equalWithParent(priority: context.countedPriority)
    }
    
    @discardableResult
    func distanceToParent(at space: CGFloat) -> LayoutBuilderType {
        distanceToParent(at: space, priority: context.countedPriority)
    }
    
    @discardableResult
    func distanceToParent(moreThan space: CGFloat) -> LayoutBuilderType {
        distanceToParent(moreThan: space, priority: context.countedPriority)
    }
    
    @discardableResult
    func distanceToParent(lessThan space: CGFloat) -> LayoutBuilderType {
        distanceToParent(lessThan: space, priority: context.countedPriority)
    }
}
