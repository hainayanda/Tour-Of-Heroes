//
//  AreaLayoutBuilder+Extension.swift
//  NamadaLayout
//
//  Created by Nayanda Haberty (ID) on 15/07/20.
//

import Foundation
import UIKit

public extension AreaLayoutBuilder {
    @discardableResult
    func fillParent(with margin: UIEdgeInsets, priority: UILayoutPriority) -> Self {
        ifHaveParent { parent in
            guard let parent = parent as? ViewLayout else {
                context.layoutDelegate.layoutBuilder(self, onError: .init(description: "Parent is not View Layout"))
                return
            }
            top.distance(to: parent.top, at: margin.top, priority: priority)
            left.distance(to: parent.left, at: margin.left, priority: priority)
            right.distance(to: parent.right, at: margin.right, priority: priority)
            bottom.distance(to: parent.bottom, at: margin.bottom, priority: priority)
        }
        return self
    }
    
    @discardableResult
    func fillParent(with margin: UIEdgeInsets) -> Self {
        return fillParent(with: margin, priority: context.countedPriority)
    }
    
    @discardableResult
    func fillParent(priority: UILayoutPriority) -> Self {
        return fillParent(with: .zero, priority: priority)
    }
    
    @discardableResult
    func fillParent() -> Self {
        return fillParent(with: .zero, priority: context.countedPriority)
    }
    
    @discardableResult
    func fixToParent(_ positions: [LayoutPosition], with margin: UIEdgeInsets, priority: UILayoutPriority) -> Self {
        ifHaveParent { parent in
            guard let parent = parent as? ViewLayout else {
                context.layoutDelegate.layoutBuilder(self, onError: .init(description: "Parent is not View Layout"))
                return
            }
            for position in positions {
                switch position {
                case .top:
                    top.distance(to: parent.top, at: margin.top)
                case .left:
                    left.distance(to: parent.left, at: margin.left)
                case .right:
                    right.distance(to: parent.right, at: margin.right)
                case .bottom:
                    bottom.distance(to: parent.bottom, at: margin.bottom)
                }
            }
        }
        return self
    }
    
    @discardableResult
    func fixToParent(_ positions: [LayoutPosition], priority: UILayoutPriority) -> Self {
        fixToParent(positions, with: .zero, priority: priority)
    }
    
    @discardableResult
    func fixToParent(_ positions: [LayoutPosition], with margin: UIEdgeInsets) -> Self {
        fixToParent(positions, with: margin, priority: context.countedPriority)
    }
    
    @discardableResult
    func fixToParent(_ positions: [LayoutPosition]) -> Self {
        fixToParent(positions, with: .zero, priority: context.countedPriority)
    }
    
    @discardableResult
    func inParent(_ positions: [LayoutPosition], moreThan margin: UIEdgeInsets) -> Self {
        return inParent(positions, moreThan: margin, priority: context.countedPriority)
    }
    
    @discardableResult
    func inParent(_ positions: [LayoutPosition], moreThan margin: UIEdgeInsets, priority: UILayoutPriority) -> Self {
        ifHaveParent { parent in
            guard let parent = parent as? ViewLayout else {
                context.layoutDelegate.layoutBuilder(self, onError: .init(description: "Parent is not View Layout"))
                return
            }
            for position in positions {
                switch position {
                case .top:
                    top.distance(to: parent.top, moreThan: margin.top)
                case .left:
                    left.distance(to: parent.left, moreThan: margin.left)
                case .right:
                    right.distance(to: parent.right, moreThan: margin.right)
                case .bottom:
                    bottom.distance(to: parent.bottom, moreThan: margin.bottom)
                }
            }
        }
        return self
    }
    
    @discardableResult
    func inParent(_ positions: [LayoutPosition], lessThan margin: UIEdgeInsets) -> Self {
        return inParent(positions, lessThan: margin, priority: context.countedPriority)
    }
    
    @discardableResult
    func inParent(_ positions: [LayoutPosition], lessThan margin: UIEdgeInsets, priority: UILayoutPriority) -> Self {
        ifHaveParent { parent in
            guard let parent = parent as? ViewLayout else {
                context.layoutDelegate.layoutBuilder(self, onError: .init(description: "Parent is not View Layout"))
                return
            }
            for position in positions {
                switch position {
                case .top:
                    top.distance(to: parent.top, lessThan: margin.top)
                case .left:
                    left.distance(to: parent.left, lessThan: margin.left)
                case .right:
                    right.distance(to: parent.right, lessThan: margin.right)
                case .bottom:
                    bottom.distance(to: parent.bottom, lessThan: margin.bottom)
                }
            }
        }
        return self
    }
}
