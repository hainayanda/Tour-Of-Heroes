//
//  LayoutBuilderTypeable+Extension.swift
//  FBSnapshotTestCase
//
//  Created by Nayanda Haberty (ID) on 07/07/20.
//

import Foundation
import UIKit

extension ViewLayoutable {
    
    func apply() {
        context.layoutDelegate.layoutBuilder(self, willActivateConstraints: constructedConstraints)
        NSLayoutConstraint.activate(constructedConstraints)
        context.layoutDelegate.layoutBuilder(self, didActivateConstraints: constructedConstraints)
    }
    
    func editExistingAndApply() {
        self.view.mostTopParentForLayout.remove(allIdentified: constructedConstraints)
        apply()
    }
    
    func remake() {
        self.view.removeAllRelatedNamadaConstraints()
        apply()
    }
    
    // MARK: Size
    
    @discardableResult
    public func size(
        equalWith size: CGSize,
        priority: UILayoutPriority) -> Self {
        width.equal(with: size.width, priority: priority)
        height.equal(with: size.height, priority: priority)
        return self
    }
    
    @discardableResult
    public func size(
        moreThan size: CGSize,
        priority: UILayoutPriority) -> Self {
        width.moreThan(size.width, priority: priority)
        height.moreThan(size.height, priority: priority)
        return self
    }
    
    @discardableResult
    public func size(
        lessThan size: CGSize,
        priority: UILayoutPriority) -> Self {
        width.lessThan(size.width, priority: priority)
        height.lessThan(size.height, priority: priority)
        return self
    }
    
    @discardableResult
    public func size(equalWith size: CGSize) -> Self {
        self.size(equalWith: size, priority: context.countedPriority)
    }
    
    @discardableResult
    public func size(moreThan size: CGSize) -> Self {
        self.size(moreThan: size, priority: context.countedPriority)
    }
    
    @discardableResult
    public func size(lessThan size: CGSize) -> Self {
        self.size(lessThan: size, priority: context.countedPriority)
    }
    
    // MARK: Left
    
    @discardableResult
    public func atLeft<View: UIView>(
        of other: View,
        spacing: CGFloat,
        priority: UILayoutPriority) -> Self {
        right.distance(to: other.layout.left, at: spacing, priority: priority)
        center.yAxis.equal(with: other.layout.center.yAxis, priority: priority)
        return self
    }
    
    @discardableResult
    public func atLeft<View: UIView>(
        of other: View,
        spacing: CGFloat? = nil,
        priority: UILayoutPriority? = nil) -> Self {
        self.atLeft(of: other, spacing: spacing ?? 0, priority: priority ?? context.countedPriority)
    }
    
    @discardableResult
    public func atLeft<View: UIView>(
        of other: View,
        lessThan space: CGFloat,
        priority: UILayoutPriority) -> Self {
        right.distance(to: other.layout.left, lessThan: space, priority: priority)
        center.yAxis.equal(with: other.layout.center.yAxis, priority: priority)
        return self
    }
    
    @discardableResult
    public func atLeft<View: UIView>(
        of other: View,
        lessThan space: CGFloat,
        priority: UILayoutPriority? = nil) -> Self {
        self.atLeft(of: other, lessThan: space, priority: priority ?? context.countedPriority)
    }
    
    @discardableResult
    public func atLeft<View: UIView>(
        of other: View,
        moreThan space: CGFloat,
        priority: UILayoutPriority) -> Self {
        right.distance(to: other.layout.left, moreThan: space, priority: priority)
        center.yAxis.equal(with: other.layout.center.yAxis, priority: priority)
        return self
    }
    
    @discardableResult
    public func atLeft<View: UIView>(
        of other: View,
        moreThan space: CGFloat,
        priority: UILayoutPriority? = nil) -> Self {
        self.atLeft(of: other, moreThan: space, priority: priority ?? context.countedPriority)
    }
    
    
    // MARK: Right
    
    @discardableResult
    public func atRight<View: UIView>(
        of other: View,
        spacing: CGFloat,
        priority: UILayoutPriority) -> Self {
        left.distance(to: other.layout.right, at: spacing, priority: priority)
        center.yAxis.equal(with: other.layout.center.yAxis, priority: priority)
        return self
    }
    
    @discardableResult
    public func atRight<View: UIView>(
        of other: View,
        spacing: CGFloat? = nil,
        priority: UILayoutPriority? = nil) -> Self {
        self.atRight(of: other, spacing: spacing ?? 0, priority: priority ?? context.countedPriority)
    }
    
