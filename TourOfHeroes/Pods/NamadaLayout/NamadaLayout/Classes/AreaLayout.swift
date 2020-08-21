//
//  AreaLayout.swift
//  NamadaLayout
//
//  Created by Nayanda Haberty (ID) on 07/07/20.
//

import Foundation
import UIKit

public class AreaLayout: AreaLayoutBuilder {
    
    public typealias LayoutProtocolType = AreaLayout
    
    public var context: LayoutContext
    public var identifier: String
    public var parentLayout: AreaLayout?
    
    public let top: EdgeLayout<NSLayoutYAxisAnchor>
    public let bottom: EdgeLayout<NSLayoutYAxisAnchor>
    public let left: EdgeLayout<NSLayoutXAxisAnchor>
    public let right: EdgeLayout<NSLayoutXAxisAnchor>
    
    init<View: UIView>(context: LayoutContext, view: View, parentLayout: ViewLayout?) {
        self.context = context
        self.parentLayout = parentLayout?.safeArea
        self.identifier = "namada_\(View.self)\(view.accessibilityIdentifier ?? "")\(view.hashValue)_safe_area"
        let top: NSLayoutYAxisAnchor
        let left: NSLayoutXAxisAnchor
        let bottom: NSLayoutYAxisAnchor
        let right: NSLayoutXAxisAnchor
        let inset: UIEdgeInsets
        if #available(iOS 11.0, *) {
            top = view.safeAreaLayoutGuide.topAnchor
            left = view.safeAreaLayoutGuide.leftAnchor
            bottom = view.safeAreaLayoutGuide.bottomAnchor
            right = view.safeAreaLayoutGuide.rightAnchor
            inset = .zero
        } else {
            top = view.topAnchor
            left = view.leftAnchor
            bottom = view.bottomAnchor
            right = view.rightAnchor
            inset = view.layoutMargins
        }
        self.top = .init(
            context: context,
            anchor: top,
            inset: inset.top,
            identifier: "\(identifier)_top",
            parentRelated: parentLayout?.top,
            parentSafeEdge: parentLayout?.safeArea.top
        )
        self.bottom = .init(
            context: context,
            anchor: bottom,
            inset: inset.bottom,
            multiplier: .negative,
            identifier: "\(identifier)_bottom",
            parentRelated: parentLayout?.bottom,
            parentSafeEdge: parentLayout?.safeArea.bottom
        )
        self.left = .init(
            context: context,
            anchor: left,
            inset: inset.left,
            identifier: "\(identifier)_left",
            parentRelated: parentLayout?.left,
            parentSafeEdge: parentLayout?.safeArea.left
        )
        self.right = .init(
            context: context,
            anchor: right,
            inset: inset.right,
            multiplier: .negative,
            identifier: "\(identifier)_right",
            parentRelated: parentLayout?.right,
            parentSafeEdge: parentLayout?.safeArea.right
        )
    }
}
