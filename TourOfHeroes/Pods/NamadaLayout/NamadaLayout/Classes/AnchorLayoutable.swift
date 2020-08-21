//
//  AnchorLayoutable.swift
//  NamadaLayout
//
//  Created by Nayanda Haberty (ID) on 07/07/20.
//

import Foundation
import UIKit

public protocol AnchorLayoutable: LayoutBuilder {
    @discardableResult
    func equal(with other: LayoutBuilderType, priority: UILayoutPriority) -> LayoutBuilderType
    @discardableResult
    func distance(to other: LayoutBuilderType, at space: CGFloat, priority: UILayoutPriority) -> LayoutBuilderType
    @discardableResult
    func distance(to other: LayoutBuilderType, moreThan space: CGFloat, priority: UILayoutPriority) -> LayoutBuilderType
    @discardableResult
    func distance(to other: LayoutBuilderType, lessThan space: CGFloat, priority: UILayoutPriority) -> LayoutBuilderType
    @discardableResult
    func equalWithParent(priority: UILayoutPriority) -> LayoutBuilderType
    @discardableResult
    func distanceToParent(at space: CGFloat, priority: UILayoutPriority) -> LayoutBuilderType
    @discardableResult
    func distanceToParent(moreThan space: CGFloat, priority: UILayoutPriority) -> LayoutBuilderType
    @discardableResult
    func distanceToParent(lessThan space: CGFloat, priority: UILayoutPriority) -> LayoutBuilderType
}