    @discardableResult
    public func atRight<View: UIView>(
        of other: View,
        lessThan space: CGFloat,
        priority: UILayoutPriority) -> Self {
        left.distance(to: other.layout.right, lessThan: space, priority: priority)
        center.yAxis.equal(with: other.layout.center.yAxis, priority: priority)
        return self
    }
    
    @discardableResult
    public func atRight<View: UIView>(
        of other: View,
        lessThan space: CGFloat,
        priority: UILayoutPriority? = nil) -> Self {
        self.atRight(of: other, lessThan: space, priority: priority ?? context.countedPriority)
    }
    
    @discardableResult
    public func atRight<View: UIView>(
        of other: View,
        moreThan space: CGFloat,
        priority: UILayoutPriority) -> Self {
        left.distance(to: other.layout.right, moreThan: space, priority: priority)
        center.yAxis.equal(with: other.layout.center.yAxis, priority: priority)
        return self
    }
    
    @discardableResult
    public func atRight<View: UIView>(
        of other: View,
        moreThan space: CGFloat,
        priority: UILayoutPriority? = nil) -> Self {
        self.atRight(of: other, moreThan: space, priority: priority ?? context.countedPriority)
    }
    
    // MARK: Top
    
    @discardableResult
    public func atTop<View: UIView>(
        of other: View,
        spacing: CGFloat,
        priority: UILayoutPriority) -> Self {
        bottom.distance(to: other.layout.top, at: spacing, priority: priority)
        center.xAxis.equal(with: other.layout.center.xAxis, priority: priority)
        return self
    }
    
    @discardableResult
    public func atTop<View: UIView>(
        of other: View,
        spacing: CGFloat? = nil,
        priority: UILayoutPriority? = nil) -> Self {
        self.atTop(of: other, spacing: spacing ?? 0, priority: priority ?? context.countedPriority)
    }
    
    @discardableResult
    public func atTop<View: UIView>(
        of other: View,
        lessThan space: CGFloat,
        priority: UILayoutPriority) -> Self {
        bottom.distance(to: other.layout.top, lessThan: space, priority: priority)
        center.xAxis.equal(with: other.layout.center.xAxis, priority: priority)
        return self
    }
    
    @discardableResult
    public func atTop<View: UIView>(
        of other: View,
        lessThan space: CGFloat,
        priority: UILayoutPriority? = nil) -> Self {
        self.atTop(of: other, lessThan: space, priority: priority ?? context.countedPriority)
    }
    
    @discardableResult
    public func atTop<View: UIView>(
        of other: View,
        moreThan space: CGFloat,
        priority: UILayoutPriority) -> Self {
        bottom.distance(to: other.layout.top, moreThan: space, priority: priority)
        center.xAxis.equal(with: other.layout.center.xAxis, priority: priority)
        return self
    }
    
    @discardableResult
    public func atTop<View: UIView>(
        of other: View,
        moreThan space: CGFloat,
        priority: UILayoutPriority? = nil) -> Self {
        self.atTop(of: other, moreThan: space, priority: priority ?? context.countedPriority)
    }
    
    // MARK: Bottom
    
    @discardableResult
    public func atBottom<View: UIView>(
        of other: View,
        spacing: CGFloat,
        priority: UILayoutPriority) -> Self {
        top.distance(to: other.layout.bottom, at: spacing, priority: priority)
        center.xAxis.equal(with: other.layout.center.xAxis, priority: priority)
        return self
    }
    
    @discardableResult
    public func atBottom<View: UIView>(
        of other: View,
        spacing: CGFloat? = nil,
        priority: UILayoutPriority? = nil) -> Self {
        self.atBottom(of: other, spacing: spacing ?? 0, priority: priority ?? context.countedPriority)
    }
    
    @discardableResult
    public func atBottom<View: UIView>(
        of other: View,
        lessThan space: CGFloat,
        priority: UILayoutPriority) -> Self {
        top.distance(to: other.layout.bottom, lessThan: space, priority: priority)
        center.xAxis.equal(with: other.layout.center.xAxis, priority: priority)
        return self
    }
    
    @discardableResult
    public func atBottom<View: UIView>(
        of other: View,
        lessThan space: CGFloat,
        priority: UILayoutPriority? = nil) -> Self {
        self.atBottom(of: other, lessThan: space, priority: priority ?? context.countedPriority)
    }
    
