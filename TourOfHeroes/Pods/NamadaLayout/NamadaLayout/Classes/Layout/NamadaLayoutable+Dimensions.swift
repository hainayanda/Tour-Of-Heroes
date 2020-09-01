//
//  NamadaLayoutable+Dimensions.swift
//  NamadaLayout
//
//  Created by Nayanda Haberty (ID) on 27/08/20.
//

import Foundation

public extension NamadaLayoutable {
    
    // MARK: Height Anchor
    
    @discardableResult
    func height(_ relation: InterRelation<NSLayoutDimension>, multiplyBy multipier: CGFloat, constant: CGFloat, priority: PriorityConvertible) -> Self {
        let constraint: NSLayoutConstraint
        switch relation {
        case .moreThanTo(let dimension):
            constraint = view.heightAnchor.constraint(greaterThanOrEqualTo: dimension, multiplier: multipier, constant: constant)
        case .lessThanTo(let dimension):
            constraint = view.heightAnchor.constraint(lessThanOrEqualTo: dimension, multiplier: multipier, constant: constant)
        case .equalTo(let dimension):
            constraint = view.heightAnchor.constraint(equalTo: dimension, multiplier: multipier, constant: constant)
        }
        constraint.priority = priority.asPriority
        constraint.identifier = "namada_\(view.uniqueKey)_height_to_\(identifier(ofSecondItemIn: constraint))"
        constructedConstraints.removeAll { $0.identifier == constraint.identifier }
        constructedConstraints.append(constraint)
        return self
    }
    
    @discardableResult
    func height(_ relation: InterRelation<NSLayoutDimension>, multiplyBy multipier: CGFloat = 0, constant: CGFloat = 0, priority: PriorityConvertible? = nil) -> Self {
        let priority = priority ?? context.mutatingPriority
        return height(relation, multiplyBy: multipier, constant: constant, priority: priority)
    }
    
