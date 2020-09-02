//
//  NamadaLayoutable+Extensions.swift
//  NamadaLayout
//
//  Created by Nayanda Haberty (ID) on 27/08/20.
//

import Foundation

extension NamadaLayoutable {
    
    func identifier(ofSecondItemIn constraint: NSLayoutConstraint) -> String {
        let relatedKey = (constraint.secondItem as? UIView)?.uniqueKey ?? "unknown"
        return "\(relatedKey)_\(constraint.secondAttribute.asString)"
    }
    
    @discardableResult
    public func center(_ relation: LayoutRelation<CoordinateOffsets>, to view: UIView, priority: UILayoutPriority? = nil) -> Self {
        let priority: UILayoutPriority = priority ?? context.mutatingPriority
        centerX(relation.asXRelation, to: view.centerXAnchor, priority: priority)
        centerY(relation.asYRelation, to: view.centerYAnchor, priority: priority)
        return self
    }
    
    @discardableResult
    public func center(_ relation: LayoutRelation<CoordinateOffsets>, to parent: ParentRelated, priority: UILayoutPriority? = nil) -> Self {
        let priority: UILayoutPriority = priority ?? context.mutatingPriority
        centerX(relation.asXRelation, to: parent, priority: priority)
        centerY(relation.asYRelation, to: parent, priority: priority)
        return self
    }
    
    // MARK: Vertical Anchor
    
    @discardableResult
    public func vertical(_ relation: LayoutRelation<InsetsConvertible>, to parent: ParentRelated, priority: UILayoutPriority? = nil) -> Self {
        let priority: UILayoutPriority = priority ?? context.mutatingPriority
        top(relation.asTopRelation, to: parent, priority: priority)
        bottom(relation.asBottomRelation, to: parent, priority: priority)
        return self
    }
    
    @discardableResult
    public func vertical(_ relation: LayoutRelation<InsetsConvertible>, to view: UIView, priority: UILayoutPriority? = nil) -> Self {
        let priority: UILayoutPriority = priority ?? context.mutatingPriority
        top(relation.asTopRelation, to: view.topAnchor, priority: priority)
        bottom(relation.asBottomRelation, to: view.bottomAnchor, priority: priority)
        return self
    }
    
    // MARK: Horizontal Anchor
    
    @discardableResult
    public func horizontal(_ relation: LayoutRelation<InsetsConvertible>, to view: UIView, priority: UILayoutPriority? = nil) -> Self {
        let priority: UILayoutPriority = priority ?? context.mutatingPriority
        left(relation.asLeftRelation, to: view.leftAnchor, priority: priority)
        right(relation.asRightRelation, to: view.rightAnchor, priority: priority)
        return self
    }
    
    @discardableResult
    public func horizontal(_ relation: LayoutRelation<InsetsConvertible>, to parent: ParentRelated, priority: UILayoutPriority? = nil) -> Self {
        let priority: UILayoutPriority = priority ?? context.mutatingPriority
        left(relation.asLeftRelation, to: parent, priority: priority)
        right(relation.asRightRelation, to: parent, priority: priority)
        return self
    }
    
    // MARK: Edges Anchor
    
    @discardableResult
    public func edges(_ relation: LayoutRelation<InsetsConvertible>, to parent: ParentRelated, priority: UILayoutPriority? = nil) -> Self {
        let priority: UILayoutPriority = priority ?? context.mutatingPriority
        vertical(relation, to: parent, priority: priority)
        horizontal(relation, to: parent, priority: priority)
        return self
    }
    
    // MARK: Size Anchor
    
    @discardableResult
    public func size(_ relation: InterRelation<CGSize>, priority: UILayoutPriority? = nil) -> Self {
        let priority: UILayoutPriority = priority ?? context.mutatingPriority
        height(relation.asHeightRelation, priority: priority)
        width(relation.asHeightRelation, priority: priority)
        return self
    }
    
    @discardableResult
    public func size(_ relation: InterRelation<UIView>, multiplyBy multipier: CGFloat = 1, constant: CGFloat = 0, priority: UILayoutPriority? = nil) -> Self {
        let priority: UILayoutPriority = priority ?? context.mutatingPriority
        height(relation.asHeightRelation, multiplyBy: multipier, constant: constant, priority: priority)
        width(relation.asWidthRelation, multiplyBy: multipier, constant: constant, priority: priority)
        return self
    }
    
    // MARK: Position Anchor
    
    @discardableResult
    public func at(_ positions: [NamadaLayoutPosition], _ relation: LayoutRelation<InsetsConvertible>, to parent: ParentRelated, priority: UILayoutPriority? = nil) -> Self {
        let priority: UILayoutPriority = priority ?? context.mutatingPriority
        for position in positions {
            switch position {
            case .top:
                top(relation.asTopRelation, to: parent, priority: priority)
            case .bottom:
                bottom(relation.asBottomRelation, to: parent, priority: priority)
            case .left:
                left(relation.asLeftRelation, to: parent, priority: priority)
            case .right:
                right(relation.asRightRelation, to: parent, priority: priority)
            }
        }
        return self
    }
    
    @discardableResult
    public func at(_ viewRelation: NamadaRelatedPosition, _ relation: LayoutRelation<InsetsConvertible>, priority: UILayoutPriority? = nil) -> Self {
        let priority: UILayoutPriority = priority ?? context.mutatingPriority
        let position = viewRelation.position
        let relatedView = viewRelation.view
        switch position {
        case .top:
            bottom(relation.asBottomRelation, to: relatedView.topAnchor, priority: priority)
        case .bottom:
            top(relation.asTopRelation, to: relatedView.bottomAnchor, priority: priority)
        case .left:
            right(relation.asRightRelation, to: relatedView.leftAnchor, priority: priority)
        case .right:
            left(relation.asLeftRelation, to: relatedView.rightAnchor, priority: priority)
        }
        if viewRelation.shouldParallel {
            switch position {
            case .top, .bottom:
                centerX(.equal, to: relatedView.centerXAnchor, priority: priority)
            case .left, .right:
                centerY(.equal, to: relatedView.centerYAnchor, priority: priority)
            }
        }
        return self
    }
    
    // MARK: Between Anchor
    
    public func inBetween(of view: UIView, and otherView: UIView, _ position: NamadaMiddlePosition, priority: UILayoutPriority? = nil) -> Self {
        let priority: UILayoutPriority = priority ?? context.mutatingPriority
        switch position {
        case .vertically(let relation):
            top(relation.asTopRelation, to: view.bottomAnchor, priority: priority)
            bottom(relation.asBottomRelation, to: otherView.topAnchor, priority: priority)
        case .horizontally(let relation):
            left(relation.asLeftRelation, to: view.rightAnchor, priority: priority)
            right(relation.asRightRelation, to: view.leftAnchor, priority: priority)
        }
        return self
    }
    
}

public extension Array where Element == NamadaLayoutPosition {
    static var topLeft: [Element] { [.top, .left] }
    static var topRight: [Element] { [.top, .right] }
    static var bottomLeft: [Element] { [.bottom, .left] }
    static var bottomRight: [Element] { [.bottom, .right] }
    static var fullLeft: [Element] { [.left, .top, .bottom] }
    static var fullRight: [Element] { [.right, .top, .bottom] }
    static var fullBottom: [Element] { [.bottom, .left, .right] }
    static var fullTop: [Element] { [.top, .left, .right] }
    static var edges: [Element] { [.top, .bottom, .left, .right] }
}
