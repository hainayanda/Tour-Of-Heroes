//
//  AnchorLayout.swift
//  NamadaLayout
//
//  Created by Nayanda Haberty (ID) on 05/07/20.
//

import Foundation
import UIKit

// MARK: Anchor

public class AnchorLayout<NSAnchor: Hashable>: AnchorLayoutable, Hashable where NSAnchor : AnyObject {
    
    public typealias LayoutBuilderType = AnchorLayout<NSAnchor>
    
    public private(set) var parentLayout: LayoutBuilderType?
    var anchor: NSAnchor
    var offsetMultiplier: SpaceLayoutMultiplier
    var relatives: [AnchorLayout<NSAnchor>: SpaceLayout] = [:]
    public let context: LayoutContext
    public let identifier: String
    
    init(
        context: LayoutContext,
        anchor: NSAnchor,
        multiplier: SpaceLayoutMultiplier = .positive,
        identifier: String,
        parentRelated: LayoutBuilderType?) {
        self.context = context
        self.anchor = anchor
        self.offsetMultiplier = multiplier
        self.identifier = identifier
        self.parentLayout = parentRelated
    }
    
    public func hash(into hasher: inout Hasher) {
        hasher.combine(anchor)
        hasher.combine(identifier)
    }
    
    // MARK: Relation with other Anchor
    
    @discardableResult
    public func equal(
        with other: AnchorLayout<NSAnchor>,
        priority: UILayoutPriority) -> AnchorLayout<NSAnchor> {
        add(anchor: other, with: .init(space: 0, relation: .exactly, priority: priority))
        return self
    }
    
    @discardableResult
    public func distance(
        to other: AnchorLayout<NSAnchor>,
        at space: CGFloat,
        priority: UILayoutPriority) -> AnchorLayout<NSAnchor> {
        add(
            anchor: other,
            with: .init(
                space: offsetMultiplier.multipliy(space),
                relation: .exactly,
                priority: priority
            )
        )
        return self
    }
    
    @discardableResult
    public func distance(
        to other: AnchorLayout<NSAnchor>,
        moreThan space: CGFloat,
        priority: UILayoutPriority) -> AnchorLayout<NSAnchor> {
        add(
            anchor: other,
            with: .init(
                space: offsetMultiplier.multipliy(space),
                relation: offsetMultiplier.real(relation: .greaterThan),
                priority: priority
            )
        )
        return self
    }
    
    @discardableResult
    public func distance(
        to other: AnchorLayout<NSAnchor>,
        lessThan space: CGFloat,
        priority: UILayoutPriority) -> AnchorLayout<NSAnchor> {
        add(
            anchor: other,
            with: .init(
                space: offsetMultiplier.multipliy(space),
                relation: offsetMultiplier.real(relation: .lessThan),
                priority: priority
            )
        )
        return self
    }
    
    // MARK: Relation with Parent
    
    @discardableResult
    public func equalWithParent(priority: UILayoutPriority) -> AnchorLayout<NSAnchor> {
        ifHaveParent { parent in
            add(
                anchor: parent,
                with: .init(
                    space: 0,
                    relation: .exactly,
                    priority: priority
                )
            )
        }
        return self
    }
    
    @discardableResult
    public func distanceToParent(
        at space: CGFloat,
        priority: UILayoutPriority) -> AnchorLayout<NSAnchor> {
        ifHaveParent { parent in
            add(
                anchor: parent,
                with: .init(
                    space: offsetMultiplier.multipliy(space),
                    relation: .exactly,
                    priority: priority
                )
            )
        }
        return self
    }
    
    @discardableResult
    public func distanceToParent(
        moreThan space: CGFloat,
        priority: UILayoutPriority) -> AnchorLayout<NSAnchor> {
        ifHaveParent { parent in
            add(
                anchor: parent,
                with: .init(
                    space: offsetMultiplier.multipliy(space),
                    relation: offsetMultiplier.real(relation: .greaterThan),
                    priority: priority
                )
            )
        }
        return self
    }
    
    @discardableResult
    public func distanceToParent(
        lessThan space: CGFloat,
        priority: UILayoutPriority) -> AnchorLayout<NSAnchor> {
        ifHaveParent { parent in
            add(
                anchor: parent,
                with: .init(
                    space: offsetMultiplier.multipliy(space),
                    relation: offsetMultiplier.real(relation: .lessThan),
                    priority: priority
                )
            )
        }
        return self
    }
    
