//
//  ViewLayoutable.swift
//  FBSnapshotTestCase
//
//  Created by Nayanda Haberty (ID) on 07/07/20.
//

import Foundation
import UIKit

public protocol ViewLayoutable: AreaLayoutBuilder {
    var safeArea: AreaLayout { get }
    var center: CenterAnchorLayout { get }
    var width: DimensionLayout { get }
    var height: DimensionLayout { get }
    var view: UIView { get }
    var subLayouts: [LayoutBuilderType] { get }
    func put<V: UIView>(_ view: V, _ builder: (LayoutBuilderType) -> Void) -> ViewApplicator<V>
    
    @discardableResult
    func size(equalWith size: CGSize, priority: UILayoutPriority) -> LayoutBuilderType
    @discardableResult
    func size(moreThan size: CGSize, priority: UILayoutPriority) -> LayoutBuilderType
    @discardableResult
    func size(lessThan size: CGSize, priority: UILayoutPriority) -> LayoutBuilderType
    
    @discardableResult
    func atLeft<View: UIView>(of other: View, spacing: CGFloat, priority: UILayoutPriority) -> LayoutBuilderType
    @discardableResult
    func atLeft<View: UIView>(of other: View, moreThan space: CGFloat, priority: UILayoutPriority) -> LayoutBuilderType
    @discardableResult
    func atLeft<View: UIView>(of other: View, lessThan space: CGFloat, priority: UILayoutPriority) -> LayoutBuilderType
    
    @discardableResult
    func atRight<View: UIView>(of other: View, spacing: CGFloat, priority: UILayoutPriority) -> LayoutBuilderType
    @discardableResult
    func atRight<View: UIView>(of other: View, moreThan space: CGFloat, priority: UILayoutPriority) -> LayoutBuilderType
    @discardableResult
    func atRight<View: UIView>(of other: View, lessThan space: CGFloat, priority: UILayoutPriority) -> LayoutBuilderType
    
    @discardableResult
    func atBottom<View: UIView>(of other: View, spacing: CGFloat, priority: UILayoutPriority) -> LayoutBuilderType
    @discardableResult
    func atBottom<View: UIView>(of other: View, moreThan space: CGFloat, priority: UILayoutPriority) -> LayoutBuilderType
    @discardableResult
    func atBottom<View: UIView>(of other: View, lessThan space: CGFloat, priority: UILayoutPriority) -> LayoutBuilderType
    
    @discardableResult
    func atTop<View: UIView>(of other: View, spacing: CGFloat, priority: UILayoutPriority) -> LayoutBuilderType
    @discardableResult
    func atTop<View: UIView>(of other: View, moreThan space: CGFloat, priority: UILayoutPriority) -> LayoutBuilderType
    @discardableResult
    func atTop<View: UIView>(of other: View, lessThan space: CGFloat, priority: UILayoutPriority) -> LayoutBuilderType
    
    
    @discardableResult
    func fillSafeArea(with margin: UIEdgeInsets, priority: UILayoutPriority) -> LayoutBuilderType
    @discardableResult
    func fixToSafeArea(_ positions: [LayoutPosition], with margin: UIEdgeInsets, priority: UILayoutPriority) -> LayoutBuilderType
    @discardableResult
    func inSafeArea(_ positions: [LayoutPosition], moreThan margin: UIEdgeInsets, priority: UILayoutPriority) -> LayoutBuilderType
    @discardableResult
    func inSafeArea(_ positions: [LayoutPosition], lessThan margin: UIEdgeInsets, priority: UILayoutPriority) -> LayoutBuilderType
}
