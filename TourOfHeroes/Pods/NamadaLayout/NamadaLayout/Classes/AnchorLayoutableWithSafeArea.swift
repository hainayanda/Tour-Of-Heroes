//
//  EdgeLayoutable.swift
//  NamadaLayout
//
//  Created by Nayanda Haberty (ID) on 07/07/20.
//

import Foundation
import UIKit

public protocol AnchorLayoutableWithSafeArea: AnchorLayoutable {
    @discardableResult
    func equalWithSafeArea(priority: UILayoutPriority) -> LayoutBuilderType
    @discardableResult
    func distanceToSafeArea(at space: CGFloat, priority: UILayoutPriority) -> LayoutBuilderType
    @discardableResult
    func distanceToSafeArea(moreThan space: CGFloat, priority: UILayoutPriority) -> LayoutBuilderType
    @discardableResult
    func distanceToSafeArea(lessThan space: CGFloat, priority: UILayoutPriority) -> LayoutBuilderType
}
