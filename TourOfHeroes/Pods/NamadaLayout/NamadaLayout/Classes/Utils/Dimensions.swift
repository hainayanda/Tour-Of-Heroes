//
//  Dimensions.swift
//  NamadaLayout
//
//  Created by Nayanda Haberty (ID) on 28/08/20.
//

import Foundation
import UIKit

//MARK: Insets

public protocol InsetsConvertible {
    var asVerticalInsets: UIVerticalInsets { get }
    var asHorizontalInsets: UIHorizontalInsets { get }
    var asEdgeInsets: UIEdgeInsets { get }
}

extension CGFloat: InsetsConvertible {
    public var asVerticalInsets: UIVerticalInsets {
        .init(insets: self)
    }
    
    public var asHorizontalInsets: UIHorizontalInsets {
        .init(insets: self)
    }
    
    public var asEdgeInsets: UIEdgeInsets {
        .init(insets: self)
    }
}

extension Int: InsetsConvertible {
    public var asVerticalInsets: UIVerticalInsets {
        .init(insets: CGFloat(self))
    }
    
    public var asHorizontalInsets: UIHorizontalInsets {
        .init(insets: CGFloat(self))
    }
    
    public var asEdgeInsets: UIEdgeInsets {
        .init(insets: CGFloat(self))
    }
}

extension Double: InsetsConvertible {
    public var asVerticalInsets: UIVerticalInsets {
        .init(insets: CGFloat(self))
    }
    
    public var asHorizontalInsets: UIHorizontalInsets {
        .init(insets: CGFloat(self))
    }
    
    public var asEdgeInsets: UIEdgeInsets {
        .init(insets: CGFloat(self))
    }
}

public struct UIVerticalInsets: InsetsConvertible {
    public static let zero: UIVerticalInsets = .init(insets: 0)
    public let top: CGFloat
    public let bottom: CGFloat
    public var asEdgeInsets: UIEdgeInsets {
        .init(top: top, left: 0, bottom: bottom, right: 0)
    }
    public var asVerticalInsets: UIVerticalInsets {
        self
    }
    public var asHorizontalInsets: UIHorizontalInsets {
        .zero
    }
    
    public init(top: CGFloat, bottom: CGFloat) {
        self.top = top
        self.bottom = bottom
    }
    
    public init(insets: CGFloat) {
        self.top = insets
        self.bottom = insets
    }
}

public struct UIHorizontalInsets: InsetsConvertible {
    public static let zero: UIHorizontalInsets = .init(insets: 0)
    public let left: CGFloat
    public let right: CGFloat
    public var asEdgeInsets: UIEdgeInsets {
        .init(top: 0, left: left, bottom: 0, right: right)
    }
    public var asVerticalInsets: UIVerticalInsets {
        .zero
    }
    public var asHorizontalInsets: UIHorizontalInsets {
        self
    }
    
    public init(left: CGFloat, right: CGFloat) {
        self.left = left
        self.right = right
    }
    
    public init(insets: CGFloat) {
        self.left = insets
        self.right = insets
    }
}

public struct UIAxisInsets {
    public let xInset: CGFloat
    public let yInset: CGFloat
    public static let zero: UIAxisInsets = .init(insets: 0)
    
    public init(xInset: CGFloat, yInset: CGFloat) {
        self.xInset = xInset
        self.yInset = yInset
    }
    
    public init(insets: CGFloat) {
        self.xInset = insets
        self.yInset = insets
    }
}

public extension UIEdgeInsets {
    var asHorizontalInsets: UIHorizontalInsets { .init(left: left, right: right) }
    var asVerticalInsets: UIVerticalInsets { .init(top: top, bottom: bottom) }
    
    init(horizontalInset: UIHorizontalInsets, verticalInset: UIVerticalInsets) {
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
    
    init(insets: CGFloat) {
        self.init(
            top: insets,
            left: insets,
            bottom: insets,
            right: insets
        )
    }
    
    init(vertical: CGFloat, left: CGFloat = 0, right: CGFloat = 0) {
        self.init(
            top: vertical,
            left: left,
            bottom: vertical,
            right: right
        )
    }
    
    init(horizontal: CGFloat = 0, top: CGFloat = 0, bottom: CGFloat = 0) {
        self.init(
            top: top,
            left: horizontal,
            bottom: bottom,
            right: horizontal
        )
    }
}

extension UIEdgeInsets: InsetsConvertible {
    public var asEdgeInsets: UIEdgeInsets {
        self
    }
}

public struct CoordinateOffsets {
    public var xOffset: CGFloat
    public var yOffset: CGFloat
    
    public init(xOffset: CGFloat = 0, yOffset: CGFloat = 0) {
        self.xOffset = xOffset
        self.yOffset = yOffset
    }
    
}

// MARK: Auto

extension CGFloat {
    public static var automatic: CGFloat { -(.greatestFiniteMagnitude) }
}

extension CGSize {
    public static var automatic: CGSize { .init(width: .automatic, height: .automatic)}
}

public func hInsets(_ insets: CGFloat) -> InsetsConvertible {
    return UIHorizontalInsets(insets: insets)
}

public func vInsets(_ insets: CGFloat) -> InsetsConvertible {
    return UIVerticalInsets(insets: insets)
}

public func hInsets(left: CGFloat, right: CGFloat) -> InsetsConvertible {
    return UIHorizontalInsets(left: left, right: right)
}

public func vInsets(top: CGFloat, bottom: CGFloat) -> InsetsConvertible {
    return UIVerticalInsets(top: top, bottom: bottom)
}