    @discardableResult
    func height(_ relation: InterRelation<ParentRelated>, multiplyBy multipier: CGFloat, constant: CGFloat, priority: PriorityConvertible) -> Self {
        guard let superview = view.superview ?? context.delegate.namadaLayout(viewHaveNoSuperview: view) else {
            context.delegate.namadaLayout(view, erroWhenLayout: .init(description: "View have no superview"))
            return self
        }
        switch relation {
        case .moreThanTo(let parent):
            if parent == .parent {
                height(.moreThanTo(superview.widthAnchor), multiplyBy: multipier, constant: constant, priority: priority)
            } else if #available(iOS 11.0, *) {
                height(.moreThanTo(superview.safeAreaLayoutGuide.widthAnchor), multiplyBy: multipier, constant: constant, priority: priority)
            } else {
                let layoutMargins = superview.layoutMargins
                let totalMargin = layoutMargins.top + layoutMargins.bottom
                height(.moreThanTo(superview.widthAnchor), multiplyBy: multipier, constant: constant - totalMargin, priority: priority)
            }
        case .lessThanTo(let parent):
            if parent == .parent {
                height(.lessThanTo(superview.widthAnchor), multiplyBy: multipier, constant: constant, priority: priority)
            } else if #available(iOS 11.0, *) {
                height(.lessThanTo(superview.safeAreaLayoutGuide.widthAnchor), multiplyBy: multipier, constant: constant, priority: priority)
            } else {
                let layoutMargins = superview.layoutMargins
                let totalMargin = layoutMargins.top + layoutMargins.bottom
                height(.lessThanTo(superview.widthAnchor), multiplyBy: multipier, constant: constant - totalMargin, priority: priority)
            }
        case .equalTo(let parent):
            if parent == .parent {
                height(.equalTo(superview.widthAnchor), multiplyBy: multipier, constant: constant, priority: priority)
            } else if #available(iOS 11.0, *) {
                height(.equalTo(superview.safeAreaLayoutGuide.widthAnchor), multiplyBy: multipier, constant: constant, priority: priority)
            } else {
                let layoutMargins = superview.layoutMargins
                let totalMargin = layoutMargins.top + layoutMargins.bottom
                height(.equalTo(superview.widthAnchor), multiplyBy: multipier, constant: constant - totalMargin, priority: priority)
            }
        }
        return self
    }
    
    @discardableResult
    func height(_ relation: InterRelation<ParentRelated>, multiplyBy multipier: CGFloat = 0, constant: CGFloat = 0, priority: PriorityConvertible? = nil) -> Self {
        let priority = priority ?? context.mutatingPriority
        return height(relation, multiplyBy: multipier, constant: constant, priority: priority)
    }
    
    @discardableResult
    func height(_ relation: InterRelation<CGFloat>, priority: PriorityConvertible) -> Self {
        let constraint: NSLayoutConstraint
        let identifier: String
        switch relation {
        case .moreThanTo(let dimension):
            identifier = "more_than_dimension"
            constraint = view.heightAnchor.constraint(greaterThanOrEqualToConstant: dimension)
        case .lessThanTo(let dimension):
            identifier = "less_than_dimension"
            constraint = view.heightAnchor.constraint(lessThanOrEqualToConstant: dimension)
        case .equalTo(let dimension):
            identifier = "equal_with_dimension"
            constraint = view.heightAnchor.constraint(equalToConstant: dimension)
        }
        constraint.priority = priority.asPriority
        constraint.identifier = "namada_\(view.uniqueKey)_height_\(identifier)"
        constructedConstraints.removeAll { $0.identifier == constraint.identifier }
        constructedConstraints.append(constraint)
        return self
    }
    
    @discardableResult
    func height(_ relation: InterRelation<CGFloat>) -> Self {
        return height(relation, priority: context.mutatingPriority)
    }
    
    // MARK: Width Anchor
    
    @discardableResult
    func width(_ relation: InterRelation<NSLayoutDimension>, multiplyBy multipier: CGFloat, constant: CGFloat, priority: PriorityConvertible) -> Self {
        let constraint: NSLayoutConstraint
        switch relation {
        case .moreThanTo(let dimension):
            constraint = view.widthAnchor.constraint(greaterThanOrEqualTo: dimension, multiplier: multipier, constant: constant)
        case .lessThanTo(let dimension):
            constraint = view.widthAnchor.constraint(lessThanOrEqualTo: dimension, multiplier: multipier, constant: constant)
        case .equalTo(let dimension):
            constraint = view.widthAnchor.constraint(equalTo: dimension, multiplier: multipier, constant: constant)
        }
        constraint.priority = priority.asPriority
        constraint.identifier = "namada_\(view.uniqueKey)_width_to_\(identifier(ofSecondItemIn: constraint))"
        constructedConstraints.removeAll { $0.identifier == constraint.identifier }
        constructedConstraints.append(constraint)
        return self
    }
    
    @discardableResult
    func width(_ relation: InterRelation<NSLayoutDimension>, multiplyBy multipier: CGFloat = 1, constant: CGFloat = 0, priority: PriorityConvertible? = nil) -> Self {
        return width(relation, multiplyBy: multipier, constant: constant, priority: priority ?? context.mutatingPriority)
    }
    
    @discardableResult
    func width(_ relation: InterRelation<ParentRelated>, multiplyBy multipier: CGFloat, constant: CGFloat, priority: PriorityConvertible) -> Self {
        guard let superview = view.superview ?? context.delegate.namadaLayout(viewHaveNoSuperview: view) else {
            context.delegate.namadaLayout(view, erroWhenLayout: .init(description: "View have no superview"))
            return self
        }
        switch relation {
        case .moreThanTo(let parent):
            if parent == .parent {
                width(.moreThanTo(superview.widthAnchor), multiplyBy: multipier, constant: constant, priority: priority)
            } else if #available(iOS 11.0, *) {
                width(.moreThanTo(superview.safeAreaLayoutGuide.widthAnchor), multiplyBy: multipier, constant: constant, priority: priority)
            } else {
                let layoutMargins = superview.layoutMargins
                let totalMargin = layoutMargins.left + layoutMargins.right
                width(.moreThanTo(superview.widthAnchor), multiplyBy: multipier, constant: constant - totalMargin, priority: priority)
            }
        case .lessThanTo(let parent):
            if parent == .parent {
                width(.lessThanTo(superview.widthAnchor), multiplyBy: multipier, constant: constant, priority: priority)
            } else if #available(iOS 11.0, *) {
                width(.lessThanTo(superview.safeAreaLayoutGuide.widthAnchor), multiplyBy: multipier, constant: constant, priority: priority)
            } else {
                let layoutMargins = superview.layoutMargins
                let totalMargin = layoutMargins.left + layoutMargins.right
                width(.lessThanTo(superview.widthAnchor), multiplyBy: multipier, constant: constant - totalMargin, priority: priority)
            }
        case .equalTo(let parent):
            if parent == .parent {
                width(.equalTo(superview.widthAnchor), multiplyBy: multipier, constant: constant, priority: priority)
            } else if #available(iOS 11.0, *) {
                width(.equalTo(superview.safeAreaLayoutGuide.widthAnchor), multiplyBy: multipier, constant: constant, priority: priority)
            } else {
                let layoutMargins = superview.layoutMargins
                let totalMargin = layoutMargins.left + layoutMargins.right
                width(.equalTo(superview.widthAnchor), multiplyBy: multipier, constant: constant - totalMargin, priority: priority)
            }
        }
        return self
    }
    
    @discardableResult
    func width(_ relation: InterRelation<ParentRelated>, multiplyBy multipier: CGFloat = 0, constant: CGFloat = 0, priority: PriorityConvertible? = nil) -> Self {
        let priority = priority ?? context.mutatingPriority
        return width(relation, multiplyBy: multipier, constant: constant, priority: priority)
    }
    
    @discardableResult
    func width(_ relation: InterRelation<CGFloat>, priority: PriorityConvertible) -> Self {
        let constraint: NSLayoutConstraint
        let identifier: String
        switch relation {
        case .moreThanTo(let dimension):
            identifier = "more_than_dimension"
            constraint = view.widthAnchor.constraint(greaterThanOrEqualToConstant: dimension)
        case .lessThanTo(let dimension):
            identifier = "less_than_dimension"
            constraint = view.widthAnchor.constraint(lessThanOrEqualToConstant: dimension)
        case .equalTo(let dimension):
            identifier = "equal_with_dimension"
            constraint = view.widthAnchor.constraint(equalToConstant: dimension)
        }
        constraint.priority = priority.asPriority
        constraint.identifier = "namada_\(view.uniqueKey)_width_\(identifier)"
        constructedConstraints.removeAll { $0.identifier == constraint.identifier }
        constructedConstraints.append(constraint)
        return self
    }
    
    @discardableResult
    func width(_ relation: InterRelation<CGFloat>) -> Self {
        return width(relation, priority: context.mutatingPriority)
    }
}