    @discardableResult
    public func atBottom<View: UIView>(
        of other: View,
        moreThan space: CGFloat,
        priority: UILayoutPriority) -> Self {
        top.distance(to: other.layout.bottom, moreThan: space, priority: priority )
        center.xAxis.equal(with: other.layout.center.xAxis, priority: priority)
        return self
    }
    
    @discardableResult
    public func atBottom<View: UIView>(
        of other: View,
        moreThan space: CGFloat,
        priority: UILayoutPriority? = nil) -> Self {
        self.atBottom(of: other, moreThan: space, priority: priority ?? context.countedPriority)
    }
    
    @discardableResult
    public func fillSafeArea(with margin: UIEdgeInsets, priority: UILayoutPriority) -> Self {
        return fixToSafeArea(.edges, with: margin, priority: priority)
    }
    
    @discardableResult
    public func fillSafeArea(with margin: UIEdgeInsets = .zero, priority: UILayoutPriority? = nil) -> Self {
        return fillSafeArea(with: margin, priority: priority ?? context.countedPriority)
    }
    
    @discardableResult
    public func fixToSafeArea(_ positions: [LayoutPosition], with margin: UIEdgeInsets = .zero, priority: UILayoutPriority? = nil) -> Self {
        fixToSafeArea(positions, with: margin, priority: priority ?? context.countedPriority)
    }
    
    @discardableResult
    public func fixToSafeArea(_ positions: [LayoutPosition]) -> Self {
        fixToSafeArea(positions, with: .zero, priority: context.countedPriority)
    }
    
    @discardableResult
    public func fixToSafeArea(_ positions: [LayoutPosition], with margin: UIEdgeInsets, priority: UILayoutPriority) -> Self {
        ifHaveParent { parent in
            guard let parent = parent as? ViewLayout else { return }
            let safeArea = parent.safeArea
            for position in positions {
                switch position {
                case .top:
                    top.distance(to: safeArea.top, at: margin.top, priority: priority)
                case .left:
                    left.distance(to: safeArea.left, at: margin.left, priority: priority)
                case .right:
                    right.distance(to: safeArea.right, at: margin.right, priority: priority)
                case .bottom:
                    bottom.distance(to: safeArea.bottom, at: margin.bottom, priority: priority)
                }
            }
        }
        return self
    }
    
    @discardableResult
    public func inSafeArea(_ positions: [LayoutPosition], moreThan margin: UIEdgeInsets) -> Self {
        return inSafeArea(positions, moreThan: margin, priority: context.countedPriority)
    }
    
    @discardableResult
    public func inSafeArea(_ positions: [LayoutPosition], moreThan margin: UIEdgeInsets, priority: UILayoutPriority) -> Self {
        ifHaveParent { parent in
            guard let parent = parent as? ViewLayout else { return }
            let safeArea = parent.safeArea
            for position in positions {
                switch position {
                case .top:
                    top.distance(to: safeArea.top, moreThan: margin.top, priority: priority)
                case .left:
                    left.distance(to: safeArea.left, moreThan: margin.left, priority: priority)
                case .right:
                    right.distance(to: safeArea.right, moreThan: margin.right, priority: priority)
                case .bottom:
                    bottom.distance(to: safeArea.bottom, moreThan: margin.bottom, priority: priority)
                }
            }
        }
        return self
    }
    
    @discardableResult
    public func inSafeArea(_ positions: [LayoutPosition], lessThan margin: UIEdgeInsets) -> Self {
        return inSafeArea(positions, lessThan: margin, priority: context.countedPriority)
    }
    
    @discardableResult
    public func inSafeArea(_ positions: [LayoutPosition], lessThan margin: UIEdgeInsets, priority: UILayoutPriority) -> Self {
        ifHaveParent { parent in
            guard let parent = parent as? ViewLayout else { return }
            let safeArea = parent.safeArea
            for position in positions {
                switch position {
                case .top:
                    top.distance(to: safeArea.top, lessThan: margin.top, priority: priority)
                case .left:
                    left.distance(to: safeArea.left, lessThan: margin.left, priority: priority)
                case .right:
                    right.distance(to: safeArea.right, lessThan: margin.right, priority: priority)
                case .bottom:
                    bottom.distance(to: safeArea.bottom, lessThan: margin.bottom, priority: priority)
                }
            }
        }
        return self
    }
}
