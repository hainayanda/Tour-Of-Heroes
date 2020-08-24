//
//  Extras.swift
//  NamadaLayout
//
//  Created by Nayanda Haberty (ID) on 04/07/20.
//

import Foundation
import UIKit

//MARK: Insets

public struct UIVerticalInset {
    public static let zero: UIVerticalInset = .init(inset: 0)
    public let top: CGFloat
    public let bottom: CGFloat
    public var asEdgeInset: UIEdgeInsets {
        .init(top: top, left: 0, bottom: bottom, right: 0)
    }
    
    public init(top: CGFloat, bottom: CGFloat) {
        self.top = top
        self.bottom = bottom
    }
    
    public init(inset: CGFloat) {
        self.top = inset
        self.bottom = inset
    }
}

public struct UIHorizontalInset {
    public static let zero: UIHorizontalInset = .init(inset: 0)
    public let left: CGFloat
    public let right: CGFloat
    public var asEdgeInset: UIEdgeInsets {
        .init(top: 0, left: left, bottom: 0, right: right)
    }
    
    public init(left: CGFloat, right: CGFloat) {
        self.left = left
        self.right = right
    }
    
    public init(inset: CGFloat) {
        self.left = inset
        self.right = inset
    }
}

public struct UIAxisInset {
    public let xInset: CGFloat
    public let yInset: CGFloat
    public static let zero: UIAxisInset = .init(inset: 0)
    
    public init(xInset: CGFloat, yInset: CGFloat) {
        self.xInset = xInset
        self.yInset = yInset
    }
    
    public init(inset: CGFloat) {
        self.xInset = inset
        self.yInset = inset
    }
}

public extension UIEdgeInsets {
    var asHorizontalInset: UIHorizontalInset { .init(left: left, right: right) }
    var asVerticalInset: UIVerticalInset { .init(top: top, bottom: bottom) }
    
    init(horizontalInset: UIHorizontalInset, verticalInset: UIVerticalInset) {
        self.init(
            top: verticalInset.top,
            left: horizontalInset.left,
            bottom: verticalInset.bottom,
            right: horizontalInset.right
        )
    }
    
    init(vertical: CGFloat, horizontal: CGFloat) {
        self.init(
            top: vertical,
            left: horizontal,
            bottom: vertical,
            right: horizontal
        )
    }
    
    init(inset: CGFloat) {
        self.init(
            top: inset,
            left: inset,
            bottom: inset,
            right: inset
        )
    }
    
    init(vertical: CGFloat = 0, left: CGFloat, right: CGFloat) {
        self.init(
            top: vertical,
            left: left,
            bottom: vertical,
            right: right
        )
    }
    
    init(horizontal: CGFloat = 0, top: CGFloat, bottom: CGFloat) {
        self.init(
            top: top,
            left: horizontal,
            bottom: bottom,
            right: horizontal
        )
    }
}

// MARK: Auto

extension CGFloat {
    public static var automatic: CGFloat { -(.greatestFiniteMagnitude) }
}

extension CGSize {
    public static var automatic: CGSize { .init(width: .automatic, height: .automatic)}
}
