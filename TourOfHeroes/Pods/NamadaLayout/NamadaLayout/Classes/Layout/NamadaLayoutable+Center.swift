//
//  File.swift
//  NamadaLayout
//
//  Created by Nayanda Haberty (ID) on 28/08/20.
//

import Foundation
import UIKit

public extension NamadaLayoutable {
    
    // MARK: Center Anchor
    
    @discardableResult
    func centerX(_ relation: LayoutRelation<CGFloat>, to anchor: NSLayoutXAxisAnchor, priority: PriorityConvertible) -> Self {
        let constraint: NSLayoutConstraint
        switch relation {
        case .moreThanTo(let offset):
            constraint = view.centerXAnchor.constraint(greaterThanOrEqualTo: anchor, constant: offset)
        case .lessThanTo(let offset):
            constraint = view.centerXAnchor.constraint(lessThanOrEqualTo: anchor, constant: offset)
        case .equalTo(let offset):
            constraint = view.centerXAnchor.constraint(equalTo: anchor, constant: offset)
        case .moreThan:
            constraint = view.centerXAnchor.constraint(greaterThanOrEqualTo: anchor)
        case .lessThan:
            constraint = view.centerXAnchor.constraint(lessThanOrEqualTo: anchor)
        case .equal:
            constraint = view.centerXAnchor.constraint(equalTo: anchor)
        }
        constraint.priority = priority.asPriority
        constraint.identifier = "namada_\(view.uniqueKey)_center_x_to_\(identifier(ofSecondItemIn: constraint))"
        constructedConstraints.removeAll { $0.identifier == constraint.identifier }
        constructedConstraints.append(constraint)
        return self
    }
    
    @discardableResult
    func centerX(_ relation: LayoutRelation<CGFloat>, to anchor: NSLayoutXAxisAnchor) -> Self {
        return centerX(relation, to: anchor, priority: context.mutatingPriority)
    }
    
    @discardableResult
    func centerY(_ relation: LayoutRelation<CGFloat>, to anchor: NSLayoutYAxisAnchor, priority: PriorityConvertible) -> Self {
        let constraint: NSLayoutConstraint
        switch relation {
        case .moreThanTo(let offset):
            constraint = view.centerYAnchor.constraint(greaterThanOrEqualTo: anchor, constant: offset)
        case .lessThanTo(let offset):
            constraint = view.centerYAnchor.constraint(lessThanOrEqualTo: anchor, constant: offset)
        case .equalTo(let offset):
            constraint = view.centerYAnchor.constraint(equalTo: anchor, constant: offset)
        case .moreThan:
            constraint = view.centerYAnchor.constraint(greaterThanOrEqualTo: anchor)
        case .lessThan:
            constraint = view.centerYAnchor.constraint(lessThanOrEqualTo: anchor)
        case .equal:
            constraint = view.centerYAnchor.constraint(equalTo: anchor)
        }
        constraint.priority = priority.asPriority
        constraint.identifier = "namada_\(view.uniqueKey)_center_y_to_\(identifier(ofSecondItemIn: constraint))"
        constructedConstraints.removeAll { $0.identifier == constraint.identifier }
        constructedConstraints.append(constraint)
        return self
    }
    
    @discardableResult
    func centerY(_ relation: LayoutRelation<CGFloat>, to anchor: NSLayoutYAxisAnchor) -> Self {
        return centerY(relation, to: anchor, priority: context.mutatingPriority)
    }
    
    @discardableResult
    func centerX(_ relation: LayoutRelation<CGFloat>, to anchor: ParentRelated, priority: PriorityConvertible) -> Self {
        guard let superview = view.superview ?? context.delegate.namadaLayout(viewHaveNoSuperview: view) else {
            context.delegate.namadaLayout(view, erroWhenLayout: .init(description: "View have no superview"))
            return self
        }
        if #available(iOS 11.0, *), anchor == .safeArea {
            let guide = superview.safeAreaLayoutGuide
            return centerX(relation, to: guide.centerXAnchor, priority: priority)
        }
        return centerX(relation, to: superview.centerXAnchor, priority: priority)
    }
    
    @discardableResult
    func centerX(_ relation: LayoutRelation<CGFloat>, to anchor: ParentRelated) -> Self {
        return centerX(relation, to: anchor, priority: context.mutatingPriority)
    }
    
    @discardableResult
    func centerY(_ relation: LayoutRelation<CGFloat>, to anchor: ParentRelated, priority: PriorityConvertible) -> Self {
        guard let superview = view.superview ?? context.delegate.namadaLayout(viewHaveNoSuperview: view) else {
            context.delegate.namadaLayout(view, erroWhenLayout: .init(description: "View have no superview"))
            return self
        }
        if #available(iOS 11.0, *), anchor == .safeArea {
            let guide = superview.safeAreaLayoutGuide
            return centerY(relation, to: guide.centerYAnchor, priority: priority)
        }
        return centerY(relation, to: superview.centerYAnchor, priority: priority)
    }
    
    @discardableResult
    func centerY(_ relation: LayoutRelation<CGFloat>, to anchor: ParentRelated) -> Self {
        return centerY(relation, to: anchor, priority: context.mutatingPriority)
    }
}
