//
//  NamadaLayoutable+Edges.swift
//  NamadaLayout
//
//  Created by Nayanda Haberty (ID) on 27/08/20.
//

import Foundation
public extension NamadaLayoutable {
    
    // MARK: Top Anchor
    
    @discardableResult
    func top(_ relation: LayoutRelation<CGFloat>, to anchor: NSLayoutYAxisAnchor, priority: UILayoutPriority) -> Self {
        let constraint: NSLayoutConstraint
        switch relation {
        case .moreThanTo(let space):
            constraint = view.topAnchor.constraint(greaterThanOrEqualTo: anchor, constant: space)
        case .lessThanTo(let space):
            constraint = view.topAnchor.constraint(lessThanOrEqualTo: anchor, constant: space)
        case .equalTo(let space):
            constraint = view.topAnchor.constraint(equalTo: anchor, constant: space)
        case .moreThan:
            constraint = view.topAnchor.constraint(greaterThanOrEqualTo: anchor)
        case .lessThan:
            constraint = view.topAnchor.constraint(lessThanOrEqualTo: anchor)
        case .equal:
            constraint = view.topAnchor.constraint(equalTo: anchor)
        }
        constraint.priority = priority
        constraint.identifier = "namada_\(view.uniqueKey)_top_to_\(identifier(ofSecondItemIn: constraint))"
        constructedConstraints.removeAll { $0.identifier == constraint.identifier }
        constructedConstraints.append(constraint)
        return self
    }
    
    @discardableResult
    func top(_ relation: LayoutRelation<CGFloat>, to anchor: NSLayoutYAxisAnchor) -> Self {
        return top(relation, to: anchor, priority: context.mutatingPriority)
    }
    
