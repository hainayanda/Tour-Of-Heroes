//
//  Enumeration+Extensions.swift
//  NamadaLayout
//
//  Created by Nayanda Haberty (ID) on 28/08/20.
//

import Foundation
import UIKit

public extension LayoutRelation where Related == InsetsConvertible {
    
    var asTopRelation: LayoutRelation<CGFloat> {
        switch self {
        case .equal:
            return .equal
        case .moreThan:
            return .moreThan
        case .lessThan:
            return .lessThan
        case .equalTo(let insets):
            return .equalTo(insets.vertical.top)
        case .moreThanTo(let insets):
            return .moreThanTo(insets.vertical.top)
        case .lessThanTo(let insets):
            return .lessThanTo(insets.vertical.top)
        }
    }
    
    var asBottomRelation: LayoutRelation<CGFloat> {
        switch self {
        case .equal:
            return .equal
        case .moreThan:
            return .moreThan
        case .lessThan:
            return .lessThan
        case .equalTo(let insets):
            return .equalTo(insets.vertical.bottom)
        case .moreThanTo(let insets):
            return .moreThanTo(insets.vertical.bottom)
        case .lessThanTo(let insets):
            return .lessThanTo(insets.vertical.bottom)
        }
    }
    
    var asLeftRelation: LayoutRelation<CGFloat> {
        switch self {
        case .equal:
            return .equal
        case .moreThan:
            return .moreThan
        case .lessThan:
            return .lessThan
        case .equalTo(let insets):
            return .equalTo(insets.horizontal.left)
        case .moreThanTo(let insets):
            return .moreThanTo(insets.horizontal.left)
        case .lessThanTo(let insets):
            return .lessThanTo(insets.horizontal.left)
        }
    }
    
    var asRightRelation: LayoutRelation<CGFloat> {
        switch self {
        case .equal:
            return .equal
        case .moreThan:
            return .moreThan
        case .lessThan:
            return .lessThan
        case .equalTo(let insets):
            return .equalTo(insets.horizontal.right)
        case .moreThanTo(let insets):
            return .moreThanTo(insets.horizontal.right)
        case .lessThanTo(let insets):
            return .lessThanTo(insets.horizontal.right)
        }
    }
}

public extension LayoutRelation where Related == CoordinateOffsets {
    var asXRelation: LayoutRelation<CGFloat> {
        switch self {
        case .equal:
            return .equal
        case .moreThan:
            return .moreThan
        case .lessThan:
            return .lessThan
        case .equalTo(let offsets):
            return .equalTo(offsets.xOffset)
        case .moreThanTo(let offsets):
            return .moreThanTo(offsets.xOffset)
        case .lessThanTo(let offsets):
            return .lessThanTo(offsets.xOffset)
        }
    }
    
    var asYRelation: LayoutRelation<CGFloat> {
        switch self {
        case .equal:
            return .equal
        case .moreThan:
            return .moreThan
        case .lessThan:
            return .lessThan
        case .equalTo(let offsets):
            return .equalTo(offsets.yOffset)
        case .moreThanTo(let offsets):
            return .moreThanTo(offsets.yOffset)
        case .lessThanTo(let offsets):
            return .lessThanTo(offsets.yOffset)
        }
    }
}

public extension LayoutRelation where Related == CGFloat {
    var distance: CGFloat {
        switch self {
        case .moreThanTo(let distance), .lessThanTo(let distance), .equalTo(let distance):
            return distance
        case .moreThan, .lessThan, .equal:
            return 0
        }
    }
}

public extension InterRelation where Related == CGSize {
    var asHeightRelation: InterRelation<CGFloat> {
        switch self {
        case .equalTo(let size):
            return .equalTo(size.height)
        case .moreThanTo(let size):
            return .moreThanTo(size.height)
        case .lessThanTo(let size):
            return .lessThanTo(size.height)
        }
    }
    var asWidthRelation: InterRelation<CGFloat> {
        switch self {
        case .equalTo(let size):
            return .equalTo(size.width)
        case .moreThanTo(let size):
            return .moreThanTo(size.width)
        case .lessThanTo(let size):
            return .lessThanTo(size.width)
        }
    }
}

public extension InterRelation where Related == UIView {
    var asHeightRelation: InterRelation<NSLayoutDimension> {
        switch self {
        case .equalTo(let view):
            return .equalTo(view.heightAnchor)
        case .moreThanTo(let view):
            return .moreThanTo(view.heightAnchor)
        case .lessThanTo(let view):
            return .lessThanTo(view.heightAnchor)
        }
    }
    var asWidthRelation: InterRelation<NSLayoutDimension> {
        switch self {
        case .equalTo(let view):
            return .equalTo(view.widthAnchor)
        case .moreThanTo(let view):
            return .moreThanTo(view.widthAnchor)
        case .lessThanTo(let view):
            return .lessThanTo(view.widthAnchor)
        }
    }
}

public extension NamadaRelatedPosition {
    var position: NamadaLayoutPosition {
        switch self {
        case .topOf(_), .topOfAndParallelWith(_):
            return .top
        case .bottomOf(_), .bottomOfAndParallelWith(_):
            return .bottom
        case .leftOf(_), .leftOfAndParallelWith(_):
            return .left
        case .rightOf(_), .rightOfAndParallelWith(_):
            return .right
        }
    }
    var shouldParallel: Bool {
        switch self {
        case .topOfAndParallelWith(_), .bottomOfAndParallelWith(_), .leftOfAndParallelWith(_), .rightOfAndParallelWith(_):
            return true
        default:
            return false
        }
    }
    var view: UIView {
        switch self {
        case .topOf(let view), .topOfAndParallelWith(let view),
             .bottomOf(let view), .bottomOfAndParallelWith(let view),
             .leftOf(let view), .leftOfAndParallelWith(let view),
             .rightOf(let view), .rightOfAndParallelWith(let view):
            return view
        }
    }
}

extension NSLayoutConstraint.Attribute {
    var asString: String {
        switch self {
        case .left:
            return "left"
        case .right:
            return "right"
        case .top:
            return "top"
        case .bottom:
            return "bottom"
        case .leading:
            return "leading"
        case .trailing:
            return "trailing"
        case .width:
            return "width"
        case .height:
            return "height"
        case .centerX:
            return "centerX"
        case .centerY:
            return "centerY"
        case .lastBaseline:
            return "lastBaseline"
        case .firstBaseline:
            return "firstBaseline"
        case .leftMargin:
            return "leftMargin"
        case .rightMargin:
            return "rightMargin"
        case .topMargin:
            return "topMargin"
        case .bottomMargin:
            return "bottomMargin"
        case .leadingMargin:
            return "leadingMargin"
        case .trailingMargin:
            return "trailingMargin"
        case .centerXWithinMargins:
            return "centerXWithinMargins"
        case .centerYWithinMargins:
            return "centerYWithinMargins"
        case .notAnAttribute:
            return "notAnAttribute"
        @unknown default:
            return "default"
        }
    }
}
