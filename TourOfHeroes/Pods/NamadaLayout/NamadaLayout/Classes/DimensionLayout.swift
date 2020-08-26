//
//  DimensionLayout.swift
//  NamadaLayout
//
//  Created by Nayanda Haberty (ID) on 05/07/20.
//

import Foundation
import UIKit

public class DimensionLayout: LayoutBuilder, ConstraintsBuilder, Hashable {
    
    public typealias LayoutBuilderType = DimensionLayout
    
    public private(set) var parentLayout: DimensionLayout?
    public let context: LayoutContext
    let layoutDimension: NSLayoutDimension
    var constraints: [String: NSLayoutConstraint] = [:]
    public let identifier: String
    public var constructedConstraints: [NSLayoutConstraint] {
        constraints.compactMap { $0.value }
    }
    
    init(
        context: LayoutContext,
        layoutDimension: NSLayoutDimension,
        identifier: String,
        parentRelated: DimensionLayout?) {
        self.context = context
        self.layoutDimension = layoutDimension
        self.identifier = identifier
        self.parentLayout = parentRelated
    }
    
    public func hash(into hasher: inout Hasher) {
        hasher.combine(layoutDimension)
        hasher.combine(identifier)
    }
    
    @discardableResult
    public func equal(
        with constant: CGFloat,
        priority: UILayoutPriority? = nil) -> DimensionLayout {
        let constraint = layoutDimension.constraint(equalToConstant: constant)
        add(constraint, id: "\(identifier)_equal_to_\(constant)", priority: priority ?? context.countedPriority)
        return self
    }
    
    @discardableResult
    public func moreThan(
        _ constant: CGFloat,
        priority: UILayoutPriority? = nil) -> DimensionLayout {
        let constraint = layoutDimension.constraint(greaterThanOrEqualToConstant: constant)
        add(constraint, id: "\(identifier)_more_than_\(constant)", priority: priority ?? context.countedPriority)
        return self
    }
    
    @discardableResult
    public func lessThan(
        _ constant: CGFloat,
        priority: UILayoutPriority? = nil) -> DimensionLayout {
        let constraint = layoutDimension.constraint(lessThanOrEqualToConstant: constant)
        add(constraint, id: "\(identifier)_less_than_\(constant)", priority: priority ?? context.countedPriority)
        return self
    }
    
    @discardableResult
    public func equal(
        with other: DimensionLayout,
        multipliedBy multiplier: CGFloat = 1,
        offsetBy offset: CGFloat = 0,
        priority: UILayoutPriority? = nil) -> DimensionLayout {
        guard other != self else {
            return sameWith(other)
        }
        let constraint = layoutDimension.constraint(
            equalTo: other.layoutDimension,
            multiplier: multiplier,
            constant: offset
        )
        add(constraint, id: "\(identifier)_to_\(other.identifier)", priority: priority ?? context.countedPriority)
        return self
    }
    
    @discardableResult
    public func moreThan(
        _ other: DimensionLayout,
        multipliedBy multiplier: CGFloat = 1,
        offsetBy offset: CGFloat = 0,
        priority: UILayoutPriority? = nil) -> DimensionLayout {
        guard other != self else {
            return sameWith(other)
        }
        let constraint = layoutDimension.constraint(
            greaterThanOrEqualTo: other.layoutDimension,
            multiplier: multiplier,
            constant: offset
        )
        add(constraint, id: "\(identifier)_to_\(other.identifier)", priority: priority ?? context.countedPriority)
        return self
    }
    
    @discardableResult
    public func lessThan(
        _ other: DimensionLayout,
        multipliedBy multiplier: CGFloat = 1,
        offsetBy offset: CGFloat = 0,
        priority: UILayoutPriority? = nil) -> DimensionLayout {
        guard other != self else {
            return sameWith(other)
        }
        let constraint = layoutDimension.constraint(
            lessThanOrEqualTo: other.layoutDimension,
            multiplier: multiplier,
            constant: offset
        )
        add(constraint, id: "\(identifier)_to_\(other.identifier)", priority: priority ?? context.countedPriority)
        return self
    }
    
    @discardableResult
    public func equalWithParent(
        multipliedBy multiplier: CGFloat = 1,
        offsetBy offset: CGFloat = 0,
        priority: UILayoutPriority? = nil) -> DimensionLayout {
        ifHaveParent { parent in
            let constraint = layoutDimension.constraint(
                equalTo: parent.layoutDimension,
                multiplier: multiplier,
                constant: offset
            )
            add(constraint, id: "\(identifier)_to_\(parent.identifier)", priority: priority ?? context.countedPriority)
        }
        return self
    }
    
    @discardableResult
    public func moreThanParent(
        multipliedBy multiplier: CGFloat = 1,
        offsetBy offset: CGFloat = 0,
        priority: UILayoutPriority? = nil) -> DimensionLayout {
        ifHaveParent { parent in
            let constraint = layoutDimension.constraint(
                greaterThanOrEqualTo: parent.layoutDimension,
                multiplier: multiplier,
                constant: offset
            )
            add(constraint, id: "\(identifier)_to_\(parent.identifier)", priority: priority ?? context.countedPriority)
        }
        return self
    }
    
    @discardableResult
    public func lessThanParent(
        multipliedBy multiplier: CGFloat = 1,
        offsetBy offset: CGFloat = 0,
        priority: UILayoutPriority? = nil) -> DimensionLayout {
        ifHaveParent { parent in
            let constraint = layoutDimension.constraint(
                lessThanOrEqualTo: parent.layoutDimension,
                multiplier: multiplier,
                constant: offset
            )
            add(constraint, id: "\(identifier)_to_\(parent.identifier)", priority: priority ?? context.countedPriority)
        }
        return self
    }
    
    private func add(
        _ constraint: NSLayoutConstraint,
        id: String,
        priority: UILayoutPriority) {
        constraint.identifier = id
        constraint.priority = priority
        constraints[id] = constraint
    }
    
    private func sameWith(_ other: DimensionLayout) -> DimensionLayout {
        do {
            try context.layoutDelegate.layoutBuilder(self, relateWith: other)
        } catch {
            guard let layoutError = error as? LayoutError else {
                print(error.localizedDescription)
                return self
            }
            context.layoutDelegate.layoutBuilder(self, onError: layoutError)
        }
        return self
    }
    
    public static func == (lhs: DimensionLayout, rhs: DimensionLayout) -> Bool {
        lhs.layoutDimension == rhs.layoutDimension
    }
}
