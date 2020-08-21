//
//  CommonModels.swift
//  NamadaLayout
//
//  Created by Nayanda Haberty (ID) on 07/07/20.
//

import Foundation

struct SpaceLayout {
    var space: CGFloat = 0
    var relation: Relation = .exactly
    var priority: UILayoutPriority
}

enum SpaceLayoutMultiplier: CGFloat {
    case negative = -1
    case positive = 1
    
    func multipliy(_ space: CGFloat) -> CGFloat {
        rawValue * space
    }
    
    func real(relation: Relation) -> Relation {
        switch relation  {
        case .greaterThan:
            return self == .positive ? .greaterThan : .lessThan
        case .lessThan:
            return self == .positive ? .lessThan : .greaterThan
        default:
            return relation
        }
    }
}

enum Relation {
    case exactly
    case greaterThan
    case lessThan
}

public extension Array where Element == LayoutPosition {
    static var edges: [LayoutPosition] { [.top, .bottom, .left, .right] }
    static var vertical: [LayoutPosition] { [.top, .bottom] }
    static var horizontal: [LayoutPosition] { [.left, .right] }
    static var topLeft: [LayoutPosition] { [.top, .left] }
    static var topRight: [LayoutPosition] { [.top, .right] }
    static var bottomLeft: [LayoutPosition] { [.bottom, .left] }
    static var bottomRight: [LayoutPosition] { [.bottom, .right] }
    static var fullTop: [LayoutPosition] { [.top, .left, .right] }
    static var fullBottom: [LayoutPosition] { [.bottom, .left, .right] }
    static var fullLeft: [LayoutPosition] { [.left, .top, .bottom] }
    static var fullRight: [LayoutPosition] { [.right, .top, .bottom] }
    static var top: [LayoutPosition] { [.top] }
    static var bottom: [LayoutPosition] { [.bottom] }
    static var left: [LayoutPosition] { [.left] }
    static var right: [LayoutPosition] { [.right] }
}

public enum LayoutPosition {
    case top
    case bottom
    case left
    case right
}

public enum BindingState {
    case mapping
    case applying
    case none
}

public enum LayoutStackedStrategy {
    case emptying
    case append
    case replaceDifferences
}

public struct LayoutError: Error {
    
    private var description: String
    public var localizedDescription: String { description }
    
    public init(description: String) {
        self.description = description
    }
}

public enum CellReloadStrategy {
    case reloadAll
    case reloadLinearDifferences
    case reloadArangementDifferences
}