    public var constructedConstraints: [NSLayoutConstraint] {
        relatives.compactMap { other, space in
            if let anchor = self.anchor as? NSLayoutYAxisAnchor,
                let otherAnchor = other.anchor as? NSLayoutYAxisAnchor {
                let constraint: NSLayoutConstraint
                let id = "\(identifier)_to_\(other.identifier)"
                switch space.relation {
                case .exactly:
                    constraint = anchor.constraint(equalTo: otherAnchor, constant: space.space)
                case .greaterThan:
                    constraint = anchor.constraint(greaterThanOrEqualTo: otherAnchor, constant: space.space)
                case .lessThan:
                    constraint = anchor.constraint(lessThanOrEqualTo: otherAnchor, constant: space.space)
                }
                constraint.identifier = id
                constraint.priority = space.priority
                return constraint
            } else if let anchor = self.anchor as? NSLayoutXAxisAnchor,
                let otherAnchor = other.anchor as? NSLayoutXAxisAnchor {
                let constraint: NSLayoutConstraint
                let id = "\(identifier)_to_\(other.identifier)"
                switch space.relation {
                case .exactly:
                    constraint = anchor.constraint(equalTo: otherAnchor, constant: space.space)
                case .greaterThan:
                    constraint = anchor.constraint(greaterThanOrEqualTo: otherAnchor, constant: space.space)
                case .lessThan:
                    constraint = anchor.constraint(lessThanOrEqualTo: otherAnchor, constant: space.space)
                }
                constraint.identifier = id
                constraint.priority = space.priority
                return constraint
            }
            return nil
        }
    }
    
    func add(anchor: AnchorLayout<NSAnchor>, with space: SpaceLayout) {
        guard self != anchor else {
            do {
                try context.layoutDelegate.layoutBuilder(self, relateWith: anchor)
            } catch {
                guard let layoutError: LayoutError = error as? LayoutError else {
                    print(error.localizedDescription)
                    return
                }
                context.layoutDelegate.layoutBuilder(self, onError: layoutError)
            }
            return
        }
        if let found = relatives.keys.first(where: { $0.identifier == anchor.identifier }) {
            relatives.removeValue(forKey: found)
        }
        var space = space
        space.space += offsetMultiplier.multipliy((anchor as? EdgeLayout<NSAnchor>)?.inset ?? 0)
        space.space += offsetMultiplier.multipliy((self as? EdgeLayout<NSAnchor>)?.inset ?? 0)
        relatives[anchor] = space
    }
    
    public static func == (lhs: AnchorLayout<NSAnchor>, rhs: AnchorLayout<NSAnchor>) -> Bool {
        lhs.anchor == rhs.anchor && lhs.identifier == rhs.identifier
    }
}

// MARK: CenterAnchor

public class CenterAnchorLayout: LayoutBuilder, Hashable {
    
    public typealias LayoutBuilderType = CenterAnchorLayout
    
    public private(set) var parentLayout: LayoutBuilderType?
    public private(set) var xAxis: AnchorLayout<NSLayoutXAxisAnchor>
    public private(set) var yAxis: AnchorLayout<NSLayoutYAxisAnchor>
    public let identifier: String
    public let context: LayoutContext
    
    public var constructedConstraints: [NSLayoutConstraint] {
        xAxis.constructedConstraints + yAxis.constructedConstraints
    }
    
    init(
        context: LayoutContext,
        xAxis: AnchorLayout<NSLayoutXAxisAnchor>,
        yAxis: AnchorLayout<NSLayoutYAxisAnchor>,
        identifier: String,
        parentRelated: LayoutBuilderType?) {
        self.context = context
        self.xAxis = xAxis
        self.yAxis = yAxis
        self.parentLayout = parentRelated
        self.identifier = identifier
    }
    
    public func hash(into hasher: inout Hasher) {
        hasher.combine(xAxis)
        hasher.combine(yAxis)
    }
    
    @discardableResult
    public func equal(with other: CenterAnchorLayout, priority: UILayoutPriority? = nil) -> CenterAnchorLayout {
        guard self != other else {
            do {
                try context.layoutDelegate.layoutBuilder(self, relateWith: other)
            } catch {
                guard let layoutError: LayoutError = error as? LayoutError else {
                    print(error.localizedDescription)
                    return self
                }
                context.layoutDelegate.layoutBuilder(self, onError: layoutError)
            }
            return self
        }
        let layoutPriority = priority ?? context.countedPriority
        xAxis.equal(with: other.xAxis, priority: layoutPriority)
        yAxis.equal(with: other.yAxis, priority: layoutPriority)
        return self
    }
    
    @discardableResult
    public func equalWithParent(priority: UILayoutPriority? = nil) -> CenterAnchorLayout {
        let layoutPriority = priority ?? context.countedPriority
        xAxis.equalWithParent(priority: layoutPriority)
        yAxis.equalWithParent(priority: layoutPriority)
        return self
    }
    
    public static func == (lhs: CenterAnchorLayout, rhs: CenterAnchorLayout) -> Bool {
        lhs.xAxis == rhs.xAxis && lhs.yAxis == rhs.yAxis
    }
    
}
