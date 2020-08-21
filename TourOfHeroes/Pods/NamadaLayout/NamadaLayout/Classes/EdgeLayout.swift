//
//  EdgeLayout.swift
//  NamadaLayout
//
//  Created by Nayanda Haberty (ID) on 06/07/20.
//

import Foundation
import UIKit

public class EdgeLayout<NSAnchor: Hashable>: AnchorLayout<NSAnchor>, AnchorLayoutableWithSafeArea where NSAnchor: AnyObject {
    let parentSafeEdge: LayoutBuilderType?
    let inset: CGFloat
    
    init(
        context: LayoutContext,
        anchor: NSAnchor,
        inset: CGFloat = 0,
        multiplier: SpaceLayoutMultiplier = .positive,
        identifier: String,
        parentRelated: LayoutBuilderType?,
        parentSafeEdge: LayoutBuilderType?) {
        self.parentSafeEdge = parentSafeEdge
        self.inset = inset
        super.init(
            context: context,
            anchor: anchor,
            multiplier: multiplier,
            identifier: identifier,
            parentRelated: parentRelated
        )
    }
    
    public override func hash(into hasher: inout Hasher) {
        super.hash(into: &hasher)
        hasher.combine(parentSafeEdge)
    }
    
    // MARK: Relation with other Anchor
    
    @discardableResult
    public func equalWithSafeArea(priority: UILayoutPriority) -> LayoutBuilderType {
        ifHaveSafeParent { parentSafe in
            add(
                anchor: parentSafe,
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
    public func distanceToSafeArea(
        at space: CGFloat,
        priority: UILayoutPriority) -> LayoutBuilderType {
        ifHaveSafeParent { parentSafe in
            add(
                anchor: parentSafe,
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
    public func distanceToSafeArea(
        moreThan space: CGFloat,
        priority: UILayoutPriority) -> LayoutBuilderType {
        ifHaveSafeParent { parentSafe in
            add(
                anchor: parentSafe,
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
    public func distanceToSafeArea(
        lessThan space: CGFloat,
        priority: UILayoutPriority) -> LayoutBuilderType {
        ifHaveSafeParent { parentSafe in
            add(
                anchor: parentSafe,
                with: .init(
                    space: offsetMultiplier.multipliy(space),
                    relation: offsetMultiplier.real(relation: .lessThan),
                    priority: priority
                )
            )
        }
        return self
    }
    
    func ifHaveSafeParent(do actions: (LayoutBuilderType) -> Void) {
        if let parentLayout = parentSafeEdge {
            actions(parentLayout)
            return
        }
        do {
            if let parentLayout = try context.layoutDelegate.layoutBuilderNeedParent(self) {
                actions(parentLayout)
            }
            return
        } catch {
            guard let layoutError: LayoutError = error as? LayoutError else {
                print(error.localizedDescription)
                return
            }
            context.layoutDelegate.layoutBuilder(self, onError: layoutError)
        }
    }
}