    @discardableResult
    func top(_ relation: LayoutRelation<CGFloat>, to parent: ParentRelated, priority: UILayoutPriority) -> Self {
        guard let superview = view.superview ?? context.delegate.namadaLayout(viewHaveNoSuperview: view) else {
            context.delegate.namadaLayout(view, erroWhenLayout: .init(description: "View have no superview"))
            return self
        }
        if parent == .safeArea {
            if #available(iOS 11.0, *) {
                let guide = superview.safeAreaLayoutGuide
                return top(relation, to: guide.topAnchor, priority: priority)
            } else {
                let spaceAdded = superview.layoutMargins.top
                switch relation {
                case .equal, .equalTo(_):
                    return top(.equalTo(relation.distance + spaceAdded), to: superview.topAnchor, priority: priority)
                case .lessThan, .lessThanTo(_):
                    return top(.lessThanTo(relation.distance + spaceAdded), to: superview.topAnchor, priority: priority)
                case .moreThan, .moreThanTo(_):
                    return top(.moreThanTo(relation.distance + spaceAdded), to: superview.topAnchor, priority: priority)
                }
            }
        } else {
            return top(relation, to: superview.topAnchor, priority: priority)
        }
    }
    
    @discardableResult
    func top(_ relation: LayoutRelation<CGFloat>, to parent: ParentRelated) -> Self {
        return top(relation, to: parent, priority: context.mutatingPriority)
    }
    
    // MARK: Bottom Anchor
    
    @discardableResult
    func bottom(_ relation: LayoutRelation<CGFloat>, to anchor: NSLayoutYAxisAnchor, priority: UILayoutPriority) -> Self {
        let constraint: NSLayoutConstraint
        switch relation {
        case .moreThanTo(let space):
            constraint = view.bottomAnchor.constraint(greaterThanOrEqualTo: anchor, constant: -space)
        case .lessThanTo(let space):
            constraint = view.bottomAnchor.constraint(lessThanOrEqualTo: anchor, constant: -space)
        case .equalTo(let space):
            constraint = view.bottomAnchor.constraint(equalTo: anchor, constant: -space)
        case .moreThan:
            constraint = view.bottomAnchor.constraint(greaterThanOrEqualTo: anchor)
        case .lessThan:
            constraint = view.bottomAnchor.constraint(lessThanOrEqualTo: anchor)
        case .equal:
            constraint = view.bottomAnchor.constraint(equalTo: anchor)
        }
        constraint.priority = priority
        constraint.identifier = "namada_\(view.uniqueKey)_bottom_to_\(identifier(ofSecondItemIn: constraint))"
        constructedConstraints.removeAll { $0.identifier == constraint.identifier }
        constructedConstraints.append(constraint)
        return self
    }
    
    @discardableResult
    func bottom(_ relation: LayoutRelation<CGFloat>, to anchor: NSLayoutYAxisAnchor) -> Self {
        return bottom(relation, to: anchor, priority: context.mutatingPriority)
    }
    
    @discardableResult
    func bottom(_ relation: LayoutRelation<CGFloat>, to parent: ParentRelated, priority: UILayoutPriority) -> Self {
        guard let superview = view.superview ?? context.delegate.namadaLayout(viewHaveNoSuperview: view) else {
            context.delegate.namadaLayout(view, erroWhenLayout: .init(description: "View have no superview"))
            return self
        }
        if parent == .safeArea {
            if #available(iOS 11.0, *) {
                let guide = superview.safeAreaLayoutGuide
                return bottom(relation, to: guide.bottomAnchor, priority: priority)
            } else {
                let spaceAdded = superview.layoutMargins.top
                switch relation {
                case .equal, .equalTo(_):
                    return bottom(.equalTo(-(relation.distance + spaceAdded)), to: superview.bottomAnchor, priority: priority)
                case .lessThan, .lessThanTo(_):
                    return bottom(.lessThanTo(-(relation.distance + spaceAdded)), to: superview.bottomAnchor, priority: priority)
                case .moreThan, .moreThanTo(_):
                    return bottom(.moreThanTo(-(relation.distance + spaceAdded)), to: superview.bottomAnchor, priority: priority)
                }
            }
        } else {
            return bottom(relation, to: superview.bottomAnchor, priority: priority)
        }
    }
    
    @discardableResult
    func bottom(_ relation: LayoutRelation<CGFloat>, to parent: ParentRelated) -> Self {
        return bottom(relation, to: parent, priority: context.mutatingPriority)
    }
    
    // MARK: Left Anchor
    
    @discardableResult
    func left(_ relation: LayoutRelation<CGFloat>, to anchor: NSLayoutXAxisAnchor, priority: UILayoutPriority) -> Self {
        let constraint: NSLayoutConstraint
        switch relation {
        case .moreThanTo(let space):
            constraint = view.leftAnchor.constraint(greaterThanOrEqualTo: anchor, constant: space)
        case .lessThanTo(let space):
            constraint = view.leftAnchor.constraint(lessThanOrEqualTo: anchor, constant: space)
        case .equalTo(let space):
            constraint = view.leftAnchor.constraint(equalTo: anchor, constant: space)
        case .moreThan:
            constraint = view.leftAnchor.constraint(greaterThanOrEqualTo: anchor)
        case .lessThan:
            constraint = view.leftAnchor.constraint(lessThanOrEqualTo: anchor)
        case .equal:
            constraint = view.leftAnchor.constraint(equalTo: anchor)
        }
        constraint.priority = priority
        constraint.identifier = "namada_\(view.uniqueKey)_left_to_\(identifier(ofSecondItemIn: constraint))"
        constructedConstraints.removeAll { $0.identifier == constraint.identifier }
        constructedConstraints.append(constraint)
        return self
    }
    
    @discardableResult
    func left(_ relation: LayoutRelation<CGFloat>, to anchor: NSLayoutXAxisAnchor) -> Self {
        return left(relation, to: anchor, priority: context.mutatingPriority)
    }
    
    @discardableResult
    func left(_ relation: LayoutRelation<CGFloat>, to parent: ParentRelated, priority: UILayoutPriority) -> Self {
        guard let superview = view.superview ?? context.delegate.namadaLayout(viewHaveNoSuperview: view) else {
            context.delegate.namadaLayout(view, erroWhenLayout: .init(description: "View have no superview"))
            return self
        }
        if parent == .safeArea {
            if #available(iOS 11.0, *) {
                let guide = superview.safeAreaLayoutGuide
                return left(relation, to: guide.leftAnchor, priority: priority)
            } else {
                let spaceAdded = superview.layoutMargins.top
                switch relation {
                case .equal, .equalTo(_):
                    return left(.equalTo(relation.distance + spaceAdded), to: superview.leftAnchor, priority: priority)
                case .lessThan, .lessThanTo(_):
                    return left(.lessThanTo(relation.distance + spaceAdded), to: superview.leftAnchor, priority: priority)
                case .moreThan, .moreThanTo(_):
                    return left(.moreThanTo(relation.distance + spaceAdded), to: superview.leftAnchor, priority: priority)
                }
            }
        } else {
            return left(relation, to: superview.leftAnchor, priority: priority)
        }
    }
    
    @discardableResult
    func left(_ relation: LayoutRelation<CGFloat>, to parent: ParentRelated) -> Self {
        return left(relation, to: parent, priority: context.mutatingPriority)
    }
    
    // MARK: Right Anchor
    
    @discardableResult
    func right(_ relation: LayoutRelation<CGFloat>, to anchor: NSLayoutXAxisAnchor, priority: UILayoutPriority) -> Self {
        let constraint: NSLayoutConstraint
        switch relation {
        case .moreThanTo(let space):
            constraint = view.rightAnchor.constraint(greaterThanOrEqualTo: anchor, constant: -space)
        case .lessThanTo(let space):
            constraint = view.rightAnchor.constraint(lessThanOrEqualTo: anchor, constant: -space)
        case .equalTo(let space):
            constraint = view.rightAnchor.constraint(equalTo: anchor, constant: -space)
        case .moreThan:
            constraint = view.rightAnchor.constraint(greaterThanOrEqualTo: anchor)
        case .lessThan:
            constraint = view.rightAnchor.constraint(lessThanOrEqualTo: anchor)
        case .equal:
            constraint = view.rightAnchor.constraint(equalTo: anchor)
        }
        constraint.priority = priority
        constraint.identifier = "namada_\(view.uniqueKey)_right_to_\(identifier(ofSecondItemIn: constraint))"
        constructedConstraints.removeAll { $0.identifier == constraint.identifier }
        constructedConstraints.append(constraint)
        return self
    }
    
    @discardableResult
    func right(_ relation: LayoutRelation<CGFloat>, to anchor: NSLayoutXAxisAnchor) -> Self {
        return right(relation, to: anchor, priority: context.mutatingPriority)
    }
    
    @discardableResult
    func right(_ relation: LayoutRelation<CGFloat>, to parent: ParentRelated, priority: UILayoutPriority) -> Self {
        guard let superview = view.superview else {
            //do something
            return self
        }
        if parent == .safeArea {
            if #available(iOS 11.0, *) {
                let guide = superview.safeAreaLayoutGuide
                return right(relation, to: guide.rightAnchor, priority: priority)
            } else {
                let spaceAdded = superview.layoutMargins.top
                switch relation {
                case .equal, .equalTo(_):
                    return right(.equalTo(-(relation.distance + spaceAdded)), to: superview.rightAnchor, priority: priority)
                case .lessThan, .lessThanTo(_):
                    return right(.lessThanTo(-(relation.distance + spaceAdded)), to: superview.rightAnchor, priority: priority)
                case .moreThan, .moreThanTo(_):
                    return right(.moreThanTo(-(relation.distance + spaceAdded)), to: superview.rightAnchor, priority: priority)
                }
            }
        } else {
            return right(relation, to: superview.rightAnchor, priority: priority)
        }
    }
    
    @discardableResult
    func right(_ relation: LayoutRelation<CGFloat>, to parent: ParentRelated) -> Self {
        return right(relation, to: parent, priority: context.mutatingPriority)
    }
}
