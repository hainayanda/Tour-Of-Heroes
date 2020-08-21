//
//  LayoutBuilder+Extension.swift
//  FBSnapshotTestCase
//
//  Created by Nayanda Haberty (ID) on 07/07/20.
//

import Foundation

extension LayoutBuilder {
    func ifHaveParent(do actions: (LayoutBuilderType) -> Void) {
        if let parentLayout = parentLayout {
            actions(parentLayout)
            return
        }
        do {
            if let parentLayout = try context.layoutDelegate.layoutBuilderNeedParent(self) as? LayoutBuilderType {
                actions(parentLayout)
            }
            return
        } catch {
            guard let layoutError: LayoutError = error as? LayoutError else {
                print(error.localizedDescription)
                return
            }
            context.layoutDelegate.layoutBuilder(self, onError: layoutError)
        }
    }
}

public extension AreaLayoutBuilder  {
    
    var constructedConstraints: [NSLayoutConstraint] {
        var thisConstraints: [NSLayoutConstraint] = top.constructedConstraints
        thisConstraints.append(contentsOf: bottom.constructedConstraints)
        thisConstraints.append(contentsOf: left.constructedConstraints)
        thisConstraints.append(contentsOf: right.constructedConstraints)
        return thisConstraints
    }
}

public extension ViewLayoutable {
    
    var constructedConstraints: [NSLayoutConstraint] {
        var thisConstraints: [NSLayoutConstraint] = top.constructedConstraints
        thisConstraints.append(contentsOf: bottom.constructedConstraints)
        thisConstraints.append(contentsOf: left.constructedConstraints)
        thisConstraints.append(contentsOf: right.constructedConstraints)
        thisConstraints.append(contentsOf: center.constructedConstraints)
        thisConstraints.append(contentsOf: width.constructedConstraints)
        thisConstraints.append(contentsOf: height.constructedConstraints)
        thisConstraints.append(contentsOf: safeArea.constructedConstraints)
        for layout in subLayouts {
            thisConstraints.append(contentsOf: layout.constructedConstraints)
        }
        return thisConstraints
    }
}
